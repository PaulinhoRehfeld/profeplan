// ============================================================================
// PROFEPLAN — Testes: orchestrator-agent
// S1-07: Testes unitários para OrchestratorAgent
// ============================================================================

import { describe, it, expect } from 'vitest';
import {
  BaseDisciplineAgent,
  TipoGeracao,
  DisciplinaNome,
  NivelEnsino,
} from '../../src/base/discipline-agent-base';
import type { DisciplinaContext, GeracaoResultado } from '../../src/base/discipline-agent-base';
import { AgentRegistry } from '../../src/base/agent-registry';
import type { AgentEntry } from '../../src/base/agent-registry';
import { OrchestratorAgent } from '../../src/coordenacao/orchestrator-agent';
import type { GeracaoRequest } from '../../src/coordenacao/orchestrator-agent';

// ---------------------------------------------------------------------------
// Dummy Agent com pipeline funcional (sucesso)
// ---------------------------------------------------------------------------

/** Agente dummy que sempre retorna sucesso. */
class DummySuccessAgent extends BaseDisciplineAgent {
  public get displayName(): string {
    return 'DummySuccess';
  }

  protected buildSystemPrompt(): string {
    return 'You are a successful dummy agent.';
  }

  public getDisciplina(): DisciplinaNome {
    return DisciplinaNome.MATEMATICA;
  }

  public getHabilidadesPrioritarias(): string[] {
    return ['EF06MA01'];
  }

  // Sobrescreve _postProcess para retornar sucesso (evita erro "Not implemented")
  protected async _postProcess(
    _raw: string,
    _tipo: TipoGeracao,
  ): Promise<GeracaoResultado> {
    return {
      sucesso: true,
      conteudo: { tema: 'Funções', resumo: 'Conteúdo gerado com sucesso.' },
      metadados: {
        agente: this.displayName,
        disciplina: this.getDisciplina(),
        nivel: this.context.nivel,
        tipo: _tipo,
        timestamp: new Date().toISOString(),
      },
    };
  }

  protected async _callLLM(
    _prompt: string,
    _ragContext: string,
    _params: Record<string, unknown>,
  ): Promise<string> {
    return '{"tema":"Funções"}';
  }

  protected _selectPromptTemplate(_tipo: TipoGeracao): string {
    return 'Template dummy';
  }

  protected async _buildRagContext(_tipo: TipoGeracao): Promise<string> {
    return '{}';
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/** Cria uma GeracaoRequest mínima. */
function makeRequest(overrides?: Partial<GeracaoRequest>): GeracaoRequest {
  return {
    disciplina: DisciplinaNome.MATEMATICA,
    nivel: NivelEnsino.EF_6,
    tipo: TipoGeracao.PLANO_AULA,
    professorId: 'prof-001',
    turmaId: 'turma-001',
    params: { tema: 'Funções' },
    ...overrides,
  };
}

/** Cria uma AgentEntry com o DummySuccessAgent. */
function makeEntry(overrides?: Partial<AgentEntry>): AgentEntry {
  return {
    codigo: 'Agent_Matematica_EF',
    disciplina: DisciplinaNome.MATEMATICA,
    nivel: NivelEnsino.EF_6,
    displayName: 'Pitágoras',
    construtor: DummySuccessAgent,
    ...overrides,
  };
}

// ===========================================================================
// Testes: OrchestratorAgent
// ===========================================================================

describe('OrchestratorAgent', () => {
  // --- Construção ---

  it('deve criar OrchestratorAgent com registry vazio', () => {
    const registry = new AgentRegistry();
    const orchestrator = new OrchestratorAgent(registry);

    expect(orchestrator.registry).toBe(registry);
    expect(orchestrator.maxRetries).toBe(3); // default
  });

  it('deve aceitar maxRetries customizado', () => {
    const registry = new AgentRegistry();
    const orchestrator = new OrchestratorAgent(registry, { maxRetries: 5 });

    expect(orchestrator.maxRetries).toBe(5);
  });

  // --- processarRequisicao: agente não encontrado ---

  it('processarRequisicao deve retornar erro quando agente não encontrado', async () => {
    const registry = new AgentRegistry();
    const orchestrator = new OrchestratorAgent(registry);

    const response = await orchestrator.processarRequisicao(makeRequest());

    expect(response.sucesso).toBe(false);
    expect(response.erro).toBeDefined();
    expect(response.erro).toContain('Nenhum agente registrado');
    expect(response.conteudo).toBeUndefined();
    expect(response.metadados).toBeDefined();
    expect(response.metadados!.agente).toBe('N/A');
    expect(response.metadados!.tentativas).toBe(0);
  });

  // --- _parseDisciplina ---

  it('_parseDisciplina deve extrair disciplina e nível da request', () => {
    const registry = new AgentRegistry();
    const orchestrator = new OrchestratorAgent(registry);
    const req = makeRequest({
      disciplina: DisciplinaNome.FISICA,
      nivel: NivelEnsino.EM_2,
    });

    const result = orchestrator._parseDisciplina(req);

    expect(result.disciplina).toBe(DisciplinaNome.FISICA);
    expect(result.nivel).toBe(NivelEnsino.EM_2);
  });

  it('_parseDisciplina deve retornar os campos exatos da request', () => {
    const registry = new AgentRegistry();
    const orchestrator = new OrchestratorAgent(registry);
    const req = makeRequest();

    const result = orchestrator._parseDisciplina(req);

    expect(result.disciplina).toBe(req.disciplina);
    expect(result.nivel).toBe(req.nivel);
  });

  // --- _buildContext ---

  it('_buildContext deve construir DisciplinaContext corretamente', () => {
    const registry = new AgentRegistry();
    const orchestrator = new OrchestratorAgent(registry);
    const req = makeRequest({
      disciplina: DisciplinaNome.QUIMICA,
      nivel: NivelEnsino.EM_1,
      professorId: 'prof-999',
      turmaId: 'turma-888',
    });

    const context = orchestrator._buildContext(req);

    expect(context.disciplina).toBe(DisciplinaNome.QUIMICA);
    expect(context.nivel).toBe(NivelEnsino.EM_1);
    expect(context.professorId).toBe('prof-999');
    expect(context.turmaId).toBe('turma-888');
  });

  it('_buildContext não deve incluir campos extras da request', () => {
    const registry = new AgentRegistry();
    const orchestrator = new OrchestratorAgent(registry);
    const req = makeRequest();

    const context = orchestrator._buildContext(req);

    // Deve ter apenas os 4 campos essenciais
    expect(Object.keys(context)).toHaveLength(4);
    expect(context).toEqual({
      disciplina: req.disciplina,
      nivel: req.nivel,
      professorId: req.professorId,
      turmaId: req.turmaId,
    });
  });

  // --- processarRequisicao: agente registrado (sucesso) ---

  it('processarRequisicao deve chamar o agente registrado e retornar sucesso', async () => {
    const registry = new AgentRegistry();
    registry.register(makeEntry());
    const orchestrator = new OrchestratorAgent(registry);

    const req = makeRequest();
    const response = await orchestrator.processarRequisicao(req);

    expect(response.sucesso).toBe(true);
    expect(response.conteudo).toBeDefined();
    expect(response.conteudo!.tema).toBe('Funções');
    expect(response.metadados).toBeDefined();
    expect(response.metadados!.agente).toBe('Pitágoras');
    expect(response.metadados!.tentativas).toBeGreaterThanOrEqual(1);
  });
});
