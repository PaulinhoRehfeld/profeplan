import assert from 'node:assert/strict';
import test from 'node:test';
import { createClient } from '@supabase/supabase-js';
import { evaluateStagingRecoveryProbe } from '@profeplan/knowledge-factory';
import { SupabaseTemporaryStagingAdapter } from '../src/index.ts';

const required = ['KF_SUPABASE_URL', 'KF_SUPABASE_SERVICE_ROLE_KEY'];
const missing = required.filter((name) => !process.env[name]);
const integration = missing.length === 0 ? test : test.skip;

const bytes = new TextEncoder().encode('%PDF-1.7\nsynthetic');
const expectedDigest = '5aea7a7a5e33d66d021fd52802ceb64ac5b8f377b2be55fddca8607f093ce3ce';
const run = { kind: 'processing_run', id: 'processing-run-synthetic-c2-4' };
const sourceVersion = { kind: 'source_version', id: 'source-version-synthetic-c2-4' };
const receivedFile = { kind: 'received_file', id: 'received-file-synthetic-c2-4' };
const artifactId = 'artifact-synthetic-c2-4';
const correlationId = 'correlation-synthetic-c2-4';

integration('C.2.4 reconciles a real disposable Storage object and makes cleanup physically idempotent', async () => {
  const admin = createClient(process.env.KF_SUPABASE_URL, process.env.KF_SUPABASE_SERVICE_ROLE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const runId = (process.env.GITHUB_RUN_ID ?? 'local').replace(/[^a-zA-Z0-9-]/gu, '').slice(-32);
  const bucketName = `kf-c2-4-${runId || 'local'}`.toLowerCase();
  const created = await admin.storage.createBucket(bucketName, {
    public: false,
    fileSizeLimit: 1024 * 1024,
    allowedMimeTypes: ['application/pdf'],
  });
  assert.equal(created.error, null, created.error?.message);

  try {
    let now = '2026-08-15T01:10:00.000Z';
    const adapter = new SupabaseTemporaryStagingAdapter(
      { client: admin, correlationId },
      { bucketName, now: () => now }
    );
    const write = {
      artifactId,
      run,
      sourceVersion,
      receivedFile,
      bytes,
      mediaType: 'application/pdf',
      createdAt: '2026-08-15T01:09:00.000Z',
      expiresAt: '2026-08-15T07:09:00.000Z',
      correlationId,
    };

    const before = await adapter.inspect({ artifactId, run, correlationId });
    assert.equal(before.outcome, 'absent');
    const staged = await adapter.stage(write);
    const observed = await adapter.inspect({ artifactId, run, correlationId });
    assert.equal(observed.outcome, 'present');
    assert.equal(observed.observedDigest.value, expectedDigest);
    assert.equal(observed.observedSizeBytes, bytes.byteLength);

    const recovery = evaluateStagingRecoveryProbe({
      preparation: {
        artifactId,
        run,
        sourceVersion,
        receivedFile,
        sizeBytes: bytes.byteLength,
        mediaType: 'application/pdf',
        createdAt: write.createdAt,
        expiresAt: write.expiresAt,
        writeIntentDigest: { algorithm: 'sha-256', value: expectedDigest },
        correlationId,
      },
      probe: observed,
      evaluatedAt: '2026-08-15T01:11:00.000Z',
    });
    assert.equal(recovery.allowed, true);
    assert.equal(recovery.value?.outcome, 'reuse_existing');

    now = '2026-08-15T01:12:00.000Z';
    const discardCommand = {
      artifact: staged.artifact,
      run,
      requestedAt: '2026-08-15T01:11:30.000Z',
      reasonCode: 'technical_failure',
      correlationId,
    };
    const first = await adapter.discard(discardCommand);
    assert.equal(first.outcome, 'discarded');
    const absent = await adapter.inspect({ artifactId, run, correlationId });
    assert.equal(absent.outcome, 'absent');
    const second = await adapter.discard(discardCommand);
    assert.equal(second.outcome, 'already_discarded');
    assert.equal(JSON.stringify(second).includes(bucketName), false);
  } finally {
    await admin.storage.emptyBucket(bucketName);
    const deleted = await admin.storage.deleteBucket(bucketName);
    assert.equal(deleted.error, null, deleted.error?.message);
  }
});
