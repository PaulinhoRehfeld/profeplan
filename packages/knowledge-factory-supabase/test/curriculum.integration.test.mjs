import assert from 'node:assert/strict';
import test from 'node:test';
import { SupabaseClient } from '@supabase/supabase-js';
import { SupabaseCurriculumRepository } from '../src/index.ts';

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
const repository = new SupabaseCurriculumRepository({
  client,
  correlationId: 'a1000000-0000-4000-8000-000000000001',
});

const SOURCE_A_ID = 'a2000000-0000-4000-8000-000000000002';
const SOURCE_B_ID = 'a3000000-0000-4000-8000-000000000003';
const SOURCE_C_ID = 'a4000000-0000-4000-8000-000000000004';
const SOURCE_VERSION_A_ID = 'a5000000-0000-4000-8000-000000000005';
const SOURCE_VERSION_B_ID = 'a6000000-0000-4000-8000-000000000006';
const SOURCE_VERSION_C_ID = 'a7000000-0000-4000-8000-000000000007';
const HIGH_SCHOOL_PACKAGE_ID = 'a8000000-0000-4000-8000-000000000008';
const FUNDAMENTAL_PACKAGE_ID = 'a9000000-0000-4000-8000-000000000009';
const HIGH_SCHOOL_NODE_A_ID = 'aa000000-0000-4000-8000-00000000000a';
const HIGH_SCHOOL_NODE_B_ID = 'ab000000-0000-4000-8000-00000000000b';
const FUNDAMENTAL_NODE_ID = 'ac000000-0000-4000-8000-00000000000c';

test('CurriculumRepository disambiguates active MG packages by stage and hydrates sources', async () => {
  const now = '2026-08-07T12:00:00.000Z';
  const { error: sourceError } = await client.from('kf_sources').insert(
    [SOURCE_A_ID, SOURCE_B_ID, SOURCE_C_ID].map((id, index) => ({
      id,
      version: '1.0.0',
      title: `Synthetic curriculum source ${index + 1}`,
      source_type: 'wrtech_owned',
      status: 'approved',
      license_category: 'owned',
      allowed_uses: ['retrieval'],
      created_at: now,
      updated_at: now,
    }))
  );
  assert.equal(sourceError, null);

  const { error: versionError } = await client.from('kf_source_versions').insert([
    {
      id: SOURCE_VERSION_A_ID,
      version: '1.0.0',
      source_id: SOURCE_A_ID,
      checksum: 'sha256:curriculum-source-a',
      effective_at: now,
    },
    {
      id: SOURCE_VERSION_B_ID,
      version: '1.0.0',
      source_id: SOURCE_B_ID,
      checksum: 'sha256:curriculum-source-b',
      effective_at: now,
    },
    {
      id: SOURCE_VERSION_C_ID,
      version: '1.0.0',
      source_id: SOURCE_C_ID,
      checksum: 'sha256:curriculum-source-c',
      effective_at: now,
    },
  ]);
  assert.equal(versionError, null);

  const { error: packageError } = await client.from('kf_curriculum_packages').insert([
    {
      id: FUNDAMENTAL_PACKAGE_ID,
      version: '2026.1',
      state: 'MG',
      stage: 'fundamental_ii',
      status: 'active',
      title: 'Synthetic MG fundamental package',
      effective_from: now,
    },
    {
      id: HIGH_SCHOOL_PACKAGE_ID,
      version: '2026.1',
      state: 'MG',
      stage: 'ensino_medio',
      status: 'active',
      title: 'Synthetic MG high school package',
      effective_from: now,
    },
  ]);
  assert.equal(packageError, null);

  const { error: packageSourceError } = await client.from('kf_curriculum_package_sources').insert([
    {
      curriculum_package_id: HIGH_SCHOOL_PACKAGE_ID,
      source_version_id: SOURCE_VERSION_B_ID,
    },
    {
      curriculum_package_id: FUNDAMENTAL_PACKAGE_ID,
      source_version_id: SOURCE_VERSION_C_ID,
    },
    {
      curriculum_package_id: HIGH_SCHOOL_PACKAGE_ID,
      source_version_id: SOURCE_VERSION_A_ID,
    },
  ]);
  assert.equal(packageSourceError, null);

  const highSchool = await repository.findActivePackageByStateAndStage('MG', 'ensino_medio');
  const fundamental = await repository.findActivePackageByStateAndStage('MG', 'fundamental_ii');

  assert.equal(highSchool?.id, HIGH_SCHOOL_PACKAGE_ID);
  assert.equal(highSchool?.stage, 'ensino_medio');
  assert.deepEqual(highSchool?.sourceVersionIds, [SOURCE_VERSION_A_ID, SOURCE_VERSION_B_ID]);
  assert.equal(fundamental?.id, FUNDAMENTAL_PACKAGE_ID);
  assert.equal(fundamental?.stage, 'fundamental_ii');
  assert.deepEqual(fundamental?.sourceVersionIds, [SOURCE_VERSION_C_ID]);
  assert.equal(await repository.findPackageById('ad000000-0000-4000-8000-00000000000d'), null);
});

test('CurriculumRepository isolates nodes by package and returns deterministic order', async () => {
  const { error: nodeError } = await client.from('kf_curriculum_nodes').insert([
    {
      id: HIGH_SCHOOL_NODE_B_ID,
      version: '1.0.0',
      curriculum_package_id: HIGH_SCHOOL_PACKAGE_ID,
      node_type: 'knowledge_object',
      code: 'SYN-MG-PHI-2-002',
      title: 'Synthetic high school node B',
      description: 'Synthetic description B',
      component: 'Filosofia',
      grades: ['2_em'],
    },
    {
      id: FUNDAMENTAL_NODE_ID,
      version: '1.0.0',
      curriculum_package_id: FUNDAMENTAL_PACKAGE_ID,
      node_type: 'skill',
      code: 'SYN-MG-FII-9-001',
      title: 'Synthetic fundamental node',
      description: 'Synthetic fundamental description',
      component: 'Ensino Religioso',
      grades: ['9'],
    },
    {
      id: HIGH_SCHOOL_NODE_A_ID,
      version: '1.0.0',
      curriculum_package_id: HIGH_SCHOOL_PACKAGE_ID,
      node_type: 'skill',
      code: 'SYN-MG-PHI-2-001',
      title: 'Synthetic high school node A',
      description: 'Synthetic description A',
      component: 'Filosofia',
      grades: ['2_em'],
    },
  ]);
  assert.equal(nodeError, null);

  const highSchoolNodes = await repository.listNodesByPackage(HIGH_SCHOOL_PACKAGE_ID);
  assert.deepEqual(
    highSchoolNodes.map((node) => [node.id, node.code, node.curriculumPackageId]),
    [
      [HIGH_SCHOOL_NODE_A_ID, 'SYN-MG-PHI-2-001', HIGH_SCHOOL_PACKAGE_ID],
      [HIGH_SCHOOL_NODE_B_ID, 'SYN-MG-PHI-2-002', HIGH_SCHOOL_PACKAGE_ID],
    ]
  );
  assert.equal((await repository.findNodeById(HIGH_SCHOOL_NODE_A_ID))?.id, HIGH_SCHOOL_NODE_A_ID);
  assert.equal((await repository.findNodeById(FUNDAMENTAL_NODE_ID))?.id, FUNDAMENTAL_NODE_ID);
  assert.equal(await repository.findNodeById('ae000000-0000-4000-8000-00000000000e'), null);
});
