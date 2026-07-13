/**
 * Agente Nativo de Busca ENEM — Client-Side
 *
 * Busca questões do ENEM diretamente no JSON estático hospedado no domínio,
 * sem depender de Supabase ou APIs externas.
 *
 * O JSON é carregado sob demanda e cacheado em memória.
 * A busca usa matching textual com scoring por relevância.
 */

interface EnemAlternativa {
  letra: string;
  texto: string;
}

interface EnemQuestaoRaw {
  id: number;
  ano: number;
  disciplina: string;
  conteudo: string;
  alternativas: EnemAlternativa[];
  gabarito: string;
  _searchText: string;
}

export interface EnemQuestao {
  id: number;
  ano: number;
  disciplina: string;
  conteudo: string;
  alternativas: EnemAlternativa[];
  gabarito: string;
}

export interface EnemSearchResult {
  questao: EnemQuestao;
  score: number;
}

interface EnemSearchOptions {
  query: string;
  disciplinas?: string[];
  anos?: number[];
  limit?: number;
}

const JSON_URL = '/enem_questions.json';

let cache: EnemQuestaoRaw[] | null = null;
let loadingPromise: Promise<EnemQuestaoRaw[]> | null = null;

const loadQuestions = async (): Promise<EnemQuestaoRaw[]> => {
  if (cache) return cache;

  if (!loadingPromise) {
    loadingPromise = fetch(JSON_URL)
      .then((res) => {
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        return res.json();
      })
      .then((data: EnemQuestaoRaw[]) => {
        cache = data;
        console.log(`[EnemAgent] ${data.length} questões carregadas do domínio.`);
        return data;
      })
      .catch((err) => {
        loadingPromise = null;
        throw err;
      });
  }

  return loadingPromise;
};

/**
 * Calcula score de relevância entre query e texto da questão.
 * Scoring: correspondências exatas valem mais que parciais.
 */
const computeScore = (query: string, searchText: string): number => {
  const q = query.toLowerCase().trim();
  const s = searchText;

  if (!q) return 0;

  // Split query into tokens
  const tokens = q.split(/\s+/).filter((t) => t.length >= 2);
  if (tokens.length === 0) return 0;

  let score = 0;

  for (const token of tokens) {
    // Exact word match (high weight)
    const regex = new RegExp(`\\b${escapeRegex(token)}\\b`, 'gi');
    const exactMatches = (s.match(regex) || []).length;
    score += exactMatches * 10;

    // Partial match (lower weight)
    const partialCount = (s.match(new RegExp(escapeRegex(token), 'gi')) || []).length;
    score += (partialCount - exactMatches) * 3;
  }

  // Bonus for exact phrase match
  if (s.includes(q)) {
    score += 20;
  }

  // Bonus for shorter questions (more specific)
  score += Math.max(0, 50 - s.length / 100);

  return score;
};

const escapeRegex = (s: string): string => {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
};

/**
 * Busca questões do ENEM no JSON estático do domínio.
 */
export const searchEnemQuestions = async (
  options: EnemSearchOptions
): Promise<EnemSearchResult[]> => {
  const { query, disciplinas, anos, limit = 25 } = options;

  if (!query || !query.trim()) return [];

  try {
    const todas = await loadQuestions();

    // Filter by discipline and year
    let candidatas = todas;

    if (disciplinas && disciplinas.length > 0) {
      const discSet = new Set(disciplinas.map((d) => d.toLowerCase().replace(/\s+/g, '-')));
      candidatas = candidatas.filter((q) => discSet.has(q.disciplina.toLowerCase()));
    }

    if (anos && anos.length > 0) {
      const anoSet = new Set(anos);
      candidatas = candidatas.filter((q) => anoSet.has(q.ano));
    }

    // Score and rank
    const scored = candidatas
      .map((q) => ({
        questao: {
          id: q.id,
          ano: q.ano,
          disciplina: q.disciplina,
          conteudo: q.conteudo,
          alternativas: q.alternativas,
          gabarito: q.gabarito,
        } as EnemQuestao,
        score: computeScore(query, q._searchText),
      }))
      .filter((r) => r.score > 0)
      .sort((a, b) => b.score - a.score)
      .slice(0, limit);

    console.log(
      `[EnemAgent] Busca: "${query}" → ${scored.length} resultados (de ${candidatas.length} candidatas)`
    );
    return scored;
  } catch (err) {
    console.error('[EnemAgent] Erro na busca:', err);
    return [];
  }
};

/**
 * Verifica se o agente ENEM está pronto (JSON carregado).
 */
export const isEnemAgentReady = (): boolean => cache !== null;

/**
 * Pré-carrega o agente ENEM em background.
 */
export const preloadEnemAgent = (): void => {
  loadQuestions().catch(() => {
    console.warn('[EnemAgent] Pré-carregamento falhou. Busca funcionará sob demanda.');
  });
};

/**
 * Obtém uma questão específica por ID.
 */
export const getEnemQuestionById = async (id: number): Promise<EnemQuestao | null> => {
  try {
    const todas = await loadQuestions();
    const q = todas.find((q) => q.id === id);
    if (!q) return null;
    return {
      id: q.id,
      ano: q.ano,
      disciplina: q.disciplina,
      conteudo: q.conteudo,
      alternativas: q.alternativas,
      gabarito: q.gabarito,
    };
  } catch {
    return null;
  }
};
