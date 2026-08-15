import { supabase } from '../../services/supabaseClient';
import { checkUsageQuota, incrementUserUsage } from '../../services/ProfileService';
import type { UserProfile } from '../../types';
import { PdiDocumentService } from '../../services/pdi/PdiDocumentService';
import { isGovernedCreditConsumerEnabled } from '../../services/credits/creditConsumerFlags';

// --- FOLDER STRUCTURE ENUM ---
export enum PlanFolder {
  TRIMESTRAIS = 'TRIMESTRAIS',
  PLANO_AULA = 'PLANOS DE AULA',
  MATERIAL_ALUNO = 'MATERIAIS ALUNOS',
  ATIVIDADES = 'ATIVIDADES',
  SIMULADOS = 'SIMULADOS',
  AVALIACOES = 'AVALIAÇÕES',
  APRESENTACOES = 'APRESENTAÇÕES',
  OUTROS = 'OUTROS',
}

const getHistoryKey = (userId: string) => `profeplan_history_buffer:${userId}`;

export interface GeneratedPlan {
  id: string;
  type:
    | 'plano'
    | 'material'
    | 'exercicio'
    | 'simulado'
    | 'avaliacao'
    | 'apresentacao'
    | 'trimestral'
    | 'documento'
    | 'outros'
    | 'aula'
    | 'enem';
  folder: PlanFolder;
  title: string;
  content: string;
  createdAt: string;
  synced: boolean;
  classId?: string;
}

type GovernedSaveResult = {
  saved?: boolean;
  outcome?: string;
  charged?: boolean;
  reason?: string;
  artifact_id?: string;
};

const readLocalHistory = (userId: string): GeneratedPlan[] => {
  try {
    const parsed = JSON.parse(localStorage.getItem(getHistoryKey(userId)) || '[]');
    return Array.isArray(parsed) ? (parsed as GeneratedPlan[]) : [];
  } catch {
    return [];
  }
};

const createGovernedArtifactId = (): string => {
  if (typeof globalThis.crypto?.randomUUID === 'function') {
    return globalThis.crypto.randomUUID();
  }
  return `artifact_${Date.now()}_${Math.random().toString(36).slice(2)}`;
};

const findExactUnsyncedDraft = (
  userId: string,
  plan: Omit<GeneratedPlan, 'synced' | 'id' | 'folder'>,
  targetFolder: PlanFolder
): GeneratedPlan | undefined =>
  readLocalHistory(userId)
    .slice()
    .reverse()
    .find(
      (saved) =>
        saved.synced === false &&
        saved.type === plan.type &&
        saved.folder === targetFolder &&
        saved.title === plan.title &&
        saved.content === plan.content &&
        (saved.classId || null) === (plan.classId || null)
    );

const persistLocalDraft = (userId: string, plan: GeneratedPlan) => {
  const saved = readLocalHistory(userId);
  const existingIndex = saved.findIndex((candidate) => candidate.id === plan.id);

  if (existingIndex >= 0) {
    saved[existingIndex] = plan;
  } else {
    saved.push(plan);
  }

  localStorage.setItem(getHistoryKey(userId), JSON.stringify(saved));
};

/**
 * [LOCAL-FIRST]
 * Saves a local draft before attempting canonical persistence.
 *
 * Flag OFF preserves the legacy quota + direct-table + increment flow.
 * Flag ON uses the governed first-save boundary. An exact unsynced local draft
 * is reused after timeout/failure so the retry keeps the same artifact_id.
 */
export const savePlan = async (
  userId: string,
  plan: Omit<GeneratedPlan, 'synced' | 'id' | 'folder'>,
  targetFolder: PlanFolder,
  preloadedProfile?: UserProfile | null
) => {
  const governed = isGovernedCreditConsumerEnabled();

  if (governed && plan.type === 'trimestral') {
    throw new Error('Planejamento trimestral usa a fronteira governada dedicada.');
  }

  if (!governed) {
    const quota = await checkUsageQuota(userId, preloadedProfile);
    if (!quota.allowed) {
      throw new Error(quota.message || 'Saldo insuficiente.');
    }
  }

  const retryDraft = governed ? findExactUnsyncedDraft(userId, plan, targetFolder) : undefined;
  const newPlan: GeneratedPlan = retryDraft
    ? {
        ...retryDraft,
        ...plan,
        folder: targetFolder,
        synced: false,
      }
    : {
        ...plan,
        folder: targetFolder,
        id: governed ? createGovernedArtifactId() : `local_${Date.now()}`,
        synced: false,
        createdAt: new Date().toISOString(),
      };

  try {
    persistLocalDraft(userId, newPlan);
    console.log('✅ Plano salvo localmente.');
  } catch (error) {
    console.error('Erro ao salvar plano localmente:', error);
  }

  await syncPlanToCloud(userId, newPlan);
  return { ...newPlan, synced: true };
};

const syncPlanToCloud = async (userId: string, plan: GeneratedPlan) => {
  const governed = isGovernedCreditConsumerEnabled();

  if (governed) {
    const { data, error } = await supabase.rpc('credit_save_generated_content', {
      p_artifact_id: plan.id,
      p_type: plan.type,
      p_folder: plan.folder,
      p_title: plan.title,
      p_content: plan.content,
      p_created_at: plan.createdAt,
    });

    if (error) throw error;

    const result = data as GovernedSaveResult | null;
    if (!result?.saved) {
      if (result?.reason === 'INSUFFICIENT_CREDITS') {
        throw new Error('Créditos insuficientes para salvar este documento.');
      }
      throw new Error(result?.reason || 'Não foi possível salvar o documento.');
    }
  } else {
    const { error: contentError } = await supabase.from('generated_contents').insert({
      user_id: userId,
      type: plan.type,
      folder: plan.folder,
      title: plan.title,
      content: plan.content,
      created_at: plan.createdAt,
    });

    if (contentError) throw contentError;

    await incrementUserUsage(userId, 'document');
    console.log('💰 Crédito debitado por salvamento de documento.');
  }

  // generated_contents is canonical. Lesson/PDI memory remains auxiliary and
  // best-effort exactly as before; an auxiliary failure must not reverse a
  // canonical save that already committed.
  if (['plano', 'aula'].includes(plan.type)) {
    const { error: lessonError } = await supabase.from('lessons').insert({
      user_id: userId,
      topic: plan.title,
      content: plan.content,
      class_id: plan.classId || null,
    });

    if (lessonError) console.warn('Erro ao salvar memória da aula:', lessonError);

    if (plan.classId) {
      PdiDocumentService.logEventForClass(
        plan.classId,
        'LESSON_PLAN',
        `Planejamento: ${plan.title}`,
        {
          type: plan.type,
          folder: plan.folder,
          summary: 'Aula planejada e adaptada via ProfePlan.',
        },
        'Bloco VIII'
      ).catch((err) => console.warn('Erro ao logar PDI automático:', err));
    }
  }

  try {
    const saved = readLocalHistory(userId);
    const updated = saved.map((candidate) =>
      candidate.id === plan.id ? { ...candidate, synced: true } : candidate
    );
    localStorage.setItem(getHistoryKey(userId), JSON.stringify(updated));
  } catch {
    // A canonical cloud save is authoritative even if local cache update fails.
  }

  console.log('☁️ Plano sincronizado!');
};
