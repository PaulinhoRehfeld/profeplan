// ============================================================================
// PROFEPLAN — DoD Sprint 1: Teste de integração ponta-a-ponta
// S1-08: Prova que o framework completo funciona (Registry → Orchestrator → Agent → QualityGate)
// ============================================================================

import { describe, it, expect } from 'vitest';
import { DummyAgent } from '../src/disciplinas/dummy';
import { AgentRegistry } from '../src/base/agent-registry';
import { OrchestratorAgent } from '../src/coordenacao/orchestrator-agent';
import {
  QualityGatePipeline,
  BaseQualityGate,
} from '../src/qualidade/quality-gate-pipeline';
import {
  DisciplinaNome,
  NivelEnsino,
  TipoGeracao,
  type GeracaoResultado,
  type GateResult,
} from '../src/base/discipline-agent-base';
import type { GeracaoRequest } from '../src/coordenacao/orchestrator-agent';

// ---------------------------------------------------------------------------
// Gate dummy auxiliar (sempre passa)
// ---------------------------------------------------------------------------

class PassGate extends BaseQualityGate {
  public get name(): string {
    return 'PassGate';
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
      message: 'OK',
    };
  }
}

// ===========================================================================
// Testes DoD Sprint 1
// ===========================================================================

describe('DoD Sprint 1 — Framework funcional ponta-a-ponta', () => {
  it('fluxo completo: Orchestrator → Registry → DummyAgent → QualityGate → resposta', async () => {
    // 1. Criar registry e registrar DummyAgent
    const registry = new AgentRegistry();
    registry.register({
      codigo: 'Agent_Dummy_EF',
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Pitágoras',
      construtor: DummyAgent,
    });

    // 2. Criar pipeline com um gate dummy que passa
    const pipeline = new QualityGatePipeline([new PassGate()]);

    // 3. Criar orchestrator
    const orchestrator = new OrchestratorAgent(registry, { maxRetries: 2 });

    // 4. Criar request
    const request: GeracaoRequest = {
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_6,
      tipo: TipoGeracao.PLANO_AULA,
      professorId: 'prof-001',
      turmaId: 'turma-001',
      params: { tema: 'Frações' },
    };

    // 5. Processar requisição
    const response = await orchestrator.processarRequisicao(request);

    // 6. Verificar sucesso
    expect(response.sucesso).toBe(true);
    expect(response.conteudo).toBeDefined();
    expect(response.conteudo!.tema).toBe('Frações');
    expect(response.metadados).toBeDefined();
    expect(response.metadados!.agente).toBe('Pitágoras');
    expect(response.metadados!.tentativas).toBe(1);

    // 7. Verificar que o pipeline também funciona
    const pipelineResult = await pipeline.validate(
      { sucesso: true, conteudo: response.conteudo! },
      request,
    );
    expect(pipelineResult.aprovado).toBe(true);
  });

  it('Orchestrator retorna erro quando agente não encontrado', async () => {
    const registry = new AgentRegistry();
    const orchestrator = new OrchestratorAgent(registry);

    const request: GeracaoRequest = {
      disciplina: DisciplinaNome.FILOSOFIA,
      nivel: NivelEnsino.EM_1,
      tipo: TipoGeracao.PLANO_AULA,
      professorId: 'prof-001',
      turmaId: 'turma-001',
      params: {},
    };

    const response = await orchestrator.processarRequisicao(request);
    expect(response.sucesso).toBe(false);
    expect(response.erro).toBeDefined();
  });
});
