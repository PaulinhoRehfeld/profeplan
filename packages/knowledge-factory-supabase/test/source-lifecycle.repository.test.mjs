import assert from 'node:assert/strict';
import test from 'node:test';
import {
  SupabaseSourceLifecycleCommandRepository,
  SupabaseSourceLifecycleReadRepository,
} from '../src/index.ts';

const SUBJECT_ID = '81000000-0000-4000-8000-000000000001';
const SUCCESSOR_ID = '81000000-0000-4000-8000-000000000002';
const AUTHORIZATION_ID = '82000000-0000-4000-8000-000000000001';
const SUCCESSOR_AUTHORIZATION_ID = '82000000-0000-4000-8000-000000000002';
const BASIS_ID = '83000000-0000-4000-8000-000000000001';
const CURATOR_ID = '84000000-0000-4000-8000-000000000001';
const REVIEWER_ID = '84000000-0000-4000-8000-000000000002';
const CORRELATION_ID = '85000000-0000-4000-8000-000000000001';
const NOW = '2026-08-14T15:00:00.000Z';
const FINGERPRINT = 'a'.repeat(64);

const RPC_BY_COMMAND = Object.freeze({
  register_identity: 'kf_source_register_identity',
  request_validation: 'kf_source_request_validation',
  confirm_validation: 'kf_source_confirm_validation',
  block_source: 'kf_source_block',
  replace_source: 'kf_source_replace',
  archive_source: 'kf_source_archive',
  grant_authorization: 'kf_source_grant_authorization',
  suspend_authorization: 'kf_source_suspend_authorization',
  resume_authorization: 'kf_source_resume_authorization',
  revoke_authorization: 'kf_source_revoke_authorization',
  block_purpose: 'kf_source_block_purpose',
  supersede_authorization: 'kf_source_supersede_authorization',
  open_impact_assessment: 'kf_source_open_impact_assessment',
});

const STATE_BY_COMMAND = Object.freeze({
  register_identity: 'REGISTERED',
  request_validation: 'PENDING_VALIDATION',
  confirm_validation: 'VALIDATED',
  block_source: 'BLOCKED',
  replace_source: 'REPLACED',
  archive_source: 'ARCHIVED',
  grant_authorization: 'GRANTED',
  suspend_authorization: 'SUSPENDED',
  resume_authorization: 'GRANTED',
  revoke_authorization: 'REVOKED',
  block_purpose: 'BLOCKED',
  supersede_authorization: 'SUPERSEDED',
  open_impact_assessment: null,
});

function commandId(index) {
  return `86000000-0000-4000-8000-${String(index).padStart(12, '0')}`;
}

function envelope(index, role = 'curator') {
  return {
    commandId: commandId(index),
    fingerprint: FINGERPRINT,
    actor: {
      actorId: role === 'curator' ? CURATOR_ID : REVIEWER_ID,
      role,
    },
    occurredAt: NOW,
    effectiveAt: NOW,
    correlationId: CORRELATION_ID,
    reason: `synthetic C.1.4 reason ${index}`,
  };
}

function scope() {
  return {
    subject: { id: SUBJECT_ID, kind: 'source_version' },
    purpose: 'retrieval',
    restrictions: ['synthetic-only'],
  };
}

function basis() {
  return {
    id: BASIS_ID,
    kind: 'wrtech_ownership',
    referenceDigest: 'sha256:synthetic-c1-4',
  };
}

