import { supabase } from './supabaseClient';
import { UserProfile } from '../types';

// --- CONFIGURATION ---
const IS_BETA_TESTING = false; // Set to TRUE for Play Store Beta (Free Gold for Testers)

const getErrorMessage = (error: unknown): string =>
    error instanceof Error ? error.message : 'Unknown error';

// Helper to recover from Session ID mismatch (Ghost ID)
export const getProfileByEmail = async (email: string) => {
    const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('email', email)
        .order('created_at', { ascending: false });

    if (error) {
        console.error('[userService] Error fetching profile by email:', error);
        return { data: null };
    }

    // Handle duplicates gracefully by taking the most recent match
    const profile = data && data.length > 0 ? data[0] : null;

    return { data: profile };
};

export const getUserProfile = async (userId: string, email?: string): Promise<UserProfile | null> => {
    try {
        // 1. Try fetching by ID first
        const { data, error } = await supabase
            .from('profiles')
            .select('*')
            .eq('id', userId)
            .maybeSingle();

        // 2. Fallback: If ID not found/mismatched but we have email, try email
        if ((error || !data) && email) {
            console.warn(`[userService] Profile not found for ID ${userId}. Attempting fallback by email: ${email}`);
            const { data: recoveredProfile } = await getProfileByEmail(email);
            if (recoveredProfile) {
                console.log('[userService] Profile recovered by email!');
                return recoveredProfile as UserProfile;
            }
        }

        if (error || !data) {
            console.error("[userService] ❌ Error fetching profile:", error);
                const status =
                    error && typeof error === 'object' && 'status' in error
                        ? (error as { status?: number }).status
                        : undefined;
                if (error?.code === '42501' || status === 403) {
                console.error("[userService] ⛔ RLS PERMISSION DENIED. Check Supabase Policies for 'profiles' table.");
            }
            return null;
        }

        let schoolName = undefined;
        let inepCode = undefined;
        if (data?.school_id) {
            try {
                const { data: schoolData } = await supabase
                    .from('schools')
                    .select('name, inep_code')
                    .eq('id', (data.school_id as string).trim())
                    .maybeSingle();
                if (schoolData) {
                    schoolName = schoolData.name;
                    inepCode = schoolData.inep_code;
                }
            } catch (schoolErr) {
                console.warn("[userService] Optional school fetch failed:", schoolErr);
            }
        }

        // Transform and normalize
        const profileData: UserProfile = {
            ...data,
            full_name: data.full_name || data.userName || '', // Ensure name mapping
            school_name: schoolName || data.school_name,
            inep_code: inepCode
        };

        console.log("[userService] Profile Loaded:", profileData.full_name);
        // schools join removed
        // delete profileData.schools;

        // BETA OVERRIDE: Grant Gold + Unlimited to everyone during testing
        if (IS_BETA_TESTING && data) {
            return {
                ...profileData,
                tier: 'GOLD',
                is_unlimited: true,
                credits: 9999 // Visual sugar
            };
        }

        return profileData as UserProfile;
    } catch (err) {
        console.error("[userService] Fatal Exception in getUserProfile:", err);
        return null;
    }
};

