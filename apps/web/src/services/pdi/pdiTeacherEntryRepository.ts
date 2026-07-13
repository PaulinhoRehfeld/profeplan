import { supabase } from '../supabaseClient';
import { TeacherEntry } from '../../types';

/**
 * Repositório de avaliações de professores (tabela pdi_teacher_entries).
 * Extraído de PdiDocumentService (Fase 2 — ver docs/REFACTORING_METHODOLOGY.md).
 */

type Block10EvaluationInput = {
  data: string;
  atividade_titulo: string;
  disciplina: string;
  professor_valor: number;
  professor_nota_alcancada: number;
  professor_id: string;
  professor_grau_autonomia?: string;
  ia_diagnostico?: string;
};

export async function saveTeacherEntry(
  entry: TeacherEntry
): Promise<{ data: TeacherEntry | null; error: unknown }> {
  const { data, error } = await supabase
    .from('pdi_teacher_entries')
    .upsert(entry, { onConflict: 'pdi_document_id, teacher_id, subject, bimester' })
    .select()
    .single();

  return { data, error };
}

export async function getTeacherEntries(
  pdiId: string
): Promise<{ data: TeacherEntry[] | null; error: unknown }> {
  const { data, error } = await supabase
    .from('pdi_teacher_entries')
    .select('*')
    .eq('pdi_document_id', pdiId);

  return { data, error };
}

export async function addBlock10Evaluation(
  pdiId: string,
  evaluation: Block10EvaluationInput
): Promise<{ data: TeacherEntry | null; error: unknown }> {
  return saveTeacherEntry({
    pdi_document_id: pdiId,
    teacher_id: evaluation.professor_id,
    bimester: 1,
    subject: evaluation.disciplina,
    autonomy_level: evaluation.professor_grau_autonomia,
    observations: evaluation.ia_diagnostico,
  });
}

export async function updateBlock10WithAI(
  pdiId: string,
  evaluationId: string,
  aiDiagnosis: string
): Promise<{ data: unknown; error: unknown }> {
  const { data, error } = await supabase
    .from('pdi_teacher_entries')
    .update({ observations: aiDiagnosis })
    .eq('id', evaluationId);
  return { data, error };
}
