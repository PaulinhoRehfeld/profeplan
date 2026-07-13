// ============================================================================
// PROFEPLAN — Agent História (Heródoto) — S2-05
// Agente de disciplina concreto para História — EF + EM
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
 * Agente de História — "Heródoto".
 *
 * Cobre Ensino Fundamental (6º ao 9º ano) e Ensino Médio (1ª a 3ª série),
 * gerando planejamentos trimestrais, planos de aula e avaliações alinhados
 * à BNCC e ao Currículo Referência de Minas Gerais.
 *
 * Foco: contextualização histórica, fontes primárias, pensamento crítico,
 * múltiplas perspectivas historiográficas e preparação para o ENEM (Ciências Humanas).
 */
export class AgentHistoria extends BaseDisciplineAgent {
  /** Nome icônico do agente: "Heródoto" (homenagem a Heródoto de Halicarnasso, "Pai da História"). */
  public get displayName(): string {
    return AGENT_DISPLAY_NAMES[DisciplinaNome.HISTORIA]; // "Heródoto"
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
    return DisciplinaNome.HISTORIA;
  }

  /**
   * Habilidades BNCC prioritárias para História.
   *
   * Ensino Fundamental (6º ao 9º): EF06HI01 a EF09HI08.
   * Ensino Médio (1ª a 3ª): EM13CHS101 a EM13CHS606 (Ciências Humanas e Sociais Aplicadas).
   */
  public getHabilidadesPrioritarias(): string[] {
    if (this.context.nivel.startsWith('EF_')) {
      return [
        // 6º ano
        'EF06HI01',
        'EF06HI02',
        'EF06HI03',
        'EF06HI04',
        'EF06HI05',
        'EF06HI06',
        'EF06HI07',
        'EF06HI08',
        // 7º ano
        'EF07HI01',
        'EF07HI02',
        'EF07HI03',
        'EF07HI04',
        'EF07HI05',
        'EF07HI06',
        'EF07HI07',
        'EF07HI08',
        // 8º ano
        'EF08HI01',
        'EF08HI02',
        'EF08HI03',
        'EF08HI04',
        'EF08HI05',
        'EF08HI06',
        'EF08HI07',
        'EF08HI08',
        // 9º ano
        'EF09HI01',
        'EF09HI02',
        'EF09HI03',
        'EF09HI04',
        'EF09HI05',
        'EF09HI06',
        'EF09HI07',
        'EF09HI08',
      ];
    }
    return [
      'EM13CHS101',
      'EM13CHS102',
      'EM13CHS103',
      'EM13CHS104',
      'EM13CHS105',
      'EM13CHS106',
      'EM13CHS201',
      'EM13CHS202',
      'EM13CHS203',
      'EM13CHS204',
      'EM13CHS205',
      'EM13CHS206',
      'EM13CHS301',
      'EM13CHS302',
      'EM13CHS303',
      'EM13CHS304',
      'EM13CHS305',
      'EM13CHS306',
      'EM13CHS401',
      'EM13CHS402',
      'EM13CHS403',
      'EM13CHS404',
      'EM13CHS405',
      'EM13CHS406',
      'EM13CHS501',
      'EM13CHS502',
      'EM13CHS503',
      'EM13CHS504',
      'EM13CHS505',
      'EM13CHS506',
      'EM13CHS601',
      'EM13CHS602',
      'EM13CHS603',
      'EM13CHS604',
      'EM13CHS605',
      'EM13CHS606',
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
    return `[RAG] Contexto de História para geração do tipo: ${tipo}. Nível: ${this.context.nivel}.`;
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
