import assert from 'node:assert/strict';
import test from 'node:test';
import { evaluateGovernedSourceEligibility } from '../src/index.ts';

const sourceVersionId = 'source-version-1';
const basis = { id: 'basis-1', kind: 'publisher_contract' };
const legalActor = { actorId: 'legal-1', role: 'legal_editorial_reviewer' };
const curatorActor = { actorId: 'curator-1', role: 'curator' };

function registrationEvent({
  eventId,
  toState,
  effectiveAt,
  sequence,
  subjectId = sourceVersionId,
  fromState,
}) {
  const eventTypeByState = {
    REGISTERED: 'source_registered',
    PENDING_VALIDATION: 'source_validation_requested',
    VALIDATED: 'source_validated',
    BLOCKED: 'source_blocked',
    REPLACED: 'source_replaced',
    ARCHIVED: 'source_archived',
  };

  return {
    eventId,
    eventType: eventTypeByState[toState],
    aggregateId: subjectId,
    aggregateVersion: '1',
    sequence,
    actor: curatorActor,
    reason: `registration ${toState}`,
    occurredAt: effectiveAt,
    effectiveAt,
    correlationId: 'correlation-registration',
    commandId: `command-${eventId}`,
    subject: { kind: 'source_version', id: subjectId },
    fromState,
    toState,
  };
}

function authorizationEvent({
  eventId,
  authorizationId = 'authorization-1',
  subjectId = sourceVersionId,
  purpose = 'generation',
  toState = 'GRANTED',
  effectiveAt,
  effectiveFrom = '2026-08-01T00:00:00.000Z',
  effectiveUntil,
  sequence,
  fromState,
}) {
  const eventTypeByState = {
    PENDING_REVIEW: 'authorization_superseded',
    GRANTED: fromState === 'SUSPENDED' ? 'authorization_resumed' : 'authorization_granted',
    SUSPENDED: 'authorization_suspended',
    REVOKED: 'authorization_revoked',
    EXPIRED: 'authorization_expired',
    BLOCKED: 'authorization_blocked',
    SUPERSEDED: 'authorization_superseded',
  };

  return {
    eventId,
    eventType: eventTypeByState[toState],
    aggregateId: authorizationId,
    aggregateVersion: '1',
    sequence,
    actor: legalActor,
    reason: `authorization ${toState}`,
    occurredAt: effectiveAt,
    effectiveAt,
    correlationId: 'correlation-authorization',
    commandId: `command-${eventId}`,
    authorizationId,
    scope: {
      subject: { kind: 'source_version', id: subjectId },
      purpose,
    },
    basis,
    fromState,
    toState,
    effectiveFrom,
    effectiveUntil,
  };
}

const validatedTimeline = [
  registrationEvent({
    eventId: 'reg-1',
    toState: 'REGISTERED',
    effectiveAt: '2026-08-01T08:00:00.000Z',
    sequence: 1,
  }),
  registrationEvent({
    eventId: 'reg-2',
    fromState: 'REGISTERED',
    toState: 'PENDING_VALIDATION',
    effectiveAt: '2026-08-01T09:00:00.000Z',
    sequence: 2,
  }),
  registrationEvent({
    eventId: 'reg-3',
    fromState: 'PENDING_VALIDATION',
    toState: 'VALIDATED',
    effectiveAt: '2026-08-01T10:00:00.000Z',
    sequence: 3,
  }),
];

function evaluate(overrides = {}) {
  return evaluateGovernedSourceEligibility({
    sourceVersionId,
    purpose: 'generation',
    instant: '2026-08-10T12:00:00.000Z',
    registrationEvents: validatedTimeline,
    authorizationEvents: [],
    ...overrides,
  });
}

test('VALIDATED does not imply GRANTED', () => {
  const decision = evaluate();

  assert.equal(decision.status, 'INELIGIBLE');
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_PURPOSE_NOT_AUTHORIZED'));
});

test('a different authorized purpose does not authorize generation', () => {
  const decision = evaluate({
    authorizationEvents: [
      authorizationEvent({
        eventId: 'auth-retrieval',
        purpose: 'retrieval',
        effectiveAt: '2026-08-02T00:00:00.000Z',
        sequence: 1,
      }),
    ],
  });

  assert.equal(decision.status, 'INELIGIBLE');
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_PURPOSE_NOT_AUTHORIZED'));
});

