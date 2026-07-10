// ============================================================================
// PROFEPLAN — Testes E2E Sprint 4: Orchestrator + Quality Gates com Retry
// S4-06: Fluxo completo de geração com pipeline de qualidade e política de retry
// ============================================================================

import { describe, it, expect, beforeEach } from 'vitest';

// --- Base types ---
import {
  BaseDisciplineAgent,
  TipoGeracao,
  DisciplinaNome,
  NivelEnsino,
} from '../../src/base/discipline-agent-base';
import type {
  GeracaoResultado,
  DisciplinaContext,
} from '../../src/base/discipline-agent-base';
import { AgentRegistry } from '../../src/base/agent-registry';
import type { AgentEntry } from '../../src/base/agent-registry';

// --- Coordenação ---
import { OrchestratorAgent } from '../../src/coordenacao/orchestrator-agent';
import type { GeracaoRequest } from '../../src/coordenacao/orchestrator-agent';

// --- Quality Gates ---
import { QualityGatePipeline } from '../../src/qualidade/quality-gate-pipeline';
import type { PipelineResult } from '../../src/qualidade/quality-gate-pipeline';
import { FormatValidatorAgent } from '../../src/qualidade/format-validator';
import { BNCCValidatorAgent } from '../../src/qualidade/bncc-validator';
import { PrivacyGuardAgent } from '../../src/qualidade/privacy-guard';
import { HallucinationDetectorAgent } from '../../src/qualidade/hallucination-detector';
import { ContentScorerAgent } from '../../src/qualidade/content-scorer';
import { PDIGuardianAgent } from '../../src/qualidade/pdi-guardian';
import { AntiPlagiarismScorerAgent } from '../../src/qualidade/anti-plagiarism-scorer';

// ===========================================================================
// Dummy Agents para controlar comportamento nas retentativas
// ===========================================================================

/** Dummy que sempre retorna sucesso com conteúdo válido para PLANO_AULA. */
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

  protected getPromptsMap(): Record<string, string> {
    return {};
  }

  protected async _buildRagContext(_t: TipoGeracao): Promise<string> {
    return '{}';
  }

  protected _selectPromptTemplate(_t: TipoGeracao): string {
    return 'Template dummy';
  }

  protected async _callLLM(
    _p: string,
    _r: string,
    _params: Record<string, unknown>,
  ): Promise<string> {
    return '{}';
  }

  protected async _postProcess(
    _raw: string,
    _tipo: TipoGeracao,
  ): Promise<GeracaoResultado> {
    return {
      sucesso: true,
      conteudo: {
        tema: 'Funções Quadráticas',
        duracao: '50 minutos',
        objetivo: 'Compreender funções quadráticas e suas aplicações',
        desenvolvimento: 'Aula expositiva com exemplos práticos de funções quadráticas no cotidiano',
        recursos: 'Quadro, projetor, calculadora',
        avaliacao: 'Exercícios de fixação ao final da aula',
        habilidades_bncc: ['EF06MA01'],
      },
      metadados: {
        agente: this.displayName,
        disciplina: this.getDisciplina(),
        nivel: this.context.nivel,
        tipo: _tipo,
        timestamp: new Date().toISOString(),
      },
    };
  }
}

/**
 * Dummy que controla falha por tentativa.
 * - chamada #1 (se _failFirst=true): retorna conteúdo null → FormatValidator BLOCKER
 * - demais chamadas: retorna conteúdo válido
 */
class RetryAwareAgent extends BaseDisciplineAgent {
  private _callCount = 0;

  public get displayName(): string {
    return 'RetryAware';
  }

