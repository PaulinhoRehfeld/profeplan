import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  KnowledgeFactoryPersistenceError,
  SupabaseProductionOrderRequestRepository,
  SupabaseProductionOrderTransitionRepository,
  createProductionOrderCommandToRpcPayload,
  productionOrderWriteReceiptRowToReceipt,
  toPersistenceError,
  transitionProductionOrderCommandToRpcPayload,
} from '../src/index.ts';

const REQUESTER_ID = 'a6000000-0000-4000-8000-000000000001';
const COMMAND_ID = 'c6000000-0000-4000-8000-000000000001';
const ORDER_ID = 'd6000000-0000-4000-8000-000000000001';
const EVENT_ID = 'e6000000-0000-4000-8000-000000000001';
const OCCURRED_AT = '2026-08-11T20:00:00.000Z';

const CREATE_COMMAND = Object.freeze({
  commandId: COMMAND_ID,
  order: Object.freeze({
    id: ORDER_ID,
    version: '1.0.0',
    agentProfileId: 'a6100000-0000-4000-8000-000000000001',
    curriculumPackageId: 'c6100000-0000-4000-8000-000000000001',
    productType: 'lesson_plan',
    theme: 'Synthetic command adapter theme',
    durationMinutes: 50,
  }),
  eventId: EVENT_ID,
  eventVersion: '1.0.0',
  occurredAt: OCCURRED_AT,
});

const TRANSITION_COMMAND = Object.freeze({
  commandId: COMMAND_ID,
  requesterId: REQUESTER_ID,
  oppId: ORDER_ID,
  expectedStatus: 'requested',
  expectedUpdatedAt: OCCURRED_AT,
  toStatus: 'scoped',
  eventId: EVENT_ID,
  eventVersion: '1.0.0',
  reason: 'Synthetic application policy accepted the scope',
  occurredAt: '2026-08-11T20:05:00.000Z',
});

const CREATE_RECEIPT_ROW = Object.freeze({
  command_id: COMMAND_ID,
  operation: 'create_production_order',
  opp_id: ORDER_ID,
  event_id: EVENT_ID,
  status: 'requested',
  replayed: false,
  committed_at: OCCURRED_AT,
});

const TRANSITION_RECEIPT_ROW = Object.freeze({
  ...CREATE_RECEIPT_ROW,
  operation: 'transition_production_order',
  status: 'scoped',
});

function createClientDouble({
  response = { data: [CREATE_RECEIPT_ROW], error: null },
  failure,
} = {}) {
  const calls = [];
  const client = {
    secret: 'provider-credential-must-never-be-logged',
    rpc(name, args) {
      calls.push(['rpc', name, args]);
      return failure ? Promise.reject(failure) : Promise.resolve(response);
    },
    from() {
      throw new Error('production order command adapters must not access tables directly');
    },
  };
  return { client, calls };
}

function createRequestRepository(client, entries = [], requesterId = REQUESTER_ID, logger) {
  return new SupabaseProductionOrderRequestRepository(
    { client, requesterId },
    logger ?? {
      record(entry) {
        entries.push(entry);
      },
    }
  );
}

function createTransitionRepository(client, entries = [], logger) {
  return new SupabaseProductionOrderTransitionRepository(
    { client, correlationId: 'f6000000-0000-4000-8000-000000000001' },
    logger ?? {
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
      `${error.message} ${JSON.stringify(error)}`,
      /provider-credential|private provider|PT409|P0002|22023|42501/i
    );
    return true;
  });
}

