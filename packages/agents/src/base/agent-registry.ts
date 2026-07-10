// ============================================================================
// PROFEPLAN — Agent Registry
// S1-04: Registro centralizado com discovery automático de agentes
// ============================================================================

import {
  BaseDisciplineAgent,
  type DisciplinaContext,
  DisciplinaNome,
  NivelEnsino,
} from './discipline-agent-base';

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

/**
 * Assinatura de construtor para uma subclasse concreta de {@link BaseDisciplineAgent}.
 *
 * @example
 * ```ts
 * class AgentMatematicaEF extends BaseDisciplineAgent { ... }
 * const ctor: AgentConstructor = AgentMatematicaEF;
 * ```
 */
export type AgentConstructor = new (
  context: DisciplinaContext,
) => BaseDisciplineAgent;

/**
 * Entrada no registro de agentes.
 *
 * Cada entrada representa um agente concreto registrado,
 * combinando uma disciplina com um nível de ensino específico.
 */
export interface AgentEntry {
  /** Código único do agente (ex: `'Agent_LinguaPortuguesa_EF'`). */
  readonly codigo: string;
  /** Disciplina que este agente atende. */
  readonly disciplina: DisciplinaNome;
  /** Nível de ensino que este agente atende. */
  readonly nivel: NivelEnsino;
  /** Nome icônico do agente (ex: `'Machado'`, `'Einstein'`). */
  readonly displayName: string;
  /** Construtor da classe concreta do agente. */
  readonly construtor: AgentConstructor;
}

// ---------------------------------------------------------------------------
// AgentRegistry
// ---------------------------------------------------------------------------

/**
 * Registro centralizado de agentes de disciplina do PROFEPLAN.
 *
 * Responsável por armazenar, consultar e gerenciar o ciclo de vida
 * dos agentes concretos. A chave de registro é composta por
 * `${disciplina}_${nivel}`, garantindo unicidade.
 *
 * Suporte futuro a **discovery automático** via {@link discover},
 * que fará import dinâmico dos módulos de disciplina.
 */
export class AgentRegistry {
  /** Mapa interno: chave `${disciplina}_${nivel}` → {@link AgentEntry}. */
  private readonly agents: Map<string, AgentEntry>;

  public constructor() {
    this.agents = new Map();
  }

  // -----------------------------------------------------------------------
  // Registro
  // -----------------------------------------------------------------------

  /**
   * Registra um agente no registry.
   *
   * A chave é composta automaticamente como `${disciplina}_${nivel}`.
   * Caso já exista um agente para a mesma chave, o registro anterior
   * é sobrescrito e um warning é emitido no console.
   *
   * @param entry — Entrada do agente a ser registrada.
   */
  public register(entry: AgentEntry): void {
    const key = this.buildKey(entry.disciplina, entry.nivel);

    if (this.agents.has(key)) {
      console.warn(
        `[AgentRegistry] Sobrescrevendo agente '${key}': ` +
          `'${this.agents.get(key)!.displayName}' → '${entry.displayName}'`,
      );
    }

    this.agents.set(key, entry);
  }

  // -----------------------------------------------------------------------
  // Consulta
  // -----------------------------------------------------------------------

  /**
   * Obtém um agente por disciplina e nível de ensino.
   *
   * Estratégia de fallback: se não houver agente para a combinação
   * exata `${disciplina}_${nivel}`, retorna o primeiro agente
   * disponível para a mesma disciplina (qualquer nível).
   *
   * @param disciplina — Disciplina desejada.
   * @param nivel      — Nível de ensino desejado.
   * @returns A {@link AgentEntry} correspondente, ou `undefined`.
   */
  public getAgent(
    disciplina: DisciplinaNome,
    nivel: NivelEnsino,
  ): AgentEntry | undefined {
    const key = this.buildKey(disciplina, nivel);
    const exact = this.agents.get(key);

    if (exact) {
      return exact;
    }

    // Fallback: primeiro agente da mesma disciplina, qualquer nível
    for (const entry of this.agents.values()) {
      if (entry.disciplina === disciplina) {
        return entry;
      }
    }

    return undefined;
  }

