import { supabase } from './supabaseClient';
import { UserProfile } from '../types';

// --- CONFIGURATION ---
const IS_BETA_TESTING = false; // Set to TRUE for Play Store Beta (Free Gold for Testers)

// Helper to recover from Session ID mismatch (Ghost ID)
export const getProfileByEmail = async (email: string) => {
    const { data } = await supabase
        .from('profiles')
        .select('*')
        .eq('email', email)
        .single();

    return { data };
};

export const getUserProfile = async (userId: string): Promise<UserProfile | null> => {
    // Modified query to join with schools table
    const { data, error } = await supabase
        .from('profiles')
        .select(`
            *,
            schools:school_id (
                name
            )
        `)
        .eq('id', userId)
        .single();

    if (error) {
        console.error("Error fetching user profile:", error);
        return null;
    }

    // Transform result to flat UserProfile structure
    const profileData = {
        ...data,
        school_name: data.schools?.name // Flatten the joined school name
    };
    delete profileData.schools;

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
export const incrementUserUsage = async (userId: string): Promise<void> => {
    // We actually DECREMENT credits now, as per the new "Credits Remaining" logic
    // Using RPC 'deduct_credit' logic (assuming it exists or using update)
    // If RPC doesn't exist, we can use simple update for now, but safer to use RPC.
    // Given previous `increment_usage` existed, we should probably update that RPC or simple update.

    // Check if unlimited first to avoid unnecessary DB write? 
    // Ideally the RPC handles it, but client-side check saves a call.
    const profile = await getUserProfile(userId);
    if (!profile || profile.is_unlimited) return;

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
    const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .order('email');
    return { data, error };
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
    // 1. Check if user already has phone (to avoid double reward abuse)
    const { data: profile } = await supabase.from('profiles').select('phone, credits').eq('id', userId).single();
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
        .single();

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
        .single();

    if (!referral) return; // No referral found

    // 2. Mark as completed
    await supabase.from('referrals').update({ status: 'completed' }).eq('id', referral.id);

    // 3. Reward Referrer (+10 Credits)
    // We need to fetch referrer current credits first to increment safely (or use RPC if available)
    const { data: referrerProfile } = await supabase
        .from('profiles')
        .select('credits')
        .eq('id', referral.referrer_id)
        .single();

    if (referrerProfile) {
        await supabase
            .from('profiles')
            .update({ credits: (referrerProfile.credits || 0) + 10 })
            .eq('id', referral.referrer_id);
    }
};

export const addUserCredits = async (userId: string, amount: number) => {
    const { data: profile } = await supabase.from('profiles').select('credits').eq('id', userId).single();
    if (!profile) return { error: { message: 'Usuário não encontrado' } };

    const newCredits = (profile.credits || 0) + amount;
    return await supabase.from('profiles').update({ credits: newCredits }).eq('id', userId);
};
