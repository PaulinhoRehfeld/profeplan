import { supabase } from '../../services/supabaseClient';
import { isGovernedTermPlanSavePilotEnabled } from '../../services/credits/creditPilotFlags';
import { TermPlan } from '../../types';

const LOCAL_STORAGE_KEY = 'profeplan_term_plans';
const GOVERNED_DRAFT_STORAGE_KEY = 'profeplan_term_plan_governed_draft';

const getStorageKey = (userId: string) => `${LOCAL_STORAGE_KEY}:${userId}`;
const getGovernedDraftStorageKey = (userId: string, planId: string) =>
  `${GOVERNED_DRAFT_STORAGE_KEY}:${userId}:${planId}`;

const readLocalPlans = (userId: string): TermPlan[] => {
  try {
    return JSON.parse(localStorage.getItem(getStorageKey(userId)) || '[]');
  } catch {
    return [];
  }
};

const writeLocalPlans = (userId: string, plans: TermPlan[]) => {
  localStorage.setItem(getStorageKey(userId), JSON.stringify(plans));
};

const cacheSavedPlan = (plan: TermPlan, userId: string): TermPlan => {
  const planWithMeta: TermPlan = {
    ...plan,
    userId,
  };
  const existingPlans = readLocalPlans(userId);
  const planIndex = existingPlans.findIndex((p: TermPlan) => p.id === planWithMeta.id);

  if (planIndex >= 0) {
    existingPlans[planIndex] = planWithMeta;
  } else {
    existingPlans.push(planWithMeta);
  }

  writeLocalPlans(userId, existingPlans);
  return planWithMeta;
};

type GovernedTermPlanSaveResponse = {
  saved?: boolean;
  outcome?: string;
  reason?: string;
  original_reason?: string;
  replay?: boolean;
  charged?: boolean;
  balance_after?: number;
  operation_id?: string;
  plan_id?: string;
};

const saveTermPlanGoverned = async (plan: TermPlan, userId: string): Promise<TermPlan> => {
  const planWithMeta: TermPlan = { ...plan, userId };
  const draftKey = getGovernedDraftStorageKey(userId, plan.id);

  // Work preservation is separate from the canonical saved-plan cache. A
  // rejected/failed RPC keeps the generated material available after reload,
  // but it is not presented as a successfully persisted plan.
  localStorage.setItem(draftKey, JSON.stringify(planWithMeta));

  const title = plan.title || `Planejamento ${plan.period}º ${plan.regime} - ${plan.subject}`;
  const { data, error } = await supabase.rpc('credit_save_term_plan', {
    p_plan_id: plan.id,
    p_title: title,
    p_period: plan.period,
    p_regime: plan.regime,
    p_subject: plan.subject,
    p_grade: plan.grade,
    p_level: plan.level || 'Ensino Médio',
    p_workload_weekly: plan.workloadWeekly,
    p_reserves: plan.reserves,
    p_total_classes: plan.totalClasses,
    p_grading_grid: plan.gradingGrid,
    p_state_base: plan.stateBase,
    p_education_sphere: plan.educationSphere,
    p_generated_text: plan.generatedText || '',
    p_lessons: plan.lessons || [],
  });

  if (error) {
    throw new Error(`Falha ao salvar o planejamento de forma segura: ${error.message}`);
  }

  const receipt = (data || {}) as GovernedTermPlanSaveResponse;
  if (receipt.saved !== true) {
    if (receipt.reason === 'INSUFFICIENT_CREDITS' || receipt.original_reason === 'INSUFFICIENT_CREDITS') {
      throw new Error(
        `Créditos insuficientes para salvar este planejamento. Seu trabalho foi preservado como rascunho local.`
      );
    }

    throw new Error(
      `O planejamento não foi persistido pelo comando governado (${receipt.reason || receipt.outcome || 'decisão desconhecida'}). Seu trabalho foi preservado como rascunho local.`
    );
  }

  const saved = cacheSavedPlan(planWithMeta, userId);
  localStorage.removeItem(draftKey);
  return saved;
};

