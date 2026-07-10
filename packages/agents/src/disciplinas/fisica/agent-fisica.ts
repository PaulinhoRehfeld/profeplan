// ============================================================================
// PROFEPLAN — Agent Física (Einstein) — S3-04
// Agente de disciplina concreto para Física — EM (somente Ensino Médio)
// ============================================================================

import {
  BaseDisciplineAgent,
  DisciplinaNome,
  NivelEnsino,
  TipoGeracao,
  type GeracaoResultado,
  AGENT_DISPLAY_NAMES,
} from '../../base/discipline-agent-base';

/**
 * Agente de Física — "Einstein".
 *
 * Cobre EXCLUSIVAMENTE o Ensino Médio (1ª a 3ª série), gerando
 * planejamentos trimestrais, planos de aula e avaliações alinhados
 * à BNCC (área de Ciências da Natureza e suas Tecnologias) e ao
 * Currículo Referência de Minas Gerais.
 *
 * Foco: experimentação com materiais de baixo custo, modelagem
 * matemática de fenômenos físicos, competências ENEM C1-C7
 * (Ciências da Natureza), preparação para vestibulares.
 *
 * REGRA CRÍTICA: PROIBIDO INVENTAR FÓRMULAS OU CONSTANTES FÍSICAS.
 * Toda fórmula, lei ou constante DEVE estar confirmada na base RAG.
 */
export class AgentFisica extends BaseDisciplineAgent {
  /** Nome icônico do agente: "Einstein" (homenagem a Albert Einstein). */
  public get displayName(): string {
    return AGENT_DISPLAY_NAMES[DisciplinaNome.FISICA]; // "Einstein"
  }

  /**
   * Constrói o system prompt para Física.
   *
   * Física é disciplina EXCLUSIVA do Ensino Médio no currículo brasileiro.
   * Portanto, SEMPRE retorna system-prompt-EM.md, independentemente do nível.
   */
  protected buildSystemPrompt(): string {
    return this._loadPrompt('system-prompt-EM.md');
  }

  /** Disciplina associada a este agente: FISICA. */
  public getDisciplina(): DisciplinaNome {
    return DisciplinaNome.FISICA;
  }

  /**
   * Habilidades BNCC prioritárias para Física (Ensino Médio).
   *
   * A Física está inserida na área de Ciências da Natureza e suas
   * Tecnologias (CNT). As habilidades cobrem:
   * - EM13CNT101 a EM13CNT107: Matéria e Energia (ênfase em Física)
   * - EM13CNT201 a EM13CNT208: Vida e Evolução (interfaces com Física)
   * - EM13CNT301 a EM13CNT310: Terra e Universo (ênfase em Física)
   */
  public getHabilidadesPrioritarias(): string[] {
    return [
      // Matéria e Energia — foco principal em Física
      'EM13CNT101', 'EM13CNT102', 'EM13CNT103', 'EM13CNT104', 'EM13CNT105',
      'EM13CNT106', 'EM13CNT107',
      // Vida e Evolução — interfaces Física-Biologia
      'EM13CNT201', 'EM13CNT202', 'EM13CNT203', 'EM13CNT204', 'EM13CNT205',
      'EM13CNT206', 'EM13CNT207', 'EM13CNT208',
      // Terra e Universo — foco principal em Física (Astronomia, Cosmologia)
      'EM13CNT301', 'EM13CNT302', 'EM13CNT303', 'EM13CNT304', 'EM13CNT305',
      'EM13CNT306', 'EM13CNT307', 'EM13CNT308', 'EM13CNT309', 'EM13CNT310',
    ];
  }

  // --- Pipeline de geração (sobrescritas) ---

  /**
   * Constrói o contexto RAG a partir do Supabase + ContextBuilderAgent.
   * TODO: Integrar com ContextBuilderAgent + Supabase RAG (Sprint 3).
   */
  protected async _buildRagContext(tipo: TipoGeracao): Promise<string> {
    // TODO: Integrar com ContextBuilderAgent + Supabase RAG
    return `[RAG] Contexto de Física para geração do tipo: ${tipo}. Nível: ${this.context.nivel}.`;
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

  /**
   * Invoca o modelo de linguagem (Azure OpenAI) com prompt, contexto RAG e parâmetros.
   * TODO: Integrar com Azure OpenAI (Sprint 3).
   */
  protected async _callLLM(
    prompt: string,
    ragContext: string,
    params: Record<string, unknown>,
  ): Promise<string> {
    // TODO: Integrar com Azure OpenAI
    return JSON.stringify({
      prompt_usado: prompt.substring(0, 80) + '...',
      contexto_rag: ragContext,
      params_recebidos: params,
      resposta_mock: `[MOCK] Conteúdo gerado por Einstein (Física) para ${params.tema || 'tema não especificado'}.`,
    });
  }

  /**
   * Pós-processa a saída bruta do LLM no formato {@link GeracaoResultado}.
   */
  protected async _postProcess(raw: string, tipo: TipoGeracao): Promise<GeracaoResultado> {
    let conteudo: Record<string, unknown>;
    try {
      conteudo = JSON.parse(raw) as Record<string, unknown>;
    } catch {
      conteudo = { raw, erro: 'Falha ao parsear JSON do LLM' };
    }
    return {
      sucesso: true,
      conteudo,
      metadados: {
        agente: this.displayName,
        disciplina: this.getDisciplina(),
        nivel: this.context.nivel,
        tipo,
        timestamp: new Date().toISOString(),
      },
    };
  }

  // --- Helpers privados ---

  /**
   * Carrega o conteúdo de um arquivo de prompt.
   *
   * No estágio atual (mock), retorna o nome do arquivo como placeholder.
   * TODO: Carregar do sistema de arquivos ou Supabase (Sprint 3).
   */
  private _loadPrompt(filename: string): string {
    // TODO: Carregar do sistema de arquivos ou Supabase
    return `[PROMPT: ${filename}] Conteúdo do prompt para Física.`;
  }
}
