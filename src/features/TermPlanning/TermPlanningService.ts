import { supabase } from '../../services/supabaseClient';
import { TermPlan } from '../../types';

const LOCAL_STORAGE_KEY = 'profeplan_term_plans_history';

/**
 * Salva o planejamento trimestral/bimestral (Local-First)
 */
export const saveTermPlan = async (userId: string, plan: TermPlan) => {
    // 1. Save Local
    const planWithMeta: TermPlan = {
        ...plan,
        id: plan.id || `term_${Date.now()}`,
        created_at: plan.created_at || new Date().toISOString()
    };

    try {
        const history: TermPlan[] = JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY) || '[]');
        history.push(planWithMeta);
        localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(history));
    } catch (e) {
        console.error('Local save failed', e);
    }

    // 2. Sync to Supabase
    try {
        const payload = {
            id: planWithMeta.id,
            user_id: userId,
            period: plan.period,
            regime: plan.regime,
            subject: plan.subject,
            grade: plan.grade,
            level: plan.level, // New column
            workload_weekly: plan.workloadWeekly,
            reserves: plan.reserves,
            total_classes: plan.totalClasses,
            grading_grid: plan.gradingGrid,
            state_base: plan.stateBase,
            education_sphere: plan.educationSphere,
            generated_text: plan.generatedText,
            lessons: plan.lessons, // New column
            updated_at: new Date().toISOString()
        };

        const { error } = await supabase.from('term_plans').upsert(payload);

        if (error) {
            // FALLBACK: Try without 'level' column if it fails (Migration safety)
            console.warn("Upsert failed, trying fallback without 'level'...", error.message);
            const { level, ...fallbackPayload } = payload;
            const { error: fallbackError } = await supabase.from('term_plans').upsert(fallbackPayload);
            if (fallbackError) throw fallbackError;
        }

        console.log('☁️ Term plan synced to Supabase');
    } catch (e) {
        console.warn('⚠️ Sync failed (offline or schema mismatch):', e);
    }

    return planWithMeta;
};

/**
 * Busca os planejamentos (Supabase term_plans + generated_contents + Fallback Local)
 */
export const fetchTermPlans = async (userId: string): Promise<TermPlan[]> => {
    let plans: TermPlan[] = [];
    console.log(`[DEBUG] fetchTermPlans called for userId: ${userId}`);

    try {
        // 1. Fetch Structured Plans (term_plans)
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

        // 2. Fetch Generic Plans marked as 'trimestral' (generated_contents)
        // Isso cobre planos salvos via Chat/Meus Arquivos
        const { data: genericData, error: genericError } = await supabase
            .from('generated_contents')
            .select('*')
            .eq('user_id', userId)
            .eq('type', 'trimestral')
            .order('created_at', { ascending: false });

        if (genericError) {
            console.error('[DEBUG] Generic Fetch Error:', genericError);
        } else {
            console.log(`[DEBUG] Generic Plans Found: ${genericData?.length || 0}`);
        }

        if (!genericError && genericData) {
            const genericPlans: TermPlan[] = genericData.map((d: any) => {
                const meta = parseTitleMetadata(d.title || '', d.content || '');
                return {
                    id: d.id,
                    subject: meta.subject,
                    grade: meta.grade,
                    period: meta.period,
                    regime: meta.regime as 'Bimestre' | 'Trimestre',
                    level: 'Ensino Médio', // Default fallback
                    workloadWeekly: 2,
                    reserves: { monthlyExam: false, bimonthlyExam: false, recovery: false },
                    totalClasses: 0,
                    gradingGrid: { vistos: 0, trabalhos: 0, monthlyExam: 0, bimonthlyExam: 0, others: 0 },
                    stateBase: 'Geral',
                    educationSphere: 'Geral',
                    generatedText: d.content || '',
                    created_at: d.created_at
                } as TermPlan;
            });

            // Merge avoiding duplicates (prefer structured if exists)
            // Mas IDs serão diferentes (uuid vs local_...), então apenas concatena
            // Filtrar duplicatas pode ser complexo se ID mudar, vamos permitir por enquanto
            plans = [...plans, ...genericPlans];
        }

    } catch (e) {
        console.warn('Supabase fetch failed, trying local', e);
    }

    // 3. Mescla com LocalStorage (prioridade para local se mais recente ou offline)
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
