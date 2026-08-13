import assert from 'node:assert/strict';
import test from 'node:test';
import { evaluateMvpCurriculumScope } from '../src/index.ts';

const occurredAt = '2026-08-07T12:00:00.000Z';

function pkg(overrides = {}) {
  return {
    id: 'curriculum-mg-em',
    version: '1',
    state: 'MG',
    stage: 'ensino_medio',
    status: 'active',
    title: 'Currículo sintético MG',
    effectiveFrom: '2026-01-01T00:00:00.000Z',
    sourceVersionIds: ['source-version-1'],
    ...overrides,
  };
}

test('MG Filosofia 2º EM is accepted in MVP', () => {
  const decision = evaluateMvpCurriculumScope({
    curriculumPackage: pkg(),
    schoolComponent: 'Filosofia',
    stage: 'ensino_medio',
    grade: '2_em',
    occurredAt,
  });
  assert.equal(decision.allowed, true);
});

test('RS remains blocked', () => {
  const decision = evaluateMvpCurriculumScope({
    curriculumPackage: pkg({ state: 'RS' }),
    schoolComponent: 'Filosofia',
    stage: 'ensino_medio',
    grade: '2_em',
    occurredAt,
  });
  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'CURRICULUM_STATE_BLOCKED'));
});

test('wrong grade is outside pilot scope', () => {
  const decision = evaluateMvpCurriculumScope({
    curriculumPackage: pkg(),
    schoolComponent: 'Filosofia',
    stage: 'ensino_medio',
    grade: '3_em',
    occurredAt,
  });
  assert.equal(decision.allowed, false);
});
