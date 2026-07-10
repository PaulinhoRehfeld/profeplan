// ============================================================================
// PROFEPLAN V5 — FREEDAY Integration
// S6-01: Integração dos agentes V5 com o assistente FREEDAY
// ============================================================================

import type { DisciplinaNome, NivelEnsino, TipoGeracao } from './base/discipline-agent-base';

/**
 * Definição de uma função (tool) que o FREEDAY pode invocar
 * via function calling da OpenAI/DeepSeek.
 */
export interface FreedayFunction {
  /** Nome da função registrada no LLM. */
  name: string;
  /** Descrição para o LLM decidir quando chamar. */
  description: string;
  /** Parâmetros no formato JSON Schema. */
  parameters: Record<string, unknown>;
  /** Handler que executa a função e retorna o resultado. */
  handler: (args: Record<string, unknown>) => Promise<FreedayFunctionResult>;
}

/** Resultado da execução de uma função FREEDAY. */
export interface FreedayFunctionResult {
  success: boolean;
  content: string;
  metadata?: Record<string, unknown>;
}

/**
 * Catálogo de funções registradas no FREEDAY.
 *
 * Cada função corresponde a um tipo de geração suportado pelos agentes V5.
 */
export const FREEDAY_FUNCTIONS: FreedayFunction[] = [
  {
    name: 'gerar_plano_aula',
    description: 'Gera um plano de aula para uma disciplina e ano específicos.',
    parameters: {
      type: 'object',
      properties: {
        disciplina: { type: 'string', description: 'Disciplina (ex: MATEMATICA)' },
        nivel: { type: 'string', description: 'Nível de ensino (ex: EF_6)' },
        tema: { type: 'string', description: 'Tema da aula' },
      },
      required: ['disciplina', 'nivel', 'tema'],
    },
    handler: async (_args) => ({
      success: true,
      content: '[FREEDAY] Plano de aula gerado via OrchestratorAgent V5.',
    }),
  },
  {
    name: 'gerar_planejamento_trimestral',
    description: 'Gera um planejamento trimestral completo.',
    parameters: {
      type: 'object',
      properties: {
        disciplina: { type: 'string' },
        nivel: { type: 'string' },
        trimestre: { type: 'number', description: '1, 2, 3 ou 4' },
      },
      required: ['disciplina', 'nivel', 'trimestre'],
    },
    handler: async (_args) => ({
      success: true,
      content: '[FREEDAY] Planejamento trimestral gerado via OrchestratorAgent V5.',
    }),
  },
  {
    name: 'gerar_avaliacao',
    description: 'Gera uma avaliação com questões alinhadas à BNCC.',
    parameters: {
      type: 'object',
      properties: {
        disciplina: { type: 'string' },
        nivel: { type: 'string' },
        num_questoes: { type: 'number', description: 'Número de questões' },
      },
      required: ['disciplina', 'nivel'],
    },
    handler: async (_args) => ({
      success: true,
      content: '[FREEDAY] Avaliação gerada via OrchestratorAgent V5.',
    }),
  },
];

/**
 * Integra os agentes V5 ao FREEDAY via function calling.
 *
 * TODO: Conectar handlers reais ao OrchestratorAgent + agentProxy BFF.
 *
 * @returns Lista de funções registradas no formato OpenAI function calling.
 */
export function getFreedayToolDefinitions(): Array<{
  type: 'function';
  function: { name: string; description: string; parameters: Record<string, unknown> };
}> {
  return FREEDAY_FUNCTIONS.map((fn) => ({
    type: 'function' as const,
    function: {
      name: fn.name,
      description: fn.description,
      parameters: fn.parameters,
    },
  }));
}
