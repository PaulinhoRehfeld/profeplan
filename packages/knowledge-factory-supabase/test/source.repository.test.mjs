import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  KNOWLEDGE_SOURCE_COLUMNS,
  SOURCE_PERMISSION_EVENT_COLUMNS,
  SOURCE_VERSION_COLUMNS,
  KnowledgeFactoryPersistenceError,
  SupabaseKnowledgeSourceRepository,
  knowledgeSourceToRow,
  sourcePermissionEventRowToSourcePermissionEvent,
  sourceRowToKnowledgeSource,
  sourceVersionRowToSourceVersion,
} from '../src/index.ts';

const SOURCE_ID = '81000000-0000-4000-8000-000000000001';
const VERSION_ID = '82000000-0000-4000-8000-000000000002';
const EVENT_ID = '83000000-0000-4000-8000-000000000003';

const SOURCE = Object.freeze({
  id: SOURCE_ID,
  version: '1.0.0',
  title: 'Synthetic approved source',
  sourceType: 'open_content',
  status: 'approved',
  licenseCategory: 'open',
  allowedUses: Object.freeze(['retrieval', 'generation']),
  provenanceUri: 'https://example.invalid/source',
  createdAt: '2026-08-07T12:00:00.000Z',
  updatedAt: '2026-08-07T12:30:00.000Z',
});

const SOURCE_ROW = Object.freeze({
  id: SOURCE.id,
  version: SOURCE.version,
  title: SOURCE.title,
  source_type: SOURCE.sourceType,
  status: SOURCE.status,
  license_category: SOURCE.licenseCategory,
  allowed_uses: SOURCE.allowedUses,
  provenance_uri: SOURCE.provenanceUri,
  created_at: SOURCE.createdAt,
  updated_at: SOURCE.updatedAt,
});

const VERSION_ROW = Object.freeze({
  id: VERSION_ID,
  version: '2026.1',
  source_id: SOURCE_ID,
  checksum: 'sha256:synthetic',
  effective_at: '2026-08-07T13:00:00+00:00',
  supersedes_version: null,
});

const EVENT_ROW = Object.freeze({
  id: EVENT_ID,
  version: '1',
  source_id: SOURCE_ID,
  action: 'grant',
  use_type: 'retrieval',
  reason: 'Synthetic permission evidence',
  occurred_at: '2026-08-07T14:00:00.000Z',
});

function createClientDouble({ responses = {}, failures = {}, upsertResponse } = {}) {
  const calls = [];
  const defaults = {
    kf_sources: { data: SOURCE_ROW, error: null },
    kf_source_versions: { data: VERSION_ROW, error: null },
    kf_source_permission_events: { data: [EVENT_ROW], error: null },
  };

  const client = {
    secret: 'service-role-must-never-be-logged',
    from(table) {
      calls.push(['from', table]);
      return {
        select(columns) {
          calls.push(['select', table, columns]);
          const builder = {
            eq(column, value) {
              calls.push(['eq', table, column, value]);
              return builder;
            },
            order(column, options) {
              calls.push(['order', table, column, options]);
              return builder;
            },
            maybeSingle() {
              calls.push(['maybeSingle', table]);
              if (failures[table]) return Promise.reject(failures[table]);
              return Promise.resolve(responses[table] ?? defaults[table]);
            },
            then(onFulfilled, onRejected) {
              const result = failures[table]
                ? Promise.reject(failures[table])
                : Promise.resolve(responses[table] ?? defaults[table]);
              return result.then(onFulfilled, onRejected);
            },
          };
          return builder;
        },
        upsert(payload, options) {
          calls.push(['upsert', table, payload, options]);
          return {
            select(columns) {
              calls.push(['upsert.select', table, columns]);
              return {
                single() {
                  calls.push(['single', table]);
                  if (failures.upsert) return Promise.reject(failures.upsert);
                  return Promise.resolve(
                    upsertResponse ?? responses.upsert ?? { data: SOURCE_ROW, error: null }
                  );
                },
              };
            },
          };
        },
      };
    },
  };

  return { client, calls };
}

