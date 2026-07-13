import { supabase } from './supabaseClient';

/**
 * Service para Normalização de Disciplinas
 * Substitui hardcoded IFs do AiPlanningService
 */

// Cache em memória para evitar queries repetidas
const subjectCache = new Map<string, string>();
let cacheInitialized = false;

const getErrorMessage = (error: unknown): string =>
  error instanceof Error ? error.message : 'Unknown error';

/**
 * Inicializa o cache carregando todas as disciplinas normalizadas
 */
export const initializeSubjectCache = async (): Promise<void> => {
  if (cacheInitialized) return;

  try {
    const { data, error } = await supabase
      .from('subject_aliases')
      .select('input_variant, normalized_name');

    if (error) {
      console.error('Erro ao carregar subject_aliases:', error);
      return;
    }

    if (data && data.length > 0) {
      data.forEach(({ input_variant, normalized_name }) => {
        // Cache case-insensitive
        subjectCache.set(input_variant.toLowerCase(), normalized_name);
      });
      cacheInitialized = true;
      console.log(`✅ Subject cache initialized with ${subjectCache.size} variants`);
    } else {
      console.warn(
        '⚠️ subject_aliases table is empty or not found. Run migration: infra/supabase/migrations/20260209_create_subject_aliases.sql'
      );
      // Do NOT set cacheInitialized=true so we retry on next call
    }
  } catch (err) {
    console.error('Erro crítico ao inicializar cache:', err);
  }
};

/**
 * Normaliza uma disciplina usando a tabela subject_aliases
 * @param input - Nome da disciplina (qualquer variação)
 * @returns Nome normalizado ou original se não encontrado
 */
export const normalizeSubject = async (input: string): Promise<string> => {
  if (!input) return '';

  // Inicializar cache se necessário
  if (!cacheInitialized) {
    await initializeSubjectCache();
  }

  const lowerInput = input.toLowerCase().trim();

  // 1. Busca no cache
  if (subjectCache.has(lowerInput)) {
    return subjectCache.get(lowerInput)!;
  }

  // 2. Busca parcial (caso novo input contenha palavra-chave)
  for (const [variant, normalized] of subjectCache.entries()) {
    if (lowerInput.includes(variant) || variant.includes(lowerInput)) {
      // Adiciona ao cache para próxima vez
      subjectCache.set(lowerInput, normalized);
      return normalized;
    }
  }

  // 3. Fallback: consulta ao banco (caso cache esteja desatualizado)
  try {
    const { data, error } = await supabase
      .from('subject_aliases')
      .select('normalized_name')
      .ilike('input_variant', `%${input}%`)
      .limit(1)
      .maybeSingle();

    if (!error && data) {
      subjectCache.set(lowerInput, data.normalized_name);
      return data.normalized_name;
    }
  } catch (err) {
    console.warn('Erro na busca de normalização:', err);
  }

  // 4. Se não encontrou, retorna capitalizado
  console.warn(`⚠️ Disciplina não mapeada: "${input}"`);
  return input.charAt(0).toUpperCase() + input.slice(1);
};

/**
 * Adiciona nova variante de disciplina
 * Útil para professores de novas disciplinas
 */
export const addSubjectVariant = async (
  inputVariant: string,
  normalizedName: string,
  category?: string
): Promise<{ success: boolean; error?: string }> => {
  try {
    const { error } = await supabase.from('subject_aliases').insert({
      input_variant: inputVariant.toLowerCase(),
      normalized_name: normalizedName,
      category,
    });

    if (error) {
      return { success: false, error: error.message };
    }

    // Atualiza cache
    subjectCache.set(inputVariant.toLowerCase(), normalizedName);

    return { success: true };
  } catch (err: unknown) {
    return { success: false, error: getErrorMessage(err) };
  }
};

/**
 * Retorna todas as disciplinas normalizadas disponíveis
 */
export const getAllNormalizedSubjects = async (): Promise<string[]> => {
  try {
    const { data, error } = await supabase
      .from('subject_aliases')
      .select('normalized_name')
      .order('normalized_name');

    if (error) return [];

    // Retorna apenas valores únicos
    const unique = Array.from(new Set(data.map((d) => d.normalized_name)));
    return unique;
  } catch (err) {
    console.error('Erro ao buscar disciplinas:', err);
    return [];
  }
};
