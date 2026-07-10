// ============================================================================
// PROFEPLAN — Testes de Integração Sprint 2
// S2-08: Integração entre AgentRegistry, Orchestrator, 5 agentes reais,
//        ContextBuilder, SessionAgent e QualityGatePipeline
// ============================================================================

import { describe, it, expect } from 'vitest';

// --- Base & Registry ---
import { AgentRegistry } from '../../src/base/agent-registry';
import { DisciplinaNome, NivelEnsino, TipoGeracao } from '../../src/base/discipline-agent-base';
import type { GeracaoResultado } from '../../src/base/discipline-agent-base';

// --- Coordenação ---
import { OrchestratorAgent } from '../../src/coordenacao/orchestrator-agent';
import type { GeracaoRequest } from '../../src/coordenacao/orchestrator-agent';
import { ContextBuilderAgent } from '../../src/coordenacao/context-builder-agent';
import { SessionAgent } from '../../src/coordenacao/session-agent';

// --- Qualidade ---
import { QualityGatePipeline, BaseQualityGate } from '../../src/qualidade/quality-gate-pipeline';
import type { GateResult, GateSeverity } from '../../src/qualidade/quality-gate-pipeline';

// --- Agentes de Disciplina (Sprint 2) ---
import { AgentLinguaPortuguesa } from '../../src/disciplinas/lingua-portuguesa';
import { AgentMatematica } from '../../src/disciplinas/matematica';
import { AgentHistoria } from '../../src/disciplinas/historia';
import { AgentGeografia } from '../../src/disciplinas/geografia';
import { AgentCienciasBiologia } from '../../src/disciplinas/ciencias-biologia';

// ===========================================================================
// Helpers
// ===========================================================================

/** Cria uma GeracaoRequest mínima para testes. */
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

// ===========================================================================
// 1. Registro dos 5 Agentes no AgentRegistry
// ===========================================================================

describe('S2-08 Integração — AgentRegistry com 5 agentes reais', () => {
  it('deve registrar 5 agentes de disciplina e retornar size === 5', () => {
    const registry = new AgentRegistry();

    // Registrar Machado — Língua Portuguesa
    registry.register({
      codigo: 'Agent_LinguaPortuguesa_EF',
      disciplina: DisciplinaNome.LINGUA_PORTUGUESA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Machado',
      construtor: AgentLinguaPortuguesa,
    });

    // Registrar Pitágoras — Matemática
    registry.register({
      codigo: 'Agent_Matematica_EF',
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Pitágoras',
      construtor: AgentMatematica,
    });

    // Registrar Heródoto — História
    registry.register({
      codigo: 'Agent_Historia_EF',
      disciplina: DisciplinaNome.HISTORIA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Heródoto',
      construtor: AgentHistoria,
    });

    // Registrar Milton — Geografia
    registry.register({
      codigo: 'Agent_Geografia_EF',
      disciplina: DisciplinaNome.GEOGRAFIA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Milton',
      construtor: AgentGeografia,
    });

    // Registrar Darwin — Ciências/Biologia
    registry.register({
      codigo: 'Agent_CienciasBiologia_EF',
      disciplina: DisciplinaNome.CIENCIAS,
      nivel: NivelEnsino.EF_6,
      displayName: 'Darwin',
      construtor: AgentCienciasBiologia,
    });

    expect(registry.size).toBe(5);
  });

  it('deve permitir consultar cada agente individualmente após registro', () => {
    const registry = new AgentRegistry();

    registry.register({
      codigo: 'Agent_LinguaPortuguesa_EF',
      disciplina: DisciplinaNome.LINGUA_PORTUGUESA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Machado',
      construtor: AgentLinguaPortuguesa,
    });

    registry.register({
      codigo: 'Agent_Matematica_EF',
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Pitágoras',
      construtor: AgentMatematica,
    });

    registry.register({
      codigo: 'Agent_Historia_EF',
      disciplina: DisciplinaNome.HISTORIA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Heródoto',
      construtor: AgentHistoria,
    });

    registry.register({
      codigo: 'Agent_Geografia_EF',
      disciplina: DisciplinaNome.GEOGRAFIA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Milton',
      construtor: AgentGeografia,
    });

    registry.register({
      codigo: 'Agent_CienciasBiologia_EF',
      disciplina: DisciplinaNome.CIENCIAS,
      nivel: NivelEnsino.EF_6,
      displayName: 'Darwin',
      construtor: AgentCienciasBiologia,
    });

    // Verifica cada agente
    const machado = registry.getAgent(DisciplinaNome.LINGUA_PORTUGUESA, NivelEnsino.EF_6);
    expect(machado).toBeDefined();
    expect(machado!.displayName).toBe('Machado');

    const pitagoras = registry.getAgent(DisciplinaNome.MATEMATICA, NivelEnsino.EF_6);
    expect(pitagoras).toBeDefined();
    expect(pitagoras!.displayName).toBe('Pitágoras');

    const herodoto = registry.getAgent(DisciplinaNome.HISTORIA, NivelEnsino.EF_6);
    expect(herodoto).toBeDefined();
    expect(herodoto!.displayName).toBe('Heródoto');

    const milton = registry.getAgent(DisciplinaNome.GEOGRAFIA, NivelEnsino.EF_6);
    expect(milton).toBeDefined();
    expect(milton!.displayName).toBe('Milton');

    const darwin = registry.getAgent(DisciplinaNome.CIENCIAS, NivelEnsino.EF_6);
    expect(darwin).toBeDefined();
    expect(darwin!.displayName).toBe('Darwin');
  });
});

