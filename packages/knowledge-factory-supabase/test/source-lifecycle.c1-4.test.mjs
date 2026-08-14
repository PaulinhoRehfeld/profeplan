import assert from 'node:assert/strict';
import test from 'node:test';
import { SupabaseClient } from '@supabase/supabase-js';
import {
  SupabaseSourceLifecycleCommandRepository,
  SupabaseSourceLifecycleReadRepository,
} from '../src/index.ts';

const SUPABASE_URL = process.env.KF_SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.KF_SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  throw new Error('Disposable Supabase credentials were not provided to the C.1.4 integration test');
}

const client = new SupabaseClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
  auth: { persistSession: false, autoRefreshToken: false, detectSessionInUrl: false },
});

const commandRepository = new SupabaseSourceLifecycleCommandRepository({
  client,
  correlationId: '89200000-0000-4000-8000-000000000001',
});
const readRepository = new SupabaseSourceLifecycleReadRepository({
  client,
  correlationId: '89200000-0000-4000-8000-000000000002',
});

const CURATOR_ID = '89110000-0000-4000-8000-000000000001';
const REVIEWER_ID = '89110000-0000-4000-8000-000000000002';
const UNASSIGNED_CURATOR_ID = '89110000-0000-4000-8000-000000009999';
const SUBJECT_ID = '89300000-0000-4000-8000-000000000001';
const UNASSIGNED_SUBJECT_ID = '89300000-0000-4000-8000-000000000999';
const AUTHORIZATION_ID = '89400000-0000-4000-8000-000000000001';
const BASIS_ID = '89500000-0000-4000-8000-000000000001';
const CORRELATION_ID = '89600000-0000-4000-8000-000000000001';

function commandId(index) {
  return `89700000-0000-4000-8000-${String(index).padStart(12, '0')}`;
}

