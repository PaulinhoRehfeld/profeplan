import assert from 'node:assert/strict';
import test from 'node:test';
import { createClient } from '@supabase/supabase-js';
import { SupabaseTemporaryStagingAdapter } from '../src/index.ts';

const required = ['KF_SUPABASE_URL', 'KF_SUPABASE_SERVICE_ROLE_KEY', 'KF_SUPABASE_ANON_KEY'];
const missing = required.filter((name) => !process.env[name]);

const integration = missing.length === 0 ? test : test.skip;

const sourceVersion = { kind: 'source_version', id: 'source-version-synthetic-c2-2' };
const receivedFile = { kind: 'received_file', id: 'received-file-synthetic-c2-2' };
const runA = { kind: 'processing_run', id: 'processing-run-synthetic-a' };
const runB = { kind: 'processing_run', id: 'processing-run-synthetic-b' };
const bytes = new TextEncoder().encode('%PDF-1.7\nsynthetic disposable integration fixture');

function write(run, artifactId) {
  return {
    artifactId,
    run,
    sourceVersion,
    receivedFile,
    bytes,
    mediaType: 'application/pdf',
    createdAt: '2026-08-14T21:00:00.000Z',
    expiresAt: '2026-08-15T03:00:00.000Z',
    correlationId: 'correlation-synthetic-c2-2',
  };
}

function physicalPath(run, artifactId) {
  return `runs/${encodeURIComponent(run.id)}/artifacts/${encodeURIComponent(artifactId)}`;
}

integration('C.2.2 stages and discards synthetic bytes in disposable Supabase Storage only', async () => {
  const url = process.env.KF_SUPABASE_URL;
  const serviceRoleKey = process.env.KF_SUPABASE_SERVICE_ROLE_KEY;
  const anonKey = process.env.KF_SUPABASE_ANON_KEY;
  const runId = (process.env.GITHUB_RUN_ID ?? 'local').replace(/[^a-zA-Z0-9-]/gu, '').slice(-32);
  const bucketName = `kf-c2-2-${runId || 'local'}`.toLowerCase();

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
    const adapter = new SupabaseTemporaryStagingAdapter(
      { client: admin, correlationId: 'correlation-synthetic-c2-2' },
      { bucketName, now: () => '2026-08-14T21:05:00.000Z' }
    );

    const artifactId = 'artifact-synthetic-c2-2';
    const path = physicalPath(runA, artifactId);
    const descriptorA = await adapter.stage(write(runA, artifactId));
    assert.equal(descriptorA.state, 'STAGED');
    assert.equal(
      descriptorA.artifact.opaqueLocator,
      `temporary-staging:v1:${encodeURIComponent(runA.id)}:${encodeURIComponent(artifactId)}`
    );
    assert.equal(JSON.stringify(descriptorA).includes(bucketName), false);

    const downloaded = await admin.storage.from(bucketName).download(path);
    assert.equal(downloaded.error, null, downloaded.error?.message);
    assert.deepEqual(new Uint8Array(await downloaded.data.arrayBuffer()), bytes);

    await assert.rejects(
      adapter.stage(write(runA, artifactId)),
      (error) => error.code === 'CONFLICT'
    );

    const unauthorizedUpload = await anon.storage
      .from(bucketName)
      .upload('unauthorized/synthetic.pdf', bytes, { contentType: 'application/pdf', upsert: false });
    assert.notEqual(unauthorizedUpload.error, null);

    const unauthorizedDownload = await anon.storage.from(bucketName).download(path);
    assert.notEqual(unauthorizedDownload.error, null);

    const unauthorizedList = await anon.storage
      .from(bucketName)
      .list(`runs/${encodeURIComponent(runA.id)}/artifacts`, {
        search: encodeURIComponent(artifactId),
        limit: 2,
      });
    assert.equal(
      unauthorizedList.error !== null ||
        !unauthorizedList.data.some((item) => item.name === encodeURIComponent(artifactId)),
      true
    );

    // Supabase Storage may represent an RLS-blocked delete as a successful no-op.
    // The security invariant is that an anonymous caller cannot alter the staged object.
    await anon.storage.from(bucketName).remove([path]);

    const afterUnauthorizedRemove = await admin.storage.from(bucketName).download(path);
    assert.equal(afterUnauthorizedRemove.error, null, afterUnauthorizedRemove.error?.message);
    assert.deepEqual(new Uint8Array(await afterUnauthorizedRemove.data.arrayBuffer()), bytes);

    await assert.rejects(
      adapter.discard({
        artifact: descriptorA.artifact,
        run: runB,
        requestedAt: '2026-08-14T21:02:00.000Z',
        reasonCode: 'orphan_cleanup',
        correlationId: 'correlation-synthetic-c2-2',
      }),
      (error) => error.code === 'INVALID_INPUT'
    );

    const stillPresent = await admin.storage.from(bucketName).download(path);
    assert.equal(stillPresent.error, null, stillPresent.error?.message);
    assert.deepEqual(new Uint8Array(await stillPresent.data.arrayBuffer()), bytes);

    const discard = await adapter.discard({
      artifact: descriptorA.artifact,
      run: runA,
      requestedAt: '2026-08-14T21:04:59.000Z',
      reasonCode: 'operator_cancelled',
      correlationId: 'correlation-synthetic-c2-2',
    });
    assert.equal(discard.state, 'DISCARDED');
    assert.equal(discard.outcome, 'discarded');
    assert.equal(discard.confirmedAt, '2026-08-14T21:05:00.000Z');
    assert.equal(JSON.stringify(discard).includes(bucketName), false);

    const afterDiscard = await admin.storage.from(bucketName).list(
      `runs/${encodeURIComponent(runA.id)}/artifacts`,
      { search: encodeURIComponent(artifactId), limit: 2 }
    );
    assert.equal(afterDiscard.error, null, afterDiscard.error?.message);
    assert.equal(afterDiscard.data.some((item) => item.name === encodeURIComponent(artifactId)), false);

    const repeated = await adapter.discard({
      artifact: descriptorA.artifact,
      run: runA,
      requestedAt: '2026-08-14T21:05:01.000Z',
      reasonCode: 'operator_cancelled',
      correlationId: 'correlation-synthetic-c2-2',
    });
    assert.equal(repeated.state, 'DISCARDED');
    assert.equal(repeated.outcome, 'already_discarded');
  } finally {
    await admin.storage.emptyBucket(bucketName);
    const deleted = await admin.storage.deleteBucket(bucketName);
    assert.equal(deleted.error, null, deleted.error?.message);
  }
});
