import { supabase } from '../supabaseClient';
import { UserProfile } from '../../types';
import { ADMIN_EMAILS, MAX_CREDITS_ADD } from '../../constants';

/**
 * Módulo de ações administrativas sobre perfis.
 * Extraído de userService.ts (refatoração Fase 1 — ver docs/REFACTORING_METHODOLOGY.md).
 * Comportamento idêntico ao original.
 */

export const getAllUsers = async () => {
    // Attempt Secure RPC first (Bypasses RLS issues)
    const { data, error } = await supabase.rpc('get_all_profiles_secure');

    if (!error && data) {
        return { data, error };
    }

    // Fallback to standard select if RPC missing/failed
    console.warn('[userService] RPC failed/missing, falling back to standard select:', error);
    return await supabase
        .from('profiles')
        .select('*')
        .order('email');
};

export const updateUserProfileAdmin = async (targetUserId: string, updates: Partial<UserProfile>) => {
    // Usa RPC SECURITY DEFINER que bypassa RLS — mesma abordagem do get_all_profiles_secure
    const { data: result, error } = await supabase.rpc('admin_update_profile', {
        p_target_id: targetUserId,
        p_tier: updates.tier ?? null,
        p_credits: updates.credits ?? null,
        p_is_unlimited: updates.is_unlimited ?? null,
        p_role: updates.role ?? null,
        p_is_admin: updates.is_admin ?? null,
    });

    if (error) {
        console.error('[userService] admin_update_profile RPC error:', error);
        return { data: null, error };
    }

    // RPC retorna { success: boolean, error?: string }
    const parsed = result as { success: boolean; error?: string } | null;
    if (parsed && !parsed.success) {
        console.error('[userService] admin_update_profile failed:', parsed.error);
        return { data: null, error: { message: parsed.error || 'Falha ao atualizar perfil.' } };
    }

    return { data: result, error: null };
};

export const addUserCredits = async (userId: string, amount: number) => {
    // M-5: Guard against invalid amounts
    if (!Number.isFinite(amount) || amount <= 0 || amount > MAX_CREDITS_ADD) {
        return { error: { message: `Valor inválido. Deve ser entre 1 e ${MAX_CREDITS_ADD} créditos.` } };
    }

    // Usa RPC SECURITY DEFINER que bypassa RLS
    const { data: result, error } = await supabase.rpc('admin_add_credits', {
        p_target_id: userId,
        p_amount: amount,
    });

    if (error) {
        console.error('[userService] admin_add_credits RPC error:', error);
        return { error };
    }

    const parsed = result as { success: boolean; error?: string } | null;
    if (parsed && !parsed.success) {
        return { error: { message: parsed.error || 'Falha ao adicionar créditos.' } };
    }

    return { data: result, error: null };
};

export const updateUserRole = async (userId: string, newRole: 'teacher' | 'manager') => {
    // C-1: Verify the caller is actually an admin before updating any role.
    // Teachers can only change between 'teacher' and 'manager' (never 'admin').
    // Admin escalation must be done directly in the database, never via this function.
    const { data: { user: callerUser } } = await supabase.auth.getUser();
    if (!callerUser) return { data: null, error: { message: 'Não autenticado.' } };

    const callerEmail = callerUser.email || '';
    const isCallerAdmin = ADMIN_EMAILS.includes(callerEmail.toLowerCase());

    // Non-admin users can only change their own role, and only between teacher/manager
    if (!isCallerAdmin && callerUser.id !== userId) {
        return { data: null, error: { message: 'Você não tem permissão para alterar o role de outros usuários.' } };
    }

    // Nobody can assign 'admin' via this function
    if ((newRole as string) === 'admin') {
        return { data: null, error: { message: 'Elevação para admin não é permitida por esta função.' } };
    }

    const { data, error } = await supabase
        .from('profiles')
        .update({ role: newRole })
        .eq('id', userId);
    return { data, error };
};
