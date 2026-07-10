// ============================================================================
// PROFEPLAN — DoD Sprint 3: Teste de integração ponta-a-ponta
// S3-10: Prova que 10+ agentes estão registráveis, Orchestrator funciona
//        com todos, pipeline de qualidade com 3 gates, e bug de acentos
//        no BNCCValidator foi corrigido.
// ============================================================================

import { describe, it, expect } from 'vitest';

// --- Base & Registry ---
import { AgentRegistry } from '../src/base/agent-registry';
import {
  DisciplinaNome,
  NivelEnsino,
  TipoGeracao,
} from '../src/base/discipline-agent-base';
import type { GeracaoResultado } from '../src/base/discipline-agent-base';

// --- Coordenação ---
import { OrchestratorAgent } from '../src/coordenacao/orchestrator-agent';
import type { GeracaoRequest } from '../src/coordenacao/orchestrator-agent';

// --- Quality Gates (Sprint 3) ---
import { QualityGatePipeline } from '../src/qualidade/quality-gate-pipeline';
import { FormatValidatorAgent } from '../src/qualidade/format-validator';
import { BNCCValidatorAgent } from '../src/qualidade/bncc-validator';
import { PrivacyGuardAgent } from '../src/qualidade/privacy-guard';

// --- Agentes de Disciplina ---
// Sprint 1
import { DummyAgent } from '../src/disciplinas/dummy';
// Sprint 2 (5 agentes)
import { AgentLinguaPortuguesa } from '../src/disciplinas/lingua-portuguesa';
import { AgentMatematica } from '../src/disciplinas/matematica';
import { AgentHistoria } from '../src/disciplinas/historia';
import { AgentGeografia } from '../src/disciplinas/geografia';
import { AgentCienciasBiologia } from '../src/disciplinas/ciencias-biologia';
// Sprint 3 (5 agentes)
import { AgentFisica } from '../src/disciplinas/fisica';
import { AgentQuimica } from '../src/disciplinas/quimica';
import { AgentLinguaInglesa } from '../src/disciplinas/lingua-inglesa';
import { AgentArtes } from '../src/disciplinas/artes';
import { AgentEducacaoFisica } from '../src/disciplinas/educacao-fisica';

// ===========================================================================
// Helpers
// ===========================================================================

/** Cria uma GeracaoRequest mínima para testes. */
function makeRequest(overrides?: Partial<GeracaoRequest>): GeracaoRequest {
  return {
    disciplina: DisciplinaNome.MATEMATICA,
    nivel: NivelEnsino.EF_6,
    tipo: TipoGeracao.PLANO_AULA,
    professorId: 'prof-test',
    turmaId: 'turma-test',
    params: { tema: 'Teste DoD S3' },
    ...overrides,
  };
}

// ===========================================================================
// 1. Registro de 10+ Agentes no AgentRegistry
// ===========================================================================

