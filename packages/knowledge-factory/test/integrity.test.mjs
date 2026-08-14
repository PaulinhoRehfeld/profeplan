import assert from 'node:assert/strict';
import test from 'node:test';
import { evaluateStagingIntegrity } from '../src/index.ts';

const digestA = '5aea7a7a5e33d66d021fd52802ceb64ac5b8f377b2be55fddca8607f093ce3ce';
const digestB = 'b'.repeat(64);

const run = { kind: 'processing_run', id: 'processing-run-integrity-1' };
const sourceVersion = { kind: 'source_version', id: 'source-version-integrity-1' };
const receivedFile = { kind: 'received_file', id: 'received-file-integrity-1' };

function artifact(overrides = {}) {
  return {
    contractVersion: '1.0.0',
    state: 'STAGED',
    artifact: {
      artifactId: 'artifact-integrity-1',
      opaqueLocator: 'temporary-staging:v1:processing-run-integrity-1:artifact-integrity-1',
    },
    run,
    sourceVersion,
    receivedFile,
    sizeBytes: 18,
    mediaType: 'application/pdf',
    createdAt: '2026-08-14T21:00:00.000Z',
    expiresAt: '2026-08-15T03:00:00.000Z',
    ...overrides,
  };
}

function evidence(overrides = {}) {
  return {
    contractVersion: '1.0.0',
    artifactId: 'artifact-integrity-1',
    run,
    sourceVersion,
    receivedFile,
    digest: { algorithm: 'sha-256', value: digestA },
    byteLength: 18,
    verifiedAt: '2026-08-14T21:05:00.000Z',
    correlationId: 'correlation-integrity-1',
    ...overrides,
  };
}

function reasonCodes(decision) {
  return decision.reasons.map((item) => item.code);
}

test('valid physical evidence materializes STAGED -> VERIFIED without release semantics', () => {
  const decision = evaluateStagingIntegrity({
    artifact: artifact(),
    evidence: evidence(),
    evaluatedAt: '2026-08-14T21:06:00.000Z',
  });

  assert.equal(decision.allowed, true);
  assert.equal(decision.value.state, 'VERIFIED');
  assert.equal(decision.value.integrity.digest.value, digestA);
  assert.equal(decision.value.duplicateDecision.outcome, 'unique');
  assert.equal('releasedForExtractionAt' in decision.value, false);
});

test('binary duplicates remain auditable relationships and never collapse identities', () => {
  const knownEvidence = [
    evidence({
      artifactId: 'artifact-integrity-other-same-run',
      receivedFile: { kind: 'received_file', id: 'received-file-other-same-run' },
    }),
    evidence({
      artifactId: 'artifact-integrity-other-run',
      run: { kind: 'processing_run', id: 'processing-run-integrity-2' },
      receivedFile: { kind: 'received_file', id: 'received-file-other-run' },
    }),
    evidence({
      artifactId: 'artifact-integrity-other-source-version',
      run: { kind: 'processing_run', id: 'processing-run-integrity-3' },
      sourceVersion: { kind: 'source_version', id: 'source-version-integrity-2' },
      receivedFile: { kind: 'received_file', id: 'received-file-other-source-version' },
    }),
  ];

  const decision = evaluateStagingIntegrity({
    artifact: artifact(),
    evidence: evidence(),
    knownEvidence,
    evaluatedAt: '2026-08-14T21:06:00.000Z',
  });

  assert.equal(decision.allowed, true);
  assert.equal(decision.value.duplicateDecision.outcome, 'duplicate');
  assert.deepEqual(
    decision.value.duplicateDecision.matches.map((match) => match.relationship),
    ['same_run', 'same_source_version', 'cross_source_version']
  );
  assert.equal(decision.value.sourceVersion.id, sourceVersion.id);
  assert.equal(decision.value.receivedFile.id, receivedFile.id);
});

test('consistent re-verification of the same artifact is auditable and allowed', () => {
  const decision = evaluateStagingIntegrity({
    artifact: artifact(),
    evidence: evidence(),
    knownEvidence: [evidence({ verifiedAt: '2026-08-14T21:04:00.000Z' })],
    evaluatedAt: '2026-08-14T21:06:00.000Z',
  });

  assert.equal(decision.allowed, true);
  assert.equal(decision.value.duplicateDecision.outcome, 'duplicate');
  assert.equal(decision.value.duplicateDecision.matches[0].relationship, 'same_artifact');
});

test('same physical artifact previously observed with another digest fails closed', () => {
  const decision = evaluateStagingIntegrity({
    artifact: artifact(),
    evidence: evidence(),
    knownEvidence: [evidence({ digest: { algorithm: 'sha-256', value: digestB } })],
    evaluatedAt: '2026-08-14T21:06:00.000Z',
  });

  assert.equal(decision.allowed, false);
  assert.equal(reasonCodes(decision).includes('STAGING_INTEGRITY_DIGEST_CONFLICT'), true);
});

test('identity binding mismatch fails closed', () => {
  const decision = evaluateStagingIntegrity({
    artifact: artifact(),
    evidence: evidence({ run: { kind: 'processing_run', id: 'processing-run-wrong' } }),
    evaluatedAt: '2026-08-14T21:06:00.000Z',
  });

  assert.equal(decision.allowed, false);
  assert.equal(reasonCodes(decision).includes('STAGING_INTEGRITY_BINDING_MISMATCH'), true);
});

test('physically observed byte length must equal the staged descriptor', () => {
  const decision = evaluateStagingIntegrity({
    artifact: artifact(),
    evidence: evidence({ byteLength: 19 }),
    evaluatedAt: '2026-08-14T21:06:00.000Z',
  });

  assert.equal(decision.allowed, false);
  assert.equal(reasonCodes(decision).includes('STAGING_INTEGRITY_BYTE_LENGTH_MISMATCH'), true);
});

test('digest representation is canonical lowercase SHA-256 hexadecimal', () => {
  const decision = evaluateStagingIntegrity({
    artifact: artifact(),
    evidence: evidence({
      digest: { algorithm: 'sha-256', value: digestA.toUpperCase() },
    }),
    evaluatedAt: '2026-08-14T21:06:00.000Z',
  });

  assert.equal(decision.allowed, false);
  assert.equal(reasonCodes(decision).includes('STAGING_INTEGRITY_DIGEST_INVALID'), true);
});

test('expired artifacts cannot be promoted to VERIFIED', () => {
  const decision = evaluateStagingIntegrity({
    artifact: artifact(),
    evidence: evidence(),
    evaluatedAt: '2026-08-15T03:00:00.000Z',
  });

  assert.equal(decision.allowed, false);
  assert.equal(reasonCodes(decision).includes('STAGING_ARTIFACT_EXPIRED'), true);
});

test('verification timestamp must remain inside the artifact lifecycle window', () => {
  const decision = evaluateStagingIntegrity({
    artifact: artifact(),
    evidence: evidence({ verifiedAt: '2026-08-14T20:59:59.000Z' }),
    evaluatedAt: '2026-08-14T21:06:00.000Z',
  });

  assert.equal(decision.allowed, false);
  assert.equal(reasonCodes(decision).includes('STAGING_INTEGRITY_VERIFICATION_TIME_INVALID'), true);
});