  protected buildSystemPrompt(): string {
    return 'You are a retry-aware dummy agent.';
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

  protected async _buildRagContext(_t: TipoGeracao): Promise<string> {
    return '{}';
  }

  protected _selectPromptTemplate(_t: TipoGeracao): string {
    return 'Template dummy';
  }

  protected async _callLLM(
    _p: string,
    _r: string,
    _params: Record<string, unknown>,
  ): Promise<string> {
    // Se houver feedback acumulado, simula ajuste
    return JSON.stringify({ _feedback: _params._feedback ?? 'none' });
  }

  protected async _postProcess(
    _raw: string,
    _tipo: TipoGeracao,
  ): Promise<GeracaoResultado> {
    this._callCount++;

    // Primeira chamada: falha controlada (conteúdo null)
    if (this._callCount === 1) {
      return {
        sucesso: true,
        conteudo: null as unknown as Record<string, unknown>,
        metadados: {
          agente: this.displayName,
          disciplina: this.getDisciplina(),
          nivel: this.context.nivel,
          tipo: _tipo,
          timestamp: new Date().toISOString(),
        },
      };
    }

    // Chamadas seguintes: sucesso
    return {
      sucesso: true,
      conteudo: {
        tema: 'Funções Quadráticas',
        duracao: '50 minutos',
        objetivo: 'Compreender funções quadráticas',
        desenvolvimento: 'Aula com exemplos práticos',
        recursos: 'Quadro, calculadora',
        avaliacao: 'Exercícios de fixação',
        habilidades_bncc: ['EF06MA01'],
      },
      metadados: {
        agente: this.displayName,
        disciplina: this.getDisciplina(),
        nivel: this.context.nivel,
        tipo: _tipo,
        timestamp: new Date().toISOString(),
      },
    };
  }
}

/**
 * Dummy que sempre retorna conteúdo null (BLOCKER perpétuo).
 * Usado no teste de esgotamento de retries.
 */
class AlwaysBlockerAgent extends BaseDisciplineAgent {
  public get displayName(): string {
    return 'AlwaysBlocker';
  }

  protected buildSystemPrompt(): string {
    return 'You are an always-blocker agent.';
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

  protected async _buildRagContext(_t: TipoGeracao): Promise<string> {
    return '{}';
  }

  protected _selectPromptTemplate(_t: TipoGeracao): string {
    return 'Template dummy';
  }

  protected async _callLLM(
    _p: string,
    _r: string,
    _params: Record<string, unknown>,
  ): Promise<string> {
    return '{}';
  }

  protected async _postProcess(
    _raw: string,
    _tipo: TipoGeracao,
  ): Promise<GeracaoResultado> {
    return {
      sucesso: true,
      conteudo: null as unknown as Record<string, unknown>,
      metadados: {
        agente: this.displayName,
        disciplina: this.getDisciplina(),
        nivel: this.context.nivel,
        tipo: _tipo,
        timestamp: new Date().toISOString(),
      },
    };
  }
}

/**
 * Dummy que retorna conteúdo com CPF na primeira chamada,
 * depois conteúdo limpo (para teste de Privacy Guard + retry).
 */
class PrivacyLeakAgent extends BaseDisciplineAgent {
  private _callCount = 0;

  public get displayName(): string {
    return 'PrivacyLeak';
  }

  protected buildSystemPrompt(): string {
    return 'You are a privacy-leak agent.';
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

  protected async _buildRagContext(_t: TipoGeracao): Promise<string> {
    return '{}';
  }

  protected _selectPromptTemplate(_t: TipoGeracao): string {
    return 'Template dummy';
  }

  protected async _callLLM(
    _p: string,
    _r: string,
    _params: Record<string, unknown>,
  ): Promise<string> {
    return '{}';
  }

  protected async _postProcess(
    _raw: string,
    _tipo: TipoGeracao,
  ): Promise<GeracaoResultado> {
    this._callCount++;

    if (this._callCount === 1) {
      return {
        sucesso: true,
        conteudo: {
          tema: 'Aula Teste',
          duracao: '50 minutos',
          // CPF falso que o Privacy Guard detecta como BLOCKER
          observacao: 'Aluno João Silva, CPF 123.456.789-00 necessita de adaptação.',
        },
        metadados: {
          agente: this.displayName,
          disciplina: this.getDisciplina(),
          nivel: this.context.nivel,
          tipo: _tipo,
          timestamp: new Date().toISOString(),
        },
      };
    }

    return {
      sucesso: true,
      conteudo: {
        tema: 'Aula Teste',
        duracao: '50 minutos',
        objetivo: 'Aula corrigida sem dados pessoais',
        desenvolvimento: 'Conteúdo pedagógico seguro',
        recursos: 'Quadro',
        avaliacao: 'Participação',
      },
      metadados: {
        agente: this.displayName,
        disciplina: this.getDisciplina(),
        nivel: this.context.nivel,
        tipo: _tipo,
        timestamp: new Date().toISOString(),
      },
    };
  }
}

/**
 * Dummy que retorna código BNCC inválido na primeira chamada,
 * depois código válido.
 */
class BNCCLeakAgent extends BaseDisciplineAgent {
  private _callCount = 0;

