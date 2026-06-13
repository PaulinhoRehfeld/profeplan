import { supabase } from './supabaseClient';
import { TeacherSchoolLink } from '../types';
import { normalizeInepCode } from '../utils/inepUtils';

const getErrorMessage = (error: unknown): string =>
    error instanceof Error ? error.message : 'Unknown error';

type TeacherSchoolRow = {
    id: string;
    teacher_id: string;
    school_id: string;
    role: string;
    disciplines?: string[];
    started_at: string;
    ended_at?: string | null;
    schools?: {
        name?: string;
        inep_code?: string;
    };
};

type SchoolTeacherRow = {
    id: string;
    role: string;
    disciplines?: string[];
    started_at: string;
    profiles?: {
        id?: string;
        full_name?: string;
        email?: string;
        masp?: string;
        created_at?: string;
    };
};

interface SchoolTeacher {
    link_id: string;
    id?: string;
    teacher_id?: string;
    full_name?: string;
    email?: string;
    masp?: string;
    created_at?: string;
    role: string;
    disciplines?: string[];
    started_at: string;
    link_started_at?: string;
}

/**
 * Service para gerenciar vínculos entre professores e escolas
 * Suporta professores em múltiplas escolas
 * NOTA: teacher_id = UUID (string), school_id = TEXT (string)
 */

/**
 * Obtém todas as escolas vinculadas a um professor (vínculos ativos)
 */
export const getTeacherSchools = async (teacherId: string): Promise<TeacherSchoolLink[]> => {
    try {
        const { data, error } = await supabase
            .from('teacher_schools')
            .select(`
                id,
                teacher_id,
                school_id,
                role,
                disciplines,
                started_at,
                ended_at,
                schools (
                    name,
                    inep_code
                )
            `)
            .eq('teacher_id', teacherId)
            .is('ended_at', null) // Apenas vínculos ativos
            .order('started_at', { ascending: false });

        if (error) throw error;

        // Flatten schools object
        return (data as TeacherSchoolRow[] | null || []).map((link) => ({
            id: link.id,
            teacher_id: link.teacher_id,
            school_id: link.school_id,
            school_name: link.schools?.name,
            school_inep: link.schools?.inep_code,
            role: link.role as "teacher" | "coordinator" | "principal",
            disciplines: link.disciplines || [],
            started_at: link.started_at,
            ended_at: link.ended_at
        }));
    } catch (err) {
        console.error('[teacherSchoolService] Error fetching teacher schools:', err);
        return [];
    }
};

/**
 * Obtém professores ativos vinculados a uma escola
 */
export const getActiveTeachersBySchool = async (schoolId: string): Promise<SchoolTeacher[]> => {
    try {
        const { data, error } = await supabase
            .from('teacher_schools')
            .select(`
                id,
                role,
                disciplines,
                started_at,
                profiles (
                    id,
                    full_name,
                    email,
                    masp,
                    created_at
                )
            `)
            .eq('school_id', schoolId)
            .is('ended_at', null)
            .order('started_at', { ascending: false });

        if (error) throw error;

        return (data as SchoolTeacherRow[] | null || [])
            .filter((link) => link.profiles)
            .map((link) => ({
                link_id: link.id,
                id: link.profiles?.id,
                teacher_id: link.profiles?.id,
                full_name: link.profiles?.full_name,
                email: link.profiles?.email,
                masp: link.profiles?.masp,
                created_at: link.profiles?.created_at,
                role: link.role,
                disciplines: link.disciplines || [],
                started_at: link.started_at,
                link_started_at: link.started_at
            }));
    } catch (err) {
        console.error('[teacherSchoolService] Error fetching teachers by school:', err);
        return [];
    }
};

/**
 * Cria um vínculo entre professor e escola
 * Usado quando professor digita INEP ou quando gestor convida por MASP
 */
