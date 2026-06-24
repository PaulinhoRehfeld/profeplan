import { supabase } from '../supabaseClient';
import { UserProfile } from '../../types';
import { isHardcodedAdmin } from '../../constants';
import { getUserProfile } from '../userService';

/**
 * Módulo de créditos / quota.
 * Extraído de userService.ts (refatoração Fase 1 — ver docs/REFACTORING_METHODOLOGY.md).
 * Comportamento idêntico ao original; coberto por userService.characterization.test.ts.
 */

export const checkUsageQuota = async (userId: string, preloadedProfile?: UserProfile | null): Promise<{ allowed: boolean; message?: string }> => {
    const profile = preloadedProfile ?? await getUserProfile(userId);

    // Profile Not Found
    if (!profile) {
        try {
            const { data: { session } } = await supabase.auth.getSession();
            const email = session?.user?.email;

            // Admin bypass
            if (email && isHardcodedAdmin(email)) {
                console.warn(`[userService] Profile null para admin ${email} — liberando bypass.`);
                return { allowed: true };
            }

            // Session exists but profile inaccessible (expired JWT / RLS block / DB issue).
            // Allow the action rather than blocking a legitimately authenticated user.
            // Credit deduction still runs after the action via incrementUserUsage.
            if (session?.user?.id) {
                console.warn(`[userService] Profile null mas sessão ativa (${session.user.id}) — permitindo. Possível JWT expirado.`);
                return { allowed: true };
            }
        } catch { /* silent */ }

        // Truly no session — block
        console.warn(`User ${userId} not found in profiles and no active session. Blocking.`);
        return {
            allowed: false,
            message: 'Sua sessão expirou. Recarregue a página e faça login novamente.'
        };
    }

    // GOLD TIER (Unlimited)
    if (profile.is_unlimited || profile.tier === 'GOLD') {
        return { allowed: true };
    }

    // SILVER TIER (Credit Check)
    if (profile.credits <= 0) {
        return {
            allowed: false,
            message: `Créditos insuficientes (${profile.credits}). Entre em contato com o suporte para recarregar.`
        };
    }

    return { allowed: true };
};

/**
 * Deducts 1 credit from the user (if not unlimited).
 */
export const incrementUserUsage = async (userId: string, taskType: string = 'unknown'): Promise<void> => {
    // Only deduct credits if it's an AI or Content Generation task
    const paidTasks = ['generate', 'document', 'chat', 'term_plan', 'aula', 'simulation'];
    if (!paidTasks.includes(taskType)) {
        console.log(`[userService] Skipping credit deduction for task type: ${taskType}`);
        return;
    }

    const profile = await getUserProfile(userId);
    // Safety check: skip if unlimited or no profile
    if (!profile || profile.is_unlimited) return;

    // Critical: Do NOT deduct if profile says 0 or negative
    if (profile.credits <= 0) {
        console.warn(`[userService] Attempted to deduct from empty balance for user ${userId}. Task: ${taskType}`);
        return;
    }

    const { error } = await supabase
        .from('profiles')
        .update({ credits: Math.max(0, profile.credits - 1) })
        .eq('id', userId);

    if (error) {
        console.error("Failed to deduct credit:", error);
    }
};
