import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  EXTRACTION_ARTIFACT_READ_ERROR_CODES,
  ExtractionArtifactReadError,
  readVerifiedExtractionArtifact,
} from '../src/index.ts';

const bytes = new TextEncoder().encode('%PDF-1.7\nsynthetic C.3.3 fixture only\n%%EOF');
const sha256 = createHash('sha256').update(bytes).digest('hex');
const readAt = '2026-08-18T04:00:00.000Z';
const expiresAt = '2026-08-18T05:00:00.000Z';
const sourceVersion = { kind: 'source_version', id: 'source-version-synthetic-c3-3' };
const run = { kind: 'extraction_run', id: 'extraction-run-synthetic-c3-3' };
const artifact = {
  artifactId: 'artifact-synthetic-c3-3',
  sha256,
  sizeBytes: bytes.byteLength,
};

function request(overrides = {}) {
  return {
    run,
    sourceVersion,
    artifact,
    authorizationEvidence: {
      authorizationId: 'authorization-synthetic-c3-3',
      sourceVersion,
      purpose: 'extraction',
      checkpoint: 'artifact_read',
      evaluatedAt: readAt,
    },
    readAt,
    ...overrides,
  };
}

function port(overrides = {}) {
  return {
    async read() {
      return {
        metadata: {
          artifactId: artifact.artifactId,
          sizeBytes: bytes.byteLength,
          mediaType: 'application/pdf',
          expiresAt,
        },
        body: bytes.slice(),
      };
    },
    ...overrides,
  };
}

async function expectReadError(promise, code) {
  await assert.rejects(promise, (error) => {
    assert.ok(error instanceof ExtractionArtifactReadError);
    assert.equal(error.code, code);
    return true;
  });
}

test('C.3.3 artifact read error vocabulary is closed and provider-neutral', () => {
  assert.deepEqual(EXTRACTION_ARTIFACT_READ_ERROR_CODES, [
    'authorization_denied',
    'artifact_unavailable',
    'artifact_expired',
    'artifact_identity_mismatch',
    'artifact_size_mismatch',
    'artifact_digest_mismatch',
    'artifact_read_failed',
  ]);
});

test('verified synthetic artifact read revalidates size and SHA-256 before returning bytes', async () => {
  const result = await readVerifiedExtractionArtifact(port(), request());

  assert.equal(result.artifact.artifactId, artifact.artifactId);
  assert.equal(result.mediaType, 'application/pdf');
  assert.equal(result.expiresAt, expiresAt);
  assert.equal(result.sha256, sha256);
  assert.deepEqual(result.body, bytes);
  assert.notEqual(result.body, bytes);
});

test('artifact-read authorization must match purpose, checkpoint, source version and read instant', async () => {
  await expectReadError(
    readVerifiedExtractionArtifact(
      port(),
      request({
        authorizationEvidence: {
          authorizationId: 'authorization-synthetic-c3-3',
          sourceVersion,
          purpose: 'extraction',
          checkpoint: 'claim',
          evaluatedAt: readAt,
        },
      })
    ),
    'authorization_denied'
  );

  await expectReadError(
    readVerifiedExtractionArtifact(
      port(),
      request({
        authorizationEvidence: {
          authorizationId: 'authorization-synthetic-c3-3',
          sourceVersion: { kind: 'source_version', id: 'different-source-version' },
          purpose: 'extraction',
          checkpoint: 'artifact_read',
          evaluatedAt: readAt,
        },
      })
    ),
    'authorization_denied'
  );

  await expectReadError(
    readVerifiedExtractionArtifact(
      port(),
      request({
        authorizationEvidence: {
          authorizationId: 'authorization-synthetic-c3-3',
          sourceVersion,
          purpose: 'extraction',
          checkpoint: 'artifact_read',
          evaluatedAt: '2026-08-18T03:59:59.999Z',
        },
      })
    ),
    'authorization_denied'
  );
});