test('expired authorization is ineligible even without a maintenance event', () => {
  const decision = evaluate({
    authorizationEvents: [
      authorizationEvent({
        eventId: 'auth-grant',
        effectiveAt: '2026-08-02T00:00:00.000Z',
        effectiveUntil: '2026-08-05T00:00:00.000Z',
        sequence: 1,
      }),
    ],
  });

  assert.equal(decision.status, 'INELIGIBLE');
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_AUTHORIZATION_EXPIRED'));
});

test('malformed authorization window fails closed', () => {
  const decision = evaluate({
    authorizationEvents: [
      authorizationEvent({
        eventId: 'auth-malformed-window',
        effectiveAt: '2026-08-02T00:00:00.000Z',
        effectiveUntil: 'not-a-date',
        sequence: 1,
      }),
    ],
  });

  assert.equal(decision.status, 'INELIGIBLE');
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_INVALID_EFFECTIVE_WINDOW'));
});

test('blocked source registration is ineligible despite an old grant', () => {
  const decision = evaluate({
    registrationEvents: [
      ...validatedTimeline,
      registrationEvent({
        eventId: 'reg-block',
        fromState: 'VALIDATED',
        toState: 'BLOCKED',
        effectiveAt: '2026-08-08T00:00:00.000Z',
        sequence: 4,
      }),
    ],
    authorizationEvents: [
      authorizationEvent({
        eventId: 'auth-grant',
        effectiveAt: '2026-08-02T00:00:00.000Z',
        sequence: 1,
      }),
    ],
  });

  assert.equal(decision.status, 'INELIGIBLE');
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_REGISTRATION_BLOCKED'));
});

test('suspended authorization is ineligible', () => {
  const decision = evaluate({
    authorizationEvents: [
      authorizationEvent({
        eventId: 'auth-grant',
        effectiveAt: '2026-08-02T00:00:00.000Z',
        sequence: 1,
      }),
      authorizationEvent({
        eventId: 'auth-suspend',
        fromState: 'GRANTED',
        toState: 'SUSPENDED',
        effectiveAt: '2026-08-08T00:00:00.000Z',
        sequence: 2,
      }),
    ],
  });

  assert.equal(decision.status, 'INELIGIBLE');
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_AUTHORIZATION_SUSPENDED'));
});

test('revocation changes eligibility only from its effective instant forward', () => {
  const authorizationEvents = [
    authorizationEvent({
      eventId: 'auth-grant',
      effectiveAt: '2026-08-02T00:00:00.000Z',
      sequence: 1,
    }),
    authorizationEvent({
      eventId: 'auth-revoke',
      fromState: 'GRANTED',
      toState: 'REVOKED',
      effectiveAt: '2026-08-08T12:00:00.000Z',
      sequence: 2,
    }),
  ];

  const before = evaluate({
    instant: '2026-08-08T11:59:59.000Z',
    authorizationEvents,
  });
  const after = evaluate({
    instant: '2026-08-08T12:00:00.000Z',
    authorizationEvents,
  });

  assert.equal(before.status, 'ELIGIBLE');
  assert.equal(after.status, 'INELIGIBLE');
  assert.ok(after.reasons.some((item) => item.code === 'SOURCE_AUTHORIZATION_REVOKED'));
});

test('future authorization does not apply before effectiveFrom', () => {
  const decision = evaluate({
    authorizationEvents: [
      authorizationEvent({
        eventId: 'auth-future',
        effectiveAt: '2026-08-02T00:00:00.000Z',
        effectiveFrom: '2026-08-15T00:00:00.000Z',
        sequence: 1,
      }),
    ],
  });

  assert.equal(decision.status, 'INELIGIBLE');
  assert.ok(
    decision.reasons.some((item) => item.code === 'SOURCE_AUTHORIZATION_NOT_YET_EFFECTIVE')
  );
});

