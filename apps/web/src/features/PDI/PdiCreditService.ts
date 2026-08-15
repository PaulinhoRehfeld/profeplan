import { supabase } from '../../services/supabaseClient';

export type GovernedPdiSaveResult = {
  saved?: boolean;
  outcome?: string;
  charged?: boolean;
  reason?: string;
  artifact_id?: string;
  pdi_record_id?: string;
  pdi_document_id?: string;
  canonical_table?: string;
};

export type GovernedPdiAdaptationInput = {
  artifactId: string;
  pdiDocumentId: string;
  studentId: string;
  lessonId: string;
  lessonTitle: string;
  subject: string;
  content: string;
  block9Payload: Record<string, unknown>;
};

const assertSaved = (result: GovernedPdiSaveResult | null, label: string) => {
  if (result?.saved) return result;

  if (result?.reason === 'INSUFFICIENT_CREDITS') {
    throw new Error(`Créditos insuficientes para salvar ${label}.`);
  }

  throw new Error(result?.reason || `Não foi possível salvar ${label}.`);
};

export const validatePdiAdaptationGoverned = async (
  input: GovernedPdiAdaptationInput
): Promise<GovernedPdiSaveResult> => {
  const { data, error } = await supabase.rpc('credit_validate_pdi_adaptation', {
    p_artifact_id: input.artifactId,
    p_pdi_document_id: input.pdiDocumentId,
    p_student_id: input.studentId,
    p_lesson_id: input.lessonId,
    p_lesson_title: input.lessonTitle,
    p_subject: input.subject,
    p_content: input.content,
    p_block9_payload: input.block9Payload,
  });

  if (error) throw error;
  return assertSaved(data as GovernedPdiSaveResult | null, 'esta adaptação PDI');
};

export const savePdiGeneratedReportGoverned = async (input: {
  artifactId: string;
  title: string;
  content: string;
}): Promise<GovernedPdiSaveResult> => {
  const { data, error } = await supabase.rpc('credit_save_pdi_generated_report', {
    p_artifact_id: input.artifactId,
    p_title: input.title,
    p_content: input.content,
  });

  if (error) throw error;
  return assertSaved(data as GovernedPdiSaveResult | null, 'este relatório PDI');
};

export const savePdiFinalReportGoverned = async (
  pdiDocumentId: string,
  content: string
): Promise<GovernedPdiSaveResult> => {
  const { data, error } = await supabase.rpc('credit_save_pdi_final_report', {
    p_pdi_document_id: pdiDocumentId,
    p_content: content,
  });

  if (error) throw error;
  return assertSaved(data as GovernedPdiSaveResult | null, 'o relatório final do PDI');
};