// ===========================================================================
// 2. Orchestrator processa requisição para cada agente (5 testes)
// ===========================================================================

describe('S2-08 Integração — Orchestrator com agentes reais', () => {
  // --- Machado (Língua Portuguesa) ---
  it('Machado — deve processar requisição de Língua Portuguesa EF_6 com sucesso', async () => {
    const registry = new AgentRegistry();
    registry.register({
      codigo: 'Agent_LinguaPortuguesa_EF',
      disciplina: DisciplinaNome.LINGUA_PORTUGUESA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Machado',
      construtor: AgentLinguaPortuguesa,
    });

    const orchestrator = new OrchestratorAgent(registry, { maxRetries: 1 });

    const response = await orchestrator.processarRequisicao(
      makeRequest({
        disciplina: DisciplinaNome.LINGUA_PORTUGUESA,
        nivel: NivelEnsino.EF_6,
        tipo: TipoGeracao.PLANO_AULA,
        params: { tema: 'Interpretação de texto' },
      }),
    );

    expect(response.sucesso).toBe(true);
    expect(response.conteudo).toBeDefined();
    expect(response.metadados).toBeDefined();
    expect(response.metadados!.agente).toBe('Machado');
    expect(response.metadados!.disciplina).toBe(DisciplinaNome.LINGUA_PORTUGUESA);
  });

  // --- Pitágoras (Matemática) ---
  it('Pitágoras — deve processar requisição de Matemática EF_6 com sucesso', async () => {
    const registry = new AgentRegistry();
    registry.register({
      codigo: 'Agent_Matematica_EF',
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Pitágoras',
      construtor: AgentMatematica,
    });

    const orchestrator = new OrchestratorAgent(registry, { maxRetries: 1 });

    const response = await orchestrator.processarRequisicao(
      makeRequest({
        disciplina: DisciplinaNome.MATEMATICA,
        nivel: NivelEnsino.EF_6,
        tipo: TipoGeracao.PLANO_AULA,
        params: { tema: 'Frações' },
      }),
    );

    expect(response.sucesso).toBe(true);
    expect(response.conteudo).toBeDefined();
    expect(response.metadados).toBeDefined();
    expect(response.metadados!.agente).toBe('Pitágoras');
    expect(response.metadados!.disciplina).toBe(DisciplinaNome.MATEMATICA);
  });

  // --- Heródoto (História) ---
  it('Heródoto — deve processar requisição de História EF_6 com sucesso', async () => {
    const registry = new AgentRegistry();
    registry.register({
      codigo: 'Agent_Historia_EF',
      disciplina: DisciplinaNome.HISTORIA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Heródoto',
      construtor: AgentHistoria,
    });

    const orchestrator = new OrchestratorAgent(registry, { maxRetries: 1 });

    const response = await orchestrator.processarRequisicao(
      makeRequest({
        disciplina: DisciplinaNome.HISTORIA,
        nivel: NivelEnsino.EF_6,
        tipo: TipoGeracao.PLANO_AULA,
        params: { tema: 'Egito Antigo' },
      }),
    );

    expect(response.sucesso).toBe(true);
    expect(response.conteudo).toBeDefined();
    expect(response.metadados).toBeDefined();
    expect(response.metadados!.agente).toBe('Heródoto');
    expect(response.metadados!.disciplina).toBe(DisciplinaNome.HISTORIA);
  });

  // --- Milton (Geografia) ---
  it('Milton — deve processar requisição de Geografia EF_6 com sucesso', async () => {
    const registry = new AgentRegistry();
    registry.register({
      codigo: 'Agent_Geografia_EF',
      disciplina: DisciplinaNome.GEOGRAFIA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Milton',
      construtor: AgentGeografia,
    });

    const orchestrator = new OrchestratorAgent(registry, { maxRetries: 1 });

    const response = await orchestrator.processarRequisicao(
      makeRequest({
        disciplina: DisciplinaNome.GEOGRAFIA,
        nivel: NivelEnsino.EF_6,
        tipo: TipoGeracao.PLANO_AULA,
        params: { tema: 'Cartografia' },
      }),
    );

    expect(response.sucesso).toBe(true);
    expect(response.conteudo).toBeDefined();
    expect(response.metadados).toBeDefined();
    expect(response.metadados!.agente).toBe('Milton');
    expect(response.metadados!.disciplina).toBe(DisciplinaNome.GEOGRAFIA);
  });

  // --- Darwin (Ciências/Biologia) ---
  it('Darwin — deve processar requisição de Ciências EF_6 com sucesso', async () => {
    const registry = new AgentRegistry();
    registry.register({
      codigo: 'Agent_CienciasBiologia_EF',
      disciplina: DisciplinaNome.CIENCIAS,
      nivel: NivelEnsino.EF_6,
      displayName: 'Darwin',
      construtor: AgentCienciasBiologia,
    });

    const orchestrator = new OrchestratorAgent(registry, { maxRetries: 1 });

    const response = await orchestrator.processarRequisicao(
      makeRequest({
        disciplina: DisciplinaNome.CIENCIAS,
        nivel: NivelEnsino.EF_6,
        tipo: TipoGeracao.PLANO_AULA,
        params: { tema: 'Cadeia alimentar' },
      }),
    );

    expect(response.sucesso).toBe(true);
    expect(response.conteudo).toBeDefined();
    expect(response.metadados).toBeDefined();
    expect(response.metadados!.agente).toBe('Darwin');
    expect(response.metadados!.disciplina).toBe(DisciplinaNome.CIENCIAS);
  });
});

