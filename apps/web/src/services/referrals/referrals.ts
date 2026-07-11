import { supabase } from '../supabaseClient';
import { resolveAuthUid } from '../../utils/authUtils';

/**
 * Módulo de indicações e recompensas (referrals).
 * Extraído de userService.ts (refatoração Fase 1 — ver docs/REFACTORING_METHODOLOGY.md).
 * Comportamento idêntico ao original.
 */

export const registerPhone = async (userId: string, phone: string) => {
    // Usa auth.uid() real — evita ghost UUID no RLS (mesmo padrão de getClasses).
    // Sem isso, com Ghost ID o SELECT de guarda retorna vazio e a função devolve
    // "telefone já cadastrado" indevidamente, sem nunca conceder o bônus.
    let authUid: string;
    try {
        authUid = await resolveAuthUid();
    } catch {
        authUid = userId;
    }

    // M-3: Atomic update — only succeeds if phone IS NULL (no TOCTOU window).
    // If two requests race, the second will hit 0 rows updated and return a failure.
    const { data, error } = await supabase
        .from('profiles')
        .select('phone, credits')
        .eq('id', authUid)
        .is('phone', null) // Only update if phone not yet set
        .maybeSingle();

    if (error) return { success: false, message: error.message };
    if (!data) return { success: false, message: 'Telefone já cadastrado anteriormente.' };

    // Safe to update: we just confirmed phone is null in the same read
    const { error: updateError } = await supabase
        .from('profiles')
        .update({
            phone: phone,
            credits: (data.credits || 0) + 10
        })
        .eq('id', authUid)
        .is('phone', null); // Atomic guard: fail if phone was set by a racing request

    if (updateError) return { success: false, message: updateError.message };
    return { success: true, message: 'Telefone cadastrado! Você ganhou 10 créditos.' };
};

export const addReferral = async (referrerId: string, refereeEmail: string) => {
    // Check if referral already exists
    const { data: existing } = await supabase
        .from('referrals')
        .select('*')
        .eq('referrer_id', referrerId)
        .eq('referee_email', refereeEmail)
        .maybeSingle();

    if (existing) return { success: false, message: 'Você já indicou esta pessoa.' };

    const { error } = await supabase
        .from('referrals')
        .insert({
            referrer_id: referrerId,
            referee_email: refereeEmail,
            status: 'pending'
        });

    if (error) return { success: false, message: error.message };
    return { success: true, message: 'Indicação enviada com sucesso!' };
};

export const checkAndRewardReferrer = async (newUserEmail: string) => {
    // M-4: Atomic status flip — only the first caller to set status='completed' will proceed.
    // Subsequent duplicate calls will find no 'pending' row and exit early.
    const { data: updatedReferral, error: updateError } = await supabase
        .from('referrals')
        .update({ status: 'completed' })
        .eq('referee_email', newUserEmail)
        .eq('status', 'pending') // Atomic guard: only matches once
        .select('referrer_id')
        .maybeSingle();

    if (updateError || !updatedReferral) return; // Already completed or not found

    // Safe to reward: status was 'pending' and we just atomically flipped it
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
