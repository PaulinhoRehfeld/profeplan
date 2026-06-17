import { supabase } from './supabaseClient';
import { UserProfile } from '../types';
import { ADMIN_EMAILS, MAX_CREDITS_ADD, isHardcodedAdmin } from '../constants';

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

        // 2. Fallback: If ID not found/mismatched, attempt to resolve email from active session
        let activeEmail = email;
        if ((error || !data) && !activeEmail) {
            try {
                const { data: { session } } = await supabase.auth.getSession();
                if (session?.user?.email) {
                    activeEmail = session.user.email;
                } else {
                    const { data: { user } } = await supabase.auth.getUser();
                    if (user?.email) {
                        activeEmail = user.email;
                    }
                }
            } catch (authErr) {
                console.warn("[userService] Optional auth session fetch failed:", authErr);
            }
        }

        if ((error || !data) && activeEmail) {
            console.warn(`[userService] Profile not found for ID ${userId}. Attempting fallback by email: ${activeEmail}`);
            const { data: recoveredProfile } = await getProfileByEmail(activeEmail);
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

            // ── Auto-create profile as last resort (trigger may have failed) ──
            try {
                const { data: { user: authUser } } = await supabase.auth.getUser();
                if (!authUser) {
                    console.warn('[userService] No active auth session — cannot create emergency profile.');
                } else {
                    // If stored userId differs from session (Ghost ID), use session ID
                    const targetId = authUser.id === userId ? userId : authUser.id;
                    if (authUser.id !== userId) {
                        console.warn(`[userService] Ghost ID detected: stored=${userId} auth=${authUser.id}. Using auth ID.`);
                    }
                    console.warn('[userService] Attempting emergency profile creation for:', targetId);
                    const fallbackEmail = authUser.email || activeEmail || '';
                    const userIsAdmin = isHardcodedAdmin(fallbackEmail);
                    const { data: created, error: createErr } = await supabase
                        .from('profiles')
                        .upsert({
                            id: targetId,
                            email: fallbackEmail,
                            full_name: authUser.user_metadata?.full_name
                                || authUser.user_metadata?.name
                                || fallbackEmail.split('@')[0],
                            role: userIsAdmin ? 'admin' : 'teacher',
                            is_admin: userIsAdmin,
                            tier: userIsAdmin ? 'GOLD' : 'FREE',
                            is_unlimited: userIsAdmin,
                            credits: userIsAdmin ? 9999 : 10,
                        }, { onConflict: 'id' })
                        .select()
                        .maybeSingle();

                    if (!createErr && created) {
                        console.log('[userService] ✅ Emergency profile created successfully.');
                        return created as UserProfile;
                    }
                    if (createErr) {
                        console.error('[userService] Emergency profile creation failed:', createErr);
                    } else {
                        // Upsert succeeded but select returned null (RLS on return=representation).
                        // Retry the read separately.
                        console.warn('[userService] Upsert returned null — retrying SELECT after write...');
                        const { data: retryData, error: retryErr } = await supabase
                            .from('profiles')
                            .select('*')
                            .eq('id', targetId)
                            .maybeSingle();
                        if (!retryErr && retryData) {
                            console.log('[userService] ✅ Profile confirmed via retry SELECT.');
                            return retryData as UserProfile;
                        }
                        console.error('[userService] Retry SELECT also failed:', retryErr);
                    }
                }
            } catch (emergencyErr) {
                console.warn('[userService] Emergency profile creation threw:', emergencyErr);
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
                credits: 9999 // Beta visual sugar — production uses DB values
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
        console.warn(`User ${userId} not found in profiles. Blocking quota-protected action.`);
        return {
            allowed: false,
            message: 'Não foi possível carregar seu perfil para validar os créditos. Tente novamente em instantes.'
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
    const { data, error } = await supabase
        .from('profiles')
        .update(updates)
        .eq('id', targetUserId);
    return { data, error };
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
    // M-3: Atomic update — only succeeds if phone IS NULL (no TOCTOU window).
    // If two requests race, the second will hit 0 rows updated and return a failure.
    const { data, error } = await supabase
        .from('profiles')
        .select('phone, credits')
        .eq('id', userId)
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
        .eq('id', userId)
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

export const addUserCredits = async (userId: string, amount: number) => {
    // M-5: Guard against invalid amounts
    if (!Number.isFinite(amount) || amount <= 0 || amount > MAX_CREDITS_ADD) {
        return { error: { message: `Valor inválido. Deve ser entre 1 e ${MAX_CREDITS_ADD} créditos.` } };
    }

    const { data: profile } = await supabase.from('profiles').select('credits').eq('id', userId).maybeSingle();
    if (!profile) return { error: { message: 'Usuário não encontrado' } };

    const newCredits = (profile.credits || 0) + amount;
    return await supabase.from('profiles').update({ credits: newCredits }).eq('id', userId);
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