test('creation mapper emits only the closed RPC payload and omits derived fields', () => {
  const runtimeCommand = {
    ...CREATE_COMMAND,
    requesterId: 'must-not-cross-the-boundary',
    status: 'ready',
    createdAt: 'must-not-cross-the-boundary',
    order: {
      ...CREATE_COMMAND.order,
      requesterId: 'must-not-cross-the-boundary',
      status: 'ready',
      updatedAt: 'must-not-cross-the-boundary',
      unknown: 'must-not-cross-the-boundary',
    },
    unknown: 'must-not-cross-the-boundary',
  };

  assert.deepEqual(createProductionOrderCommandToRpcPayload(runtimeCommand), {
    order: CREATE_COMMAND.order,
    eventId: EVENT_ID,
    eventVersion: '1.0.0',
    occurredAt: OCCURRED_AT,
  });
});

test('creation mapper omits an absent optional duration', () => {
  const payload = createProductionOrderCommandToRpcPayload({
    ...CREATE_COMMAND,
    order: { ...CREATE_COMMAND.order, durationMinutes: undefined },
  });
  assert.ok(!('durationMinutes' in payload.order));
});

test('transition mapper emits only the closed SYSTEM RPC payload', () => {
  assert.deepEqual(
    transitionProductionOrderCommandToRpcPayload({
      ...TRANSITION_COMMAND,
      eventType: 'approved',
      fromStatus: 'failed',
      unknown: 'must-not-cross-the-boundary',
    }),
    {
      requesterId: REQUESTER_ID,
      oppId: ORDER_ID,
      expectedStatus: 'requested',
      expectedUpdatedAt: OCCURRED_AT,
      toStatus: 'scoped',
      eventId: EVENT_ID,
      eventVersion: '1.0.0',
      reason: TRANSITION_COMMAND.reason,
      occurredAt: TRANSITION_COMMAND.occurredAt,
    }
  );
  const withoutReason = transitionProductionOrderCommandToRpcPayload({
    ...TRANSITION_COMMAND,
    reason: undefined,
  });
  assert.ok(!('reason' in withoutReason));
});

test('command mappers reject missing or empty command identity', () => {
  assert.throws(
    () => createProductionOrderCommandToRpcPayload({ ...CREATE_COMMAND, commandId: '' }),
    {
      code: 'INVALID_RESPONSE',
    }
  );
  assert.throws(
    () => transitionProductionOrderCommandToRpcPayload({ ...TRANSITION_COMMAND, commandId: '' }),
    { code: 'INVALID_RESPONSE' }
  );
});

test('receipt mapper reconstructs and freezes the exact provider-neutral receipt', () => {
  const receipt = productionOrderWriteReceiptRowToReceipt([CREATE_RECEIPT_ROW], {
    commandId: COMMAND_ID,
    operation: 'create_production_order',
    oppId: ORDER_ID,
    eventId: EVENT_ID,
    status: 'requested',
  });
  assert.deepEqual(receipt, {
    commandId: COMMAND_ID,
    operation: 'create_production_order',
    oppId: ORDER_ID,
    eventId: EVENT_ID,
    status: 'requested',
    replayed: false,
    committedAt: OCCURRED_AT,
  });
  assert.ok(Object.isFrozen(receipt));
});

test('receipt mapper requires exactly one row with exactly the approved columns', () => {
  const expected = {
    commandId: COMMAND_ID,
    operation: 'create_production_order',
    oppId: ORDER_ID,
    eventId: EVENT_ID,
    status: 'requested',
  };
  for (const data of [
    null,
    {},
    [],
    [CREATE_RECEIPT_ROW, CREATE_RECEIPT_ROW],
    [{ ...CREATE_RECEIPT_ROW, private_payload: 'unexpected' }],
  ]) {
    assert.throws(() => productionOrderWriteReceiptRowToReceipt(data, expected), {
      code: 'INVALID_RESPONSE',
    });
  }
});

