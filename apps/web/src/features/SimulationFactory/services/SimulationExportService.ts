/**
 * SIMULATION EXPORT SERVICE
 * ==========================
 *
 * Serviço isolado para exportação de simulados
 * Mantém lógica de DOCX separada do módulo principal
 */

import { SimulationQuestion } from '../types/question.types';

/**
 * Exporta simulado para DOCX
 * Usa o exportService existente mas com tipos isolados
 */
export const exportSimulationToDocx = async (
  questions: SimulationQuestion[],
  observations: string,
  version: string,
  settings?: any
): Promise<void> => {
  // Importação dinâmica para evitar dependência circular
  const { exportSimuladoToDocx } = await import('../../../services/exportService');

  // Converte SimulationQuestion para formato esperado pelo exportService
  // Mantém compatibilidade mas usa tipos isolados
  const compatibleQuestions = questions.map((q) => ({
    id: q.id,
    metadata: q.metadata,
  }));

  return exportSimuladoToDocx(compatibleQuestions as any, observations, version, settings);
};

/**
 * Gera título padrão para simulado
 */
export const generateSimulationTitle = (prefix: string = 'Simulado'): string => {
  const date = new Date().toLocaleDateString('pt-BR');
  return `${prefix}_${date.replace(/\//g, '-')}`;
};

/**
 * Gera resumo do conteúdo das questões
 */
export const generateContentSummary = (questions: SimulationQuestion[]): string => {
  return questions
    .map((q) => q.metadata?.alternativesIntroduction || q.metadata?.context)
    .filter(Boolean)
    .join('\n---\n');
};

/**
 * Embaralha questões para criar versão B
 */
export const shuffleQuestions = (questions: SimulationQuestion[]): SimulationQuestion[] => {
  return [...questions].sort(() => Math.random() - 0.5);
};
