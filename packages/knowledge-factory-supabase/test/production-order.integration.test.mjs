import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import test from 'node:test';
import { SupabaseClient } from '@supabase/supabase-js';
import { SupabaseProductionOrderReadRepository } from '../src/index.ts';
import { createSyntheticAuthPassword } from './support/synthetic-auth.mjs';

const SUPABASE_URL = process.env.KF_SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.KF_SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  throw new Error('Disposable Supabase credentials were not provided to the integration test');
}

const clientOptions = {
  auth: {
    persistSession: false,
    autoRefreshToken: false,
    detectSessionInUrl: false,
  },
};
const systemClient = new SupabaseClient(SUPABASE_URL, SERVICE_ROLE_KEY, clientOptions);

let requesterA;
let requesterB;
let orderAId;
let orderBId;
let eventAIds;

async function createRequester(label) {
  const email = `kf-opp-${label}-${randomUUID()}@example.invalid`;
  const password = createSyntheticAuthPassword();
  const { data: created, error: createError } = await systemClient.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  });
  assert.equal(createError, null);
  assert.ok(created.user?.id);

  const authClient = new SupabaseClient(SUPABASE_URL, SERVICE_ROLE_KEY, clientOptions);
  const { data: session, error: signInError } = await authClient.auth.signInWithPassword({
    email,
    password,
  });
  assert.equal(signInError, null);
  assert.equal(session.user?.id, created.user.id);
  const accessToken = session.session?.access_token;
  assert.ok(accessToken);

  const client = new SupabaseClient(SUPABASE_URL, accessToken, {
    ...clientOptions,
    global: { headers: { Authorization: `Bearer ${accessToken}` } },
  });

  return Object.freeze({ client, requesterId: created.user.id });
}

async function countRows(table) {
  const { count, error } = await systemClient
    .from(table)
    .select('id', { count: 'exact', head: true });
  assert.equal(error, null);
  assert.equal(typeof count, 'number');
  return count;
}

async function createProductionOrderFixture({
  requester,
  commandId,
  orderId,
  eventId,
  curriculumPackageId,
  agentProfileId,
  productType,
  theme,
  durationMinutes,
  occurredAt,
}) {
  const order = {
    id: orderId,
    version: '1.0.0',
    agentProfileId,
    curriculumPackageId,
    productType,
    theme,
  };
  if (durationMinutes !== undefined) {
    order.durationMinutes = durationMinutes;
  }

  const { data, error } = await requester.client.rpc('kf_create_production_order', {
    p_command_id: commandId,
    p_payload: {
      order,
      eventId,
      eventVersion: '1.0.0',
      occurredAt,
    },
  });
  assert.equal(error, null);
  assert.equal(data?.[0]?.opp_id, orderId);
  assert.equal(data?.[0]?.event_id, eventId);
  assert.equal(data?.[0]?.status, 'requested');
  assert.equal(data?.[0]?.replayed, false);
}

async function transitionProductionOrderFixture({
  commandId,
  requesterId,
  orderId,
  expectedStatus,
  expectedUpdatedAt,
  toStatus,
  eventId,
  occurredAt,
  reason,
}) {
  const payload = {
    requesterId,
    oppId: orderId,
    expectedStatus,
    expectedUpdatedAt,
    toStatus,
    eventId,
    eventVersion: '1.0.0',
    occurredAt,
  };
  if (reason !== undefined) {
    payload.reason = reason;
  }

  const { data, error } = await systemClient.rpc('kf_transition_production_order', {
    p_command_id: commandId,
    p_payload: payload,
  });
  assert.equal(error, null);
  assert.equal(data?.[0]?.opp_id, orderId);
  assert.equal(data?.[0]?.event_id, eventId);
  assert.equal(data?.[0]?.status, toStatus);
  assert.equal(data?.[0]?.replayed, false);
}