function commands() {
  return [
    {
      method: 'registerIdentity',
      command: {
        ...envelope(1),
        commandType: 'register_identity',
        subject: { id: SUBJECT_ID, kind: 'source_version' },
      },
      aggregateId: SUBJECT_ID,
      dimension: 'registration',
    },
    ...[
      ['requestValidation', 'request_validation', 'REGISTERED', 2],
      ['confirmValidation', 'confirm_validation', 'PENDING_VALIDATION', 3],
      ['blockSource', 'block_source', 'VALIDATED', 4],
      ['archiveSource', 'archive_source', 'BLOCKED', 6],
    ].map(([method, commandType, expectedState, index]) => ({
      method,
      command: {
        ...envelope(index),
        commandType,
        subject: { id: SUBJECT_ID, kind: 'source_version' },
        expectedState,
        expectedVersion: 'revision-1',
        expectedSequence: 1,
      },
      aggregateId: SUBJECT_ID,
      dimension: 'registration',
    })),
    {
      method: 'replaceSource',
      command: {
        ...envelope(5),
        commandType: 'replace_source',
        subject: { id: SUBJECT_ID, kind: 'source_version' },
        successor: { id: SUCCESSOR_ID, kind: 'source_version' },
        expectedState: 'VALIDATED',
        expectedVersion: 'revision-1',
        expectedSequence: 1,
      },
      aggregateId: SUBJECT_ID,
      dimension: 'registration',
    },
    {
      method: 'grantAuthorization',
      command: {
        ...envelope(7, 'legal_editorial_reviewer'),
        commandType: 'grant_authorization',
        authorizationId: AUTHORIZATION_ID,
        scope: scope(),
        basis: basis(),
        effectiveFrom: NOW,
      },
      aggregateId: AUTHORIZATION_ID,
      dimension: 'authorization',
    },
    ...[
      ['suspendAuthorization', 'suspend_authorization', 'GRANTED', 8],
      ['resumeAuthorization', 'resume_authorization', 'SUSPENDED', 9],
      ['revokeAuthorization', 'revoke_authorization', 'GRANTED', 10],
      ['blockPurpose', 'block_purpose', 'SUSPENDED', 11],
    ].map(([method, commandType, expectedState, index]) => ({
      method,
      command: {
        ...envelope(index, 'legal_editorial_reviewer'),
        commandType,
        authorizationId: AUTHORIZATION_ID,
        scope: scope(),
        basis: basis(),
        expectedState,
        expectedVersion: 'revision-1',
        expectedSequence: 1,
      },
      aggregateId: AUTHORIZATION_ID,
      dimension: 'authorization',
    })),
    {
      method: 'supersedeAuthorization',
      command: {
        ...envelope(12, 'legal_editorial_reviewer'),
        commandType: 'supersede_authorization',
        authorizationId: AUTHORIZATION_ID,
        successorAuthorizationId: SUCCESSOR_AUTHORIZATION_ID,
        scope: scope(),
        basis: basis(),
        effectiveFrom: NOW,
        expectedState: 'GRANTED',
        expectedVersion: 'revision-1',
        expectedSequence: 1,
      },
      aggregateId: AUTHORIZATION_ID,
      dimension: 'authorization',
    },
    {
      method: 'openImpactAssessment',
      command: {
        ...envelope(13),
        commandType: 'open_impact_assessment',
        subject: { id: SUBJECT_ID, kind: 'source_version' },
        triggeringAuthorizationId: AUTHORIZATION_ID,
      },
      aggregateId: SUBJECT_ID,
      dimension: 'impact',
    },
  ];
}

function receiptRow(command, aggregateId, dimension) {
  return {
    dimension,
    command_id: command.commandId,
    fingerprint: command.fingerprint,
    operation: command.commandType,
    aggregate_id: aggregateId,
    aggregate_version: 'revision-result',
    sequence: 2,
    event_ids: ['87000000-0000-4000-8000-000000000001'],
    state: STATE_BY_COMMAND[command.commandType],
    replayed: false,
    committed_at: NOW,
  };
}

test('command adapter routes all 13 lifecycle commands through their exact RPCs', async () => {
  const calls = [];
  const client = {
    async rpc(name, args) {
      calls.push({ name, args });
      const commandType = args.p_payload.commandType;
      const entry = commands().find((candidate) => candidate.command.commandType === commandType);
      return { data: [receiptRow(entry.command, entry.aggregateId, entry.dimension)], error: null };
    },
  };
  const repository = new SupabaseSourceLifecycleCommandRepository({ client });

  for (const entry of commands()) {
    const receipt = await repository[entry.method](entry.command);
    assert.equal(receipt.operation, entry.command.commandType);
    assert.equal(receipt.aggregateId, entry.aggregateId);
  }

  assert.equal(calls.length, 13);
  for (const [index, entry] of commands().entries()) {
    const call = calls[index];
    assert.equal(call.name, RPC_BY_COMMAND[entry.command.commandType]);
    assert.equal(call.args.p_command_id, entry.command.commandId);
    assert.equal(call.args.p_fingerprint, entry.command.fingerprint);
    assert.equal(call.args.p_payload.commandType, entry.command.commandType);
    assert.equal('commandId' in call.args.p_payload, false);
    assert.equal('fingerprint' in call.args.p_payload, false);
  }
});

test('command adapter translates C.1.3 competence denial to provider-neutral FORBIDDEN', async () => {
  const entry = commands()[0];
  const client = {
    async rpc() {
      return { data: null, error: { code: 'PT403', message: 'actor is not competent' } };
    },
  };
  const repository = new SupabaseSourceLifecycleCommandRepository({ client });

  await assert.rejects(repository.registerIdentity(entry.command), {
    name: 'KnowledgeFactoryPersistenceError',
    code: 'FORBIDDEN',
  });
});

