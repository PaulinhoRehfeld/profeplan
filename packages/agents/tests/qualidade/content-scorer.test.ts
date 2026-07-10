// ============================================================================
// PROFEPLAN — Testes: ContentScorerAgent
// S4-02: Testes unitários para o gate de qualidade pedagógica heurística
// ============================================================================

import { describe, it, expect } from 'vitest';

import {
  DisciplinaNome,
  NivelEnsino,
  TipoGeracao,
} from '../../src/base/discipline-agent-base';
import type { GeracaoResultado } from '../../src/base/discipline-agent-base';

import type { GeracaoRequest } from '../../src/coordenacao/orchestrator-agent';
import type { GateResult } from '../../src/qualidade/quality-gate-pipeline';

import { ContentScorerAgent } from '../../src/qualidade/content-scorer';

// ===========================================================================
// Helpers
// ===========================================================================

/** Cria uma GeracaoRequest mínima para testes. */
function makeRequest(overrides?: Partial<GeracaoRequest>): GeracaoRequest {
  return {
    disciplina: DisciplinaNome.GEOGRAFIA,
    nivel: NivelEnsino.EF_6,
    tipo: TipoGeracao.PLANO_AULA,
    professorId: 'prof-test',
    turmaId: 'turma-test',
    params: { tema: 'Clima' },
    ...overrides,
  };
}

/** Cria um GeracaoResultado válido mínimo. */
function makeResult(conteudo: Record<string, unknown>): GeracaoResultado {
  return {
    sucesso: true,
    conteudo,
    metadados: {
      agente: 'TestAgent',
      disciplina: 'GEOGRAFIA',
      nivel: 'EF_6',
      tipo: 'PLANO_AULA',
      timestamp: new Date().toISOString(),
    },
  };
}

/** Gera uma string de preenchimento com N caracteres. */
function pad(length: number): string {
  return 'x'.repeat(length);
}

// ===========================================================================
// 1. Testes de nome e aplicabilidade
// ===========================================================================

describe('ContentScorerAgent — Nome e Aplicabilidade', () => {
  const gate = new ContentScorerAgent();

  it('1.1. name retorna "Content Scorer"', () => {
    expect(gate.name).toBe('Content Scorer');
  });

  it('1.2. isApplicable retorna true para qualquer TipoGeracao', () => {
    const tipos = Object.values(TipoGeracao);
    for (const tipo of tipos) {
      expect(gate.isApplicable(tipo)).toBe(true);
    }
  });
});

// ===========================================================================
// 2. Conteúdo ausente ou inválido → BLOCKER
// ===========================================================================

describe('ContentScorerAgent — Conteúdo ausente/inválido', () => {
  const gate = new ContentScorerAgent();

  it('2.1. conteudo null → BLOCKER, score 0', async () => {
    const resultado: GeracaoResultado = {
      sucesso: false,
      conteudo: null as unknown as Record<string, unknown>,
    };
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.gate).toBe('Content Scorer');
    expect(r.passed).toBe(false);
    expect(r.severity).toBe('BLOCKER');
    expect(r.score).toBe(0);
    expect(r.message).toContain('ausente');
  });

  it('2.2. conteudo undefined → BLOCKER, score 0', async () => {
    const resultado: GeracaoResultado = {
      sucesso: false,
      conteudo: undefined as unknown as Record<string, unknown>,
    };
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.passed).toBe(false);
    expect(r.severity).toBe('BLOCKER');
    expect(r.score).toBe(0);
  });

  it('2.3. conteudo é string → BLOCKER, score 0', async () => {
    const resultado: GeracaoResultado = {
      sucesso: false,
      conteudo: 'string inválida' as unknown as Record<string, unknown>,
    };
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.passed).toBe(false);
    expect(r.severity).toBe('BLOCKER');
    expect(r.score).toBe(0);
  });
});

// ===========================================================================
// 3. Critério 1: Tamanho adequado (>=200 chars)
// ===========================================================================

