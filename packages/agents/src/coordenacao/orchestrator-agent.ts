// ============================================================================
// PROFEPLAN — Orchestrator Agent
// S1-05: Roteador principal que orquestra agentes de disciplina
// ============================================================================

import {
  BaseDisciplineAgent,
  type DisciplinaContext,
  DisciplinaNome,
  NivelEnsino,
  TipoGeracao,
  type GeracaoResultado,
} from '../base/discipline-agent-base';
import { AgentRegistry, type AgentEntry } from '../base/agent-registry';
import { QualityGatePipeline } from '../qualidade/quality-gate-pipeline';

// ---------------------------------------------------------------------------
// Interfaces públicas
// ---------------------------------------------------------------------------

/**
 * Requisição de geração enviada ao {@link OrchestratorAgent}.
 *
 * Contém todos os parâmetros necessários para que o orquestrador
 * localize o agente de disciplina correto, construa o contexto
 * e dispare o pipeline de geração.
 */
export interface GeracaoRequest {
  /** Disciplina alvo da geração. */
  readonly disciplina: DisciplinaNome;
  /** Nível de ensino alvo da geração. */
  readonly nivel: NivelEnsino;
  /** Tipo de conteúdo a ser gerado. */
  readonly tipo: TipoGeracao;
  /** Identificador do professor solicitante. */
  readonly professorId: string;
  /** Identificador da turma. */
  readonly turmaId: string;
  /** Parâmetros adicionais específicos do tipo de geração. */
  readonly params: Record<string, unknown>;
  /**
   * Feedback de tentativas anteriores.
   *
   * Preenchido automaticamente pelo pipeline de retry do próprio
   * {@link OrchestratorAgent} quando uma tentativa de geração falha,
   * permitindo que o agente ajuste a sua estratégia na tentativa seguinte.
   */
  feedback?: string;
}

/**
 * Resposta padronizada do {@link OrchestratorAgent} após processar
 * uma {@link GeracaoRequest}.
 */
export interface GeracaoResponse {
  /** Indica se a geração foi bem-sucedida. */
  readonly sucesso: boolean;
  /** Conteúdo gerado, presente apenas em caso de sucesso. */
  readonly conteudo?: Record<string, unknown>;
  /** Mensagem de erro descritiva, presente apenas em caso de falha. */
  readonly erro?: string;
  /** Metadados da execução (agente utilizado, tentativas, etc.). */
  readonly metadados?: {
    /** Nome icônico do agente que processou a requisição. */
    agente: string;
    /** Disciplina (valor do enum). */
    disciplina: string;
    /** Nível de ensino (valor do enum). */
    nivel: string;
    /** Número de tentativas realizadas até sucesso ou esgotamento. */
    tentativas: number;
    /** Timestamp ISO-8601 da resposta. */
    timestamp: string;
  };
}

// ---------------------------------------------------------------------------
// OrchestratorAgent
// ---------------------------------------------------------------------------

/**
 * Roteador principal do sistema de agentes do PROFEPLAN.
 *
 * Responsável por receber uma {@link GeracaoRequest}, localizar o agente
 * de disciplina adequado no {@link AgentRegistry}, construir o contexto
 * de execução e disparar o pipeline de geração com política de retry.
 *
 * @example
 * ```ts
 * const registry = new AgentRegistry();
 * // ... registrar agentes ...
 * const orchestrator = new OrchestratorAgent(registry);
 * const response = await orchestrator.processarRequisicao({
 *   disciplina: DisciplinaNome.MATEMATICA,
 *   nivel: NivelEnsino.EM_1,
 *   tipo: TipoGeracao.PLANO_AULA,
 *   professorId: 'prof-123',
 *   turmaId: 'turma-456',
 *   params: { tema: 'Funções Quadráticas' },
 * });
 * ```
 */
export class OrchestratorAgent {
  /** Registry de agentes utilizado para localizar agentes de disciplina. */
  public readonly registry: AgentRegistry;

  /** Número máximo de tentativas antes de desistir de uma geração. */
  public readonly maxRetries: number;

  /** Pipeline de qualidade opcional. Se fornecido, valida cada geração antes de retornar. */
  public readonly qualityPipeline?: QualityGatePipeline;

  /**
   * @param registry   — Instância de {@link AgentRegistry} com agentes registrados.
   * @param options    — Opções de configuração.
   * @param options.maxRetries — Número máximo de retentativas (default: 3).
   * @param options.qualityPipeline — Pipeline de qualidade opcional para validar gerações.
   */
  public constructor(
    registry: AgentRegistry,
    options?: { maxRetries?: number; qualityPipeline?: QualityGatePipeline },
  ) {
    this.registry = registry;
    this.maxRetries = options?.maxRetries ?? 3;
    this.qualityPipeline = options?.qualityPipeline;
  }

  // -----------------------------------------------------------------------
  // Método principal
  // -----------------------------------------------------------------------