function createRepository(client, entries = []) {
  return new SupabaseKnowledgeSourceRepository(
    { client, correlationId: '84000000-0000-4000-8000-000000000004' },
    {
      record(entry) {
        entries.push(entry);
      },
    }
  );
}

async function assertPersistenceCode(promise, code) {
  await assert.rejects(promise, (error) => {
    assert.ok(error instanceof KnowledgeFactoryPersistenceError);
    assert.equal(error.code, code);
    assert.doesNotMatch(error.message, /23505|42501|permission denied|service.role/i);
    return true;
  });
}

function assertInvalidMapper(action) {
  assert.throws(action, (error) => {
    assert.ok(error instanceof KnowledgeFactoryPersistenceError);
    assert.equal(error.code, 'INVALID_RESPONSE');
    return true;
  });
}

test('source mappers round-trip the three existing contracts', () => {
  assert.deepEqual(knowledgeSourceToRow(SOURCE), SOURCE_ROW);
  assert.deepEqual(sourceRowToKnowledgeSource(SOURCE_ROW), SOURCE);
  assert.deepEqual(sourceVersionRowToSourceVersion(VERSION_ROW), {
    id: VERSION_ROW.id,
    version: VERSION_ROW.version,
    sourceId: VERSION_ROW.source_id,
    checksum: VERSION_ROW.checksum,
    effectiveAt: VERSION_ROW.effective_at,
  });
  assert.deepEqual(sourcePermissionEventRowToSourcePermissionEvent(EVENT_ROW), {
    id: EVENT_ROW.id,
    version: EVENT_ROW.version,
    sourceId: EVENT_ROW.source_id,
    action: EVENT_ROW.action,
    use: EVENT_ROW.use_type,
    reason: EVENT_ROW.reason,
    occurredAt: EVENT_ROW.occurred_at,
  });
});

test('source mapper translates optional SQL nulls without inventing contract fields', () => {
  const source = sourceRowToKnowledgeSource({
    ...SOURCE_ROW,
    provenance_uri: null,
  });
  const sourceVersion = sourceVersionRowToSourceVersion({
    ...VERSION_ROW,
    supersedes_version: null,
  });
  assert.ok(!('provenanceUri' in source));
  assert.ok(!('supersedesVersion' in sourceVersion));
  assert.equal(knowledgeSourceToRow({ ...SOURCE, provenanceUri: undefined }).provenance_uri, null);
});

test('source mappers reject invalid enums, arrays and timestamps', () => {
  for (const row of [
    { ...SOURCE_ROW, source_type: 'invented' },
    { ...SOURCE_ROW, allowed_uses: ['retrieval', 'invented'] },
    { ...SOURCE_ROW, created_at: '2026-02-30T12:00:00Z' },
    { ...VERSION_ROW, effective_at: '2026-08-07' },
    { ...EVENT_ROW, action: 'edit' },
    { ...EVENT_ROW, occurred_at: '2026-08-07T24:00:00Z' },
  ]) {
    if ('source_type' in row || 'allowed_uses' in row || 'created_at' in row) {
      assertInvalidMapper(() => sourceRowToKnowledgeSource(row));
    } else if ('effective_at' in row) {
      assertInvalidMapper(() => sourceVersionRowToSourceVersion(row));
    } else {
      assertInvalidMapper(() => sourcePermissionEventRowToSourcePermissionEvent(row));
    }
  }
});

test('findById filters by id, selects explicit columns and maps the row', async () => {
  const { client, calls } = createClientDouble();
  assert.deepEqual(await createRepository(client).findById(SOURCE_ID), SOURCE);
  assert.deepEqual(calls, [
    ['from', 'kf_sources'],
    ['select', 'kf_sources', KNOWLEDGE_SOURCE_COLUMNS],
    ['eq', 'kf_sources', 'id', SOURCE_ID],
    ['maybeSingle', 'kf_sources'],
  ]);
});

