import { supabase } from '../supabaseClient';
import { checkUsageQuota } from '../ProfileService';
import { createSimpleCompletion } from '../ai/AiCore';
import { getAuthHeaders } from '../sessionService';
import { Block9AdaptationEntry } from '../../types/pdi';
import { getPdiDocument } from './pdiDocumentRepository';

/**
 * Serviço de adaptações curriculares Block 9.
 * Extraído de PdiDocumentService (Fase 2 — ver docs/REFACTORING_METHODOLOGY.md).
 */

type PdiDocRow = {
  id: string;
  content_data?: {
    clinical_health?: { diagnosis_cid?: string };
    pedagogical?: {
      specific_needs?: string;
      general_objective?: string;
      technological_resources?: string;
      adapted_materials?: string;
    };
    cognitive?: { potentials?: string; challenges?: string };
  };
  school_students?: { name?: string };
};

type Block9AdaptationInput = Omit<Block9AdaptationEntry, 'generated_at' | 'generated_by_ai'>;

const getErrorMessage = (error: unknown): string =>
  error instanceof Error ? error.message : 'Unknown error';

export async function addBlock9Adaptation(
  pdiId: string,
  adaptation: Block9AdaptationInput
): Promise<{ data: Block9AdaptationEntry; error: null }> {
  try {
    const generated_at = new Date().toISOString();
    const generated_by_ai = true;
    const enriched: Block9AdaptationEntry = {
      ...adaptation,
      generated_at,
      generated_by_ai,
    };

    const { data: row, error: fetchErr } = await supabase
      .from('pdi_documents')
      .select('block_9_content')
      .eq('id', pdiId)
      .maybeSingle();

    if (fetchErr) {
      console.error('[pdiBlock9Service] Failed to load pdi_documents.block_9_content:', fetchErr);
      return { data: enriched, error: null };
    }

    const existing = (row?.block_9_content || []) as Block9AdaptationEntry[];
    const idx = existing.findIndex((e) => e.lesson_id === adaptation.lesson_id);

    const next =
      idx >= 0
        ? [...existing.slice(0, idx), enriched, ...existing.slice(idx + 1)]
        : [...existing, enriched];

    const { error: updateErr } = await supabase
      .from('pdi_documents')
      .update({ block_9_content: next })
      .eq('id', pdiId);

    if (updateErr) {
      console.error('[pdiBlock9Service] Failed to persist block_9_content:', updateErr);
    }

    return { data: enriched, error: null };
  } catch (e) {
    console.error('[pdiBlock9Service] Exception while persisting block_9_content:', e);
    return {
      data: {
        ...adaptation,
        generated_at: new Date().toISOString(),
        generated_by_ai: true,
      } as Block9AdaptationEntry,
      error: null,
    };
  }
}

export async function getStudentAdaptations(pdiId: string): Promise<Block9AdaptationEntry[]> {
  try {
    const { data: pdi } = await getPdiDocument(pdiId);
    if (!pdi) return [];
    return (pdi.block_9_content || []) as Block9AdaptationEntry[];
  } catch (error) {
    console.error('Error fetching Block 9 adaptations:', error);
    return [];
  }
}

export async function getAdaptationStats(
  pdiId: string
): Promise<{ total: number; last_generated?: string; subjects: string[] }> {
  const adaptations = await getStudentAdaptations(pdiId);
  const subjects = [...new Set(adaptations.map((a) => a.subject))];
  const lastGenerated =
    adaptations.length > 0
      ? adaptations.sort(
          (a, b) => new Date(b.generated_at).getTime() - new Date(a.generated_at).getTime()
        )[0].generated_at
      : undefined;
  return {
    total: adaptations.length,
    last_generated: lastGenerated,
    subjects: subjects as string[],
  };
}