test('receipt mapper rejects identity, operation, status, replay and timestamp mismatches', () => {
  const expected = {
    commandId: COMMAND_ID,
    operation: 'create_production_order',
    oppId: ORDER_ID,
    eventId: EVENT_ID,
    status: 'requested',
  };
  for (const row of [
    { ...CREATE_RECEIPT_ROW, command_id: 'different' },
    { ...CREATE_RECEIPT_ROW, operation: 'transition_production_order' },
    { ...CREATE_RECEIPT_ROW, opp_id: 'different' },
    { ...CREATE_RECEIPT_ROW, event_id: 'different' },
    { ...CREATE_RECEIPT_ROW, status: 'scoped' },
    { ...CREATE_RECEIPT_ROW, replayed: 'false' },
    { ...CREATE_RECEIPT_ROW, committed_at: '2026-02-30T12:00:00Z' },
  ]) {
    assert.throws(() => productionOrderWriteReceiptRowToReceipt([row], expected), {
      code: 'INVALID_RESPONSE',
    });
  }
});

test('REQUESTER adapter calls only the approved creation RPC', async () => {
  const { client, calls } = createClientDouble();
  const receipt = await createRequestRepository(client).createProductionOrder(CREATE_COMMAND);
  assert.equal(receipt.status, 'requested');
  assert.deepEqual(calls, [
    [
      'rpc',
      'kf_create_production_order',
      {
        p_command_id: COMMAND_ID,
        p_payload: {
          order: CREATE_COMMAND.order,
          eventId: EVENT_ID,
          eventVersion: '1.0.0',
          occurredAt: OCCURRED_AT,
        },
      },
    ],
  ]);
});

test('REQUESTER adapter rejects missing identity before provider access', async () => {
  const { client, calls } = createClientDouble();
  await assertPersistenceCode(
    createRequestRepository(client, [], '   ').createProductionOrder(CREATE_COMMAND),
    'UNAUTHORIZED'
  );
  assert.deepEqual(calls, []);
});

test('SYSTEM adapter calls only the approved transition RPC', async () => {
  const { client, calls } = createClientDouble({
    response: { data: [TRANSITION_RECEIPT_ROW], error: null },
  });
  const receipt =
    await createTransitionRepository(client).transitionProductionOrder(TRANSITION_COMMAND);
  assert.equal(receipt.status, 'scoped');
  assert.deepEqual(calls, [
    [
      'rpc',
      'kf_transition_production_order',
      {
        p_command_id: COMMAND_ID,
        p_payload: transitionProductionOrderCommandToRpcPayload(TRANSITION_COMMAND),
      },
    ],
  ]);
});

for (const [providerError, expectedCode] of [
  [{ code: '22023', message: 'private provider invalid input' }, 'INVALID_INPUT'],
  [{ code: 'PT409', message: 'private provider conflict' }, 'CONFLICT'],
  [{ code: 'P0002', message: 'private provider missing row' }, 'NOT_FOUND'],
  [{ code: '42501', message: 'permission denied for function' }, 'FORBIDDEN'],
  [{ code: '42501', message: 'an authenticated requester is required' }, 'UNAUTHORIZED'],
]) {
  test(`command adapters sanitize provider errors as ${expectedCode}`, async () => {
    const { client } = createClientDouble({ response: { data: null, error: providerError } });
    await assertPersistenceCode(
      createRequestRepository(client).createProductionOrder(CREATE_COMMAND),
      expectedCode
    );
  });
}

test('malformed envelopes and mismatched receipts never escape as partial success', async () => {
  for (const response of [
    null,
    {},
    { data: [CREATE_RECEIPT_ROW] },
    { error: null },
    { data: [{ ...CREATE_RECEIPT_ROW, opp_id: 'different' }], error: null },
  ]) {
    const { client } = createClientDouble({ response });
    await assertPersistenceCode(
      createRequestRepository(client).createProductionOrder(CREATE_COMMAND),
      'INVALID_RESPONSE'
    );
  }
});