  /**
   * Lista todos os agentes registrados.
   *
   * @returns Array com todas as {@link AgentEntry} do registry.
   */
  public listAgents(): AgentEntry[] {
    return Array.from(this.agents.values());
  }

  /**
   * Lista todos os agentes de uma disciplina específica (todos os níveis).
   *
   * @param disciplina — Disciplina a filtrar.
   * @returns Array de {@link AgentEntry} da disciplina informada.
   */
  public listByDisciplina(disciplina: DisciplinaNome): AgentEntry[] {
    const result: AgentEntry[] = [];

    for (const entry of this.agents.values()) {
      if (entry.disciplina === disciplina) {
        result.push(entry);
      }
    }

    return result;
  }

  /**
   * Lista todos os agentes de um nível de ensino específico (todas as disciplinas).
   *
   * @param nivel — Nível de ensino a filtrar.
   * @returns Array de {@link AgentEntry} do nível informado.
   */
  public listByNivel(nivel: NivelEnsino): AgentEntry[] {
    const result: AgentEntry[] = [];

    for (const entry of this.agents.values()) {
      if (entry.nivel === nivel) {
        result.push(entry);
      }
    }

    return result;
  }

  // -----------------------------------------------------------------------
  // Verificação
  // -----------------------------------------------------------------------

  /**
   * Verifica se existe um agente registrado para a combinação
   * disciplina + nível.
   *
   * @param disciplina — Disciplina a verificar.
   * @param nivel      — Nível de ensino a verificar.
   * @returns `true` se o agente estiver registrado.
   */
  public hasAgent(disciplina: DisciplinaNome, nivel: NivelEnsino): boolean {
    return this.agents.has(this.buildKey(disciplina, nivel));
  }

  // -----------------------------------------------------------------------
  // Remoção
  // -----------------------------------------------------------------------

  /**
   * Remove um agente do registro.
   *
   * @param disciplina — Disciplina do agente a remover.
   * @param nivel      — Nível de ensino do agente a remover.
   * @returns `true` se o agente existia e foi removido, `false` caso contrário.
   */
  public unregister(
    disciplina: DisciplinaNome,
    nivel: NivelEnsino,
  ): boolean {
    return this.agents.delete(this.buildKey(disciplina, nivel));
  }

  // -----------------------------------------------------------------------
  // Propriedades
  // -----------------------------------------------------------------------

  /**
   * Número total de agentes registrados.
   */
  public get size(): number {
    return this.agents.size;
  }

  // -----------------------------------------------------------------------
  // Discovery
  // -----------------------------------------------------------------------

  /**
   * Realiza o discovery automático de agentes de disciplina.
   *
   * **Placeholder** — a implementação definitiva utilizará import dinâmico
   * (`import()`) para carregar os módulos de disciplina sob demanda,
   * percorrendo o diretório `disciplinas/` e registrando cada classe
   * concreta que estenda {@link BaseDisciplineAgent}.
   *
   * @returns O número de agentes descobertos e registrados (atualmente 0).
   */
  public async discover(): Promise<number> {
    // TODO (S1-05+): Implementar discovery com import dinâmico.
    // 1. Varrer diretório `disciplinas/` no filesystem (ou usar
    //    glob de import estático com Vite/Rollup).
    // 2. Para cada módulo, verificar se exporta uma classe que
    //    estende BaseDisciplineAgent.
    // 3. Instanciar provisoriamente para extrair displayName,
    //    disciplina e nível.
    // 4. Chamar this.register() para cada agente descoberto.
    return 0;
  }

  // -----------------------------------------------------------------------
  // Helpers privados
  // -----------------------------------------------------------------------

  /**
   * Constrói a chave única de registro a partir de disciplina e nível.
   *
   * @param disciplina — Disciplina.
   * @param nivel      — Nível de ensino.
   * @returns Chave no formato `${disciplina}_${nivel}`.
   */
  private buildKey(disciplina: DisciplinaNome, nivel: NivelEnsino): string {
    return `${disciplina}_${nivel}`;
  }
}