describe('ContentScorerAgent — Critério 1: Tamanho adequado', () => {
  const gate = new ContentScorerAgent();

  it('3.1. Conteúdo >=200 chars → +0.3 no score', async () => {
    const conteudo = {
      tema: 'Clima e Tempo',
      descricao: pad(190), // total > 200 chars
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    // 0.3 (tamanho) + 0 (sem estrutura) + 0 (sem BNCC) + 0.2 (linguagem ok) = 0.5
    expect(r.score).toBeGreaterThanOrEqual(0.3);
    expect(r.message).toContain('Tamanho adequado');
  });

  it('3.2. Conteúdo <200 chars → sem pontuação de tamanho', async () => {
    const conteudo = { tema: 'Curto' };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    // 0 (tamanho) + 0 (sem estrutura) + 0 (sem BNCC) + 0.2 (linguagem ok) = 0.2
    expect(r.score).toBeLessThan(0.3);
    expect(r.message).toContain('muito curto');
  });
});

// ===========================================================================
// 4. Critério 2: Estrutura pedagógica
// ===========================================================================

describe('ContentScorerAgent — Critério 2: Estrutura pedagógica', () => {
  const gate = new ContentScorerAgent();

  it('4.1. Campo "objetivos" presente → +0.3', async () => {
    const conteudo = {
      objetivos: 'Compreender conceitos básicos',
      descricao: pad(180),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    // 0.3 (tamanho) + 0.3 (estrutura: objetivos) + 0 (sem BNCC) + 0.2 (linguagem) = 0.8
    expect(r.score).toBeGreaterThanOrEqual(0.7);
    expect(r.message).toContain('Estrutura pedagógica presente');
    expect(r.message).toContain('objetivos');
  });

  it('4.2. Campo "desenvolvimento" presente → +0.3', async () => {
    const conteudo = {
      desenvolvimento: 'Etapas da aula...',
      descricao: pad(180),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.message).toContain('Estrutura pedagógica presente');
    expect(r.message).toContain('desenvolvimento');
  });

  it('4.3. Campo "habilidades_bncc" presente → +0.3', async () => {
    const conteudo = {
      habilidades_bncc: ['EF06GE01'],
      descricao: pad(180),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.message).toContain('Estrutura pedagógica presente');
    expect(r.message).toContain('habilidades_bncc');
  });

  it('4.4. Campo "metodologia" presente → +0.3', async () => {
    const conteudo = {
      metodologia: 'Aula expositiva dialogada',
      descricao: pad(180),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.message).toContain('Estrutura pedagógica presente');
  });

  it('4.5. Nenhum campo estrutural → sem pontuação de estrutura', async () => {
    const conteudo = {
      x: 'y',
      descricao: pad(180),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    // 0.3 (tamanho) + 0 (sem estrutura) + 0 (sem BNCC) + 0.2 (linguagem) = 0.5
    expect(r.message).toContain('Estrutura pedagógica ausente');
  });
});

// ===========================================================================
// 5. Critério 3: BNCC presente
// ===========================================================================

describe('ContentScorerAgent — Critério 3: BNCC presente', () => {
  const gate = new ContentScorerAgent();

  it('5.1. Código EF no conteúdo → +0.2', async () => {
    const conteudo = {
      tema: 'Cartografia',
      habilidades: 'EF06GE01 - Localização espacial',
      descricao: pad(180),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    // 0.3 (tamanho) + 0 (sem estrutura) + 0.2 (BNCC) + 0.2 (linguagem) = 0.7
    expect(r.score).toBeGreaterThanOrEqual(0.7);
    expect(r.message).toContain('BNCC presente');
  });

  it('5.2. Código EM no conteúdo → +0.2', async () => {
    const conteudo = {
      tema: 'Física Moderna',
      habilidades: 'EM13CNT101 - Analisar fenômenos',
      descricao: pad(180),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.message).toContain('BNCC presente');
  });

  it('5.3. Múltiplos códigos BNCC → +0.2', async () => {
    const conteudo = {
      tema: 'Geografia Física',
      habilidades: 'EF06GE01 EF06GE02 EF06GE03',
      descricao: pad(180),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.message).toContain('BNCC presente');
    expect(r.message).toContain('3 código(s)');
  });

  it('5.4. Sem código BNCC → sem pontuação', async () => {
    const conteudo = {
      tema: 'Aula sem referência BNCC',
      descricao: pad(180),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    // 0.3 (tamanho) + 0 (sem estrutura) + 0 (sem BNCC) + 0.2 (linguagem) = 0.5
    expect(r.message).toContain('BNCC ausente');
  });
});

// ===========================================================================
// 6. Critério 4: Linguagem inclusiva
// ===========================================================================

describe('ContentScorerAgent — Critério 4: Linguagem inclusiva', () => {
  const gate = new ContentScorerAgent();

  it('6.1. Conteúdo limpo → +0.2', async () => {
    const conteudo = {
      tema: 'Aula sobre diversidade',
      descricao: 'Todos os alunos são capazes de aprender. ' + pad(140),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    // 0.3 (tamanho) + 0 (sem estrutura) + 0 (sem BNCC) + 0.2 (linguagem) = 0.5
    expect(r.message).toContain('Linguagem inclusiva');
    expect(r.score).toBe(0.5);
  });

  it('6.2. Termo "burro" detectado → sem pontuação de linguagem', async () => {
    const conteudo = {
      tema: 'Aula problemática',
      descricao: 'O aluno é burro e não aprende. ' + pad(150),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    // 0.3 (tamanho) + 0 (sem estrutura) + 0 (sem BNCC) + 0 (linguagem) = 0.3
    expect(r.message).toContain('Linguagem não inclusiva');
    expect(r.message).toContain('burro');
    expect(r.score).toBe(0.3);
  });

  it('6.3. Termo "idiota" detectado → sem pontuação', async () => {
    const conteudo = {
      tema: 'Problema',
      descricao: 'Que pergunta idiota. ' + pad(170),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.message).toContain('Linguagem não inclusiva');
    expect(r.message).toContain('idiota');
  });

  it('6.4. Termo "incapaz" detectado → sem pontuação', async () => {
    const conteudo = {
      tema: 'Estigma',
      descricao: 'Aluno incapaz de realizar a tarefa. ' + pad(150),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.message).toContain('Linguagem não inclusiva');
    expect(r.message).toContain('incapaz');
  });

  it('6.5. Termo "retardado" detectado → sem pontuação', async () => {
    const conteudo = {
      tema: 'Ofensa',
      descricao: 'Comportamento retardado. ' + pad(168),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.message).toContain('Linguagem não inclusiva');
    expect(r.message).toContain('retardado');
  });

  it('6.6. Termo "anormal" detectado → sem pontuação', async () => {
    const conteudo = {
      tema: 'Julgamento',
      descricao: 'Situação anormal em sala. ' + pad(165),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.message).toContain('Linguagem não inclusiva');
    expect(r.message).toContain('anormal');
  });

  it('6.7. Termo "defeituoso" detectado → sem pontuação', async () => {
    const conteudo = {
      tema: 'Defeito',
      descricao: 'Raciocínio defeituoso. ' + pad(168),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.message).toContain('Linguagem não inclusiva');
    expect(r.message).toContain('defeituoso');
  });

  it('6.8. Regex é case-insensitive (BURRO, IdIoTa)', async () => {
    const conteudo = {
      tema: 'Case',
      descricao: 'Isso é BURRO e IdIoTa. ' + pad(155),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.message).toContain('Linguagem não inclusiva');
    expect(r.message).toMatch(/burro/i);
    expect(r.message).toMatch(/idiota/i);
  });

  it('6.9. Múltiplos termos → lista todos na mensagem', async () => {
    const conteudo = {
      tema: 'Vários',
      descricao: 'burro e anormal. ' + pad(170),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.message).toContain('2 termo(s) discriminatório(s)');
  });
});

// ===========================================================================
// 7. Cenários de severidade (BLOCKER / WARNING / INFO)
// ===========================================================================

describe('ContentScorerAgent — Classificação de severidade', () => {
  const gate = new ContentScorerAgent();

  it('7.1. Score 0.0 → BLOCKER (conteúdo ausente)', async () => {
    const resultado: GeracaoResultado = {
      sucesso: false,
      conteudo: null as unknown as Record<string, unknown>,
    };
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.severity).toBe('BLOCKER');
    expect(r.passed).toBe(false);
    expect(r.score).toBe(0);
  });

  it('7.2. Score <0.3 → BLOCKER (conteúdo muito pobre)', async () => {
    // Apenas linguagem inclusiva passa: 0.2, tamanho < 200
    const conteudo = { t: 'x' };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.severity).toBe('BLOCKER');
    expect(r.passed).toBe(false);
    expect(r.score).toBe(0.2);
  });

  it('7.3. Score entre 0.3 e <0.5 → WARNING', async () => {
    // 0.3 (tamanho) + 0 (sem estrutura) + 0 (sem BNCC) + 0 (termo discriminatório) = 0.3
    const conteudo = {
      tema: 'Aula',
      descricao: 'Que ideia burro. ' + pad(170),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.severity).toBe('WARNING');
    expect(r.passed).toBe(true);
    expect(r.score).toBe(0.3);
  });

  it('7.4. Score 0.5 → INFO (aceitável)', async () => {
    // 0.3 (tamanho) + 0 (sem estrutura) + 0 (sem BNCC) + 0.2 (linguagem) = 0.5
    const conteudo = {
      tema: 'Aula Ok',
      descricao: pad(190),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.severity).toBe('INFO');
    expect(r.passed).toBe(true);
    expect(r.score).toBe(0.5);
  });

  it('7.5. Score >=0.7 → INFO (boa qualidade)', async () => {
    // 0.3 (tamanho) + 0.3 (estrutura) + 0 (sem BNCC) + 0.2 (linguagem) = 0.8
    const conteudo = {
      objetivos: 'Aprender sobre clima',
      tema: 'Clima e Tempo',
      descricao: pad(180),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.severity).toBe('INFO');
    expect(r.passed).toBe(true);
    expect(r.score).toBe(0.8);
    expect(r.message).toContain('boa qualidade');
  });

  it('7.6. Score máximo 1.0 → INFO', async () => {
    // 0.3 (tamanho) + 0.3 (estrutura) + 0.2 (BNCC) + 0.2 (linguagem) = 1.0
    const conteudo = {
      objetivos: 'Compreender os biomas brasileiros',
      desenvolvimento: 'Aula expositiva com slides',
      habilidades_bncc: ['EF06GE01'],
      tema: 'Biomas',
      duracao: '50 minutos',
      // Código BNCC embutido como string também:
      codigos: 'EF06GE01 e EF06GE02',
      descricao: pad(180),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.severity).toBe('INFO');
    expect(r.passed).toBe(true);
    expect(r.score).toBe(1.0);
    expect(r.message).toContain('1.00');
  });

  it('7.7. Score nunca excede 1.0 (clamp)', async () => {
    // Todos os critérios atendidos — deve ser exatamente 1.0
    const conteudo = {
      objetivos: 'Meta da aula',
      desenvolvimento: 'Passo a passo',
      habilidades_bncc: 'EF06GE01',
      tema: 'Tema',
      descricao: pad(190),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.score).toBeLessThanOrEqual(1.0);
    expect(r.score).toBe(1.0);
  });
});

// ===========================================================================
// 8. suggestion (mensagem de melhoria)
// ===========================================================================

describe('ContentScorerAgent — Sugestões de melhoria', () => {
  const gate = new ContentScorerAgent();

  it('8.1. Sem falhas → suggestion é undefined', async () => {
    const conteudo = {
      objetivos: 'Aprender',
      desenvolvimento: 'Etapas',
      habilidades_bncc: ['EF06GE01'],
      descricao: pad(190),
    };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.score).toBe(1.0);
    expect(r.suggestion).toBeUndefined();
  });

  it('8.2. Com falhas → suggestion contém "Melhorias sugeridas"', async () => {
    const conteudo = { t: 'x' };
    const resultado = makeResult(conteudo);
    const req = makeRequest();

    const r: GateResult = await gate.check(resultado, req);

    expect(r.suggestion).toBeDefined();
    expect(r.suggestion).toContain('Melhorias sugeridas');
  });
});
