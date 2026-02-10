import { supabase } from '../supabaseClient';

export interface Student {
    id: string;
    school_id: string;
    state_unique_id?: string;
    name: string;
    current_class_id?: string;
    created_at?: string;
}

export const StudentService = {
    /**
     * Create a new student linked to a school
     */
    async createStudent(student: Omit<Student, 'id' | 'created_at'>): Promise<{ data: Student | null, error: any }> {
        const { data, error } = await supabase
            .from('students')
            .insert(student)
            .select()
            .single();

        return { data, error };
    },

    /**
     * Get all students for a specific school
     */
    async getStudentsBySchool(schoolId: string): Promise<{ data: Student[] | null, error: any }> {
        const { data, error } = await supabase
            .from('students')
            .select('*')
            .eq('school_id', schoolId)
            .order('name');

        return { data, error };
    },

    /**
     * Get a single student by ID
     */
    async getStudentById(id: string): Promise<{ data: Student | null, error: any }> {
        const { data, error } = await supabase
            .from('students')
            .select('*')
            .eq('id', id)
            .single();

        return { data, error };
    }
};
