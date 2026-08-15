import assert from 'node:assert/strict';
import test from 'node:test';
import { SupabaseIngestionCommandRepository } from '../src/index.ts';

const RUN_ID = 'a1000000-0000-4000-8000-000000000001';
const SOURCE_VERSION_ID = 'a2000000-0000-4000-8000-000000000001';
const RECEIVED_FILE_ID = 'a3000000-0000-4000-8000-000000000001';
const ACTOR_ID = 'a4000000-0000-4000-8000-000000000001';
const CORRELATION_ID = 'a5000000-0000-4000-8000-000000000001';
const ARTIFACT_ID = 'a6000000-0000-4000-8000-000000000001';
const NOW = '2026-08-15T01:20:00.000Z';
const FINGERPRINT = 'a'.repeat(64);

function envelope(commandId) {
  return {
    commandId,
    fingerprint: FINGERPRINT,
    actor: { actorId: ACTOR_ID, role: 'system_worker' },
    occurredAt: NOW,
    correlationId: CORRELATION_ID,
    reason: 'synthetic C.2.4 repository test',
  };
}

function row(command, previousState, state, sequence = 2) {
  return {
    command_id: command.commandId,
    fingerprint: command.fingerprint,
    correlation_id: command.correlationId,
    operation: command.commandType,
    run_id: command.commandType === 'request_ingestion' ? command.request.run.id : command.run.id,
    aggregate_version: `revision-${sequence}`,
    sequence,
    event_ids: ['a7000000-0000-4000-8000-000000000001'],
    previous_state: previousState,
    state,
    replayed: false,
    committed_at: NOW,
    reason_code:
      command.commandType === 'fail_ingestion'
        ? 'technical_failure'
        : command.commandType === 'cancel_ingestion'
          ? 'operator_cancelled'
          : null,
  };
}

function stagedArtifact() {
  return {
    contractVersion: '1.0.0',
    state: 'STAGED',
    artifact: { artifactId: ARTIFACT_ID, opaqueLocator: `temporary-staging:v1:${RUN_ID}:${ARTIFACT_ID}` },
    run: { kind: 'processing_run', id: RUN_ID },
    sourceVersion: { kind: 'source_version', id: SOURCE_VERSION_ID },
    receivedFile: { kind: 'received_file', id: RECEIVED_FILE_ID },
    sizeBytes: 21,
    mediaType: 'application/pdf',
    createdAt: '2026-08-15T01:10:00.000Z',
    expiresAt: '2026-08-15T07:10:00.000Z',
  };
}

function verifiedArtifact() {
  return {
    ...stagedArtifact(),
    state: 'VERIFIED',
    integrity: {
      contractVersion: '1.0.0',
      artifactId: ARTIFACT_ID,
      run: { kind: 'processing_run', id: RUN_ID },
      sourceVersion: { kind: 'source_version', id: SOURCE_VERSION_ID },
      receivedFile: { kind: 'received_file', id: RECEIVED_FILE_ID },
      digest: { algorithm: 'sha-256', value: 'b'.repeat(64) },
      byteLength: 21,
      verifiedAt: '2026-08-15T01:19:00.000Z',
      correlationId: CORRELATION_ID,
    },
    duplicateDecision: {
      contractVersion: '1.0.0',
      digest: { algorithm: 'sha-256', value: 'b'.repeat(64) },
      outcome: 'unique',
      matches: [],
      evaluatedAt: NOW,
    },
  };
}

