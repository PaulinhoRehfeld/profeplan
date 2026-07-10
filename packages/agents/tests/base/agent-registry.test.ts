// ============================================================================
// PROFEPLAN — Testes: agent-registry
// S1-07: Testes unitários para AgentRegistry
// ============================================================================

import { describe, it, expect } from 'vitest';
import {
  BaseDisciplineAgent,
  DisciplinaNome,
  NivelEnsino,
} from '../../src/base/discipline-agent-base';
import type { DisciplinaContext } from '../../src/base/discipline-agent-base';
import { AgentRegistry } from '../../src/base/agent-registry';
import type { AgentEntry, AgentConstructor } from '../../src/base/agent-registry';

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

  protected getPromptsMap(): Record<string, string> {
    return {};
  }
}

/** Outra classe dummy para testes de registro múltiplo. */
class DummyAgentPortugues extends BaseDisciplineAgent {
  public get displayName(): string {
    return 'DummyPT';
  }

  protected buildSystemPrompt(): string {
    return 'You are a dummy portuguese agent.';
  }

  public getDisciplina(): DisciplinaNome {
    return DisciplinaNome.LINGUA_PORTUGUESA;
  }

  public getHabilidadesPrioritarias(): string[] {
    return ['EF06LP01'];
  }

  protected getPromptsMap(): Record<string, string> {
    return {};
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/** Cria um DisciplinaContext mínimo. */
function makeContext(
  disciplina: DisciplinaNome = DisciplinaNome.MATEMATICA,
  nivel: NivelEnsino = NivelEnsino.EF_6,
): DisciplinaContext {
  return {
    disciplina,
    nivel,
    professorId: 'prof-001',
    turmaId: 'turma-001',
  };
}

/** Cria uma AgentEntry com o agente dummy para MATEMATICA/EF_6. */
function makeEntry(
  overrides?: Partial<AgentEntry>,
): AgentEntry {
  return {
    codigo: 'Agent_Matematica_EF',
    disciplina: DisciplinaNome.MATEMATICA,
    nivel: NivelEnsino.EF_6,
    displayName: 'Pitágoras',
    construtor: DummyAgent,
    ...overrides,
  };
}

// ===========================================================================
// Testes: AgentRegistry
// ===========================================================================

describe('AgentRegistry', () => {
  // --- Registro ---

  it('deve iniciar vazio (size === 0)', () => {
    const registry = new AgentRegistry();
    expect(registry.size).toBe(0);
  });

  it('deve registrar um agente e incrementar size', () => {
    const registry = new AgentRegistry();
    registry.register(makeEntry());
    expect(registry.size).toBe(1);
  });

  it('hasAgent deve retornar true após registro', () => {
    const registry = new AgentRegistry();
    registry.register(makeEntry());
    expect(registry.hasAgent(DisciplinaNome.MATEMATICA, NivelEnsino.EF_6)).toBe(true);
  });

  it('hasAgent deve retornar false para agente não registrado', () => {
    const registry = new AgentRegistry();
    expect(registry.hasAgent(DisciplinaNome.FISICA, NivelEnsino.EM_1)).toBe(false);
  });

  // --- getAgent ---

  it('getAgent deve retornar o agente correto para match exato', () => {
    const registry = new AgentRegistry();
    const entry = makeEntry();
    registry.register(entry);

    const found = registry.getAgent(DisciplinaNome.MATEMATICA, NivelEnsino.EF_6);
    expect(found).toBeDefined();
    expect(found!.codigo).toBe('Agent_Matematica_EF');
    expect(found!.displayName).toBe('Pitágoras');
  });

  it('getAgent deve retornar undefined para disciplina não registrada', () => {
    const registry = new AgentRegistry();
    expect(registry.getAgent(DisciplinaNome.QUIMICA, NivelEnsino.EM_1)).toBeUndefined();
  });

  it('getAgent com fallback: mesma disciplina, nível diferente', () => {
    const registry = new AgentRegistry();
    // Registra MATEMATICA apenas para EF_6
    registry.register(makeEntry({ disciplina: DisciplinaNome.MATEMATICA, nivel: NivelEnsino.EF_6 }));

    // Busca para EM_1 — deve cair no fallback e retornar o agente EF_6
    const found = registry.getAgent(DisciplinaNome.MATEMATICA, NivelEnsino.EM_1);
    expect(found).toBeDefined();
    expect(found!.disciplina).toBe(DisciplinaNome.MATEMATICA);
    expect(found!.nivel).toBe(NivelEnsino.EF_6); // fallback: nível diferente
  });

  // --- listAgents ---

  it('listAgents deve retornar array vazio quando registry está vazio', () => {
    const registry = new AgentRegistry();
    expect(registry.listAgents()).toEqual([]);
  });

  it('listAgents deve retornar todos os agentes registrados', () => {
    const registry = new AgentRegistry();
    registry.register(makeEntry({ codigo: 'A1' }));
    registry.register(makeEntry({ codigo: 'A2', disciplina: DisciplinaNome.MATEMATICA, nivel: NivelEnsino.EF_7 }));

    const all = registry.listAgents();
    expect(all).toHaveLength(2);
    const codigos = all.map((a) => a.codigo);
    expect(codigos).toContain('A1');
    expect(codigos).toContain('A2');
  });

  // --- listByDisciplina ---

  it('listByDisciplina deve filtrar corretamente por disciplina', () => {
    const registry = new AgentRegistry();

    // Registra 2 agentes de MATEMATICA e 1 de PORTUGUES
    registry.register(makeEntry({ codigo: 'MAT_6', disciplina: DisciplinaNome.MATEMATICA, nivel: NivelEnsino.EF_6 }));
    registry.register(makeEntry({ codigo: 'MAT_7', disciplina: DisciplinaNome.MATEMATICA, nivel: NivelEnsino.EF_7 }));
    registry.register(makeEntry({
      codigo: 'PT_6',
      disciplina: DisciplinaNome.LINGUA_PORTUGUESA,
      nivel: NivelEnsino.EF_6,
    }));

    const matAgents = registry.listByDisciplina(DisciplinaNome.MATEMATICA);
    expect(matAgents).toHaveLength(2);
    expect(matAgents.every((a) => a.disciplina === DisciplinaNome.MATEMATICA)).toBe(true);

    const ptAgents = registry.listByDisciplina(DisciplinaNome.LINGUA_PORTUGUESA);
    expect(ptAgents).toHaveLength(1);
    expect(ptAgents[0].codigo).toBe('PT_6');
  });

  it('listByDisciplina deve retornar array vazio para disciplina sem agentes', () => {
    const registry = new AgentRegistry();
    registry.register(makeEntry());
    expect(registry.listByDisciplina(DisciplinaNome.QUIMICA)).toEqual([]);
  });

  // --- listByNivel ---

  it('listByNivel deve filtrar corretamente por nível', () => {
    const registry = new AgentRegistry();

    registry.register(makeEntry({ codigo: 'MAT_6', nivel: NivelEnsino.EF_6 }));
    registry.register(makeEntry({ codigo: 'PT_6', disciplina: DisciplinaNome.LINGUA_PORTUGUESA, nivel: NivelEnsino.EF_6 }));
    registry.register(makeEntry({ codigo: 'MAT_7', nivel: NivelEnsino.EF_7 }));

    const ef6 = registry.listByNivel(NivelEnsino.EF_6);
    expect(ef6).toHaveLength(2);
    expect(ef6.every((a) => a.nivel === NivelEnsino.EF_6)).toBe(true);

    const ef7 = registry.listByNivel(NivelEnsino.EF_7);
    expect(ef7).toHaveLength(1);
    expect(ef7[0].codigo).toBe('MAT_7');
  });

  it('listByNivel deve retornar array vazio para nível sem agentes', () => {
    const registry = new AgentRegistry();
    registry.register(makeEntry({ nivel: NivelEnsino.EF_6 }));
    expect(registry.listByNivel(NivelEnsino.EM_3)).toEqual([]);
  });

  // --- unregister ---

  it('unregister deve remover agente existente e retornar true', () => {
    const registry = new AgentRegistry();
    registry.register(makeEntry());

    expect(registry.size).toBe(1);
    const removed = registry.unregister(DisciplinaNome.MATEMATICA, NivelEnsino.EF_6);
    expect(removed).toBe(true);
    expect(registry.size).toBe(0);
    expect(registry.hasAgent(DisciplinaNome.MATEMATICA, NivelEnsino.EF_6)).toBe(false);
  });

  it('unregister de agente inexistente deve retornar false', () => {
    const registry = new AgentRegistry();
    const removed = registry.unregister(DisciplinaNome.FISICA, NivelEnsino.EM_1);
    expect(removed).toBe(false);
  });

  it('unregister duas vezes: segunda chamada retorna false', () => {
    const registry = new AgentRegistry();
    registry.register(makeEntry());

    expect(registry.unregister(DisciplinaNome.MATEMATICA, NivelEnsino.EF_6)).toBe(true);
    expect(registry.unregister(DisciplinaNome.MATEMATICA, NivelEnsino.EF_6)).toBe(false);
  });

  // --- register sobrescreve ---

  it('register deve sobrescrever agente existente (mesma chave)', () => {
    const registry = new AgentRegistry();

    const entry1 = makeEntry({ displayName: 'V1' });
    const entry2 = makeEntry({ displayName: 'V2' });

    registry.register(entry1);
    expect(registry.getAgent(DisciplinaNome.MATEMATICA, NivelEnsino.EF_6)!.displayName).toBe('V1');

    // Registra novamente com a mesma chave (mesma disciplina + nível)
    registry.register(entry2);
    expect(registry.size).toBe(1); // não deve aumentar
    expect(registry.getAgent(DisciplinaNome.MATEMATICA, NivelEnsino.EF_6)!.displayName).toBe('V2');
  });

  // --- size ---

  it('size deve refletir o número exato de entradas únicas', () => {
    const registry = new AgentRegistry();

    registry.register(makeEntry({ codigo: 'A', nivel: NivelEnsino.EF_6 }));
    registry.register(makeEntry({ codigo: 'B', nivel: NivelEnsino.EF_7 }));
    registry.register(makeEntry({ codigo: 'C', nivel: NivelEnsino.EF_8 }));

    expect(registry.size).toBe(3);

    registry.unregister(DisciplinaNome.MATEMATICA, NivelEnsino.EF_7);
    expect(registry.size).toBe(2);
  });

  // --- discover ---

  it('discover() deve retornar 0 (placeholder)', async () => {
    const registry = new AgentRegistry();
    const count = await registry.discover();
    expect(count).toBe(0);
  });

  it('discover() não deve alterar agentes existentes', async () => {
    const registry = new AgentRegistry();
    registry.register(makeEntry());

    const count = await registry.discover();
    expect(count).toBe(0);
    expect(registry.size).toBe(1); // agente previamente registrado permanece
  });
});
