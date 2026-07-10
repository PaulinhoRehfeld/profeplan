// ============================================================================
// PROFEPLAN — Quality Gate Pipeline
// S1-06: Framework de validação com gates plugáveis e fail-fast em BLOCKER
// ============================================================================

import type { GeracaoResultado, TipoGeracao } from '../base/discipline-agent-base';
import type { GeracaoRequest } from '../coordenacao/orchestrator-agent';

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/**
 * Severidade de um gate de qualidade.
 *
 * - `BLOCKER`: falha interrompe o pipeline imediatamente (fail-fast).
 * - `WARNING`: falha é reportada mas não bloqueia a entrega.
 * - `INFO`: falha é meramente informativa, sem impacto no fluxo.
 */
export type GateSeverity = 'BLOCKER' | 'WARNING' | 'INFO';

// ---------------------------------------------------------------------------
// Interfaces
// ---------------------------------------------------------------------------

/**
 * Resultado da execução de um gate individual de qualidade.
 */
export interface GateResult {
  /** Nome do gate (ex: 'BNCC Validator'). */
  readonly gate: string;
  /** Se passou na validação. */
  readonly passed: boolean;
  /** Severidade da falha (BLOCKER interrompe o pipeline). */
  readonly severity: GateSeverity;
  /** Score de 0.0 (falha total) a 1.0 (perfeito). */
  readonly score: number;
  /** Mensagem descritiva do resultado. */
  readonly message: string;
  /** Sugestão de correção (opcional). */
  readonly suggestion?: string;
}

/**
 * Resultado agregado da execução completa do {@link QualityGatePipeline}.
 */
export interface PipelineResult {
  /** `true` se nenhum gate `BLOCKER` falhou. */
  readonly aprovado: boolean;
  /** Score agregado (produto dos scores individuais). */
  readonly score: number;
  /** Lista completa de resultados de todos os gates executados. */
  readonly gateResults: readonly GateResult[];
  /** Subconjunto de {@link gateResults} cujo `passed === false`. */
  readonly failures: readonly GateResult[];
  /** Subconjunto de {@link gateResults} cujo `severity === 'BLOCKER'`. */
  readonly blockers: readonly GateResult[];
}

// ---------------------------------------------------------------------------
// BaseQualityGate (abstract)
// ---------------------------------------------------------------------------

/**
 * Classe base abstrata para gates de qualidade plugáveis.
 *
 * Cada gate concreto (ex: validador BNCC, detector de alucinação,
 * verificador de formato) estende esta classe e implementa os três
 * membros abstratos obrigatórios.
 *
 * O {@link QualityGatePipeline} itera sobre instâncias desta classe,
 * chamando {@link isApplicable} antes de {@link check} para pular
 * gates irrelevantes para o tipo de geração corrente.
 */
export abstract class BaseQualityGate {
  /** Nome descritivo do gate (ex: 'BNCC Validator'). */
  public abstract get name(): string;

  /**
   * Determina se este gate é aplicável ao tipo de geração informado.
   *
   * @param tipo — Tipo de geração sendo validada.
   * @returns `true` se o gate deve ser executado para este tipo.
   */
  public abstract isApplicable(tipo: TipoGeracao): boolean;

  /**
   * Executa a validação do gate sobre o resultado de uma geração.
   *
   * @param resultado — Resultado da geração produzida pelo agente de disciplina.
   * @param req       — Requisição original que originou a geração.
   * @returns Promise com o {@link GateResult} contendo score, passed, mensagem etc.
   */
  public abstract check(
    resultado: GeracaoResultado,
    req: GeracaoRequest,
  ): Promise<GateResult>;
}

// ---------------------------------------------------------------------------
// QualityGatePipeline
// ---------------------------------------------------------------------------

/**
 * Pipeline de validação de qualidade para conteúdos gerados pelos agentes.
 *
 * Mantém uma lista de {@link BaseQualityGate} registrados e os executa
 * em sequência sobre cada {@link GeracaoResultado}. Aplica política
 * **fail-fast**: se um gate com severidade `BLOCKER` falhar, o pipeline
 * é interrompido imediatamente e o resultado agregado é retornado.
 *
 * Gates cujo {@link BaseQualityGate.isApplicable} retornar `false` para
 * o tipo de geração corrente são automaticamente ignorados (skip).
 *
 * O score agregado é o **produto** dos scores individuais, o que pune
 * múltiplas falhas parciais de forma multiplicativa.
 *
 * @example
 * ```ts
 * const pipeline = new QualityGatePipeline();
 * pipeline.addGate(new BnccValidator());
 * pipeline.addGate(new HallucinationDetector());
 *
 * const result = await pipeline.validate(geracaoResultado, request);
 * if (!result.aprovado) {
 *   console.error('Blockers:', result.blockers);
 * }
 * ```
 */
