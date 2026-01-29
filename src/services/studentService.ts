import { supabase } from './supabaseClient';

// Types
export interface Student {
    id: string;
    name: string;
    student_code?: string;
    current_school_id: string;
    class_id?: string; // Added class_id
    serie?: string; // Keep for legacy, but we might rely on class link
    pdi_needs?: string[]; // New: Array of needs
    observations?: string; // New: Pedagogical observations
    created_at: string;
}

export interface CreateStudentDTO {
    name: string;
    student_code?: string;
    current_school_id: string;
    class_id?: string;
    pdi_needs?: string[];
    observations?: string;
}

/**
 * Get all students for a school
 */
export const getStudentsBySchool = async (schoolId: string): Promise<Student[]> => {
    const { data, error } = await supabase
        .from('students')
        .select('*')
        .eq('current_school_id', schoolId)
        .order('name');

    if (error) {
        console.error('Error fetching students:', error);
        return [];
    }

    return data || [];
};

/**
 * Create a new student
 */
export const createStudent = async (studentData: CreateStudentDTO): Promise<{ success: boolean; data?: Student; error?: string }> => {
    // Generate student code if not provided
    const studentCode = studentData.student_code || `STD${Date.now()}`;

    const { data, error } = await supabase
        .from('students')
        .insert([{
            ...studentData,
            student_code: studentCode
        }])
        .select()
        .single();

    if (error) {
        return { success: false, error: error.message };
    }

    return { success: true, data };
};

/**
 * Update student information
 */
export const updateStudent = async (
    studentId: string,
    updates: Partial<Student>
): Promise<{ success: boolean; error?: string }> => {
    const { error } = await supabase
        .from('students')
        .update(updates)
        .eq('id', studentId);

    if (error) {
        return { success: false, error: error.message };
    }

    return { success: true };
};

/**
 * Archive and Delete a student (Safe Delete)
 */
export const archiveStudent = async (
    studentId: string,
    reason: string,
    details: string
): Promise<{ success: boolean; error?: string }> => {
    const { data, error } = await supabase.rpc('archive_and_delete_student', {
        p_student_id: studentId,
        p_reason: reason,
        p_details: details
    });

    if (error) {
        return { success: false, error: error.message };
    }

    // RPC returns JSONB { success: boolean, error?: string }
    // Supabase returns it as 'data'
    if (data && !data.success) {
        return { success: false, error: data.error };
    }

    return { success: true };
};
