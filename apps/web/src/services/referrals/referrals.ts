import { supabase } from '../supabaseClient';
import { resolveAuthUid } from '../../utils/authUtils';
import { isGovernedCreditProducerEnabled } from '../credits/creditProducerFlags';

/**
 * Módulo de indicações e recompensas (referrals).
 *
 * Lote 1.3C.3 keeps the legacy implementation available while the governed
 * producer migration is not deployed. Once VITE_GOVERNED_CREDIT_PRODUCERS is
 * explicitly true, positive economic writes fail closed through governed RPCs
 * and never fall back to profiles.credits.
 */

export const registerPhone = async (userId: string, phone: string) => {
  if (isGovernedCreditProducerEnabled()) {
    const { data, error } = await supabase.rpc('credit_register_my_phone_bonus', {
      p_phone: phone,
    });

    if (error) return { success: false, message: error.message };

    const result = data as
      | { success?: boolean; result?: string; credited?: boolean }
      | null;

    if (result?.result === 'already_registered') {
      return { success: false, message: 'Telefone já cadastrado anteriormente.' };
    }

    if (result?.success === false) {
      return { success: false, message: 'Não foi possível cadastrar o telefone.' };
    }

    return { success: true, message: 'Telefone cadastrado! Você ganhou 10 créditos.' };
  }

  // Legacy path retained only while the governed producer flag is OFF.
  let authUid: string;
  try {
    authUid = await resolveAuthUid();
  } catch {
    authUid = userId;
  }

  const { data, error } = await supabase
    .from('profiles')
    .select('phone, credits')
    .eq('id', authUid)
    .is('phone', null)
    .maybeSingle();

  if (error) return { success: false, message: error.message };
  if (!data) return { success: false, message: 'Telefone já cadastrado anteriormente.' };

  const { error: updateError } = await supabase
    .from('profiles')
    .update({
      phone,
      credits: (data.credits || 0) + 10,
    })
    .eq('id', authUid)
    .is('phone', null);

  if (updateError) return { success: false, message: updateError.message };
  return { success: true, message: 'Telefone cadastrado! Você ganhou 10 créditos.' };
};

export const addReferral = async (referrerId: string, refereeEmail: string) => {
  const { data: existing } = await supabase
    .from('referrals')
    .select('*')
    .eq('referrer_id', referrerId)
    .eq('referee_email', refereeEmail)
    .maybeSingle();

  if (existing) return { success: false, message: 'Você já indicou esta pessoa.' };

  const { error } = await supabase.from('referrals').insert({
    referrer_id: referrerId,
    referee_email: refereeEmail,
    status: 'pending',
  });

  if (error) return { success: false, message: error.message };
  return { success: true, message: 'Indicação enviada com sucesso!' };
};

export const checkAndRewardReferrer = async (newUserEmail: string) => {
  if (isGovernedCreditProducerEnabled()) {
    const { error } = await supabase.rpc('credit_claim_my_referral_bonus');
    if (error) {
      console.error('[referrals] governed referral claim failed:', error);
    }
    return;
  }

  // Legacy path retained only while the governed producer flag is OFF.
  const { data: updatedReferral, error: updateError } = await supabase
    .from('referrals')
    .update({ status: 'completed' })
    .eq('referee_email', newUserEmail)
    .eq('status', 'pending')
    .select('referrer_id')
    .maybeSingle();

  if (updateError || !updatedReferral) return;

  const { data: referrerProfile } = await supabase
    .from('profiles')
    .select('credits')
    .eq('id', updatedReferral.referrer_id)
    .maybeSingle();

  if (referrerProfile) {
    await supabase
      .from('profiles')
      .update({ credits: (referrerProfile.credits || 0) + 10 })
      .eq('id', updatedReferral.referrer_id);
  }
};
