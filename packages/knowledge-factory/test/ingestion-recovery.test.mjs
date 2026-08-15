import assert from 'node:assert/strict';
import test from 'node:test';
import {
  canonicalizeIngestionFingerprintValue,
  computeIngestionCommandFingerprint,
  evaluateStagingRecoveryProbe,
} from '../src/index.ts';

const RUN_ID = '91000000-0000-4000-8000-000000000001';
const ARTIFACT_ID = '92000000-0000-4000-8000-000000000001';
const SOURCE_VERSION_ID = '93000000-0000-4000-8000-000000000001';
const RECEIVED_FILE_ID = '94000000-0000-4000-8000-000000000001';
const CORRELATION_ID = '95000000-0000-4000-8000-000000000001';
const DIGEST = 'a'.repeat(64);

function preparation(overrides = {}) {
  return {
    artifactId: ARTIFACT_ID,
    run: { kind: 'processing_run', id: RUN_ID },
    sourceVersion: { kind: 'source_version', id: SOURCE_VERSION_ID },
    receivedFile: { kind: 'received_file', id: RECEIVED_FILE_ID },
    sizeBytes: 21,
    mediaType: 'application/pdf',
    createdAt: '2026-08-15T01:00:00.000Z',
    expiresAt: '2026-08-15T07:00:00.000Z',
    writeIntentDigest: { algorithm: 'sha-256', value: DIGEST },
    correlationId: CORRELATION_ID,
    ...overrides,
  };
}

test('C.2.4 recovery retries only when the prepared artifact is physically absent', () => {
  const decision = evaluateStagingRecoveryProbe({
    preparation: preparation(),
    probe: {
      outcome: 'absent',
      artifactId: ARTIFACT_ID,
      run: { kind: 'processing_run', id: RUN_ID },
      observedAt: '2026-08-15T01:05:00.000Z',
    },
    evaluatedAt: '2026-08-15T01:05:00.000Z',
  });
  assert.equal(decision.allowed, true);
  assert.deepEqual(decision.value, { outcome: 'retry_upload' });
});

test('C.2.4 recovery reuses an existing object only when size and write-intent digest match', () => {
  const decision = evaluateStagingRecoveryProbe({
    preparation: preparation(),
    probe: {
      outcome: 'present',
      artifact: {
        artifactId: ARTIFACT_ID,
        opaqueLocator: `temporary-staging:v1:${RUN_ID}:${ARTIFACT_ID}`,
      },
      run: { kind: 'processing_run', id: RUN_ID },
      observedDigest: { algorithm: 'sha-256', value: DIGEST },
      observedSizeBytes: 21,
      observedAt: '2026-08-15T01:05:00.000Z',
    },
    evaluatedAt: '2026-08-15T01:05:00.000Z',
  });
  assert.equal(decision.allowed, true);
  assert.equal(decision.value?.outcome, 'reuse_existing');
});

test('C.2.4 recovery fails closed for a divergent physical object', () => {
  const decision = evaluateStagingRecoveryProbe({
    preparation: preparation(),
    probe: {
      outcome: 'present',
      artifact: { artifactId: ARTIFACT_ID, opaqueLocator: 'temporary-staging:v1:opaque' },
      run: { kind: 'processing_run', id: RUN_ID },
      observedDigest: { algorithm: 'sha-256', value: 'b'.repeat(64) },
      observedSizeBytes: 22,
      observedAt: '2026-08-15T01:05:00.000Z',
    },
    evaluatedAt: '2026-08-15T01:05:00.000Z',
  });
  assert.equal(decision.allowed, false);
  assert.equal(decision.reasons[0]?.code, 'STAGING_RECOVERY_OBJECT_CONFLICT');
});

test('C.2.4 recovery never extends or ignores the original retention deadline', () => {
  const decision = evaluateStagingRecoveryProbe({
    preparation: preparation(),
    probe: {
      outcome: 'absent',
      artifactId: ARTIFACT_ID,
      run: { kind: 'processing_run', id: RUN_ID },
      observedAt: '2026-08-15T07:00:00.000Z',
    },
    evaluatedAt: '2026-08-15T07:00:00.000Z',
  });
  assert.equal(decision.allowed, false);
  assert.equal(decision.reasons[0]?.code, 'STAGING_ARTIFACT_EXPIRED');
});

test('canonical fingerprint ignores object insertion order and excludes commandId/fingerprint', async () => {
  assert.equal(
    canonicalizeIngestionFingerprintValue({ z: 1, a: { y: 2, b: 3 } }),
    canonicalizeIngestionFingerprintValue({ a: { b: 3, y: 2 }, z: 1 })
  );

  const base = {
    commandId: '96000000-0000-4000-8000-000000000001',
    commandType: 'begin_staging',
    actor: { actorId: '97000000-0000-4000-8000-000000000001', role: 'system_worker' },
    occurredAt: '2026-08-15T01:10:00.000Z',
    correlationId: CORRELATION_ID,
    reason: 'synthetic recovery test',
    run: { kind: 'processing_run', id: RUN_ID },
    expectedState: 'REQUESTED',
  };
  const first = await computeIngestionCommandFingerprint({ ...base, fingerprint: '0'.repeat(64) });
  const second = await computeIngestionCommandFingerprint({
    ...base,
    commandId: '96000000-0000-4000-8000-000000000002',
    fingerprint: 'f'.repeat(64),
  });
  assert.match(first, /^[0-9a-f]{64}$/u);
  assert.equal(first, second);
});
