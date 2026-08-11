import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  KnowledgeFactoryPersistenceError,
  SupabasePedagogicalComponentCommandRepository,
  componentCommandToRpcPayload,
  componentWriteReceiptRowToReceipt,
  toPersistenceError,
} from '../src/index.ts';

const COMMAND_ID = 'e9000000-0000-4000-8000-000000000001';
const COMPONENT_ID = 'e3000000-0000-4000-8000-000000000001';
const VERSION_ID = 'e3100000-0000-4000-8000-000000000001';
const EVIDENCE_ID = 'e3200000-0000-4000-8000-000000000001';
const SOURCE_ID = 'e1000000-0000-4000-8000-000000000001';
const SOURCE_VERSION_ID = 'e1100000-0000-4000-8000-000000000001';
const SOURCE_SEGMENT_ID = 'e1200000-0000-4000-8000-000000000001';
const CURRICULUM_NODE_ID = 'e2100000-0000-4000-8000-000000000001';
const OCCURRED_AT = '2026-08-11T12:00:00.000Z';

const COMPONENT = Object.freeze({
  id: COMPONENT_ID,
  version: '1.0.0',
  canonicalKey: 'synthetic-command-adapter',
  title: 'Synthetic command adapter',
  componentType: 'concept',
  schoolComponent: 'Filosofia',
  grades: Object.freeze(['2_em']),
  status: 'draft',
  currentVersionId: VERSION_ID,
  createdAt: OCCURRED_AT,
  updatedAt: OCCURRED_AT,
});

const VERSION = Object.freeze({
  id: VERSION_ID,
  version: '1.0.0',
  componentId: COMPONENT_ID,
  summary: 'Synthetic command adapter version',
  keywords: Object.freeze(['synthetic', 'command']),
  sourceEvidenceIds: Object.freeze([EVIDENCE_ID]),
  curriculumNodeIds: Object.freeze([CURRICULUM_NODE_ID]),
  status: 'draft',
});

const EVIDENCE = Object.freeze({
  id: EVIDENCE_ID,
  version: '1.0.0',
  componentVersionId: VERSION_ID,
  sourceId: SOURCE_ID,
  sourceVersionId: SOURCE_VERSION_ID,
  sourceSegmentId: SOURCE_SEGMENT_ID,
  contribution: 'conceptual',
  recordedAt: OCCURRED_AT,
});

const CREATE_COMMAND = Object.freeze({
  commandId: COMMAND_ID,
  component: COMPONENT,
  initialVersion: VERSION,
  evidenceOrigins: Object.freeze([EVIDENCE]),
});

const RECEIPT_ROW = Object.freeze({
  command_id: COMMAND_ID,
  operation: 'create_component_aggregate',
  component_id: COMPONENT_ID,
  component_version_id: VERSION_ID,
  replayed: false,
  committed_at: OCCURRED_AT,
});

function createClientDouble({ response = { data: [RECEIPT_ROW], error: null }, failure } = {}) {
  const calls = [];
  const client = {
    secret: 'service-role-must-never-be-logged',
    rpc(name, args) {
      calls.push(['rpc', name, args]);
      return failure ? Promise.reject(failure) : Promise.resolve(response);
    },
    from() {
      throw new Error('command adapter must not issue direct table queries');
    },
  };
  return { client, calls };
}

function createRepository(client, entries = [], logger) {
  return new SupabasePedagogicalComponentCommandRepository(
    { client, correlationId: 'ea000000-0000-4000-8000-000000000001' },
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
      /service-role|private provider|PT409|P0002|22023|23514/i
    );
    return true;
  });
}

test('command mapper removes commandId and preserves the closed payload', () => {
  assert.deepEqual(componentCommandToRpcPayload(CREATE_COMMAND), {
    component: COMPONENT,
    initialVersion: VERSION,
    evidenceOrigins: [EVIDENCE],
  });
});

test('command mapper rejects a payload without commandId', () => {
  assert.throws(() => componentCommandToRpcPayload({ component: COMPONENT }), {
    code: 'INVALID_RESPONSE',
  });
});

test('receipt mapper reconstructs and freezes a provider-neutral receipt', () => {
  const receipt = componentWriteReceiptRowToReceipt([RECEIPT_ROW], {
    commandId: COMMAND_ID,
    operation: 'create_component_aggregate',
    componentId: COMPONENT_ID,
    componentVersionId: VERSION_ID,
  });
  assert.deepEqual(receipt, {
    commandId: COMMAND_ID,
    operation: 'create_component_aggregate',
    componentId: COMPONENT_ID,
    componentVersionId: VERSION_ID,
    replayed: false,
    committedAt: OCCURRED_AT,
  });
  assert.ok(Object.isFrozen(receipt));
});