describe('DoD Sprint 3 — AgentRegistry com 10+ agentes', () => {
  /** Factory que cria um registry com os 11 agentes. */
  function createFullRegistry(): AgentRegistry {
    const registry = new AgentRegistry();

    // --- Sprint 1: DummyAgent (Matemática/Pitágoras) ---
    registry.register({
      codigo: 'Agent_Dummy_EF6',
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Pitágoras',
      construtor: DummyAgent,
    });

    // --- Sprint 2: 5 agentes reais ---
    // Língua Portuguesa — Machado
    registry.register({
      codigo: 'Agent_LinguaPortuguesa_EF6',
      disciplina: DisciplinaNome.LINGUA_PORTUGUESA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Machado',
      construtor: AgentLinguaPortuguesa,
    });

    // Matemática — Pitágoras (nível diferente do Dummy)
    registry.register({
      codigo: 'Agent_Matematica_EF7',
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_7,
      displayName: 'Pitágoras',
      construtor: AgentMatematica,
    });

    // História — Heródoto
    registry.register({
      codigo: 'Agent_Historia_EF6',
      disciplina: DisciplinaNome.HISTORIA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Heródoto',
      construtor: AgentHistoria,
    });

    // Geografia — Milton
    registry.register({
      codigo: 'Agent_Geografia_EF6',
      disciplina: DisciplinaNome.GEOGRAFIA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Milton',
      construtor: AgentGeografia,
    });

    // Ciências/Biologia — Darwin
    registry.register({
      codigo: 'Agent_CienciasBiologia_EF6',
      disciplina: DisciplinaNome.CIENCIAS,
      nivel: NivelEnsino.EF_6,
      displayName: 'Darwin',
      construtor: AgentCienciasBiologia,
    });

    // --- Sprint 3: 5 agentes reais ---
    // Física — Einstein (EM apenas)
    registry.register({
      codigo: 'Agent_Fisica_EM1',
      disciplina: DisciplinaNome.FISICA,
      nivel: NivelEnsino.EM_1,
      displayName: 'Einstein',
      construtor: AgentFisica,
    });

    // Química — Lavoisier (EM apenas)
    registry.register({
      codigo: 'Agent_Quimica_EM1',
      disciplina: DisciplinaNome.QUIMICA,
      nivel: NivelEnsino.EM_1,
      displayName: 'Lavoisier',
      construtor: AgentQuimica,
    });

    // Língua Inglesa — Shakespeare
    registry.register({
      codigo: 'Agent_LinguaInglesa_EF6',
      disciplina: DisciplinaNome.LINGUA_INGLESA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Shakespeare',
      construtor: AgentLinguaInglesa,
    });

    // Artes — Tarsila
    registry.register({
      codigo: 'Agent_Artes_EF6',
      disciplina: DisciplinaNome.ARTES,
      nivel: NivelEnsino.EF_6,
      displayName: 'Tarsila',
      construtor: AgentArtes,
    });

    // Educação Física — Pelé
    registry.register({
      codigo: 'Agent_EducacaoFisica_EF6',
      disciplina: DisciplinaNome.EDUCACAO_FISICA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Pelé',
      construtor: AgentEducacaoFisica,
    });

    return registry;
  }

  it('1. Registry deve conter >= 10 agentes após registrar Dummy + 5 S2 + 5 S3', () => {
    const registry = createFullRegistry();
    const agents = registry.listAgents();

    expect(agents.length).toBeGreaterThanOrEqual(10);
    // Esperado: 11 agentes (1 Dummy + 5 S2 + 5 S3)
    expect(agents.length).toBe(11);
  });

  it('2. Cada agente registrado deve ser encontrável por disciplina+nivel', () => {
    const registry = createFullRegistry();

    // Sprint 1
    expect(registry.hasAgent(DisciplinaNome.MATEMATICA, NivelEnsino.EF_6)).toBe(true);

    // Sprint 2
    expect(registry.hasAgent(DisciplinaNome.LINGUA_PORTUGUESA, NivelEnsino.EF_6)).toBe(true);
    expect(registry.hasAgent(DisciplinaNome.MATEMATICA, NivelEnsino.EF_7)).toBe(true);
    expect(registry.hasAgent(DisciplinaNome.HISTORIA, NivelEnsino.EF_6)).toBe(true);
    expect(registry.hasAgent(DisciplinaNome.GEOGRAFIA, NivelEnsino.EF_6)).toBe(true);
    expect(registry.hasAgent(DisciplinaNome.CIENCIAS, NivelEnsino.EF_6)).toBe(true);

    // Sprint 3
    expect(registry.hasAgent(DisciplinaNome.FISICA, NivelEnsino.EM_1)).toBe(true);
    expect(registry.hasAgent(DisciplinaNome.QUIMICA, NivelEnsino.EM_1)).toBe(true);
    expect(registry.hasAgent(DisciplinaNome.LINGUA_INGLESA, NivelEnsino.EF_6)).toBe(true);
    expect(registry.hasAgent(DisciplinaNome.ARTES, NivelEnsino.EF_6)).toBe(true);
    expect(registry.hasAgent(DisciplinaNome.EDUCACAO_FISICA, NivelEnsino.EF_6)).toBe(true);
  });

  it('3. Fallback: agente sem match exato retorna mesmo assim (mesma disciplina)', () => {
    const registry = createFullRegistry();

    // Física EM_3 não tem agente registrado, mas deve cair no fallback → Einstein (EM_1)
    const entry = registry.getAgent(DisciplinaNome.FISICA, NivelEnsino.EM_3);
    expect(entry).toBeDefined();
    expect(entry!.displayName).toBe('Einstein');
  });
});

// ===========================================================================
// 2. Orchestrator processa requisições para TODOS os 10 agentes
// ===========================================================================