test('transport failures become unavailable without retrying either RPC', async () => {
  for (const createRepository of [createRequestRepository, createTransitionRepository]) {
    const { client, calls } = createClientDouble({
      failure: { name: 'AbortError', message: 'private provider timeout' },
    });
    const repository = createRepository(client);
    const promise =
      repository instanceof SupabaseProductionOrderRequestRepository
        ? repository.createProductionOrder(CREATE_COMMAND)
        : repository.transitionProductionOrder(TRANSITION_COMMAND);
    await assertPersistenceCode(promise, 'UNAVAILABLE');
    assert.equal(calls.length, 1);
  }
});

test('telemetry is allowlisted and excludes requester, command and payload data', async () => {
  const requesterEntries = [];
  const requester = createClientDouble();
  await createRequestRepository(requester.client, requesterEntries).createProductionOrder(
    CREATE_COMMAND
  );
  assert.deepEqual(Object.keys(requesterEntries[0]).sort(), [
    'adapter',
    'aggregateId',
    'aggregateType',
    'durationMs',
    'operation',
    'outcome',
    'rowCount',
  ]);

  const systemEntries = [];
  const system = createClientDouble({
    response: { data: [TRANSITION_RECEIPT_ROW], error: null },
  });
  await createTransitionRepository(system.client, systemEntries).transitionProductionOrder(
    TRANSITION_COMMAND
  );
  assert.deepEqual(Object.keys(systemEntries[0]).sort(), [
    'adapter',
    'aggregateId',
    'aggregateType',
    'correlationId',
    'durationMs',
    'operation',
    'outcome',
    'rowCount',
  ]);
  assert.doesNotMatch(
    JSON.stringify([...requesterEntries, ...systemEntries]),
    /requesterId|commandId|theme|reason|credential/i
  );
});

test('failure telemetry contains only the provider-neutral error code', async () => {
  const entries = [];
  const { client } = createClientDouble({
    response: { data: null, error: { code: 'PT409', message: 'private provider conflict' } },
  });
  await assertPersistenceCode(
    createTransitionRepository(client, entries).transitionProductionOrder(TRANSITION_COMMAND),
    'CONFLICT'
  );
  assert.equal(entries[0].errorCode, 'CONFLICT');
  assert.doesNotMatch(JSON.stringify(entries), /PT409|private provider|requesterId|reason/i);
});

test('logger failures cannot change successful command results', async () => {
  const logger = {
    record() {
      throw new Error('synthetic logger failure');
    },
  };
  const requester = createClientDouble();
  assert.equal(
    (
      await createRequestRepository(
        requester.client,
        [],
        REQUESTER_ID,
        logger
      ).createProductionOrder(CREATE_COMMAND)
    ).replayed,
    false
  );
});

test('shared error mapper distinguishes missing identity from generic forbidden execution', () => {
  assert.equal(
    toPersistenceError({ code: '42501', message: 'an authenticated requester is required' }, 'test')
      .code,
    'UNAUTHORIZED'
  );
  assert.equal(
    toPersistenceError({ code: '42501', message: 'permission denied for function' }, 'test').code,
    'FORBIDDEN'
  );
});

test('command adapter sources contain no direct DML, client creation or context fallback', async () => {
  const requesterSource = await readFile(
    new URL(
      '../src/production-order/supabase-production-order-request.repository.ts',
      import.meta.url
    ),
    'utf8'
  );
  const transitionSource = await readFile(
    new URL(
      '../src/production-order/supabase-production-order-transition.repository.ts',
      import.meta.url
    ),
    'utf8'
  );
  for (const source of [requesterSource, transitionSource]) {
    assert.doesNotMatch(
      source,
      /\.from\s*\(|\.insert\s*\(|\.update\s*\(|\.upsert\s*\(|\.delete\s*\(/
    );
    assert.doesNotMatch(source, /process\.env|createClient\s*\(/);
  }
  assert.doesNotMatch(requesterSource, /SupabaseSystemContext|service[_-]?role/i);
  assert.doesNotMatch(transitionSource, /SupabaseRequesterContext|auth\.|getUser\s*\(/i);
});
