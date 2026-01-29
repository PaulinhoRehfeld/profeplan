import { supabase } from './supabaseClient';

// Types
export interface Class {
    id: string;
    school_id: string;
    name: string;
    grade?: string;
    year: number;
    shift?: string;
    room?: string;
    created_at: string;
    updated_at: string;
}

export interface CreateClassDTO {
    school_id: string;
    name: string;
    grade?: string;
    year?: number;
    shift?: string;
    room?: string;
}

/**
 * Get all classes for a school
 */
export const getClassesBySchool = async (schoolId: string): Promise<Class[]> => {
    const { data, error } = await supabase
        .from('classes')
        .select('*')
        .eq('school_id', schoolId)
        .order('name');

    if (error) {
        console.error('Error fetching classes:', error);
        return [];
    }

    return data || [];
};

/**
 * Create a new class
 */
export const createClass = async (classData: CreateClassDTO): Promise<{ success: boolean; data?: Class; error?: string }> => {
    const { data, error } = await supabase
        .from('classes')
        .insert([{
            ...classData,
            year: classData.year || new Date().getFullYear()
        }])
        .select()
        .single();

    if (error) {
        return { success: false, error: error.message };
    }

    return { success: true, data };
};

/**
 * Get students in a class
 */
export const getStudentsByClass = async (classId: string) => {
    const { data, error } = await supabase
        .from('students')
        .select('*')
        .eq('class_id', classId)
        .order('name');

    if (error) {
        console.error('Error fetching students:', error);
        return [];
    }

    return data || [];
};

/**
 * Import students to a class (bulk insert)
 */
export const importStudentsToClass = async (
    classId: string,
    students: Array<{ name: string; student_code?: string; special_needs?: string }>
): Promise<{ success: boolean; count: number; error?: string }> => {
    const studentsToInsert = students.map(student => ({
        ...student,
        class_id: classId,
        student_code: student.student_code || `STD${Date.now()}${Math.floor(Math.random() * 1000)}`
    }));

    const { data, error } = await supabase
        .from('students')
        .insert(studentsToInsert)
        .select();

    if (error) {
        return { success: false, count: 0, error: error.message };
    }

    return { success: true, count: data?.length || 0 };
};

/**
 * Update class info
 */
export const updateClass = async (classId: string, updates: Partial<Class>): Promise<{ success: boolean; error?: string }> => {
    const { error } = await supabase
        .from('classes')
        .update(updates)
        .eq('id', classId);

    if (error) {
        return { success: false, error: error.message };
    }

    return { success: true };
};

/**
 * Delete class
 */
export const deleteClass = async (classId: string): Promise<{ success: boolean; error?: string }> => {
    const { error } = await supabase
        .from('classes')
        .delete()
        .eq('id', classId);

    if (error) {
        return { success: false, error: error.message };
    }

    return { success: true };
};

/**
 * Merge two classes
 */
export const mergeClasses = async (sourceClassId: string, targetClassId: string): Promise<{ success: boolean; message?: string; error?: string }> => {
    const { data, error } = await supabase.rpc('merge_classes', {
        p_source_class_id: sourceClassId,
        p_target_class_id: targetClassId
    });

    if (error) return { success: false, error: error.message };

    // RPC returns: { success: boolean, message?: string, error?: string }
    if (data && !data.success) return { success: false, error: data.error };

    return { success: true, message: data.message };
};