const saveTermPlanLegacy = async (plan: TermPlan, userId: string): Promise<TermPlan> => {
  // 1. Save to localStorage (offline-first)
  const planWithMeta = cacheSavedPlan(plan, userId);

  // 2. Sync to Supabase (term_plans table)
  if (supabase) {
    try {
      const payload = {
        id: plan.id,
        user_id: userId,
        title: plan.title || `Planejamento ${plan.period}º ${plan.regime} - ${plan.subject}`,
        generated_text: plan.generatedText || '',
        subject: plan.subject,
        grade: plan.grade,
        period: plan.period,
        regime: plan.regime,
        level: plan.level || 'Ensino Médio',
        workload_weekly: plan.workloadWeekly,
        reserves: plan.reserves,
        total_classes: plan.totalClasses,
        grading_grid: plan.gradingGrid,
        state_base: plan.stateBase,
        education_sphere: plan.educationSphere,
        lessons: plan.lessons || [],
        updated_at: new Date().toISOString(),
      };

      const { data, error } = await supabase.from('term_plans').upsert(payload).select().single();

      if (error) {
        console.error('Supabase save error:', error);
      } else {
        console.log('✅ Saved to Supabase:', data);
      }
    } catch (err) {
      console.error('Failed to sync to Supabase', err);
    }
  }

  return planWithMeta;
};

/**
 * Salva um plano trimestral.
 *
 * O caminho 1.3B.3 permanece desligado por padrão. Quando ativado após o
 * cutover de banco, planos com conteúdo gerado usam um único RPC atômico para
 * persistência + decisão econômica. Planos sem conteúdo gerado continuam no
 * caminho legado/configuracional e não entram no piloto billable.
 */
export const saveTermPlan = async (plan: TermPlan, userId: string): Promise<TermPlan> => {
  if (isGovernedTermPlanSavePilotEnabled() && (plan.generatedText || '').trim() !== '') {
    return saveTermPlanGoverned(plan, userId);
  }

  return saveTermPlanLegacy(plan, userId);
};

/**
 * Busca os planejamentos (✅ FONTE ÚNICA: term_plans)
 */
export const fetchTermPlans = async (userId: string): Promise<TermPlan[]> => {
  try {
    if (!supabase) {
      console.error('[CRITICAL] Supabase client not initialized in TermPlanningService');
      return [];
    }

    let plans: TermPlan[] = [];
    console.log(`[DEBUG] fetchTermPlans called for userId: ${userId}`);

    try {
      // ✅ FONTE ÚNICA: term_plans (dados estruturados e migrados)
      const { data: structuredData, error: structuredError } = await supabase
        .from('term_plans')
        .select('*')
        .eq('user_id', userId)
        .order('updated_at', { ascending: false });

      if (structuredError) {
        console.error('[DEBUG] Structured Fetch Error:', structuredError);
      } else {
        console.log(`[DEBUG] Structured Plans Found: ${structuredData?.length || 0}`);
      }

      if (!structuredError && structuredData) {
        plans = structuredData.map(
          (d: any) =>
            ({
              id: d.id,
              period: d.period,
              regime: d.regime,
              subject: d.subject,
              grade: d.grade,
              level: d.level,
              workloadWeekly: d.workload_weekly,
              reserves: d.reserves,
              totalClasses: d.total_classes,
              gradingGrid: d.grading_grid,
              stateBase: d.state_base,
              educationSphere: d.education_sphere,
              generatedText: d.generated_text || d.content || '',
              lessons: d.lessons || [],
              created_at: d.created_at || d.updated_at,
            }) as TermPlan
        );
      }
    } catch (e) {
      console.warn('Supabase fetch failed, trying local', e);
    }

    // Fallback: Planos salvos como documentos em generated_contents
    try {
      const { data: genericData, error: genericError } = await supabase
        .from('generated_contents')
        .select('*')
        .eq('user_id', userId)
        .eq('type', 'trimestral')
        .order('created_at', { ascending: false });

      if (genericError) {
        console.error('[DEBUG] Generic Fetch Error:', genericError);
      } else if (genericData && genericData.length > 0) {
        const toKey = (p: { subject: string; grade: string; period: number; regime: string }) =>
          `${p.subject}`.toLowerCase().trim() +
          `|${p.grade}`.toLowerCase().trim() +
          `|${p.period}` +
          `|${p.regime}`.toLowerCase().trim();

        const existingKeys = new Set(
          plans.map((p) =>
            toKey({
              subject: p.subject,
              grade: p.grade,
              period: p.period,
              regime: p.regime,
            })
          )
        );

        const fallbackPlans = genericData
          .map((item: any) => {
            const meta = parseTitleMetadata(item.title || '', item.content || '');
            return {
              id: item.id,
              subject: meta.subject,
              grade: meta.grade,
              period: meta.period,
              regime: meta.regime as TermPlan['regime'],
              level: 'Ensino Médio',
              workloadWeekly: 2,
              reserves: { monthlyExam: false, termExam: false, recovery: false },
              totalClasses: 0,
              gradingGrid: { vistos: 0, trabalhos: 0, monthlyExam: 0, termExam: 0, others: 0 },
              stateBase: 'Geral',
              educationSphere: 'Geral',
              generatedText: item.content || '',
              created_at: item.created_at,
            } as TermPlan;
          })
          .filter(
            (plan) =>
              !existingKeys.has(
                toKey({
                  subject: plan.subject,
                  grade: plan.grade,
                  period: plan.period,
                  regime: plan.regime,
                })
              )
          );

        plans = [...plans, ...fallbackPlans];
      }
    } catch (e) {
      console.warn('Generic fetch failed', e);
    }

    // Fallback: Mescla com LocalStorage se Supabase falhar
    try {
      const localData = readLocalPlans(userId);
      console.log(`[DEBUG] LocalStorage Plans Found: ${localData.length}`);
      if (plans.length === 0) {
        plans = localData;
      }
    } catch (e) {
      console.error('Local fetch failed', e);
    }

    console.log(`[DEBUG] Total merged plans returned: ${plans.length}`);
    return plans;
  } catch (criticalError) {
    console.error('[CRITICAL] Unhandled error in fetchTermPlans:', criticalError);
    return [];
  }
};

