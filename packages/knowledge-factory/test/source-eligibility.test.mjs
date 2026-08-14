import assert from 'node:assert/strict';
import test from 'node:test';
import { evaluateSourceEligibility } from '../src/index.ts';

const occurredAt = '2026-08-07T12:00:00.000Z';

function source(overrides = {}) {
  return {
    id: 'source-1',
    version: '1',
    title: 'Fonte sintética',
    sourceType: 'wrtech_owned',
    status: 'approved',
    licenseCategory: 'owned',
    allowedUses: ['retrieval', 'generation', 'internal_review'],
    createdAt: occurredAt,
    updatedAt: occurredAt,
    ...overrides,
  };
}

test('approved owned source is eligible for generation', () => {
  const decision = evaluateSourceEligibility({ source: source(), use: 'generation', occurredAt });
  assert.equal(decision.allowed, true);
});

test('blocked source is ineligible', () => {
  const decision = evaluateSourceEligibility({
    source: source({ status: 'blocked' }),
    use: 'generation',
    occurredAt,
  });
  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_NOT_APPROVED'));
});

test('restricted source cannot be used for generation', () => {
  const decision = evaluateSourceEligibility({
    source: source({ licenseCategory: 'restricted' }),
    use: 'generation',
    occurredAt,
  });
  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_LICENSE_INCOMPATIBLE'));
});
