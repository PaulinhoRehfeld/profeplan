// ============================================================================
// PROFEPLAN — Agent Educação Física (Pelé) — S3-08
// Agente de disciplina concreto para Educação Física — EF + EM
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
 * Agente de Educação Física — "Pelé".
 *
 * Cobre Ensino Fundamental (6º ao 9º ano) e Ensino Médio (1ª a 3ª série),
 * gerando planejamentos trimestrais, planos de aula e avaliações alinhados
 * à BNCC (área de Linguagens e suas Tecnologias) e ao Currículo Referência
 * de Minas Gerais.
 *
 * Foco EF: esportes, jogos, ginástica, dança, lutas, práticas corporais
 * de aventura e saúde. Foco EM: corpo e movimento, esportes e sociedade,
 * preparação para o ENEM.
 *
 * REGRA CRÍTICA: PROIBIDO INVENTAR REGRAS ESPORTIVAS OU EXERCÍCIOS SEM BASE.
 * Toda referência a regras esportivas, exercícios físicos, técnicas
 * corporais ou dados fisiológicos DEVE estar confirmada na base RAG.
 * NUNCA invente uma regra esportiva ou exercício — consulte SEMPRE a base RAG.
 */
export class AgentEducacaoFisica extends BaseDisciplineAgent {
  /** Nome icônico do agente: "Pelé" (homenagem a Edson Arantes do Nascimento). */
  public get displayName(): string {
    return AGENT_DISPLAY_NAMES[DisciplinaNome.EDUCACAO_FISICA]; // "Pelé"
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

  /** Disciplina associada a este agente: EDUCACAO_FISICA. */
  public getDisciplina(): DisciplinaNome {
    return DisciplinaNome.EDUCACAO_FISICA;
  }

  /**
   * Habilidades BNCC prioritárias para Educação Física.
   *
   * Ensino Fundamental (6º ao 9º): EF67EF01 a EF89EF08.
   *   Brincadeiras e jogos, esportes, ginásticas, danças, lutas e
   *   práticas corporais de aventura.
   * Ensino Médio (1ª a 3ª): EM13LGG101 a EM13LGG105.
   *   Educação Física está na área de Linguagens e suas Tecnologias.
   */
  public getHabilidadesPrioritarias(): string[] {
    if (this.context.nivel.startsWith('EF_')) {
      return [
        // 6º e 7º ano — Unidades Temáticas
        'EF67EF01',
        'EF67EF02',
        'EF67EF03',
        'EF67EF04',
        'EF67EF05',
        'EF67EF06',
        'EF67EF07',
        'EF67EF08',
        // 8º e 9º ano — Unidades Temáticas
        'EF89EF01',
        'EF89EF02',
        'EF89EF03',
        'EF89EF04',
        'EF89EF05',
        'EF89EF06',
        'EF89EF07',
        'EF89EF08',
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
    return `[RAG] Contexto de Educação Física para geração do tipo: ${tipo}. Nível: ${this.context.nivel}.`;
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
