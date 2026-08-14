import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  KnowledgeFactoryPersistenceError,
  PRODUCTION_ORDER_COLUMNS,
  PRODUCTION_ORDER_EVENT_COLUMNS,
  SupabaseProductionOrderReadRepository,
  productionOrderEventRowToOppEvent,
  productionOrderRowToProductionOrder,
} from '../src/index.ts';

const REQUESTER_A_ID = '91000000-0000-4000-8000-000000000001';
const REQUESTER_B_ID = '92000000-0000-4000-8000-000000000002';
const ORDER_ID = '93000000-0000-4000-8000-000000000003';
const EVENT_A_ID = '94000000-0000-4000-8000-000000000004';
const EVENT_B_ID = '95000000-0000-4000-8000-000000000005';

const ORDER_ROW = Object.freeze({
  id: ORDER_ID,
  version: '1.0.0',
  requester_id: REQUESTER_A_ID,
  agent_profile_id: '96000000-0000-4000-8000-000000000006',
  curriculum_package_id: '97000000-0000-4000-8000-000000000007',
  product_type: 'lesson_plan',
  theme: 'Synthetic requester-scoped theme',
  duration_minutes: 50,
  status: 'requested',
  created_at: '2026-08-11T12:00:00.000Z',
  updated_at: '2026-08-11T12:00:00.000Z',
});

const EVENT_ROW = Object.freeze({
  id: EVENT_A_ID,
  version: '1.0.0',
  opp_id: ORDER_ID,
  event_type: 'created',
  from_status: null,
  to_status: 'requested',
  reason: null,
  occurred_at: '2026-08-11T12:00:00.000Z',
});