test('source replacement does not transfer authorization to the successor version', () => {
  const successorId = 'source-version-2';
  const successorRegistration = validatedTimeline.map((event) => ({
    ...event,
    aggregateId: successorId,
    subject: { kind: 'source_version', id: successorId },
    eventId: `${event.eventId}-successor`,
  }));

  const decision = evaluateGovernedSourceEligibility({
    sourceVersionId: successorId,
    purpose: 'generation',
    instant: '2026-08-10T12:00:00.000Z',
    registrationEvents: successorRegistration,
    authorizationEvents: [
      authorizationEvent({
        eventId: 'auth-old-version',
        subjectId: sourceVersionId,
        effectiveAt: '2026-08-02T00:00:00.000Z',
        sequence: 1,
      }),
    ],
  });

  assert.equal(decision.status, 'INELIGIBLE');
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_PURPOSE_NOT_AUTHORIZED'));
});

test('historical query is deterministic regardless of event input order', () => {
  const authorizationEvents = [
    authorizationEvent({
      eventId: 'auth-revoke-future',
      fromState: 'GRANTED',
      toState: 'REVOKED',
      effectiveAt: '2026-08-20T00:00:00.000Z',
      sequence: 2,
    }),
    authorizationEvent({
      eventId: 'auth-grant',
      effectiveAt: '2026-08-02T00:00:00.000Z',
      sequence: 1,
    }),
  ];
  const shuffledRegistration = [validatedTimeline[2], validatedTimeline[0], validatedTimeline[1]];

  const first = evaluate({
    instant: '2026-08-10T12:00:00.000Z',
    registrationEvents: shuffledRegistration,
    authorizationEvents,
  });
  const second = evaluate({
    instant: '2026-08-10T12:00:00.000Z',
    registrationEvents: [...shuffledRegistration].reverse(),
    authorizationEvents: [...authorizationEvents].reverse(),
  });

  assert.deepEqual(first, second);
  assert.equal(first.status, 'ELIGIBLE');
});

test('multiple active grants choose a deterministic authorization independent of input order', () => {
  const authorizationA = authorizationEvent({
    eventId: 'auth-a',
    authorizationId: 'authorization-a',
    effectiveAt: '2026-08-02T00:00:00.000Z',
    sequence: 1,
  });
  const authorizationB = authorizationEvent({
    eventId: 'auth-b',
    authorizationId: 'authorization-b',
    effectiveAt: '2026-08-02T00:00:00.000Z',
    sequence: 1,
  });

  const first = evaluate({ authorizationEvents: [authorizationB, authorizationA] });
  const second = evaluate({ authorizationEvents: [authorizationA, authorizationB] });

  assert.deepEqual(first, second);
  assert.equal(first.status, 'ELIGIBLE');
  assert.equal(first.authorizationId, 'authorization-a');
});

test('future registration block does not contaminate a historical query', () => {
  const decision = evaluate({
    registrationEvents: [
      registrationEvent({
        eventId: 'reg-future-block',
        fromState: 'VALIDATED',
        toState: 'BLOCKED',
        effectiveAt: '2026-08-20T00:00:00.000Z',
        sequence: 4,
      }),
      ...validatedTimeline,
    ],
    authorizationEvents: [
      authorizationEvent({
        eventId: 'auth-grant',
        effectiveAt: '2026-08-02T00:00:00.000Z',
        sequence: 1,
      }),
    ],
  });

  assert.equal(decision.status, 'ELIGIBLE');
});

test('absence of governance information never becomes implicit authorization', () => {
  const decision = evaluateGovernedSourceEligibility({
    sourceVersionId,
    purpose: 'generation',
    instant: '2026-08-10T12:00:00.000Z',
    registrationEvents: [],
    authorizationEvents: [],
  });

  assert.equal(decision.status, 'INELIGIBLE');
  assert.ok(decision.reasons.some((item) => item.code === 'SOURCE_NOT_VALIDATED'));
});

test('same explicit instant and history always produce the same decision', () => {
  const input = {
    authorizationEvents: [
      authorizationEvent({
        eventId: 'auth-grant',
        effectiveAt: '2026-08-02T00:00:00.000Z',
        sequence: 1,
      }),
    ],
  };

  assert.deepEqual(evaluate(input), evaluate(input));
});
