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
    snapshotId: 'snapshot-golden-for-unit-1',
    sourceVersion: { kind: 'source_version', id: 'source-version-golden-001' },
    artifact: verifiedGoldenSampleArtifact(),
    createdAt: '2026-08-18T20:30:00.000Z',
    filename: GOLDEN_SAMPLE_FILENAME,
    filenameHintRules: filenameRules,
  });
}

test('Unit 1 is reconstructed with chapter hierarchy without reading unrelated parts', async () => {
  const inspector = new PdfJsDocumentInspectorAdapter();
  const recognition = await recognizeGoldenSample(inspector);
  const unit = recognition.snapshot.nodes.find(
    (node) => node.kind === 'unit' && node.observedTitle === 'Unidade 1 - Cultura e cotidiano'
  );
  const chapter = recognition.snapshot.nodes.find(
    (node) =>
      node.kind === 'chapter' && node.observedTitle === 'Capitulo 1 - Olhares sobre a cultura'
  );

  assert.ok(unit?.pageRange, 'cartography must delimit Unit 1');
  assert.ok(chapter?.pageRange, 'cartography must delimit Chapter 1');
  assert.deepEqual(unit.pageRange, { startPhysicalPage: 14, endPhysicalPage: 17 });
  assert.equal(unit.declaredPrintedPageLabel, '13');
  assert.equal(chapter.parentNodeId, unit.nodeId);
  assert.equal(chapter.declaredPrintedPageLabel, '14');

  const partScope = {
    scopeId: 'cartographic-scope:unit-1',
    snapshotId: recognition.snapshot.snapshotId,
    rootNodeId: unit.nodeId,
    pageRange: unit.pageRange,
    reason: 'table_of_contents_boundary',
    confidence: unit.confidence,
  };

  const reconstruction = await new PartReconstructionService(inspector).reconstruct({
    snapshotId: 'part-reconstruction:unit-1:001',
    artifact: verifiedGoldenSampleArtifact(),
    recognition: recognition.snapshot,
    partScope,
    createdAt: '2026-08-18T20:31:00.000Z',
  });

  assert.equal(reconstruction.contractVersion, '1.0.0');
  assert.deepEqual(reconstruction.partScope.pageRange, {
    startPhysicalPage: 14,
    endPhysicalPage: 17,
  });
  assert.deepEqual(
    reconstruction.inspectedPages.map((page) => [
      page.physicalPageNumber,
      page.printedPageLabel,
    ]),
    [
      [14, '13'],
      [15, '14'],
      [16, '15'],
      [17, '16'],
    ]
  );
  assert.equal(
    reconstruction.inspectedPages.some((page) =>
      [11, 12, 13, 18, 19].includes(page.physicalPageNumber)
    ),
    false
  );

  const byKind = (kind) => reconstruction.elements.filter((element) => element.kind === kind);
  const partTitle = byKind('part_title')[0];
  const chapterHeading = byKind('chapter_heading')[0];

  assert.equal(partTitle?.text, 'Unidade 1 - Cultura e cotidiano');
  assert.equal(chapterHeading?.text, 'Capitulo 1 - Olhares sobre a cultura');
  assert.equal(chapterHeading?.parentElementId, partTitle?.elementId);
  assert.equal(
    chapterHeading?.evidence.some((evidence) => evidence.cartographicNodeId === chapter.nodeId),
    true
  );
  assert.equal(
    reconstruction.relations.some(
      (relation) =>
        relation.kind === 'contains' &&
        relation.fromElementId === partTitle?.elementId &&
        relation.toElementId === chapterHeading?.elementId
    ),
    true
  );

  const chapterContinuation = reconstruction.elements.filter(
    (element) =>
      element.kind === 'body_text' &&
      [16, 17].includes(element.page.physicalPageNumber)
  );
  assert.equal(chapterContinuation.length, 4);
  assert.equal(
    chapterContinuation.every((element) => element.parentElementId === chapterHeading?.elementId),
    true
  );
  assert.deepEqual(
    chapterContinuation.map((element) => element.text),
    [
      'Texto do capitulo',
      'Conteudo sintetico destinado somente ao teste.',
      'Galeria de atividades',
      'Atividades sinteticas de encerramento.',
    ]
  );

  assert.equal(byKind('activity_heading').length, 0);
  assert.equal(byKind('teacher_guidance_heading').length, 0);
  assert.equal(byKind('teacher_guidance_text').length, 0);
  assert.deepEqual(reconstruction.warnings, []);
});
