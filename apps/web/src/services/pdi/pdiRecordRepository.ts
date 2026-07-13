import { supabase } from '../supabaseClient';
import { ProfileService } from '../ProfileService';

/**
 * Repositório de registros de PDI (tabelas pdi_records e pdi_logs).
 * Extraído de PdiDocumentService (Fase 2 — ver docs/REFACTORING_METHODOLOGY.md).
 */

export type PdiRecordType =
  | 'EVALUATION'
  | 'OCCURRENCE'
  | 'LESSON_PLAN'
  | 'OBSERVATION'
  | 'ADAPTATION';

type PdiRecordContent = Record<string, unknown>;

export interface PdiRecord {
  id: string;
  student_id: string;
  school_id: string;
  teacher_id: string;
  type: PdiRecordType;
  pdi_block?: string;
  title: string;
  content: PdiRecordContent;
  date: string;
  created_at: string;
}

export async function logEvent(
  studentId: string,
  type: PdiRecordType,
  title: string,
  content: PdiRecordContent,
  pdiBlock?: string,
  schoolIdOverride?: string | null,
  classIdOverride?: string | null,
  teacherIdOverride?: string | null
): Promise<PdiRecord | null> {
  try {
    const profile =
      schoolIdOverride && teacherIdOverride ? null : await ProfileService.getProfile();
    let schoolId =
      schoolIdOverride ?? (profile as any)?.active_school_id ?? (profile as any)?.school_id ?? null;
    const teacherId = teacherIdOverride ?? (profile as any)?.id ?? null;

    if (!schoolId) {
      try {
        if (classIdOverride) {
          const { data: clsRow, error: clsErr } = await supabase
            .from('classes')
            .select('school_id')
            .eq('id', classIdOverride)
            .maybeSingle();
          if (clsErr) {
            console.error('[pdiRecordRepository] Failed to resolve school_id from `classes`:', {
              classIdOverride,
              error: clsErr,
            });
          }
          const inferred = (clsRow as any)?.school_id ?? null;
          if (inferred) schoolId = inferred;
        }
      } catch {
        /* fail-silent */
      }
    }

    if (!schoolId) {
      console.error('[pdiRecordRepository] Missing school_id for pdi_records insert.', {
        studentId,
        type,
        teacherId,
      });
      return null;
    }

    const { data, error } = await supabase
      .from('pdi_records')
      .insert({
        student_id: studentId,
        school_id: schoolId,
        teacher_id: teacherId,
        type,
        title,
        content,
        pdi_block: pdiBlock,
        date: new Date().toISOString(),
      })
      .select()
      .single();

    if (error) {
      console.error('Error logging PDI event:', error);
      return null;
    }

    return data || null;
  } catch (error) {
    console.error('Exception in logEvent:', error);
    return null;
  }
}

export async function getStudentTimeline(studentId: string): Promise<PdiRecord[]> {
  try {
    const { data, error } = await supabase
      .from('pdi_records')
      .select('*')
      .eq('student_id', studentId)
      .order('date', { ascending: false });

    if (error) {
      console.error('Error fetching PDI timeline:', error);
      return [];
    }

    return data || [];
  } catch (error) {
    console.error('Exception in getStudentTimeline:', error);
    return [];
  }
}

export async function logEventForClass(
  classId: string,
  type: PdiRecordType,
  title: string,
  content: PdiRecordContent,
  pdiBlock?: string
): Promise<(PdiRecord | null)[]> {
  try {
    const profile = await ProfileService.getProfile();
    const teacherId = (profile as any)?.id ?? null;
    let schoolId = (profile as any)?.active_school_id ?? (profile as any)?.school_id ?? null;

    if (!schoolId) {
      const { data: clsRow } = await supabase
        .from('classes')
        .select('school_id')
        .eq('id', classId)
        .maybeSingle();
      schoolId = (clsRow as any)?.school_id ?? null;
    }

    const { data: students, error: studentsError } = await supabase
      .from('students')
      .select('id')
      .eq('class_id', classId);

    if (studentsError || !students) {
      console.error('Error fetching students:', studentsError);
      return [];
    }

    if (!schoolId) {
      console.warn(
        `[pdiRecordRepository] logEventForClass: school_id não resolvido para a turma ${classId}. Automação de PDI ignorada (${students.length} alunos).`
      );
      return [];
    }

    return Promise.all(
      students.map((s) =>
        logEvent(s.id, type, title, content, pdiBlock, schoolId, classId, teacherId)
      )
    );
  } catch (error) {
    console.error('Exception in logEventForClass:', error);
    return [];
  }
}

export async function updateRecordContent(
  recordId: string,
  newContent: PdiRecordContent
): Promise<{ success: boolean; error?: string }> {
  try {
    const { error } = await supabase
      .from('pdi_records')
      .update({ content: newContent })
      .eq('id', recordId);

    if (error) return { success: false, error: error.message };
    return { success: true };
  } catch (error: unknown) {
    console.error('Exception in updateRecordContent:', error);
    return { success: false, error: error instanceof Error ? error.message : 'Unknown error' };
  }
}

export async function getPdiLogs(
  studentId: string
): Promise<{ data: PdiRecord[] | null; error: unknown }> {
  try {
    const { data, error } = await supabase
      .from('pdi_records')
      .select('*')
      .eq('student_id', studentId)
      .order('date', { ascending: false });

    return { data, error };
  } catch (error) {
    return { data: null, error };
  }
}

export async function getLogs(
  studentId: string
): Promise<{ data: unknown[] | null; error: unknown }> {
  const { data, error } = await supabase
    .from('pdi_logs')
    .select('*')
    .eq('student_id', studentId)
    .order('created_at', { ascending: false });

  return { data, error };
}
