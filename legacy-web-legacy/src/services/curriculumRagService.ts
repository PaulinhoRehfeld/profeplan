/**
 * curriculumRagService.ts
 * Serviço de busca de currículo via RAG (Retrieval-Augmented Generation).
 *
 * Reconstruído a partir do build compilado:
 *   - legacy-web-legacy/dist/assets/markdownParser-Dou529D6.js (lines 140-278)
 *
 * Funções exportadas (mesmas assinaturas usadas no código compilado):
 *   - searchCurriculumRag()       → RPC: search_curriculum_rag
 *   - getCurriculoCompleto()      → RPC: get_curriculo_completo
 *   - searchPnldContent()         → RPC: search_pnld_content (usa Gemini embeddings)
 *   - buildTermPlanContext()      → orquestra busca de contexto para geração de plano
 */

import { GoogleGenerativeAI } from '@google/generative-ai';
import { supabase } from './supabaseClient';

// ---------------------------------------------------------------------------
// Parâmetros de busca
// ---------------------------------------------------------------------------

export interface RagSearchParams {
  disciplina?: string | null;
  ano?: string | null;
  periodo?: string | null;
}

export interface CurriculumRagResult {
  content: string;
  metadata?: {
    ano_base?: number;
    [key: string]: unknown;
  };
  similarity?: number;
}

// ---------------------------------------------------------------------------
// searchCurriculumRag
// Busca trechos de currículo RAG pelo texto (sem embedding — usa full-text)
// Corresponde ao `Y` no compilado.
// ---------------------------------------------------------------------------

export async function searchCurriculumRag(
  queryText: string,
  params?: RagSearchParams,
  matchCount = 5,
  matchThreshold = 0.5,
): Promise<CurriculumRagResult[]> {
  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 12_000);

    const query = supabase
      .rpc('search_curriculum_rag', {
        query_text: queryText,
        match_threshold: matchThreshold,
        match_count: matchCount,
        filter_disciplina: params?.disciplina ?? null,
        filter_ano: params?.ano ?? null,
        filter_periodo: params?.periodo ?? null,
      })
      .abortSignal(controller.signal);

    const { data, error } = await query;
    clearTimeout(timeoutId);

    if (error) throw error;
    return (data as CurriculumRagResult[]) || [];
  } catch (err: unknown) {
    const code = String((err as { code?: string })?.code ?? '');
    const message = String((err as { message?: string })?.message ?? '');
    const name = (err as { name?: string })?.name;

    const isAbort = name === 'AbortError' || message.toLowerCase().includes('abort');
    const isSchemaCache =
      code === 'PGRST202' || message.toLowerCase().includes('schema cache');

    if (isAbort) {
      console.warn('[RAG] Busca de currículo abortada por timeout de cliente.');
    } else if (isSchemaCache) {
      console.warn(
        '[RAG] RPC search_curriculum_rag indisponível no Supabase (schema cache). ' +
        'Usando fallback sem RAG.',
      );
    } else {
      console.error('[RAG] Erro ou Timeout na busca de currículo:', err);
    }

    return [];
  }
}

// ---------------------------------------------------------------------------
// getCurriculoCompleto
// Busca currículo determinístico (SEE/MG) para uma disciplina/período/ano.
// Corresponde ao `Q` no compilado.
// ---------------------------------------------------------------------------

export async function getCurriculoCompleto(
  disciplina: string,
  periodo: string,
  anoEscolar: string | null,
): Promise<string | null> {
  try {
    const { data, error } = await supabase.rpc('get_curriculo_completo', {
      p_disciplina: disciplina,
      p_periodo: periodo,
      p_ano_escolar: anoEscolar ?? null,
    });

    if (error) throw error;
    return (data as string) || '';
  } catch (err) {
    console.error('[RAG] Erro ao buscar currículo completo:', err);
    return null;
  }
}

// ---------------------------------------------------------------------------
// searchPnldContent
// Busca conteúdo PNLD usando Gemini para embeddings.
// Corresponde ao `oe` no compilado.
// ---------------------------------------------------------------------------

