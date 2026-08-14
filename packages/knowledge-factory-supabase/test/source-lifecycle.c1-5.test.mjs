import assert from 'node:assert/strict';
import test from 'node:test';
import { evaluateGovernedSourceEligibility } from '@profeplan/knowledge-factory';
import { SupabaseClient } from '@supabase/supabase-js';
import {
  SupabaseSourceLifecycleCommandRepository,
  SupabaseSourceLifecycleReadRepository,
} from '../src/index.ts';

const SUPABASE_URL = process.env.KF_SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.KF_SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  throw new Error('Disposable Supabase credentials were not provided to the C.1.5 integration test');
}

const client = new SupabaseClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
  auth: { persistSession: false, autoRefreshToken: false, detectSessionInUrl: false },
});

const commandRepository = new SupabaseSourceLifecycleCommandRepository({
  client,
  correlationId: '90200000-0000-4000-8000-000000000001',
});
const readRepository = new SupabaseSourceLifecycleReadRepository({
  client,
  correlationId: '90200000-0000-4000-8000-000000000002',
});

const CURATOR_ID = '89110000-0000-4000-8000-000000000001';
const REVIEWER_ID = '89110000-0000-4000-8000-000000000002';
const EXPIRING_SUBJECT_ID = '90300000-0000-4000-8000-000000000001';
const SUPERSESSION_SUBJECT_ID = '90300000-0000-4000-8000-000000000002';
const EXPIRING_AUTHORIZATION_ID = '90400000-0000-4000-8000-000000000001';
const PREDECESSOR_AUTHORIZATION_ID = '90400000-0000-4000-8000-000000000002';
const SUCCESSOR_AUTHORIZATION_ID = '90400000-0000-4000-8000-000000000003';
const BASIS_ID = '90500000-0000-4000-8000-000000000001';
const SUCCESSOR_BASIS_ID = '90500000-0000-4000-8000-000000000002';
const CORRELATION_ID = '90600000-0000-4000-8000-000000000001';

let nextCommand = 1;

function commandId() {
  const value = `90700000-0000-4000-8000-${String(nextCommand).padStart(12, '0')}`;
  nextCommand += 1;
  return value;
}

function envelope(actorId, role, instant, reason) {
  return {
    commandId: commandId(),
    actor: { actorId, role },
    occurredAt: instant,
    effectiveAt: instant,
    correlationId: CORRELATION_ID,
    reason,
  };
}

async function withFingerprint(command) {
  const { commandId: _commandId, fingerprint: _fingerprint, ...payload } = command;
  const { data, error } = await client.rpc('kf_test_c1_4_fingerprint', {
    p_operation: command.commandType,
    p_payload: payload,
  });

  assert.equal(error, null);
  assert.equal(typeof data, 'string');
  assert.match(data, /^[0-9a-f]{64}$/);
  return { ...command, fingerprint: data };
}

function basis(id = BASIS_ID, kind = 'publisher_contract') {
  return {
    id,
    kind,
    referenceDigest: `sha256:synthetic-${id}`,
  };
}

function scope(subjectId, purpose, restrictions) {
  return {
    subject: { id: subjectId, kind: 'source_version' },
    purpose,
    ...(restrictions === undefined ? {} : { restrictions }),
  };
}

async function registerValidated(subjectId, startHour) {
  const register = await withFingerprint({
    ...envelope(
      CURATOR_ID,
      'curator',
      `2026-08-14T${startHour}:00:00Z`,
      `synthetic C.1.5 register ${subjectId}`
    ),
    commandType: 'register_identity',
    subject: { id: subjectId, kind: 'source_version' },
  });
  const registered = await commandRepository.registerIdentity(register);

  const request = await withFingerprint({
    ...envelope(
      CURATOR_ID,
      'curator',
      `2026-08-14T${startHour}:01:00Z`,
      `synthetic C.1.5 request validation ${subjectId}`
    ),
    commandType: 'request_validation',
    subject: { id: subjectId, kind: 'source_version' },
    expectedState: 'REGISTERED',
    expectedVersion: registered.aggregateVersion,
    expectedSequence: registered.sequence,
  });
  const requested = await commandRepository.requestValidation(request);

  const confirm = await withFingerprint({
    ...envelope(
      CURATOR_ID,
      'curator',
      `2026-08-14T${startHour}:02:00Z`,
      `synthetic C.1.5 confirm validation ${subjectId}`
    ),
    commandType: 'confirm_validation',
    subject: { id: subjectId, kind: 'source_version' },
    expectedState: 'PENDING_VALIDATION',
    expectedVersion: requested.aggregateVersion,
    expectedSequence: requested.sequence,
  });
  const validated = await commandRepository.confirmValidation(confirm);

  assert.equal(validated.state, 'VALIDATED');
  return validated;
}

