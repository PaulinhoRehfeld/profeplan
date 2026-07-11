// ============================================================================
// PROFEPLAN — Testes: privacy-guard
// Regressão do achado #9 (auditoria 2026-07-10): a regex de data de
// nascimento casava QUALQUER data dd/mm/aaaa, bloqueando conteúdo
// pedagógico válido (datas históricas, prazos) como se fosse PII.
// ============================================================================

import { describe, it, expect } from 'vitest';
import { PrivacyGuardAgent } from '../../src/qualidade/privacy-guard';
import { TipoGeracao, DisciplinaNome, NivelEnsino } from '../../src/base/discipline-agent-base';
import type { GeracaoResultado } from '../../src/base/discipline-agent-base';
import type { GeracaoRequest } from '../../src/coordenacao/orchestrator-agent';

const req: GeracaoRequest = {
  disciplina: DisciplinaNome.HISTORIA,
  nivel: NivelEnsino.EF_9,
  tipo: TipoGeracao.PLANO_AULA,
  professorId: 'prof-1',
  turmaId: 'turma-1',
  params: {},
};

const resultadoCom = (texto: string): GeracaoResultado => ({
  sucesso: true,
  conteudo: { texto },
});

describe('PrivacyGuardAgent (regressão #9 — regex de data de nascimento)', () => {
  const guard = new PrivacyGuardAgent();

  it('NÃO bloqueia data histórica sem contexto de nascimento', async () => {
    const result = await guard.check(
      resultadoCom('A Proclamação da República ocorreu em 15/11/1889.'),
      req,
    );
    expect(result.passed).toBe(true);
    expect(result.severity).not.toBe('BLOCKER');
  });

  it('NÃO bloqueia prazo de entrega no formato dd/mm/aaaa', async () => {
    const result = await guard.check(
      resultadoCom('Prazo de entrega do trabalho: 20/09/2026.'),
      req,
    );
    expect(result.passed).toBe(true);
    expect(result.severity).not.toBe('BLOCKER');
  });

  it('bloqueia quando a palavra "nascimento" aparece próxima da data', async () => {
    const result = await guard.check(
      resultadoCom('Data de nascimento: 12/05/2010.'),
      req,
    );
    expect(result.passed).toBe(false);
    expect(result.severity).toBe('BLOCKER');
  });

  it('continua bloqueando CPF', async () => {
    const result = await guard.check(
      resultadoCom('CPF do responsável: 123.456.789-00.'),
      req,
    );
    expect(result.passed).toBe(false);
    expect(result.severity).toBe('BLOCKER');
  });
});
