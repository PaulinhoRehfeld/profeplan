import assert from 'node:assert/strict';
import test from 'node:test';
import {
  canTransitionIngestion,
  evaluateIngestionApproval,
  evaluateIngestionCommandIdempotency,
  evaluateIngestionRequest,
  evaluateIngestionTransition,
  targetStateForIngestionCommand,
} from '../src/index.ts';

const sourceVersion = { kind: 'source_version', id: 'source-version-synthetic-1' };
const receivedFile = { kind: 'received_file', id: 'received-file-synthetic-1' };
const run = { kind: 'processing_run', id: 'processing-run-synthetic-1' };
const instant = '2026-08-14T20:00:00.000Z';

function authorization(purpose, overrides = {}) {
  return {
    authorizationId: `authorization-${purpose}`,
    sourceVersion,
    purpose,
    evaluatedAt: instant,
    ...overrides,
  };
}

function request(overrides = {}) {
  return {
    requestId: 'ingestion-request-synthetic-1',
    sourceVersion,
    receivedFile,
    run,
    requestedBy: { actorId: 'actor-synthetic-1', role: 'curator' },
    requestedAt: instant,
    authorizationEvidence: [authorization('temporary_staging'), authorization('ingestion')],
    ...overrides,
  };
}

function review(decision = 'APPROVE_FOR_EXTRACTION') {
  return {
    reviewId: 'review-synthetic-1',
    reviewMode: 'human',
    reviewer: { actorId: 'reviewer-synthetic-1', role: 'legal_editorial_reviewer' },
    decision,
    decidedAt: instant,
    reason: 'Synthetic human decision.',
  };
}

function receipt(overrides = {}) {
  return {
    contractVersion: '1.0.0',
    commandId: 'command-synthetic-1',
    fingerprint: 'sha256:synthetic-command-1',
    correlationId: 'correlation-synthetic-1',
    operation: 'request_ingestion',
    run,
    aggregateVersion: '1',
    sequence: 1,
    eventIds: ['event-synthetic-1'],
    state: 'REQUESTED',
    outcome: 'applied',
    committedAt: instant,
    ...overrides,
  };
}

test('each ingestion command maps deterministically to one target state', () => {
  assert.equal(targetStateForIngestionCommand('request_ingestion'), 'REQUESTED');
  assert.equal(targetStateForIngestionCommand('begin_staging'), 'STAGING');
  assert.equal(targetStateForIngestionCommand('mark_staged'), 'STAGED');
  assert.equal(targetStateForIngestionCommand('begin_verification'), 'VERIFYING');
  assert.equal(targetStateForIngestionCommand('confirm_verified'), 'VERIFIED');
  assert.equal(targetStateForIngestionCommand('request_review'), 'PENDING_REVIEW');
  assert.equal(
    targetStateForIngestionCommand('approve_for_extraction'),
    'APPROVED_FOR_EXTRACTION'
  );
  assert.equal(targetStateForIngestionCommand('reject_ingestion'), 'REJECTED');
  assert.equal(targetStateForIngestionCommand('fail_ingestion'), 'FAILED');
  assert.equal(targetStateForIngestionCommand('cancel_ingestion'), 'CANCELLED');
});

test('normative ingestion happy path allows only sequential progress', () => {
  const transitions = [
    ['REQUESTED', 'STAGING'],
    ['STAGING', 'STAGED'],
    ['STAGED', 'VERIFYING'],
    ['VERIFYING', 'VERIFIED'],
    ['VERIFIED', 'PENDING_REVIEW'],
    ['PENDING_REVIEW', 'APPROVED_FOR_EXTRACTION'],
  ];

  for (const [from, to] of transitions) {
    assert.equal(canTransitionIngestion(from, to), true, `${from} -> ${to} should be allowed`);
  }

  assert.equal(canTransitionIngestion('REQUESTED', 'VERIFIED'), false);
  assert.equal(canTransitionIngestion('VERIFIED', 'APPROVED_FOR_EXTRACTION'), false);
});

test('exception exits are allowed from every non-terminal normative state', () => {
  const nonTerminalStates = [
    'REQUESTED',
    'STAGING',
    'STAGED',
    'VERIFYING',
    'VERIFIED',
    'PENDING_REVIEW',
  ];

  for (const state of nonTerminalStates) {
    assert.equal(canTransitionIngestion(state, 'REJECTED'), true);
    assert.equal(canTransitionIngestion(state, 'FAILED'), true);
    assert.equal(canTransitionIngestion(state, 'CANCELLED'), true);
  }
});