export const createTeacherSchoolLink = async (
    teacherId: string,
    schoolId: string,
    options?: {
        role?: 'teacher' | 'coordinator' | 'principal';
        disciplines?: string[];
    }
): Promise<{ success: boolean; error?: string; linkId?: string }> => {
    try {
        // 1. Verificar se vínculo já existe (ativo)
        const { data: existing } = await supabase
            .from('teacher_schools')
            .select('id')
            .eq('teacher_id', teacherId)
            .eq('school_id', schoolId)
            .is('ended_at', null)
            .maybeSingle();

        if (existing) {
            return { success: true, linkId: existing.id }; // Já existe, não faz nada
        }

        // 2. Criar novo vínculo
        const { data, error } = await supabase
            .from('teacher_schools')
            .insert({
                teacher_id: teacherId,
                school_id: schoolId,
                role: options?.role || 'teacher',
                disciplines: options?.disciplines || []
            })
            .select('id')
            .single();

        if (error) throw error;

        console.log('[teacherSchoolService] ✅ Link created:', teacherId, '<->', schoolId);
        return { success: true, linkId: data.id };
    } catch (err: unknown) {
        console.error('[teacherSchoolService] Error creating link:', err);
        return { success: false, error: getErrorMessage(err) };
    }
};

/**
 * Atualiza um vínculo existente (ex: adicionar disciplinas, mudar cargo)
 */
export const updateTeacherSchoolLink = async (
    linkId: string,
    updates: {
        role?: 'teacher' | 'coordinator' | 'principal';
        disciplines?: string[];
    }
): Promise<{ success: boolean; error?: string }> => {
    try {
        const { error } = await supabase
            .from('teacher_schools')
            .update(updates)
            .eq('id', linkId);

        if (error) throw error;

        return { success: true };
    } catch (err: unknown) {
        console.error('[teacherSchoolService] Error updating link:', err);
        return { success: false, error: getErrorMessage(err) };
    }
};

/**
 * Remove um vínculo (marca como ended_at = NOW)
 * Não deleta fisicamente para manter histórico
 */
export const endTeacherSchoolLink = async (linkId: string): Promise<{ success: boolean; error?: string }> => {
    try {
        const { error } = await supabase
            .from('teacher_schools')
            .update({ ended_at: new Date().toISOString() })
            .eq('id', linkId);

        if (error) throw error;

        return { success: true };
    } catch (err: unknown) {
        console.error('[teacherSchoolService] Error ending link:', err);
        return { success: false, error: getErrorMessage(err) };
    }
};

/**
 * Limpa todos os vínculos ativos de um professor
 * Usado para re-sincronizar o perfil e remover escolas antigas
 */
export const clearTeacherSchoolLinks = async (teacherId: string): Promise<{ success: boolean; error?: string }> => {
    try {
        const { error } = await supabase
            .from('teacher_schools')
            .update({ ended_at: new Date().toISOString() })
            .eq('teacher_id', teacherId)
            .is('ended_at', null);

        if (error) throw error;

        return { success: true };
    } catch (err: unknown) {
        console.error('[teacherSchoolService] Error clearing links:', err);
        return { success: false, error: getErrorMessage(err) };
    }
};

/**
 * RECONCILIAÇÃO: Busca e vincula professor por INEP
 * Chamado quando professor preenche código INEP no perfil
 */