function createClientDouble({ responses = {}, failures = {} } = {}) {
  const calls = [];
  const defaults = {
    kf_production_orders: { data: ORDER_ROW, error: null },
    kf_production_order_events: { data: [EVENT_ROW], error: null },
  };
  const client = {
    secret: 'requester-token-must-never-be-logged',
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

function createRepository(client, requesterId = REQUESTER_A_ID, entries = []) {
  return new SupabaseProductionOrderReadRepository(
    { client, requesterId },
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
    assert.doesNotMatch(
      error.message,
      /42501|PGRST|permission denied|provider detail|requester-token/i
    );
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

test('production order mappers convert explicit rows and omit SQL null optionals', () => {
  assert.deepEqual(productionOrderRowToProductionOrder(ORDER_ROW, REQUESTER_A_ID), {
    id: ORDER_ROW.id,
    version: ORDER_ROW.version,
    requesterId: ORDER_ROW.requester_id,
    agentProfileId: ORDER_ROW.agent_profile_id,
    curriculumPackageId: ORDER_ROW.curriculum_package_id,
    productType: ORDER_ROW.product_type,
    theme: ORDER_ROW.theme,
    durationMinutes: ORDER_ROW.duration_minutes,
    status: ORDER_ROW.status,
    createdAt: ORDER_ROW.created_at,
    updatedAt: ORDER_ROW.updated_at,
  });
  assert.deepEqual(productionOrderEventRowToOppEvent(EVENT_ROW, ORDER_ID), {
    id: EVENT_ROW.id,
    version: EVENT_ROW.version,
    oppId: EVENT_ROW.opp_id,
    eventType: EVENT_ROW.event_type,
    toStatus: EVENT_ROW.to_status,
    occurredAt: EVENT_ROW.occurred_at,
  });

  const orderWithoutDuration = productionOrderRowToProductionOrder(
    { ...ORDER_ROW, duration_minutes: null },
    REQUESTER_A_ID
  );
  const eventWithOptionals = productionOrderEventRowToOppEvent(
    {
      ...EVENT_ROW,
      event_type: 'failed',
      from_status: 'requested',
      to_status: 'failed',
      reason: 'Synthetic failure reason',
    },
    ORDER_ID
  );
  assert.ok(!('durationMinutes' in orderWithoutDuration));
  assert.equal(eventWithOptionals.fromStatus, 'requested');
  assert.equal(eventWithOptionals.reason, 'Synthetic failure reason');
});

test('production order mappers reject malformed fields and unexpected ownership', () => {
  for (const row of [
    { ...ORDER_ROW, product_type: 'invented' },
    { ...ORDER_ROW, status: 'invented' },
    { ...ORDER_ROW, duration_minutes: 0 },
    { ...ORDER_ROW, created_at: '2026-02-30T12:00:00Z' },
  ]) {
    assertInvalidMapper(() => productionOrderRowToProductionOrder(row, REQUESTER_A_ID));
  }
  for (const row of [
    { ...EVENT_ROW, event_type: 'invented' },
    { ...EVENT_ROW, from_status: 'invented' },
    { ...EVENT_ROW, reason: '' },
    { ...EVENT_ROW, occurred_at: '2026-08-11' },
    { ...EVENT_ROW, opp_id: '98000000-0000-4000-8000-000000000008' },
  ]) {
    assertInvalidMapper(() => productionOrderEventRowToOppEvent(row, ORDER_ID));
  }
  assert.throws(
    () => productionOrderRowToProductionOrder(ORDER_ROW, REQUESTER_B_ID),
    (error) => {
      assert.ok(error instanceof KnowledgeFactoryPersistenceError);
      assert.equal(error.code, 'FORBIDDEN');
      return true;
    }
  );
});

test('findById selects explicit columns and maps only the requester row', async () => {
  const { client, calls } = createClientDouble();
  const order = await createRepository(client).findById(ORDER_ID);
  assert.equal(order?.id, ORDER_ID);
  assert.equal(order?.requesterId, REQUESTER_A_ID);
  assert.deepEqual(calls, [
    ['from', 'kf_production_orders'],
    ['select', 'kf_production_orders', PRODUCTION_ORDER_COLUMNS],
    ['eq', 'kf_production_orders', 'id', ORDER_ID],
    ['maybeSingle', 'kf_production_orders'],
  ]);
});

test('findById keeps a RLS-hidden foreign order indistinguishable from absence', async () => {
  const { client } = createClientDouble({
    responses: { kf_production_orders: { data: null, error: null } },
  });
  assert.equal(await createRepository(client).findById(ORDER_ID), null);
});

test('findById rejects a hydrated row whose requester does not match the context', async () => {
  const { client } = createClientDouble({
    responses: {
      kf_production_orders: {
        data: { ...ORDER_ROW, requester_id: REQUESTER_B_ID },
        error: null,
      },
    },
  });
  await assertPersistenceCode(createRepository(client).findById(ORDER_ID), 'FORBIDDEN');
});

test('listEvents filters by OPP and orders by occurred_at then id', async () => {
  const secondEvent = {
    ...EVENT_ROW,
    id: EVENT_B_ID,
    event_type: 'scope_resolved',
    from_status: 'requested',
    to_status: 'scoped',
    occurred_at: '2026-08-11T12:05:00.000Z',
  };
  const { client, calls } = createClientDouble({
    responses: {
      kf_production_order_events: { data: [EVENT_ROW, secondEvent], error: null },
    },
  });
  const events = await createRepository(client).listEvents(ORDER_ID);
  assert.deepEqual(
    events.map((event) => event.id),
    [EVENT_A_ID, EVENT_B_ID]
  );
  assert.deepEqual(calls, [
    ['from', 'kf_production_order_events'],
    ['select', 'kf_production_order_events', PRODUCTION_ORDER_EVENT_COLUMNS],
    ['eq', 'kf_production_order_events', 'opp_id', ORDER_ID],
    ['order', 'kf_production_order_events', 'occurred_at', { ascending: true }],
    ['order', 'kf_production_order_events', 'id', { ascending: true }],
  ]);
});

test('listEvents accepts an RLS-hidden empty list but rejects malformed provider data', async () => {
  const empty = createClientDouble({
    responses: { kf_production_order_events: { data: [], error: null } },
  });
  assert.deepEqual(await createRepository(empty.client).listEvents(ORDER_ID), []);

  for (const data of [null, [{ ...EVENT_ROW, opp_id: REQUESTER_B_ID }]]) {
    const malformed = createClientDouble({
      responses: { kf_production_order_events: { data, error: null } },
    });
    await assertPersistenceCode(
      createRepository(malformed.client).listEvents(ORDER_ID),
      'INVALID_RESPONSE'
    );
  }
});

test('missing requester identity fails before any provider operation', async () => {
  const { client, calls } = createClientDouble();
  const repository = createRepository(client, '   ');
  await assertPersistenceCode(repository.findById(ORDER_ID), 'UNAUTHORIZED');
  await assertPersistenceCode(repository.listEvents(ORDER_ID), 'UNAUTHORIZED');
  assert.deepEqual(calls, []);
});

for (const [providerError, expectedCode] of [
  [{ code: '42501', message: 'permission denied for table' }, 'FORBIDDEN'],
  [{ status: 401, message: 'JWT missing' }, 'UNAUTHORIZED'],
  [{ code: 'unexpected', message: 'provider detail' }, 'UNKNOWN'],
]) {
  test(`production order adapter translates provider errors to ${expectedCode}`, async () => {
    const { client } = createClientDouble({
      responses: { kf_production_orders: { data: null, error: providerError } },
    });
    await assertPersistenceCode(createRepository(client).findById(ORDER_ID), expectedCode);
  });
}

test('production order adapter sanitizes failures and emits only allowlisted telemetry', async () => {
  const entries = [];
  const { client } = createClientDouble({
    failures: {
      kf_production_orders: Object.assign(new Error('requester-token provider detail'), {
        name: 'AbortError',
      }),
    },
  });
  await assertPersistenceCode(
    createRepository(client, REQUESTER_A_ID, entries).findById(ORDER_ID),
    'UNAVAILABLE'
  );
  assert.equal(entries.length, 1);
  assert.deepEqual(Object.keys(entries[0]).sort(), [
    'adapter',
    'aggregateId',
    'aggregateType',
    'durationMs',
    'errorCode',
    'operation',
    'outcome',
  ]);
  assert.equal(entries[0].errorCode, 'UNAVAILABLE');
  assert.doesNotMatch(JSON.stringify(entries), /requester|token|provider detail|secret/i);
});

test('logger failures do not change a successful requester read', async () => {
  const { client } = createClientDouble();
  const repository = new SupabaseProductionOrderReadRepository(
    { client, requesterId: REQUESTER_A_ID },
    {
      record() {
        throw new Error('synthetic logger failure');
      },
    }
  );
  assert.equal((await repository.findById(ORDER_ID))?.id, ORDER_ID);
});

test('read adapter source contains no write, RPC, client creation or SYSTEM fallback', async () => {
  const source = await readFile(
    new URL(
      '../src/production-order/supabase-production-order-read.repository.ts',
      import.meta.url
    ),
    'utf8'
  );
  assert.doesNotMatch(source, /\.(?:insert|update|upsert|delete|rpc)\s*\(/);
  assert.doesNotMatch(
    source,
    /createClient\s*\(|process\.env|SupabaseSystemContext|service[_-]?role/i
  );
});
