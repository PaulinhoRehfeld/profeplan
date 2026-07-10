// ============================================================================
// PROFEPLAN — Agent Ciências/Biologia (Darwin) — S2-07
// Agente de disciplina concreto para Ciências (EF) + Biologia (EM)
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
 * Agente de Ciências (EF) e Biologia (EM) — "Darwin".
 *
 * Este agente cobre DUAS disciplinas diferentes:
 * - **Ensino Fundamental (6º ao 9º)**: Ciências da Natureza,
 *   com foco em investigação científica, experimentação e
 *   letramento científico.
 * - **Ensino Médio (1ª a 3ª)**: Biologia, integrada à área de
 *   Ciências da Natureza e suas Tecnologias, com foco em evolução,
 *   ecologia, genética e preparação para o ENEM.
 *
 * `getDisciplina()` retorna CIENCIAS se o nível for EF_*, e
 * BIOLOGIA se for EM_*. O system prompt também é selecionado
 * conforme o nível (system-prompt-EF.md ou system-prompt-EM.md).
 */
export class AgentCienciasBiologia extends BaseDisciplineAgent {
  /**
   * Nome icônico do agente: "Darwin" (homenagem a Charles Darwin,
   * naturalista britânico, pai da teoria da evolução por seleção natural).
   */
  public get displayName(): string {
    return AGENT_DISPLAY_NAMES[DisciplinaNome.CIENCIAS]; // "Darwin"
  }

  /**
   * Constrói o system prompt adequado ao nível de ensino.
   * - EF (6º ao 9º): system-prompt-EF.md (Ciências, foco investigativo)
   * - EM (1ª a 3ª): system-prompt-EM.md (Biologia, foco ENEM)
   */
  protected buildSystemPrompt(): string {
    if (this.context.nivel.startsWith('EF_')) {
      return this._loadPrompt('system-prompt-EF.md');
    }
    return this._loadPrompt('system-prompt-EM.md');
  }

  /**
   * Retorna a disciplina associada, dependendo do nível de ensino.
   * - EF_* → DisciplinaNome.CIENCIAS
   * - EM_* → DisciplinaNome.BIOLOGIA
   */
  public getDisciplina(): DisciplinaNome {
    if (this.context.nivel.startsWith('EF_')) {
      return DisciplinaNome.CIENCIAS;
    }
    return DisciplinaNome.BIOLOGIA;
  }

  /**
   * Habilidades BNCC prioritárias para Ciências (EF) e Biologia (EM).
   *
   * Ensino Fundamental (6º ao 9º): EF06CI01 a EF09CI11
   * Ensino Médio (1ª a 3ª): EM13CNT101 a EM13CNT310
   *   (Ciências da Natureza e suas Tecnologias)
   */
  public getHabilidadesPrioritarias(): string[] {
    if (this.context.nivel.startsWith('EF_')) {
      return [
        // 6º ano — Terra e Universo / Matéria e Energia / Vida e Evolução
        'EF06CI01', 'EF06CI02', 'EF06CI03', 'EF06CI04', 'EF06CI05',
        'EF06CI06', 'EF06CI07', 'EF06CI08',
        // 7º ano
        'EF07CI01', 'EF07CI02', 'EF07CI03', 'EF07CI04', 'EF07CI05',
        'EF07CI06', 'EF07CI07', 'EF07CI08', 'EF07CI09', 'EF07CI10',
        'EF07CI11',
        // 8º ano
        'EF08CI01', 'EF08CI02', 'EF08CI03', 'EF08CI04', 'EF08CI05',
        'EF08CI06', 'EF08CI07', 'EF08CI08',
        // 9º ano
        'EF09CI01', 'EF09CI02', 'EF09CI03', 'EF09CI04', 'EF09CI05',
        'EF09CI06', 'EF09CI07', 'EF09CI08', 'EF09CI09', 'EF09CI10',
        'EF09CI11',
      ];
    }
    return [
      // Ciências da Natureza e suas Tecnologias — EM
      'EM13CNT101', 'EM13CNT102', 'EM13CNT103', 'EM13CNT104', 'EM13CNT105',
      'EM13CNT106', 'EM13CNT107',
      'EM13CNT201', 'EM13CNT202', 'EM13CNT203', 'EM13CNT204', 'EM13CNT205',
      'EM13CNT206', 'EM13CNT207', 'EM13CNT208',
      'EM13CNT301', 'EM13CNT302', 'EM13CNT303', 'EM13CNT304', 'EM13CNT305',
      'EM13CNT306', 'EM13CNT307', 'EM13CNT308', 'EM13CNT309', 'EM13CNT310',
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
    return `[RAG] Contexto de Ciências/Biologia para geração do tipo: ${tipo}. Nível: ${this.context.nivel}.`;
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
