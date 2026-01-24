import { supabase } from './supabaseClient';

// Types
export interface Student {
    id: string;
    name: string;
    student_code?: string;
    current_school_id: string;
    serie?: string;
    special_needs?: string;
    created_at: string;
}

export interface CreateStudentDTO {
    name: string;
    student_code?: string;
    current_school_id: string;
    serie?: string;
    special_needs?: string;
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
    const studentCode = studentData.student_code || `STD${Date.now()}${Math.floor(Math.random() * 1000)}`;

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
 * Delete a student
 */
export const deleteStudent = async (studentId: string): Promise<{ success: boolean; error?: string }> => {
    const { error } = await supabase
        .from('students')
        .delete()
        .eq('id', studentId);

    if (error) {
        return { success: false, error: error.message };
    }

    return { success: true };
};
