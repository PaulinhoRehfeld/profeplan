// ============================================================================
// PROFEPLAN — Agent Ensino Religioso (Francisco) — S5-03
// Agente de disciplina concreto para Ensino Religioso — EF (somente Ensino Fundamental)
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
 * Agente de Ensino Religioso — "Francisco".
 *
 * Cobre EXCLUSIVAMENTE o Ensino Fundamental (6º ao 9º ano), gerando
 * planejamentos trimestrais, planos de aula e avaliações alinhados
 * à BNCC (área de Ensino Religioso) e ao Currículo Referência de
 * Minas Gerais.
 *
 * Foco: diversidade religiosa, valores humanos, ética, cultura de paz,
 * respeito às diferentes tradições religiosas e filosofias de vida,
 * laicidade do Estado, projetos de vida e convivência democrática.
 *
 * REGRA CRÍTICA: PROIBIDO PROSELITISMO RELIGIOSO.
 * PROIBIDO DOUTRINAÇÃO RELIGIOSA.
 * O agente DEVE manter postura laica e respeitosa com TODAS as
 * tradições religiosas e não religiosas (ateísmo, agnosticismo).
 * O Ensino Religioso no Brasil é disciplina de oferta obrigatória
 * e matrícula facultativa, com natureza NÃO CONFESSIONAL.
 */
export class AgentEnsinoReligioso extends BaseDisciplineAgent {
  /** Nome icônico do agente: "Francisco" (Papa Francisco / São Francisco de Assis). */
  public get displayName(): string {
    return AGENT_DISPLAY_NAMES[DisciplinaNome.ENSINO_RELIGIOSO]; // "Francisco"
  }

  /**
   * Constrói o system prompt para Ensino Religioso.
   *
   * Ensino Religioso é disciplina EXCLUSIVA do Ensino Fundamental
   * (6º ao 9º ano) no currículo brasileiro. Portanto, SEMPRE
   * retorna system-prompt-EF.md, independentemente do nível.
   */
  protected buildSystemPrompt(): string {
    return this._loadPrompt('system-prompt-EF.md');
  }

  /** Disciplina associada a este agente: ENSINO_RELIGIOSO. */
  public getDisciplina(): DisciplinaNome {
    return DisciplinaNome.ENSINO_RELIGIOSO;
  }

  /**
   * Habilidades BNCC prioritárias para Ensino Religioso (Ensino Fundamental).
   *
   * O Ensino Religioso possui habilidades próprias na BNCC, organizadas
   * por ano do Ensino Fundamental (6º ao 9º):
   *
   * Unidades Temáticas:
   * - Crenças religiosas e filosofias de vida
   * - Manifestações religiosas
   * - Identidades e alteridades
   *
   * 6º ano (EF06ER01 a EF06ER06):
   * - EF06ER01: Reconhecer o papel da tradição escrita na preservação de
   *   ensinamentos e valores.
   * - EF06ER02: Reconhecer e valorizar a diversidade de textos sagrados
   *   das diferentes tradições religiosas.
   * - EF06ER03: Reconhecer, em textos sagrados, ensinamentos e valores
   *   éticos que promovam o respeito à vida e à dignidade humana.
   * - EF06ER04: Reconhecer que os textos sagrados são instrumentos de
   *   registro e transmissão de valores.
   * - EF06ER05: Discutir como o estudo e a interpretação dos textos
   *   sagrados influenciam a vida pessoal e coletiva.
   * - EF06ER06: Reconhecer a importância dos mitos, ritos, símbolos e
   *   textos na estruturação das diferentes crenças e tradições religiosas.
   *
   * 7º ano (EF07ER01 a EF07ER07):
   * - EF07ER01: Reconhecer e respeitar as práticas de comunicação com as
   *   divindades em distintas manifestações e tradições religiosas.
   * - EF07ER02: Identificar práticas de espiritualidade utilizadas pelas
   *   pessoas em diferentes tradições religiosas.
   * - EF07ER03: Reconhecer os papéis atribuídos às lideranças religiosas
   *   de diferentes tradições.
   * - EF07ER04: Exemplificar líderes religiosos que se destacaram por
   *   suas contribuições à sociedade.
   * - EF07ER05: Discutir estratégias que promovam a convivência ética e
   *   respeitosa entre as diferentes tradições religiosas.
   * - EF07ER06: Identificar princípios éticos comuns às diversas tradições
   *   religiosas e filosofias de vida.
   * - EF07ER07: Identificar e discutir o papel das lideranças religiosas
   *   na defesa e promoção dos direitos humanos.
   *
   * 8º ano (EF08ER01 a EF08ER07):
   * - EF08ER01: Discutir como as crenças e convicções podem influenciar
   *   escolhas e atitudes pessoais e coletivas.
   * - EF08ER02: Analisar filosofias de vida, manifestações e tradições
   *   religiosas destacando seus princípios éticos.
   * - EF08ER03: Analisar doutrinas das diferentes tradições religiosas e
   *   suas concepções de mundo, vida e morte.
   * - EF08ER04: Discutir como filosofias de vida e tradições religiosas
   *   podem influenciar a constituição de projetos de vida.
   * - EF08ER05: Debater sobre as possibilidades e os limites da
   *   interferência das tradições religiosas na esfera pública.
   * - EF08ER06: Analisar práticas, projetos e políticas que contribuem
   *   para a promoção da liberdade de pensamento, crença e convicção.
   * - EF08ER07: Analisar as formas de uso das mídias e tecnologias pelas
   *   diferentes denominações religiosas.
   *
   * 9º ano (EF09ER01 a EF09ER08):
   * - EF09ER01: Analisar princípios e orientações para o cuidado da vida
   *   nas diversas tradições religiosas e filosofias de vida.
   * - EF09ER02: Listar e discutir as diferentes expressões de valorização
   *   e de desrespeito à vida.
   * - EF09ER03: Identificar sentidos do viver e do morrer em diferentes
   *   culturas e tradições religiosas.
   * - EF09ER04: Identificar concepções de vida e morte em diferentes
   *   tradições religiosas e filosofias de vida.
   * - EF09ER05: Analisar as diferentes ideias de imortalidade elaboradas
   *   pelas tradições religiosas.
   * - EF09ER06: Reconhecer o exercício da convivência e da coexistência
   *   como atitude ética de respeito à vida e à dignidade humana.
   * - EF09ER07: Identificar princípios éticos que possam alicerçar a
   *   construção de projetos de vida.
   * - EF09ER08: Construir projetos de vida assentados em princípios e
   *   valores éticos.
   */
  public getHabilidadesPrioritarias(): string[] {
    return [
      // 6º ano
      'EF06ER01', 'EF06ER02', 'EF06ER03', 'EF06ER04', 'EF06ER05',
      'EF06ER06',
      // 7º ano
      'EF07ER01', 'EF07ER02', 'EF07ER03', 'EF07ER04', 'EF07ER05',
      'EF07ER06', 'EF07ER07',
      // 8º ano
      'EF08ER01', 'EF08ER02', 'EF08ER03', 'EF08ER04', 'EF08ER05',
      'EF08ER06', 'EF08ER07',
      // 9º ano
      'EF09ER01', 'EF09ER02', 'EF09ER03', 'EF09ER04', 'EF09ER05',
      'EF09ER06', 'EF09ER07', 'EF09ER08',
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
    return `[RAG] Contexto de Ensino Religioso para geração do tipo: ${tipo}. Nível: ${this.context.nivel}.`;
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
