import assert from 'node:assert/strict';
import test from 'node:test';
import {
  DEFAULT_STAGING_INTAKE_POLICY,
  evaluateStagingArtifactAvailability,
  evaluateStagingIntake,
} from '../src/index.ts';

const sourceVersion = { kind: 'source_version', id: 'source-version-synthetic-1' };
const receivedFile = { kind: 'received_file', id: 'received-file-synthetic-1' };
const run = { kind: 'processing_run', id: 'processing-run-synthetic-1' };
const instant = '2026-08-14T21:00:00.000Z';
const pdfBytes = new TextEncoder().encode('%PDF-1.7\nsynthetic fixture only');

function authorization(purpose) {
  return {
    authorizationId: `authorization-${purpose}`,
    sourceVersion,
    purpose,
    evaluatedAt: instant,
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

function input(overrides = {}) {
  return {
    request: request(),
    artifactId: 'artifact-synthetic-1',
    file: {
      originalFilename: 'synthetic.pdf',
      declaredMediaType: 'application/pdf',
      bytes: pdfBytes,
    },
    runUsage: { artifactCount: 0, totalBytes: 0 },
    intakeStartedAt: instant,
    evaluatedAt: '2026-08-14T21:01:00.000Z',
    correlationId: 'correlation-synthetic-1',
    ...overrides,
  };
}

function tinyPolicy(overrides = {}) {
  return {
    ...DEFAULT_STAGING_INTAKE_POLICY,
    maxFileSizeBytes: 64,
    maxFilesPerRun: 2,
    maxTotalBytesPerRun: 96,
    maxIntakeDurationMs: 5 * 60 * 1000,
    defaultRetentionMs: 60 * 60 * 1000,
    maxRetentionMs: 2 * 60 * 60 * 1000,
    ...overrides,
  };
}

function expectReason(decision, code) {
  assert.equal(decision.allowed, false);
  assert.ok(decision.reasons.some((item) => item.code === code), `expected ${code}`);
}

test('valid synthetic PDF intake produces deterministic provider-neutral staging write', () => {
  const decision = evaluateStagingIntake(input({ policy: tinyPolicy() }));

  assert.equal(decision.allowed, true);
  assert.equal(decision.value?.artifactId, 'artifact-synthetic-1');
  assert.equal(decision.value?.run.id, run.id);
  assert.equal(decision.value?.sourceVersion.id, sourceVersion.id);
  assert.equal(decision.value?.receivedFile.id, receivedFile.id);
  assert.equal(decision.value?.mediaType, 'application/pdf');
  assert.equal(decision.value?.expiresAt, '2026-08-14T22:01:00.000Z');
  assert.equal(decision.value?.normalizedFilename, 'synthetic.pdf');
});

test('temporary_staging authorization remains independently required', () => {
  const decision = evaluateStagingIntake(
    input({
      policy: tinyPolicy(),
      request: request({ authorizationEvidence: [authorization('ingestion')] }),
    })
  );

  expectReason(decision, 'INGESTION_TEMPORARY_STAGING_AUTHORIZATION_REQUIRED');
});

test('ingestion authorization remains independently required', () => {
  const decision = evaluateStagingIntake(
    input({
      policy: tinyPolicy(),
      request: request({ authorizationEvidence: [authorization('temporary_staging')] }),
    })
  );

  expectReason(decision, 'INGESTION_AUTHORIZATION_REQUIRED');
});

test('file above configured limit is rejected', () => {
  const decision = evaluateStagingIntake(input({ policy: tinyPolicy({ maxFileSizeBytes: 4 }) }));
  expectReason(decision, 'STAGING_FILE_TOO_LARGE');
});

test('run file-count limit is enforced', () => {
  const decision = evaluateStagingIntake(
    input({ policy: tinyPolicy(), runUsage: { artifactCount: 2, totalBytes: 0 } })
  );
  expectReason(decision, 'STAGING_RUN_FILE_LIMIT_EXCEEDED');
});

test('run total-byte limit is enforced', () => {
  const decision = evaluateStagingIntake(
    input({ policy: tinyPolicy(), runUsage: { artifactCount: 0, totalBytes: 90 } })
  );
  expectReason(decision, 'STAGING_RUN_BYTE_LIMIT_EXCEEDED');
});

test('forbidden content type is rejected without semantic inspection', () => {
  const decision = evaluateStagingIntake(
    input({
      policy: tinyPolicy(),
      file: { originalFilename: 'synthetic.pdf', declaredMediaType: 'text/plain', bytes: pdfBytes },
    })
  );
  expectReason(decision, 'STAGING_MEDIA_TYPE_NOT_ALLOWED');
});

test('forbidden extension is rejected', () => {
  const decision = evaluateStagingIntake(
    input({
      policy: tinyPolicy(),
      file: {
        originalFilename: 'synthetic.exe',
        declaredMediaType: 'application/pdf',
        bytes: pdfBytes,
      },
    })
  );
  expectReason(decision, 'STAGING_EXTENSION_NOT_ALLOWED');
});

test('path traversal and hostile filenames are rejected', () => {
  for (const originalFilename of ['../synthetic.pdf', '..\\synthetic.pdf', 'folder/synthetic.pdf']) {
    const decision = evaluateStagingIntake(
      input({
        policy: tinyPolicy(),
        file: { originalFilename, declaredMediaType: 'application/pdf', bytes: pdfBytes },
      })
    );
    expectReason(decision, 'STAGING_FILENAME_REJECTED');
  }
});

test('minimum physical PDF signature mismatch is rejected without checksum', () => {
  const decision = evaluateStagingIntake(
    input({
      policy: tinyPolicy(),
      file: {
        originalFilename: 'synthetic.pdf',
        declaredMediaType: 'application/pdf',
        bytes: new TextEncoder().encode('not-a-pdf'),
      },
    })
  );
  expectReason(decision, 'STAGING_FILE_SIGNATURE_MISMATCH');
});

test('intake exceeding configured duration is rejected', () => {
  const decision = evaluateStagingIntake(
    input({ policy: tinyPolicy(), evaluatedAt: '2026-08-14T21:06:00.001Z' })
  );
  expectReason(decision, 'STAGING_INTAKE_DURATION_EXCEEDED');
});

test('retention above configured ceiling is rejected', () => {
  const decision = evaluateStagingIntake(
    input({ policy: tinyPolicy(), requestedRetentionMs: 3 * 60 * 60 * 1000 })
  );
  expectReason(decision, 'STAGING_RETENTION_INVALID');
});

test('artifact at or after expiration is unavailable', () => {
  const descriptor = {
    contractVersion: '1.0.0',
    artifact: { artifactId: 'artifact-synthetic-1', opaqueLocator: 'temporary-staging:artifact-synthetic-1' },
    run,
    sourceVersion,
    receivedFile,
    sizeBytes: pdfBytes.byteLength,
    mediaType: 'application/pdf',
    createdAt: '2026-08-14T21:00:00.000Z',
    expiresAt: '2026-08-14T22:00:00.000Z',
  };

  assert.equal(
    evaluateStagingArtifactAvailability(descriptor, '2026-08-14T21:59:59.999Z').allowed,
    true
  );
  expectReason(
    evaluateStagingArtifactAvailability(descriptor, '2026-08-14T22:00:00.000Z'),
    'STAGING_ARTIFACT_EXPIRED'
  );
});

test('same inputs and clock produce the same prepared staging metadata', () => {
  const first = evaluateStagingIntake(input({ policy: tinyPolicy() }));
  const second = evaluateStagingIntake(input({ policy: tinyPolicy() }));

  assert.deepEqual(first, second);
});
