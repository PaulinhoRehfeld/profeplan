import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  COMPONENT_CURRICULUM_LINK_COLUMNS,
  COMPONENT_SOURCE_EVIDENCE_ID_COLUMNS,
  EVIDENCE_ORIGIN_COLUMNS,
  PEDAGOGICAL_COMPONENT_COLUMNS,
  PEDAGOGICAL_COMPONENT_VERSION_COLUMNS,
  KnowledgeFactoryPersistenceError,
  SupabasePedagogicalComponentReadRepository,
  componentCurriculumLinkRowsToIds,
  componentSourceEvidenceRowsToIds,
  evidenceOriginRowToEvidenceOrigin,
  pedagogicalComponentRowToPedagogicalComponent,
  pedagogicalComponentVersionRowToPedagogicalComponentVersion,
} from '../src/index.ts';

const COMPONENT_ID = 'b1000000-0000-4000-8000-000000000001';
const COMPONENT_VERSION_ID = 'b2000000-0000-4000-8000-000000000002';
const EVIDENCE_A_ID = 'b3000000-0000-4000-8000-000000000003';
const EVIDENCE_B_ID = 'b4000000-0000-4000-8000-000000000004';
const CURRICULUM_NODE_A_ID = 'b5000000-0000-4000-8000-000000000005';
const CURRICULUM_NODE_B_ID = 'b6000000-0000-4000-8000-000000000006';
const SOURCE_ID = 'b7000000-0000-4000-8000-000000000007';
const SOURCE_VERSION_ID = 'b8000000-0000-4000-8000-000000000008';
const SOURCE_SEGMENT_ID = 'b9000000-0000-4000-8000-000000000009';

const COMPONENT_ROW = Object.freeze({
  id: COMPONENT_ID,
  version: '1.0.0',
  canonical_key: 'synthetic-component-read-adapter',
  title: 'Synthetic pedagogical component',
  component_type: 'concept',
  school_component: 'Filosofia',
  grades: Object.freeze(['2_em']),
  status: 'approved',
  current_version_id: COMPONENT_VERSION_ID,
  created_at: '2026-08-08T12:00:00.000Z',
  updated_at: '2026-08-08T12:30:00-03:00',
});

const VERSION_ROW = Object.freeze({
  id: COMPONENT_VERSION_ID,
  version: '1.0.0',
  component_id: COMPONENT_ID,
  summary: 'Synthetic summary for adapter validation',
  keywords: Object.freeze(['synthetic', 'read-only']),
  supersedes_version: null,
  approved_at: '2026-08-08T13:00:00.000Z',
  status: 'approved',
});

const EVIDENCE_ROW = Object.freeze({
  id: EVIDENCE_A_ID,
  version: '1.0.0',
  component_version_id: COMPONENT_VERSION_ID,
  source_id: SOURCE_ID,
  source_version_id: SOURCE_VERSION_ID,
  source_segment_id: SOURCE_SEGMENT_ID,
  contribution: 'conceptual',
  recorded_at: '2026-08-08T13:30:00.000Z',
});

const EVIDENCE_ID_ROWS = Object.freeze([
  Object.freeze({ id: EVIDENCE_A_ID }),
  Object.freeze({ id: EVIDENCE_B_ID }),
]);
const CURRICULUM_LINK_ROWS = Object.freeze([
  Object.freeze({ curriculum_node_id: CURRICULUM_NODE_A_ID }),
  Object.freeze({ curriculum_node_id: CURRICULUM_NODE_B_ID }),
]);

function createClientDouble({ responses = {}, failures = {} } = {}) {
  const calls = [];
  const defaults = {
    [`kf_pedagogical_components:${PEDAGOGICAL_COMPONENT_COLUMNS}`]: {
      data: COMPONENT_ROW,
      error: null,
    },
    [`kf_component_versions:${PEDAGOGICAL_COMPONENT_VERSION_COLUMNS}`]: {
      data: VERSION_ROW,
      error: null,
    },
    [`kf_component_source_evidence:${COMPONENT_SOURCE_EVIDENCE_ID_COLUMNS}`]: {
      data: EVIDENCE_ID_ROWS,
      error: null,
    },
    [`kf_component_curriculum_links:${COMPONENT_CURRICULUM_LINK_COLUMNS}`]: {
      data: CURRICULUM_LINK_ROWS,
      error: null,
    },
    [`kf_component_source_evidence:${EVIDENCE_ORIGIN_COLUMNS}`]: {
      data: [EVIDENCE_ROW],
      error: null,
    },
  };

  function resultFor(table, columns) {
    const key = `${table}:${columns}`;
    if (failures[key] || failures[table]) {
      return Promise.reject(failures[key] ?? failures[table]);
    }
    return Promise.resolve(responses[key] ?? responses[table] ?? defaults[key]);
  }

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
              return resultFor(table, columns);
            },
            then(onFulfilled, onRejected) {
              return resultFor(table, columns).then(onFulfilled, onRejected);
            },
          };
          return builder;
        },
      };
    },
  };

  return { client, calls };
}