function envelope(index, actorId, role, instant) {
  return {
    commandId: commandId(index),
    actor: { actorId, role },
    occurredAt: instant,
    effectiveAt: instant,
    correlationId: CORRELATION_ID,
    reason: `synthetic C.1.4 integration decision ${index}`,
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

function scope() {
  return {
    subject: { id: SUBJECT_ID, kind: 'source_version' },
    purpose: 'retrieval',
  };
}

function basis() {
  return {
    id: BASIS_ID,
    kind: 'wrtech_ownership',
    referenceDigest: 'sha256:synthetic-c1-4-integration',
  };
}

test('C.1.4 adapters execute governed commands and reconstruct historical reads end to end', async () => {
  const register = await withFingerprint({
    ...envelope(1, CURATOR_ID, 'curator', '2026-08-14T16:00:00Z'),
    commandType: 'register_identity',
    subject: { id: SUBJECT_ID, kind: 'source_version' },
  });
  const registered = await commandRepository.registerIdentity(register);
  assert.equal(registered.state, 'REGISTERED');
  assert.equal(registered.sequence, 1);
  assert.equal(registered.replayed, false);

  const replayed = await commandRepository.registerIdentity(register);
  assert.equal(replayed.replayed, true);
  assert.equal(replayed.aggregateVersion, registered.aggregateVersion);
  assert.equal(replayed.committedAt, registered.committedAt);

  const conflictingRegister = await withFingerprint({
    ...register,
    fingerprint: undefined,
    reason: 'same command id with intentionally different semantic payload',
  });
  await assert.rejects(commandRepository.registerIdentity(conflictingRegister), {
    name: 'KnowledgeFactoryPersistenceError',
    code: 'CONFLICT',
  });

  const request = await withFingerprint({
    ...envelope(2, CURATOR_ID, 'curator', '2026-08-14T16:01:00Z'),
    commandType: 'request_validation',
    subject: { id: SUBJECT_ID, kind: 'source_version' },
    expectedState: 'REGISTERED',
    expectedVersion: registered.aggregateVersion,
    expectedSequence: registered.sequence,
  });
  const requested = await commandRepository.requestValidation(request);
  assert.equal(requested.state, 'PENDING_VALIDATION');

  const registrationAsOf = await readRepository.listRegistrationHistory(
    SUBJECT_ID,
    '2026-08-14T16:01:30Z'
  );
  assert.deepEqual(
    registrationAsOf.map((event) => event.eventType),
    ['source_registered', 'source_validation_requested']
  );

  const confirm = await withFingerprint({
    ...envelope(3, CURATOR_ID, 'curator', '2026-08-14T16:02:00Z'),
    commandType: 'confirm_validation',
    subject: { id: SUBJECT_ID, kind: 'source_version' },
    expectedState: 'PENDING_VALIDATION',
    expectedVersion: requested.aggregateVersion,
    expectedSequence: requested.sequence,
  });
  const validated = await commandRepository.confirmValidation(confirm);
  assert.equal(validated.state, 'VALIDATED');

  const registrationHistory = await readRepository.listRegistrationHistory(SUBJECT_ID);
  assert.deepEqual(
    registrationHistory.map((event) => event.toState),
    ['REGISTERED', 'PENDING_VALIDATION', 'VALIDATED']
  );

  const grant = await withFingerprint({
    ...envelope(4, REVIEWER_ID, 'legal_editorial_reviewer', '2026-08-14T16:03:00Z'),
    commandType: 'grant_authorization',
    authorizationId: AUTHORIZATION_ID,
    scope: scope(),
    basis: basis(),
    effectiveFrom: '2026-08-14T16:03:00Z',
  });
  const granted = await commandRepository.grantAuthorization(grant);
  assert.equal(granted.state, 'GRANTED');
  assert.equal(granted.sequence, 1);

  const suspend = await withFingerprint({
    ...envelope(5, REVIEWER_ID, 'legal_editorial_reviewer', '2026-08-14T16:04:00Z'),
    commandType: 'suspend_authorization',
    authorizationId: AUTHORIZATION_ID,
    scope: scope(),
    basis: basis(),
    expectedState: 'GRANTED',
    expectedVersion: granted.aggregateVersion,
    expectedSequence: granted.sequence,
  });
  const suspended = await commandRepository.suspendAuthorization(suspend);
  assert.equal(suspended.state, 'SUSPENDED');
  assert.equal(suspended.eventIds.length, 2);

  const resume = await withFingerprint({
    ...envelope(6, REVIEWER_ID, 'legal_editorial_reviewer', '2026-08-14T16:05:00Z'),
    commandType: 'resume_authorization',
    authorizationId: AUTHORIZATION_ID,
    scope: scope(),
    basis: basis(),
    expectedState: 'SUSPENDED',
    expectedVersion: suspended.aggregateVersion,
    expectedSequence: suspended.sequence,
  });
  const resumed = await commandRepository.resumeAuthorization(resume);
  assert.equal(resumed.state, 'GRANTED');

  const revoke = await withFingerprint({
    ...envelope(7, REVIEWER_ID, 'legal_editorial_reviewer', '2026-08-14T16:06:00Z'),
    commandType: 'revoke_authorization',
    authorizationId: AUTHORIZATION_ID,
    scope: scope(),
    basis: basis(),
    expectedState: 'GRANTED',
    expectedVersion: resumed.aggregateVersion,
    expectedSequence: resumed.sequence,
  });
  const revoked = await commandRepository.revokeAuthorization(revoke);
  assert.equal(revoked.state, 'REVOKED');
  assert.equal(revoked.eventIds.length, 2);

  const authorizationHistory = await readRepository.listAuthorizationHistory(
    SUBJECT_ID,
    'retrieval'
  );
  assert.deepEqual(
    authorizationHistory.map((event) => event.eventType),
    [
      'authorization_granted',
      'authorization_suspended',
      'authorization_resumed',
      'authorization_revoked',
    ]
  );
  assert.ok(authorizationHistory.every((event) => event.scope.purpose === 'retrieval'));

  const explicitImpact = await withFingerprint({
    ...envelope(8, CURATOR_ID, 'curator', '2026-08-14T16:07:00Z'),
    commandType: 'open_impact_assessment',
    subject: { id: SUBJECT_ID, kind: 'source_version' },
    triggeringAuthorizationId: AUTHORIZATION_ID,
  });
  const impactReceipt = await commandRepository.openImpactAssessment(explicitImpact);
  assert.equal(impactReceipt.dimension, 'impact');

  const impactHistory = await readRepository.listImpactHistory(SUBJECT_ID);
  assert.equal(impactHistory.length, 3);
  assert.ok(impactHistory.every((event) => event.eventType === 'source_impact_assessment_opened'));
  assert.equal(
    impactHistory.at(-1).triggeringAuthorizationId,
    AUTHORIZATION_ID
  );

  const forbidden = await withFingerprint({
    ...envelope(9, UNASSIGNED_CURATOR_ID, 'curator', '2026-08-14T16:08:00Z'),
    commandType: 'register_identity',
    subject: { id: UNASSIGNED_SUBJECT_ID, kind: 'work' },
  });
  await assert.rejects(commandRepository.registerIdentity(forbidden), {
    name: 'KnowledgeFactoryPersistenceError',
    code: 'FORBIDDEN',
  });
});