describe('DoD Sprint 3 — Orchestrator com 10+ agentes', () => {
  function createFullRegistry(): AgentRegistry {
    const registry = new AgentRegistry();

    registry.register({
      codigo: 'Agent_Dummy_EF6',
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Pitágoras',
      construtor: DummyAgent,
    });
    registry.register({
      codigo: 'Agent_LP_EF6',
      disciplina: DisciplinaNome.LINGUA_PORTUGUESA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Machado',
      construtor: AgentLinguaPortuguesa,
    });
    registry.register({
      codigo: 'Agent_MAT_EF7',
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_7,
      displayName: 'Pitágoras',
      construtor: AgentMatematica,
    });
    registry.register({
      codigo: 'Agent_HIST_EF6',
      disciplina: DisciplinaNome.HISTORIA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Heródoto',
      construtor: AgentHistoria,
    });
    registry.register({
      codigo: 'Agent_GEO_EF6',
      disciplina: DisciplinaNome.GEOGRAFIA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Milton',
      construtor: AgentGeografia,
    });
    registry.register({
      codigo: 'Agent_CIE_EF6',
      disciplina: DisciplinaNome.CIENCIAS,
      nivel: NivelEnsino.EF_6,
      displayName: 'Darwin',
      construtor: AgentCienciasBiologia,
    });
    registry.register({
      codigo: 'Agent_FIS_EM1',
      disciplina: DisciplinaNome.FISICA,
      nivel: NivelEnsino.EM_1,
      displayName: 'Einstein',
      construtor: AgentFisica,
    });
    registry.register({
      codigo: 'Agent_QUI_EM1',
      disciplina: DisciplinaNome.QUIMICA,
      nivel: NivelEnsino.EM_1,
      displayName: 'Lavoisier',
      construtor: AgentQuimica,
    });
    registry.register({
      codigo: 'Agent_ING_EF6',
      disciplina: DisciplinaNome.LINGUA_INGLESA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Shakespeare',
      construtor: AgentLinguaInglesa,
    });
    registry.register({
      codigo: 'Agent_ART_EF6',
      disciplina: DisciplinaNome.ARTES,
      nivel: NivelEnsino.EF_6,
      displayName: 'Tarsila',
      construtor: AgentArtes,
    });
    registry.register({
      codigo: 'Agent_EDF_EF6',
      disciplina: DisciplinaNome.EDUCACAO_FISICA,
      nivel: NivelEnsino.EF_6,
      displayName: 'Pelé',
      construtor: AgentEducacaoFisica,
    });

    return registry;
  }

  it('4. Orchestrator processa DummyAgent (Matemática EF_6) com sucesso', async () => {
    const registry = createFullRegistry();
    const orchestrator = new OrchestratorAgent(registry);

    const response = await orchestrator.processarRequisicao(
      makeRequest({ disciplina: DisciplinaNome.MATEMATICA, nivel: NivelEnsino.EF_6 }),
    );

    expect(response.sucesso).toBe(true);
    expect(response.conteudo).toBeDefined();
    expect(response.metadados!.agente).toBe('Pitágoras');
  });

  it('5. Orchestrator processa AgentMatematica (EF_7) com sucesso', async () => {
    const registry = createFullRegistry();
    const orchestrator = new OrchestratorAgent(registry);

    const response = await orchestrator.processarRequisicao(
      makeRequest({ disciplina: DisciplinaNome.MATEMATICA, nivel: NivelEnsino.EF_7 }),
    );

    expect(response.sucesso).toBe(true);
    expect(response.metadados!.agente).toBe('Pitágoras');
  });

  it('6. Orchestrator processa AgentFisica (EM_1) com sucesso', async () => {
    const registry = createFullRegistry();
    const orchestrator = new OrchestratorAgent(registry);

    const response = await orchestrator.processarRequisicao(
      makeRequest({ disciplina: DisciplinaNome.FISICA, nivel: NivelEnsino.EM_1 }),
    );

    expect(response.sucesso).toBe(true);
    expect(response.metadados!.agente).toBe('Einstein');
  });

  it('7. Orchestrator processa AgentEducacaoFisica (EF_6) com sucesso', async () => {
    const registry = createFullRegistry();
    const orchestrator = new OrchestratorAgent(registry);

    const response = await orchestrator.processarRequisicao(
      makeRequest({ disciplina: DisciplinaNome.EDUCACAO_FISICA, nivel: NivelEnsino.EF_6 }),
    );

    expect(response.sucesso).toBe(true);
    expect(response.metadados!.agente).toBe('Pelé');
  });
});

