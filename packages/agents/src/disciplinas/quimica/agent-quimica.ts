// ============================================================================
// PROFEPLAN — Agent Química (Lavoisier) — S3-05
// Agente de disciplina concreto para Química — EM (somente Ensino Médio)
// ============================================================================

import {
  BaseDisciplineAgent,
  DisciplinaNome,
  NivelEnsino,
  TipoGeracao,
  type GeracaoResultado,
  AGENT_DISPLAY_NAMES,
} from '../../base/discipline-agent-base';
import { PROMPTS } from './prompts.generated';

/**
 * Agente de Química — "Lavoisier".
 *
 * Cobre EXCLUSIVAMENTE o Ensino Médio (1ª a 3ª série), gerando
 * planejamentos trimestrais, planos de aula e avaliações alinhados
 * à BNCC (área de Ciências da Natureza e suas Tecnologias) e ao
 * Currículo Referência de Minas Gerais.
 *
 * Foco: experimentação com materiais de baixo custo, tabela periódica,
 * estequiometria, química orgânica e inorgânica, competências ENEM C1-C7
 * (Ciências da Natureza), preparação para vestibulares.
 *
 * REGRA CRÍTICA: PROIBIDO INVENTAR REAÇÕES QUÍMICAS OU FÓRMULAS MOLECULARES.
 * Toda reação, fórmula molecular ou equação química DEVE estar confirmada
 * na base RAG. NUNCA balanceie uma equação de memória — consulte SEMPRE a base RAG.
 */
export class AgentQuimica extends BaseDisciplineAgent {
  /** Nome icônico do agente: "Lavoisier" (homenagem a Antoine Lavoisier). */
  public get displayName(): string {
    return AGENT_DISPLAY_NAMES[DisciplinaNome.QUIMICA]; // "Lavoisier"
  }

  /**
   * Constrói o system prompt para Química.
   *
   * Química é disciplina EXCLUSIVA do Ensino Médio no currículo brasileiro.
   * Portanto, SEMPRE retorna system-prompt-EM.md, independentemente do nível.
   */
  protected buildSystemPrompt(): string {
    return this._loadPrompt('system-prompt-EM.md');
  }

  /** Disciplina associada a este agente: QUIMICA. */
  public getDisciplina(): DisciplinaNome {
    return DisciplinaNome.QUIMICA;
  }

  /**
   * Habilidades BNCC prioritárias para Química (Ensino Médio).
   *
   * A Química está inserida na área de Ciências da Natureza e suas
   * Tecnologias (CNT). As habilidades cobrem:
   * - EM13CNT101 a EM13CNT107: Matéria e Energia (ênfase em Química)
   * - EM13CNT201 a EM13CNT208: Vida e Evolução (interfaces com Química)
   * - EM13CNT301 a EM13CNT310: Terra e Universo (interfaces com Química)
   */
  public getHabilidadesPrioritarias(): string[] {
    return [
      // Matéria e Energia — foco principal em Química
      'EM13CNT101',
      'EM13CNT102',
      'EM13CNT103',
      'EM13CNT104',
      'EM13CNT105',
      'EM13CNT106',
      'EM13CNT107',
      // Vida e Evolução — interfaces Química-Biologia
      'EM13CNT201',
      'EM13CNT202',
      'EM13CNT203',
      'EM13CNT204',
      'EM13CNT205',
      'EM13CNT206',
      'EM13CNT207',
      'EM13CNT208',
      // Terra e Universo — interfaces com Química (Geoquímica, Ciclos)
      'EM13CNT301',
      'EM13CNT302',
      'EM13CNT303',
      'EM13CNT304',
      'EM13CNT305',
      'EM13CNT306',
      'EM13CNT307',
      'EM13CNT308',
      'EM13CNT309',
      'EM13CNT310',
    ];
  }

  /**
   * Mapa de prompts desta disciplina, gerado a partir de `prompts/*.md`
   * por `scripts/build-prompts.mjs`.
   */
  protected getPromptsMap(): Record<string, string> {
    return PROMPTS;
  }

  // --- Pipeline de geração (sobrescritas) ---

  /**
   * Constrói o contexto RAG a partir do Supabase + ContextBuilderAgent.
   * TODO: Integrar com ContextBuilderAgent + Supabase RAG (Sprint 3).
   */
  protected async _buildRagContext(tipo: TipoGeracao): Promise<string> {
    // TODO: Integrar com ContextBuilderAgent + Supabase RAG
    return `[RAG] Contexto de Química para geração do tipo: ${tipo}. Nível: ${this.context.nivel}.`;
  }

  /**
   * Seleciona o template de prompt adequado ao tipo de geração.
   */
  protected _selectPromptTemplate(tipo: TipoGeracao): string {
    switch (tipo) {
      case TipoGeracao.PLANEJAMENTO_TRIMESTRAL:
        return this._loadPrompt('planejamento-trimestral.md');
      case TipoGeracao.PLANO_AULA:
        return this._loadPrompt('plano-aula.md');
      case TipoGeracao.AVALIACAO:
        return this._loadPrompt('avaliacao.md');
      default:
        return this._loadPrompt('plano-aula.md'); // fallback seguro
    }
  }
}
