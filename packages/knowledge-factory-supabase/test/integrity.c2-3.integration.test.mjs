import assert from 'node:assert/strict';
import test from 'node:test';
import { createClient } from '@supabase/supabase-js';
import { evaluateStagingIntegrity } from '@profeplan/knowledge-factory';
import { SupabaseTemporaryStagingAdapter } from '../src/index.ts';

const required = ['KF_SUPABASE_URL', 'KF_SUPABASE_SERVICE_ROLE_KEY', 'KF_SUPABASE_ANON_KEY'];
const missing = required.filter((name) => !process.env[name]);
const integration = missing.length === 0 ? test : test.skip;

const bytes = new TextEncoder().encode('%PDF-1.7\nsynthetic');
const mutatedBytes = new TextEncoder().encode('%PDF-1.7\nsynthetiX');
const expectedDigest = '5aea7a7a5e33d66d021fd52802ceb64ac5b8f377b2be55fddca8607f093ce3ce';
const mutatedDigest = '6907739928b18f05c8bb5f75d22cf975d1d3fef1554b9a0838ac553f8d9327b9';

const runA = { kind: 'processing_run', id: 'processing-run-synthetic-c2-3-a' };
const runB = { kind: 'processing_run', id: 'processing-run-synthetic-c2-3-b' };
const sourceVersionA = { kind: 'source_version', id: 'source-version-synthetic-c2-3-a' };
const sourceVersionB = { kind: 'source_version', id: 'source-version-synthetic-c2-3-b' };

function write({ run, sourceVersion, receivedFileId, artifactId, payload = bytes }) {
  return {
    artifactId,
    run,
    sourceVersion,
    receivedFile: { kind: 'received_file', id: receivedFileId },
    bytes: payload,
    mediaType: 'application/pdf',
    createdAt: '2026-08-14T21:00:00.000Z',
    expiresAt: '2026-08-15T03:00:00.000Z',
    correlationId: 'correlation-synthetic-c2-3',
  };
}

function physicalPath(run, artifactId) {
  return `runs/${encodeURIComponent(run.id)}/artifacts/${encodeURIComponent(artifactId)}`;
}

integration('C.2.3 verifies readback digest, detects mutation and classifies binary duplication', async () => {
  const url = process.env.KF_SUPABASE_URL;
  const serviceRoleKey = process.env.KF_SUPABASE_SERVICE_ROLE_KEY;
  const anonKey = process.env.KF_SUPABASE_ANON_KEY;
  const runId = (process.env.GITHUB_RUN_ID ?? 'local').replace(/[^a-zA-Z0-9-]/gu, '').slice(-32);
  const bucketName = `kf-c2-3-${runId || 'local'}`.toLowerCase();

  const admin = createClient(url, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const anon = createClient(url, anonKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const create = await admin.storage.createBucket(bucketName, {
    public: false,
    fileSizeLimit: 1024 * 1024,
    allowedMimeTypes: ['application/pdf'],
  });
  assert.equal(create.error, null, create.error?.message);

  try {
    let now = '2026-08-14T21:05:00.000Z';
    const adapter = new SupabaseTemporaryStagingAdapter(
      { client: admin, correlationId: 'correlation-synthetic-c2-3' },
      { bucketName, now: () => now }
    );

    const descriptorA = await adapter.stage(
      write({
        run: runA,
        sourceVersion: sourceVersionA,
        receivedFileId: 'received-file-synthetic-c2-3-a',
        artifactId: 'artifact-synthetic-c2-3-a',
      })
    );

    const evidenceA = await adapter.verify({
      artifact: descriptorA,
      algorithm: 'sha-256',
      correlationId: 'correlation-synthetic-c2-3',
    });
    assert.equal(evidenceA.digest.value, expectedDigest);
    assert.equal(evidenceA.byteLength, bytes.byteLength);
    assert.equal(JSON.stringify(evidenceA).includes(bucketName), false);

    const verifiedA = evaluateStagingIntegrity({
      artifact: descriptorA,
      evidence: evidenceA,
      evaluatedAt: '2026-08-14T21:05:01.000Z',
    });
    assert.equal(verifiedA.allowed, true);
    assert.equal(verifiedA.value.state, 'VERIFIED');
    assert.equal(verifiedA.value.duplicateDecision.outcome, 'unique');

    const pathA = physicalPath(runA, descriptorA.artifact.artifactId);
    const anonymousRead = await anon.storage.from(bucketName).download(pathA);
    assert.notEqual(anonymousRead.error, null);

    const mutation = await admin.storage.from(bucketName).update(pathA, mutatedBytes, {
      contentType: 'application/pdf',
      upsert: true,
    });
    assert.equal(mutation.error, null, mutation.error?.message);

    now = '2026-08-14T21:06:00.000Z';
    const mutatedEvidence = await adapter.verify({
      artifact: descriptorA,
      algorithm: 'sha-256',
      correlationId: 'correlation-synthetic-c2-3',
    });
    assert.equal(mutatedEvidence.digest.value, mutatedDigest);
    assert.equal(mutatedEvidence.byteLength, bytes.byteLength);

    const mutationDecision = evaluateStagingIntegrity({
      artifact: descriptorA,
      evidence: mutatedEvidence,
      knownEvidence: [evidenceA],
      evaluatedAt: '2026-08-14T21:06:01.000Z',
    });
    assert.equal(mutationDecision.allowed, false);
    assert.equal(
      mutationDecision.reasons.some((item) => item.code === 'STAGING_INTEGRITY_DIGEST_CONFLICT'),
      true
    );

    const descriptorB = await adapter.stage(
      write({
        run: runB,
        sourceVersion: sourceVersionB,
        receivedFileId: 'received-file-synthetic-c2-3-b',
        artifactId: 'artifact-synthetic-c2-3-b',
      })
    );
    now = '2026-08-14T21:07:00.000Z';
    const evidenceB = await adapter.verify({
      artifact: descriptorB,
      algorithm: 'sha-256',
      correlationId: 'correlation-synthetic-c2-3',
    });

    const duplicateDecision = evaluateStagingIntegrity({
      artifact: descriptorB,
      evidence: evidenceB,
      knownEvidence: [evidenceA],
      evaluatedAt: '2026-08-14T21:07:01.000Z',
    });
    assert.equal(duplicateDecision.allowed, true);
    assert.equal(duplicateDecision.value.duplicateDecision.outcome, 'duplicate');
    assert.equal(
      duplicateDecision.value.duplicateDecision.matches[0].relationship,
      'cross_source_version'
    );
    assert.equal(duplicateDecision.value.sourceVersion.id, sourceVersionB.id);
    assert.equal(duplicateDecision.value.integrity.digest.value, expectedDigest);
  } finally {
    await admin.storage.emptyBucket(bucketName);
    const deleted = await admin.storage.deleteBucket(bucketName);
    assert.equal(deleted.error, null, deleted.error?.message);
  }
});
