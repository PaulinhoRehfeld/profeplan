/**
 * Serviço de Busca de Questões ENEM
 *
 * Usa o EnemAgent nativo (JSON estático no domínio) em vez de Supabase,
 * eliminando custo de banco e risco de estouro de cota.
 */
import { EnemQuestion } from '../types';
import { searchEnemQuestions, preloadEnemAgent } from './enemAgent';

// Pré-carrega o agente em background ao importar este módulo
preloadEnemAgent();

// Mapeamento de Áreas para Disciplinas (Normalização)
const AREA_MAP: Record<string, string[]> = {
  Humanas: ['ciencias-humanas', 'historia', 'geografia', 'filosofia', 'sociologia'],
  Natureza: ['ciencias-natureza', 'fisica', 'quimica', 'biologia'],
  Linguagens: ['linguagens', 'portugues', 'literatura', 'ingles', 'espanhol', 'artes'],
  Matematica: ['matematica'],
  Matemática: ['matematica'],
};

/**
 * Divide o conteúdo da questão em context (texto base) e alternativesIntroduction (comando).
 * Heurística: última frase antes das alternativas é o comando.
 */
const splitContent = (conteudo: string): { context: string; alternativesIntroduction: string } => {
  const trimmed = conteudo.trim();

  // Tenta encontrar o último parágrafo significativo como comando
  const paragraphs = trimmed.split(/\n\s*\n/);

  if (paragraphs.length <= 1) {
    // Tenta dividir na última frase que termina com ? ou :
    const sentences = trimmed.split(/(?<=[.?!:])\s+(?=[A-ZÀ-Ú])/);
    if (sentences.length > 1) {
      const last = sentences.pop() || '';
      return { context: sentences.join(' '), alternativesIntroduction: last };
    }
    return { context: trimmed, alternativesIntroduction: '' };
  }

  const lastParagraph = paragraphs.pop() || '';
  const context = paragraphs.join('\n\n');

  // Se o último parágrafo for curto, provavelmente é o comando
  if (lastParagraph.length < 300) {
    return { context, alternativesIntroduction: lastParagraph };
  }

  return { context: trimmed, alternativesIntroduction: '' };
};

export const searchQuestions = async (query: string, areas?: string[]): Promise<EnemQuestion[]> => {
  try {
    if (!query.trim()) return [];

    // Converte áreas para disciplinas do ENEM
    const disciplinas =
      areas && areas.length > 0 ? areas.flatMap((area) => AREA_MAP[area] || []) : undefined;

    const results = await searchEnemQuestions({
      query,
      disciplinas,
      limit: 15,
    });

    // Mapeia para o formato EnemQuestion esperado pelos consumidores
    return results.map((r) => {
      const q = r.questao;
      const { context, alternativesIntroduction } = splitContent(q.conteudo);

      return {
        id: q.id,
        similarity: r.score / 100, // Normaliza score para 0-1 aproximado
        metadata: {
          id_original: q.id,
          year: q.ano,
          discipline: q.disciplina,
          disciplina: q.disciplina,
          context,
          alternativesIntroduction,
          alternatives: q.alternativas.map((a) => ({
            letter: a.letra,
            text: a.texto,
            isCorrect: a.letra === q.gabarito,
          })),
          bncc: [],
          tags: [q.disciplina, `enem-${q.ano}`],
        },
      } as EnemQuestion;
    });
  } catch (error: unknown) {
    console.error('[questionService] Erro na busca ENEM:', error);
    return [];
  }
};
