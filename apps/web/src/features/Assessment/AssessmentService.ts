import { supabase } from '../../services/supabaseClient';
import { Assessment } from '../../types';
import { PdiDocumentService } from '../../services/pdi/PdiDocumentService';
import { isGovernedCreditConsumerEnabled } from '../../services/credits/creditConsumerFlags';

// A-2: Key MUST include userId to prevent data leakage between accounts
const getAssessmentKey = (userId: string) => `profeplan_assessments:${userId}`;

type GovernedSaveResult = {
  saved?: boolean;
  outcome?: string;
  charged?: boolean;
  reason?: string;
  artifact_id?: string;
};

const persistAssessmentLocally = (userId: string, assessment: Assessment) => {
  const saved = JSON.parse(localStorage.getItem(getAssessmentKey(userId)) || '[]');
  const assessments = Array.isArray(saved) ? (saved as Assessment[]) : [];
  const filtered = assessments.filter((candidate) => candidate.id !== assessment.id);

  filtered.push(assessment);
  localStorage.setItem(getAssessmentKey(userId), JSON.stringify(filtered));
};

/**
 * [LOCAL-FIRST / GOVERNED CUTOVER]
 *
 * Flag OFF preserves the legacy local-first + background direct-table flow.
 * Flag ON makes generated_contents canonical through credit_save_generated_content.
 * The existing assessment.id is the economic artifact identity; it is never
 * replaced by a second client-generated identifier.
 */
export const saveAssessment = async (userId: string, assessment: Assessment) => {
  const governed = isGovernedCreditConsumerEnabled();

  if (!governed) {
    // Legacy behavior: local persistence confirms immediately and cloud sync is
    // fire-and-forget. This branch intentionally remains unchanged until 4E.
    try {
      persistAssessmentLocally(userId, assessment);
      console.log('✅ Avaliação salva localmente.');
    } catch (e) {
      console.error('Erro crítico ao salvar no LocalStorage:', e);
      throw new Error('Não foi possível salvar a avaliação no dispositivo.');
    }

    syncAssessmentToCloudLegacy(userId, assessment).catch((err) => {
      console.warn('⚠️ Falha no Sync Background (será tentado novamente depois):', err);
    });

    return true;
  }

  // Governed behavior: do not confirm the Save locally before the canonical RPC
  // confirms it. RPC failure/insufficiency therefore cannot masquerade as a
  // successful economic Save. Retrying the same Assessment preserves its id.
  await syncAssessmentToCloudGoverned(userId, assessment);

  try {
    persistAssessmentLocally(userId, assessment);
    console.log('✅ Avaliação governada salva e cache local atualizado.');
  } catch (error) {
    // generated_contents is authoritative after a successful governed RPC.
    // A cache failure must not turn a committed Save into a new economic event.
    console.warn('Falha ao atualizar cache local após Save canônico:', error);
  }

  return true;
};

/**
 * Legacy synchronization kept exclusively for VITE_GOVERNED_CREDIT_CONSUMERS=OFF.
 */
const syncAssessmentToCloudLegacy = async (userId: string, assessment: Assessment) => {
  const markdown = assessmentToMarkdown(assessment);

  const { error: contentError } = await supabase.from('generated_contents').insert({
    user_id: userId,
    type: 'avaliacao',
    folder: 'AVALIAÇÕES',
    title: assessment.title,
    content: markdown,
  });

  if (contentError) throw contentError;

  await persistAuxiliaryAssessmentMemory(userId, assessment, markdown);
  console.log('☁️ Avaliação sincronizada com a nuvem!');
};

/**
 * Governed synchronization for 1.3C.4B.
 *
 * The browser supplies artifact identity and pedagogical payload only. The RPC
 * derives SAVE_ASSESSMENT and all economic values server-side.
 */
const syncAssessmentToCloudGoverned = async (userId: string, assessment: Assessment) => {
  const markdown = assessmentToMarkdown(assessment);

  const { data, error } = await supabase.rpc('credit_save_generated_content', {
    p_artifact_id: assessment.id,
    p_type: 'avaliacao',
    p_folder: 'AVALIAÇÕES',
    p_title: assessment.title,
    p_content: markdown,
    p_created_at: assessment.createdAt,
  });

  if (error) throw error;

  const result = data as GovernedSaveResult | null;
  if (!result?.saved) {
    if (result?.reason === 'INSUFFICIENT_CREDITS') {
      throw new Error('Créditos insuficientes para salvar esta avaliação.');
    }
    throw new Error(result?.reason || 'Não foi possível salvar a avaliação.');
  }

  // The canonical artifact and its economic receipt are already committed here.
  // Everything below is auxiliary and must never change the economic outcome.
  await persistAuxiliaryAssessmentMemory(userId, assessment, markdown);
  console.log('☁️ Avaliação governada sincronizada com a nuvem!');
};

/**
 * lessons and automatic PDI logging are contextual memory only. They are
 * deliberately best-effort so an auxiliary failure cannot cause a second
 * charge or reinterpret a committed generated_contents Save as failed.
 */
const persistAuxiliaryAssessmentMemory = async (
  userId: string,
  assessment: Assessment,
  markdown: string
) => {
  try {
    const { error: lessonError } = await supabase.from('lessons').insert({
      user_id: userId,
      topic: `AVALIAÇÃO: ${assessment.title}`,
      content: markdown,
      class_id: assessment.classId,
    });

    if (lessonError) console.warn('Erro ao salvar memória da avaliação:', lessonError);
  } catch (error) {
    console.warn('Erro ao salvar memória auxiliar da avaliação:', error);
  }

  if (assessment.classId) {
    try {
      await PdiDocumentService.logEventForClass(
        assessment.classId,
        'EVALUATION',
        `Avaliação: ${assessment.title}`,
        {
          subject: assessment.subject,
          points: assessment.totalPoints,
          period: assessment.academicPeriod,
        },
        'Bloco X'
      );
    } catch (error) {
      console.warn('Erro ao logar PDI automático:', error);
    }
  }
};

/**
 * Busca avaliações (Prioridade Local > Nuvem)
 */
export const getAssessments = async (userId: string): Promise<Assessment[]> => {
  // 1. Tenta Local
  const localData = localStorage.getItem(getAssessmentKey(userId));
  if (localData) {
    try {
      return JSON.parse(localData);
    } catch {
      return [];
    }
  }

  // 2. Se não tiver local, tenta buscar do Supabase (generated_contents)
  return [];
};

// Helper: Converte JSON Assessment para Markdown (para salvar no banco legado)
const assessmentToMarkdown = (assessment: Assessment): string => {
  let md = `# ${assessment.title}\n\n`;
  md += `**Disciplina:** ${assessment.subject}\n`;
  md += `**Turma:** ${assessment.className}\n`;
  md += `**Período:** ${assessment.academicPeriod}\n`;
  md += `**Valor Total:** ${assessment.totalPoints} pts\n\n`;
  md += `---\n\n`;

  assessment.questions.forEach((q, i) => {
    md += `### Questão ${i + 1} (${q.type === 'objective' ? 'Objetiva' : 'Dissertativa'}) - ${q.maxPoints} pts\n`;
    md += `${q.question}\n\n`;
    if (q.type === 'objective' && q.options) {
      q.options.forEach((opt) => {
        md += `- ${opt}\n`;
      });
      md += `\n**Gabarito:** ${q.correctAnswer}\n\n`;
    } else if (q.type === 'dissertative' && q.rubric) {
      md += `**Critérios de Correção (Rubrica):**\n${q.rubric}\n\n`;
    }
    md += `---\n\n`;
  });

  return md;
};
