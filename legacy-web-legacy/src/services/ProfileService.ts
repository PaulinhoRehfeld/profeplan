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
    checkUsageQuota,
    incrementUserUsage,
    getAllUsers,
    updateUserProfile,
    updateUserProfileAdmin,
    isAdmin,
    hasFeaturePattern,
    registerPhone,
    addReferral,
    checkAndRewardReferrer,
    addUserCredits,
    updateUserRole
} from './userService';

/**
 * Verifica se o Perfil Profissional está completo o suficiente
 * para liberar os fluxos principais (planos, PDI, avaliações).
 */
export const isProfileCompleteForMainFlows = (
    profile: UserProfile | null,
    settings: UserSettings
): boolean => {
    if (!profile) return false;

    // Campos básicos
    const name = settings.userName || profile.full_name;
    const institutionalEmail = settings.institutionalEmail || profile.email;
    const masp = settings.masp || profile.masp;

    // Vínculo escolar por INEP
    const schoolInep = settings.schoolCode || (profile as any).inep_code;
    const schoolName = settings.institution || profile.school_name;

    const hasBasics = !!name && !!institutionalEmail && !!masp;
    const hasSchool = !!schoolInep && !!schoolName;

    return hasBasics && hasSchool;
};

