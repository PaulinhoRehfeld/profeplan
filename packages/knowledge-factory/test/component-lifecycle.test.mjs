import assert from 'node:assert/strict';
import test from 'node:test';
import { evaluateComponentTransition } from '../src/index.ts';

const occurredAt = '2026-08-07T12:00:00.000Z';

function version(status) {
  return {
    id: 'component-version-1',
    version: '1',
    componentId: 'component-1',
    summary: 'Resumo sintético',
    keywords: ['teste'],
    sourceEvidenceIds: ['evidence-1'],
    curriculumNodeIds: ['node-1'],
    status,
  };
}

test('reviewed component may be approved or rejected', () => {
  assert.equal(
    evaluateComponentTransition({ version: version('in_review'), toStatus: 'approved', occurredAt })
      .allowed,
    true
  );
  assert.equal(
    evaluateComponentTransition({ version: version('in_review'), toStatus: 'rejected', occurredAt })
      .allowed,
    true
  );
});

test('rejected component cannot silently return to approved', () => {
  const decision = evaluateComponentTransition({
    version: version('rejected'),
    toStatus: 'approved',
    occurredAt,
  });
  assert.equal(decision.allowed, false);
});

test('suspended component must return through review before approval', () => {
  assert.equal(
    evaluateComponentTransition({ version: version('suspended'), toStatus: 'in_review', occurredAt })
      .allowed,
    true
  );
  assert.equal(
    evaluateComponentTransition({ version: version('suspended'), toStatus: 'approved', occurredAt })
      .allowed,
    false
  );
});