export const reconcileTeacherByInep = async (
    teacherId: string,
    inepCode: string
): Promise<{ success: boolean; schoolId?: string; schoolName?: string; error?: string }> => {
    try {
        console.log('[teacherSchoolService] 🔍 Reconciling teacher:', teacherId, 'with INEP:', inepCode);

        // NOVO: Normalizar INEP (adiciona prefixo 31 se necessário)
        const normalizationResult = normalizeInepCode(inepCode);

        if (!normalizationResult.isValid) {
            console.error('[teacherSchoolService] ❌ Invalid INEP format:', normalizationResult.error);
            return {
                success: false,
                error: normalizationResult.error || 'Formato de INEP inválido'
            };
        }

        const normalizedInep = normalizationResult.normalized;
        console.log('[teacherSchoolService] ✅ INEP normalized:', `"${inepCode}" → "${normalizedInep}"`);

        // 1. Buscar escola pelo INEP normalizado
        console.log('[teacherSchoolService] Searching for INEP:', `"${normalizedInep}"`, 'Length:', normalizedInep.length);

        const { data: school, error: schoolError } = await supabase
            .from('schools')
            .select('id, name, inep_code')
            .eq('inep_code', normalizedInep)
            .maybeSingle();

        console.log('[teacherSchoolService] School query result:', { school, error: schoolError });

        if (schoolError) {
            console.error('[teacherSchoolService] School query error:', schoolError);
            throw schoolError;
        }

        if (!school) {
            console.warn('[teacherSchoolService] ⚠️ School not found. INEP searched:', normalizedInep);

            // DEBUG: Buscar todas as escolas para comparar
            const { data: allSchools } = await supabase
                .from('schools')
                .select('inep_code')
                .limit(5);
            console.log('[teacherSchoolService] Sample of existing INEPs in database:', allSchools?.map(s => `"${s.inep_code}"`));

            return {
                success: false,
                error: `Escola com INEP ${normalizedInep} (original: ${inepCode}) não encontrada no sistema.`
            };
        }

        console.log('[teacherSchoolService] ✅ School found:', school.name, 'ID:', school.id);

        // 2. Criar vínculo na tabela teacher_schools
        const linkResult = await createTeacherSchoolLink(teacherId, school.id);

        if (!linkResult.success) {
            return { success: false, error: linkResult.error };
        }

        // 3. IMPORTANTE: NÃO sobrescrever active_school_id se já existir
        // Apenas define se estiver vazio (NULL ou undefined)
        const { data: currentProfile } = await supabase
            .from('profiles')
            .select('active_school_id')
            .eq('id', teacherId)
            .single();

        // Só atualiza active_school_id se ainda não tiver (primeira escola)
        if (!currentProfile?.active_school_id) {
            console.log('[teacherSchoolService] 🏫 Setting first active school:', school.name);
            const { error: updateError } = await supabase
                .from('profiles')
                .update({ active_school_id: school.id })
                .eq('id', teacherId);

            if (updateError) console.warn('[teacherSchoolService] Failed to set active_school_id:', updateError);
        } else {
            console.log('[teacherSchoolService] ℹ️ active_school_id already set, not overwriting:', currentProfile.active_school_id);
        }

        return {
            success: true,
            schoolId: school.id,
            schoolName: school.name
        };
    } catch (err: unknown) {
        console.error('[teacherSchoolService] Error in reconciliation:', err);
        return { success: false, error: getErrorMessage(err) };
    }
};

/**
 * GESTÃO ESCOLAR: Busca professores vinculados a uma escola
 */
export const getSchoolTeachers = async (schoolId: string): Promise<SchoolTeacher[]> => {
    try {
        const { data, error } = await supabase
            .from('teacher_schools')
            .select(`
                id,
                role,
                disciplines,
                started_at,
                profiles (
                    id,
                    full_name,
                    email,
                    masp
                )
            `)
            .eq('school_id', schoolId)
            .is('ended_at', null)
            .order('started_at', { ascending: false });

        if (error) throw error;

        return (data as SchoolTeacherRow[] | null || []).map((link) => ({
            link_id: link.id,
            teacher_id: link.profiles?.id,
            name: link.profiles?.full_name,
            email: link.profiles?.email,
            masp: link.profiles?.masp,
            role: link.role,
            disciplines: link.disciplines,
            started_at: link.started_at
        }));
    } catch (err) {
        console.error('[teacherSchoolService] Error fetching school teachers:', err);
        return [];
    }
};

/**
 * CONVITE POR MASP: Gestor adiciona professor à escola pelo MASP
 */