// --- Helpers ---
const parseTitleMetadata = (title: string, content: string) => {
  // Expected Format: "Planejamento 2º Bimestre - Geografia" or "2º Trimestre - História"
  let subject = 'Geral';
  let period = 1;
  let regime = 'Trimestre';
  let grade = 'Geral';

  // 1. Try to extract Subject (everything after " - ")
  if (title.includes(' - ')) {
    const parts = title.split(' - ');
    if (parts.length > 1) {
      subject = parts[parts.length - 1]
        .trim()
        .replace(/\(\d+\)$/, '')
        .trim(); // Remove suffix like (2)
    }
  } else {
    subject = title;
  }

  // 2. Try to extract Period (Number)
  const periodMatch = title.match(/(\d+)º/);
  if (periodMatch) {
    period = parseInt(periodMatch[1]);
  }

  // 3. Try to extract Regime
  if (title.toLowerCase().includes('bimestre')) regime = 'Bimestre';
  if (title.toLowerCase().includes('trimestre')) regime = 'Trimestre';

  // 4. Try to extract Grade/Class from content if possible
  // (Simple heuristic looking for "Turma:" or "Série:")
  const gradeMatch = content.match(/(Turma|Série):\s*(.*?)\n/i);
  if (gradeMatch) {
    grade = gradeMatch[2].trim();
  }

  return { subject, period, regime, grade };
};

/**
 * Deleta um plano trimestral (Local + Supabase)
 */
export const deleteTermPlan = async (planId: string, userId: string): Promise<void> => {
  // 1. Delete from localStorage
  const existingPlans = readLocalPlans(userId);
  const filteredPlans = existingPlans.filter((p: TermPlan) => p.id !== planId);
  writeLocalPlans(userId, filteredPlans);

  // 2. Delete from Supabase
  if (supabase) {
    try {
      const { error } = await supabase
        .from('term_plans')
        .delete()
        .eq('id', planId)
        .eq('user_id', userId);

      if (error) {
        console.error('Supabase delete error:', error);
      }
    } catch (err) {
      console.error('Failed to delete from Supabase', err);
    }
  }
};
