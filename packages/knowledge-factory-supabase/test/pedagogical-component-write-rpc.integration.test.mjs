import assert from 'node:assert/strict';
import test from 'node:test';
import { SupabaseClient } from '@supabase/supabase-js';

const SUPABASE_URL = process.env.KF_SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.KF_SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  throw new Error('Disposable Supabase credentials were not provided to the integration test');
}

const client = new SupabaseClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
  auth: {
    persistSession: false,
    autoRefreshToken: false,
    detectSessionInUrl: false,
  },
});

const SOURCE_ID = 'c1000000-0000-4000-8000-000000000001';
const SOURCE_VERSION_ID = 'c1100000-0000-4000-8000-000000000001';
const SOURCE_SEGMENT_ID = 'c1200000-0000-4000-8000-000000000001';
const CURRICULUM_NODE_ID = 'c2100000-0000-4000-8000-000000000001';
const INITIAL_TIME = '2026-08-08T21:00:00.000Z';

function evidence(versionId, evidenceId) {
  return {
    id: evidenceId,
    version: '1.0.0',
    componentVersionId: versionId,
    sourceId: SOURCE_ID,
    sourceVersionId: SOURCE_VERSION_ID,
    sourceSegmentId: SOURCE_SEGMENT_ID,
    contribution: 'conceptual',
    recordedAt: INITIAL_TIME,
  };
}

function version(componentId, versionId, versionTag, status, evidenceId) {
  const hasMaterial = evidenceId !== undefined;
  return {
    id: versionId,
    version: versionTag,
    componentId,
    summary: `Synthetic RPC integration version ${versionTag}.`,
    keywords: ['synthetic', 'rpc'],
    sourceEvidenceIds: hasMaterial ? [evidenceId] : [],
    curriculumNodeIds: hasMaterial ? [CURRICULUM_NODE_ID] : [],
    ...(versionTag === '1.0.0' ? {} : { supersedesVersion: '1.0.0' }),
    ...(status === 'approved' ? { approvedAt: INITIAL_TIME } : {}),
    status,
  };
}

function createPayload({ componentId, versionId, canonicalKey, status = 'draft', evidenceId }) {
  const initialVersion = version(componentId, versionId, '1.0.0', status, evidenceId);
  return {
    component: {
      id: componentId,
      version: '1.0.0',
      canonicalKey,
      title: 'Synthetic concurrent RPC component',
      componentType: 'concept',
      schoolComponent: 'Filosofia',
      grades: ['2_em'],
      status,
      currentVersionId: versionId,
      createdAt: INITIAL_TIME,
      updatedAt: INITIAL_TIME,
    },
    initialVersion,
    evidenceOrigins: evidenceId === undefined ? [] : [evidence(versionId, evidenceId)],
  };
}

function appendPayload({ componentId, currentVersionId, versionId, versionTag, evidenceId }) {
  return {
    expectedCurrentVersionId: currentVersionId,
    version: version(componentId, versionId, versionTag, 'approved', evidenceId),
    evidenceOrigins: [evidence(versionId, evidenceId)],
  };
}

async function rpc(name, commandId, payload) {
  return client.rpc(name, { p_command_id: commandId, p_payload: payload });
}

async function countBy(table, column, value) {
  const { count, error } = await client
    .from(table)
    .select(column, { count: 'exact', head: true })
    .eq(column, value);
  assert.equal(error, null);
  assert.equal(typeof count, 'number');
  return count;
}

