import assert from 'node:assert/strict';
import test from 'node:test';
import { SupabaseIngestionRecoveryRepository } from '../src/index.ts';

const RUN_ID = 'b1000000-0000-4000-8000-000000000001';
const SOURCE_VERSION_ID = 'b2000000-0000-4000-8000-000000000001';
const RECEIVED_FILE_ID = 'b3000000-0000-4000-8000-000000000001';
const ARTIFACT_ID = 'b4000000-0000-4000-8000-000000000001';
const CORRELATION_ID = 'b5000000-0000-4000-8000-000000000001';
const DIGEST = 'c'.repeat(64);
const NOW = '2026-08-15T01:30:00.000Z';

function artifactSnapshot(state = 'RECEIVING', discard = null) {
  return {
    contractVersion: '1.0.0',
    artifactId: ARTIFACT_ID,
    run: { kind: 'processing_run', id: RUN_ID },
    sourceVersion: { kind: 'source_version', id: SOURCE_VERSION_ID },
    receivedFile: { kind: 'received_file', id: RECEIVED_FILE_ID },
    state,
    sizeBytes: 21,
    mediaType: 'application/pdf',
    createdAt: NOW,
    expiresAt: '2026-08-15T07:30:00.000Z',
    opaqueLocator: state === 'RECEIVING' ? null : `temporary-staging:v1:${RUN_ID}:${ARTIFACT_ID}`,
    writeIntentDigest: { algorithm: 'sha-256', value: DIGEST },
    correlationId: CORRELATION_ID,
    discard,
  };
}

function recoverySnapshot() {
  return {
    contractVersion: '1.0.0',
    run: {
      contractVersion: '1.0.0',
      requestId: 'b6000000-0000-4000-8000-000000000001',
      run: { kind: 'processing_run', id: RUN_ID },
      sourceVersion: { kind: 'source_version', id: SOURCE_VERSION_ID },
      receivedFile: { kind: 'received_file', id: RECEIVED_FILE_ID },
      state: 'STAGING',
      aggregateVersion: 'revision-2',
      sequence: 2,
      requestedAt: NOW,
      createdAt: NOW,
      updatedAt: NOW,
    },
    artifacts: [artifactSnapshot()],
    integrityEvidence: [],
    latestReceipt: {
      contractVersion: '1.0.0',
      commandId: 'b7000000-0000-4000-8000-000000000001',
      fingerprint: 'd'.repeat(64),
      correlationId: CORRELATION_ID,
      operation: 'begin_staging',
      run: { kind: 'processing_run', id: RUN_ID },
      aggregateVersion: 'revision-2',
      sequence: 2,
      eventIds: ['b8000000-0000-4000-8000-000000000001'],
      previousState: 'REQUESTED',
      state: 'STAGING',
      outcome: 'applied',
      committedAt: NOW,
    },
  };
}

test('recovery repository uses only narrow C.2.4 RPCs and returns provider-neutral snapshots', async () => {
  const calls = [];
  const client = {
    async rpc(name, args) {
      calls.push({ name, args });
      if (name === 'kf_ingestion_recovery_snapshot') return { data: recoverySnapshot(), error: null };
      if (name === 'kf_ingestion_prepare_discard') {
        return {
          data: artifactSnapshot('DISCARD_PENDING', {
            requestedAt: NOW,
            reasonCode: 'technical_failure',
            correlationId: CORRELATION_ID,
            confirmedAt: null,
            outcome: null,
          }),
          error: null,
        };
      }
      if (name === 'kf_ingestion_confirm_discard') {
        return {
          data: artifactSnapshot('DISCARDED', {
            requestedAt: NOW,
            confirmedAt: '2026-08-15T01:31:00.000Z',
            reasonCode: 'technical_failure',
            outcome: 'already_discarded',
            correlationId: CORRELATION_ID,
          }),
          error: null,
        };
      }
      return { data: artifactSnapshot(), error: null };
    },
  };
  const repository = new SupabaseIngestionRecoveryRepository({ client });
  const preparation = {
    artifactId: ARTIFACT_ID,
    run: { kind: 'processing_run', id: RUN_ID },
    sourceVersion: { kind: 'source_version', id: SOURCE_VERSION_ID },
    receivedFile: { kind: 'received_file', id: RECEIVED_FILE_ID },
    sizeBytes: 21,
    mediaType: 'application/pdf',
    createdAt: NOW,
    expiresAt: '2026-08-15T07:30:00.000Z',
    writeIntentDigest: { algorithm: 'sha-256', value: DIGEST },
    correlationId: CORRELATION_ID,
  };
  assert.equal((await repository.prepareStagingArtifact(preparation)).state, 'RECEIVING');
  const snapshot = await repository.getRecoverySnapshot({ kind: 'processing_run', id: RUN_ID });
  assert.equal(snapshot.run.state, 'STAGING');
  assert.equal(snapshot.latestReceipt?.operation, 'begin_staging');

  const discardCommand = {
    artifact: { artifactId: ARTIFACT_ID, opaqueLocator: `temporary-staging:v1:${RUN_ID}:${ARTIFACT_ID}` },
    run: { kind: 'processing_run', id: RUN_ID },
    requestedAt: NOW,
    reasonCode: 'technical_failure',
    correlationId: CORRELATION_ID,
  };
  assert.equal((await repository.prepareDiscard(discardCommand)).state, 'DISCARD_PENDING');
  assert.equal(
    (
      await repository.confirmDiscard({
        contractVersion: '1.0.0',
        state: 'DISCARDED',
        artifactId: ARTIFACT_ID,
        run: { kind: 'processing_run', id: RUN_ID },
        requestedAt: NOW,
        confirmedAt: '2026-08-15T01:31:00.000Z',
        outcome: 'already_discarded',
        reasonCode: 'technical_failure',
        correlationId: CORRELATION_ID,
      })
    ).discard?.outcome,
    'already_discarded'
  );

  assert.deepEqual(
    calls.map((call) => call.name),
    [
      'kf_ingestion_prepare_staging_artifact',
      'kf_ingestion_recovery_snapshot',
      'kf_ingestion_prepare_discard',
      'kf_ingestion_confirm_discard',
    ]
  );
  assert.equal(JSON.stringify(snapshot).includes('bucket'), false);
  assert.equal(JSON.stringify(snapshot).includes('signed'), false);
});

test('recovery repository rejects malformed provider snapshots instead of returning partial state', async () => {
  const repository = new SupabaseIngestionRecoveryRepository({
    client: {
      async rpc() {
        return { data: { contractVersion: '1.0.0', run: null, artifacts: [], integrityEvidence: [] }, error: null };
      },
    },
  });
  await assert.rejects(
    repository.getRecoverySnapshot({ kind: 'processing_run', id: RUN_ID }),
    (error) => error.code === 'INVALID_RESPONSE'
  );
});
