import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  PART_RECONSTRUCTION_CONTRACT_VERSION,
  PART_RECONSTRUCTION_ELEMENT_KINDS,
  PART_RECONSTRUCTION_EVIDENCE_KINDS,
  PART_RECONSTRUCTION_RELATION_KINDS,
} from '../src/index.ts';

test('part reconstruction exposes only the first C.4-local candidate vocabulary', () => {
  assert.equal(PART_RECONSTRUCTION_CONTRACT_VERSION, '1.0.0');
  assert.deepEqual(PART_RECONSTRUCTION_ELEMENT_KINDS, [
    'part_title',
    'section_heading',
    'body_text',
    'activity_heading',
    'activity_prompt',
    'visual_marker',
    'caption',
    'teacher_guidance_heading',
    'teacher_guidance_text',
  ]);
  assert.deepEqual(PART_RECONSTRUCTION_RELATION_KINDS, [
    'contains',
    'caption_for_visual',
    'teacher_guidance_for_activity',
  ]);
  assert.deepEqual(PART_RECONSTRUCTION_EVIDENCE_KINDS, [
    'native_text',
    'observed_element',
    'cartographic_node',
    'teacher_manual_text',
  ]);
});

test('part reconstruction does not leak conceptual, curricular or retrieval authority', async () => {
  const source = await readFile(
    new URL('../src/knowledge-factory/reconstruction.ts', import.meta.url),
    'utf8'
  );
  const forbidden = [
    'embedding',
    'pgvector',
    'bncc',
    'curriculumValidation',
    'conceptGraph',
    'canonicalComponent',
    '@supabase',
    'SupabaseClient',
    'OpenAI',
    'Anthropic',
    'OCR',
  ];

  for (const token of forbidden) {
    assert.equal(source.includes(token), false, `forbidden reconstruction surface leaked: ${token}`);
  }
});
