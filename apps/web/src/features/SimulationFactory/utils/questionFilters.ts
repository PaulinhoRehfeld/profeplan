/**
 * QUESTION FILTERS & UTILS
 * =========================
 *
 * Utilitários para normalização e filtragem de questões
 * Isolados do código principal para facilitar manutenção
 */

import { SimulationQuestion, QuestionArea, AREA_DISCIPLINE_MAP } from '../types/question.types';

/**
 * Normaliza string para comparação (remove acentos, lowercase, caracteres especiais)
 */
export const normalizeString = (str: string): string => {
  return str
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '') // Remove acentos
    .replace(/[^a-z0-9]/g, ''); // Remove caracteres especiais
};

/**
 * Filtra questões por área(s)
 */
export const filterByArea = (
  questions: SimulationQuestion[],
  areas: string[]
): SimulationQuestion[] => {
  if (areas.length === 0) return questions;

  // Mapear áreas para disciplinas
  const targetDisciplines = areas.flatMap(
    (area) => AREA_DISCIPLINE_MAP[area as QuestionArea] || []
  );

  if (targetDisciplines.length === 0) return questions;

  console.log(`🎯 [Filter] Filtering by disciplines: ${targetDisciplines.join(', ')}`);

  return questions.filter((q) => {
    const qDisc = q.metadata?.discipline || q.metadata?.disciplina || '';
    const normalizedDisc = normalizeString(qDisc);

    const isMatch = targetDisciplines.some((td) => {
      const normalizedTd = normalizeString(td);
      return normalizedDisc.includes(normalizedTd) || normalizedTd.includes(normalizedDisc);
    });

    return isMatch;
  });
};

/**
 * Deduplica questões por ID
 */
export const deduplicateQuestions = (questions: SimulationQuestion[]): SimulationQuestion[] => {
  const seen = new Set<number>();
  return questions.filter((q) => {
    if (seen.has(q.id)) return false;
    seen.add(q.id);
    return true;
  });
};

/**
 * Ordena questões por relevância (similaridade ou ano)
 */
export const sortByRelevance = (questions: SimulationQuestion[]): SimulationQuestion[] => {
  return [...questions].sort((a, b) => {
    // Priorizar por similaridade se disponível
    if (a.similarity !== undefined && b.similarity !== undefined) {
      return b.similarity - a.similarity;
    }

    // Fallback: ordenar por ano (mais recente primeiro)
    return (b.metadata?.year || 0) - (a.metadata?.year || 0);
  });
};

/**
 * Valida se uma questão tem metadados MÍNIMOS para ser exibida
 *
 * ✅ PERMISSIVO: Apenas valida o essencial
 * Permite questões mesmo sem alternatives/context completos
 */
export const hasCompleteMetadata = (question: SimulationQuestion): boolean => {
  const { metadata } = question;

  // Apenas validar que tem metadata E discipline
  // NÃO validar alternatives/context (muito restritivo!)
  return !!(
    metadata &&
    (metadata.discipline || metadata.disciplina) // Aceitar ambos os nomes
  );
};

/**
 * Filtra apenas questões com metadados completos
 */
export const filterCompleteQuestions = (questions: SimulationQuestion[]): SimulationQuestion[] => {
  return questions.filter(hasCompleteMetadata);
};

/**
 * Extrai texto resumido da questão (para preview)
 */
export const getQuestionPreview = (
  question: SimulationQuestion,
  maxLength: number = 150
): string => {
  const text =
    question.metadata?.alternativesIntroduction ||
    question.metadata?.context ||
    'Visualizar questão completa...';

  if (text.length <= maxLength) return text;

  return text.substring(0, maxLength).trim() + '...';
};

/**
 * Formata ano da questão para exibição
 */
export const formatYear = (year?: number): string => {
  if (!year) return 'Ano N/A';
  return `${year}`;
};

/**
 * Formata disciplina para exibição
 */
export const formatDiscipline = (discipline?: string): string => {
  if (!discipline) return 'Geral';
  return discipline;
};

/**
 * Conta questões por área
 */
export const countByArea = (questions: SimulationQuestion[]): Record<QuestionArea, number> => {
  const counts: Record<QuestionArea, number> = {
    Linguagens: 0,
    Matemática: 0,
    Humanas: 0,
    Natureza: 0,
  };

  questions.forEach((q) => {
    const disc = q.metadata?.discipline || q.metadata?.disciplina || '';
    const normalizedDisc = normalizeString(disc);

    for (const [area, disciplines] of Object.entries(AREA_DISCIPLINE_MAP)) {
      const isMatch = disciplines.some((d) => {
        const normalizedTarget = normalizeString(d);
        return (
          normalizedDisc.includes(normalizedTarget) || normalizedTarget.includes(normalizedDisc)
        );
      });

      if (isMatch) {
        counts[area as QuestionArea]++;
        break;
      }
    }
  });

  return counts;
};