test('typed provider authorization denial is preserved at the read boundary', async () => {
  await expectReadError(
    readVerifiedExtractionArtifact(
      port({
        async read() {
          throw new ExtractionArtifactReadError(
            'authorization_denied',
            'synthetic current authorization denial'
          );
        },
      }),
      request()
    ),
    'authorization_denied'
  );
});

test('provider unavailable and unknown provider failures stay explicit', async () => {
  await expectReadError(
    readVerifiedExtractionArtifact(
      port({
        async read() {
          throw new ExtractionArtifactReadError('artifact_unavailable', 'synthetic unavailable');
        },
      }),
      request()
    ),
    'artifact_unavailable'
  );

  await expectReadError(
    readVerifiedExtractionArtifact(
      port({
        async read() {
          throw new Error('provider-shaped implementation error must not escape');
        },
      }),
      request()
    ),
    'artifact_read_failed'
  );
});

test('artifact at or after retention expiry is rejected before extraction', async () => {
  await expectReadError(
    readVerifiedExtractionArtifact(
      port(),
      request({
        readAt: expiresAt,
        authorizationEvidence: {
          authorizationId: 'authorization-synthetic-c3-3',
          sourceVersion,
          purpose: 'extraction',
          checkpoint: 'artifact_read',
          evaluatedAt: expiresAt,
        },
      })
    ),
    'artifact_expired'
  );
});

test('different artifact identity fails closed', async () => {
  await expectReadError(
    readVerifiedExtractionArtifact(
      port({
        async read() {
          return {
            metadata: {
              artifactId: 'different-artifact',
              sizeBytes: bytes.byteLength,
              mediaType: 'application/pdf',
              expiresAt,
            },
            body: bytes.slice(),
          };
        },
      }),
      request()
    ),
    'artifact_identity_mismatch'
  );
});

test('metadata or body size divergence from C.2 handoff fails closed', async () => {
  await expectReadError(
    readVerifiedExtractionArtifact(
      port({
        async read() {
          return {
            metadata: {
              artifactId: artifact.artifactId,
              sizeBytes: bytes.byteLength + 1,
              mediaType: 'application/pdf',
              expiresAt,
            },
            body: bytes.slice(),
          };
        },
      }),
      request()
    ),
    'artifact_size_mismatch'
  );

  await expectReadError(
    readVerifiedExtractionArtifact(
      port({
        async read() {
          return {
            metadata: {
              artifactId: artifact.artifactId,
              sizeBytes: bytes.byteLength,
              mediaType: 'application/pdf',
              expiresAt,
            },
            body: bytes.slice(0, -1),
          };
        },
      }),
      request()
    ),
    'artifact_size_mismatch'
  );
});

test('same-size byte tampering is rejected by digest revalidation', async () => {
  const tampered = bytes.slice();
  tampered[tampered.byteLength - 1] ^= 1;

  await expectReadError(
    readVerifiedExtractionArtifact(
      port({
        async read() {
          return {
            metadata: {
              artifactId: artifact.artifactId,
              sizeBytes: tampered.byteLength,
              mediaType: 'application/pdf',
              expiresAt,
            },
            body: tampered,
          };
        },
      }),
      request()
    ),
    'artifact_digest_mismatch'
  );
});

test('shared C.3.3 artifact boundary contains no provider/storage implementation details', async () => {
  const sources = await Promise.all([
    readFile(new URL('../src/extraction/artifact-read.port.ts', import.meta.url), 'utf8'),
    readFile(new URL('../src/extraction/artifact-read.service.ts', import.meta.url), 'utf8'),
  ]);
  const forbidden = [
    'SupabaseClient',
    'signedUrl',
    'signed_url',
    'bucketName',
    'bucket_name',
    '@supabase',
    'service_role',
    'pdfplumber',
    'pdfjs',
    'tesseract',
    'Textract',
    'GoogleDocumentAI',
  ];

  for (const source of sources) {
    for (const token of forbidden) {
      assert.equal(source.includes(token), false, `implementation detail leaked: ${token}`);
    }
  }
});