test('simultaneous retries of one create command produce one commit and one replay', async () => {
  const componentId = 'd3000000-0000-4000-8000-000000000001';
  const versionId = 'd3100000-0000-4000-8000-000000000001';
  const evidenceId = 'd3200000-0000-4000-8000-000000000001';
  const commandId = 'd9000000-0000-4000-8000-000000000001';
  const payload = createPayload({
    componentId,
    versionId,
    evidenceId,
    canonicalKey: 'synthetic-concurrent-create-rpc',
    status: 'approved',
  });

  const results = await Promise.all([
    rpc('kf_create_pedagogical_component_aggregate', commandId, payload),
    rpc('kf_create_pedagogical_component_aggregate', commandId, payload),
  ]);

  for (const result of results) {
    assert.equal(result.error, null);
    assert.equal(result.data?.length, 1);
  }

  assert.deepEqual(results.map((result) => result.data[0].replayed).sort(), [false, true]);
  assert.equal(results[0].data[0].committed_at, results[1].data[0].committed_at);
  assert.equal(await countBy('kf_pedagogical_components', 'id', componentId), 1);
  assert.equal(await countBy('kf_component_versions', 'component_id', componentId), 1);
  assert.equal(await countBy('kf_component_source_evidence', 'component_version_id', versionId), 1);
  assert.equal(
    await countBy('kf_component_curriculum_links', 'component_version_id', versionId),
    1
  );

  const conflictingPayload = structuredClone(payload);
  conflictingPayload.component.title = 'Different valid synthetic title';
  const conflict = await rpc(
    'kf_create_pedagogical_component_aggregate',
    commandId,
    conflictingPayload
  );
  assert.equal(conflict.data, null);
  assert.equal(conflict.error?.code, '40001');
});

test('concurrent promotions from the same expected state have exactly one winner', async () => {
  const componentId = 'd3000000-0000-4000-8000-000000000002';
  const currentVersionId = 'd3100000-0000-4000-8000-000000000002';
  const targetAId = 'd3110000-0000-4000-8000-000000000002';
  const targetBId = 'd3120000-0000-4000-8000-000000000002';

  const created = await rpc(
    'kf_create_pedagogical_component_aggregate',
    'd9000000-0000-4000-8000-000000000010',
    createPayload({
      componentId,
      versionId: currentVersionId,
      canonicalKey: 'synthetic-concurrent-promotion-rpc',
    })
  );
  assert.equal(created.error, null);

  const appendA = await rpc(
    'kf_append_pedagogical_component_version',
    'd9000000-0000-4000-8000-000000000011',
    appendPayload({
      componentId,
      currentVersionId,
      versionId: targetAId,
      versionTag: '2.0.0',
      evidenceId: 'd3210000-0000-4000-8000-000000000002',
    })
  );
  assert.equal(appendA.error, null);

  const appendB = await rpc(
    'kf_append_pedagogical_component_version',
    'd9000000-0000-4000-8000-000000000012',
    appendPayload({
      componentId,
      currentVersionId,
      versionId: targetBId,
      versionTag: '3.0.0',
      evidenceId: 'd3220000-0000-4000-8000-000000000002',
    })
  );
  assert.equal(appendB.error, null);

  const promotionResults = await Promise.all([
    rpc('kf_promote_pedagogical_component_version', 'd9000000-0000-4000-8000-000000000013', {
      componentId,
      targetVersionId: targetAId,
      expectedCurrentVersionId: currentVersionId,
      expectedComponentUpdatedAt: INITIAL_TIME,
      occurredAt: '2026-08-08T22:00:00.000Z',
    }),
    rpc('kf_promote_pedagogical_component_version', 'd9000000-0000-4000-8000-000000000014', {
      componentId,
      targetVersionId: targetBId,
      expectedCurrentVersionId: currentVersionId,
      expectedComponentUpdatedAt: INITIAL_TIME,
      occurredAt: '2026-08-08T22:01:00.000Z',
    }),
  ]);

  const winners = promotionResults.filter((result) => result.error === null);
  const conflicts = promotionResults.filter((result) => result.error?.code === '40001');
  assert.equal(winners.length, 1);
  assert.equal(conflicts.length, 1);

  const { data: componentRows, error: componentError } = await client
    .from('kf_pedagogical_components')
    .select('current_version_id,status,updated_at')
    .eq('id', componentId)
    .single();
  assert.equal(componentError, null);
  assert.equal(componentRows.status, 'approved');
  assert.ok([targetAId, targetBId].includes(componentRows.current_version_id));
  assert.equal(componentRows.current_version_id, winners[0].data[0].component_version_id);
});
