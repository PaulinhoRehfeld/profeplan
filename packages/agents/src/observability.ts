// ============================================================================
// PROFEPLAN V5 — Observability Dashboard
// S6-03: Métricas de latência, taxa de rejeição e scores dos agentes
// ============================================================================

/**
 * Métricas coletadas durante a execução do pipeline de agentes.
 */
export interface AgentMetrics {
  /** Timestamp ISO-8601 do início da geração. */
  timestamp: string;
  /** Disciplina alvo. */
  disciplina: string;
  /** Nível de ensino. */
  nivel: string;
  /** Tipo de geração. */
  tipo: string;
  /** Display name do agente utilizado. */
  agente: string;
  /** Número de tentativas até sucesso ou esgotamento. */
  tentativas: number;
  /** Latência total em milissegundos. */
  latenciaMs: number;
  /** Se a geração foi bem-sucedida. */
  sucesso: boolean;
  /** Score do pipeline de qualidade (0-1). */
  qualityScore?: number;
  /** Número de gates que falharam. */
  gatesFalhos?: number;
  /** Número de gates BLOCKER. */
  gatesBlockers?: number;
}

/**
 * Agregador de métricas para o dashboard de observabilidade.
 *
 * TODO: Enviar para Application Insights / Azure Monitor.
 */
export class ObservabilityDashboard {
  private metrics: AgentMetrics[] = [];

  /** Registra uma métrica de execução. */
  public record(metric: AgentMetrics): void {
    this.metrics.push(metric);
    // TODO: Enviar para Azure Application Insights
    // telemetryClient.trackEvent({ name: 'AgentGeneration', properties: metric });
  }

  /** Taxa de sucesso geral (%). */
  public get taxaSucesso(): number {
    if (this.metrics.length === 0) return 100;
    const sucessos = this.metrics.filter((m) => m.sucesso).length;
    return Math.round((sucessos / this.metrics.length) * 100);
  }

  /** Latência P95 em ms. */
  public get latenciaP95(): number {
    if (this.metrics.length === 0) return 0;
    const sorted = [...this.metrics].sort((a, b) => a.latenciaMs - b.latenciaMs);
    const idx = Math.ceil(sorted.length * 0.95) - 1;
    return sorted[idx]?.latenciaMs ?? 0;
  }

  /** Latência média em ms. */
  public get latenciaMedia(): number {
    if (this.metrics.length === 0) return 0;
    const total = this.metrics.reduce((sum, m) => sum + m.latenciaMs, 0);
    return Math.round(total / this.metrics.length);
  }

  /** Taxa de rejeição por quality gates (%). */
  public get taxaRejeicao(): number {
    if (this.metrics.length === 0) return 0;
    const rejeitados = this.metrics.filter((m) => (m.gatesBlockers ?? 0) > 0).length;
    return Math.round((rejeitados / this.metrics.length) * 100);
  }

  /** Score médio de qualidade. */
  public get qualityScoreMedio(): number {
    if (this.metrics.length === 0) return 1.0;
    const total = this.metrics.reduce((sum, m) => sum + (m.qualityScore ?? 1), 0);
    return Math.round((total / this.metrics.length) * 100) / 100;
  }

  /** Retorna todas as métricas (para exportação). */
  public getAllMetrics(): readonly AgentMetrics[] {
    return this.metrics;
  }

  /** Limpa o histórico de métricas. */
  public reset(): void {
    this.metrics = [];
  }
}
