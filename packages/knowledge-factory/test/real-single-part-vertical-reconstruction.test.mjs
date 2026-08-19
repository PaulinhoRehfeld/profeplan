import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  PartReconstructionService,
  PdfJsDocumentInspectorAdapter,
  StructuralRecognitionService,
} from '../src/index.ts';

const REAL_PILOT_PATH = process.env.PROFEPLAN_REAL_PILOT_PDF;
const EXPECTED_SHA256 = process.env.PROFEPLAN_REAL_PILOT_SHA256;
const runRealPilot = REAL_PILOT_PATH ? test : test.skip;

const CANONICAL_FILENAME = 'DOSEUJEITO_PNLD26_SOCIOLOGIA_VU_MP.pdf';
const GOVERNED_SHA256 = '1e7f8d613fdb43a49d4a1f0a031465784b03b31b1d22e1779d279365ad82e39a';

const filenameRules = [
  {
    token: 'PNLD26',
    kind: 'program_cycle',
    interpretedValue: 'PNLD 2026',
    confidence: 0.99,
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

function normalize(value) {
  return value
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLocaleLowerCase('pt-BR')
    .replace(/\s+/g, ' ')
    .trim();
}

function isInsideRange(physicalPageNumber, range) {
  return (
    physicalPageNumber >= range.startPhysicalPage &&
    physicalPageNumber <= range.endPhysicalPage
  );
}

async function temporaryVerifiedArtifact(path) {
  const buffer = await readFile(path);
  const sha256 = createHash('sha256').update(buffer).digest('hex');

  assert.equal(sha256, GOVERNED_SHA256, 'real-pilot PDF differs from the governed PNLD 2026 artifact');

  if (EXPECTED_SHA256) {
    assert.match(EXPECTED_SHA256, /^[0-9a-f]{64}$/u);
    assert.equal(sha256, EXPECTED_SHA256, 'real-pilot PDF digest changed');
  }

  return {
    artifact: {
      artifactId: 'artifact:first-real-single-part-pilot',
      sha256,
      sizeBytes: buffer.byteLength,
    },
    mediaType: 'application/pdf',
    expiresAt: '2099-01-01T00:00:00.000Z',
    sha256,
    body: new Uint8Array(buffer),
  };
}

runRealPilot(
  'real PNLD 2026 PDF reconstructs one mapped section without deep-reading the book',
  async () => {
    assert.ok(REAL_PILOT_PATH);

    const artifact = await temporaryVerifiedArtifact(REAL_PILOT_PATH);
    const inspector = new PdfJsDocumentInspectorAdapter();
    const recognition = await new StructuralRecognitionService(inspector).recognize({
      snapshotId: 'snapshot:first-real-single-part-pilot',
      sourceVersion: { kind: 'source_version', id: 'source-version:first-real-pilot' },
      artifact,
      createdAt: '2026-08-18T23:30:00.000Z',
      filename: CANONICAL_FILENAME,
      filenameHintRules: filenameRules,
    });

    assert.equal(recognition.snapshot.contractVersion, '1.0.0');
    assert.equal(recognition.snapshot.totalPhysicalPages, 449);
    assert.equal(recognition.snapshot.artifactSha256, GOVERNED_SHA256);

    const tocRegion = recognition.snapshot.regions.find(
      (region) => region.kind === 'table_of_contents'
    );
    assert.ok(tocRegion, 'cartography must observe the real Sumário');
    assert.equal(
      isInsideRange(7, tocRegion.pageRange),
      true,
      'physical page 7 must belong to the observed Sumário region'
    );

    const unit = recognition.snapshot.nodes.find((node) => {
      const title = normalize(node.observedTitle);
      return node.kind === 'unit' && title.includes('unidade 1') && title.includes('antropologia');
    });
    const chapter = recognition.snapshot.nodes.find((node) => {
      const title = normalize(node.observedTitle);
      return (
        node.kind === 'chapter' &&
        title.includes('capitulo 1') &&
        title.includes('pensamento antropologico')
      );
    });
    const section = recognition.snapshot.nodes.find(
      (node) => node.kind === 'section' && normalize(node.observedTitle) === 'evolucionismo social'
    );

    assert.ok(unit?.pageRange, 'cartography must delimit Unit 1 from the real Sumário');
    assert.equal(unit.pageRange.startPhysicalPage, 29);
    assert.equal(unit.declaredPrintedPageLabel, '28');

    assert.ok(chapter?.pageRange, 'cartography must delimit Chapter 1 from the real Sumário');
    assert.equal(chapter.pageRange.startPhysicalPage, 31);
    assert.equal(chapter.declaredPrintedPageLabel, '30');
    assert.equal(chapter.parentNodeId, unit.nodeId);

    assert.ok(section?.pageRange, 'cartography must delimit Evolucionismo social from real evidence');
    assert.deepEqual(section.pageRange, {
      startPhysicalPage: 34,
      endPhysicalPage: 35,
    });
    assert.equal(section.declaredPrintedPageLabel, '33');
    assert.equal(section.parentNodeId, chapter.nodeId);

    assert.equal(
      recognition.snapshot.nodes.every((node) =>
        ['candidate', 'reviewed_candidate', 'rejected'].includes(node.state)
      ),
      true,
      'structural recognition must remain candidate-only'
    );

    const partScope = {
      scopeId: 'cartographic-scope:first-real-evolucionismo-social',
      snapshotId: recognition.snapshot.snapshotId,
      rootNodeId: section.nodeId,
      pageRange: section.pageRange,
      reason: 'table_of_contents_boundary',
      confidence: section.confidence,
    };

    const reconstruction = await new PartReconstructionService(inspector).reconstruct({
      snapshotId: 'part-reconstruction:first-real-evolucionismo-social',
      artifact,
      recognition: recognition.snapshot,
      partScope,
      createdAt: '2026-08-18T23:31:00.000Z',
    });

    assert.equal(reconstruction.contractVersion, '1.0.0');
    assert.deepEqual(reconstruction.partScope.pageRange, {
      startPhysicalPage: 34,
      endPhysicalPage: 35,
    });

    const scopedPages = reconstruction.inspectedPages.filter((page) =>
      isInsideRange(page.physicalPageNumber, partScope.pageRange)
    );
    assert.deepEqual(
      scopedPages.map((page) => [page.physicalPageNumber, page.printedPageLabel]),
      [
        [34, '33'],
        [35, '34'],
      ],
      'physical and printed pagination must both survive the real reconstruction'
    );

    const outsideScope = reconstruction.inspectedPages.filter(
      (page) => !isInsideRange(page.physicalPageNumber, partScope.pageRange)
    );
    assert.deepEqual(
      outsideScope,
      [],
      'this pilot section must not require auxiliary deep reads outside its mapped scope'
    );

    const partTitle = reconstruction.elements.find((element) => element.kind === 'part_title');
    assert.ok(partTitle?.text, 'real section title must be corroborated in the body');
    assert.equal(normalize(partTitle.text), 'evolucionismo social');

    assert.equal(
      reconstruction.elements.every((element) => element.evidence.length > 0),
      true,
      'every reconstructed element must remain evidence-backed'
    );
    assert.equal(
      reconstruction.relations.every((relation) => relation.evidence.length > 0),
      true,
      'every reconstructed relation must remain evidence-backed'
    );
  }
);
