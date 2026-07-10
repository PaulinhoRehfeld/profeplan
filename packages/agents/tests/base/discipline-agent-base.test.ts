// ============================================================================
// PROFEPLAN — Testes: discipline-agent-base
// S1-07: Testes unitários para BaseDisciplineAgent, enums, interfaces e constantes
// ============================================================================

import { describe, it, expect } from 'vitest';
import {
  TipoGeracao,
  NivelEnsino,
  DisciplinaNome,
  AGENT_DISPLAY_NAMES,
  BaseDisciplineAgent,
} from '../../src/base/discipline-agent-base';
import type { DisciplinaContext, GeracaoResultado } from '../../src/base/discipline-agent-base';

// ---------------------------------------------------------------------------
// Dummy Agent (classe concreta mínima para testes)
// ---------------------------------------------------------------------------

/** Classe dummy que estende BaseDisciplineAgent para viabilizar os testes. */
class DummyAgent extends BaseDisciplineAgent {
  public get displayName(): string {
    return 'Dummy';
  }

  protected buildSystemPrompt(): string {
    return 'You are a dummy agent.';
  }

  public getDisciplina(): DisciplinaNome {
    return DisciplinaNome.MATEMATICA;
  }

  public getHabilidadesPrioritarias(): string[] {
    return ['EF06MA01'];
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/** Cria um DisciplinaContext mínimo e válido. */
function makeContext(overrides?: Partial<DisciplinaContext>): DisciplinaContext {
  return {
    disciplina: DisciplinaNome.MATEMATICA,
    nivel: NivelEnsino.EF_6,
    professorId: 'prof-001',
    turmaId: 'turma-001',
    ...overrides,
  };
}

// ===========================================================================
// Testes: Enum TipoGeracao
// ===========================================================================

describe('Enum TipoGeracao', () => {
  it('deve ter exatamente 5 valores', () => {
    const values = Object.values(TipoGeracao);
    expect(values).toHaveLength(5);
  });

  it('deve conter PLANEJAMENTO_TRIMESTRAL', () => {
    expect(TipoGeracao.PLANEJAMENTO_TRIMESTRAL).toBe('PLANEJAMENTO_TRIMESTRAL');
  });

  it('deve conter PLANO_AULA', () => {
    expect(TipoGeracao.PLANO_AULA).toBe('PLANO_AULA');
  });

  it('deve conter AVALIACAO', () => {
    expect(TipoGeracao.AVALIACAO).toBe('AVALIACAO');
  });

  it('deve conter PDI_ADAPTACAO', () => {
    expect(TipoGeracao.PDI_ADAPTACAO).toBe('PDI_ADAPTACAO');
  });

  it('deve conter SIMULADO', () => {
    expect(TipoGeracao.SIMULADO).toBe('SIMULADO');
  });
});

// ===========================================================================
// Testes: Enum NivelEnsino
// ===========================================================================

describe('Enum NivelEnsino', () => {
  it('deve ter exatamente 7 valores', () => {
    const values = Object.values(NivelEnsino);
    expect(values).toHaveLength(7);
  });

  it('deve conter os níveis do EF_6 ao EF_9', () => {
    expect(NivelEnsino.EF_6).toBe('EF_6');
    expect(NivelEnsino.EF_7).toBe('EF_7');
    expect(NivelEnsino.EF_8).toBe('EF_8');
    expect(NivelEnsino.EF_9).toBe('EF_9');
  });

  it('deve conter os níveis do EM_1 ao EM_3', () => {
    expect(NivelEnsino.EM_1).toBe('EM_1');
    expect(NivelEnsino.EM_2).toBe('EM_2');
    expect(NivelEnsino.EM_3).toBe('EM_3');
  });
});

// ===========================================================================
// Testes: Enum DisciplinaNome
// ===========================================================================

describe('Enum DisciplinaNome', () => {
  it('deve ter exatamente 14 valores', () => {
    const values = Object.values(DisciplinaNome);
    expect(values).toHaveLength(14);
  });

  it('deve conter as disciplinas principais', () => {
    expect(DisciplinaNome.LINGUA_PORTUGUESA).toBe('LINGUA_PORTUGUESA');
    expect(DisciplinaNome.MATEMATICA).toBe('MATEMATICA');
    expect(DisciplinaNome.CIENCIAS).toBe('CIENCIAS');
    expect(DisciplinaNome.BIOLOGIA).toBe('BIOLOGIA');
    expect(DisciplinaNome.GEOGRAFIA).toBe('GEOGRAFIA');
    expect(DisciplinaNome.HISTORIA).toBe('HISTORIA');
  });

  it('deve conter as disciplinas complementares', () => {
    expect(DisciplinaNome.ARTES).toBe('ARTES');
    expect(DisciplinaNome.EDUCACAO_FISICA).toBe('EDUCACAO_FISICA');
    expect(DisciplinaNome.ENSINO_RELIGIOSO).toBe('ENSINO_RELIGIOSO');
    expect(DisciplinaNome.LINGUA_INGLESA).toBe('LINGUA_INGLESA');
  });

  it('deve conter as disciplinas do EM', () => {
    expect(DisciplinaNome.FISICA).toBe('FISICA');
    expect(DisciplinaNome.QUIMICA).toBe('QUIMICA');
    expect(DisciplinaNome.FILOSOFIA).toBe('FILOSOFIA');
    expect(DisciplinaNome.SOCIOLOGIA).toBe('SOCIOLOGIA');
  });
});

// ===========================================================================
// Testes: AGENT_DISPLAY_NAMES
// ===========================================================================

describe('AGENT_DISPLAY_NAMES', () => {
  it('deve ter 14 entradas (uma por disciplina)', () => {
    const entries = Object.entries(AGENT_DISPLAY_NAMES);
    expect(entries).toHaveLength(14);
  });

  it('deve mapear LINGUA_PORTUGUESA → "Machado"', () => {
    expect(AGENT_DISPLAY_NAMES[DisciplinaNome.LINGUA_PORTUGUESA]).toBe('Machado');
  });

  it('deve mapear MATEMATICA → "Pitágoras"', () => {
    expect(AGENT_DISPLAY_NAMES[DisciplinaNome.MATEMATICA]).toBe('Pitágoras');
  });

  it('deve mapear FISICA → "Einstein"', () => {
    expect(AGENT_DISPLAY_NAMES[DisciplinaNome.FISICA]).toBe('Einstein');
  });

  it('deve mapear CIENCIAS → "Darwin"', () => {
    expect(AGENT_DISPLAY_NAMES[DisciplinaNome.CIENCIAS]).toBe('Darwin');
  });

  it('deve mapear BIOLOGIA → "Darwin" (mesmo nome icônico de CIENCIAS)', () => {
    expect(AGENT_DISPLAY_NAMES[DisciplinaNome.BIOLOGIA]).toBe('Darwin');
  });

  it('ambos CIENCIAS e BIOLOGIA devem compartilhar "Darwin"', () => {
    expect(AGENT_DISPLAY_NAMES[DisciplinaNome.CIENCIAS]).toBe('Darwin');
    expect(AGENT_DISPLAY_NAMES[DisciplinaNome.BIOLOGIA]).toBe('Darwin');
  });

  it('deve mapear QUIMICA → "Lavoisier"', () => {
    expect(AGENT_DISPLAY_NAMES[DisciplinaNome.QUIMICA]).toBe('Lavoisier');
  });

  it('deve mapear FILOSOFIA → "Sócrates"', () => {
    expect(AGENT_DISPLAY_NAMES[DisciplinaNome.FILOSOFIA]).toBe('Sócrates');
  });

  it('deve mapear SOCIOLOGIA → "Durkheim"', () => {
    expect(AGENT_DISPLAY_NAMES[DisciplinaNome.SOCIOLOGIA]).toBe('Durkheim');
  });
});

// ===========================================================================
// Testes: BaseDisciplineAgent (via DummyAgent)
// ===========================================================================

describe('BaseDisciplineAgent (via DummyAgent)', () => {
  // --- Construtor e inicialização ---

  it('deve inicializar o context corretamente', () => {
    const ctx = makeContext();
    const agent = new DummyAgent(ctx);

    expect(agent.context).toEqual(ctx);
    expect(agent.context.disciplina).toBe(DisciplinaNome.MATEMATICA);
    expect(agent.context.nivel).toBe(NivelEnsino.EF_6);
    expect(agent.context.professorId).toBe('prof-001');
    expect(agent.context.turmaId).toBe('turma-001');
  });

  it('deve inicializar o systemPrompt via buildSystemPrompt()', () => {
    const agent = new DummyAgent(makeContext());
    // systemPrompt é protected, mas podemos verificar indiretamente:
    // O construtor chama buildSystemPrompt() e armazena.
    // Como não temos getter, validamos que a instância é criada sem erro.
    expect(agent).toBeDefined();
    expect(agent.context).toBeDefined();
  });

  // --- displayName ---

  it('displayName deve retornar "Dummy"', () => {
    const agent = new DummyAgent(makeContext());
    expect(agent.displayName).toBe('Dummy');
  });

  // --- getDisciplina ---

  it('getDisciplina() deve retornar MATEMATICA', () => {
    const agent = new DummyAgent(makeContext());
    expect(agent.getDisciplina()).toBe(DisciplinaNome.MATEMATICA);
  });

  // --- getHabilidadesPrioritarias ---

  it('getHabilidadesPrioritarias() deve retornar ["EF06MA01"]', () => {
    const agent = new DummyAgent(makeContext());
    expect(agent.getHabilidadesPrioritarias()).toEqual(['EF06MA01']);
  });

  // --- gerar() lança erro (métodos protected não sobrescritos) ---

  it('gerar() deve lançar erro porque _buildRagContext não foi sobrescrito', async () => {
    const agent = new DummyAgent(makeContext());

    await expect(
      agent.gerar(TipoGeracao.PLANO_AULA, {}),
    ).rejects.toThrow('Not implemented: _buildRagContext');
  });
});
