import assert from 'node:assert/strict';
import test from 'node:test';
import { SupabaseClient } from '@supabase/supabase-js';
import { SupabasePedagogicalComponentCommandRepository } from '../src/index.ts';

const SUPABASE_URL = process.env.KF_SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.KF_SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  throw new Error('Disposable Supabase credentials were not provided to the integration test');
}

const client = new SupabaseClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
  auth: { persistSession: false, autoRefreshToken: false, detectSessionInUrl: false },
});
const repository = new SupabasePedagogicalComponentCommandRepository({
  client,
  correlationId: 'fa000000-0000-4000-8000-000000000001',
});

const SOURCE_ID = 'c1000000-0000-4000-8000-000000000001';
const SOURCE_VERSION_ID = 'c1100000-0000-4000-8000-000000000001';
const SOURCE_SEGMENT_ID = 'c1200000-0000-4000-8000-000000000001';
const CURRICULUM_NODE_ID = 'c2100000-0000-4000-8000-000000000001';
const COMPONENT_ID = 'f3000000-0000-4000-8000-000000000001';
const INITIAL_VERSION_ID = 'f3100000-0000-4000-8000-000000000001';
const TARGET_VERSION_ID = 'f3100000-0000-4000-8000-000000000002';
const INITIAL_EVIDENCE_ID = 'f3200000-0000-4000-8000-000000000001';
const TARGET_EVIDENCE_ID = 'f3200000-0000-4000-8000-000000000002';
const INITIAL_TIME = '2026-08-11T12:00:00.000Z';

function evidence(id, componentVersionId) {
  return {
    id,
    version: '1.0.0',
    componentVersionId,
    sourceId: SOURCE_ID,
    sourceVersionId: SOURCE_VERSION_ID,
    sourceSegmentId: SOURCE_SEGMENT_ID,
    contribution: 'conceptual',
    recordedAt: INITIAL_TIME,
  };
}

test('command adapter completes create, replay, conflict, append, approval and promotion', async () => {
  const createCommand = {
    commandId: 'f9000000-0000-4000-8000-000000000001',
    component: {
      id: COMPONENT_ID,
      version: '1.0.0',
      canonicalKey: 'synthetic-command-adapter-integration',
      title: 'Synthetic command adapter integration',
      componentType: 'concept',
      schoolComponent: 'Filosofia',
      grades: ['2_em'],
      status: 'draft',
      currentVersionId: INITIAL_VERSION_ID,
      createdAt: INITIAL_TIME,
      updatedAt: INITIAL_TIME,
    },
    initialVersion: {
      id: INITIAL_VERSION_ID,
      version: '1.0.0',
      componentId: COMPONENT_ID,
      summary: 'Initial synthetic adapter version',
      keywords: ['synthetic', 'adapter'],
      sourceEvidenceIds: [INITIAL_EVIDENCE_ID],
      curriculumNodeIds: [CURRICULUM_NODE_ID],
      status: 'draft',
    },
    evidenceOrigins: [evidence(INITIAL_EVIDENCE_ID, INITIAL_VERSION_ID)],
  };

  const created = await repository.createComponentAggregate(createCommand);
  assert.equal(created.replayed, false);
  const replayed = await repository.createComponentAggregate(createCommand);
  assert.equal(replayed.replayed, true);
  assert.equal(replayed.committedAt, created.committedAt);

  await assert.rejects(
    repository.createComponentAggregate({
      ...createCommand,
      component: { ...createCommand.component, title: 'Different valid title' },
    }),
    { code: 'CONFLICT' }
  );

  const appended = await repository.appendComponentVersion({
    commandId: 'f9000000-0000-4000-8000-000000000002',
    expectedCurrentVersionId: INITIAL_VERSION_ID,
    version: {
      id: TARGET_VERSION_ID,
      version: '2.0.0',
      componentId: COMPONENT_ID,
      summary: 'Target synthetic adapter version',
      keywords: ['synthetic', 'adapter', 'target'],
      sourceEvidenceIds: [TARGET_EVIDENCE_ID],
      curriculumNodeIds: [CURRICULUM_NODE_ID],
      supersedesVersion: '1.0.0',
      status: 'draft',
    },
    evidenceOrigins: [evidence(TARGET_EVIDENCE_ID, TARGET_VERSION_ID)],
  });
  assert.equal(appended.operation, 'append_component_version');

  const submittedForReview = await repository.transitionComponentVersionStatus({
    commandId: 'f9000000-0000-4000-8000-000000000003',
    componentId: COMPONENT_ID,
    componentVersionId: TARGET_VERSION_ID,
    expectedStatus: 'draft',
    toStatus: 'in_review',
    occurredAt: '2026-08-11T12:30:00.000Z',
  });
  assert.equal(submittedForReview.operation, 'transition_component_version_status');

  const approved = await repository.transitionComponentVersionStatus({
    commandId: 'f9000000-0000-4000-8000-000000000004',
    componentId: COMPONENT_ID,
    componentVersionId: TARGET_VERSION_ID,
    expectedStatus: 'in_review',
    toStatus: 'approved',
    occurredAt: '2026-08-11T12:45:00.000Z',
  });
  assert.equal(approved.operation, 'transition_component_version_status');

  const promoted = await repository.promoteComponentVersion({
    commandId: 'f9000000-0000-4000-8000-000000000005',
    componentId: COMPONENT_ID,
    targetVersionId: TARGET_VERSION_ID,
    expectedCurrentVersionId: INITIAL_VERSION_ID,
    expectedComponentUpdatedAt: INITIAL_TIME,
    occurredAt: '2026-08-11T13:00:00.000Z',
  });
  assert.equal(promoted.operation, 'promote_component_version');
  assert.equal(promoted.componentVersionId, TARGET_VERSION_ID);

  const { data, error } = await client
    .from('kf_pedagogical_components')
    .select('current_version_id,status,updated_at')
    .eq('id', COMPONENT_ID)
    .single();
  assert.equal(error, null);
  assert.equal(data.current_version_id, TARGET_VERSION_ID);
  assert.equal(data.status, 'approved');
  assert.equal(Date.parse(data.updated_at), Date.parse('2026-08-11T13:00:00.000Z'));
});
