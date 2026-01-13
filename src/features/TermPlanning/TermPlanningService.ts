import { supabase } from '../../services/supabaseClient';
import { TermPlan } from '../../contexts/GlobalPlanningContext';

const LOCAL_STORAGE_KEY = 'profeplan_term_plans_history';

/**
 * Salva o planejamento trimestral/bimestral (Local-First)
 */
export const saveTermPlan = async (userId: string, plan: TermPlan) => {
    // 1. Save Local
    const planWithMeta = {
        ...plan,
        id: plan.id || `term_${Date.now()}`,
        userId,
        synced: false,
        updatedAt: new Date().toISOString()
    };

    try {
        const history = JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY) || '[]');
        // Upsert based on ID logic if we were editing list, but for now just push new or replace last active
        // Simplification: We add to history logic
        history.push(planWithMeta);
        localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(history));
    } catch (e) {
        console.error('Local save failed', e);
    }

    // 2. Sync to Supabase
    try {
        const { error } = await supabase
            .from('term_plans')
            .upsert({
                id: planWithMeta.id,
                user_id: userId,
                period: plan.period,
                regime: plan.regime,
                subject: plan.subject,
                grade: plan.grade,
                level: plan.level,
                workload_weekly: plan.workloadWeekly,
                reserves: plan.reserves,
                total_classes: plan.totalClasses,
                grading_grid: plan.gradingGrid,
                state_base: plan.stateBase,
                education_sphere: plan.educationSphere,
                generated_text: plan.generatedText,
                updated_at: new Date().toISOString()
            });

        if (error) throw error;

        console.log('☁️ Term plan synced to Supabase');
    } catch (e) {
        console.warn('⚠️ Sync failed (offline?):', e);
    }

    return planWithMeta;
};

/**
 * Busca os planejamentos (Supabase term_plans + generated_contents + Fallback Local)
 */
export const fetchTermPlans = async (userId: string): Promise<TermPlan[]> => {
    let plans: TermPlan[] = [];

    try {
        // 1. Fetch Structured Plans (term_plans)
        const { data: structuredData, error: structuredError } = await supabase
            .from('term_plans')
            .select('*')
            .eq('user_id', userId)
            .order('updated_at', { ascending: false });

        if (!structuredError && structuredData) {
            plans = structuredData.map((d: any) => ({
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
                generatedText: d.generated_text,
                createdAt: d.created_at
            } as TermPlan));
        }

        // 2. Fetch Generic Plans marked as 'trimestral' (generated_contents)
        // Isso cobre planos salvos via Chat/Meus Arquivos
        const { data: genericData, error: genericError } = await supabase
            .from('generated_contents')
            .select('*')
            .eq('user_id', userId)
            .eq('type', 'trimestral')
            .order('created_at', { ascending: false });

        if (!genericError && genericData) {
            const genericPlans: TermPlan[] = genericData.map((d: any) => ({
                id: d.id,
                subject: d.title.split('-')[0]?.trim() || 'Geral', // Tenta extrair do titulo ex: "TRIMESTRAL - Geografia..."
                grade: 'Geral', // Generic fallback
                period: 1,
                regime: 'Trimestre',
                level: 'Ensino Médio',
                workloadWeekly: 0,
                reserves: { monthlyExam: false, bimonthlyExam: false, recovery: false },
                totalClasses: 0,
                gradingGrid: {},
                stateBase: 'Geral',
                educationSphere: 'Geral',
                generatedText: d.content,
                createdAt: d.created_at
            } as TermPlan));

            // Merge avoiding duplicates (prefer structured if exists)
            // Mas IDs serão diferentes (uuid vs local_...), então apenas concatena
            plans = [...plans, ...genericPlans];
        }

    } catch (e) {
        console.warn('Supabase fetch failed, trying local', e);
    }

    // 3. Mescla com LocalStorage (prioridade para local se mais recente ou offline)
    try {
        const localData = JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY) || '[]');
        if (plans.length === 0) {
            plans = localData;
        }
    } catch (e) {
        console.error('Local fetch failed', e);
    }

    return plans;
};