export const checkUsageQuota = async (userId: string): Promise<{ allowed: boolean; message?: string }> => {
    const profile = await getUserProfile(userId);

    // Profile Not Found
    if (!profile) {
        console.warn(`User ${userId} not found in profiles. Allowing access as fallback (Dev/Legacy).`);
        return { allowed: true };
    }

    // GOLD TIER (Unlimited)
    if (profile.is_unlimited || profile.tier === 'GOLD') {
        return { allowed: true };
    }

    // SILVER TIER (Credit Check)
    if (profile.credits <= 0) {
        return {
            allowed: false,
            message: `Créditos insuficientes (${profile.credits}). Entre em contato com o administrador (prehfeld@hotmail.com) para recarregar.`
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

// --- ADMIN FUNCTIONS ---

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


/**
 * Updates a user profile and deterministically links to a school via INEP code.
 * Follows the government unique ID logic (MASP for Teachers, INEP for Schools).
 */
export const updateUserProfile = async (
    userId: string,
    profileData: {
        userName?: string;
        institutionalEmail?: string;
        masp?: string;
        city?: string;
        inep_code?: string;
        [key: string]: unknown;
    }
): Promise<{ success: boolean; message?: string; error?: string }> => {
    try {
        // 1. Prepare updates for the profile table
        const updates: Record<string, unknown> = {
            full_name: profileData.userName?.trim(),
            email: profileData.institutionalEmail?.trim().toLowerCase(),
            masp: profileData.masp?.trim(),
            city: profileData.city?.trim(),
            // Pedagogical settings
            favorite_methodology: profileData.favoriteMethodology,
            teaching_style: profileData.teachingStyle,
            assessment_focus: profileData.assessmentFocus,
            tone_of_voice: profileData.toneOfVoice,
            // Document personalization
            header_text: profileData.headerText,
            footer_text: profileData.footerText,
            logo_base64: profileData.logoBase64
        };

        let message = undefined;

        // 2. School Linking is now handled via teacher_schools table
        // DO NOT update profiles.school_id here - this is legacy behavior
        // The ProfileTab calls reconcileTeacherByInep which creates proper links
        if (profileData.inep_code) {
            const cleanInep = profileData.inep_code.trim();
            console.log('[userService] ℹ️ INEP code provided:', cleanInep);
            console.log('[userService] ℹ️ School linking is handled by teacherSchoolService, not here.');
            // NOTE: We don't update school_id anymore to prevent overwriting
            // The teacher_schools table is the source of truth for multi-school support
        }

        // 3. Update the profiles table
        console.log("[userService] Sending update to Supabase for user:", userId, updates);

        const { error: updateError, count } = await supabase
            .from('profiles')
            .update(updates)
            .eq('id', userId);

        if (updateError) {
            console.error("[userService] Supabase Update Error:", updateError);
            // If it's a column missing error, it's a critical hint
            if (updateError.message.includes('column') && updateError.message.includes('does not exist')) {
                return {
                    success: false,
                    error: `Erro de Estrutura: Algumas colunas de configuração ainda não existem no seu banco de dados. Por favor, execute o script SQL de migração. (${updateError.message})`
                };
            }
            return { success: false, error: updateError.message };
        }

        console.log("[userService] Update successful. Rows affected:", count);
        return { success: true, message };
    } catch (err: unknown) {
        console.error("[userService] Fatal error in updateUserProfile:", err);
        return { success: false, error: getErrorMessage(err) || "Erro fatal ao conectar com o banco de dados" };
    }
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

export const isAdmin = (profile: UserProfile | null) => {
    // Strict check: Must be explicitly 'admin' role or is_admin flag.
    // School Managers are NOT System Admins.
    return (profile?.is_admin === true || profile?.role === 'admin') && profile?.role !== 'manager';
};

export const hasFeaturePattern = (userFeatures: string[] | null | undefined, requiredFeature: string): boolean => {
    if (!userFeatures || !Array.isArray(userFeatures)) return false;
    if (userFeatures.includes('all')) return true;
    return userFeatures.includes(requiredFeature);
};

// --- REFERRAL & REWARDS ---

export const registerPhone = async (userId: string, phone: string) => {
    // 1. Check if user already has phone (to avoid double reward abuse)
    const { data: profile } = await supabase.from('profiles').select('phone, credits').eq('id', userId).maybeSingle();
    if (profile?.phone) return { success: false, message: 'Telefone já cadastrado anteriormente.' };

    // 2. Update phone and Add 10 credits
    const { error } = await supabase
        .from('profiles')
        .update({
            phone: phone,
            credits: (profile?.credits || 0) + 10
        })
        .eq('id', userId);

    if (error) return { success: false, message: error.message };
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
    // 1. Find pending referral for this email
    const { data: referral } = await supabase
        .from('referrals')
        .select('*')
        .eq('referee_email', newUserEmail)
        .eq('status', 'pending')
        .maybeSingle();

    if (!referral) return; // No referral found

    // 2. Mark as completed
    await supabase.from('referrals').update({ status: 'completed' }).eq('id', referral.id);

    // 3. Reward Referrer (+10 Credits)
    // We need to fetch referrer current credits first to increment safely (or use RPC if available)
    const { data: referrerProfile } = await supabase
        .from('profiles')
        .select('credits')
        .eq('id', referral.referrer_id)
        .maybeSingle();

    if (referrerProfile) {
        await supabase
            .from('profiles')
            .update({ credits: (referrerProfile.credits || 0) + 10 })
            .eq('id', referral.referrer_id);
    }
};

export const addUserCredits = async (userId: string, amount: number) => {
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
    const { data, error } = await supabase
        .from('profiles')
        .update({ role: newRole })
        .eq('id', userId);
    return { data, error };
};
