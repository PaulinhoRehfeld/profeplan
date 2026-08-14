import assert from 'node:assert/strict';
import test from 'node:test';
import { SupabaseTemporaryStagingAdapter } from '../src/index.ts';

const run = { kind: 'processing_run', id: 'processing-run-synthetic-1' };
const sourceVersion = { kind: 'source_version', id: 'source-version-synthetic-1' };
const receivedFile = { kind: 'received_file', id: 'received-file-synthetic-1' };
const bytes = new TextEncoder().encode('%PDF-1.7\nsynthetic');

function write(overrides = {}) {
  return {
    artifactId: 'artifact-synthetic-1',
    run,
    sourceVersion,
    receivedFile,
    bytes,
    mediaType: 'application/pdf',
    createdAt: '2026-08-14T21:00:00.000Z',
    expiresAt: '2026-08-15T03:00:00.000Z',
    correlationId: 'correlation-synthetic-1',
    ...overrides,
  };
}

function fakeContext(behavior = {}) {
  const objects = new Map();
  const calls = { upload: [], remove: [], list: [] };

  const bucket = {
    async upload(path, payload, options) {
      calls.upload.push({ path, payload, options });
      if (behavior.uploadError) return { data: null, error: behavior.uploadError };
      if (objects.has(path) && !options.upsert) {
        return { data: null, error: { status: 409, message: 'provider duplicate detail' } };
      }
      objects.set(path, payload);
      return { data: { path }, error: null };
    },
    async remove(paths) {
      calls.remove.push(paths);
      if (behavior.removeError) return { data: null, error: behavior.removeError };
      for (const path of paths) objects.delete(path);
      return { data: paths.map((name) => ({ name })), error: null };
    },
    async list(folder, options) {
      calls.list.push({ folder, options });
      if (behavior.listError) return { data: null, error: behavior.listError };
      if (behavior.keepAfterRemove) {
        return { data: [{ name: options.search }], error: null };
      }
      const prefix = `${folder}/`;
      const data = [...objects.keys()]
        .filter((path) => path.startsWith(prefix))
        .map((path) => ({ name: path.slice(prefix.length) }))
        .filter((item) => !options.search || item.name.includes(options.search));
      return { data, error: null };
    },
  };

  return {
    context: {
      correlationId: 'correlation-synthetic-1',
      client: { storage: { from: () => bucket } },
    },
    calls,
    objects,
  };
}

test('staging adapter writes without overwrite and returns only provider-neutral locator', async () => {
  const fake = fakeContext();
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'provider-private-bucket',
    now: () => '2026-08-14T21:02:00.000Z',
  });

  const descriptor = await adapter.stage(write());

  assert.equal(fake.calls.upload.length, 1);
  assert.equal(fake.calls.upload[0].options.upsert, false);
  assert.equal(
    descriptor.artifact.opaqueLocator,
    'temporary-staging:v1:processing-run-synthetic-1:artifact-synthetic-1'
  );
  assert.equal(descriptor.run.id, run.id);
  assert.equal(descriptor.sourceVersion.id, sourceVersion.id);
  assert.equal(descriptor.receivedFile.id, receivedFile.id);
  const serialized = JSON.stringify(descriptor);
  assert.equal(serialized.includes('provider-private-bucket'), false);
  assert.equal(serialized.includes('runs/'), false);
  assert.equal(serialized.includes('signed'), false);
});

test('provider object path is derived from encoded identities and never from an original filename', async () => {
  const fake = fakeContext();
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'private-test-bucket',
  });

  await adapter.stage(
    write({
      artifactId: 'artifact/../../synthetic',
      run: { kind: 'processing_run', id: 'run/../../other' },
    })
  );

  const path = fake.calls.upload[0].path;
  assert.equal(path.includes('/../'), false);
  assert.equal(path.includes('\\'), false);
  assert.match(path, /^runs\/.+\/artifacts\/.+$/u);
});

test('collision is translated to provider-neutral conflict and does not delete existing object', async () => {
  const fake = fakeContext({ uploadError: { status: 409, message: 'raw provider collision' } });
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'private-test-bucket',
  });

  await assert.rejects(
    adapter.stage(write()),
    (error) => error.code === 'CONFLICT' && !error.message.includes('raw provider collision')
  );
  assert.equal(fake.calls.remove.length, 0);
});

test('non-conflict staging failure performs best-effort cleanup without leaking provider detail', async () => {
  const fake = fakeContext({ uploadError: { message: 'network timeout with provider detail' } });
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'private-test-bucket',
  });

  await assert.rejects(
    adapter.stage(write()),
    (error) => error.code === 'UNAVAILABLE' && !error.message.includes('provider detail')
  );
  assert.equal(fake.calls.remove.length, 1);
});

test('discard rejects processing-run mismatch before touching the provider', async () => {
  const fake = fakeContext();
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'private-test-bucket',
  });
  const descriptor = await adapter.stage(write());
  fake.calls.remove.length = 0;

  await assert.rejects(
    adapter.discard({
      artifact: descriptor.artifact,
      run: { kind: 'processing_run', id: 'processing-run-other' },
      requestedAt: '2026-08-14T21:04:59.000Z',
      reasonCode: 'orphan_cleanup',
      correlationId: 'correlation-synthetic-1',
    }),
    (error) => error.code === 'INVALID_INPUT'
  );
  assert.equal(fake.calls.remove.length, 0);
});

test('discard verifies absence and returns an auditable provider-neutral receipt', async () => {
  const fake = fakeContext();
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'private-test-bucket',
    now: () => '2026-08-14T21:05:00.000Z',
  });
  const descriptor = await adapter.stage(write());

  const receipt = await adapter.discard({
    artifact: descriptor.artifact,
    run,
    requestedAt: '2026-08-14T21:04:59.000Z',
    reasonCode: 'operator_cancelled',
    correlationId: 'correlation-synthetic-1',
  });

  assert.equal(receipt.outcome, 'discarded');
  assert.equal(receipt.confirmedAt, '2026-08-14T21:05:00.000Z');
  assert.equal(fake.calls.list.length, 1);
  const serialized = JSON.stringify(receipt);
  assert.equal(serialized.includes('private-test-bucket'), false);
  assert.equal(serialized.includes('runs/'), false);
  assert.equal(serialized.includes('provider'), false);
});

test('discard can be repeated safely when the provider treats missing removal as success', async () => {
  const fake = fakeContext();
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'private-test-bucket',
    now: () => '2026-08-14T21:05:00.000Z',
  });
  const descriptor = await adapter.stage(write());
  const command = {
    artifact: descriptor.artifact,
    run,
    requestedAt: '2026-08-14T21:04:59.000Z',
    reasonCode: 'technical_failure',
    correlationId: 'correlation-synthetic-1',
  };

  const first = await adapter.discard(command);
  const second = await adapter.discard(command);

  assert.equal(first.outcome, 'discarded');
  assert.equal(second.outcome, 'discarded');
  assert.equal(fake.calls.remove.length, 2);
});

test('unverified deletion fails closed with sanitized error', async () => {
  const fake = fakeContext({ keepAfterRemove: true });
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'private-test-bucket',
  });
  const descriptor = await adapter.stage(write());

  await assert.rejects(
    adapter.discard({
      artifact: descriptor.artifact,
      run,
      requestedAt: '2026-08-14T21:04:59.000Z',
      reasonCode: 'orphan_cleanup',
      correlationId: 'correlation-synthetic-1',
    }),
    (error) => error.code === 'UNKNOWN' && error.message === 'Persistence operation failed (UNKNOWN)'
  );
});
