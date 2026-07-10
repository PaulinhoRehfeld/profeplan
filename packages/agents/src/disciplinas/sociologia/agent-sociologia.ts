// ============================================================================
// PROFEPLAN — Agent Sociologia (Durkheim) — S5-02
// Agente de disciplina concreto para Sociologia — EM (somente Ensino Médio)
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
 * Agente de Sociologia — "Durkheim".
 *
 * Cobre EXCLUSIVAMENTE o Ensino Médio (1ª a 3ª série), gerando
 * planejamentos trimestrais, planos de aula e avaliações alinhados
 * à BNCC (área de Ciências Humanas e Sociais Aplicadas) e ao
 * Currículo Referência de Minas Gerais.
 *
 * Foco: clássicos da Sociologia (Durkheim, Weber, Marx), teorias
 * sociológicas contemporâneas, instituições sociais, estratificação,
 * movimentos sociais, cultura e identidade, cidadania, trabalho e
 * preparação para o ENEM (Ciências Humanas).
 *
 * REGRA CRÍTICA: PROIBIDO INVENTAR DADOS SOCIOLÓGICOS/ESTATÍSTICAS.
 * Todo dado quantitativo, estatística, indicador social ou taxa
 * citada DEVE estar confirmada na base RAG.
 */
export class AgentSociologia extends BaseDisciplineAgent {
  /** Nome icônico do agente: "Durkheim" (homenagem a Émile Durkheim, "Pai da Sociologia"). */
  public get displayName(): string {
    return AGENT_DISPLAY_NAMES[DisciplinaNome.SOCIOLOGIA]; // "Durkheim"
  }

  /**
   * Constrói o system prompt para Sociologia.
   *
   * Sociologia é disciplina EXCLUSIVA do Ensino Médio no currículo brasileiro.
   * Portanto, SEMPRE retorna system-prompt-EM.md, independentemente do nível.
   */
  protected buildSystemPrompt(): string {
    return this._loadPrompt('system-prompt-EM.md');
  }

  /** Disciplina associada a este agente: SOCIOLOGIA. */
  public getDisciplina(): DisciplinaNome {
    return DisciplinaNome.SOCIOLOGIA;
  }

  /**
   * Habilidades BNCC prioritárias para Sociologia (Ensino Médio).
   *
   * A Sociologia está inserida na área de Ciências Humanas e Sociais
   * Aplicadas (CHS). As habilidades cobrem:
   * - EM13CHS101 a EM13CHS106: Tempo e Espaço (processos históricos e sociais)
   * - EM13CHS201 a EM13CHS206: Territórios e Fronteiras (identidade, alteridade, fluxos)
   * - EM13CHS301 a EM13CHS306: Indivíduo, Natureza e Cultura (socialização, instituições)
   * - EM13CHS401 a EM13CHS406: Política, Ética e Cidadania (Estado, direitos, participação)
   * - EM13CHS501 a EM13CHS506: Relações de Poder e Trabalho (classes, estratificação)
   * - EM13CHS601 a EM13CHS606: Cultura, Identidade e Diversidade (multiculturalismo, etnia)
   */
  public getHabilidadesPrioritarias(): string[] {
    return [
      'EM13CHS101', 'EM13CHS102', 'EM13CHS103', 'EM13CHS104', 'EM13CHS105',
      'EM13CHS106',
      'EM13CHS201', 'EM13CHS202', 'EM13CHS203', 'EM13CHS204', 'EM13CHS205',
      'EM13CHS206',
      'EM13CHS301', 'EM13CHS302', 'EM13CHS303', 'EM13CHS304', 'EM13CHS305',
      'EM13CHS306',
      'EM13CHS401', 'EM13CHS402', 'EM13CHS403', 'EM13CHS404', 'EM13CHS405',
      'EM13CHS406',
      'EM13CHS501', 'EM13CHS502', 'EM13CHS503', 'EM13CHS504', 'EM13CHS505',
      'EM13CHS506',
      'EM13CHS601', 'EM13CHS602', 'EM13CHS603', 'EM13CHS604', 'EM13CHS605',
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
    return `[RAG] Contexto de Sociologia para geração do tipo: ${tipo}. Nível: ${this.context.nivel}.`;
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
