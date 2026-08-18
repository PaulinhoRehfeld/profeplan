import assert from 'node:assert/strict';
import test from 'node:test';
import {
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
  {
    token: 'PNLD26',
    kind: 'program_cycle',
    interpretedValue: 'PNLD 2026',
    confidence: 0.95,
  },
];

test('selective PDF inspector preserves global page labels while reading only requested pages', async () => {
  const inspector = new PdfJsDocumentInspectorAdapter();
  const result = await inspector.inspect({
    artifact: verifiedGoldenSampleArtifact(),
    pageRanges: [
      { startPhysicalPage: 1, endPhysicalPage: 1 },
      { startPhysicalPage: 7, endPhysicalPage: 7 },
      { startPhysicalPage: 11, endPhysicalPage: 11 },
    ],
  });

  assert.equal(result.totalPhysicalPages, 19);
  assert.deepEqual(
    result.pages.map((page) => page.physicalPageNumber),
    [1, 7, 11]
  );
  assert.equal(result.pageRefs[0].printedPageLabel, 'Capa');
  assert.equal(result.pageRefs[6].printedPageLabel, '6');
  assert.equal(result.pageRefs[10].printedPageLabel, '10');
  assert.match(result.pages[1].text, /Sumario/);
  assert.match(result.pages[2].text, /Introducao/);
});

test('structural recognition finds the map before deep-reading the synthetic book', async () => {
  const service = new StructuralRecognitionService(new PdfJsDocumentInspectorAdapter());
  const result = await service.recognize({
    snapshotId: 'snapshot-golden-001',
    sourceVersion: { kind: 'source_version', id: 'source-version-golden-001' },
    artifact: verifiedGoldenSampleArtifact(),
    createdAt: '2026-08-18T18:30:00.000Z',
    filename: GOLDEN_SAMPLE_FILENAME,
    filenameHintRules: filenameRules,
  });

  assert.equal(result.snapshot.totalPhysicalPages, 19);
  assert.deepEqual(
    result.snapshot.filenameHints.map((hint) => [hint.kind, hint.interpretedValue]),
    [
      ['collection', 'Horizontes'],
      ['school_component', 'Sociologia'],
      ['volume_designation', 'volume_unico'],
      ['manifestation_role', 'teacher_manual'],
      ['program_cycle', 'PNLD 2026'],
    ]
  );

  const workOrganization = result.snapshot.regions.find(
    (region) => region.kind === 'work_organization'
  );
  const toc = result.snapshot.regions.find((region) => region.kind === 'table_of_contents');
  const teacherManual = result.snapshot.regions.find(
    (region) => region.kind === 'teacher_manual'
  );
  const references = result.snapshot.regions.find((region) => region.kind === 'references');

  assert.deepEqual(workOrganization?.pageRange, {
    startPhysicalPage: 5,
    endPhysicalPage: 5,
  });
  assert.equal(toc?.pageRange.startPhysicalPage, 7);
  assert.deepEqual(teacherManual?.pageRange, {
    startPhysicalPage: 18,
    endPhysicalPage: 18,
  });
  assert.deepEqual(references?.pageRange, {
    startPhysicalPage: 19,
    endPhysicalPage: 19,
  });

  const introduction = result.snapshot.nodes.find(
    (node) => node.kind === 'part' && node.observedTitle === 'Introducao'
  );
  const unit = result.snapshot.nodes.find(
    (node) => node.kind === 'unit' && node.observedTitle.startsWith('Unidade 1')
  );
  assert.deepEqual(introduction?.pageRange, {
    startPhysicalPage: 11,
    endPhysicalPage: 13,
  });
  assert.equal(introduction?.declaredPrintedPageLabel, '10');
  assert.equal(introduction?.evidence.some((evidence) => evidence.sourceKind === 'page_text'), true);
  assert.equal(unit?.pageRange?.startPhysicalPage, 14);

  assert.deepEqual(result.nextPartScope, {
    scopeId: 'cartographic-scope:introduction',
    snapshotId: 'snapshot-golden-001',
    rootNodeId: introduction?.nodeId,
    pageRange: { startPhysicalPage: 11, endPhysicalPage: 13 },
    reason: 'table_of_contents_boundary',
    confidence: 0.97,
  });

  assert.deepEqual(result.snapshot.inspectedPageRanges, [
    { startPhysicalPage: 1, endPhysicalPage: 8 },
    { startPhysicalPage: 11, endPhysicalPage: 11 },
    { startPhysicalPage: 14, endPhysicalPage: 14 },
    { startPhysicalPage: 17, endPhysicalPage: 19 },
  ]);
  assert.equal(
    result.snapshot.inspectedPageRanges.reduce(
      (sum, range) => sum + range.endPhysicalPage - range.startPhysicalPage + 1,
      0
    ) < result.snapshot.totalPhysicalPages,
    true
  );
  assert.deepEqual(result.snapshot.warnings, []);
});

test('full C.3.3 native extraction still reads every page after inspector reuse', async () => {
  const { PdfJsNativeTextExtractorAdapter, extractVerifiedNativeText } = await import('../src/index.ts');
  const result = await extractVerifiedNativeText(
    new PdfJsNativeTextExtractorAdapter(),
    verifiedGoldenSampleArtifact()
  );

  assert.equal(result.pageCount, 19);
  assert.deepEqual(
    result.pages.map((page) => page.physicalPageNumber),
    Array.from({ length: 19 }, (_, index) => index + 1)
  );
  assert.equal(result.pages[6].printedPageLabel, '6');
  assert.equal(result.pages[10].printedPageLabel, '10');
});
