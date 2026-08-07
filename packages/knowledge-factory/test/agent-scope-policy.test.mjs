import assert from 'node:assert/strict';
import test from 'node:test';
import { evaluateSocrates2Scope } from '../src/index.ts';

const occurredAt = '2026-08-07T12:00:00.000Z';

const scope = {
  id: 'scope-socrates-2',
  version: '1',
  schoolComponent: 'Filosofia',
  stage: 'ensino_medio',
  grades: ['2_em'],
  curriculumStates: ['MG'],
  mode: 'primary',
};

const profile = {
  id: 'agent-socrates-2',
  version: '1',
  name: 'Sócrates 2',
  description: 'Perfil sintético',
  scopeId: scope.id,
  activeCurriculumPackageId: 'curriculum-mg-em',
  allowedTools: [],
  blockedDomains: [],
  active: true,
};

function request(overrides = {}) {
  return {
    schoolComponent: 'Filosofia',
    stage: 'ensino_medio',
    grade: '2_em',
    curriculumState: 'MG',
    curriculumPackageId: 'curriculum-mg-em',
    productType: 'lesson_plan',
    occurredAt,
    ...overrides,
  };
}

test('Socrates 2 accepts its exact MVP scope', () => {
  assert.equal(evaluateSocrates2Scope({ profile, scope, request: request() }).allowed, true);
});

test('Socrates 2 rejects another component', () => {
  assert.equal(
    evaluateSocrates2Scope({ profile, scope, request: request({ schoolComponent: 'História' }) })
      .allowed,
    false
  );
});

test('Socrates 2 rejects RS', () => {
  assert.equal(
    evaluateSocrates2Scope({ profile, scope, request: request({ curriculumState: 'RS' }) }).allowed,
    false
  );
});