function assertProviderNeutralEvent(event) {
  for (const providerField of [
    'aggregate_id',
    'aggregate_version',
    'effective_at',
    'event_type',
    'command_id',
  ]) {
    assert.equal(providerField in event, false, `provider field leaked: ${providerField}`);
  }
}

test('C.1.5 composes persisted history with provider-neutral temporal eligibility', async () => {
  await registerValidated(EXPIRING_SUBJECT_ID, '17');

  const grant = await withFingerprint({
    ...envelope(
      REVIEWER_ID,
      'legal_editorial_reviewer',
      '2026-08-14T17:03:00Z',
      'synthetic C.1.5 time-bounded generation grant'
    ),
    commandType: 'grant_authorization',
    authorizationId: EXPIRING_AUTHORIZATION_ID,
    scope: scope(EXPIRING_SUBJECT_ID, 'generation', ['synthetic_test_only']),
    basis: basis(),
    effectiveFrom: '2026-08-14T17:03:00Z',
    effectiveUntil: '2026-08-14T17:05:00Z',
  });
  const granted = await commandRepository.grantAuthorization(grant);
  assert.equal(granted.state, 'GRANTED');

  const registrationEvents = await readRepository.listRegistrationHistory(EXPIRING_SUBJECT_ID);
  const authorizationEvents = await readRepository.listAuthorizationHistory(EXPIRING_SUBJECT_ID);

  assert.deepEqual(
    registrationEvents.map((event) => event.toState),
    ['REGISTERED', 'PENDING_VALIDATION', 'VALIDATED']
  );
  assert.equal(authorizationEvents.length, 1);
  assertProviderNeutralEvent(registrationEvents[0]);
  assertProviderNeutralEvent(authorizationEvents[0]);

  const duringWindow = evaluateGovernedSourceEligibility({
    sourceVersionId: EXPIRING_SUBJECT_ID,
    purpose: 'generation',
    instant: '2026-08-14T17:04:00Z',
    registrationEvents,
    authorizationEvents,
  });
  assert.deepEqual(duringWindow, {
    status: 'ELIGIBLE',
    sourceVersionId: EXPIRING_SUBJECT_ID,
    purpose: 'generation',
    instant: '2026-08-14T17:04:00Z',
    authorizationId: EXPIRING_AUTHORIZATION_ID,
  });

  const afterWindow = evaluateGovernedSourceEligibility({
    sourceVersionId: EXPIRING_SUBJECT_ID,
    purpose: 'generation',
    instant: '2026-08-14T17:06:00Z',
    registrationEvents,
    authorizationEvents,
  });
  assert.equal(afterWindow.status, 'INELIGIBLE');
  assert.ok(
    afterWindow.reasons.some((item) => item.code === 'SOURCE_AUTHORIZATION_EXPIRED')
  );
});