test('C.2.4 command repository routes only the seven authorized command boundaries', async () => {
  const calls = [];
  const client = {
    async rpc(name, args) {
      calls.push({ name, args });
      const command = args.p_payload;
      const states = {
        request_ingestion: [null, 'REQUESTED', 1],
        begin_staging: ['REQUESTED', 'STAGING', 2],
        mark_staged: ['STAGING', 'STAGED', 3],
        begin_verification: ['STAGED', 'VERIFYING', 4],
        confirm_verified: ['VERIFYING', 'VERIFIED', 5],
        fail_ingestion: ['STAGING', 'FAILED', 3],
        cancel_ingestion: ['STAGING', 'CANCELLED', 3],
      };
      const [previous, state, sequence] = states[command.commandType];
      const full = {
        ...command,
        commandId: args.p_command_id,
        fingerprint: args.p_fingerprint,
        ...(command.commandType === 'request_ingestion'
          ? {}
          : { run: command.run }),
      };
      return { data: [row(full, previous, state, sequence)], error: null };
    },
  };
  const repository = new SupabaseIngestionCommandRepository({ client });
  const request = {
    ...envelope('a8000000-0000-4000-8000-000000000001'),
    commandType: 'request_ingestion',
    request: {
      requestId: 'a9000000-0000-4000-8000-000000000001',
      sourceVersion: { kind: 'source_version', id: SOURCE_VERSION_ID },
      receivedFile: { kind: 'received_file', id: RECEIVED_FILE_ID },
      run: { kind: 'processing_run', id: RUN_ID },
      requestedBy: { actorId: ACTOR_ID, role: 'system_worker' },
      requestedAt: NOW,
      authorizationEvidence: [],
    },
  };
  const begin = {
    ...envelope('a8000000-0000-4000-8000-000000000002'),
    commandType: 'begin_staging',
    run: { kind: 'processing_run', id: RUN_ID },
    expectedState: 'REQUESTED',
  };
  const mark = {
    ...envelope('a8000000-0000-4000-8000-000000000003'),
    commandType: 'mark_staged',
    run: { kind: 'processing_run', id: RUN_ID },
    expectedState: 'STAGING',
    stagingArtifact: stagedArtifact().artifact,
  };
  const verify = {
    ...envelope('a8000000-0000-4000-8000-000000000004'),
    commandType: 'begin_verification',
    run: { kind: 'processing_run', id: RUN_ID },
    expectedState: 'STAGED',
  };
  const confirm = {
    ...envelope('a8000000-0000-4000-8000-000000000005'),
    commandType: 'confirm_verified',
    run: { kind: 'processing_run', id: RUN_ID },
    expectedState: 'VERIFYING',
  };
  const fail = {
    ...envelope('a8000000-0000-4000-8000-000000000006'),
    commandType: 'fail_ingestion',
    run: { kind: 'processing_run', id: RUN_ID },
    expectedState: 'STAGING',
    reasonCode: 'technical_failure',
  };
  const cancel = {
    ...envelope('a8000000-0000-4000-8000-000000000007'),
    commandType: 'cancel_ingestion',
    run: { kind: 'processing_run', id: RUN_ID },
    expectedState: 'STAGING',
    reasonCode: 'operator_cancelled',
  };

  assert.equal((await repository.requestIngestion(request)).state, 'REQUESTED');
  assert.equal((await repository.beginStaging(begin)).state, 'STAGING');
  assert.equal((await repository.markStaged(mark, stagedArtifact())).state, 'STAGED');
  assert.equal((await repository.beginVerification(verify)).state, 'VERIFYING');
  assert.equal((await repository.confirmVerified(confirm, verifiedArtifact())).state, 'VERIFIED');
  assert.equal((await repository.failIngestion(fail)).state, 'FAILED');
  assert.equal((await repository.cancelIngestion(cancel)).state, 'CANCELLED');

  assert.deepEqual(
    calls.map((call) => call.name),
    [
      'kf_ingestion_request',
      'kf_ingestion_begin_staging',
      'kf_ingestion_mark_staged',
      'kf_ingestion_begin_verification',
      'kf_ingestion_confirm_verified',
      'kf_ingestion_fail',
      'kf_ingestion_cancel',
    ]
  );
  for (const call of calls) {
    assert.equal('commandId' in call.args.p_payload, false);
    assert.equal('fingerprint' in call.args.p_payload, false);
  }
  assert.equal(calls[2].args.p_artifact.artifact.artifactId, ARTIFACT_ID);
  assert.equal('duplicateDecision' in calls[4].args.p_verification, false);
});

test('C.2.4 command repository sanitizes provider conflicts', async () => {
  const repository = new SupabaseIngestionCommandRepository({
    client: {
      async rpc() {
        return { data: null, error: { code: 'PT409', message: 'raw database conflict detail' } };
      },
    },
  });
  await assert.rejects(
    repository.beginStaging({
      ...envelope('aa000000-0000-4000-8000-000000000001'),
      commandType: 'begin_staging',
      run: { kind: 'processing_run', id: RUN_ID },
      expectedState: 'REQUESTED',
    }),
    (error) => error.code === 'CONFLICT' && !error.message.includes('raw database conflict detail')
  );
});