test('findById and findVersion return null only for an absent row', async () => {
  const { client } = createClientDouble({
    responses: {
      kf_sources: { data: null, error: null },
      kf_source_versions: { data: null, error: null },
    },
  });
  const repository = createRepository(client);
  assert.equal(await repository.findById(SOURCE_ID), null);
  assert.equal(await repository.findVersion(SOURCE_ID, 'missing'), null);
});

test('findVersion applies source and version filters before maybeSingle', async () => {
  const { client, calls } = createClientDouble();
  const result = await createRepository(client).findVersion(SOURCE_ID, VERSION_ROW.version);
  assert.equal(result?.id, VERSION_ID);
  assert.deepEqual(calls, [
    ['from', 'kf_source_versions'],
    ['select', 'kf_source_versions', SOURCE_VERSION_COLUMNS],
    ['eq', 'kf_source_versions', 'source_id', SOURCE_ID],
    ['eq', 'kf_source_versions', 'version', VERSION_ROW.version],
    ['maybeSingle', 'kf_source_versions'],
  ]);
});

test('listPermissionEvents filters by source and uses deterministic ordering', async () => {
  const secondEvent = {
    ...EVENT_ROW,
    id: '85000000-0000-4000-8000-000000000005',
    action: 'block',
    occurred_at: '2026-08-07T15:00:00.000Z',
  };
  const { client, calls } = createClientDouble({
    responses: {
      kf_source_permission_events: {
        data: [EVENT_ROW, secondEvent],
        error: null,
      },
    },
  });
  const events = await createRepository(client).listPermissionEvents(SOURCE_ID);
  assert.equal(events.length, 2);
  assert.deepEqual(
    calls.filter(([operation]) => operation === 'order'),
    [
      ['order', 'kf_source_permission_events', 'occurred_at', { ascending: true }],
      ['order', 'kf_source_permission_events', 'id', { ascending: true }],
    ]
  );
  assert.deepEqual(
    calls.find(([operation]) => operation === 'eq'),
    ['eq', 'kf_source_permission_events', 'source_id', SOURCE_ID]
  );
});

test('listPermissionEvents accepts an empty array but rejects null data', async () => {
  const empty = createClientDouble({
    responses: { kf_source_permission_events: { data: [], error: null } },
  });
  assert.deepEqual(await createRepository(empty.client).listPermissionEvents(SOURCE_ID), []);

  const malformed = createClientDouble({
    responses: { kf_source_permission_events: { data: null, error: null } },
  });
  await assertPersistenceCode(
    createRepository(malformed.client).listPermissionEvents(SOURCE_ID),
    'INVALID_RESPONSE'
  );
});

test('save upserts only kf_sources by id and validates the returned row', async () => {
  const { client, calls } = createClientDouble();
  await createRepository(client).save(SOURCE);
  assert.deepEqual(calls, [
    ['from', 'kf_sources'],
    ['upsert', 'kf_sources', SOURCE_ROW, { onConflict: 'id' }],
    ['upsert.select', 'kf_sources', KNOWLEDGE_SOURCE_COLUMNS],
    ['single', 'kf_sources'],
  ]);
});

for (const [providerError, expectedCode] of [
  [{ code: '23505', message: 'duplicate detail' }, 'CONFLICT'],
  [{ code: '23503' }, 'CONSTRAINT_VIOLATION'],
  [{ code: '23514' }, 'CONSTRAINT_VIOLATION'],
  [{ code: '23502' }, 'CONSTRAINT_VIOLATION'],
  [{ code: '42501', message: 'permission denied for table' }, 'FORBIDDEN'],
  [{ status: 401, message: 'JWT missing' }, 'UNAUTHORIZED'],
  [{ code: 'unexpected', message: 'provider detail' }, 'UNKNOWN'],
]) {
  test(`source adapter translates provider errors to ${expectedCode}`, async () => {
    const { client } = createClientDouble({
      upsertResponse: { data: null, error: providerError },
    });
    await assertPersistenceCode(createRepository(client).save(SOURCE), expectedCode);
  });
}