test('command adapter rejects malformed provider receipts without leaking raw provider details', async () => {
  const entry = commands()[0];
  const client = {
    async rpc() {
      return { data: [{ unexpected: true }], error: null };
    },
  };
  const repository = new SupabaseSourceLifecycleCommandRepository({ client });

  await assert.rejects(repository.registerIdentity(entry.command), {
    name: 'KnowledgeFactoryPersistenceError',
    code: 'INVALID_RESPONSE',
  });
});

test('command telemetry is allowlisted and omits command payload, reason, actor and fingerprint', async () => {
  const entry = commands()[0];
  const records = [];
  const client = {
    async rpc() {
      return { data: [receiptRow(entry.command, entry.aggregateId, entry.dimension)], error: null };
    },
  };
  const repository = new SupabaseSourceLifecycleCommandRepository(
    { client },
    { record(record) { records.push(record); } }
  );

  await repository.registerIdentity(entry.command);
  assert.equal(records.length, 1);
  const serialized = JSON.stringify(records[0]);
  assert.equal(serialized.includes(entry.command.reason), false);
  assert.equal(serialized.includes(entry.command.fingerprint), false);
  assert.equal(serialized.includes(entry.command.actor.actorId), false);
  assert.equal('payload' in records[0], false);
  assert.equal(records[0].correlationId, CORRELATION_ID);
});

function commonHistoryRow(eventType, commandIdValue) {
  return {
    event_id: '88000000-0000-4000-8000-000000000001',
    aggregate_id: SUBJECT_ID,
    aggregate_version: 'revision-history',
    sequence: 1,
    event_type: eventType,
    subject_id: SUBJECT_ID,
    subject_kind: 'source_version',
    actor_id: CURATOR_ID,
    actor_role: 'curator',
    reason: 'synthetic history',
    occurred_at: NOW,
    effective_at: NOW,
    correlation_id: CORRELATION_ID,
    command_id: commandIdValue,
  };
}

test('read adapter maps registration, authorization and impact history and forwards filters', async () => {
  const calls = [];
  const client = {
    async rpc(name, args) {
      calls.push({ name, args });
      if (name === 'kf_source_list_registration_history') {
        return {
          data: [{
            ...commonHistoryRow('source_validated', commandId(21)),
            from_state: 'PENDING_VALIDATION',
            to_state: 'VALIDATED',
            successor_id: null,
            successor_kind: null,
          }],
          error: null,
        };
      }
      if (name === 'kf_source_list_authorization_history') {
        return {
          data: [{
            ...commonHistoryRow('authorization_granted', commandId(22)),
            actor_id: REVIEWER_ID,
            actor_role: 'legal_editorial_reviewer',
            aggregate_id: AUTHORIZATION_ID,
            authorization_id: AUTHORIZATION_ID,
            purpose: 'retrieval',
            restrictions: ['synthetic-only'],
            basis_id: BASIS_ID,
            basis_kind: 'wrtech_ownership',
            basis_reference_digest: 'sha256:synthetic-c1-4',
            from_state: null,
            to_state: 'GRANTED',
            effective_from: NOW,
            effective_until: null,
            superseded_by_authorization_id: null,
          }],
          error: null,
        };
      }
      return {
        data: [{
          ...commonHistoryRow('source_impact_assessment_opened', commandId(23)),
          triggering_authorization_id: AUTHORIZATION_ID,
        }],
        error: null,
      };
    },
  };
  const repository = new SupabaseSourceLifecycleReadRepository({ client });

  const registration = await repository.listRegistrationHistory(SUBJECT_ID, NOW);
  const authorization = await repository.listAuthorizationHistory(SUBJECT_ID, 'retrieval', NOW);
  const impact = await repository.listImpactHistory(SUBJECT_ID, NOW);

  assert.equal(registration[0].toState, 'VALIDATED');
  assert.equal(authorization[0].scope.purpose, 'retrieval');
  assert.deepEqual(authorization[0].scope.restrictions, ['synthetic-only']);
  assert.equal(impact[0].triggeringAuthorizationId, AUTHORIZATION_ID);

  assert.deepEqual(calls.map((call) => call.name), [
    'kf_source_list_registration_history',
    'kf_source_list_authorization_history',
    'kf_source_list_impact_history',
  ]);
  assert.deepEqual(calls[0].args, { p_subject_identity_id: SUBJECT_ID, p_as_of: NOW });
  assert.deepEqual(calls[1].args, {
    p_subject_identity_id: SUBJECT_ID,
    p_purpose: 'retrieval',
    p_as_of: NOW,
  });
  assert.deepEqual(calls[2].args, { p_subject_identity_id: SUBJECT_ID, p_as_of: NOW });
});
