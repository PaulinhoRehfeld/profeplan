import { supabase } from './supabaseClient';
import { UserProfile, UserSettings } from '../types';

export const ProfileService = {
    /**
     * Fetch the current user's profile, including the linked school.
     */
    async getProfile(): Promise<UserProfile | null> {
        const { data: { user } } = await supabase.auth.getUser();

        if (!user) return null;

        const { data, error } = await supabase
            .from('profiles')
            .select(`
        *,
        school:schools (
          id,
          name,
          city,
          sre
        )
      `)
            .eq('id', user.id)
            .single();

        if (error) {
            console.error('Error fetching profile:', error);
            return null;
        }

        return { ...data, email: user.email };
    },

    /**
     * Update the user's profile with a specific school ID.
     */
    async linkSchool(schoolId: string): Promise<boolean> {
        const { data: { user } } = await supabase.auth.getUser();
        if (!user) return false;

        const { error } = await supabase
            .from('profiles')
            .upsert({
                id: user.id,
                school_id: schoolId,
                updated_at: new Date().toISOString()
            });

        if (error) {
            console.error('Error linking school:', error);
            throw error;
        }

        return true;
    },

    /**
     * Unlink the school from the user's profile.
     */
    async unlinkSchool(): Promise<boolean> {
        const { data: { user } } = await supabase.auth.getUser();
        if (!user) return false;

        const { error } = await supabase
            .from('profiles')
            .update({ school_id: null, updated_at: new Date().toISOString() })
            .eq('id', user.id);

        if (error) {
            console.error('Error unlinking school:', error);
            throw error;
        }

        return true;
    }
};

export {
    getProfileByEmail,
    getUserProfile,
    updateUserProfile,
    isAdmin,
    hasFeaturePattern,
} from './userService';

// Créditos / quota extraídos para módulo coeso (refatoração Fase 1)
export { checkUsageQuota, incrementUserUsage } from './credits/quota';

// Indicações / recompensas extraídas para módulo coeso (refatoração Fase 1)
export { registerPhone, addReferral, checkAndRewardReferrer } from './referrals/referrals';

// Ações administrativas de perfil extraídas para módulo coeso (refatoração Fase 1)
export { getAllUsers, updateUserProfileAdmin, addUserCredits, updateUserRole } from './admin/adminProfiles';

/**
 * Verifica se o Perfil Profissional está completo o suficiente
 * para liberar os fluxos principais (planos, PDI, avaliações).
 */
export const isProfileCompleteForMainFlows = (
    profile: UserProfile | null,
    settings: UserSettings
): boolean => {
    // A obrigatoriedade de completar o perfil foi temporariamente removida.
    return true;
};

