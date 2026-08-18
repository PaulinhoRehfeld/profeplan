import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { basename } from 'node:path';
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

const EXPECTED_FILENAME =
  'PNLD_2023_OBJETO_2_7_ANO_EF_AI_LINGUA_PORTUGUESA_VOLUME_1_WF1.pdf';

const filenameRules = [
  {
    token: 'PNLD',
    kind: 'program_cycle',
    interpretedValue: 'PNLD 2023',
    confidence: 0.95,
  },
  {
    token: 'PORTUGUESA',
    kind: 'school_component',
    interpretedValue: 'Língua Portuguesa',
    confidence: 0.98,
  },
  {
    token: 'VOLUME',
    kind: 'volume_designation',
    interpretedValue: 'Volume 1',
    confidence: 0.9,
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
  'real PDF reconstructs Unit 1 selectively without promoting cartography to canonical truth',
  async () => {
    assert.ok(REAL_PILOT_PATH);
    assert.equal(
      basename(REAL_PILOT_PATH),
      EXPECTED_FILENAME,
      'pilot must run against the governed artifact selected for this proof'
    );

    const artifact = await temporaryVerifiedArtifact(REAL_PILOT_PATH);
    const inspector = new PdfJsDocumentInspectorAdapter();
    const recognition = await new StructuralRecognitionService(inspector).recognize({
      snapshotId: 'snapshot:first-real-single-part-pilot',
      sourceVersion: { kind: 'source_version', id: 'source-version:first-real-pilot' },
      artifact,
      createdAt: '2026-08-18T22:30:00.000Z',
      filename: EXPECTED_FILENAME,
      filenameHintRules: filenameRules,
    });

    assert.equal(recognition.snapshot.contractVersion, '1.0.0');
    assert.equal(recognition.snapshot.totalPhysicalPages, 41);

    const tocRegion = recognition.snapshot.regions.find(
      (region) => region.kind === 'table_of_contents'
    );
    assert.ok(tocRegion, 'cartography must observe the real table of contents');
    assert.equal(
      isInsideRange(6, tocRegion.pageRange),
      true,
      'physical page 6 must belong to the observed table-of-contents region'
    );

    const unit = recognition.snapshot.nodes.find((node) => {
      const title = normalize(node.observedTitle);
      return (
        node.kind === 'unit' &&
        title.includes('unidade 1') &&
        title.includes('no mundo da fantasia')
      );
    });

    assert.ok(unit?.pageRange, 'cartography must delimit Unit 1 from real evidence');
    assert.deepEqual(unit.pageRange, {
      startPhysicalPage: 9,
      endPhysicalPage: 14,
    });
    assert.equal(unit.declaredPrintedPageLabel, '7');
    assert.equal(
      recognition.snapshot.nodes.every((node) =>
        ['candidate', 'reviewed_candidate', 'rejected'].includes(node.state)
      ),
      true,
      'structural recognition must remain candidate-only'
    );

    const partScope = {
      scopeId: 'cartographic-scope:first-real-unit-1',
      snapshotId: recognition.snapshot.snapshotId,
      rootNodeId: unit.nodeId,
      pageRange: unit.pageRange,
      reason: 'table_of_contents_boundary',
      confidence: unit.confidence,
    };

    const reconstruction = await new PartReconstructionService(inspector).reconstruct({
      snapshotId: 'part-reconstruction:first-real-unit-1',
      artifact,
      recognition: recognition.snapshot,
      partScope,
      createdAt: '2026-08-18T22:31:00.000Z',
    });

    assert.equal(reconstruction.contractVersion, '1.0.0');
    assert.deepEqual(reconstruction.partScope.pageRange, {
      startPhysicalPage: 9,
      endPhysicalPage: 14,
    });

    const scopedPages = reconstruction.inspectedPages.filter((page) =>
      isInsideRange(page.physicalPageNumber, partScope.pageRange)
    );
    assert.deepEqual(
      scopedPages.map((page) => [page.physicalPageNumber, page.printedPageLabel]),
      [
        [9, '7'],
        [10, '8'],
        [11, '9'],
        [12, '10'],
        [13, '11'],
        [14, '12'],
      ],
      'physical and printed pagination must both survive the real reconstruction'
    );

    const outsideScope = reconstruction.inspectedPages.filter(
      (page) => !isInsideRange(page.physicalPageNumber, partScope.pageRange)
    );
    const teacherManualRange = recognition.snapshot.regions.find(
      (region) => region.kind === 'teacher_manual'
    )?.pageRange;

    assert.equal(
      outsideScope.every(
        (page) => teacherManualRange && isInsideRange(page.physicalPageNumber, teacherManualRange)
      ),
      true,
      'reconstruction may leave the part only for an already-cartographed auxiliary region'
    );

    if (outsideScope.length > 0) {
      assert.equal(
        reconstruction.relations.some(
          (relation) => relation.kind === 'teacher_guidance_for_activity'
        ),
        true,
        'auxiliary teacher-manual reads require an objective activity-guidance relation'
      );
    }

    const partTitle = reconstruction.elements.find((element) => element.kind === 'part_title');
    assert.ok(partTitle?.text, 'real Unit 1 title must be corroborated in the body');
    assert.equal(normalize(partTitle.text).includes('no mundo da fantasia'), true);

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