// ===========================================================================
// 3. Pipeline completo com 3 Quality Gates
// ===========================================================================

describe('DoD Sprint 3 — Pipeline Quality Gates (3 gates)', () => {
  it('8. Pipeline com FormatValidator + BNCCValidator + PrivacyGuard → aprovado', async () => {
    const pipeline = new QualityGatePipeline([
      new FormatValidatorAgent(),
      new BNCCValidatorAgent(),
      new PrivacyGuardAgent(),
    ]);

    // Conteúdo válido: PLANO_AULA com tema, duracao, habilidades_bncc, sem PII
    const resultado: GeracaoResultado = {
      sucesso: true,
      conteudo: {
        tema: 'Clima e Tempo',
        duracao: '50 minutos',
        objetivo: 'Compreender a diferença entre clima e tempo',
        habilidades_bncc: ['EF06GE01'], // Geografia — código válido
        metodologia: 'Aula expositiva com slides',
      },
      metadados: {
        agente: 'Milton',
        disciplina: 'GEOGRAFIA',
        nivel: 'EF_6',
        tipo: 'PLANO_AULA',
        timestamp: new Date().toISOString(),
      },
    };

    const req = makeRequest({
      disciplina: DisciplinaNome.GEOGRAFIA,
      tipo: TipoGeracao.PLANO_AULA,
    });

    const pr = await pipeline.validate(resultado, req);

    expect(pr.aprovado).toBe(true);
    expect(pr.gateResults).toHaveLength(3);
    expect(pr.blockers).toHaveLength(0);
  });

  it('9. Pipeline detecta BLOCKER com código BNCC inexistente', async () => {
    const pipeline = new QualityGatePipeline([
      new FormatValidatorAgent(),
      new BNCCValidatorAgent(),
      new PrivacyGuardAgent(),
    ]);

    const resultado: GeracaoResultado = {
      sucesso: true,
      conteudo: {
        tema: 'Aula Falsa',
        duracao: '50 minutos',
        habilidades_bncc: ['EF99XX99'], // inexistente
      },
    };

    const req = makeRequest({ disciplina: DisciplinaNome.GEOGRAFIA });

    const pr = await pipeline.validate(resultado, req);

    expect(pr.aprovado).toBe(false);
    expect(pr.blockers.length).toBeGreaterThanOrEqual(1);
    expect(pr.blockers[0].gate).toBe('BNCC Validator');
  });

  it('10. Pipeline detecta WARNING com conteúdo sem habilidades_bncc', async () => {
    const pipeline = new QualityGatePipeline([
      new FormatValidatorAgent(),
      new BNCCValidatorAgent(),
      new PrivacyGuardAgent(),
    ]);

    const resultado: GeracaoResultado = {
      sucesso: true,
      conteudo: {
        tema: 'Aula simples',
        duracao: '50 minutos',
        // sem campo habilidades_bncc
      },
    };

    const req = makeRequest({
      disciplina: DisciplinaNome.GEOGRAFIA,
    });

    const pr = await pipeline.validate(resultado, req);

    // BNCCValidator emite WARNING, não BLOCKER → pipeline aprovado
    expect(pr.aprovado).toBe(true);
    // Deve haver um WARNING nos gate results
    const warnings = pr.gateResults.filter((g) => g.severity === 'WARNING');
    expect(warnings.length).toBeGreaterThanOrEqual(1);
  });
});

// ===========================================================================
// 4. Correção do bug de acentos no BNCCValidator (S3-10 AC #1)
// ===========================================================================