  /**
   * Processa uma requisição de geração de conteúdo.
   *
   * Fluxo:
   * 1. Extrai disciplina e nível da request.
   * 2. Localiza o {@link AgentEntry} no registry.
   * 3. Se não encontrado, retorna {@link GeracaoResponse} com `sucesso=false`.
   * 4. Constrói o {@link DisciplinaContext}.
   * 5. Instancia o agente concreto.
   * 6. Executa loop de tentativas (até `maxRetries`):
   *    a. Chama `agent.gerar(tipo, params)`.
   *    b. Se sucesso → retorna resposta com conteúdo.
   *    c. Se falha → adiciona feedback e tenta novamente.
   * 7. Se esgotar tentativas → retorna resposta com erro.
   *
   * @param req — Requisição de geração.
   * @returns Resposta padronizada com conteúdo ou erro.
   */
  public async processarRequisicao(
    req: GeracaoRequest,
  ): Promise<GeracaoResponse> {
    const { disciplina, nivel } = this._parseDisciplina(req);

    // Localizar agente
    const entry = this._getAgentEntry(req);
    if (!entry) {
      return {
        sucesso: false,
        erro: `Nenhum agente registrado para disciplina='${disciplina}', nivel='${nivel}'. ` +
          `Certifique-se de que o agente foi registrado no AgentRegistry.`,
        metadados: {
          agente: 'N/A',
          disciplina,
          nivel,
          tentativas: 0,
          timestamp: new Date().toISOString(),
        },
      };
    }

    // Construir contexto e instanciar agente
    const context = this._buildContext(req);
    const agent: BaseDisciplineAgent = new entry.construtor(context);

    // Loop de tentativas com feedback acumulativo
    let feedbackAcumulado = req.feedback ?? '';
    let tentativas = 0;

    while (tentativas < this.maxRetries) {
      tentativas++;

      // Injeta feedback nos params para a tentativa atual
      const paramsComFeedback: Record<string, unknown> = {
        ...req.params,
      };
      if (feedbackAcumulado) {
        paramsComFeedback['_feedback'] = feedbackAcumulado;
      }

      const resultado: GeracaoResultado = await agent.gerar(
        req.tipo,
        paramsComFeedback,
      );

      if (resultado.sucesso) {
        // Se houver pipeline de qualidade, validar antes de retornar
        if (this.qualityPipeline) {
          const pipelineResult = await this.qualityPipeline.validate(resultado, req);

          if (pipelineResult.aprovado) {
            return {
              sucesso: true,
              conteudo: resultado.conteudo,
              metadados: {
                agente: entry.displayName,
                disciplina,
                nivel,
                tentativas,
                timestamp: new Date().toISOString(),
              },
            };
          }

          // Pipeline rejeitou — acumular feedback e tentar novamente
          const blockerMessages = pipelineResult.blockers
            .map((b) => b.message)
            .join('; ');
          feedbackAcumulado = feedbackAcumulado
            ? `${feedbackAcumulado} | [QualityGate] ${blockerMessages}`
            : `[QualityGate] ${blockerMessages}`;
          continue;
        }

        // Sem pipeline — retornar diretamente
        return {
          sucesso: true,
          conteudo: resultado.conteudo,
          metadados: {
            agente: entry.displayName,
            disciplina,
            nivel,
            tentativas,
            timestamp: new Date().toISOString(),
          },
        };
      }

      // Acumula feedback da falha para orientar a próxima tentativa
      const causa = resultado.metadados?.tipo
        ? `Falha na geração do tipo '${resultado.metadados.tipo}'`
        : 'Falha na geração';
      feedbackAcumulado = feedbackAcumulado
        ? `${feedbackAcumulado} | ${causa} (tentativa ${tentativas})`
        : `${causa} (tentativa ${tentativas})`;
    }

    // Esgotaram-se as tentativas
    return {
      sucesso: false,
      erro: `Falha após ${tentativas} tentativa(s) para disciplina='${disciplina}', ` +
        `nivel='${nivel}', tipo='${req.tipo}'. Último feedback: ${feedbackAcumulado}`,
      metadados: {
        agente: entry.displayName,
        disciplina,
        nivel,
        tentativas,
        timestamp: new Date().toISOString(),
      },
    };
  }

  // -----------------------------------------------------------------------
  // Métodos auxiliares (underscore = uso interno / compatibilidade futura)
  // -----------------------------------------------------------------------

  /**
   * Extrai disciplina e nível de ensino da requisição.
   *
   * Atualmente os campos já estão explícitos em {@link GeracaoRequest},
   * mas este método garante um ponto único de parsing para quando
   * a interface evoluir (ex: campo `disciplinaNivel` composto).
   *
   * @param req — Requisição de geração.
   * @returns Objeto com `disciplina` e `nivel` extraídos.
   */
  public _parseDisciplina(
    req: GeracaoRequest,
  ): { disciplina: DisciplinaNome; nivel: NivelEnsino } {
    return {
      disciplina: req.disciplina,
      nivel: req.nivel,
    };
  }

  /**
   * Busca o {@link AgentEntry} correspondente à requisição no registry.
   *
   * Utiliza {@link AgentRegistry.getAgent}, que aplica fallback:
   * se não houver match exato `disciplina + nivel`, retorna o primeiro
   * agente da mesma disciplina (qualquer nível).
   *
   * @param req — Requisição de geração.
   * @returns A entrada do agente, ou `undefined` se não encontrado.
   */
  public _getAgentEntry(req: GeracaoRequest): AgentEntry | undefined {
    return this.registry.getAgent(req.disciplina, req.nivel);
  }

  /**
   * Constrói o {@link DisciplinaContext} a partir da requisição.
   *
   * O contexto é o objeto imutável passado ao construtor de qualquer
   * {@link BaseDisciplineAgent}, contendo disciplina, nível, professor,
   * turma e materiais de apoio.
   *
   * @param req — Requisição de geração.
   * @returns Contexto pronto para instanciar um agente de disciplina.
   */
  public _buildContext(req: GeracaoRequest): DisciplinaContext {
    return {
      disciplina: req.disciplina,
      nivel: req.nivel,
      professorId: req.professorId,
      turmaId: req.turmaId,
    };
  }
}
