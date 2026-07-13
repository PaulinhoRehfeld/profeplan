// ============================================================================
// PROFEPLAN — Session Agent
// S2-02: Varredura de contexto trimestral e histórico de gerações
// ============================================================================

import { DisciplinaNome, NivelEnsino } from '../base/discipline-agent-base';

// ---------------------------------------------------------------------------
// Interfaces públicas
// ---------------------------------------------------------------------------

/**
 * Contexto trimestral de uma turma para uma disciplina.
 *
 * Agrega as aulas já ministradas (anteriores) e as planejadas (futuras)
 * dentro do trimestre corrente, permitindo que os agentes de geração
 * mantenham continuidade pedagógica.
 */
export interface TrimestralContext {
  /** Identificador da turma. */
  readonly turmaId: string;
  /** Disciplina de referência. */
  readonly disciplina: DisciplinaNome;
  /** Nível de ensino da turma. */
  readonly nivel: NivelEnsino;
  /** Lista de aulas já ministradas no trimestre (títulos/temas). */
  readonly aulasAnteriores: string[];
  /** Lista de aulas planejadas para o restante do trimestre. */
  readonly aulasFuturas: string[];
  /** Número do trimestre corrente (1, 2 ou 3). */
  readonly trimestreAtual: number;
}

/**
 * Registro individual de uma geração no histórico do {@link SessionAgent}.
 *
 * Cada chamada a {@link SessionAgent.registrarGeracao} produz uma entrada
 * imutável vinculada a uma turma e disciplina.
 */
export interface RegistroGeracao {
  /** Identificador único da geração. */
  readonly id: string;
  /** Identificador da turma. */
  readonly turmaId: string;
  /** Disciplina da geração. */
  readonly disciplina: DisciplinaNome;
  /** Tipo de conteúdo gerado (ex: 'PLANO_AULA', 'AVALIACAO'). */
  readonly tipo: string;
  /** Timestamp ISO-8601 da geração. */
  readonly timestamp: string;
  /** Resumo textual do conteúdo gerado. */
  readonly resumo: string;
}

// ---------------------------------------------------------------------------
// SessionAgent
// ---------------------------------------------------------------------------

/**
 * Agente responsável pela varredura de contexto trimestral e pelo
 * histórico de gerações de uma turma.
 *
 * ## Responsabilidades
 *
 * - Varrer o planejamento trimestral da turma e retornar o
 *   {@link TrimestralContext} com aulas anteriores e futuras.
 * - Registrar cada geração (plano de aula, avaliação, etc.) no
 *   histórico em memória, permitindo verificações de continuidade.
 * - Verificar se um novo plano mantém continuidade com as aulas
 *   já registradas no histórico.
 *
 * ## Estado atual
 *
 * Implementação **mock** com dados sintéticos. A integração real com
 * Supabase será feita nas próximas sprints.
 *
 * @example
 * ```ts
 * const session = new SessionAgent();
 * const ctx = await session.getTrimestralContext('turma-1', DisciplinaNome.MATEMATICA);
 * console.log(ctx.aulasAnteriores.length); // 3
 * console.log(ctx.aulasFuturas.length);    // 2
 * ```
 */
export class SessionAgent {
  /** Histórico em memória de todas as gerações registradas. */
  private readonly historico: RegistroGeracao[] = [];

  // -----------------------------------------------------------------------
  // getTrimestralContext
  // -----------------------------------------------------------------------

  /**
   * Varre o planejamento trimestral da turma e retorna o contexto
   * completo com aulas anteriores e futuras.
   *
   * @param turmaId    - Identificador da turma.
   * @param disciplina - Disciplina para a qual obter o contexto.
   * @returns Contexto trimestral com aulas anteriores, futuras e metadados.
   */
  async getTrimestralContext(
    turmaId: string,
    disciplina: DisciplinaNome
  ): Promise<TrimestralContext> {
    // TODO: Integrar com Supabase — buscar planejamento trimestral real
    return {
      turmaId,
      disciplina,
      nivel: NivelEnsino.EM_1,
      aulasAnteriores: [
        'Introdução à disciplina',
        'Revisão de conceitos básicos',
        'Aprofundamento — tópico 1',
      ],
      aulasFuturas: ['Tópico 2 — continuação', 'Preparação para avaliação trimestral'],
      trimestreAtual: 2,
    };
  }