export async function generateAdaptationsForLesson(
  lessonId: string,
  lessonTitle: string,
  lessonContent: string,
  subject: string,
  gradeLevel: string,
  habilidadesBncc: string[],
  classId: string,
  schoolId: string,
  userId: string,
  year: number
): Promise<{ success: boolean; adaptationsCreated: number; errors: string[] }> {
  const errors: string[] = [];
  let adaptationsCreated = 0;

  try {
    const { data: studentsWithPdi, error: studentsError } = await supabase
      .from('pdi_documents')
      .select(`id, student_id, year, content_data, school_students (id, name)`)
      .eq('school_id', schoolId)
      .eq('year', year)
      .eq('status', 'em_andamento');

    if (studentsError || !studentsWithPdi || studentsWithPdi.length === 0) {
      if (studentsError) errors.push(`Erro ao buscar alunos com PDI: ${studentsError.message}`);
      return { success: !studentsError, adaptationsCreated: 0, errors };
    }

    for (const pdiDoc of studentsWithPdi as PdiDocRow[]) {
      try {
        const content = pdiDoc.content_data || {};
        const studentContext = {
          nome_completo: pdiDoc.school_students?.name || 'Estudante',
          diagnostico_clinico: content.clinical_health?.diagnosis_cid,
          necessidades_especificas: content.pedagogical?.specific_needs,
          potencialidades: content.cognitive?.potentials,
          desafios: content.cognitive?.challenges,
          objetivo_geral: content.pedagogical?.general_objective,
          recursos_tecnologicos: content.pedagogical?.technological_resources,
          materiais_adaptados: content.pedagogical?.adapted_materials,
        };

        if (!studentContext.nome_completo) {
          errors.push(`${studentContext.nome_completo}: Formulário base incompleto`);
          continue;
        }

        const adaptationResult = await generateBlock9Adaptation(
          lessonContent,
          lessonTitle,
          subject,
          gradeLevel,
          habilidadesBncc,
          studentContext as any,
          userId
        );

        const newAdaptation: Block9AdaptationInput = {
          lesson_id: lessonId,
          lesson_title: lessonTitle,
          subject,
          habilidades_bncc: habilidadesBncc,
          adaptacao_metodologica: adaptationResult.adaptacao_metodologica,
          recursos_adaptados: adaptationResult.recursos_adaptados,
          objetivos_adaptados: adaptationResult.objetivos_adaptados,
          estrategias_ensino: adaptationResult.estrategias_ensino,
          tempo_estimado: adaptationResult.tempo_estimado,
        };

        const saved = await addBlock9Adaptation(pdiDoc.id, newAdaptation);
        if (saved.data) adaptationsCreated++;
        else errors.push(`${studentContext.nome_completo}: Erro ao salvar`);
      } catch (err) {
        errors.push(`${pdiDoc.school_students?.name || 'Estudante'}: ${getErrorMessage(err)}`);
      }
    }
    return { success: true, adaptationsCreated, errors };
  } catch (error) {
    return {
      success: false,
      adaptationsCreated,
      errors: [getErrorMessage(error) || 'Erro fatal ao gerar adaptações'],
    };
  }
}

export const generateBlock9Adaptation = async (
  lessonContent: string,
  lessonTitle: string,
  subject: string,
  gradeLevel: string,
  habilidadesBncc: string[],
  studentPdiContext: {
    nome_completo: string;
    diagnostico_clinico?: string;
    necessidades_especificas?: string[];
    potencialidades?: string[];
    desafios?: string[];
    objetivo_geral?: string;
    recursos_tecnologicos?: string[];
    materiais_adaptados?: string[];
  },
  userId?: string
): Promise<{
  adaptacao_metodologica: string;
  recursos_adaptados: string[];
  objetivos_adaptados: string[];
  estrategias_ensino: string[];
  tempo_estimado?: string;
}> => {
  if (userId) {
    try {
      const { data: profile } = await supabase
        .from('profiles')
        .select('allowed_features')
        .eq('id', userId)
        .maybeSingle();

      const allowedFeatures = profile?.allowed_features || [];
      if (allowedFeatures.includes('pdi_bff') || allowedFeatures.includes('all')) {
        const authHeaders = await getAuthHeaders();
        const response = await fetch('/api/pdiProxy', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            ...authHeaders,
          },
          body: JSON.stringify({
            action: 'generateBlock9Adaptation',
            lessonContent,
            lessonTitle,
            subject,
            gradeLevel,
            habilidadesBncc,
            studentPdiContext,
          }),
        });

        if (response.ok) {
          const data = await response.json();
          return data;
        }
      }
    } catch (bffError) {
      console.warn(
        '[pdiBlock9Service] BFF generateBlock9Adaptation failed, falling back to local:',
        bffError
      );
    }
  }

  if (userId) {
    const quotaStatus = await checkUsageQuota(userId);
    if (!quotaStatus.allowed) {
      throw new Error(quotaStatus.message);
    }
  }

  const prompt = `ATUE COMO UM ESPECIALISTA EM INCLUSÃO E DESENHO UNIVERSAL PARA APRENDIZAGEM (DUA).

AULA: ${lessonTitle} (${subject} - ${gradeLevel})
Conteúdo: ${lessonContent.substring(0, 2500)}
Habilidades BNCC: ${habilidadesBncc.join(', ')}

PERFIL DO ALUNO:
Nome: ${studentPdiContext.nome_completo}
Diagnóstico: ${studentPdiContext.diagnostico_clinico || 'Não especificado'}
Necessidades: ${studentPdiContext.necessidades_especificas?.join(', ') || 'Não especificadas'}
Objetivo geral: ${studentPdiContext.objetivo_geral || 'Não especificado'}

Gere uma adaptação curricular desta aula para este aluno seguindo DUA. Retorne em Markdown com seções: Objetivos Adaptados, Estratégias de Acesso, Atividade Adaptada, Avaliação Diferenciada.`;

  const adaptacao_metodologica = await createSimpleCompletion(
    prompt,
    'Você é um especialista em inclusão e DUA escrevendo adaptações de aula. Seja específico e aplicável na sala de aula.'
  );
  return {
    adaptacao_metodologica,
    recursos_adaptados: [],
    objetivos_adaptados: [],
    estrategias_ensino: [],
    tempo_estimado: undefined,
  };
};
