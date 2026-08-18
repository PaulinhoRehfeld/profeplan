import assert from 'node:assert/strict';
import test from 'node:test';
import {
  PartReconstructionService,
  PdfJsDocumentInspectorAdapter,
  StructuralRecognitionService,
} from '../src/index.ts';
import {
  GOLDEN_SAMPLE_FILENAME,
  verifiedGoldenSampleArtifact,
} from './synthetic-structural-book.fixture.mjs';

const filenameRules = [
  {
    token: 'HORIZONTES',
    kind: 'collection',
    interpretedValue: 'Horizontes',
    confidence: 0.95,
  },
  {
    token: 'SOCIOLOGIA',
    kind: 'school_component',
    interpretedValue: 'Sociologia',
    confidence: 0.99,
  },
  {
    token: 'VU',
    kind: 'volume_designation',
    interpretedValue: 'volume_unico',
    confidence: 0.98,
  },
  {
    token: 'MP',
    kind: 'manifestation_role',
    interpretedValue: 'teacher_manual',
    confidence: 0.98,
  },
];

async function recognizeGoldenSample(inspector) {
  return new StructuralRecognitionService(inspector).recognize({
    snapshotId: 'snapshot-golden-for-introduction',
    sourceVersion: { kind: 'source_version', id: 'source-version-golden-001' },
    artifact: verifiedGoldenSampleArtifact(),
    createdAt: '2026-08-18T18:45:00.000Z',
    filename: GOLDEN_SAMPLE_FILENAME,
    filenameHintRules: filenameRules,
  });
}

test('PDF.js inspector observes the synthetic image as a physical image marker', async () => {
  const inspector = new PdfJsDocumentInspectorAdapter();
  const inspection = await inspector.inspect({
    artifact: verifiedGoldenSampleArtifact(),
    pageRanges: [{ startPhysicalPage: 12, endPhysicalPage: 12 }],
  });

  const imageMarkers = inspection.pages[0].elements.filter(
    (element) => element.kind === 'image_marker'
  );
  assert.equal(imageMarkers.length, 1);
  assert.equal(imageMarkers[0].logicalLocator, 'page:12/image:1');
  assert.equal(imageMarkers[0].text, undefined);
});

test('Introduction is reconstructed without deep-reading the rest of the book', async () => {
  const inspector = new PdfJsDocumentInspectorAdapter();
  const recognition = await recognizeGoldenSample(inspector);
  assert.ok(recognition.nextPartScope, 'recognition must select the Introduction scope');

  const reconstruction = await new PartReconstructionService(inspector).reconstruct({
    snapshotId: 'part-reconstruction:introduction:001',
    artifact: verifiedGoldenSampleArtifact(),
    recognition: recognition.snapshot,
    partScope: recognition.nextPartScope,
    createdAt: '2026-08-18T18:46:00.000Z',
  });

  assert.deepEqual(reconstruction.partScope.pageRange, {
    startPhysicalPage: 11,
    endPhysicalPage: 13,
  });
  assert.deepEqual(
    reconstruction.inspectedPages.map((page) => page.physicalPageNumber),
    [11, 12, 13, 18]
  );
  assert.equal(
    reconstruction.inspectedPages.some((page) =>
      [14, 15, 16, 17, 19].includes(page.physicalPageNumber)
    ),
    false
  );

  const byKind = (kind) => reconstruction.elements.filter((element) => element.kind === kind);
  assert.deepEqual(byKind('part_title').map((element) => element.text), ['Introducao']);
  assert.deepEqual(byKind('section_heading').map((element) => element.text), [
    'Por que estudamos a vida coletiva?',
    'A convivencia e suas regras',
  ]);
  assert.deepEqual(byKind('activity_heading').map((element) => element.text), [
    'Atividade guiada',
  ]);
  assert.deepEqual(byKind('activity_prompt').map((element) => element.text), [
    'Compare duas situacoes ficticias e identifique regras sociais presentes em cada uma.',
  ]);
  assert.deepEqual(byKind('caption').map((element) => element.text), [
    'Legenda: imagem sintetica de formas diferentes de convivencia.',
  ]);
  assert.equal(byKind('visual_marker').length, 1);
  assert.equal(byKind('visual_marker')[0].page.physicalPageNumber, 12);
  assert.deepEqual(byKind('teacher_guidance_heading').map((element) => element.text), [
    'Atividade guiada - orientacao',
  ]);
  assert.deepEqual(byKind('teacher_guidance_text').map((element) => element.text), [
    'Espera-se que o estudante compare regras e justifique sua leitura com evidencias.',
  ]);

  const caption = byKind('caption')[0];
  const visual = byKind('visual_marker')[0];
  const activity = byKind('activity_heading')[0];
  const guidance = byKind('teacher_guidance_heading')[0];
  assert.equal(
    reconstruction.relations.some(
      (relation) =>
        relation.kind === 'caption_for_visual' &&
        relation.fromElementId === caption.elementId &&
        relation.toElementId === visual.elementId
    ),
    true
  );
  assert.equal(
    reconstruction.relations.some(
      (relation) =>
        relation.kind === 'teacher_guidance_for_activity' &&
        relation.fromElementId === guidance.elementId &&
        relation.toElementId === activity.elementId
    ),
    true
  );

  assert.deepEqual(reconstruction.warnings, []);
});
