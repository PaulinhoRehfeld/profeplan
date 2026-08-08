import assert from 'node:assert/strict';
import test from 'node:test';
import { SupabaseClient } from '@supabase/supabase-js';
import { SupabasePedagogicalComponentReadRepository } from '../src/index.ts';

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
const repository = new SupabasePedagogicalComponentReadRepository({
  client,
  correlationId: 'c0000000-0000-4000-8000-000000000001',
});

const COMPONENT_A_ID = 'c3000000-0000-4000-8000-000000000001';
const COMPONENT_EMPTY_ID = 'c3000000-0000-4000-8000-000000000002';
const COMPONENT_VERSION_A_ID = 'c3100000-0000-4000-8000-000000000001';
const COMPONENT_VERSION_EMPTY_ID = 'c3100000-0000-4000-8000-000000000002';
const EVIDENCE_IDS_BY_ID = [
  'c3200000-0000-4000-8000-000000000001',
  'c3200000-0000-4000-8000-000000000002',
  'c3200000-0000-4000-8000-000000000003',
];
const EVIDENCE_IDS_BY_TIME_AND_ID = [
  'c3200000-0000-4000-8000-000000000002',
  'c3200000-0000-4000-8000-000000000003',
  'c3200000-0000-4000-8000-000000000001',
];
const CURRICULUM_NODE_IDS = [
  'c2100000-0000-4000-8000-000000000001',
  'c2100000-0000-4000-8000-000000000002',
];

async function countRows(table) {
  const { count, error } = await client.from(table).select('id', { count: 'exact', head: true });
  assert.equal(error, null);
  assert.equal(typeof count, 'number');
  return count;
}

test('PedagogicalComponent read adapter reconstructs synthetic rows without writing', async () => {
  const before = {
    components: await countRows('kf_pedagogical_components'),
    versions: await countRows('kf_component_versions'),
    evidence: await countRows('kf_component_source_evidence'),
  };
  const { count: linksBefore, error: linksBeforeError } = await client
    .from('kf_component_curriculum_links')
    .select('component_version_id', { count: 'exact', head: true });
  assert.equal(linksBeforeError, null);
  assert.equal(typeof linksBefore, 'number');

  const component = await repository.findById(COMPONENT_A_ID);
  assert.equal(component?.id, COMPONENT_A_ID);
  assert.equal(component?.currentVersionId, COMPONENT_VERSION_A_ID);
  assert.equal(component?.componentType, 'concept');
  assert.deepEqual(component?.grades, ['2_em']);
  assert.equal(Date.parse(component.createdAt), Date.parse('2026-08-08T12:00:00.000Z'));
  assert.equal(await repository.findById('cf000000-0000-4000-8000-000000000001'), null);

  const version = await repository.findVersion(COMPONENT_A_ID, '1.0.0');
  assert.equal(version?.id, COMPONENT_VERSION_A_ID);
  assert.deepEqual(version?.sourceEvidenceIds, EVIDENCE_IDS_BY_ID);
  assert.deepEqual(version?.curriculumNodeIds, CURRICULUM_NODE_IDS);
  assert.equal(await repository.findVersion(COMPONENT_A_ID, 'missing'), null);

  const emptyVersion = await repository.findVersion(COMPONENT_EMPTY_ID, '1.0.0');
  assert.equal(emptyVersion?.id, COMPONENT_VERSION_EMPTY_ID);
  assert.deepEqual(emptyVersion?.sourceEvidenceIds, []);
  assert.deepEqual(emptyVersion?.curriculumNodeIds, []);

  const evidenceOrigins = await repository.listEvidenceOrigins(COMPONENT_VERSION_A_ID);
  assert.deepEqual(
    evidenceOrigins.map((evidence) => evidence.id),
    EVIDENCE_IDS_BY_TIME_AND_ID
  );
  assert.deepEqual(
    evidenceOrigins.map((evidence) => evidence.componentVersionId),
    [COMPONENT_VERSION_A_ID, COMPONENT_VERSION_A_ID, COMPONENT_VERSION_A_ID]
  );
  assert.deepEqual(await repository.listEvidenceOrigins(COMPONENT_VERSION_EMPTY_ID), []);
  assert.ok(
    !evidenceOrigins.some((evidence) => evidence.id === 'c3200000-0000-4000-8000-000000000004')
  );

  assert.deepEqual(
    {
      components: await countRows('kf_pedagogical_components'),
      versions: await countRows('kf_component_versions'),
      evidence: await countRows('kf_component_source_evidence'),
    },
    before
  );
  const { count: linksAfter, error: linksAfterError } = await client
    .from('kf_component_curriculum_links')
    .select('component_version_id', { count: 'exact', head: true });
  assert.equal(linksAfterError, null);
  assert.equal(linksAfter, linksBefore);
});

test('disposable schema enforces component relationship foreign keys for administrative fixtures', async () => {
  const { error } = await client.from('kf_component_curriculum_links').insert({
    component_version_id: 'cf000000-0000-4000-8000-000000000002',
    curriculum_node_id: CURRICULUM_NODE_IDS[0],
  });
  assert.equal(error?.code, '23503');
});
