import { supabase } from './supabaseClient';

type SchoolStudentRecord = {
    id: string;
    pdi_data?: unknown;
};

export const getSchoolStudentById = async (schoolStudentId: string): Promise<SchoolStudentRecord | null> => {
    const { data, error } = await supabase
        .from('school_students')
        .select('id, pdi_data')
        .eq('id', schoolStudentId)
        .maybeSingle();

    if (error) {
        console.error('Error fetching school student by id:', error);
        return null;
    }

    return data || null;
};

export const findSchoolStudentBySchoolAndName = async (
    schoolId: string,
    studentName: string
): Promise<SchoolStudentRecord | null> => {
    const normalized = (studentName || '').trim();
    if (!normalized) return null;

    // 1) Tentativa por igualdade case-insensitive (trim aplicado)
    const { data: exact, error: exactErr } = await supabase
        .from('school_students')
        .select('id')
        .eq('school_id', schoolId)
        .ilike('name', normalized)
        .maybeSingle();

    if (!exactErr && exact?.id) return exact;
    if (exactErr) {
        console.error('Error fetching school student by school/name (exact ilike):', exactErr);
    }

    // 2) Fallback: match parcial (reduz risco de diferenças mínimas de normalização)
    const { data: partial, error: partialErr } = await supabase
        .from('school_students')
        .select('id')
        .eq('school_id', schoolId)
        .ilike('name', `%${normalized}%`)
        .maybeSingle();

    if (partialErr) {
        console.error('Error fetching school student by school/name (partial ilike):', partialErr);
        return null;
    }

    return partial || null;
};

export const createSchoolStudent = async (
    schoolId: string,
    studentName: string
): Promise<SchoolStudentRecord | null> => {
    const { data: authData, error: authError } = await supabase.auth.getUser();

    if (authError) {
        console.error('Error fetching auth user:', authError);
        return null;
    }

    const createdBy = authData.user?.id;

    const { data, error } = await supabase
        .from('school_students')
        .insert([{
            school_id: schoolId,
            name: studentName,
            created_by: createdBy,
            pdi_data: {}
        }])
        .select('id, pdi_data')
        .single();

    if (error) {
        console.error('Error creating school student:', error);
        return null;
    }

    return data || null;
};

export const updateSchoolStudentPdiData = async (
    schoolStudentId: string,
    pdiData: Record<string, unknown>
): Promise<{ success: boolean; error?: string }> => {
    const { error } = await supabase
        .from('school_students')
        .update({ pdi_data: pdiData })
        .eq('id', schoolStudentId);

    if (error) {
        console.error('Error updating school student PDI:', error);
        return { success: false, error: error.message };
    }

    return { success: true };
};