function createRepository(client, entries = []) {
  return new SupabasePedagogicalComponentReadRepository(
    { client, correlationId: 'ba000000-0000-4000-8000-00000000000a' },
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

test('component mappers reconstruct component, version, evidence and ordered relationship ids', () => {
  const sourceEvidenceIds = componentSourceEvidenceRowsToIds(EVIDENCE_ID_ROWS);
  const curriculumNodeIds = componentCurriculumLinkRowsToIds(CURRICULUM_LINK_ROWS);

  assert.deepEqual(pedagogicalComponentRowToPedagogicalComponent(COMPONENT_ROW), {
    id: COMPONENT_ROW.id,
    version: COMPONENT_ROW.version,
    canonicalKey: COMPONENT_ROW.canonical_key,
    title: COMPONENT_ROW.title,
    componentType: COMPONENT_ROW.component_type,
    schoolComponent: COMPONENT_ROW.school_component,
    grades: COMPONENT_ROW.grades,
    status: COMPONENT_ROW.status,
    currentVersionId: COMPONENT_ROW.current_version_id,
    createdAt: COMPONENT_ROW.created_at,
    updatedAt: COMPONENT_ROW.updated_at,
  });
  assert.deepEqual(
    pedagogicalComponentVersionRowToPedagogicalComponentVersion(
      VERSION_ROW,
      sourceEvidenceIds,
      curriculumNodeIds
    ),
    {
      id: VERSION_ROW.id,
      version: VERSION_ROW.version,
      componentId: VERSION_ROW.component_id,
      summary: VERSION_ROW.summary,
      keywords: VERSION_ROW.keywords,
      sourceEvidenceIds: [EVIDENCE_A_ID, EVIDENCE_B_ID],
      curriculumNodeIds: [CURRICULUM_NODE_A_ID, CURRICULUM_NODE_B_ID],
      approvedAt: VERSION_ROW.approved_at,
      status: VERSION_ROW.status,
    }
  );
  assert.deepEqual(evidenceOriginRowToEvidenceOrigin(EVIDENCE_ROW), {
    id: EVIDENCE_ROW.id,
    version: EVIDENCE_ROW.version,
    componentVersionId: EVIDENCE_ROW.component_version_id,
    sourceId: EVIDENCE_ROW.source_id,
    sourceVersionId: EVIDENCE_ROW.source_version_id,
    sourceSegmentId: EVIDENCE_ROW.source_segment_id,
    contribution: EVIDENCE_ROW.contribution,
    recordedAt: EVIDENCE_ROW.recorded_at,
  });
});

test('version mapper omits absent optional fields and accepts legitimate empty relationships', () => {
  const version = pedagogicalComponentVersionRowToPedagogicalComponentVersion(
    { ...VERSION_ROW, supersedes_version: null, approved_at: null },
    [],
    []
  );
  assert.ok(!('supersedesVersion' in version));
  assert.ok(!('approvedAt' in version));
  assert.deepEqual(version.sourceEvidenceIds, []);
  assert.deepEqual(version.curriculumNodeIds, []);
});

test('component mappers reject invalid enums, arrays, ids, optionals and timestamps', () => {
  for (const row of [
    { ...COMPONENT_ROW, component_type: 'invented' },
    { ...COMPONENT_ROW, status: 'published' },
    { ...COMPONENT_ROW, grades: ['2_em', '4_em'] },
    { ...COMPONENT_ROW, current_version_id: '' },
    { ...COMPONENT_ROW, created_at: '2026-02-30T12:00:00Z' },
  ]) {
    assertInvalidMapper(() => pedagogicalComponentRowToPedagogicalComponent(row));
  }
  for (const row of [
    { ...VERSION_ROW, status: 'published' },
    { ...VERSION_ROW, keywords: ['valid', null] },
    { ...VERSION_ROW, supersedes_version: '' },
    { ...VERSION_ROW, approved_at: '2026-08-08' },
  ]) {
    assertInvalidMapper(() =>
      pedagogicalComponentVersionRowToPedagogicalComponentVersion(row, [], [])
    );
  }
  assertInvalidMapper(() => componentSourceEvidenceRowsToIds(null));
  assertInvalidMapper(() => componentSourceEvidenceRowsToIds([{ id: '' }]));
  assertInvalidMapper(() => componentCurriculumLinkRowsToIds([{ curriculum_node_id: null }]));
  assertInvalidMapper(() =>
    evidenceOriginRowToEvidenceOrigin({ ...EVIDENCE_ROW, contribution: 'quoted' })
  );
  assertInvalidMapper(() =>
    evidenceOriginRowToEvidenceOrigin({ ...EVIDENCE_ROW, recorded_at: null })
  );
});

test('findById selects explicit columns, filters by id and uses the injected client', async () => {
  const { client, calls } = createClientDouble();
  const result = await createRepository(client).findById(COMPONENT_ID);

  assert.equal(result?.id, COMPONENT_ID);
  assert.deepEqual(calls, [
    ['from', 'kf_pedagogical_components'],
    ['select', 'kf_pedagogical_components', PEDAGOGICAL_COMPONENT_COLUMNS],
    ['eq', 'kf_pedagogical_components', 'id', COMPONENT_ID],
    ['maybeSingle', 'kf_pedagogical_components'],
  ]);
});

test('findById returns null only for legitimate absence', async () => {
  const { client } = createClientDouble({
    responses: { kf_pedagogical_components: { data: null, error: null } },
  });
  assert.equal(await createRepository(client).findById(COMPONENT_ID), null);
});

test('findVersion filters the base row and hydrates both ordered id collections', async () => {
  const { client, calls } = createClientDouble();
  const result = await createRepository(client).findVersion(COMPONENT_ID, VERSION_ROW.version);

  assert.deepEqual(result?.sourceEvidenceIds, [EVIDENCE_A_ID, EVIDENCE_B_ID]);
  assert.deepEqual(result?.curriculumNodeIds, [CURRICULUM_NODE_A_ID, CURRICULUM_NODE_B_ID]);
  assert.deepEqual(calls, [
    ['from', 'kf_component_versions'],
    ['select', 'kf_component_versions', PEDAGOGICAL_COMPONENT_VERSION_COLUMNS],
    ['eq', 'kf_component_versions', 'component_id', COMPONENT_ID],
    ['eq', 'kf_component_versions', 'version', VERSION_ROW.version],
    ['maybeSingle', 'kf_component_versions'],
    ['from', 'kf_component_source_evidence'],
    ['select', 'kf_component_source_evidence', COMPONENT_SOURCE_EVIDENCE_ID_COLUMNS],
    ['eq', 'kf_component_source_evidence', 'component_version_id', COMPONENT_VERSION_ID],
    ['order', 'kf_component_source_evidence', 'id', { ascending: true }],
    ['from', 'kf_component_curriculum_links'],
    ['select', 'kf_component_curriculum_links', COMPONENT_CURRICULUM_LINK_COLUMNS],
    ['eq', 'kf_component_curriculum_links', 'component_version_id', COMPONENT_VERSION_ID],
    ['order', 'kf_component_curriculum_links', 'curriculum_node_id', { ascending: true }],
  ]);
});

test('findVersion returns null without starting hydration when the base row is absent', async () => {
  const { client, calls } = createClientDouble({
    responses: { kf_component_versions: { data: null, error: null } },
  });
  assert.equal(await createRepository(client).findVersion(COMPONENT_ID, 'missing'), null);
  assert.ok(!calls.some(([, table]) => table === 'kf_component_source_evidence'));
  assert.ok(!calls.some(([, table]) => table === 'kf_component_curriculum_links'));
});

test('findVersion accepts empty relationships only when both provider lists are empty', async () => {
  const { client } = createClientDouble({
    responses: {
      [`kf_component_source_evidence:${COMPONENT_SOURCE_EVIDENCE_ID_COLUMNS}`]: {
        data: [],
        error: null,
      },
      [`kf_component_curriculum_links:${COMPONENT_CURRICULUM_LINK_COLUMNS}`]: {
        data: [],
        error: null,
      },
    },
  });
  const result = await createRepository(client).findVersion(COMPONENT_ID, VERSION_ROW.version);
  assert.deepEqual(result?.sourceEvidenceIds, []);
  assert.deepEqual(result?.curriculumNodeIds, []);
});

test('findVersion rejects each provider hydration failure without a partial return', async () => {
  for (const table of ['kf_component_source_evidence', 'kf_component_curriculum_links']) {
    const { client } = createClientDouble({
      responses: {
        [table]: {
          data: null,
          error: { code: '42501', message: 'permission denied; private provider detail' },
        },
      },
    });
    await assertPersistenceCode(
      createRepository(client).findVersion(COMPONENT_ID, VERSION_ROW.version),
      'FORBIDDEN'
    );
  }
});

test('findVersion rejects null or structurally invalid hydration data', async () => {
  for (const [key, data] of [
    [`kf_component_source_evidence:${COMPONENT_SOURCE_EVIDENCE_ID_COLUMNS}`, null],
    [`kf_component_source_evidence:${COMPONENT_SOURCE_EVIDENCE_ID_COLUMNS}`, [{ id: null }]],
    [`kf_component_curriculum_links:${COMPONENT_CURRICULUM_LINK_COLUMNS}`, null],
    [
      `kf_component_curriculum_links:${COMPONENT_CURRICULUM_LINK_COLUMNS}`,
      [{ curriculum_node_id: null }],
    ],
  ]) {
    const { client } = createClientDouble({ responses: { [key]: { data, error: null } } });
    await assertPersistenceCode(
      createRepository(client).findVersion(COMPONENT_ID, VERSION_ROW.version),
      'INVALID_RESPONSE'
    );
  }
});

test('listEvidenceOrigins maps isolated rows with deterministic recorded-at and id ordering', async () => {
  const secondEvidence = {
    ...EVIDENCE_ROW,
    id: EVIDENCE_B_ID,
    contribution: 'contextual',
    recorded_at: '2026-08-08T14:00:00.000Z',
  };
  const { client, calls } = createClientDouble({
    responses: {
      [`kf_component_source_evidence:${EVIDENCE_ORIGIN_COLUMNS}`]: {
        data: [EVIDENCE_ROW, secondEvidence],
        error: null,
      },
    },
  });
  const evidence = await createRepository(client).listEvidenceOrigins(COMPONENT_VERSION_ID);

  assert.deepEqual(
    evidence.map((item) => item.id),
    [EVIDENCE_A_ID, EVIDENCE_B_ID]
  );
  assert.deepEqual(calls, [
    ['from', 'kf_component_source_evidence'],
    ['select', 'kf_component_source_evidence', EVIDENCE_ORIGIN_COLUMNS],
    ['eq', 'kf_component_source_evidence', 'component_version_id', COMPONENT_VERSION_ID],
    ['order', 'kf_component_source_evidence', 'recorded_at', { ascending: true }],
    ['order', 'kf_component_source_evidence', 'id', { ascending: true }],
  ]);
});

test('listEvidenceOrigins accepts an empty list but rejects null and malformed rows', async () => {
  const empty = createClientDouble({
    responses: {
      [`kf_component_source_evidence:${EVIDENCE_ORIGIN_COLUMNS}`]: { data: [], error: null },
    },
  });
  assert.deepEqual(
    await createRepository(empty.client).listEvidenceOrigins(COMPONENT_VERSION_ID),
    []
  );

  for (const data of [null, [{ ...EVIDENCE_ROW, source_id: null }]]) {
    const malformed = createClientDouble({
      responses: {
        [`kf_component_source_evidence:${EVIDENCE_ORIGIN_COLUMNS}`]: { data, error: null },
      },
    });
    await assertPersistenceCode(
      createRepository(malformed.client).listEvidenceOrigins(COMPONENT_VERSION_ID),
      'INVALID_RESPONSE'
    );
  }
});

for (const [providerError, expectedCode] of [
  [{ code: '23505', message: 'duplicate detail' }, 'CONFLICT'],
  [{ code: '23503' }, 'CONSTRAINT_VIOLATION'],
  [{ code: '42501', message: 'permission denied for table' }, 'FORBIDDEN'],
  [{ status: 401, message: 'JWT missing' }, 'UNAUTHORIZED'],
  [{ code: 'unexpected', message: 'provider detail' }, 'UNKNOWN'],
  [{ code: 'PGRST116', message: 'multiple rows returned' }, 'INVALID_RESPONSE'],
]) {
  test(`component adapter translates provider failures to ${expectedCode}`, async () => {
    const { client } = createClientDouble({
      responses: { kf_pedagogical_components: { data: null, error: providerError } },
    });
    await assertPersistenceCode(createRepository(client).findById(COMPONENT_ID), expectedCode);
  });
}

test('component adapter translates timeout and network failures to UNAVAILABLE', async () => {
  for (const failure of [
    Object.assign(new Error('request timed out'), { name: 'AbortError' }),
    new TypeError('fetch failed for an internal URL'),
  ]) {
    const { client } = createClientDouble({ failures: { kf_pedagogical_components: failure } });
    await assertPersistenceCode(createRepository(client).findById(COMPONENT_ID), 'UNAVAILABLE');
  }
});

test('component adapter rejects malformed main responses and rows', async () => {
  for (const response of [
    { value: 'malformed' },
    { data: [COMPONENT_ROW, COMPONENT_ROW], error: null },
    { data: { ...COMPONENT_ROW, status: 'invented' }, error: null },
  ]) {
    const { client } = createClientDouble({ responses: { kf_pedagogical_components: response } });
    await assertPersistenceCode(
      createRepository(client).findById(COMPONENT_ID),
      'INVALID_RESPONSE'
    );
  }
});

test('component telemetry is allowlisted and omits pedagogical content, ids in bulk and provider details', async () => {
  const entries = [];
  const { client } = createClientDouble({
    responses: {
      kf_pedagogical_components: {
        data: { ...COMPONENT_ROW, title: 'Sensitive pedagogical content' },
        error: null,
      },
    },
  });
  await createRepository(client, entries).findById(COMPONENT_ID);

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
    /Sensitive pedagogical|Synthetic summary|service-role|b3000000.*b4000000/i
  );
});

test('component failure telemetry contains only the provider-neutral code', async () => {
  const entries = [];
  const { client } = createClientDouble({
    responses: {
      kf_pedagogical_components: {
        data: null,
        error: { code: '42501', message: 'permission denied; Authorization: secret-jwt' },
      },
    },
  });
  await assertPersistenceCode(
    createRepository(client, entries).findById(COMPONENT_ID),
    'FORBIDDEN'
  );
  assert.equal(entries[0].errorCode, 'FORBIDDEN');
  assert.doesNotMatch(JSON.stringify(entries), /42501|permission denied|secret-jwt/i);
});

test('adapter surface is exactly the approved read-only port', () => {
  assert.deepEqual(
    Object.getOwnPropertyNames(SupabasePedagogicalComponentReadRepository.prototype).sort(),
    ['constructor', 'findById', 'findVersion', 'listEvidenceOrigins']
  );
});

test('component implementation has no writes, RPC, generalized any, client creation or env access', async () => {
  const source = (
    await Promise.all(
      [
        '../src/component/pedagogical-component.mapper.ts',
        '../src/component/supabase-pedagogical-component.repository.ts',
      ].map((path) => readFile(new URL(path, import.meta.url), 'utf8'))
    )
  ).join('\n');

  assert.match(source, /implements PedagogicalComponentReadRepository/);
  assert.doesNotMatch(source, /type PedagogicalComponentReadRepository = Pick</);
  assert.doesNotMatch(source, /\bany\b/);
  assert.doesNotMatch(source, /createClient\s*\(|process\.env|api\/_lib|supabaseAdmin/);
  assert.doesNotMatch(source, /\.insert\s*\(|\.upsert\s*\(|\.update\s*\(|\.delete\s*\(|\.rpc\s*\(/);
  assert.doesNotMatch(
    source,
    /saveComponent|saveVersion|implements\s+PedagogicalComponentRepository/
  );
});

test('all component column lists are explicit and never select star', () => {
  for (const columns of [
    PEDAGOGICAL_COMPONENT_COLUMNS,
    PEDAGOGICAL_COMPONENT_VERSION_COLUMNS,
    COMPONENT_SOURCE_EVIDENCE_ID_COLUMNS,
    COMPONENT_CURRICULUM_LINK_COLUMNS,
    EVIDENCE_ORIGIN_COLUMNS,
  ]) {
    assert.ok(columns.length > 0);
    assert.doesNotMatch(columns, /\*/);
  }
});
