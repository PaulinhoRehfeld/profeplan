import { supabase } from './supabaseClient';

export interface UserProfile {
    id: string;
    email: string;
    tier: 'SILVER' | 'GOLD';        // NEW
    credits: number;                // NEW (Remaining)
    is_unlimited: boolean;          // NEW (Gold)
    is_admin: boolean;              // NEW
    allowed_features: string[];
}

// --- CONFIGURATION ---
const IS_BETA_TESTING = false; // Set to TRUE for Play Store Beta (Free Gold for Testers)

export const getUserProfile = async (userId: string): Promise<UserProfile | null> => {
    const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .single();

    // DEV ADMIN MOCK (Bypass DB)
    if (userId === 'dev-admin-id') {
        return {
            id: 'dev-admin-id',
            email: 'admin@dev.local',
            tier: 'GOLD',
            credits: 9999,
            is_unlimited: true,
            is_admin: true,
            allowed_features: ['all']
        };
    }

    if (error) {
        console.error("Error fetching user profile:", error);
        return null;
    }

    // BETA OVERRIDE: Grant Gold + Unlimited to everyone during testing
    if (IS_BETA_TESTING && data) {
        return {
            ...data,
            tier: 'GOLD',
            is_unlimited: true,
            credits: 9999 // Visual sugar
        };
    }

    return data;
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
    return profile?.is_admin === true || profile?.email === 'prehfeld@hotmail.com';
};

export const hasFeaturePattern = (userFeatures: string[] | null | undefined, requiredFeature: string): boolean => {
    if (!userFeatures || !Array.isArray(userFeatures)) return false;
    if (userFeatures.includes('all')) return true;
    return userFeatures.includes(requiredFeature);
};