  // -----------------------------------------------------------------------
  // registrarGeracao
  // -----------------------------------------------------------------------

  /**
   * Registra uma geração no histórico interno.
   *
   * Extrai um resumo textual do resultado e armazena uma entrada
   * imutável de {@link RegistroGeracao}.
   *
   * @param resultado - Conteúdo gerado (mapa chave-valor arbitrário).
   * @param metadata  - Metadados da geração: turma, disciplina e tipo.
   */
  async registrarGeracao(
    resultado: Record<string, unknown>,
    metadata: { turmaId: string; disciplina: DisciplinaNome; tipo: string }
  ): Promise<void> {
    // TODO: Integrar com Supabase — persistir registro de geração
    const resumo = this.extrairResumo(resultado);

    const registro: RegistroGeracao = {
      id: crypto.randomUUID(),
      turmaId: metadata.turmaId,
      disciplina: metadata.disciplina,
      tipo: metadata.tipo,
      timestamp: new Date().toISOString(),
      resumo,
    };

    this.historico.push(registro);
  }

  // -----------------------------------------------------------------------
  // verificarContinuidade
  // -----------------------------------------------------------------------

  /**
   * Verifica se o novo plano mantém continuidade com as aulas
   * registradas anteriormente no histórico da turma.
   *
   * A implementação atual é um **mock**: sempre retorna `continuo: true`
   * com um alerta informativo. A verificação real de sobreposição
   * temática será implementada com embeddings.
   *
   * @param _novoPlano - Conteúdo do novo plano a ser verificado.
   * @param turmaId    - Identificador da turma.
   * @returns Objeto com a flag `continuo` e lista de `alertas`.
   */
  async verificarContinuidade(
    _novoPlano: Record<string, unknown>,
    turmaId: string
  ): Promise<{ continuo: boolean; alertas: string[] }> {
    // TODO: Integrar com Supabase — verificação real de sobreposição temática
    const geracoesTurma = this.historico.filter((r) => r.turmaId === turmaId);

    const alertas: string[] = [
      '[SessionAgent] Verificação de continuidade em modo mock — sempre retorna continuo: true.',
    ];

    if (geracoesTurma.length === 0) {
      alertas.push(
        `[SessionAgent] Nenhum registro anterior encontrado para a turma ${turmaId}. Esta é a primeira geração.`
      );
    } else {
      alertas.push(
        `[SessionAgent] ${geracoesTurma.length} registro(s) anterior(es) encontrado(s) para a turma ${turmaId}. Continuidade presumida.`
      );
    }

    return { continuo: true, alertas };
  }

  // -----------------------------------------------------------------------
  // getHistorico
  // -----------------------------------------------------------------------

  /**
   * Retorna o histórico de gerações, opcionalmente filtrado por
   * turma e disciplina.
   *
   * @param turmaId    - Identificador da turma (obrigatório).
   * @param disciplina - Disciplina para filtrar (opcional).
   * @returns Array de registros de geração que atendem aos filtros.
   */
  getHistorico(turmaId: string, disciplina?: DisciplinaNome): RegistroGeracao[] {
    return this.historico.filter((registro) => {
      const matchTurma = registro.turmaId === turmaId;
      const matchDisciplina = disciplina === undefined || registro.disciplina === disciplina;
      return matchTurma && matchDisciplina;
    });
  }

  // -----------------------------------------------------------------------
  // Métodos privados auxiliares
  // -----------------------------------------------------------------------

  /**
   * Extrai um resumo textual de um resultado de geração.
   *
   * Tenta obter o resumo de campos conhecidos (`resumo`, `titulo`,
   * `tema`) e recorre a uma representação JSON truncada como fallback.
   *
   * @param resultado - Mapa chave-valor com o conteúdo gerado.
   * @returns String de resumo para o registro de histórico.
   */
  private extrairResumo(resultado: Record<string, unknown>): string {
    const candidato = resultado.resumo ?? resultado.titulo ?? resultado.tema;
    if (typeof candidato === 'string' && candidato.length > 0) {
      return candidato;
    }
    const json = JSON.stringify(resultado);
    return json.length > 200 ? `${json.slice(0, 200)}...` : json;
  }
}
