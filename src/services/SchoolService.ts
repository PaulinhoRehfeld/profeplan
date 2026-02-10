import { supabase } from './supabaseClient';
import { SchoolStats } from '../types';

export const SchoolService = {
    /**
     * Get aggregated statistics for a school
     * @param schoolId - The unique identifier of the school
     * @returns Promise<SchoolStats> - Object containing total counts of students, teachers, classes, and PDI records
     * @example
     * const stats = await SchoolService.getSchoolStats('school-abc-123');
     */
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

    /**
     * Get paginated list of students in a school with optional search
     * @param schoolId - The unique identifier of the school
     * @param page - Page number (1-indexed)
     * @param limit - Results per page (default: 50)
     * @param search - Optional search term to filter by student name
     * @returns Promise - Supabase query response with students array or error
     * @example
     * const result = await SchoolService.getStudents('school-abc-123', 1, 20, 'João');
     */
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
        const { data, error } = await supabase
            .from('schools')
            .select('id, name, city, sre')
            .order('name');

        if (error) return { data: null, error };

        // Deduplicate: Keep first occurrence of each name
        // If same name appears multiple times, append city to differentiate
        const seenNames = new Map<string, number>();
        const deduplicated: Array<{ id: string; name: string }> = [];

        data?.forEach(school => {
            const baseName = school.name;
            const count = seenNames.get(baseName) || 0;
            seenNames.set(baseName, count + 1);

            // If it's a duplicate name, append city for clarity
            let displayName = baseName;
            if (count > 0 && school.city) {
                displayName = `${baseName} (${school.city})`;
            } else if (count > 0 && !school.city && school.sre) {
                displayName = `${baseName} (${school.sre})`;
            }

            // Only add if we haven't seen this exact id yet
            if (!deduplicated.some(s => s.id === school.id)) {
                deduplicated.push({
                    id: school.id,
                    name: displayName
                });
            }
        });

        return { data: deduplicated, error: null };
    }
};
