import { supabase } from './supabaseClient';
import { SchoolStats } from '../types';

export const SchoolService = {
  async getCities(): Promise<string[]> {
    try {
      const { data, error } = await supabase.rpc('get_cities');

      if (!error && data) {
        return data.map((item: { city?: string }) => item.city).filter(Boolean) as string[];
      }

      if (error) {
        console.warn('RPC get_cities failed, falling back to limited select:', error);
      }

      const { data: fallbackData } = await supabase.from('schools').select('city').order('city');

      if (!fallbackData) return [];

      return Array.from(new Set(fallbackData.map((item) => item.city).filter(Boolean))) as string[];
    } catch (err) {
      console.error('Error loading cities:', err);
      return [];
    }
  },

  async getSchoolsByCity(city: string): Promise<Array<{ id: string; name: string; city: string }>> {
    const { data, error } = await supabase
      .from('schools')
      .select('id, name, city')
      .eq('city', city)
      .order('name');

    if (error) {
      console.error('Error loading schools by city:', error);
      return [];
    }

    return data || [];
  },

  async resolveSchoolByIdOrInep(
    schoolIdOrInep: string
  ): Promise<{ id: string; name: string; inep_code?: string } | null> {
    const trimmed = schoolIdOrInep.trim();
    const isUuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(trimmed);

    const query = supabase
      .from('schools')
      .select('id, name, inep_code')
      .eq(isUuid ? 'id' : 'inep_code', trimmed)
      .single();

    const { data, error } = await query;

    if (error) {
      console.error('Error resolving school:', error);
      return null;
    }

    return data || null;
  },

  async getSchoolById(schoolId: string): Promise<{ id: string; name: string } | null> {
    const { data, error } = await supabase
      .from('schools')
      .select('id, name')
      .eq('id', schoolId)
      .maybeSingle();

    if (error) {
      console.error('Error fetching school by id:', error);
      return null;
    }

    return data || null;
  },

  /**
   * Get aggregated statistics for a school
   * @param schoolId - The unique identifier of the school
   * @returns Promise<SchoolStats> - Object containing total counts of students, teachers, classes, and PDI records
   * @example
   * const stats = await SchoolService.getSchoolStats('school-abc-123');
   */
  async getSchoolStats(schoolId: string): Promise<SchoolStats> {
    const { count: students } = await supabase
      .from('school_students')
      .select('*', { count: 'exact', head: true })
      .eq('school_id', schoolId);
    const { count: teachers } = await supabase
      .from('profiles')
      .select('*', { count: 'exact', head: true })
      .eq('school_id', schoolId)
      .eq('role', 'teacher');
    // Classes might need a school_id link or be inferred from teachers. For now, we might not have a direct school_id on classes unless we add it.
    // Assuming classes table has school_id or we filter by teachers in the school.
    // Let's assume we count unique classes linked to school's teachers for now or skip if complex.
    // Simplified:
    return {
      totalStudents: students || 0,
      totalTeachers: teachers || 0,
      totalClasses: 0, // Pending implementation
      pdiCount: 0, // Pending implementation
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
};