export class QualityGatePipeline {
  /** Lista interna de gates registrados. */
  private readonly _gates: BaseQualityGate[];

  /**
   * @param gates — Lista opcional de gates para inicializar o pipeline.
   */
  public constructor(gates: BaseQualityGate[] = []) {
    this._gates = [...gates];
  }

  /**
   * Adiciona um gate ao final do pipeline.
   *
   * @param gate — Instância de {@link BaseQualityGate} a ser registrada.
   */
  public addGate(gate: BaseQualityGate): void {
    this._gates.push(gate);
  }

  /**
   * Remove um gate do pipeline pelo nome.
   *
   * @param name — Nome do gate a ser removido (case-sensitive).
   * @returns `true` se o gate foi encontrado e removido, `false` caso contrário.
   */
  public removeGate(name: string): boolean {
    const index = this._gates.findIndex((g) => g.name === name);
    if (index === -1) return false;
    this._gates.splice(index, 1);
    return true;
  }

  /**
   * Retorna a lista imutável de gates atualmente registrados.
   *
   * @returns Array readonly com os gates na ordem de execução.
   */
  public getGates(): readonly BaseQualityGate[] {
    return this._gates;
  }

  /**
   * Executa todos os gates aplicáveis em sequência sobre o resultado
   * de uma geração.
   *
   * **Algoritmo:**
   * 1. Inicializa `gateResults = []`, `score = 1.0`.
   * 2. Para cada gate registrado:
   *    a. Se `!gate.isApplicable(req.tipo)` → pula (skip).
   *    b. Executa `gate.check(resultado, req)`.
   *    c. Adiciona o `GateResult` à lista.
   *    d. Multiplica o score acumulado: `score *= gateResult.score`.
   *    e. Se `severity === 'BLOCKER'` e `!passed`:
   *       → **FAIL-FAST**: retorna imediatamente `PipelineResult` com `aprovado = false`.
   * 3. Ao final (sem blockers), retorna `PipelineResult` com `aprovado = true`.
   *
   * @param resultado — Resultado da geração a ser validado.
   * @param req       — Requisição original que originou a geração.
   * @returns Promise com o {@link PipelineResult} agregado.
   */
  public async validate(
    resultado: GeracaoResultado,
    req: GeracaoRequest,
  ): Promise<PipelineResult> {
    const gateResults: GateResult[] = [];
    let score = 1.0;

    for (const gate of this._gates) {
      // Pula gates não aplicáveis ao tipo de geração corrente
      if (!gate.isApplicable(req.tipo)) {
        continue;
      }

      const gateResult = await gate.check(resultado, req);
      gateResults.push(gateResult);
      score *= gateResult.score;

      // Fail-fast: interrompe no primeiro BLOCKER que falhar
      if (gateResult.severity === 'BLOCKER' && !gateResult.passed) {
        return this._buildPipelineResult(false, score, gateResults);
      }
    }

    // Nenhum BLOCKER falhou → aprovado
    return this._buildPipelineResult(true, score, gateResults);
  }

  // -----------------------------------------------------------------------
  // Private helpers
  // -----------------------------------------------------------------------

  /**
   * Constrói o {@link PipelineResult} a partir dos resultados acumulados.
   *
   * @param aprovado    — Se o pipeline foi aprovado.
   * @param score       — Score agregado (produto).
   * @param gateResults — Lista de resultados individuais.
   * @returns Objeto {@link PipelineResult} imutável.
   */
  private _buildPipelineResult(
    aprovado: boolean,
    score: number,
    gateResults: readonly GateResult[],
  ): PipelineResult {
    const failures = gateResults.filter((r) => !r.passed);
    const blockers = gateResults.filter((r) => r.severity === 'BLOCKER');

    return {
      aprovado,
      score,
      gateResults,
      failures,
      blockers,
    };
  }
}
