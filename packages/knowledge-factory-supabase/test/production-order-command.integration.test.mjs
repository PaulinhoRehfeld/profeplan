import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import test from 'node:test';
import { SupabaseClient } from '@supabase/supabase-js';
import {
  SupabaseProductionOrderReadRepository,
  SupabaseProductionOrderRequestRepository,
  SupabaseProductionOrderTransitionRepository,
} from '../src/index.ts';
import { createSyntheticAuthPassword } from './support/synthetic-auth.mjs';

const SUPABASE_URL = process.env.KF_SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.KF_SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  throw new Error('Disposable Supabase credentials were not provided to the integration test');
}

const clientOptions = {
  auth: { persistSession: false, autoRefreshToken: false, detectSessionInUrl: false },
};
const systemClient = new SupabaseClient(SUPABASE_URL, SERVICE_ROLE_KEY, clientOptions);

async function createRequester() {
  const email = `kf-opp-command-${randomUUID()}@example.invalid`;
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

test('REQUESTER and SYSTEM command adapters use only their approved transactional RPCs', async () => {
  const requester = await createRequester();
  const requestRepository = new SupabaseProductionOrderRequestRepository(requester);
  const readRepository = new SupabaseProductionOrderReadRepository(requester);
  const transitionRepository = new SupabaseProductionOrderTransitionRepository({
    client: systemClient,
    correlationId: randomUUID(),
  });

  const curriculumPackageId = randomUUID();
  const orderId = randomUUID();
  const createdEventId = randomUUID();
  const createdAt = '2026-08-11T22:00:00.000Z';
  const createCommand = {
    commandId: randomUUID(),
    order: {
      id: orderId,
      version: '1.0.0',
      agentProfileId: randomUUID(),
      curriculumPackageId,
      productType: 'lesson_plan',
      theme: `Synthetic OPP command adapter ${orderId}`,
      durationMinutes: 50,
    },
    eventId: createdEventId,
    eventVersion: '1.0.0',
    occurredAt: createdAt,
  };

  const { error: packageError } = await systemClient.from('kf_curriculum_packages').insert({
    id: curriculumPackageId,
    version: '2026.1',
    state: 'MG',
    stage: 'ensino_medio',
    status: 'draft',
    title: `Synthetic OPP command package ${curriculumPackageId}`,
    effective_from: createdAt,
  });
  assert.equal(packageError, null);

  const created = await requestRepository.createProductionOrder(createCommand);
  assert.equal(created.operation, 'create_production_order');
  assert.equal(created.oppId, orderId);
  assert.equal(created.eventId, createdEventId);
  assert.equal(created.status, 'requested');
  assert.equal(created.replayed, false);

  const replayedCreate = await requestRepository.createProductionOrder(createCommand);
  assert.equal(replayedCreate.replayed, true);
  assert.equal(replayedCreate.committedAt, created.committedAt);
  await assert.rejects(
    requestRepository.createProductionOrder({
      ...createCommand,
      order: { ...createCommand.order, theme: 'Different synthetic theme' },
    }),
    { code: 'CONFLICT' }
  );

  const requestedOrder = await readRepository.findById(orderId);
  assert.equal(requestedOrder?.requesterId, requester.requesterId);
  assert.equal(requestedOrder?.status, 'requested');
  assert.deepEqual(
    (await readRepository.listEvents(orderId)).map((event) => event.id),
    [createdEventId]
  );

  const transitionCommand = {
    commandId: randomUUID(),
    requesterId: requester.requesterId,
    oppId: orderId,
    expectedStatus: 'requested',
    expectedUpdatedAt: createdAt,
    toStatus: 'scoped',
    eventId: randomUUID(),
    eventVersion: '1.0.0',
    reason: 'Synthetic application policy accepted the scope',
    occurredAt: '2026-08-11T22:05:00.000Z',
  };
  const transitioned = await transitionRepository.transitionProductionOrder(transitionCommand);
  assert.equal(transitioned.operation, 'transition_production_order');
  assert.equal(transitioned.status, 'scoped');
  assert.equal(transitioned.replayed, false);

  const replayedTransition =
    await transitionRepository.transitionProductionOrder(transitionCommand);
  assert.equal(replayedTransition.replayed, true);
  assert.equal(replayedTransition.committedAt, transitioned.committedAt);

  await assert.rejects(
    transitionRepository.transitionProductionOrder({
      ...transitionCommand,
      commandId: randomUUID(),
      eventId: randomUUID(),
    }),
    { code: 'CONFLICT' }
  );
  await assert.rejects(
    transitionRepository.transitionProductionOrder({
      ...transitionCommand,
      commandId: randomUUID(),
      requesterId: randomUUID(),
      expectedStatus: 'scoped',
      expectedUpdatedAt: transitionCommand.occurredAt,
      toStatus: 'retrieving',
      eventId: randomUUID(),
      occurredAt: '2026-08-11T22:10:00.000Z',
    }),
    { code: 'NOT_FOUND' }
  );

  const scopedOrder = await readRepository.findById(orderId);
  assert.equal(scopedOrder?.status, 'scoped');
  assert.deepEqual(
    (await readRepository.listEvents(orderId)).map((event) => event.id),
    [createdEventId, transitionCommand.eventId]
  );

  const requesterAsSystem = new SupabaseProductionOrderTransitionRepository({
    client: requester.client,
  });
  await assert.rejects(
    requesterAsSystem.transitionProductionOrder({
      ...transitionCommand,
      commandId: randomUUID(),
      expectedStatus: 'scoped',
      expectedUpdatedAt: transitionCommand.occurredAt,
      toStatus: 'retrieving',
      eventId: randomUUID(),
      occurredAt: '2026-08-11T22:10:00.000Z',
    }),
    { code: 'FORBIDDEN' }
  );

  const systemAsRequester = new SupabaseProductionOrderRequestRepository({
    client: systemClient,
    requesterId: requester.requesterId,
  });
  await assert.rejects(
    systemAsRequester.createProductionOrder({
      ...createCommand,
      commandId: randomUUID(),
      order: { ...createCommand.order, id: randomUUID() },
      eventId: randomUUID(),
    }),
    { code: 'FORBIDDEN' }
  );
});
