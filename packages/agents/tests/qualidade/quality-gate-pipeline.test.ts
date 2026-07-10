// ============================================================================
// PROFEPLAN — Testes: quality-gate-pipeline
// S1-07: Testes unitários para QualityGatePipeline e BaseQualityGate
// ============================================================================

import { describe, it, expect } from 'vitest';
import { TipoGeracao } from '../../src/base/discipline-agent-base';
import type { GeracaoResultado } from '../../src/base/discipline-agent-base';
import type { GeracaoRequest } from '../../src/coordenacao/orchestrator-agent';
import {
  BaseQualityGate,
  QualityGatePipeline,
} from '../../src/qualidade/quality-gate-pipeline';
import type { GateResult, GateSeverity } from '../../src/qualidade/quality-gate-pipeline';

// Re-imports para construção de dummies
import { DisciplinaNome, NivelEnsino } from '../../src/base/discipline-agent-base';

// ---------------------------------------------------------------------------
// Dummy Gates
// ---------------------------------------------------------------------------

/** Gate dummy que sempre passa com score 1.0. */
class GateAlwaysPass extends BaseQualityGate {
  public get name(): string {
    return 'AlwaysPass';
  }

  public isApplicable(_tipo: TipoGeracao): boolean {
    return true;
  }

  public async check(
    _resultado: GeracaoResultado,
    _req: GeracaoRequest,
  ): Promise<GateResult> {
    return {
      gate: this.name,
      passed: true,
      severity: 'INFO',
      score: 1.0,
      message: 'Always passes.',
    };
  }
}

/** Gate dummy BLOCKER que sempre falha. */
class GateBlockerFail extends BaseQualityGate {
  public get name(): string {
    return 'BlockerFail';
  }

  public isApplicable(_tipo: TipoGeracao): boolean {
    return true;
  }

  public async check(
    _resultado: GeracaoResultado,
    _req: GeracaoRequest,
  ): Promise<GateResult> {
    return {
      gate: this.name,
      passed: false,
      severity: 'BLOCKER',
      score: 0.0,
      message: 'Blocker failure detected.',
      suggestion: 'Fix the critical issue.',
    };
  }
}

/** Gate dummy com score parcial (0.9). */
class GateScorePartial extends BaseQualityGate {
  public get name(): string {
    return 'ScorePartial';
  }

  public isApplicable(_tipo: TipoGeracao): boolean {
    return true;
  }

  public async check(
    _resultado: GeracaoResultado,
    _req: GeracaoRequest,
  ): Promise<GateResult> {
    return {
      gate: this.name,
      passed: true,
      severity: 'WARNING',
      score: 0.9,
      message: 'Partial score — some warnings.',
    };
  }
}

/** Gate dummy que NÃO é aplicável para SIMULADO. */
class GateNotApplicableForSimulado extends BaseQualityGate {
  public get name(): string {
    return 'NotForSimulado';
  }

  public isApplicable(tipo: TipoGeracao): boolean {
    return tipo !== TipoGeracao.SIMULADO;
  }

