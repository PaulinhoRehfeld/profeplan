// ============================================================================
// PROFEPLAN — Testes: bncc-validator
// Regressão do achado #10 (auditoria 2026-07-10): matchDisciplina usava
// includes() bidirecional, deixando passar código de disciplina errada
// sempre que uma é substring da outra (ex: "Física" ⊂ "Educação Física").
// ============================================================================

import { describe, it, expect } from 'vitest';
import { BNCCValidatorAgent } from '../../src/qualidade/bncc-validator';
import { TipoGeracao, DisciplinaNome, NivelEnsino } from '../../src/base/discipline-agent-base';
import type { GeracaoResultado } from '../../src/base/discipline-agent-base';
import type { GeracaoRequest } from '../../src/coordenacao/orchestrator-agent';

const buildReq = (disciplina: DisciplinaNome): GeracaoRequest => ({
  disciplina,
  nivel: NivelEnsino.EF_9,
  tipo: TipoGeracao.PLANO_AULA,
  professorId: 'prof-1',
  turmaId: 'turma-1',
  params: {},
});

const resultadoComCodigos = (codigos: string[]): GeracaoResultado => ({
  sucesso: true,
  conteudo: { habilidades_bncc: codigos },
});

describe('BNCCValidatorAgent (regressão #10 — comparação exata de disciplina)', () => {
  it('BLOQUEIA código de "Educação Física" quando a disciplina requisitada é "Física" (não é mais substring match)', async () => {
    const gate = new BNCCValidatorAgent();
    // Injeta um registro mock de Educação Física (índice real não tem esse caso hoje)
    (gate as any).habilidadeIndex.set('EF09EF01', [
      { codigo: 'EF09EF01', disciplina: 'Educação Física', ano: 'MOCK', descricao: '[MOCK]' },
    ]);

    const result = await gate.check(resultadoComCodigos(['EF09EF01']), buildReq(DisciplinaNome.FISICA));

    expect(result.passed).toBe(false);
    expect(result.severity).toBe('BLOCKER');
    expect(result.message).toContain('OUTRA disciplina');
  });

  it('BLOQUEIA código de "Ciências Humanas e Sociais Aplicadas" quando a disciplina requisitada é "Ciências"', async () => {
    const gate = new BNCCValidatorAgent();
    (gate as any).habilidadeIndex.set('EM13CHS999', [
      { codigo: 'EM13CHS999', disciplina: 'Ciências Humanas e Sociais Aplicadas', ano: 'MOCK', descricao: '[MOCK]' },
    ]);

    const result = await gate.check(resultadoComCodigos(['EM13CHS999']), buildReq(DisciplinaNome.CIENCIAS));

    expect(result.passed).toBe(false);
    expect(result.severity).toBe('BLOCKER');
  });

  it('continua validando corretamente quando a disciplina bate exatamente', async () => {
    const gate = new BNCCValidatorAgent();
    const result = await gate.check(resultadoComCodigos(['EF09HI01']), buildReq(DisciplinaNome.HISTORIA));

    expect(result.passed).toBe(true);
    expect(result.severity).toBe('INFO');
  });
});
