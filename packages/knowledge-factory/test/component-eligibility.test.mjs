import assert from 'node:assert/strict';
import test from 'node:test';
import { evaluateComponentEligibility } from '../src/index.ts';

const occurredAt = '2026-08-07T12:00:00.000Z';

const source = {
  id: 'source-1',
  version: '1',
  title: 'Fonte sintética',
  sourceType: 'wrtech_owned',
  status: 'approved',
  licenseCategory: 'owned',
  allowedUses: ['retrieval', 'generation'],
  createdAt: occurredAt,
  updatedAt: occurredAt,
};

const component = {
  id: 'component-1',
  version: '1',
  canonicalKey: 'filosofia-etica',
  title: 'Componente sintético',
  componentType: 'concept',
  schoolComponent: 'Filosofia',
  grades: ['2_em'],
  status: 'approved',
  currentVersionId: 'component-version-1',
  createdAt: occurredAt,
  updatedAt: occurredAt,
};

const version = {
  id: 'component-version-1',
  version: '1',
  componentId: component.id,
  summary: 'Resumo sintético',
  keywords: ['ética'],
  sourceEvidenceIds: ['evidence-1'],
  curriculumNodeIds: ['node-1'],
  status: 'approved',
  approvedAt: occurredAt,
};

const evidence = {
  id: 'evidence-1',
  version: '1',
  componentVersionId: version.id,
  sourceId: source.id,
  sourceVersionId: 'source-version-1',
  sourceSegmentId: 'segment-1',
  contribution: 'conceptual',
  recordedAt: occurredAt,
};

const curriculumPackage = {
  id: 'curriculum-mg-em',
  version: '1',
  state: 'MG',
  stage: 'ensino_medio',
  status: 'active',
  title: 'Currículo sintético MG',
  effectiveFrom: '2026-01-01T00:00:00.000Z',
  sourceVersionIds: ['source-version-1'],
};

const node = {
  id: 'node-1',
  version: '1',
  curriculumPackageId: curriculumPackage.id,
  nodeType: 'skill',
  code: 'SYN-001',
  title: 'Habilidade sintética',
  description: 'Descrição sintética',
  component: 'Filosofia',
  grades: ['2_em'],
};

function evaluate(overrides = {}) {
  return evaluateComponentEligibility({
    component,
    version,
    evidenceOrigins: [evidence],
    sources: [source],
    curriculumPackage,
    curriculumNodes: [node],
    scope: { schoolComponent: 'Filosofia', stage: 'ensino_medio', grade: '2_em' },
    occurredAt,
    ...overrides,
  });
}

test('approved traceable aligned component is eligible', () => {
  assert.equal(evaluate().allowed, true);
});

test('component depending on blocked source is rejected', () => {
  const blockedSource = { ...source, status: 'blocked' };
  const decision = evaluate({ sources: [blockedSource] });
  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'COMPONENT_SOURCE_INELIGIBLE'));
});

test('component without curriculum evidence is rejected', () => {
  const decision = evaluate({ version: { ...version, curriculumNodeIds: [] } });
  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'COMPONENT_CURRICULUM_MISSING'));
});
