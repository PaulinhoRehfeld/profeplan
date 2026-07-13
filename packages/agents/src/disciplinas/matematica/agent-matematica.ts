// ============================================================================
// PROFEPLAN — Agent Matemática (Pitágoras) — S2-04
// Agente de disciplina concreto para Matemática — EF + EM
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
 * Agente de Matemática — "Pitágoras".
 *
 * Cobre Ensino Fundamental (6º ao 9º ano) e Ensino Médio (1ª a 3ª série),
 * gerando planejamentos trimestrais, planos de aula e avaliações alinhados
 * à BNCC e ao Currículo Referência de Minas Gerais.
 *
 * Foco: raciocínio lógico, resolução de problemas, competências ENEM C1-C5.
 */
export class AgentMatematica extends BaseDisciplineAgent {
  /** Nome icônico do agente: "Pitágoras" (homenagem a Pitágoras de Samos). */
  public get displayName(): string {
    return AGENT_DISPLAY_NAMES[DisciplinaNome.MATEMATICA]; // "Pitágoras"
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
    return DisciplinaNome.MATEMATICA;
  }

  /**
   * Habilidades BNCC prioritárias para Matemática.
   *
   * Ensino Fundamental: foco em números, operações, geometria e álgebra inicial.
   * Ensino Médio: foco em funções, trigonometria, geometria analítica e ENEM.
   */
  public getHabilidadesPrioritarias(): string[] {
    if (this.context.nivel.startsWith('EF_')) {
      return [
        'EF06MA01',
        'EF06MA02',
        'EF06MA03',
        'EF06MA04',
        'EF06MA05',
        'EF07MA01',
        'EF07MA02',
        'EF07MA03',
        'EF08MA01',
        'EF08MA02',
        'EF08MA03',
        'EF09MA01',
        'EF09MA02',
        'EF09MA03',
        'EF09MA04',
        'EF09MA05',
      ];
    }
    return [
      'EM13MAT101',
      'EM13MAT102',
      'EM13MAT103',
      'EM13MAT201',
      'EM13MAT202',
      'EM13MAT301',
      'EM13MAT302',
      'EM13MAT303',
      'EM13MAT401',
      'EM13MAT402',
      'EM13MAT403',
      'EM13MAT501',
      'EM13MAT502',
      'EM13MAT503',
      'EM13MAT504',
      'EM13MAT505',
      'EM13MAT506',
      'EM13MAT507',
      'EM13MAT508',
      'EM13MAT509',
      'EM13MAT510',
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
    return `[RAG] Contexto de Matemática para geração do tipo: ${tipo}. Nível: ${this.context.nivel}.`;
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
