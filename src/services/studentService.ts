/**
 * This file consolidates all student-related operations.
 * It replaces the legacy StudentService.ts (PascalCase).
 */
import { supabase } from './supabaseClient';

/**
 * CONSOLIDATED StudentService Module
 * 
 * Merges:
 * - src/services/studentService.ts (primary)
 * - src/services/pdi/StudentService.ts (archived)
 * 
 * Single source of truth for all student operations
 */

// Types
export interface Student {
    id: string;
    name: string;
    student_code?: string;
    current_school_id: string;
    school_id?: string; // Alias for compatibility
    class_id?: string;
    current_class_id?: string; // Alias for compatibility
    state_unique_id?: string; // For state-level tracking
    serie?: string; // Legacy support
    pdi_needs?: string[];
    observations?: string;
    deficiencies?: string[]; // Extended field support
    pedagogical_observations?: string; // Extended field support
    created_at: string;
}

export interface CreateStudentDTO {
    name: string;
    student_code?: string;
    current_school_id: string;
    school_id?: string; // Alternative field
    class_id?: string;
    current_class_id?: string; // Alternative field
    state_unique_id?: string;
    pdi_needs?: string[];
    observations?: string;
}

/**
 * Get all students for a school
 * Supports both 'school_id' and 'current_school_id' field names
 */
export const getStudentsBySchool = async (schoolId: string): Promise<Student[]> => {
    try {
        const { data, error } = await supabase
            .from('students')
            .select('*')
            .eq('current_school_id', schoolId)
            .order('name');

        if (error) {
            console.error('Error fetching students by school:', error);
            return [];
        }

        return data || [];
    } catch (error) {
        console.error('Exception in getStudentsBySchool:', error);
        return [];
    }
};

/**
 * Get a single student by ID
 * Supports both field naming conventions
 */
export const getStudentById = async (studentId: string): Promise<Student | null> => {
    try {
        const { data, error } = await supabase
            .from('students')
            .select('*')
            .eq('id', studentId)
            .single();

        if (error && error.code !== 'PGRST116') { // PGRST116 = no rows
            console.error('Error fetching student by ID:', error);
            return null;
        }

        return data || null;
    } catch (error) {
        console.error('Exception in getStudentById:', error);
        return null;
    }
};

/**
 * Create a new student
 * Auto-generates student_code if not provided
 */
export const createStudent = async (studentData: CreateStudentDTO): Promise<{ success: boolean; data?: Student; error?: string }> => {
    try {
        // Normalize school_id field
        const normalizedData = {
            ...studentData,
            current_school_id: studentData.current_school_id || studentData.school_id,
            student_code: studentData.student_code || `STD${Date.now()}${Math.floor(Math.random() * 1000)}`
        };

        delete (normalizedData as any).school_id; // Remove alias field

        const { data, error } = await supabase
            .from('students')
            .insert([normalizedData])
            .select()
            .single();

        if (error) {
            console.error('Error creating student:', error);
            return { success: false, error: error.message };
        }

        return { success: true, data };
    } catch (error: any) {
        console.error('Exception in createStudent:', error);
        return { success: false, error: error.message };
    }
};

/**
 * Update student information
 * Partial update - only provided fields are changed
 */
export const updateStudent = async (
    studentId: string,
    updates: Partial<Student>
): Promise<{ success: boolean; error?: string }> => {
    try {
        const { error } = await supabase
            .from('students')
            .update(updates)
            .eq('id', studentId);

        if (error) {
            console.error('Error updating student:', error);
            return { success: false, error: error.message };
        }

        return { success: true };
    } catch (error: any) {
        console.error('Exception in updateStudent:', error);
        return { success: false, error: error.message };
    }
};

/**
 * Archive and Delete a student (Safe Delete with RPC)
 * Records reason and details before archiving
 */
export const archiveStudent = async (
    studentId: string,
    reason: string,
    details: string
): Promise<{ success: boolean; error?: string }> => {
    try {
        const { data, error } = await supabase.rpc('archive_and_delete_student', {
            p_student_id: studentId,
            p_reason: reason,
            p_details: details
        });

        if (error) {
            console.error('Error archiving student:', error);
            return { success: false, error: error.message };
        }

        // RPC returns JSONB { success: boolean, error?: string }
        if (data && !data.success) {
            return { success: false, error: data.error };
        }

        return { success: true };
    } catch (error: any) {
        console.error('Exception in archiveStudent:', error);
        return { success: false, error: error.message };
    }
};