// ===========================================================================
// 3. Orchestrator com agente não registrado retorna erro
// ===========================================================================

describe('S2-08 Integração — Orchestrator com agente não registrado', () => {
  it('deve retornar erro quando nenhum agente está registrado para a disciplina', async () => {
    const registry = new AgentRegistry();
    const orchestrator = new OrchestratorAgent(registry, { maxRetries: 1 });

    const response = await orchestrator.processarRequisicao(
      makeRequest({
        disciplina: DisciplinaNome.ARTES,
        nivel: NivelEnsino.EF_6,
        tipo: TipoGeracao.PLANO_AULA,
        params: { tema: 'Pintura rupestre' },
      }),
    );

    expect(response.sucesso).toBe(false);
    expect(response.erro).toBeDefined();
    expect(response.erro).toContain('Nenhum agente registrado');
    expect(response.erro).toContain(DisciplinaNome.ARTES);
    expect(response.conteudo).toBeUndefined();
  });

  it('deve retornar erro quando o agente registrado é de outra disciplina', async () => {
    const registry = new AgentRegistry();

    // Registrar apenas Matemática
    registry.register({
      codigo: 'Agent_Matematica_EF',
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Pitágoras',
      construtor: AgentMatematica,
    });

    const orchestrator = new OrchestratorAgent(registry, { maxRetries: 1 });

    // Solicitar História (não registrada)
    const response = await orchestrator.processarRequisicao(
      makeRequest({
        disciplina: DisciplinaNome.HISTORIA,
        nivel: NivelEnsino.EF_6,
        tipo: TipoGeracao.PLANO_AULA,
        params: { tema: 'Egito Antigo' },
      }),
    );

    expect(response.sucesso).toBe(false);
    expect(response.erro).toBeDefined();
    expect(response.erro).toContain('Nenhum agente registrado');
  });

  it('deve retornar erro quando o nível não corresponde ao agente registrado', async () => {
    const registry = new AgentRegistry();

    // Registrar Matemática apenas para EF_6
    registry.register({
      codigo: 'Agent_Matematica_EF',
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Pitágoras',
      construtor: AgentMatematica,
    });

    const orchestrator = new OrchestratorAgent(registry, { maxRetries: 1 });

    // Solicitar Matemática EM_1 — deve usar fallback (mesma disciplina, qualquer nível)
    const response = await orchestrator.processarRequisicao(
      makeRequest({
        disciplina: DisciplinaNome.MATEMATICA,
        nivel: NivelEnsino.EM_1,
        tipo: TipoGeracao.PLANO_AULA,
        params: { tema: 'Funções quadráticas' },
      }),
    );

    // O fallback do AgentRegistry.getAgent deve encontrar o agente de EF_6 para Matemática
    expect(response.sucesso).toBe(true);
    expect(response.metadados!.agente).toBe('Pitágoras');
  });
});

