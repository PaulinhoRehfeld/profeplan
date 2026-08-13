import assert from 'node:assert/strict';
import test from 'node:test';
import { SupabaseClient } from '@supabase/supabase-js';
import { SupabaseKnowledgeSourceRepository } from '../src/index.ts';

const SUPABASE_URL = process.env.KF_SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.KF_SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  throw new Error('Disposable Supabase credentials were not provided to the integration test');
}

const client = new SupabaseClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
  auth: {
    persistSession: false,
    autoRefreshToken: false,
    detectSessionInUrl: false,
  },
});
const repository = new SupabaseKnowledgeSourceRepository({
  client,
  correlationId: '86000000-0000-4000-8000-000000000006',
});

const SOURCE_A_ID = '87000000-0000-4000-8000-000000000007';
const SOURCE_B_ID = '88000000-0000-4000-8000-000000000008';

const SOURCE_A = {
  id: SOURCE_A_ID,
  version: '1.0.0',
  title: 'Synthetic source A',
  sourceType: 'open_content',
  status: 'draft',
  licenseCategory: 'open',
  allowedUses: ['retrieval'],
  provenanceUri: 'https://example.invalid/source-a',
  createdAt: '2026-08-07T12:00:00.000Z',
  updatedAt: '2026-08-07T12:00:00.000Z',
};

const SOURCE_B = {
  id: SOURCE_B_ID,
  version: '1.0.0',
  title: 'Synthetic source B',
  sourceType: 'open_content',
  status: 'draft',
  licenseCategory: 'open',
  allowedUses: ['retrieval'],
  createdAt: '2026-08-07T12:00:00.000Z',
  updatedAt: '2026-08-07T12:00:00.000Z',
};

function assertEquivalentSource(actual, expected) {
  const { createdAt: actualCreatedAt, updatedAt: actualUpdatedAt, ...actualFields } = actual;
  const {
    createdAt: expectedCreatedAt,
    updatedAt: expectedUpdatedAt,
    ...expectedFields
  } = expected;

  assert.deepEqual(actualFields, expectedFields);
  assert.equal(Date.parse(actualCreatedAt), Date.parse(expectedCreatedAt));
  assert.equal(Date.parse(actualUpdatedAt), Date.parse(expectedUpdatedAt));
}

test('KnowledgeSourceRepository saves, updates and finds synthetic sources', async () => {
  await repository.save(SOURCE_A);
  await repository.save(SOURCE_B);

  assertEquivalentSource(await repository.findById(SOURCE_A_ID), SOURCE_A);
  assertEquivalentSource(await repository.findById(SOURCE_B_ID), SOURCE_B);
  assert.equal(await repository.findById('89000000-0000-4000-8000-000000000009'), null);

  const updated = {
    ...SOURCE_A,
    title: 'Synthetic source A approved',
    status: 'approved',
    allowedUses: ['retrieval', 'generation'],
    updatedAt: '2026-08-07T13:00:00.000Z',
  };
  await repository.save(updated);
  assertEquivalentSource(await repository.findById(SOURCE_A_ID), updated);
});

test('KnowledgeSourceRepository reads one version and ordered isolated permission history', async () => {
  const { error: versionError } = await client.from('kf_source_versions').insert([
    {
      id: '8a000000-0000-4000-8000-00000000000a',
      version: '2026.1',
      source_id: SOURCE_A_ID,
      checksum: 'sha256:source-a-v1',
      effective_at: '2026-08-07T14:00:00.000Z',
    },
    {
      id: '8b000000-0000-4000-8000-00000000000b',
      version: '2026.1',
      source_id: SOURCE_B_ID,
      checksum: 'sha256:source-b-v1',
      effective_at: '2026-08-07T14:00:00.000Z',
    },
  ]);
  assert.equal(versionError, null);

  const { error: eventError } = await client.from('kf_source_permission_events').insert([
    {
      id: '8c000000-0000-4000-8000-00000000000c',
      version: '1',
      source_id: SOURCE_A_ID,
      action: 'block',
      use_type: 'generation',
      reason: 'Synthetic later event',
      occurred_at: '2026-08-07T16:00:00.000Z',
    },
    {
      id: '8d000000-0000-4000-8000-00000000000d',
      version: '1',
      source_id: SOURCE_B_ID,
      action: 'grant',
      use_type: 'retrieval',
      reason: 'Synthetic other source event',
      occurred_at: '2026-08-07T15:30:00.000Z',
    },
    {
      id: '8e000000-0000-4000-8000-00000000000e',
      version: '1',
      source_id: SOURCE_A_ID,
      action: 'grant',
      use_type: 'retrieval',
      reason: 'Synthetic earlier event',
      occurred_at: '2026-08-07T15:00:00.000Z',
    },
  ]);
  assert.equal(eventError, null);

  const sourceVersion = await repository.findVersion(SOURCE_A_ID, '2026.1');
  assert.equal(sourceVersion?.sourceId, SOURCE_A_ID);
  assert.equal(sourceVersion?.checksum, 'sha256:source-a-v1');
  assert.equal(await repository.findVersion(SOURCE_A_ID, 'missing'), null);

  const sourceAEvents = await repository.listPermissionEvents(SOURCE_A_ID);
  const sourceBEvents = await repository.listPermissionEvents(SOURCE_B_ID);
  assert.deepEqual(
    sourceAEvents.map((event) => [event.sourceId, event.action, Date.parse(event.occurredAt)]),
    [
      [SOURCE_A_ID, 'grant', Date.parse('2026-08-07T15:00:00.000Z')],
      [SOURCE_A_ID, 'block', Date.parse('2026-08-07T16:00:00.000Z')],
    ]
  );
  assert.equal(sourceBEvents.length, 1);
  assert.equal(sourceBEvents[0].sourceId, SOURCE_B_ID);
});
