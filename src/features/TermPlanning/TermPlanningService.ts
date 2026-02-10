import { supabase } from '../../services/supabaseClient';
import { TermPlan } from '../../types';

const LOCAL_STORAGE_KEY = 'profeplan_term_plans';

/**
 * Salva um plano trimestral (Local + Supabase)
 */
export const saveTermPlan = async (plan: TermPlan, userId: string): Promise<TermPlan> => {
    // 1. Save to localStorage (offline-first)
    const existingPlans = JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY) || '[]');
    const planIndex = existingPlans.findIndex((p: TermPlan) => p.id === plan.id);

    if (planIndex >= 0) {
        existingPlans[planIndex] = plan;
    } else {
        existingPlans.push(plan);
    }

    localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(existingPlans));

    // 2. Sync to Supabase (term_plans table)
    if (supabase) {
        try {
            const payload = {
                id: plan.id,
                user_id: userId,
                title: plan.title || `Planejamento ${plan.period}º ${plan.regime} - ${plan.subject}`,
                content: plan.generatedText || '',
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
                updated_at: new Date().toISOString()
            };

            const { data, error } = await supabase
                .from('term_plans')
                .upsert(payload)
                .select()
                .single();

            if (error) {
                console.error('Supabase save error:', error);
            } else {
                console.log('✅ Saved to Supabase:', data);
            }
        } catch (err) {
            console.error('Failed to sync to Supabase', err);
        }
    }

    const planWithMeta: TermPlan = {
        ...plan,
        userId,
    };

    return planWithMeta;
};

/**
 * Busca os planejamentos (✅ FONTE ÚNICA: term_plans)
 */
export const fetchTermPlans = async (userId: string): Promise<TermPlan[]> => {
    try {
        if (!supabase) {
            console.error("[CRITICAL] Supabase client not initialized in TermPlanningService");
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
                    lessons: d.lessons || [],
                    created_at: d.created_at || d.updated_at
                } as TermPlan));
            }

        } catch (e) {
            console.warn('Supabase fetch failed, trying local', e);
        }

        // Fallback: Mescla com LocalStorage se Supabase falhar
        try {
            const localData = JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY) || '[]');
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
        console.error("[CRITICAL] Unhandled error in fetchTermPlans:", criticalError);
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
            subject = parts[parts.length - 1].trim().replace(/\(\d+\)$/, '').trim(); // Remove suffix like (2)
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
export const deleteTermPlan = async (planId: string): Promise<void> => {
    // 1. Delete from localStorage
    const existingPlans = JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY) || '[]');
    const filteredPlans = existingPlans.filter((p: TermPlan) => p.id !== planId);
    localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(filteredPlans));

    // 2. Delete from Supabase
    if (supabase) {
        try {
            const { error } = await supabase
                .from('term_plans')
                .delete()
                .eq('id', planId);

            if (error) {
                console.error('Supabase delete error:', error);
            }
        } catch (err) {
            console.error('Failed to delete from Supabase', err);
        }
    }
};
