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

  const { error: orderError } = await systemClient.from('kf_production_orders').insert([
    {
      id: orderAId,
      version: '1.0.0',
      requester_id: requesterA.requesterId,
      agent_profile_id: randomUUID(),
      curriculum_package_id: curriculumPackageId,
      product_type: 'lesson_plan',
      theme: 'Synthetic requester A theme',
      duration_minutes: 50,
      status: 'blocked',
      created_at: '2026-08-11T12:00:00.000Z',
      updated_at: '2026-08-11T12:05:00.000Z',
    },
    {
      id: orderBId,
      version: '1.0.0',
      requester_id: requesterB.requesterId,
      agent_profile_id: randomUUID(),
      curriculum_package_id: curriculumPackageId,
      product_type: 'didactic_text',
      theme: 'Synthetic requester B theme',
      status: 'requested',
      created_at: '2026-08-11T12:00:00.000Z',
      updated_at: '2026-08-11T12:00:00.000Z',
    },
  ]);
  assert.equal(orderError, null);

  const { error: eventError } = await systemClient.from('kf_production_order_events').insert([
    {
      id: createdEventId,
      version: '1.0.0',
      opp_id: orderAId,
      event_type: 'created',
      to_status: 'requested',
      occurred_at: '2026-08-11T12:00:00.000Z',
    },
    {
      id: tiedEventIds[1],
      version: '1.0.0',
      opp_id: orderAId,
      event_type: 'blocked',
      from_status: 'scoped',
      to_status: 'blocked',
      reason: 'Synthetic deterministic ordering event',
      occurred_at: '2026-08-11T12:05:00.000Z',
    },
    {
      id: tiedEventIds[0],
      version: '1.0.0',
      opp_id: orderAId,
      event_type: 'scope_resolved',
      from_status: 'requested',
      to_status: 'scoped',
      occurred_at: '2026-08-11T12:05:00.000Z',
    },
    {
      id: eventBId,
      version: '1.0.0',
      opp_id: orderBId,
      event_type: 'created',
      to_status: 'requested',
      occurred_at: '2026-08-11T12:00:00.000Z',
    },
  ]);
  assert.equal(eventError, null);
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
