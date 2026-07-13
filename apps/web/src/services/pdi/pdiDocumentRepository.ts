import { supabase } from '../supabaseClient';
import { PdiSchema, PDIProfileData } from '../../types/pdi-schema';
import { PdiDocument, UserProfile } from '../../types';
import { mapToCompatibility } from './pdiUtils';

/**
 * Repositório de documentos PDI (tabela pdi_documents).
 * Extraído de PdiDocumentService (Fase 2 — ver docs/REFACTORING_METHODOLOGY.md).
 */

type LegacyBlockData = {
  bloco_1_identificacao?: {
    nome_completo?: string;
    data_nascimento?: string;
    serie?: string;
    turma?: string;
    turno?: string;
  };
  bloco_2_diagnostico?: {
    laudo_medico?: string;
    restricoes_atividades?: string;
    medication?: string;
  };
};

export async function getOrCreatePdi(
  studentId: string,
  year: number = new Date().getFullYear(),
  contextualData?: { profile?: UserProfile | null; studentName?: string }
): Promise<{ data: PdiDocument | null; error: unknown }> {
  const { data: existing, error: fetchError } = await supabase
    .from('pdi_documents')
    .select('*')
    .eq('student_id', studentId)
    .eq('year', year)
    .maybeSingle();

  if (fetchError) return { data: null, error: fetchError };
  if (existing) return { data: existing, error: null };

  const initialContent: Partial<PDIProfileData> = {};

  if (contextualData?.profile) {
    initialContent.institutional = {
      school_name: contextualData.profile.school_name || contextualData.profile.school?.name,
      city: contextualData.profile.city || contextualData.profile.school?.city,
      sre: contextualData.profile.school?.sre,
    };
  }

  if (contextualData?.studentName) {
    initialContent.student_data = {
      name: contextualData.studentName,
    };
  }

  const { data: newDoc, error: createError } = await supabase
    .from('pdi_documents')
    .insert({
      student_id: studentId,
      year,
      status: 'em_andamento',
      content_data: initialContent,
    })
    .select()
    .single();

  return { data: newDoc, error: createError };
}

export async function createPdiDocument(
  studentId: string,
  _schoolId: string,
  year: number
): Promise<{ data: PdiDocument | null; error: unknown }> {
  return getOrCreatePdi(studentId, year);
}

export async function getPdiDocument(
  pdiId: string
): Promise<{ data: PdiDocument | null; error: unknown }> {
  const { data, error } = await supabase
    .from('pdi_documents')
    .select(
      `
            *,
            school_students:students (name, current_school_id)
        `
    )
    .eq('id', pdiId)
    .maybeSingle();

  return {
    data: data ? mapToCompatibility(data) : null,
    error,
  };
}

export async function updatePdiSection(
  pdiId: string,
  sectionKey: keyof PDIProfileData,
  sectionData: unknown
): Promise<{ data: PdiDocument | null; error: unknown }> {
  try {
    const SectionSchema = PdiSchema.shape[sectionKey];
    const validatedData = SectionSchema.parse(sectionData);

    const { data: currentPdi, error: fetchError } = await supabase
      .from('pdi_documents')
      .select('content_data')
      .eq('id', pdiId)
      .single();

    if (fetchError) throw fetchError;

    const currentContent = currentPdi?.content_data || {};
    const updatedContent = {
      ...currentContent,
      [sectionKey]: validatedData,
    };

    const { data: updatedPdi, error: updateError } = await supabase
      .from('pdi_documents')
      .update({
        content_data: updatedContent,
        updated_at: new Date().toISOString(),
      })
      .eq('id', pdiId)
      .select()
      .single();

    return { data: updatedPdi, error: updateError };
  } catch (validationOrDbError: unknown) {
    console.error('PDI Update Error:', validationOrDbError);
    return { data: null, error: validationOrDbError };
  }
}

export async function updateBlock1to8(
  pdiId: string,
  blockData: LegacyBlockData
): Promise<{ data: PdiDocument | null; error: unknown }> {
  const updates: Partial<PDIProfileData> = {};

  if (blockData.bloco_1_identificacao) {
    const b1 = blockData.bloco_1_identificacao;
    updates.student_data = {
      name: b1.nome_completo,
      dob: b1.data_nascimento,
      school_year: b1.serie,
      class_name: b1.turma,
      shift: b1.turno,
    };
  }

  if (blockData.bloco_2_diagnostico) {
    const b2 = blockData.bloco_2_diagnostico;
    updates.clinical_health = {
      diagnosis_cid: b2.laudo_medico,
      medical_updates: b2.restricoes_atividades,
      medication: b2.medication,
    };
  }

  const { data, error } = await supabase
    .from('pdi_documents')
    .update({
      content_data: updates,
      updated_at: new Date().toISOString(),
    })
    .eq('id', pdiId)
    .select()
    .single();

  return { data: data ? mapToCompatibility(data) : null, error };
}

export async function getSchoolPdis(schoolId: string): Promise<PdiDocument[]> {
  const { data, error } = await supabase
    .from('pdi_documents')
    .select(
      `
            *,
            school_students:students!inner (
                name,
                current_school_id
            )
        `
    )
    .eq('school_students.current_school_id', schoolId)
    .order('updated_at', { ascending: false });

  if (error) {
    console.error('Error fetching School PDIs:', error);
    return [];
  }

  return (data || []) as unknown as PdiDocument[];
}

export async function updateBlock11ByProgument(
  pdiId: string,
  reportText: string
): Promise<{ data: unknown; error: unknown }> {
  const { data, error } = await supabase
    .from('pdi_documents')
    .update({ final_report: reportText, updated_at: new Date().toISOString() })
    .eq('id', pdiId)
    .select()
    .single();
  return { data, error };
}

export async function approveBlock11(
  pdiId: string,
  _approvedBy: string
): Promise<{ data: unknown; error: unknown }> {
  const { data, error } = await supabase
    .from('pdi_documents')
    .update({
      status: 'finalizado',
      updated_at: new Date().toISOString(),
    })
    .eq('id', pdiId)
    .select()
    .single();
  return { data, error };
}