test('source adapter translates timeout and network failures to UNAVAILABLE', async () => {
  for (const failure of [
    Object.assign(new Error('request timed out'), { name: 'AbortError' }),
    new TypeError('fetch failed for an internal URL'),
  ]) {
    const { client } = createClientDouble({ failures: { upsert: failure } });
    await assertPersistenceCode(createRepository(client).save(SOURCE), 'UNAVAILABLE');
  }
});

test('source adapter rejects malformed provider responses and rows', async () => {
  for (const upsertResponse of [
    { value: 'malformed' },
    { data: null, error: null },
    { data: { ...SOURCE_ROW, status: 'invented' }, error: null },
    { data: [SOURCE_ROW, SOURCE_ROW], error: null },
  ]) {
    const { client } = createClientDouble({ upsertResponse });
    await assertPersistenceCode(createRepository(client).save(SOURCE), 'INVALID_RESPONSE');
  }
});

test('source adapter emits only allowlisted operational telemetry', async () => {
  const entries = [];
  const { client } = createClientDouble();
  await createRepository(client, entries).save({
    ...SOURCE,
    title: 'Sensitive pedagogical title',
    provenanceUri: 'https://secret.invalid/document',
  });

  assert.equal(entries.length, 1);
  assert.deepEqual(
    Object.keys(entries[0]).sort(),
    [
      'adapter',
      'aggregateId',
      'aggregateType',
      'correlationId',
      'durationMs',
      'operation',
      'outcome',
      'rowCount',
    ].sort()
  );
  assert.doesNotMatch(
    JSON.stringify(entries),
    /Sensitive pedagogical|secret\.invalid|service-role/i
  );
});

test('source failure telemetry contains only the sanitized error code', async () => {
  const entries = [];
  const { client } = createClientDouble({
    upsertResponse: {
      data: null,
      error: {
        code: '42501',
        message: 'permission denied; Authorization: secret-jwt',
      },
    },
  });
  await assertPersistenceCode(createRepository(client, entries).save(SOURCE), 'FORBIDDEN');
  assert.equal(entries[0].errorCode, 'FORBIDDEN');
  assert.doesNotMatch(JSON.stringify(entries), /42501|permission denied|secret-jwt/i);
});

test('adapter surface exactly matches KnowledgeSourceRepository and does not invent ingestion', () => {
  assert.deepEqual(Object.getOwnPropertyNames(SupabaseKnowledgeSourceRepository.prototype).sort(), [
    'constructor',
    'findById',
    'findVersion',
    'listPermissionEvents',
    'save',
  ]);
});

test('source implementation has no generalized any, client creation, env access or forbidden writes', async () => {
  const source = (
    await Promise.all(
      [
        '../src/source/source.mapper.ts',
        '../src/source/supabase-knowledge-source.repository.ts',
      ].map((path) => readFile(new URL(path, import.meta.url), 'utf8'))
    )
  ).join('\n');

  assert.doesNotMatch(source, /\bany\b/);
  assert.doesNotMatch(source, /createClient\s*\(|process\.env|api\/_lib|supabaseAdmin/);
  assert.doesNotMatch(source, /\.insert\s*\(|\.update\s*\(|\.delete\s*\(/);
  assert.doesNotMatch(source, /saveVersion|saveSegment|appendPermissionEvent|extracted_text/);
});

test('column lists remain explicit and never use SELECT star', () => {
  for (const columns of [
    KNOWLEDGE_SOURCE_COLUMNS,
    SOURCE_VERSION_COLUMNS,
    SOURCE_PERMISSION_EVENT_COLUMNS,
  ]) {
    assert.ok(columns.length > 0);
    assert.doesNotMatch(columns, /\*/);
  }
});