  public get displayName(): string {
    return 'BNCCLeak';
  }

  protected buildSystemPrompt(): string {
    return 'You are a BNCC-leak agent.';
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

  protected async _buildRagContext(_t: TipoGeracao): Promise<string> {
    return '{}';
  }

  protected _selectPromptTemplate(_t: TipoGeracao): string {
    return 'Template dummy';
  }

  protected async _callLLM(
    _p: string,
    _r: string,
    _params: Record<string, unknown>,
  ): Promise<string> {
    return '{}';
  }

  protected async _postProcess(
    _raw: string,
    _tipo: TipoGeracao,
  ): Promise<GeracaoResultado> {
    this._callCount++;

    if (this._callCount === 1) {
      return {
        sucesso: true,
        conteudo: {
          tema: 'Aula Teste',
          duracao: '50 minutos',
          habilidades_bncc: ['EF99XX99'], // código inexistente no índice mock
        },
        metadados: {
          agente: this.displayName,
          disciplina: this.getDisciplina(),
          nivel: this.context.nivel,
          tipo: _tipo,
          timestamp: new Date().toISOString(),
        },
      };
    }

    return {
      sucesso: true,
      conteudo: {
        tema: 'Aula Teste',
        duracao: '50 minutos',
        objetivo: 'Aula com BNCC válido',
        habilidades_bncc: ['EF06MA01'], // código válido para Matemática EF6
      },
      metadados: {
        agente: this.displayName,
        disciplina: this.getDisciplina(),
        nivel: this.context.nivel,
        tipo: _tipo,
        timestamp: new Date().toISOString(),
      },
    };
  }
}

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
    params: { tema: 'Funções' },
    ...overrides,
  };
}

/** Cria um GeracaoResultado válido com conteúdo customizado. */
function makeResult(conteudo: Record<string, unknown>): GeracaoResultado {
  return {
    sucesso: true,
    conteudo,
    metadados: {
      agente: 'TestAgent',
      disciplina: 'MATEMATICA',
      nivel: 'EF_6',
      tipo: 'PLANO_AULA',
      timestamp: new Date().toISOString(),
    },
  };
}

/** Cria um DisciplinaContext mínimo. */
function makeContext(overrides?: Partial<DisciplinaContext>): DisciplinaContext {
  return {
    disciplina: DisciplinaNome.MATEMATICA,
    nivel: NivelEnsino.EF_6,
    professorId: 'prof-test',
    turmaId: 'turma-test',
    ...overrides,
  };
}

/** Registra um agente dummy no registry. */
function registerAgent(
  registry: AgentRegistry,
  Ctor: new (ctx: DisciplinaContext) => BaseDisciplineAgent,
  displayName: string,
  overrides?: Partial<AgentEntry>,
): void {
  registry.register({
    codigo: `Agent_${displayName}`,
    disciplina: DisciplinaNome.MATEMATICA,
    nivel: NivelEnsino.EF_6,
    displayName,
    construtor: Ctor,
    ...overrides,
  });
}

// ===========================================================================
// S4-06 E2E: Orchestrator + Quality Gates + Retry
// ===========================================================================

describe('S4-06 E2E — Orchestrator + Quality Gates com Retry', () => {
  // -----------------------------------------------------------------------
  // 1. Orchestrator com pipeline vazio → geração retorna sucesso sem validação
  // -----------------------------------------------------------------------
  it('1. Orchestrator com pipeline vazio → sucesso sem validação', async () => {
    const registry = new AgentRegistry();
    registerAgent(registry, DummySuccessAgent, 'DummySuccess');

    // Sem pipeline de qualidade
    const orchestrator = new OrchestratorAgent(registry);

    const response = await orchestrator.processarRequisicao(makeRequest());

    expect(response.sucesso).toBe(true);
    expect(response.conteudo).toBeDefined();
    expect(response.conteudo!.tema).toBe('Funções Quadráticas');
    expect(response.metadados).toBeDefined();
    expect(response.metadados!.tentativas).toBe(1);
    expect(response.erro).toBeUndefined();
  });

  // -----------------------------------------------------------------------
  // 2. Orchestrator com pipeline de 1 gate que passa → sucesso
  // -----------------------------------------------------------------------
  it('2. Orchestrator com pipeline de 1 gate que passa → sucesso', async () => {
    const registry = new AgentRegistry();
    registerAgent(registry, DummySuccessAgent, 'DummySuccess');

    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new FormatValidatorAgent());

    const orchestrator = new OrchestratorAgent(registry, { qualityPipeline: pipeline });

    const response = await orchestrator.processarRequisicao(makeRequest());

    expect(response.sucesso).toBe(true);
    expect(response.conteudo).toBeDefined();
    expect(response.metadados!.tentativas).toBe(1);
  });

  // -----------------------------------------------------------------------
  // 3. Orchestrator com pipeline BLOCKER (FormatValidator falha) → retry acontece
  // -----------------------------------------------------------------------
  it('3. Orchestrator com pipeline BLOCKER (FormatValidator) → retry acontece', async () => {
    const registry = new AgentRegistry();
    // AlwaysBlockerAgent sempre retorna null → FormatValidator dá BLOCKER em todas as tentativas
    registerAgent(registry, AlwaysBlockerAgent, 'AlwaysBlocker');

    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new FormatValidatorAgent());

    const orchestrator = new OrchestratorAgent(registry, {
      qualityPipeline: pipeline,
      maxRetries: 3,
    });

    const response = await orchestrator.processarRequisicao(makeRequest());

    // Todas as tentativas falham → erro final
    expect(response.sucesso).toBe(false);
    expect(response.erro).toBeDefined();
    expect(response.erro).toContain('Falha após 3 tentativa');
    expect(response.metadados!.tentativas).toBe(3);
  });