// ===========================================================================
// 4. ContextBuilderAgent.build() retorna RAGPackage com 4 chunks
// ===========================================================================

describe('S2-08 Integração — ContextBuilderAgent.build()', () => {
  it('deve retornar RAGPackage com exatamente 4 chunks (N1 a N4)', async () => {
    const builder = new ContextBuilderAgent();
    const req = makeRequest({
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_6,
    });

    const pkg = await builder.build(DisciplinaNome.MATEMATICA, NivelEnsino.EF_6, req);

    expect(pkg).toBeDefined();
    expect(pkg.chunks).toBeDefined();
    expect(pkg.chunks.length).toBe(4);

    // Verifica níveis e pesos
    const niveis = pkg.chunks.map((c) => c.nivel);
    expect(niveis).toEqual([1, 2, 3, 4]);

    const pesos = pkg.chunks.map((c) => c.peso);
    expect(pesos).toEqual([
      ContextBuilderAgent.PESO_N1, // 100
      ContextBuilderAgent.PESO_N2, // 50
      ContextBuilderAgent.PESO_N3, // 30
      ContextBuilderAgent.PESO_N4, // 10
    ]);

    // Verifica fontes
    const fontes = pkg.chunks.map((c) => c.fonte);
    expect(fontes).toEqual(['plano_curso', 'pnld', 'materiais_extras', 'bncc']);

    // Verifica que cada chunk tem texto não vazio
    for (const chunk of pkg.chunks) {
      expect(chunk.texto.length).toBeGreaterThan(0);
    }

    // Verifica campos do DisciplinaContext
    expect(pkg.disciplina).toBe(DisciplinaNome.MATEMATICA);
    expect(pkg.nivel).toBe(NivelEnsino.EF_6);
    expect(pkg.professorId).toBe('prof-001');
    expect(pkg.turmaId).toBe('turma-001');
  });

  it('deve retornar chunks com marcação [MOCK N*] para cada nível', async () => {
    const builder = new ContextBuilderAgent();
    const req = makeRequest({
      disciplina: DisciplinaNome.HISTORIA,
      nivel: NivelEnsino.EM_1,
    });

    const pkg = await builder.build(DisciplinaNome.HISTORIA, NivelEnsino.EM_1, req);

    expect(pkg.chunks.length).toBe(4);
    expect(pkg.chunks[0].texto).toContain('[MOCK N1]');
    expect(pkg.chunks[1].texto).toContain('[MOCK N2]');
    expect(pkg.chunks[2].texto).toContain('[MOCK N3]');
    expect(pkg.chunks[3].texto).toContain('[MOCK N4]');
  });
});

