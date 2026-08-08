import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  CURRICULUM_NODE_COLUMNS,
  CURRICULUM_PACKAGE_COLUMNS,
  CURRICULUM_PACKAGE_SOURCE_COLUMNS,
  KnowledgeFactoryPersistenceError,
  SupabaseCurriculumRepository,
  curriculumNodeRowToCurriculumNode,
  curriculumPackageRowToCurriculumPackage,
  curriculumPackageSourceRowsToIds,
} from '../src/index.ts';

const PACKAGE_ID = '91000000-0000-4000-8000-000000000001';
const NODE_ID = '92000000-0000-4000-8000-000000000002';
const SOURCE_VERSION_A_ID = '93000000-0000-4000-8000-000000000003';
const SOURCE_VERSION_B_ID = '94000000-0000-4000-8000-000000000004';

const PACKAGE_ROW = Object.freeze({
  id: PACKAGE_ID,
  version: '2026.1',
  state: 'MG',
  stage: 'ensino_medio',
  status: 'active',
  title: 'Synthetic MG high school package',
  effective_from: '2026-08-07T12:00:00.000Z',
  effective_until: '2027-12-31T23:59:59-03:00',
});

const PACKAGE_SOURCE_ROWS = Object.freeze([
  Object.freeze({ source_version_id: SOURCE_VERSION_A_ID }),
  Object.freeze({ source_version_id: SOURCE_VERSION_B_ID }),
]);

const NODE_ROW = Object.freeze({
  id: NODE_ID,
  version: '1.0.0',
  curriculum_package_id: PACKAGE_ID,
  node_type: 'learning_expectation',
  code: 'SYN-MG-PHI-2-001',
  title: 'Synthetic learning expectation',
  description: 'Synthetic description',
  component: 'Filosofia',
  grades: Object.freeze(['2_em']),
});

function createClientDouble({ responses = {}, failures = {} } = {}) {
  const calls = [];
  const defaults = {
    kf_curriculum_packages: { data: PACKAGE_ROW, error: null },
    kf_curriculum_package_sources: { data: PACKAGE_SOURCE_ROWS, error: null },
    kf_curriculum_nodes: { data: [NODE_ROW], error: null },
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
      };
    },
  };

  return { client, calls };
}