  // -----------------------------------------------------------------------
  // 4. Orchestrator com todos os 7 gates → validação completa com agente real
  // -----------------------------------------------------------------------
  it('4. Orchestrator com todos os 7 gates → validação completa', async () => {
    const registry = new AgentRegistry();
    registerAgent(registry, DummySuccessAgent, 'DummySuccess');

    // Pipeline com TODOS os 7 quality gates
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new FormatValidatorAgent());
    pipeline.addGate(new BNCCValidatorAgent());
    pipeline.addGate(new PrivacyGuardAgent());
    pipeline.addGate(new HallucinationDetectorAgent());
    pipeline.addGate(new ContentScorerAgent());
    pipeline.addGate(new PDIGuardianAgent());       // só aplicável para PDI_ADAPTACAO
    pipeline.addGate(new AntiPlagiarismScorerAgent()); // só aplicável para PLANO_AULA

    const orchestrator = new OrchestratorAgent(registry, {
      qualityPipeline: pipeline,
    });

    const response = await orchestrator.processarRequisicao(
      makeRequest({ tipo: TipoGeracao.PLANO_AULA }),
    );

    expect(response.sucesso).toBe(true);
    expect(response.conteudo).toBeDefined();
    // PLANO_AULA: 6 gates aplicáveis (FormatValidator, BNCC, Privacy, Hallucination,
    // ContentScorer, AntiPlagiarism). PDIGuardian é pulado (não aplicável).
    expect(response.metadados!.tentativas).toBe(1);
  });