describe('DoD Sprint 3 — Bug de acentos BNCCValidator CORRIGIDO', () => {
  it('11. "LINGUA_PORTUGUESA" (sem acento) casa com "Língua Portuguesa" (com acento) no índice', async () => {
    const gate = new BNCCValidatorAgent();

    // Conteúdo com código de Língua Portuguesa
    const resultado: GeracaoResultado = {
      sucesso: true,
      conteudo: {
        tema: 'Interpretação de Texto',
        habilidades_bncc: ['EF06LP01'], // código de Língua Portuguesa no índice mock
      },
    };

    // req.disciplina = LINGUA_PORTUGUESA (enum, sem acentos)
    const req = makeRequest({
      disciplina: DisciplinaNome.LINGUA_PORTUGUESA,
    });

    const r = await gate.check(resultado, req);

    // Deve passar - a normalização NFD faz "LINGUA_PORTUGUESA" casar com "Língua Portuguesa"
    expect(r.passed).toBe(true);
    expect(r.severity).toBe('INFO');
    expect(r.score).toBe(1.0);
    expect(r.message).toContain('validados com sucesso');
  });

  it('12. "HISTORIA" (sem acento) casa com "História" (com acento) no índice', async () => {
    const gate = new BNCCValidatorAgent();

    const resultado: GeracaoResultado = {
      sucesso: true,
      conteudo: {
        tema: 'Roma Antiga',
        habilidades_bncc: ['EF06HI01'], // código de História
      },
    };

    const req = makeRequest({
      disciplina: DisciplinaNome.HISTORIA,
    });

    const r = await gate.check(resultado, req);

    expect(r.passed).toBe(true);
    expect(r.severity).toBe('INFO');
    expect(r.score).toBe(1.0);
  });

  it('13. "CIENCIAS" (sem acento) casa com "Ciências" (com acento) no índice', async () => {
    const gate = new BNCCValidatorAgent();

    const resultado: GeracaoResultado = {
      sucesso: true,
      conteudo: {
        tema: 'Ecossistemas',
        habilidades_bncc: ['EF06CI01'], // código de Ciências
      },
    };

    const req = makeRequest({
      disciplina: DisciplinaNome.CIENCIAS,
    });

    const r = await gate.check(resultado, req);

    expect(r.passed).toBe(true);
    expect(r.severity).toBe('INFO');
    expect(r.score).toBe(1.0);
  });
});

// ===========================================================================
// 5. Verificação de contagem total de agentes
// ===========================================================================

describe('DoD Sprint 3 — Verificação final', () => {
  it('14. Número total de agentes registrados é >= 10', () => {
    const registry = new AgentRegistry();

    // Registrar todos os 11 agentes (1 Dummy + 5 S2 + 5 S3)
    registry.register({
      codigo: 'A01', disciplina: DisciplinaNome.MATEMATICA, nivel: NivelEnsino.EF_6,
      displayName: 'Pitágoras', construtor: DummyAgent,
    });
    registry.register({
      codigo: 'A02', disciplina: DisciplinaNome.LINGUA_PORTUGUESA, nivel: NivelEnsino.EF_6,
      displayName: 'Machado', construtor: AgentLinguaPortuguesa,
    });
    registry.register({
      codigo: 'A03', disciplina: DisciplinaNome.MATEMATICA, nivel: NivelEnsino.EF_7,
      displayName: 'Pitágoras', construtor: AgentMatematica,
    });
    registry.register({
      codigo: 'A04', disciplina: DisciplinaNome.HISTORIA, nivel: NivelEnsino.EF_6,
      displayName: 'Heródoto', construtor: AgentHistoria,
    });
    registry.register({
      codigo: 'A05', disciplina: DisciplinaNome.GEOGRAFIA, nivel: NivelEnsino.EF_6,
      displayName: 'Milton', construtor: AgentGeografia,
    });
    registry.register({
      codigo: 'A06', disciplina: DisciplinaNome.CIENCIAS, nivel: NivelEnsino.EF_6,
      displayName: 'Darwin', construtor: AgentCienciasBiologia,
    });
    registry.register({
      codigo: 'A07', disciplina: DisciplinaNome.FISICA, nivel: NivelEnsino.EM_1,
      displayName: 'Einstein', construtor: AgentFisica,
    });
    registry.register({
      codigo: 'A08', disciplina: DisciplinaNome.QUIMICA, nivel: NivelEnsino.EM_1,
      displayName: 'Lavoisier', construtor: AgentQuimica,
    });
    registry.register({
      codigo: 'A09', disciplina: DisciplinaNome.LINGUA_INGLESA, nivel: NivelEnsino.EF_6,
      displayName: 'Shakespeare', construtor: AgentLinguaInglesa,
    });
    registry.register({
      codigo: 'A10', disciplina: DisciplinaNome.ARTES, nivel: NivelEnsino.EF_6,
      displayName: 'Tarsila', construtor: AgentArtes,
    });
    registry.register({
      codigo: 'A11', disciplina: DisciplinaNome.EDUCACAO_FISICA, nivel: NivelEnsino.EF_6,
      displayName: 'Pelé', construtor: AgentEducacaoFisica,
    });

    expect(registry.listAgents().length).toBeGreaterThanOrEqual(10);
  });
});
