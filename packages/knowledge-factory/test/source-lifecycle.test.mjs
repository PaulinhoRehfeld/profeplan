import assert from 'node:assert/strict';
import test from 'node:test';
import {
  evaluateGrantSourceAuthorization,
  evaluateSourceAuthorizationTransition,
  evaluateSourceCommandIdempotency,
  evaluateSourceOptimisticConcurrency,
  evaluateSourceRegistrationTransition,
} from '../src/index.ts';

const occurredAt = '2026-08-12T12:00:00.000Z';

function actor(role = 'legal_editorial_reviewer') {
  return { actorId: 'actor-1', role };
}

function basis() {
  return { id: 'basis-1', kind: 'publisher_contract' };
}

function grantCommand(overrides = {}) {
  return {
    commandId: 'command-grant-1',
    commandType: 'grant_authorization',
    fingerprint: 'sha256:grant-1',
    actor: actor(),
    authorizationId: 'authorization-1',
    scope: {
      subject: { kind: 'source_version', id: 'source-version-1' },
      purpose: 'generation',
    },
    basis: basis(),
    occurredAt,
    effectiveAt: occurredAt,
    effectiveFrom: '2026-08-12T00:00:00.000Z',
    correlationId: 'correlation-1',
    reason: 'Approved contract.',
    ...overrides,
  };
}

function receipt(overrides = {}) {
  return {
    dimension: 'authorization',
    commandId: 'command-grant-1',
    fingerprint: 'sha256:grant-1',
    operation: 'grant_authorization',
    aggregateId: 'authorization-1',
    aggregateVersion: '1',
    sequence: 1,
    eventIds: ['event-1'],
    state: 'GRANTED',
    replayed: false,
    committedAt: occurredAt,
    ...overrides,
  };
}

test('BLOCKED registration cannot transition directly to VALIDATED', () => {
  const decision = evaluateSourceRegistrationTransition({
    currentState: 'BLOCKED',
    toState: 'VALIDATED',
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_INVALID_REGISTRATION_TRANSITION'));
});

test('REVOKED authorization cannot return to GRANTED on the same grant', () => {
  const decision = evaluateSourceAuthorizationTransition({
    currentState: 'REVOKED',
    toState: 'GRANTED',
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_INVALID_AUTHORIZATION_TRANSITION'));
});

test('EXPIRED authorization cannot return to GRANTED on the same grant', () => {
  const decision = evaluateSourceAuthorizationTransition({
    currentState: 'EXPIRED',
    toState: 'GRANTED',
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_INVALID_AUTHORIZATION_TRANSITION'));
});

test('expected state mismatch is a conflict before transition evaluation', () => {
  const decision = evaluateSourceRegistrationTransition({
    currentState: 'PENDING_VALIDATION',
    expectedState: 'REGISTERED',
    toState: 'VALIDATED',
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_EXPECTED_STATE_MISMATCH'));
});

test('same command ID and fingerprint is a safe replay', () => {
  const existingReceipt = receipt();
  const decision = evaluateSourceCommandIdempotency({
    commandId: 'command-grant-1',
    fingerprint: 'sha256:grant-1',
    existing: {
      commandId: 'command-grant-1',
      fingerprint: 'sha256:grant-1',
      receipt: existingReceipt,
    },
  });

  assert.equal(decision.allowed, true);
  assert.equal(decision.value?.outcome, 'replay');
  assert.equal(decision.value?.receipt, existingReceipt);
});

test('same command ID with a different fingerprint is a conflict', () => {
  const decision = evaluateSourceCommandIdempotency({
    commandId: 'command-grant-1',
    fingerprint: 'sha256:different',
    existing: {
      commandId: 'command-grant-1',
      fingerprint: 'sha256:grant-1',
      receipt: receipt(),
    },
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_IDEMPOTENCY_CONFLICT'));
});

test('expected version mismatch is rejected provider-neutrally', () => {
  const decision = evaluateSourceOptimisticConcurrency({
    expectedVersion: '1',
    currentVersion: '2',
    expectedSequence: 4,
    currentSequence: 4,
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_EXPECTED_VERSION_MISMATCH'));
});

test('expected sequence mismatch is rejected provider-neutrally', () => {
  const decision = evaluateSourceOptimisticConcurrency({
    currentVersion: '2',
    expectedSequence: 3,
    currentSequence: 4,
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_EXPECTED_SEQUENCE_MISMATCH'));
});

test('grant requires a valid effective window', () => {
  const decision = evaluateGrantSourceAuthorization({
    registrationState: 'VALIDATED',
    command: grantCommand({
      effectiveFrom: '2026-08-13T00:00:00.000Z',
      effectiveUntil: '2026-08-12T00:00:00.000Z',
    }),
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_INVALID_EFFECTIVE_WINDOW'));
});

test('grant requires an identifiable authorization basis', () => {
  const decision = evaluateGrantSourceAuthorization({
    registrationState: 'VALIDATED',
    command: grantCommand({ basis: undefined }),
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_AUTHORIZATION_BASIS_REQUIRED'));
});

test('grant requires an identified competent actor', () => {
  const missingActor = evaluateGrantSourceAuthorization({
    registrationState: 'VALIDATED',
    command: grantCommand({ actor: undefined }),
  });
  const wrongRole = evaluateGrantSourceAuthorization({
    registrationState: 'VALIDATED',
    command: grantCommand({ actor: actor('technical_admin') }),
  });

  assert.equal(missingActor.allowed, false);
  assert.ok(missingActor.reasons.some((item) => item.code === 'SOURCE_ACTOR_REQUIRED'));
  assert.equal(wrongRole.allowed, false);
  assert.ok(wrongRole.reasons.some((item) => item.code === 'SOURCE_ACTOR_ROLE_FORBIDDEN'));
});

test('VALIDATED registration is necessary but does not itself constitute authorization', () => {
  const decision = evaluateGrantSourceAuthorization({
    registrationState: 'PENDING_VALIDATION',
    command: grantCommand(),
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_NOT_VALIDATED'));
});
