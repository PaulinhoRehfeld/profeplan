import { supabase } from '../supabaseClient';
import { UserProfile } from '../../types';
import { ADMIN_EMAILS, MAX_CREDITS_ADD } from '../../constants';
import { isGovernedCreditProducerEnabled } from '../credits/creditProducerFlags';

/**
 * Módulo de ações administrativas sobre perfis.
 *
 * Lote 1.3C.3 preserves the legacy RPC shape while the producer flag is OFF.
 * Once governed producers are explicitly enabled, positive adjustments require
 * a stable operation id and generic profile editing can no longer write credits.
 */

export const getAllUsers = async () => {
  const { data, error } = await supabase.rpc('get_all_profiles_secure');

  if (!error && data) {
    return { data, error };
  }

  console.warn('[userService] RPC failed/missing, falling back to standard select:', error);
  return await supabase.from('profiles').select('*').order('email');
};

export const updateUserProfileAdmin = async (
  targetUserId: string,
  updates: Partial<UserProfile>
) => {
  const governed = isGovernedCreditProducerEnabled();

  const { data: result, error } = await supabase.rpc('admin_update_profile', {
    p_target_id: targetUserId,
    p_tier: updates.tier ?? null,
    p_credits: governed ? null : (updates.credits ?? null),
    p_is_unlimited: updates.is_unlimited ?? null,
    p_role: updates.role ?? null,
    p_is_admin: updates.is_admin ?? null,
  });

  if (error) {
    console.error('[userService] admin_update_profile RPC error:', error);
    return { data: null, error };
  }

  const parsed = result as { success: boolean; error?: string } | null;
  if (parsed && !parsed.success) {
    console.error('[userService] admin_update_profile failed:', parsed.error);
    return { data: null, error: { message: parsed.error || 'Falha ao atualizar perfil.' } };
  }

  return { data: result, error: null };
};

export const addUserCredits = async (userId: string, amount: number, operationId?: string) => {
  if (!Number.isFinite(amount) || amount <= 0 || amount > MAX_CREDITS_ADD) {
    return {
      error: { message: `Valor inválido. Deve ser entre 1 e ${MAX_CREDITS_ADD} créditos.` },
    };
  }

  const governed = isGovernedCreditProducerEnabled();
  if (governed && !operationId) {
    return {
      error: { message: 'Identificador idempotente obrigatório para ajuste governado.' },
    };
  }

  const args = governed
    ? {
        p_target_id: userId,
        p_amount: amount,
        p_operation_id: operationId,
      }
    : {
        p_target_id: userId,
        p_amount: amount,
      };

  const { data: result, error } = await supabase.rpc('admin_add_credits', args);

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
  const {
    data: { user: callerUser },
  } = await supabase.auth.getUser();
  if (!callerUser) return { data: null, error: { message: 'Não autenticado.' } };

  const callerEmail = callerUser.email || '';
  const isCallerAdmin = ADMIN_EMAILS.includes(callerEmail.toLowerCase());

  if (!isCallerAdmin && callerUser.id !== userId) {
    return {
      data: null,
      error: { message: 'Você não tem permissão para alterar o role de outros usuários.' },
    };
  }

  if ((newRole as string) === 'admin') {
    return {
      data: null,
      error: { message: 'Elevação para admin não é permitida por esta função.' },
    };
  }

  const { data, error } = await supabase
    .from('profiles')
    .update({ role: newRole })
    .eq('id', userId);
  return { data, error };
};