  // -----------------------------------------------------------------------
  // 5. Ciclo completo: geração → pipeline → aprovação
  // -----------------------------------------------------------------------
  it('5. Ciclo completo: geração → pipeline → aprovação', async () => {
    const registry = new AgentRegistry();
    registerAgent(registry, DummySuccessAgent, 'DummySuccess');

    // Pipeline com gates essenciais
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new FormatValidatorAgent());
    pipeline.addGate(new BNCCValidatorAgent());
    pipeline.addGate(new PrivacyGuardAgent());
    pipeline.addGate(new ContentScorerAgent());

    const orchestrator = new OrchestratorAgent(registry, {
      qualityPipeline: pipeline,
    });

    const req = makeRequest({
      disciplina: DisciplinaNome.MATEMATICA,
      nivel: NivelEnsino.EF_6,
      tipo: TipoGeracao.PLANO_AULA,
    });
    const response = await orchestrator.processarRequisicao(req);

    // Validações do ciclo completo
    expect(response.sucesso).toBe(true);
    expect(response.conteudo).toBeDefined();
    expect(response.conteudo!.tema).toBe('Funções Quadráticas');
    expect(response.metadados!.agente).toBe('DummySuccess');
    expect(response.metadados!.tentativas).toBe(1);
    expect(response.metadados!.disciplina).toBe('MATEMATICA');
    expect(response.metadados!.timestamp).toBeDefined();
    expect(response.erro).toBeUndefined();
  });

  // -----------------------------------------------------------------------
  // 6. Ciclo com retry: geração → BLOCKER → retry → sucesso
  // -----------------------------------------------------------------------
  it('6. Ciclo com retry: geração → BLOCKER → retry → sucesso', async () => {
    const registry = new AgentRegistry();
    // RetryAwareAgent: falha na 1ª chamada (null), sucesso na 2ª
    registerAgent(registry, RetryAwareAgent, 'RetryAware');

    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new FormatValidatorAgent());

    const orchestrator = new OrchestratorAgent(registry, {
      qualityPipeline: pipeline,
      maxRetries: 3,
    });

    const response = await orchestrator.processarRequisicao(makeRequest());

    expect(response.sucesso).toBe(true);
    expect(response.conteudo).toBeDefined();
    expect(response.conteudo!.tema).toBe('Funções Quadráticas');
    // Deve ter usado 2 tentativas (1 falha + 1 sucesso)
    expect(response.metadados!.tentativas).toBe(2);
  });

  // -----------------------------------------------------------------------
  // 7. Privacy Guard BLOCKER (CPF no conteúdo) → retry
  // -----------------------------------------------------------------------
  it('7. Privacy Guard BLOCKER (CPF no conteúdo) → retry', async () => {
    const registry = new AgentRegistry();
    // PrivacyLeakAgent: 1ª chamada inclui CPF, 2ª chamada conteúdo limpo
    registerAgent(registry, PrivacyLeakAgent, 'PrivacyLeak');

    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new PrivacyGuardAgent());
    // Adiciona FormatValidator para garantir que o conteúdo é válido
    pipeline.addGate(new FormatValidatorAgent());

    const orchestrator = new OrchestratorAgent(registry, {
      qualityPipeline: pipeline,
      maxRetries: 3,
    });

    const response = await orchestrator.processarRequisicao(makeRequest());

    // Deve ter retentado e obtido sucesso na 2ª tentativa com conteúdo limpo
    expect(response.sucesso).toBe(true);
    expect(response.metadados!.tentativas).toBe(2);
    // Conteúdo final não deve conter CPF
    const conteudoStr = JSON.stringify(response.conteudo);
    expect(conteudoStr).not.toContain('123.456.789-00');
  });

  // -----------------------------------------------------------------------
  // 8. BNCC Validator BLOCKER (código inválido) → retry
  // -----------------------------------------------------------------------
  it('8. BNCC Validator BLOCKER (código inválido) → retry', async () => {
    const registry = new AgentRegistry();
    // BNCCLeakAgent: 1ª chamada com código inválido, 2ª com código válido
    registerAgent(registry, BNCCLeakAgent, 'BNCCLeak');

    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new BNCCValidatorAgent());

    const orchestrator = new OrchestratorAgent(registry, {
      qualityPipeline: pipeline,
      maxRetries: 3,
    });

    const response = await orchestrator.processarRequisicao(
      makeRequest({ disciplina: DisciplinaNome.MATEMATICA }),
    );

    expect(response.sucesso).toBe(true);
    expect(response.metadados!.tentativas).toBe(2);
  });

  // -----------------------------------------------------------------------
  // 9. Pipeline com Content Scorer + Hallucination Detector → score combinado
  // -----------------------------------------------------------------------
  it('9. Pipeline com Content Scorer + Hallucination Detector → score combinado', async () => {
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new ContentScorerAgent());
    pipeline.addGate(new HallucinationDetectorAgent());

    // Conteúdo bem estruturado: tamanho adequado, BNCC, estrutura pedagógica
    const resultado = makeResult({
      tema: 'Funções Quadráticas — Aplicações no Cotidiano',
      duracao: '50 minutos',
      objetivo: 'Compreender e aplicar funções quadráticas em problemas reais',
      desenvolvimento:
        'Aula expositiva com exemplos de trajetória de projéteis, otimização de área ' +
        'e modelagem de fenômenos físicos. Exercícios em grupo e discussão coletiva.',
      recursos: 'Quadro, projetor multimídia, calculadoras científicas, software GeoGebra',
      avaliacao: 'Resolução de 5 problemas contextualizados com rubrica de correção',
      habilidades_bncc: ['EF06MA01'],
      metodologia: 'Aprendizagem baseada em problemas com abordagem investigativa',
    });

    const req = makeRequest({ tipo: TipoGeracao.PLANO_AULA });

    const pipelineResult: PipelineResult = await pipeline.validate(resultado, req);

    expect(pipelineResult.aprovado).toBe(true);
    expect(pipelineResult.gateResults.length).toBe(2);
    // Score combinado = produto dos scores individuais
    const scoreProduto =
      pipelineResult.gateResults[0].score * pipelineResult.gateResults[1].score;
    expect(pipelineResult.score).toBe(scoreProduto);
    // Ambos os gates devem ter passado (Content Scorer pode dar WARNING mas passed=true)
    expect(pipelineResult.blockers.length).toBe(0);
  });

  // -----------------------------------------------------------------------
  // 10. PDI Guardian + Privacy Guard com PDI_ADAPTACAO → validação específica
  // -----------------------------------------------------------------------
  it('10. PDI Guardian + Privacy Guard com PDI_ADAPTACAO → validação específica', async () => {
    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new PDIGuardianAgent());
    pipeline.addGate(new PrivacyGuardAgent());

    // Conteúdo PDI válido: tem todos os campos obrigatórios, sem PII
    const resultado = makeResult({
      aluno_id: 'aluno-123',
      pdi_id: 'pdi-456',
      aula_id: 'aula-789',
      adaptacao:
        'Disponibilizar material ampliado (fonte 18pt) e tempo adicional de 50% ' +
        'para realização das atividades avaliativas, conforme previsto no PDI do estudante. ' +
        'Utilizar recursos de tecnologia assistiva com leitor de tela e software de ' +
        'ampliação. As adaptações seguem os princípios do DUA garantindo múltiplas ' +
        'formas de representação, ação/expressão e engajamento.',
    });

    const req = makeRequest({ tipo: TipoGeracao.PDI_ADAPTACAO });

    const pipelineResult: PipelineResult = await pipeline.validate(resultado, req);

    // PDIGuardian: aplicável para PDI_ADAPTACAO → deve passar
    // PrivacyGuard: sempre aplicável → deve passar (sem PII)
    expect(pipelineResult.aprovado).toBe(true);
    expect(pipelineResult.gateResults.length).toBe(2);
    expect(pipelineResult.blockers.length).toBe(0);

    // Verifica que ambos os gates foram executados
    const gateNames = pipelineResult.gateResults.map((g) => g.gate);
    expect(gateNames).toContain('PDI Guardian');
    expect(gateNames).toContain('Privacy Guard');
  });

  // -----------------------------------------------------------------------
  // 11. Anti-Plagiarism Scorer com múltiplas aulas → detecta similaridade
  // -----------------------------------------------------------------------
  it('11. Anti-Plagiarism Scorer com múltiplas aulas → detecta similaridade', async () => {
    const antiPlagiarism = new AntiPlagiarismScorerAgent();

    // Adiciona aula ao histórico com conteúdo bem definido
    antiPlagiarism.addAulaHistorico(
      JSON.stringify({
        tema: 'Funções Quadráticas — Introdução ao Conceito',
        objetivo: 'Compreender funções quadráticas e suas aplicações no cotidiano',
        desenvolvimento:
          'Aula expositiva dialogada com exemplos práticos de funções quadráticas. ' +
          'Os alunos devem resolver exercícios de fixação com problemas contextualizados ' +
          'envolvendo parábolas e modelagem matemática. Trabalho em grupo com apresentação.',
        recursos: 'Quadro branco, projetor multimídia, calculadora científica, GeoGebra',
        avaliacao: 'Lista de exercícios com rubrica de correção',
      }),
    );

    antiPlagiarism.addAulaHistorico(
      JSON.stringify({
        tema: 'Função Afim — Revisão',
        objetivo: 'Revisar conceitos de função afim',
        desenvolvimento: 'Revisão de função afim com exemplos do cotidiano.',
        recursos: 'Quadro',
        avaliacao: 'Exercícios',
      }),
    );

    // Conteúdo MUITO similar à primeira aula (compartilha a maioria das palavras)
    const resultado = makeResult({
      tema: 'Funções Quadráticas — Introdução ao Conceito',
      objetivo: 'Compreender funções quadráticas e suas aplicações no cotidiano',
      desenvolvimento:
        'Aula expositiva dialogada com exemplos práticos de funções quadráticas. ' +
        'Os alunos devem resolver exercícios de fixação com problemas contextualizados ' +
        'envolvendo parábolas e modelagem matemática. Trabalho em grupo com apresentação.',
      recursos: 'Quadro branco, projetor multimídia, calculadora científica, GeoGebra',
      avaliacao: 'Lista de exercícios com rubrica de correção',
    });

    const req = makeRequest({ tipo: TipoGeracao.PLANO_AULA });

    const gateResult = await antiPlagiarism.check(resultado, req);

    expect(gateResult.gate).toBe('Anti-Plagiarism Scorer');
    // Deve detectar similaridade com a primeira aula
    expect(gateResult.severity).toBe('WARNING');
    expect(gateResult.score).toBeLessThan(1.0);
    expect(gateResult.message).toContain('similaridade');
  });

  // -----------------------------------------------------------------------
  // 12. Esgotamento de retries: 3 falhas → erro final
  // -----------------------------------------------------------------------
  it('12. Esgotamento de retries: 3 falhas → erro final', async () => {
    const registry = new AgentRegistry();
    // AlwaysBlockerAgent sempre retorna null → BLOCKER perpétuo
    registerAgent(registry, AlwaysBlockerAgent, 'AlwaysBlocker');

    const pipeline = new QualityGatePipeline();
    pipeline.addGate(new FormatValidatorAgent());

    const orchestrator = new OrchestratorAgent(registry, {
      qualityPipeline: pipeline,
      maxRetries: 3,
    });

    const response = await orchestrator.processarRequisicao(makeRequest());

    // Após 3 tentativas, todas falharam → erro
    expect(response.sucesso).toBe(false);
    expect(response.erro).toBeDefined();
    expect(response.erro).toContain('Falha após 3 tentativa');
    expect(response.erro).toContain('[QualityGate]');
    expect(response.metadados!.tentativas).toBe(3);
    expect(response.conteudo).toBeUndefined();
  });
});