// ===========================================================================
// 5. SessionAgent registra e recupera histórico
// ===========================================================================

describe('S2-08 Integração — SessionAgent (registro e histórico)', () => {
  it('deve registrar uma geração e recuperá-la via getHistorico', async () => {
    const session = new SessionAgent();

    const resultado = {
      tema: 'Introdução à Álgebra',
      resumo: 'Aula inaugural de álgebra para o 6º ano.',
      duracao: '50min',
    };

    await session.registrarGeracao(resultado, {
      turmaId: 'turma-001',
      disciplina: DisciplinaNome.MATEMATICA,
      tipo: 'PLANO_AULA',
    });

    const historico = session.getHistorico('turma-001');
    expect(historico.length).toBe(1);
    expect(historico[0].turmaId).toBe('turma-001');
    expect(historico[0].disciplina).toBe(DisciplinaNome.MATEMATICA);
    expect(historico[0].tipo).toBe('PLANO_AULA');
    expect(historico[0].resumo).toBe('Aula inaugural de álgebra para o 6º ano.');
    expect(historico[0].id).toBeDefined();
    expect(historico[0].timestamp).toBeDefined();
  });

  it('deve filtrar histórico por turma e disciplina corretamente', async () => {
    const session = new SessionAgent();

    // Registrar 2 gerações para turmas/disciplinas diferentes
    await session.registrarGeracao(
      { tema: 'Geometria', resumo: 'Aula de geometria.' },
      { turmaId: 'turma-001', disciplina: DisciplinaNome.MATEMATICA, tipo: 'PLANO_AULA' },
    );

    await session.registrarGeracao(
      { tema: 'Cartografia', resumo: 'Aula de cartografia.' },
      { turmaId: 'turma-001', disciplina: DisciplinaNome.GEOGRAFIA, tipo: 'PLANO_AULA' },
    );

    await session.registrarGeracao(
      { tema: 'Funções', resumo: 'Aula de funções.' },
      { turmaId: 'turma-002', disciplina: DisciplinaNome.MATEMATICA, tipo: 'PLANO_AULA' },
    );

    // Filtrar apenas turma-001
    const histTurma1 = session.getHistorico('turma-001');
    expect(histTurma1.length).toBe(2);

    // Filtrar turma-001 + Matemática
    const histTurma1Mat = session.getHistorico('turma-001', DisciplinaNome.MATEMATICA);
    expect(histTurma1Mat.length).toBe(1);
    expect(histTurma1Mat[0].resumo).toBe('Aula de geometria.');

    // Filtrar turma-002 (deve ter 1)
    const histTurma2 = session.getHistorico('turma-002');
    expect(histTurma2.length).toBe(1);
    expect(histTurma2[0].resumo).toBe('Aula de funções.');
  });

  it('deve retornar contexto trimestral (mock) para uma turma', async () => {
    const session = new SessionAgent();

    const ctx = await session.getTrimestralContext('turma-001', DisciplinaNome.MATEMATICA);

    expect(ctx.turmaId).toBe('turma-001');
    expect(ctx.disciplina).toBe(DisciplinaNome.MATEMATICA);
    expect(ctx.aulasAnteriores.length).toBeGreaterThan(0);
    expect(ctx.aulasFuturas.length).toBeGreaterThan(0);
    expect(ctx.trimestreAtual).toBe(2);
  });

  it('deve verificar continuidade (mock) para um plano novo', async () => {
    const session = new SessionAgent();

    // Registrar uma geração prévia
    await session.registrarGeracao(
      { tema: 'Frações', resumo: 'Aula sobre frações.' },
      { turmaId: 'turma-001', disciplina: DisciplinaNome.MATEMATICA, tipo: 'PLANO_AULA' },
    );

    const resultado = await session.verificarContinuidade(
      { tema: 'Frações equivalentes' },
      'turma-001',
    );

    expect(resultado.continuo).toBe(true);
    expect(resultado.alertas.length).toBeGreaterThan(0);
    // Deve conter referência ao modo mock
    expect(resultado.alertas.some((a) => a.includes('mock'))).toBe(true);
  });
});