  public async check(
    _resultado: GeracaoResultado,
    _req: GeracaoRequest,
  ): Promise<GateResult> {
    return {
      gate: this.name,
      passed: true,
      severity: 'INFO',
      score: 1.0,
      message: 'Checked.',
    };
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/** Cria um GeracaoResultado dummy com sucesso. */
function makeResultado(): GeracaoResultado {
  return {
    sucesso: true,
    conteudo: { tema: 'Funções' },
    metadados: {
      agente: 'Pitágoras',
      disciplina: 'MATEMATICA',
      nivel: 'EF_6',
      tipo: 'PLANO_AULA',
      timestamp: new Date().toISOString(),
    },
  };
}

/** Cria uma GeracaoRequest dummy. */
function makeRequest(tipo: TipoGeracao = TipoGeracao.PLANO_AULA): GeracaoRequest {
  return {
    disciplina: DisciplinaNome.MATEMATICA,
    nivel: NivelEnsino.EF_6,
    tipo,
    professorId: 'prof-001',
    turmaId: 'turma-001',
    params: {},
  };
}

// ===========================================================================
// Testes: QualityGatePipeline
// ===========================================================================

describe('QualityGatePipeline', () => {
  // --- Criação ---

  it('deve criar pipeline vazio (sem gates)', () => {
    const pipeline = new QualityGatePipeline();
    expect(pipeline.getGates()).toEqual([]);
  });

  it('deve criar pipeline com gates iniciais', () => {
    const gate = new GateAlwaysPass();
    const pipeline = new QualityGatePipeline([gate]);
    expect(pipeline.getGates()).toHaveLength(1);
    expect(pipeline.getGates()[0]).toBe(gate);
  });

  // --- addGate ---

  it('addGate deve adicionar gate ao pipeline', () => {
    const pipeline = new QualityGatePipeline();
    const gate = new GateAlwaysPass();

    pipeline.addGate(gate);

    expect(pipeline.getGates()).toHaveLength(1);
    expect(pipeline.getGates()[0]).toBe(gate);
  });

  it('addGate deve adicionar múltiplos gates em ordem', () => {
    const pipeline = new QualityGatePipeline();
    const gate1 = new GateAlwaysPass();
    const gate2 = new GateScorePartial();

    pipeline.addGate(gate1);
    pipeline.addGate(gate2);

    const gates = pipeline.getGates();
    expect(gates).toHaveLength(2);
    expect(gates[0].name).toBe('AlwaysPass');
    expect(gates[1].name).toBe('ScorePartial');
  });

  // --- getGates ---

  it('getGates deve retornar array readonly com os gates', () => {
    const pipeline = new QualityGatePipeline();
    const gate = new GateAlwaysPass();
    pipeline.addGate(gate);

    const gates = pipeline.getGates();
    expect(gates).toHaveLength(1);
    expect(gates[0].name).toBe('AlwaysPass');
  });

  // --- removeGate ---

  it('removeGate deve remover gate existente por nome e retornar true', () => {
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new GateAlwaysPass());
    pipeline.addGate(new GateScorePartial());

    const removed = pipeline.removeGate('AlwaysPass');
    expect(removed).toBe(true);
    expect(pipeline.getGates()).toHaveLength(1);
    expect(pipeline.getGates()[0].name).toBe('ScorePartial');
  });

  it('removeGate deve retornar false para gate inexistente', () => {
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new GateAlwaysPass());

    const removed = pipeline.removeGate('NonExistent');
    expect(removed).toBe(false);
    expect(pipeline.getGates()).toHaveLength(1);
  });

  it('removeGate é case-sensitive', () => {
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new GateAlwaysPass());

    const removed = pipeline.removeGate('alwayspass'); // case diferente
    expect(removed).toBe(false);
    expect(pipeline.getGates()).toHaveLength(1);
  });

  // --- validate: gate que passa ---

