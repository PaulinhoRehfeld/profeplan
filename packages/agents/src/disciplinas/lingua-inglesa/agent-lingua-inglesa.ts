// ============================================================================
// PROFEPLAN — Agent Língua Inglesa (Shakespeare) — S3-06
// Agente de disciplina concreto para Língua Inglesa — EF + EM
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
 * Agente de Língua Inglesa — "Shakespeare".
 *
 * Cobre Ensino Fundamental (6º ao 9º ano) e Ensino Médio (1ª a 3ª série),
 * gerando planejamentos trimestrais, planos de aula e avaliações alinhados
 * à BNCC e ao Currículo Referência de Minas Gerais.
 *
 * Foco: comunicação básica e vocabulário no EF; inglês instrumental e
 * interpretação para o ENEM (Linguagens) no EM.
 */
export class AgentLinguaInglesa extends BaseDisciplineAgent {
  /** Nome icônico do agente: "Shakespeare" (homenagem a William Shakespeare). */
  public get displayName(): string {
    return AGENT_DISPLAY_NAMES[DisciplinaNome.LINGUA_INGLESA]; // "Shakespeare"
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

  /** Disciplina associada a este agente. */
  public getDisciplina(): DisciplinaNome {
    return DisciplinaNome.LINGUA_INGLESA;
  }

  /**
   * Habilidades BNCC prioritárias para Língua Inglesa.
   *
   * Ensino Fundamental (6º ao 9º): EF06LI01 a EF09LI08.
   * Ensino Médio (1ª a 3ª): EM13LGG101 a EM13LGG105 (Língua Inglesa está na área de Linguagens).
   */
  public getHabilidadesPrioritarias(): string[] {
    if (this.context.nivel.startsWith('EF_')) {
      return [
        // 6º ano
        'EF06LI01',
        'EF06LI02',
        'EF06LI03',
        'EF06LI04',
        'EF06LI05',
        'EF06LI06',
        'EF06LI07',
        'EF06LI08',
        // 7º ano
        'EF07LI01',
        'EF07LI02',
        'EF07LI03',
        'EF07LI04',
        'EF07LI05',
        'EF07LI06',
        'EF07LI07',
        'EF07LI08',
        // 8º ano
        'EF08LI01',
        'EF08LI02',
        'EF08LI03',
        'EF08LI04',
        'EF08LI05',
        'EF08LI06',
        'EF08LI07',
        'EF08LI08',
        // 9º ano
        'EF09LI01',
        'EF09LI02',
        'EF09LI03',
        'EF09LI04',
        'EF09LI05',
        'EF09LI06',
        'EF09LI07',
        'EF09LI08',
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
    return `[RAG] Contexto de Língua Inglesa para geração do tipo: ${tipo}. Nível: ${this.context.nivel}.`;
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
