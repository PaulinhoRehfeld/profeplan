import { supabase } from './supabaseClient';

// Types
export interface Teacher {
    id: string;
    email: string;
    full_name: string;
    masp?: string;
    school_id: string;
    role: string;
    created_at: string;
}

export interface InviteTeacherDTO {
    email: string;
    full_name: string;
    masp?: string;
    school_id: string;
}

export interface PendingTeacher {
    id: string;
    school_id: string;
    email_institucional: string;
    masp: string;
    full_name: string;
    status: 'pending' | 'matched' | 'expired';
    matched_profile_id?: string;
    created_at: string;
    matched_at?: string;
}

export interface CreatePendingTeacherDTO {
    school_id: string;
    email_institucional: string;
    masp: string;
    full_name: string;
}

/**
 * Get all teachers for a school
 */
export const getTeachersBySchool = async (schoolId: string): Promise<Teacher[]> => {
    const { data, error } = await supabase
        .from('profiles')
        .select('id, email, full_name, masp, school_id, role, created_at')
        .eq('school_id', schoolId)
        .eq('role', 'teacher')
        .order('full_name');

    if (error) {
        console.error('Error fetching teachers:', error);
        return [];
    }

    return data || [];
};

/**
 * Invite a teacher to join the school
 * Creates a profile entry that will be linked when the teacher signs up
 */
export const inviteTeacher = async (teacherData: InviteTeacherDTO): Promise<{ success: boolean; error?: string }> => {
    try {
        // Check if email already exists
        const { data: existingProfile } = await supabase
            .from('profiles')
            .select('id, email')
            .eq('email', teacherData.email)
            .single();

        if (existingProfile) {
            // Update existing profile with school info
            const { error: updateError } = await supabase
                .from('profiles')
                .update({
                    school_id: teacherData.school_id,
                    full_name: teacherData.full_name,
                    masp: teacherData.masp,
                    role: 'teacher'
                })
                .eq('email', teacherData.email);

            if (updateError) {
                return { success: false, error: updateError.message };
            }

            return { success: true };
        }

        // For new teachers, we'll create a pending invitation
        // When they sign up with this email, their profile will be linked to the school
        // Note: This requires a companion auth flow that checks for pending invitations

        return {
            success: false,
            error: 'Professor deve se cadastrar primeiro na plataforma. Envie o link de cadastro para o email fornecido.'
        };

    } catch (error: any) {
        return { success: false, error: error.message };
    }
};

/**
 * Update teacher information
 */
export const updateTeacher = async (
    teacherId: string,
    updates: Partial<Teacher>
): Promise<{ success: boolean; error?: string }> => {
    const { error } = await supabase
        .from('profiles')
        .update(updates)
        .eq('id', teacherId);

    if (error) {
        return { success: false, error: error.message };
    }

    return { success: true };
};

/**
 * Remove teacher from school (sets school_id to null)
 */
export const removeTeacherFromSchool = async (teacherId: string): Promise<{ success: boolean; error?: string }> => {
    const { error } = await supabase
        .from('profiles')
        .update({ school_id: null })
        .eq('id', teacherId);

    if (error) {
        return { success: false, error: error.message };
    }

    return { success: true };
};

/**
 * Create a pending teacher (pre-registration)
 * The teacher will be automatically linked when they sign up with matching email and MASP
 */
export const createPendingTeacher = async (data: CreatePendingTeacherDTO): Promise<{ success: boolean; data?: PendingTeacher; error?: string }> => {
    // Validate email format
    if (!data.email_institucional.endsWith('@educacao.mg.gov.br')) {
        return {
            success: false,
            error: 'Email deve ser institucional (@educacao.mg.gov.br)'
        };
    }

    const { data: result, error } = await supabase
        .from('pending_teachers')
        .insert([{
            ...data,
            created_by: (await supabase.auth.getUser()).data.user?.id
        }])
        .select()
        .single();

    if (error) {
        if (error.code === '23505') { // Unique violation
            return {
                success: false,
                error: 'Professor já cadastrado com este email e MASP'
            };
        }
        return { success: false, error: error.message };
    }

    return { success: true, data: result };
};

/**
 * Get all pending teachers for a school
 */
export const getPendingTeachersBySchool = async (schoolId: string): Promise<PendingTeacher[]> => {
    const { data, error } = await supabase
        .from('pending_teachers')
        .select('*')
        .eq('school_id', schoolId)
        .order('created_at', { ascending: false });

    if (error) {
        console.error('Error fetching pending teachers:', error);
        return [];
    }

    return data || [];
};

/**
 * Delete a pending teacher
 */
export const deletePendingTeacher = async (pendingTeacherId: string): Promise<{ success: boolean; error?: string }> => {
    const { error } = await supabase
        .from('pending_teachers')
        .delete()
        .eq('id', pendingTeacherId);

    if (error) {
        return { success: false, error: error.message };
    }

    return { success: true };
};

/**
 * Approve a pending teacher (Manually link profile)
 */
export const approveTeacher = async (pendingId: string): Promise<{ success: boolean; message?: string; error?: string }> => {
    const { data, error } = await supabase.rpc('approve_teacher', {
        p_pending_id: pendingId
    });

    if (error) return { success: false, error: error.message };

    // RPC returns: { success, message, error }
    if (data && !data.success) return { success: false, error: data.error };

    return { success: true, message: data.message };
};

