// ============================================================================
// PROFEPLAN — Agent Artes (Tarsila) — S3-07
// Agente de disciplina concreto para Artes — EF + EM
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
 * Agente de Artes — "Tarsila".
 *
 * Cobre Ensino Fundamental (6º ao 9º ano) e Ensino Médio (1ª a 3ª série),
 * gerando planejamentos trimestrais, planos de aula e avaliações alinhados
 * à BNCC (área de Linguagens e suas Tecnologias) e ao Currículo Referência
 * de Minas Gerais.
 *
 * Foco: artes visuais, música, dança, teatro (EF); história da arte,
 * culturas brasileira e mundial, preparação para o ENEM (EM).
 *
 * REGRA CRÍTICA: PROIBIDO INVENTAR OBRAS DE ARTE OU ARTISTAS.
 * Toda referência a obras, artistas, movimentos artísticos ou datas
 * DEVE estar confirmada na base RAG. NUNCA invente uma obra ou artista —
 * consulte SEMPRE a base RAG.
 */
export class AgentArtes extends BaseDisciplineAgent {
  /** Nome icônico do agente: "Tarsila" (homenagem a Tarsila do Amaral). */
  public get displayName(): string {
    return AGENT_DISPLAY_NAMES[DisciplinaNome.ARTES]; // "Tarsila"
  }

  /**
   * Constrói o system prompt adequado ao nível de ensino.
   * - EF (6º ao 9º): system-prompt-EF.md
   * - EM (1ª a 3ª): system-prompt-EM.md
   */
  protected buildSystemPrompt(): string {
    if (this.context.nivel.startsWith('EF_')) {
      return this._loadPrompt('system-prompt-EF.md');
    }
    return this._loadPrompt('system-prompt-EM.md');
  }

  /** Disciplina associada a este agente: ARTES. */
  public getDisciplina(): DisciplinaNome {
    return DisciplinaNome.ARTES;
  }

  /**
   * Habilidades BNCC prioritárias para Artes.
   *
   * Ensino Fundamental (6º ao 9º): EF69AR01 a EF69AR08.
   *   Artes integradas: investigação, criação, expressão em múltiplas linguagens.
   * Ensino Médio (1ª a 3ª): EM13LGG101 a EM13LGG105.
   *   Artes está na área de Linguagens e suas Tecnologias.
   */
  public getHabilidadesPrioritarias(): string[] {
    if (this.context.nivel.startsWith('EF_')) {
      return [
        'EF69AR01',
        'EF69AR02',
        'EF69AR03',
        'EF69AR04',
        'EF69AR05',
        'EF69AR06',
        'EF69AR07',
        'EF69AR08',
      ];
    }
    return ['EM13LGG101', 'EM13LGG102', 'EM13LGG103', 'EM13LGG104', 'EM13LGG105'];
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
    return `[RAG] Contexto de Artes para geração do tipo: ${tipo}. Nível: ${this.context.nivel}.`;
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
