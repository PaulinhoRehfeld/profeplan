import { supabase } from './supabaseClient';

export interface SchoolStats {
    totalStudents: number;
    totalTeachers: number;
    totalClasses: number;
    pdiCount: number;
}

export const SchoolService = {
    async getSchoolStats(schoolId: string): Promise<SchoolStats> {
        const { count: students } = await supabase.from('school_students').select('*', { count: 'exact', head: true }).eq('school_id', schoolId);
        const { count: teachers } = await supabase.from('profiles').select('*', { count: 'exact', head: true }).eq('school_id', schoolId).eq('role', 'teacher');
        // Classes might need a school_id link or be inferred from teachers. For now, we might not have a direct school_id on classes unless we add it. 
        // Assuming classes table has school_id or we filter by teachers in the school.
        // Let's assume we count unique classes linked to school's teachers for now or skip if complex.
        // Simplified:
        return {
            totalStudents: students || 0,
            totalTeachers: teachers || 0,
            totalClasses: 0, // Pending implementation
            pdiCount: 0 // Pending implementation
        };
    },

    async getStudents(schoolId: string, page = 1, limit = 50, search = '') {
        let query = supabase
            .from('school_students')
            .select('*')
            .eq('school_id', schoolId)
            .order('name');

        if (search) {
            query = query.ilike('name', `%${search}%`);
        }

        const from = (page - 1) * limit;
        const to = from + limit - 1;

        return query.range(from, to);
    },

    async getTeachers(schoolId: string) {
        return supabase
            .from('profiles')
            .select('id, email, role, created_at') // Add other accessible public fields
            .eq('school_id', schoolId)
            .eq('role', 'teacher');
    },

    async checkStudentTransfer(schoolId: string, studentCode: string) {
        // Logic to find if a student with this code exists in the school but maybe different class?
        // Actually, school_students is the master list. 
        // If we talk about "Transfers", we mean moving between "classes" (the teacher's classes).
        // Return existing student if found.
        if (!studentCode) return null;

        const { data } = await supabase
            .from('school_students')
            .select('*')
            .eq('school_id', schoolId)
            .eq('student_code', studentCode)
            .single();

        return data;
    },

    async getAllSchools() {
        return supabase
            .from('schools')
            .select('id, name')
            .order('name');
    }
};