export async function searchPnldContent(
  queryText: string,
  params?: { livro_titulo?: string | null; disciplina?: string | null },
  matchCount = 5,
  matchThreshold = 0.5,
): Promise<unknown[]> {
  const geminiKey =
    import.meta.env.VITE_GEMINI_API_KEY?.trim() ||
    'AIzaSyBpLzXwQaFFd0TuHIxZYP4X0eYdICYVJP4';

  if (!geminiKey) throw new Error('[PNLD] Gemini API Key missing');

  const genAI = new GoogleGenerativeAI(geminiKey);
  const model = genAI.getGenerativeModel({ model: 'models/gemini-embedding-001' });

  try {
    const result = await model.embedContent(queryText);
    const embedding = result.embedding.values.slice(0, 768);

    const { data, error } = await supabase.rpc('search_pnld_content', {
      query_embedding: embedding,
      match_threshold: matchThreshold,
      match_count: matchCount,
      filter_livro_titulo: params?.livro_titulo ?? null,
      filter_disciplina: params?.disciplina ?? null,
    });

    if (error) throw error;
    return (data as unknown[]) || [];
  } catch (err) {
    console.error('[PNLD] Erro na busca de conteúdo PNLD (Projeto Codex):', err);
    return [];
  }
}

// ---------------------------------------------------------------------------
// normalizeSubject — normalização de nome de disciplina
// Importado dinamicamente no compilado via SubjectNormalizationService
// ---------------------------------------------------------------------------

const SUBJECT_MAP: Record<string, string> = {
  matematica: 'Matemática',
  matematica1: 'Matemática',
  mat: 'Matemática',
  portugues: 'Língua Portuguesa',
  'lingua portuguesa': 'Língua Portuguesa',
  port: 'Língua Portuguesa',
  historia: 'História',
  hist: 'História',
  geografia: 'Geografia',
  geo: 'Geografia',
  ciencias: 'Ciências',
  biologia: 'Biologia',
  bio: 'Biologia',
  fisica: 'Física',
  quimica: 'Química',
  quim: 'Química',
  filosofia: 'Filosofia',
  sociologia: 'Sociologia',
  'educacao fisica': 'Educação Física',
  'ed. fisica': 'Educação Física',
  arte: 'Arte',
  artes: 'Arte',
  ingles: 'Língua Inglesa',
  'lingua inglesa': 'Língua Inglesa',
  espanhol: 'Língua Espanhola',
};

export function normalizeSubject(raw: string): string {
  const key = raw.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
  return (
    SUBJECT_MAP[key] ||
    raw.charAt(0).toUpperCase() + raw.slice(1)
  );
}

// ---------------------------------------------------------------------------
// buildTermPlanContext
// Orquestra a busca de currículo para montar o contexto do prompt de plano.
// Corresponde à função `ae` no compilado.
// ---------------------------------------------------------------------------

export interface BuildContextInput {
  subject: string;
  grade: string;
  level?: string;
  period: number;
  stateBase?: string;
  pnld_book_id?: string;
  userId?: string;
  skipCredits?: boolean;
  userSettings?: {
    favoriteMethodology?: string;
    teachingStyle?: string;
    assessmentFocus?: string;
    toneOfVoice?: string;
  };
}

export async function buildTermPlanContext(input: BuildContextInput): Promise<string> {
  const gradeNum = input.grade.replace(/\D/g, '');
  let gradeFormatted = `${gradeNum}º Ano`;
  if (input.level === 'Ensino Médio') gradeFormatted = `${gradeNum}º Ano EM`;

  const subject = normalizeSubject(input.subject);
  const periodo = `${input.period}º Trimestre`;

  console.log(`🔍 Buscando currículo para: ${subject}, ${gradeFormatted}, ${periodo}`);

  let curriculumContext = '';

  // 1. Tenta currículo determinístico SEE/MG
  if (input.stateBase?.includes('Minas Gerais') || input.stateBase === 'MG') {
    const seeContent = await getCurriculoCompleto(subject, periodo, gradeFormatted);
    if (seeContent) {
      console.log('📍 SEE MG OFFICIAL: Deterministic curriculum loaded.');
      curriculumContext = `[CURRÍCULO OFICIAL SEE/MG]:\n${seeContent}`;
    }
  }

  // 2. Fallback: busca RAG por embedding
  if (!curriculumContext) {
    const ragResults = await searchCurriculumRag(
      `Planejamento e Habilidades de ${subject} para ${gradeFormatted} no ${periodo}`,
      { disciplina: subject, ano: gradeFormatted, periodo },
      5,
    );

    if (ragResults.length > 0) {
      curriculumContext = ragResults
        .map((r) => {
          const anoBase = r.metadata?.ano_base;
          const suffix = anoBase === 2025 ? ' (Base curricular 2025)' : '';
          return `${r.content || ''}${suffix}`;
        })
        .join('\n\n---\n\n');

      console.log(`✅ Encontrados ${ragResults.length} trechos de currículo via RAG.`);
    }
  }

  return curriculumContext;
}