test.before(async () => {
  requesterA = await createRequester('a');
  requesterB = await createRequester('b');

  const curriculumPackageId = randomUUID();
  orderAId = randomUUID();
  orderBId = randomUUID();
  const createdEventId = randomUUID();
  const tiedEventIds = [randomUUID(), randomUUID()].sort();
  eventAIds = [createdEventId, ...tiedEventIds];
  const eventBId = randomUUID();

  const { error: packageError } = await systemClient.from('kf_curriculum_packages').insert({
    id: curriculumPackageId,
    version: '2026.1',
    state: 'MG',
    stage: 'ensino_medio',
    status: 'draft',
    title: `Synthetic requester adapter package ${curriculumPackageId}`,
    effective_from: '2026-08-11T12:00:00.000Z',
  });
  assert.equal(packageError, null);

  await createProductionOrderFixture({
    requester: requesterA,
    commandId: randomUUID(),
    orderId: orderAId,
    eventId: createdEventId,
    curriculumPackageId,
    agentProfileId: randomUUID(),
    productType: 'lesson_plan',
    theme: 'Synthetic requester A theme',
    durationMinutes: 50,
    occurredAt: '2026-08-11T12:00:00.000Z',
  });
  await transitionProductionOrderFixture({
    commandId: randomUUID(),
    requesterId: requesterA.requesterId,
    orderId: orderAId,
    expectedStatus: 'requested',
    expectedUpdatedAt: '2026-08-11T12:00:00.000Z',
    toStatus: 'scoped',
    eventId: tiedEventIds[0],
    occurredAt: '2026-08-11T12:05:00.000Z',
  });
  await transitionProductionOrderFixture({
    commandId: randomUUID(),
    requesterId: requesterA.requesterId,
    orderId: orderAId,
    expectedStatus: 'scoped',
    expectedUpdatedAt: '2026-08-11T12:05:00.000Z',
    toStatus: 'blocked',
    eventId: tiedEventIds[1],
    occurredAt: '2026-08-11T12:05:00.000Z',
    reason: 'Synthetic deterministic ordering event',
  });
  await createProductionOrderFixture({
    requester: requesterB,
    commandId: randomUUID(),
    orderId: orderBId,
    eventId: eventBId,
    curriculumPackageId,
    agentProfileId: randomUUID(),
    productType: 'didactic_text',
    theme: 'Synthetic requester B theme',
    occurredAt: '2026-08-11T12:00:00.000Z',
  });
});

test('REQUESTER adapters read only their own OPP and keep foreign OPP absent', async () => {
  const repositoryA = new SupabaseProductionOrderReadRepository(requesterA);
  const repositoryB = new SupabaseProductionOrderReadRepository(requesterB);
  const before = {
    orders: await countRows('kf_production_orders'),
    events: await countRows('kf_production_order_events'),
  };

  const orderA = await repositoryA.findById(orderAId);
  assert.equal(orderA?.id, orderAId);
  assert.equal(orderA?.requesterId, requesterA.requesterId);
  assert.equal(orderA?.durationMinutes, 50);
  assert.equal(await repositoryA.findById(orderBId), null);

  const orderB = await repositoryB.findById(orderBId);
  assert.equal(orderB?.id, orderBId);
  assert.equal(orderB?.requesterId, requesterB.requesterId);
  assert.ok(!('durationMinutes' in orderB));
  assert.equal(await repositoryB.findById(orderAId), null);

  assert.deepEqual(
    {
      orders: await countRows('kf_production_orders'),
      events: await countRows('kf_production_order_events'),
    },
    before
  );
});

test('REQUESTER event reads preserve RLS isolation and deterministic ordering', async () => {
  const repositoryA = new SupabaseProductionOrderReadRepository(requesterA);
  const repositoryB = new SupabaseProductionOrderReadRepository(requesterB);

  const eventsA = await repositoryA.listEvents(orderAId);
  assert.deepEqual(
    eventsA.map((event) => event.id),
    eventAIds
  );
  assert.ok(eventsA.every((event) => event.oppId === orderAId));
  assert.deepEqual(await repositoryA.listEvents(orderBId), []);
  assert.deepEqual(await repositoryB.listEvents(orderAId), []);
  assert.equal((await repositoryB.listEvents(orderBId)).length, 1);
});
