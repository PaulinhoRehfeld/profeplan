import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  CARTOGRAPHIC_CANDIDATE_STATES,
  CARTOGRAPHIC_NODE_KINDS,
  CARTOGRAPHIC_PART_SCOPE_REASONS,
  CARTOGRAPHIC_REGION_KINDS,
  CARTOGRAPHY_EVIDENCE_SOURCE_KINDS,
  DOCUMENT_METADATA_OBSERVATION_KINDS,
  FILENAME_HINT_KINDS,
  STRUCTURAL_RECOGNITION_CONTRACT_VERSION,
} from '../src/index.ts';

test('structural recognition exposes a versioned preliminary-cartography vocabulary', () => {
  assert.equal(STRUCTURAL_RECOGNITION_CONTRACT_VERSION, '1.0.0');

  assert.deepEqual(FILENAME_HINT_KINDS, [
    'collection',
    'school_component',
    'volume_designation',
    'manifestation_role',
    'program_cycle',
    'other',
  ]);

  assert.equal(DOCUMENT_METADATA_OBSERVATION_KINDS.includes('isbn'), true);
  assert.equal(DOCUMENT_METADATA_OBSERVATION_KINDS.includes('manifestation_role'), true);
  assert.equal(CARTOGRAPHIC_REGION_KINDS.includes('work_organization'), true);
  assert.equal(CARTOGRAPHIC_REGION_KINDS.includes('table_of_contents'), true);
  assert.equal(CARTOGRAPHIC_REGION_KINDS.includes('teacher_manual'), true);
  assert.equal(CARTOGRAPHIC_NODE_KINDS.includes('part'), true);
  assert.equal(CARTOGRAPHIC_NODE_KINDS.includes('chapter'), true);
  assert.equal(CARTOGRAPHIC_NODE_KINDS.includes('subsection'), true);
});

test('preliminary cartography cannot claim C.4 structural confirmation', () => {
  assert.deepEqual(CARTOGRAPHIC_CANDIDATE_STATES, [
    'candidate',
    'reviewed_candidate',
    'rejected',
  ]);
  assert.equal(CARTOGRAPHIC_CANDIDATE_STATES.includes('confirmed'), false);
  assert.equal(CARTOGRAPHIC_CANDIDATE_STATES.includes('canonical'), false);
});

test('cartography keeps evidence sources and part-scope boundaries explicit', () => {
  assert.equal(CARTOGRAPHY_EVIDENCE_SOURCE_KINDS.includes('filename'), true);
  assert.equal(CARTOGRAPHY_EVIDENCE_SOURCE_KINDS.includes('table_of_contents'), true);
  assert.equal(CARTOGRAPHY_EVIDENCE_SOURCE_KINDS.includes('work_organization'), true);
  assert.equal(CARTOGRAPHY_EVIDENCE_SOURCE_KINDS.includes('human_review'), true);

  assert.deepEqual(CARTOGRAPHIC_PART_SCOPE_REASONS, [
    'table_of_contents_boundary',
    'work_organization_boundary',
    'body_heading_boundary',
    'pdf_bookmark_boundary',
    'human_review_boundary',
  ]);
});

test('cartography contract remains provider-neutral and free of downstream semantic surfaces', async () => {
  const source = await readFile(
    new URL('../src/knowledge-factory/cartography.ts', import.meta.url),
    'utf8'
  );

  const forbidden = [
    '@supabase',
    'SupabaseClient',
    'bucket',
    'signedUrl',
    'tesseract',
    'Textract',
    'OpenAI',
    'Anthropic',
    'embedding',
    'pgvector',
    'bnccValidation',
    'canonicalHierarchy',
  ];

  for (const token of forbidden) {
    assert.equal(source.includes(token), false, `forbidden cartography surface leaked: ${token}`);
  }

  assert.equal(source.includes("import type { ExtractionPageRef } from './extraction.ts';"), true);
  assert.equal(source.includes('printedPageLabel'), false);
});