test('receipt mapper preserves replay and the original commit timestamp', () => {
  const receipt = componentWriteReceiptRowToReceipt([{ ...RECEIPT_ROW, replayed: true }], {
    commandId: COMMAND_ID,
    operation: 'create_component_aggregate',
    componentId: COMPONENT_ID,
    componentVersionId: VERSION_ID,
  });
  assert.equal(receipt.replayed, true);
  assert.equal(receipt.committedAt, OCCURRED_AT);
});

test('receipt mapper requires exactly one row', () => {
  const expected = {
    commandId: COMMAND_ID,
    operation: 'create_component_aggregate',
    componentId: COMPONENT_ID,
    componentVersionId: VERSION_ID,
  };
  for (const value of [null, {}, [], [RECEIPT_ROW, RECEIPT_ROW]]) {
    assert.throws(() => componentWriteReceiptRowToReceipt(value, expected), {
      code: 'INVALID_RESPONSE',
    });
  }
});

test('receipt mapper validates command, operation and aggregate identities', () => {
  const expected = {
    commandId: COMMAND_ID,
    operation: 'create_component_aggregate',
    componentId: COMPONENT_ID,
    componentVersionId: VERSION_ID,
  };
  for (const row of [
    { ...RECEIPT_ROW, command_id: 'different' },
    { ...RECEIPT_ROW, operation: 'append_component_version' },
    { ...RECEIPT_ROW, component_id: 'different' },
    { ...RECEIPT_ROW, component_version_id: 'different' },
  ]) {
    assert.throws(() => componentWriteReceiptRowToReceipt([row], expected), {
      code: 'INVALID_RESPONSE',
    });
  }
});

test('receipt mapper rejects invalid replay flags and timestamps', () => {
  const expected = {
    commandId: COMMAND_ID,
    operation: 'create_component_aggregate',
    componentId: COMPONENT_ID,
    componentVersionId: VERSION_ID,
  };
  for (const row of [
    { ...RECEIPT_ROW, replayed: 'false' },
    { ...RECEIPT_ROW, committed_at: 'not-a-date' },
    { ...RECEIPT_ROW, committed_at: '2026-08-11' },
    { ...RECEIPT_ROW, committed_at: '2026-02-30T12:00:00Z' },
  ]) {
    assert.throws(() => componentWriteReceiptRowToReceipt([row], expected), {
      code: 'INVALID_RESPONSE',
    });
  }
});

test('create calls only its approved RPC with commandId separated from payload', async () => {
  const { client, calls } = createClientDouble();
  const receipt = await createRepository(client).createComponentAggregate(CREATE_COMMAND);
  assert.equal(receipt.componentId, COMPONENT_ID);
  assert.deepEqual(calls, [
    [
      'rpc',
      'kf_create_pedagogical_component_aggregate',
      {
        p_command_id: COMMAND_ID,
        p_payload: {
          component: COMPONENT,
          initialVersion: VERSION,
          evidenceOrigins: [EVIDENCE],
        },
      },
    ],
  ]);
});

test('append calls only its approved RPC and validates the version identity', async () => {
  const command = {
    commandId: COMMAND_ID,
    expectedCurrentVersionId: 'e3100000-0000-4000-8000-000000000000',
    version: VERSION,
    evidenceOrigins: [EVIDENCE],
  };
  const { client, calls } = createClientDouble({
    response: {
      data: [
        {
          ...RECEIPT_ROW,
          operation: 'append_component_version',
        },
      ],
      error: null,
    },
  });
  const receipt = await createRepository(client).appendComponentVersion(command);
  assert.equal(receipt.operation, 'append_component_version');
  assert.equal(calls[0][1], 'kf_append_pedagogical_component_version');
  assert.ok(!('commandId' in calls[0][2].p_payload));
});

test('transition calls only its approved RPC and validates both aggregate ids', async () => {
  const command = {
    commandId: COMMAND_ID,
    componentId: COMPONENT_ID,
    componentVersionId: VERSION_ID,
    expectedStatus: 'draft',
    toStatus: 'in_review',
    occurredAt: OCCURRED_AT,
  };
  const { client, calls } = createClientDouble({
    response: {
      data: [{ ...RECEIPT_ROW, operation: 'transition_component_version_status' }],
      error: null,
    },
  });
  const receipt = await createRepository(client).transitionComponentVersionStatus(command);
  assert.equal(receipt.operation, 'transition_component_version_status');
  assert.equal(calls[0][1], 'kf_transition_pedagogical_component_version_status');
});

test('promote calls only its approved RPC and maps targetVersionId to the receipt', async () => {
  const command = {
    commandId: COMMAND_ID,
    componentId: COMPONENT_ID,
    targetVersionId: VERSION_ID,
    expectedCurrentVersionId: 'e3100000-0000-4000-8000-000000000000',
    expectedComponentUpdatedAt: OCCURRED_AT,
    occurredAt: OCCURRED_AT,
  };
  const { client, calls } = createClientDouble({
    response: {
      data: [{ ...RECEIPT_ROW, operation: 'promote_component_version' }],
      error: null,
    },
  });
  const receipt = await createRepository(client).promoteComponentVersion(command);
  assert.equal(receipt.componentVersionId, VERSION_ID);
  assert.equal(calls[0][1], 'kf_promote_pedagogical_component_version');
});

