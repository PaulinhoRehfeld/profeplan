// ============================================================================
// PROFEPLAN — Agent Geografia (Milton) — S2-06
// Agente de disciplina concreto para Geografia — EF + EM
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
 * Agente de Geografia — "Milton".
 *
 * Homenagem a Milton Santos (1926–2001), maior geógrafo brasileiro,
 * referência mundial em geografia crítica, espaço geográfico e globalização.
 *
 * Cobre Ensino Fundamental (6º ao 9º ano) e Ensino Médio (1ª a 3ª série),
 * gerando planejamentos trimestrais, planos de aula e avaliações alinhados
 * à BNCC e ao Currículo Referência de Minas Gerais.
 *
 * Foco: espaço geográfico, cartografia, sustentabilidade, geoprocessamento,
 * geopolítica, globalização e preparação para o ENEM (Ciências Humanas).
 */
export class AgentGeografia extends BaseDisciplineAgent {
  /** Nome icônico do agente: "Milton" (homenagem a Milton Santos). */
  public get displayName(): string {
    return AGENT_DISPLAY_NAMES[DisciplinaNome.GEOGRAFIA]; // "Milton"
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
    return DisciplinaNome.GEOGRAFIA;
  }

  /**
   * Habilidades BNCC prioritárias para Geografia.
   *
   * Ensino Fundamental (6º ao 9º): EF06GE01 a EF09GE11.
   * Ensino Médio (1ª a 3ª): EM13CHS101 a EM13CHS606 (Ciências Humanas e Sociais Aplicadas).
   */
  public getHabilidadesPrioritarias(): string[] {
    if (this.context.nivel.startsWith('EF_')) {
      return [
        // 6º ano
        'EF06GE01', 'EF06GE02', 'EF06GE03', 'EF06GE04', 'EF06GE05',
        'EF06GE06', 'EF06GE07', 'EF06GE08', 'EF06GE09',
        // 7º ano
        'EF07GE01', 'EF07GE02', 'EF07GE03', 'EF07GE04', 'EF07GE05',
        'EF07GE06', 'EF07GE07', 'EF07GE08', 'EF07GE09',
        // 8º ano
        'EF08GE01', 'EF08GE02', 'EF08GE03', 'EF08GE04', 'EF08GE05',
        'EF08GE06', 'EF08GE07', 'EF08GE08', 'EF08GE09',
        // 9º ano
        'EF09GE01', 'EF09GE02', 'EF09GE03', 'EF09GE04', 'EF09GE05',
        'EF09GE06', 'EF09GE07', 'EF09GE08', 'EF09GE09', 'EF09GE10',
        'EF09GE11',
      ];
    }
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

  // --- Pipeline de geração (sobrescritas) ---

  /**
   * Constrói o contexto RAG a partir do Supabase + ContextBuilderAgent.
   * TODO: Integrar com ContextBuilderAgent + Supabase RAG (Sprint 3).
   */
  protected async _buildRagContext(tipo: TipoGeracao): Promise<string> {
    // TODO: Integrar com ContextBuilderAgent + Supabase RAG
    return `[RAG] Contexto de Geografia para geração do tipo: ${tipo}. Nível: ${this.context.nivel}.`;
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
      resposta_mock: `[MOCK] Conteúdo gerado por Milton (Geografia) para ${params.tema || 'tema não especificado'}.`,
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
    return `[PROMPT: ${filename}] Conteúdo do prompt para Geografia.`;
  }
}