test('terminal ingestion states cannot transition further inside C.2', () => {
  const terminalStates = ['APPROVED_FOR_EXTRACTION', 'REJECTED', 'FAILED', 'CANCELLED'];

  for (const state of terminalStates) {
    assert.equal(canTransitionIngestion(state, 'REQUESTED'), false);
    assert.equal(canTransitionIngestion(state, 'STAGING'), false);
    assert.equal(canTransitionIngestion(state, 'PENDING_REVIEW'), false);
  }
});

test('expected ingestion state mismatch is rejected before transition evaluation', () => {
  const decision = evaluateIngestionTransition({
    currentState: 'STAGED',
    expectedState: 'STAGING',
    toState: 'VERIFYING',
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'INGESTION_EXPECTED_STATE_MISMATCH'));
});

test('invalid ingestion transition returns a provider-neutral domain reason', () => {
  const decision = evaluateIngestionTransition({
    currentState: 'REQUESTED',
    expectedState: 'REQUESTED',
    toState: 'VERIFIED',
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'INGESTION_INVALID_TRANSITION'));
});

test('same ingestion command ID and fingerprint is a stable replay', () => {
  const existingReceipt = receipt();
  const decision = evaluateIngestionCommandIdempotency({
    commandId: 'command-synthetic-1',
    fingerprint: 'sha256:synthetic-command-1',
    existing: {
      commandId: 'command-synthetic-1',
      fingerprint: 'sha256:synthetic-command-1',
      receipt: existingReceipt,
    },
  });

  assert.equal(decision.allowed, true);
  assert.equal(decision.value?.outcome, 'replay');
  assert.equal(decision.value?.receipt, existingReceipt);
});

test('same ingestion command ID with different fingerprint is a conflict', () => {
  const decision = evaluateIngestionCommandIdempotency({
    commandId: 'command-synthetic-1',
    fingerprint: 'sha256:different',
    existing: {
      commandId: 'command-synthetic-1',
      fingerprint: 'sha256:synthetic-command-1',
      receipt: receipt(),
    },
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'INGESTION_IDEMPOTENCY_CONFLICT'));
});

test('ingestion request requires temporary staging authorization independently', () => {
  const decision = evaluateIngestionRequest(
    request({ authorizationEvidence: [authorization('ingestion')] })
  );

  assert.equal(decision.allowed, false);
  assert.ok(
    decision.reasons.some(
      (item) => item.code === 'INGESTION_TEMPORARY_STAGING_AUTHORIZATION_REQUIRED'
    )
  );
});

test('ingestion request requires ingestion authorization independently', () => {
  const decision = evaluateIngestionRequest(
    request({ authorizationEvidence: [authorization('temporary_staging')] })
  );

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'INGESTION_AUTHORIZATION_REQUIRED'));
});

test('extraction authorization does not substitute ingestion authorization', () => {
  const decision = evaluateIngestionRequest(
    request({
      authorizationEvidence: [authorization('temporary_staging'), authorization('extraction')],
    })
  );

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'INGESTION_AUTHORIZATION_REQUIRED'));
});

test('approval for extraction requires explicit human approval', () => {
  const decision = evaluateIngestionApproval({
    sourceVersion,
    authorizationEvidence: [authorization('extraction')],
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'INGESTION_HUMAN_REVIEW_REQUIRED'));
});

test('human rejection cannot produce approval for extraction', () => {
  const decision = evaluateIngestionApproval({
    sourceVersion,
    review: review('REJECT'),
    authorizationEvidence: [authorization('extraction')],
  });

  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === 'INGESTION_HUMAN_REVIEW_NOT_APPROVED'));
});

test('ingestion authorization does not substitute extraction authorization', () => {
  const decision = evaluateIngestionApproval({
    sourceVersion,
    review: review(),
    authorizationEvidence: [authorization('ingestion')],
  });

  assert.equal(decision.allowed, false);
  assert.ok(
    decision.reasons.some((item) => item.code === 'INGESTION_EXTRACTION_AUTHORIZATION_REQUIRED')
  );
});

test('human approval plus independent extraction authorization satisfies the C.2.1 approval invariant', () => {
  const decision = evaluateIngestionApproval({
    sourceVersion,
    review: review(),
    authorizationEvidence: [authorization('extraction')],
  });

  assert.equal(decision.allowed, true);
});