test('PT409 becomes a provider-neutral conflict', async () => {
  const { client } = createClientDouble({
    response: { data: null, error: { code: 'PT409', message: 'private provider conflict' } },
  });
  await assertPersistenceCode(
    createRepository(client).createComponentAggregate(CREATE_COMMAND),
    'CONFLICT'
  );
});

test('P0002 becomes provider-neutral not found', async () => {
  const { client } = createClientDouble({
    response: { data: null, error: { code: 'P0002', message: 'private provider missing row' } },
  });
  await assertPersistenceCode(
    createRepository(client).createComponentAggregate(CREATE_COMMAND),
    'NOT_FOUND'
  );
});

test('22023 becomes provider-neutral invalid input', async () => {
  const { client } = createClientDouble({
    response: { data: null, error: { code: '22023', message: 'private provider invalid input' } },
  });
  await assertPersistenceCode(
    createRepository(client).createComponentAggregate(CREATE_COMMAND),
    'INVALID_INPUT'
  );
});

test('constraint failures keep the existing provider-neutral taxonomy', async () => {
  const { client } = createClientDouble({
    response: { data: null, error: { code: '23514', message: 'private provider constraint' } },
  });
  await assertPersistenceCode(
    createRepository(client).createComponentAggregate(CREATE_COMMAND),
    'CONSTRAINT_VIOLATION'
  );
});

test('malformed provider envelopes are rejected as invalid responses', async () => {
  for (const response of [null, {}, { data: [RECEIPT_ROW] }, { error: null }]) {
    const { client } = createClientDouble({ response });
    await assertPersistenceCode(
      createRepository(client).createComponentAggregate(CREATE_COMMAND),
      'INVALID_RESPONSE'
    );
  }
});

test('receipt mismatches never escape as partial success', async () => {
  const { client } = createClientDouble({
    response: { data: [{ ...RECEIPT_ROW, component_id: 'different' }], error: null },
  });
  await assertPersistenceCode(
    createRepository(client).createComponentAggregate(CREATE_COMMAND),
    'INVALID_RESPONSE'
  );
});

test('transport failures become unavailable without retrying the RPC', async () => {
  const { client, calls } = createClientDouble({
    failure: { name: 'AbortError', message: 'private network timeout' },
  });
  await assertPersistenceCode(
    createRepository(client).createComponentAggregate(CREATE_COMMAND),
    'UNAVAILABLE'
  );
  assert.equal(calls.length, 1);
});

test('successful telemetry is allowlisted and contains no command payload', async () => {
  const entries = [];
  const { client } = createClientDouble();
  await createRepository(client, entries).createComponentAggregate(CREATE_COMMAND);
  assert.deepEqual(Object.keys(entries[0]).sort(), [
    'adapter',
    'aggregateId',
    'aggregateType',
    'correlationId',
    'durationMs',
    'operation',
    'outcome',
    'rowCount',
  ]);
  assert.doesNotMatch(JSON.stringify(entries), /commandId|canonicalKey|service-role/i);
});

test('failure telemetry exposes only the provider-neutral error code', async () => {
  const entries = [];
  const { client } = createClientDouble({
    response: { data: null, error: { code: 'PT409', message: 'private provider conflict' } },
  });
  await assertPersistenceCode(
    createRepository(client, entries).createComponentAggregate(CREATE_COMMAND),
    'CONFLICT'
  );
  assert.equal(entries[0].errorCode, 'CONFLICT');
  assert.doesNotMatch(JSON.stringify(entries), /PT409|private provider|service-role/i);
});

test('logger failures cannot change a successful command result', async () => {
  const { client } = createClientDouble();
  const repository = createRepository(client, [], {
    record() {
      throw new Error('logger unavailable');
    },
  });
  assert.equal((await repository.createComponentAggregate(CREATE_COMMAND)).replayed, false);
});

test('shared error mapper distinguishes all command SQLSTATEs without provider text', () => {
  assert.equal(toPersistenceError({ code: 'PT409' }, 'test').code, 'CONFLICT');
  assert.equal(toPersistenceError({ code: 'P0002' }, 'test').code, 'NOT_FOUND');
  assert.equal(toPersistenceError({ code: '22023' }, 'test').code, 'INVALID_INPUT');
});

test('command adapter source contains no direct DML or environment wiring', async () => {
  const source = await readFile(
    new URL(
      '../src/component/supabase-pedagogical-component-command.repository.ts',
      import.meta.url
    ),
    'utf8'
  );
  assert.doesNotMatch(source, /\.from\s*\(|\.insert\s*\(|\.update\s*\(|\.delete\s*\(/);
  assert.doesNotMatch(source, /process\.env|createClient|service[_-]?role/i);
});
