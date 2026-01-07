import { supabase } from '../../services/supabaseClient';
import { checkUsageQuota, incrementUserUsage } from '../../services/userService';

// --- FOLDER STRUCTURE ENUM ---
export enum PlanFolder {
    PLANEJAMENTO_TRI_BI = 'PLANEJAMENTO TRI/BI',
    PLANO_AULA = 'PLANO AULA',
    MATERIAL_ALUNO = 'MATERIAL ALUNO',
    APRESENTACOES = 'APRESENTAÇÕES',
    AVALIACOES = 'AVALIAÇÕES',
    SIMULADOS = 'SIMULADOS'
}

const LOCAL_STORAGE_HISTORY_KEY = 'profeplan_history_buffer';

export interface GeneratedPlan {
    id: string;
    type: 'plano' | 'aula' | 'avaliacao' | 'documento' | 'trimestral' | 'enem';
    folder: PlanFolder; // New Field
    title: string;
    content: string;
    createdAt: string;
    synced: boolean;
}

/**
 * [LOCAL-FIRST]
 * Salva o plano gerado no LocalStorage e tenta sincronizar.
 */
/**
 * [CREDIT TRANSACTION]
 * Salva o plano e consome 1 crédito.
 * Lógica: Check Quota -> Save Local -> Sync Cloud (DB) -> Deduct Credit
 */
export const savePlan = async (userId: string, plan: Omit<GeneratedPlan, 'synced' | 'id' | 'folder'>, targetFolder: PlanFolder) => {

    // 1. Check Credit Balance (Gatekeeper)
    const quota = await checkUsageQuota(userId);
    if (!quota.allowed) {
        throw new Error(quota.message || "Saldo insuficiente.");
    }

    const newPlan: GeneratedPlan = {
        ...plan,
        folder: targetFolder,
        id: `local_${Date.now()}`,
        synced: false,
        createdAt: new Date().toISOString()
    };

    // 2. Save Locally (Draft/Backup)
    try {
        const saved = JSON.parse(localStorage.getItem(LOCAL_STORAGE_HISTORY_KEY) || '[]');
        saved.push(newPlan);
        localStorage.setItem(LOCAL_STORAGE_HISTORY_KEY, JSON.stringify(saved));
        console.log('✅ Plano salvo localmente.');
    } catch (e) {
        console.error('Erro ao salvar plano localmente:', e);
    }

    // 3. Sync Background (The Real Save) & Deduct Credit
    // We await this now to ensure credit deduction validity
    await syncPlanToCloud(userId, newPlan);

    return newPlan;
};

/**
 * Sincroniza com Supabase (generated_contents + lessons)
 */
const syncPlanToCloud = async (userId: string, plan: GeneratedPlan) => {
    // A. Generated Contents (Drive)
    const { error: contentError } = await supabase
        .from('generated_contents')
        .insert({
            user_id: userId,
            type: plan.type,
            folder: plan.folder, // New Column
            title: plan.title,
            content: plan.content,
            created_at: plan.createdAt
        });

    if (contentError) throw contentError;

    // A.2 - INCREMENT USAGE (Debit Credit)
    // Only debit if insertion was successful
    await incrementUserUsage(userId);
    console.log('💰 Crédito debitado por salvamento de documento.');

    // B. Memory (Lessons) - Apenas se for relevante (Plano de Aula ou Atividade)
    if (['plano', 'aula', 'trimestral'].includes(plan.type)) {
        const { error: lessonError } = await supabase
            .from('lessons')
            .insert({
                user_id: userId,
                topic: plan.title,
                content: plan.content,
                class_id: null // Poderia passar se tivesse
            });

        if (lessonError) console.warn('Erro ao salvar memória da aula:', lessonError);
    }

    // C. Atualiza status local para 'synced'
    try {
        const saved = JSON.parse(localStorage.getItem(LOCAL_STORAGE_HISTORY_KEY) || '[]');
        const updated = saved.map((p: GeneratedPlan) =>
            p.id === plan.id ? { ...p, synced: true } : p
        );
        localStorage.setItem(LOCAL_STORAGE_HISTORY_KEY, JSON.stringify(updated));
    } catch (e) {
        // Ignorar erro de update local pós-sync
    }

    console.log('☁️ Plano sincronizado!');
};