export const inviteTeacherByMasp = async (
    schoolId: string,
    masp: string
): Promise<{ success: boolean; teacherName?: string; error?: string }> => {
    try {
        // 1. Buscar professor pelo MASP
        const { data: teacher, error: teacherError } = await supabase
            .from('profiles')
            .select('id, full_name, email')
            .eq('masp', masp.trim())
            .eq('role', 'teacher')
            .maybeSingle();

        if (teacherError) throw teacherError;

        if (!teacher) {
            return {
                success: false,
                error: `Professor com MASP ${masp} não encontrado no sistema.`
            };
        }

        // 2. Criar vínculo
        const linkResult = await createTeacherSchoolLink(teacher.id, schoolId);

        if (!linkResult.success) {
            return { success: false, error: linkResult.error };
        }

        return {
            success: true,
            teacherName: teacher.full_name
        };
    } catch (err: unknown) {
        console.error('[teacherSchoolService] Error inviting teacher:', err);
        return { success: false, error: getErrorMessage(err) };
    }
};

/**
 * Busca os gestores (managers) de uma escola específica
 * Gestores são identificados pelo role 'manager' na tabela profiles
 */
export const getSchoolManagers = async (schoolId: string): Promise<{
    success: boolean;
    managers?: Array<{
        id: string;
        full_name: string;
        email: string;
        role: string;
    }>;
    error?: string;
}> => {
    try {
        // A-5: Query via teacher_schools JOIN profiles instead of the legacy profiles.school_id field.
        // This ensures managers registered through the new linkage system are found.
        const { data, error } = await supabase
            .from('teacher_schools')
            .select(`
                profiles!teacher_schools_teacher_id_fkey (
                    id,
                    full_name,
                    email,
                    role
                )
            `)
            .eq('school_id', schoolId)
            .is('ended_at', null); // Only active links

        if (error) throw error;

        // Filter to only managers and flatten from the join
        const managers = (data || [])
            .map((row: any) => row.profiles)
            .filter((p: any) => p && p.role === 'manager');

        return { success: true, managers };
    } catch (err: unknown) {
        console.error('[teacherSchoolService] Error fetching school managers:', err);
        return { success: false, error: getErrorMessage(err) };
    }
};

/**
 * Busca o gestor da escola ativa do professor
 * Retorna o primeiro gestor encontrado (caso haja múltiplos)
 */
export const getTeacherSchoolManager = async (
    teacherId: string,
    schoolId?: string
): Promise<{
    success: boolean;
    manager?: {
        id: string;
        full_name: string;
        email: string;
    };
    schoolName?: string;
    error?: string;
}> => {
    try {
        let targetSchoolId = schoolId;

        // Se não foi fornecido schoolId, buscar a escola ativa do professor
        if (!targetSchoolId) {
            const { data: activeLink } = await supabase
                .from('teacher_schools')
                .select('school_id, schools(name)')
                .eq('teacher_id', teacherId)
                .is('ended_at', null)
                .order('started_at', { ascending: false })
                .limit(1)
                .maybeSingle();

            if (!activeLink) {
                return {
                    success: false,
                    error: 'Professor não possui escola ativa vinculada'
                };
            }

            targetSchoolId = activeLink.school_id;
        }

        // Buscar gestor da escola
        const managersResult = await getSchoolManagers(targetSchoolId);

        if (!managersResult.success || !managersResult.managers || managersResult.managers.length === 0) {
            return {
                success: false,
                error: 'Nenhum gestor encontrado para esta escola'
            };
        }

        // Retornar o primeiro gestor
        const manager = managersResult.managers[0];

        // Buscar nome da escola
        const { data: schoolData } = await supabase
            .from('schools')
            .select('name')
            .eq('id', targetSchoolId)
            .single();

        return {
            success: true,
            manager: {
                id: manager.id,
                full_name: manager.full_name,
                email: manager.email
            },
            schoolName: schoolData?.name
        };
    } catch (err: unknown) {
        console.error('[teacherSchoolService] Error fetching teacher school manager:', err);
        return { success: false, error: getErrorMessage(err) };
    }
};
