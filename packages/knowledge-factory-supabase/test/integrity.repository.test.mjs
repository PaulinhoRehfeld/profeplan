import assert from 'node:assert/strict';
import test from 'node:test';
import { SupabaseTemporaryStagingAdapter } from '../src/index.ts';

const run = { kind: 'processing_run', id: 'processing-run-integrity-1' };
const sourceVersion = { kind: 'source_version', id: 'source-version-integrity-1' };
const receivedFile = { kind: 'received_file', id: 'received-file-integrity-1' };
const bytes = new TextEncoder().encode('%PDF-1.7\nsynthetic');
const expectedDigest = '5aea7a7a5e33d66d021fd52802ceb64ac5b8f377b2be55fddca8607f093ce3ce';
const mutatedDigest = '6907739928b18f05c8bb5f75d22cf975d1d3fef1554b9a0838ac553f8d9327b9';

function write(overrides = {}) {
  return {
    artifactId: 'artifact-integrity-1',
    run,
    sourceVersion,
    receivedFile,
    bytes,
    mediaType: 'application/pdf',
    createdAt: '2026-08-14T21:00:00.000Z',
    expiresAt: '2026-08-15T03:00:00.000Z',
    correlationId: 'correlation-integrity-1',
    ...overrides,
  };
}

function fakeContext(behavior = {}) {
  const objects = new Map();
  const calls = { upload: [], download: [], remove: [], list: [] };

  const bucket = {
    async upload(path, payload, options) {
      calls.upload.push({ path, payload, options });
      objects.set(path, new Uint8Array(payload));
      return { data: { path }, error: null };
    },
    async download(path) {
      calls.download.push(path);
      if (behavior.downloadError) return { data: null, error: behavior.downloadError };
      const payload = objects.get(path);
      if (payload === undefined) {
        return { data: null, error: { status: 404, message: 'provider object missing' } };
      }
      return { data: new Blob([payload]), error: null };
    },
    async remove(paths) {
      calls.remove.push(paths);
      for (const path of paths) objects.delete(path);
      return { data: [], error: null };
    },
    async list(folder, options) {
      calls.list.push({ folder, options });
      const prefix = `${folder}/`;
      const data = [...objects.keys()]
        .filter((path) => path.startsWith(prefix))
        .map((path) => ({ name: path.slice(prefix.length) }));
      return { data, error: null };
    },
  };

  return {
    context: {
      correlationId: 'correlation-integrity-1',
      client: { storage: { from: () => bucket } },
    },
    calls,
    objects,
  };
}

function physicalPath(runRef = run, artifactId = 'artifact-integrity-1') {
  return `runs/${encodeURIComponent(runRef.id)}/artifacts/${encodeURIComponent(artifactId)}`;
}

test('integrity adapter hashes bytes read back from private staging', async () => {
  const fake = fakeContext();
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'provider-private-bucket',
    now: () => '2026-08-14T21:05:00.000Z',
  });
  const descriptor = await adapter.stage(write());

  const evidence = await adapter.verify({
    artifact: descriptor,
    algorithm: 'sha-256',
    correlationId: 'correlation-integrity-1',
  });

  assert.equal(fake.calls.download.length, 1);
  assert.equal(evidence.digest.algorithm, 'sha-256');
  assert.equal(evidence.digest.value, expectedDigest);
  assert.equal(evidence.byteLength, bytes.byteLength);
  assert.equal(evidence.verifiedAt, '2026-08-14T21:05:00.000Z');
  assert.equal(evidence.artifactId, descriptor.artifact.artifactId);
  assert.equal(evidence.run.id, run.id);
  assert.equal(evidence.sourceVersion.id, sourceVersion.id);
  assert.equal(evidence.receivedFile.id, receivedFile.id);

  const serialized = JSON.stringify(evidence);
  assert.equal(serialized.includes('provider-private-bucket'), false);
  assert.equal(serialized.includes('runs/'), false);
  assert.equal(serialized.includes('temporary-staging:v1:'), false);
});

test('digest follows stored readback even when bytes change after staging', async () => {
  const fake = fakeContext();
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'provider-private-bucket',
    now: () => '2026-08-14T21:05:00.000Z',
  });
  const descriptor = await adapter.stage(write());

  fake.objects.set(physicalPath(), new TextEncoder().encode('%PDF-1.7\nsynthetiX'));

  const evidence = await adapter.verify({
    artifact: descriptor,
    algorithm: 'sha-256',
    correlationId: 'correlation-integrity-1',
  });

  assert.equal(evidence.digest.value, mutatedDigest);
  assert.notEqual(evidence.digest.value, expectedDigest);
  assert.equal(evidence.byteLength, bytes.byteLength);
});

test('locator mismatch fails before any provider readback', async () => {
  const fake = fakeContext();
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'provider-private-bucket',
  });
  const descriptor = await adapter.stage(write());
  const forged = {
    ...descriptor,
    artifact: { ...descriptor.artifact, opaqueLocator: 'temporary-staging:v1:forged' },
  };

  await assert.rejects(
    adapter.verify({
      artifact: forged,
      algorithm: 'sha-256',
      correlationId: 'correlation-integrity-1',
    }),
    (error) => error.code === 'INVALID_INPUT'
  );
  assert.equal(fake.calls.download.length, 0);
});

test('unsupported digest algorithm fails closed before provider access', async () => {
  const fake = fakeContext();
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'provider-private-bucket',
  });
  const descriptor = await adapter.stage(write());

  await assert.rejects(
    adapter.verify({
      artifact: descriptor,
      algorithm: 'md5',
      correlationId: 'correlation-integrity-1',
    }),
    (error) => error.code === 'INVALID_INPUT'
  );
  assert.equal(fake.calls.download.length, 0);
});

test('provider download failures are translated without raw detail leakage', async () => {
  const fake = fakeContext({
    downloadError: { status: 503, message: 'raw provider readback failure secret-detail' },
  });
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'provider-private-bucket',
  });
  const descriptor = await adapter.stage(write());

  await assert.rejects(
    adapter.verify({
      artifact: descriptor,
      algorithm: 'sha-256',
      correlationId: 'correlation-integrity-1',
    }),
    (error) =>
      error.code === 'UNAVAILABLE' &&
      error.message === 'Persistence operation failed (UNAVAILABLE)' &&
      !error.message.includes('secret-detail')
  );
});
