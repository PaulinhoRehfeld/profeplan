// ============================================================================
// PROFEPLAN — Agent Lingua Portuguesa (Machado) — S2-03
// Agente de disciplina concreto para Língua Portuguesa — EF + EM
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
 * Agente de Língua Portuguesa — "Machado".
 *
 * Cobre Ensino Fundamental (6º ao 9º ano) e Ensino Médio (1ª a 3ª série),
 * gerando planejamentos trimestrais, planos de aula e avaliações alinhados
 * à BNCC e ao Currículo Referência de Minas Gerais.
 */
export class AgentLinguaPortuguesa extends BaseDisciplineAgent {
  /** Nome icônico do agente: "Machado" (homenagem a Machado de Assis). */
  public get displayName(): string {
    return AGENT_DISPLAY_NAMES[DisciplinaNome.LINGUA_PORTUGUESA]; // "Machado"
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
    return DisciplinaNome.LINGUA_PORTUGUESA;
  }

  /**
   * Habilidades BNCC prioritárias para Língua Portuguesa.
   *
   * Ensino Fundamental: foco em leitura, produção textual e análise linguística.
   * Ensino Médio: foco em competências do ENEM e produção dissertativo-argumentativa.
   */
  public getHabilidadesPrioritarias(): string[] {
    if (this.context.nivel.startsWith('EF_')) {
      return ['EF06LP01', 'EF06LP02', 'EF07LP01', 'EF08LP01', 'EF09LP01'];
    }
    return ['EM13LP01', 'EM13LP02', 'EM13LP03', 'EM13LP04', 'EM13LP05'];
  }

  // --- Pipeline de geração (sobrescritas) ---

  /**
   * Constrói o contexto RAG a partir do Supabase + ContextBuilderAgent.
   * TODO: Integrar com ContextBuilderAgent + Supabase RAG (Sprint 3).
   */
  protected async _buildRagContext(tipo: TipoGeracao): Promise<string> {
    // TODO: Integrar com ContextBuilderAgent + Supabase RAG
    return `[RAG] Contexto de Língua Portuguesa para geração do tipo: ${tipo}. Nível: ${this.context.nivel}.`;
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
      resposta_mock: `[MOCK] Conteúdo gerado por Machado (Língua Portuguesa) para ${params.tema || 'tema não especificado'}.`,
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
    return `[PROMPT: ${filename}] Conteúdo do prompt para Língua Portuguesa.`;
  }
}