test('C.1.5 proves supersession is atomic, purpose-scoped and non-transferring', async () => {
  await registerValidated(SUPERSESSION_SUBJECT_ID, '18');

  const predecessorScope = scope(SUPERSESSION_SUBJECT_ID, 'retrieval', ['internal_only']);
  const predecessorBasis = basis();

  const grant = await withFingerprint({
    ...envelope(
      REVIEWER_ID,
      'legal_editorial_reviewer',
      '2026-08-14T18:03:00Z',
      'synthetic C.1.5 predecessor retrieval grant'
    ),
    commandType: 'grant_authorization',
    authorizationId: PREDECESSOR_AUTHORIZATION_ID,
    scope: predecessorScope,
    basis: predecessorBasis,
    effectiveFrom: '2026-08-14T18:03:00Z',
  });
  const granted = await commandRepository.grantAuthorization(grant);

  const suspend = await withFingerprint({
    ...envelope(
      REVIEWER_ID,
      'legal_editorial_reviewer',
      '2026-08-14T18:04:00Z',
      'synthetic C.1.5 suspend predecessor before purpose block'
    ),
    commandType: 'suspend_authorization',
    authorizationId: PREDECESSOR_AUTHORIZATION_ID,
    scope: predecessorScope,
    basis: predecessorBasis,
    expectedState: 'GRANTED',
    expectedVersion: granted.aggregateVersion,
    expectedSequence: granted.sequence,
  });
  const suspended = await commandRepository.suspendAuthorization(suspend);
  assert.equal(suspended.state, 'SUSPENDED');

  const block = await withFingerprint({
    ...envelope(
      REVIEWER_ID,
      'legal_editorial_reviewer',
      '2026-08-14T18:05:00Z',
      'synthetic C.1.5 block predecessor purpose'
    ),
    commandType: 'block_purpose',
    authorizationId: PREDECESSOR_AUTHORIZATION_ID,
    scope: predecessorScope,
    basis: predecessorBasis,
    expectedState: 'SUSPENDED',
    expectedVersion: suspended.aggregateVersion,
    expectedSequence: suspended.sequence,
  });
  const blocked = await commandRepository.blockPurpose(block);
  assert.equal(blocked.state, 'BLOCKED');

  const supersede = await withFingerprint({
    ...envelope(
      REVIEWER_ID,
      'legal_editorial_reviewer',
      '2026-08-14T18:06:00Z',
      'synthetic C.1.5 supersede retrieval grant with generation grant'
    ),
    commandType: 'supersede_authorization',
    authorizationId: PREDECESSOR_AUTHORIZATION_ID,
    successorAuthorizationId: SUCCESSOR_AUTHORIZATION_ID,
    scope: scope(SUPERSESSION_SUBJECT_ID, 'generation', ['teacher_output_only']),
    basis: basis(SUCCESSOR_BASIS_ID, 'open_license'),
    effectiveFrom: '2026-08-14T18:06:00Z',
    expectedState: 'BLOCKED',
    expectedVersion: blocked.aggregateVersion,
    expectedSequence: blocked.sequence,
  });
  const superseded = await commandRepository.supersedeAuthorization(supersede);
  assert.equal(superseded.state, 'SUPERSEDED');
  assert.equal(superseded.eventIds.length, 3);

  const registrationEvents = await readRepository.listRegistrationHistory(SUPERSESSION_SUBJECT_ID);
  const authorizationEvents = await readRepository.listAuthorizationHistory(
    SUPERSESSION_SUBJECT_ID
  );
  const impactEvents = await readRepository.listImpactHistory(SUPERSESSION_SUBJECT_ID);

  assert.ok(authorizationEvents.length >= 5);
  assert.ok(
    authorizationEvents.some(
      (event) =>
        event.authorizationId === PREDECESSOR_AUTHORIZATION_ID &&
        event.toState === 'SUPERSEDED' &&
        event.supersededByAuthorizationId === SUCCESSOR_AUTHORIZATION_ID
    )
  );
  assert.ok(
    authorizationEvents.some(
      (event) =>
        event.authorizationId === SUCCESSOR_AUTHORIZATION_ID &&
        event.toState === 'GRANTED' &&
        event.scope.purpose === 'generation'
    )
  );
  assert.ok(impactEvents.length >= 2);
  assertProviderNeutralEvent(authorizationEvents.at(-1));
  assertProviderNeutralEvent(impactEvents.at(-1));

  const oldPurpose = evaluateGovernedSourceEligibility({
    sourceVersionId: SUPERSESSION_SUBJECT_ID,
    purpose: 'retrieval',
    instant: '2026-08-14T18:07:00Z',
    registrationEvents,
    authorizationEvents,
  });
  assert.equal(oldPurpose.status, 'INELIGIBLE');
  assert.ok(
    oldPurpose.reasons.some((item) => item.code === 'SOURCE_AUTHORIZATION_SUPERSEDED')
  );

  const successorPurpose = evaluateGovernedSourceEligibility({
    sourceVersionId: SUPERSESSION_SUBJECT_ID,
    purpose: 'generation',
    instant: '2026-08-14T18:07:00Z',
    registrationEvents,
    authorizationEvents,
  });
  assert.deepEqual(successorPurpose, {
    status: 'ELIGIBLE',
    sourceVersionId: SUPERSESSION_SUBJECT_ID,
    purpose: 'generation',
    instant: '2026-08-14T18:07:00Z',
    authorizationId: SUCCESSOR_AUTHORIZATION_ID,
  });
});