  it('validate com um gate que passa deve retornar aprovado=true', async () => {
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new GateAlwaysPass());

    const result = await pipeline.validate(makeResultado(), makeRequest());

    expect(result.aprovado).toBe(true);
    expect(result.gateResults).toHaveLength(1);
    expect(result.gateResults[0].passed).toBe(true);
    expect(result.failures).toHaveLength(0);
    expect(result.blockers).toHaveLength(0);
  });

  // --- validate: gate BLOCKER que falha (fail-fast) ---

  it('validate deve interromper no primeiro BLOCKER que falha (fail-fast)', async () => {
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new GateAlwaysPass());    // passa
    pipeline.addGate(new GateBlockerFail());   // BLOCKER falha → fail-fast
    pipeline.addGate(new GateScorePartial());  // NUNCA deve ser executado

    const result = await pipeline.validate(makeResultado(), makeRequest());

    expect(result.aprovado).toBe(false);
    // Apenas 2 gates executados (o terceiro foi pulado pelo fail-fast)
    expect(result.gateResults).toHaveLength(2);
    expect(result.gateResults[0].gate).toBe('AlwaysPass');
    expect(result.gateResults[1].gate).toBe('BlockerFail');
    expect(result.failures).toHaveLength(1);
    expect(result.failures[0].gate).toBe('BlockerFail');
    expect(result.blockers).toHaveLength(1);
  });

  // --- validate: gate não aplicável é pulado ---

  it('validate deve pular gate cujo isApplicable retorna false', async () => {
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new GateAlwaysPass());
    pipeline.addGate(new GateNotApplicableForSimulado());

    // Request com tipo SIMULADO → NotForSimulado.isApplicable = false
    const result = await pipeline.validate(
      makeResultado(),
      makeRequest(TipoGeracao.SIMULADO),
    );

    expect(result.aprovado).toBe(true);
    // Apenas o AlwaysPass deve ter executado
    expect(result.gateResults).toHaveLength(1);
    expect(result.gateResults[0].gate).toBe('AlwaysPass');
  });

  it('validate deve executar gate que era não-aplicável quando o tipo muda', async () => {
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new GateNotApplicableForSimulado());

    // Request com tipo PLANO_AULA → NotForSimulado.isApplicable = true
    const result = await pipeline.validate(
      makeResultado(),
      makeRequest(TipoGeracao.PLANO_AULA),
    );

    expect(result.aprovado).toBe(true);
    expect(result.gateResults).toHaveLength(1);
    expect(result.gateResults[0].gate).toBe('NotForSimulado');
  });

  // --- validate: score multiplicativo ---

  it('score deve ser o produto dos scores individuais', async () => {
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new GateScorePartial()); // score 0.9
    pipeline.addGate(new GateScorePartial()); // score 0.9

    const result = await pipeline.validate(makeResultado(), makeRequest());

    // 0.9 * 0.9 = 0.81
    expect(result.score).toBeCloseTo(0.81, 4);
  });

  it('score com três gates: 0.9 * 0.9 * 0.9 ≈ 0.729', async () => {
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new GateScorePartial());
    pipeline.addGate(new GateScorePartial());
    pipeline.addGate(new GateScorePartial());

    const result = await pipeline.validate(makeResultado(), makeRequest());

    expect(result.score).toBeCloseTo(0.729, 4);
  });

  it('score com gate BLOCKER que falha deve ser 0', async () => {
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new GateScorePartial()); // score 0.9
    pipeline.addGate(new GateBlockerFail());  // score 0.0

    const result = await pipeline.validate(makeResultado(), makeRequest());

    // 0.9 * 0.0 = 0.0
    expect(result.score).toBe(0.0);
  });

  // --- validate: failures e blockers ---

  it('failures deve listar apenas gates com passed=false', async () => {
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new GateAlwaysPass());   // passed=true
    pipeline.addGate(new GateScorePartial()); // passed=true (WARNING)
    // (Não podemos testar failure sem BLOCKER, pois o fail-fast pararia)
    // Usamos um gate BLOCKER que passa para garantir que o pipeline continua

    const result = await pipeline.validate(makeResultado(), makeRequest());

    expect(result.failures).toHaveLength(0);
  });

  it('blockers deve conter todos os gates BLOCKER executados (mesmo os que passaram)', async () => {
    // Criamos um gate BLOCKER que passa
    class GateBlockerPass extends BaseQualityGate {
      public get name(): string { return 'BlockerPass'; }
      public isApplicable(_t: TipoGeracao): boolean { return true; }
      public async check(_r: GeracaoResultado, _q: GeracaoRequest): Promise<GateResult> {
        return {
          gate: this.name,
          passed: true,
          severity: 'BLOCKER',
          score: 1.0,
          message: 'Blocker passed.',
        };
      }
    }

    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new GateAlwaysPass());
    pipeline.addGate(new GateBlockerPass());

    const result = await pipeline.validate(makeResultado(), makeRequest());

    expect(result.aprovado).toBe(true);
    // blockers contém TODOS os gates com severity BLOCKER
    expect(result.blockers).toHaveLength(1);
    expect(result.blockers[0].gate).toBe('BlockerPass');
  });

  // --- validate: pipeline vazio ---

  it('validate em pipeline vazio deve retornar aprovado=true com score=1.0', async () => {
    const pipeline = new QualityGatePipeline();

    const result = await pipeline.validate(makeResultado(), makeRequest());

    expect(result.aprovado).toBe(true);
    expect(result.score).toBe(1.0);
    expect(result.gateResults).toHaveLength(0);
    expect(result.failures).toHaveLength(0);
    expect(result.blockers).toHaveLength(0);
  });
});
