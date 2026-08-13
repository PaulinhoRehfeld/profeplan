import assert from 'node:assert/strict';
import test from 'node:test';
import { evaluateOppTransition } from '../src/index.ts';

const occurredAt = '2026-08-07T12:00:00.000Z';

function order(status) {
  return {
    id: 'opp-1',
    version: '1',
    requesterId: 'teacher-synthetic',
    agentProfileId: 'agent-socrates-2',
    curriculumPackageId: 'curriculum-mg-em',
    productType: 'lesson_plan',
    theme: 'Tema sintético',
    status,
    createdAt: occurredAt,
    updatedAt: occurredAt,
  };
}

const sufficient = {
  id: 'sufficiency-1',
  version: '1',
  sufficient: true,
  reasons: [],
  evidenceCount: 1,
  componentCount: 1,
};

const insufficient = {
  ...sufficient,
  id: 'sufficiency-2',
  sufficient: false,
  reasons: ['insufficient_evidence'],
};

test('valid requested to scoped transition is accepted', () => {
  assert.equal(
    evaluateOppTransition({ order: order('requested'), toStatus: 'scoped', occurredAt }).allowed,
    true
  );
});

test('OPP cannot jump directly from requested to ready', () => {
  assert.equal(
    evaluateOppTransition({
      order: order('requested'),
      toStatus: 'ready',
      occurredAt,
      sufficiency: sufficient,
      findings: [],
    }).allowed,
    false
  );
});

test('retrieval cannot assemble insufficient context', () => {
  assert.equal(
    evaluateOppTransition({
      order: order('retrieving'),
      toStatus: 'assembling',
      occurredAt,
      sufficiency: insufficient,
    }).allowed,
    false
  );
});

test('open Must finding blocks ready status', () => {
  const findings = [
    {
      id: 'finding-1',
      version: '1',
      oppId: 'opp-1',
      domain: 'curriculum_alignment',
      priority: 'must',
      status: 'open',
      code: 'SYN',
      message: 'Finding sintético',
      evidenceIds: [],
      createdAt: occurredAt,
    },
  ];

  assert.equal(
    evaluateOppTransition({
      order: order('validating'),
      toStatus: 'ready',
      occurredAt,
      sufficiency: sufficient,
      findings,
    }).allowed,
    false
  );
});