// ===========================================================================
// 6. QualityGatePipeline com gate dummy + agente real
// ===========================================================================

describe('S2-08 Integração — QualityGatePipeline + agente real', () => {
  // --- Gates dummy reutilizáveis ---

  /** Gate dummy que sempre passa com score 1.0. */
  class GateAlwaysPass extends BaseQualityGate {
    public get name(): string {
      return 'GateAlwaysPass';
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
        severity: 'INFO' as GateSeverity,
        score: 1.0,
        message: 'Sempre passa.',
      };
    }
  }

  /** Gate dummy WARNING com score 0.9. */
  class GateWarningPartial extends BaseQualityGate {
    public get name(): string {
      return 'GateWarningPartial';
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
        severity: 'WARNING' as GateSeverity,
        score: 0.9,
        message: 'Passou com warnings.',
        suggestion: 'Revisar formatação.',
      };
    }
  }

  it('deve validar conteúdo gerado por agente real através do pipeline com gate dummy', async () => {
    // 1. Configurar registry com agente real
    const registry = new AgentRegistry();
    registry.register({
      codigo: 'Agent_Matematica_EF',
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Pitágoras',
      construtor: AgentMatematica,
    });

    // 2. Criar pipeline com gate dummy que sempre passa
    const pipeline = new QualityGatePipeline([new GateAlwaysPass()]);

    // 3. Criar orchestrator e gerar conteúdo
    const orchestrator = new OrchestratorAgent(registry, { maxRetries: 1 });
    const req = makeRequest({
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_6,
      tipo: TipoGeracao.PLANO_AULA,
      params: { tema: 'Equações do 1º grau' },
    });

    const response = await orchestrator.processarRequisicao(req);
    expect(response.sucesso).toBe(true);

    // 4. Validar resultado via pipeline
    const fakeResultado: GeracaoResultado = {
      sucesso: true,
      conteudo: response.conteudo ?? {},
      metadados: {
        agente: response.metadados?.agente ?? 'Pitágoras',
        disciplina: response.metadados?.disciplina ?? DisciplinaNome.MATEMATICA,
        nivel: response.metadados?.nivel ?? NivelEnsino.EF_6,
        tipo: TipoGeracao.PLANO_AULA,
        timestamp: response.metadados?.timestamp ?? new Date().toISOString(),
      },
    };

    const pipelineResult = await pipeline.validate(fakeResultado, req);

    expect(pipelineResult.aprovado).toBe(true);
    expect(pipelineResult.score).toBe(1.0);
    expect(pipelineResult.gateResults.length).toBe(1);
    expect(pipelineResult.gateResults[0].passed).toBe(true);
    expect(pipelineResult.failures.length).toBe(0);
    expect(pipelineResult.blockers.length).toBe(0);
  });

  it('deve validar com múltiplos gates e calcular score agregado', async () => {
    const pipeline = new QualityGatePipeline([
      new GateAlwaysPass(),
      new GateWarningPartial(),
    ]);

    const fakeResultado: GeracaoResultado = {
      sucesso: true,
      conteudo: { tema: 'Teste' },
      metadados: {
        agente: 'Pitágoras',
        disciplina: DisciplinaNome.MATEMATICA,
        nivel: NivelEnsino.EF_6,
        tipo: TipoGeracao.PLANO_AULA,
        timestamp: new Date().toISOString(),
      },
    };

    const req = makeRequest();

    const pipelineResult = await pipeline.validate(fakeResultado, req);

    expect(pipelineResult.aprovado).toBe(true);
    // Score = 1.0 * 0.9 = 0.9
    expect(pipelineResult.score).toBeCloseTo(0.9, 5);
    expect(pipelineResult.gateResults.length).toBe(2);
    expect(pipelineResult.failures.length).toBe(0);
  });

  it('deve validar conteúdo de todos os 5 agentes reais via pipeline', async () => {
    const registry = new AgentRegistry();

    // Registrar todos os 5 agentes
    const agentes = [
      {
        codigo: 'Agent_LinguaPortuguesa_EF',
        disciplina: DisciplinaNome.LINGUA_PORTUGUESA,
        nivel: NivelEnsino.EF_6,
        displayName: 'Machado',
        construtor: AgentLinguaPortuguesa,
        tema: 'Interpretação de texto',
      },
      {
        codigo: 'Agent_Matematica_EF',
        disciplina: DisciplinaNome.MATEMATICA,
        nivel: NivelEnsino.EF_6,
        displayName: 'Pitágoras',
        construtor: AgentMatematica,
        tema: 'Frações',
      },
      {
        codigo: 'Agent_Historia_EF',
        disciplina: DisciplinaNome.HISTORIA,
        nivel: NivelEnsino.EF_6,
        displayName: 'Heródoto',
        construtor: AgentHistoria,
        tema: 'Egito Antigo',
      },
      {
        codigo: 'Agent_Geografia_EF',
        disciplina: DisciplinaNome.GEOGRAFIA,
        nivel: NivelEnsino.EF_6,
        displayName: 'Milton',
        construtor: AgentGeografia,
        tema: 'Cartografia',
      },
      {
        codigo: 'Agent_CienciasBiologia_EF',
        disciplina: DisciplinaNome.CIENCIAS,
        nivel: NivelEnsino.EF_6,
        displayName: 'Darwin',
        construtor: AgentCienciasBiologia,
        tema: 'Cadeia alimentar',
      },
    ];

    for (const ag of agentes) {
      registry.register({
        codigo: ag.codigo,
        disciplina: ag.disciplina,
        nivel: ag.nivel,
        displayName: ag.displayName,
        construtor: ag.construtor,
      });
    }

    const pipeline = new QualityGatePipeline([new GateAlwaysPass()]);
    const orchestrator = new OrchestratorAgent(registry, { maxRetries: 1 });

    // Validar cada agente
    for (const ag of agentes) {
      const req = makeRequest({
        disciplina: ag.disciplina,
        nivel: ag.nivel,
        tipo: TipoGeracao.PLANO_AULA,
        params: { tema: ag.tema },
      });

      const response = await orchestrator.processarRequisicao(req);
      expect(response.sucesso).toBe(true);

      const fakeResultado: GeracaoResultado = {
        sucesso: true,
        conteudo: response.conteudo ?? {},
        metadados: {
          agente: ag.displayName,
          disciplina: ag.disciplina,
          nivel: ag.nivel,
          tipo: TipoGeracao.PLANO_AULA,
          timestamp: new Date().toISOString(),
        },
      };

      const pipelineResult = await pipeline.validate(fakeResultado, req);
      expect(pipelineResult.aprovado).toBe(true);
      expect(pipelineResult.score).toBe(1.0);
    }
  });
});
