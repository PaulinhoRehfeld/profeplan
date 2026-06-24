import { supabase } from '../supabaseClient';
import { UserProfile } from '../../types';
import { isHardcodedAdmin } from '../../constants';
import { getUserProfile } from '../profile/profileRepository';

/**
 * Módulo de créditos / quota.
 * Extraído de userService.ts (refatoração Fase 1 — ver docs/REFACTORING_METHODOLOGY.md).
 * Comportamento idêntico ao original; coberto por userService.characterization.test.ts.
 */

export const checkUsageQuota = async (userId: string, preloadedProfile?: UserProfile | null): Promise<{ allowed: boolean; message?: string }> => {
    const profile = preloadedProfile ?? await getUserProfile(userId);

    // Profile Not Found
    if (!profile) {
        // networkError distingue "blip de conexão" (retryável) de "sessão realmente
        // morta" (relogar). getSession() lê do storage (sem rede); se a busca do perfil
        // falhou por conectividade, a sessão local ainda deve estar presente.
        let networkError = false;
        try {
            const { data: { session } } = await supabase.auth.getSession();
            const email = session?.user?.email;

            // Admin bypass
            if (email && isHardcodedAdmin(email)) {
                console.warn(`[quota] Profile null para admin ${email} — liberando bypass.`);
                return { allowed: true };
            }

            // Sessão presente localmente → permite. O BFF revalida o JWT no servidor;
            // a dedução de crédito ocorre depois via incrementUserUsage.
            if (session?.user?.id) {
                console.warn(`[quota] Profile null mas sessão ativa (${session.user.id}) — permitindo.`);
                return { allowed: true };
            }

            // getSession() não trouxe sessão: confirma no servidor antes de declarar morta.
            try {
                const { data: { user } } = await supabase.auth.getUser();
                if (user?.id) {
                    console.warn(`[quota] Profile null mas getUser confirma sessão (${user.id}) — permitindo.`);
                    return { allowed: true };
                }
            } catch {
                networkError = true;
            }
        } catch {
            // getSession lançou — tratamos como problema de conectividade, não sessão morta.
            networkError = true;
        }

        if (networkError) {
            console.warn(`[quota] Falha de conexão ao validar sessão de ${userId}.`);
            return {
                allowed: false,
                message: 'Falha de conexão com o servidor. Verifique sua internet e tente novamente em instantes.'
            };
        }

        // Sem sessão local nem no servidor — sessão realmente expirada.
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
    // credits === null means the profile was found but credit data is incomplete
    // (e.g. duplicate row from Ghost ID migration with no credits initialized).
    // Treat as allowed — the real profile row likely has credits; blocking here is a false negative.
    if (profile.credits === null || profile.credits === undefined) {
        console.warn(`[quota] credits is null for profile ${profile.id} — allowing (ghost-id migration state).`);
        return { allowed: true };
    }

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