function createRepository(client, entries = []) {
  return new SupabaseCurriculumRepository(
    { client, correlationId: '95000000-0000-4000-8000-000000000005' },
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

test('curriculum mappers map packages, ordered source ids and nodes', () => {
  assert.deepEqual(curriculumPackageSourceRowsToIds(PACKAGE_SOURCE_ROWS), [
    SOURCE_VERSION_A_ID,
    SOURCE_VERSION_B_ID,
  ]);
  assert.deepEqual(
    curriculumPackageRowToCurriculumPackage(PACKAGE_ROW, [
      SOURCE_VERSION_A_ID,
      SOURCE_VERSION_B_ID,
    ]),
    {
      id: PACKAGE_ROW.id,
      version: PACKAGE_ROW.version,
      state: PACKAGE_ROW.state,
      stage: PACKAGE_ROW.stage,
      status: PACKAGE_ROW.status,
      title: PACKAGE_ROW.title,
      effectiveFrom: PACKAGE_ROW.effective_from,
      effectiveUntil: PACKAGE_ROW.effective_until,
      sourceVersionIds: [SOURCE_VERSION_A_ID, SOURCE_VERSION_B_ID],
    }
  );
  assert.deepEqual(curriculumNodeRowToCurriculumNode(NODE_ROW), {
    id: NODE_ROW.id,
    version: NODE_ROW.version,
    curriculumPackageId: NODE_ROW.curriculum_package_id,
    nodeType: NODE_ROW.node_type,
    code: NODE_ROW.code,
    title: NODE_ROW.title,
    description: NODE_ROW.description,
    component: NODE_ROW.component,
    grades: NODE_ROW.grades,
  });
});

test('package mapper omits an absent effective-until date', () => {
  const curriculumPackage = curriculumPackageRowToCurriculumPackage(
    { ...PACKAGE_ROW, effective_until: null },
    []
  );
  assert.ok(!('effectiveUntil' in curriculumPackage));
  assert.deepEqual(curriculumPackage.sourceVersionIds, []);
});

test('curriculum mappers reject invalid enums, arrays, timestamps and source rows', () => {
  for (const row of [
    { ...PACKAGE_ROW, state: 'SP' },
    { ...PACKAGE_ROW, stage: 'fundamental_i' },
    { ...PACKAGE_ROW, status: 'published' },
    { ...PACKAGE_ROW, effective_from: '2026-02-30T12:00:00Z' },
    { ...PACKAGE_ROW, effective_until: '2026-08-07' },
  ]) {
    assertInvalidMapper(() => curriculumPackageRowToCurriculumPackage(row, []));
  }

  for (const row of [
    { ...NODE_ROW, node_type: 'topic' },
    { ...NODE_ROW, grades: ['2_em', '4_em'] },
    { ...NODE_ROW, description: null },
  ]) {
    assertInvalidMapper(() => curriculumNodeRowToCurriculumNode(row));
  }

  assertInvalidMapper(() => curriculumPackageRowToCurriculumPackage(PACKAGE_ROW, [null]));
  assertInvalidMapper(() => curriculumPackageSourceRowsToIds(null));
  assertInvalidMapper(() => curriculumPackageSourceRowsToIds([{ source_version_id: '' }]));
});

test('findPackageById selects explicit columns and hydrates ordered source ids', async () => {
  const { client, calls } = createClientDouble();
  const curriculumPackage = await createRepository(client).findPackageById(PACKAGE_ID);

  assert.deepEqual(curriculumPackage?.sourceVersionIds, [SOURCE_VERSION_A_ID, SOURCE_VERSION_B_ID]);
  assert.deepEqual(calls, [
    ['from', 'kf_curriculum_packages'],
    ['select', 'kf_curriculum_packages', CURRICULUM_PACKAGE_COLUMNS],
    ['eq', 'kf_curriculum_packages', 'id', PACKAGE_ID],
    ['maybeSingle', 'kf_curriculum_packages'],
    ['from', 'kf_curriculum_package_sources'],
    ['select', 'kf_curriculum_package_sources', CURRICULUM_PACKAGE_SOURCE_COLUMNS],
    ['eq', 'kf_curriculum_package_sources', 'curriculum_package_id', PACKAGE_ID],
    ['order', 'kf_curriculum_package_sources', 'source_version_id', { ascending: true }],
  ]);
});

test('active lookup filters by state, stage and active status before hydration', async () => {
  const { client, calls } = createClientDouble();
  const result = await createRepository(client).findActivePackageByStateAndStage(
    'MG',
    'ensino_medio'
  );

  assert.equal(result?.id, PACKAGE_ID);
  assert.deepEqual(
    calls.filter(([operation, table]) => operation === 'eq' && table === 'kf_curriculum_packages'),
    [
      ['eq', 'kf_curriculum_packages', 'state', 'MG'],
      ['eq', 'kf_curriculum_packages', 'stage', 'ensino_medio'],
      ['eq', 'kf_curriculum_packages', 'status', 'active'],
    ]
  );
});

test('package lookups return null only when the package row is absent', async () => {
  const { client, calls } = createClientDouble({
    responses: { kf_curriculum_packages: { data: null, error: null } },
  });
  const repository = createRepository(client);

  assert.equal(await repository.findPackageById(PACKAGE_ID), null);
  assert.equal(await repository.findActivePackageByStateAndStage('MG', 'ensino_medio'), null);
  assert.ok(!calls.some(([, table]) => table === 'kf_curriculum_package_sources'));
});

test('source hydration failure never returns a partial package', async () => {
  for (const sourceResponse of [
    { data: null, error: null },
    { data: [{ source_version_id: null }], error: null },
    { data: null, error: { code: '42501', message: 'permission denied' } },
  ]) {
    const { client } = createClientDouble({
      responses: { kf_curriculum_package_sources: sourceResponse },
    });
    await assertPersistenceCode(
      createRepository(client).findPackageById(PACKAGE_ID),
      sourceResponse.error === null ? 'INVALID_RESPONSE' : 'FORBIDDEN'
    );
  }
});

test('findNodeById maps one row and returns null only when absent', async () => {
  const found = createClientDouble({
    responses: { kf_curriculum_nodes: { data: NODE_ROW, error: null } },
  });
  assert.deepEqual(await createRepository(found.client).findNodeById(NODE_ID), {
    id: NODE_ROW.id,
    version: NODE_ROW.version,
    curriculumPackageId: NODE_ROW.curriculum_package_id,
    nodeType: NODE_ROW.node_type,
    code: NODE_ROW.code,
    title: NODE_ROW.title,
    description: NODE_ROW.description,
    component: NODE_ROW.component,
    grades: NODE_ROW.grades,
  });

  const absent = createClientDouble({
    responses: { kf_curriculum_nodes: { data: null, error: null } },
  });
  assert.equal(await createRepository(absent.client).findNodeById(NODE_ID), null);
});

test('listNodesByPackage filters and orders by code, version and id', async () => {
  const secondNode = {
    ...NODE_ROW,
    id: '96000000-0000-4000-8000-000000000006',
    version: '2.0.0',
    code: 'SYN-MG-PHI-2-002',
  };
  const { client, calls } = createClientDouble({
    responses: { kf_curriculum_nodes: { data: [NODE_ROW, secondNode], error: null } },
  });
  const nodes = await createRepository(client).listNodesByPackage(PACKAGE_ID);

  assert.equal(nodes.length, 2);
  assert.deepEqual(calls, [
    ['from', 'kf_curriculum_nodes'],
    ['select', 'kf_curriculum_nodes', CURRICULUM_NODE_COLUMNS],
    ['eq', 'kf_curriculum_nodes', 'curriculum_package_id', PACKAGE_ID],
    ['order', 'kf_curriculum_nodes', 'code', { ascending: true }],
    ['order', 'kf_curriculum_nodes', 'version', { ascending: true }],
    ['order', 'kf_curriculum_nodes', 'id', { ascending: true }],
  ]);
});

test('listNodesByPackage accepts an empty array but rejects a malformed list', async () => {
  const empty = createClientDouble({
    responses: { kf_curriculum_nodes: { data: [], error: null } },
  });
  assert.deepEqual(await createRepository(empty.client).listNodesByPackage(PACKAGE_ID), []);

  const malformed = createClientDouble({
    responses: { kf_curriculum_nodes: { data: null, error: null } },
  });
  await assertPersistenceCode(
    createRepository(malformed.client).listNodesByPackage(PACKAGE_ID),
    'INVALID_RESPONSE'
  );
});

for (const [providerError, expectedCode] of [
  [{ code: '23505', message: 'duplicate detail' }, 'CONFLICT'],
  [{ code: '23503' }, 'CONSTRAINT_VIOLATION'],
  [{ code: '42501', message: 'permission denied for table' }, 'FORBIDDEN'],
  [{ status: 401, message: 'JWT missing' }, 'UNAUTHORIZED'],
  [{ code: 'unexpected', message: 'provider detail' }, 'UNKNOWN'],
]) {
  test(`curriculum adapter translates provider errors to ${expectedCode}`, async () => {
    const { client } = createClientDouble({
      responses: { kf_curriculum_packages: { data: null, error: providerError } },
    });
    await assertPersistenceCode(createRepository(client).findPackageById(PACKAGE_ID), expectedCode);
  });
}

test('curriculum adapter translates timeout and network failures to UNAVAILABLE', async () => {
  for (const failure of [
    Object.assign(new Error('request timed out'), { name: 'AbortError' }),
    new TypeError('fetch failed for an internal URL'),
  ]) {
    const { client } = createClientDouble({
      failures: { kf_curriculum_packages: failure },
    });
    await assertPersistenceCode(
      createRepository(client).findPackageById(PACKAGE_ID),
      'UNAVAILABLE'
    );
  }
});

test('curriculum adapter rejects malformed provider responses and rows', async () => {
  for (const packageResponse of [
    { value: 'malformed' },
    { data: { ...PACKAGE_ROW, state: 'SP' }, error: null },
    { data: [PACKAGE_ROW], error: null },
  ]) {
    const { client } = createClientDouble({
      responses: { kf_curriculum_packages: packageResponse },
    });
    await assertPersistenceCode(
      createRepository(client).findPackageById(PACKAGE_ID),
      'INVALID_RESPONSE'
    );
  }
});

test('curriculum telemetry is allowlisted and omits pedagogical content', async () => {
  const entries = [];
  const { client } = createClientDouble({
    responses: {
      kf_curriculum_packages: {
        data: { ...PACKAGE_ROW, title: 'Sensitive curriculum title' },
        error: null,
      },
    },
  });
  await createRepository(client, entries).findPackageById(PACKAGE_ID);

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
    /Sensitive curriculum|Synthetic description|service-role/i
  );
});

test('curriculum failure telemetry contains only the sanitized error code', async () => {
  const entries = [];
  const { client } = createClientDouble({
    responses: {
      kf_curriculum_packages: {
        data: null,
        error: { code: '42501', message: 'permission denied; Authorization: secret-jwt' },
      },
    },
  });
  await assertPersistenceCode(
    createRepository(client, entries).findPackageById(PACKAGE_ID),
    'FORBIDDEN'
  );
  assert.equal(entries[0].errorCode, 'FORBIDDEN');
  assert.doesNotMatch(JSON.stringify(entries), /42501|permission denied|secret-jwt/i);
});

test('adapter surface exactly matches the four CurriculumRepository methods', () => {
  assert.deepEqual(Object.getOwnPropertyNames(SupabaseCurriculumRepository.prototype).sort(), [
    'constructor',
    'findActivePackageByStateAndStage',
    'findNodeById',
    'findPackageById',
    'listNodesByPackage',
  ]);
});

test('curriculum implementation has no generalized any, client creation, env access or writes', async () => {
  const source = (
    await Promise.all(
      [
        '../src/curriculum/curriculum.mapper.ts',
        '../src/curriculum/supabase-curriculum.repository.ts',
      ].map((path) => readFile(new URL(path, import.meta.url), 'utf8'))
    )
  ).join('\n');

  assert.doesNotMatch(source, /\bany\b/);
  assert.doesNotMatch(source, /createClient\s*\(|process\.env|api\/_lib|supabaseAdmin/);
  assert.doesNotMatch(source, /\.insert\s*\(|\.upsert\s*\(|\.update\s*\(|\.delete\s*\(/);
  assert.doesNotMatch(source, /kf_curriculum_links|savePackage|saveNode|activatePackage/);
});

test('curriculum column lists remain explicit and never use SELECT star', () => {
  for (const columns of [
    CURRICULUM_PACKAGE_COLUMNS,
    CURRICULUM_PACKAGE_SOURCE_COLUMNS,
    CURRICULUM_NODE_COLUMNS,
  ]) {
    assert.ok(columns.length > 0);
    assert.doesNotMatch(columns, /\*/);
  }
});
