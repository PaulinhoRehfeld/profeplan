import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  PartReconstructionService,
  PartStructuralReviewService,
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

function inspectedPageCount(ranges) {
  return ranges.reduce(
    (sum, range) => sum + range.endPhysicalPage - range.startPhysicalPage + 1,
    0
  );
}

function physicalPagesFromRanges(ranges) {
  const pages = new Set();
  for (const range of ranges) {
    for (
      let physicalPageNumber = range.startPhysicalPage;
      physicalPageNumber <= range.endPhysicalPage;
      physicalPageNumber += 1
    ) {
      pages.add(physicalPageNumber);
    }
  }
  return [...pages].sort((left, right) => left - right);
}

function flattenInspectionRequests(requests) {
  return requests.flatMap((ranges) => ranges ?? []);
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
  'real PNLD 2026 PDF reconstructs and structurally confirms one mapped section without deep-reading the book',
  async () => {
    assert.ok(REAL_PILOT_PATH);

    const artifact = await temporaryVerifiedArtifact(REAL_PILOT_PATH);
    const inspector = new PdfJsDocumentInspectorAdapter();
    const recognitionRequests = [];
    const recognitionInspector = {
      async inspect(request) {
        recognitionRequests.push(request.pageRanges);
        return inspector.inspect(request);
      },
    };
    const recognition = await new StructuralRecognitionService(recognitionInspector).recognize({
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
    assert.equal(
      recognitionRequests.every((ranges) => Array.isArray(ranges) && ranges.length > 0),
      true,
      'cartography must never invoke the inspector without an explicit bounded page range'
    );

    const actualCartographyRanges = flattenInspectionRequests(recognitionRequests);
    const actualCartographyPages = physicalPagesFromRanges(actualCartographyRanges);
    const reportedCartographyPages = physicalPagesFromRanges(recognition.snapshot.inspectedPageRanges);

    assert.deepEqual(
      actualCartographyPages,
      reportedCartographyPages,
      'reported cartography coverage must equal the pages actually requested from the inspector'
    );
    assert.equal(
      actualCartographyPages.length < recognition.snapshot.totalPhysicalPages,
      true,
      'cartography must remain selective instead of reading all 449 physical pages'
    );
    assert.equal(
      inspectedPageCount(recognition.snapshot.inspectedPageRanges) <
        recognition.snapshot.totalPhysicalPages,
      true,
      'compacted cartography coverage must remain selective instead of spanning all 449 pages'
    );

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

    const reconstructionRequests = [];
    const reconstructionInspector = {
      async inspect(request) {
        reconstructionRequests.push(request.pageRanges);
        return inspector.inspect(request);
      },
    };

    const reconstruction = await new PartReconstructionService(reconstructionInspector).reconstruct({
      snapshotId: 'part-reconstruction:first-real-evolucionismo-social',
      artifact,
      recognition: recognition.snapshot,
      partScope,
      createdAt: '2026-08-18T23:31:00.000Z',
    });

    assert.deepEqual(
      reconstructionRequests,
      [[{ startPhysicalPage: 34, endPhysicalPage: 35 }]],
      'reconstruction must request exactly the governed two-page CartographicPartScope and nothing else'
    );
    assert.equal(reconstruction.contractVersion, '1.0.0');
    assert.equal(reconstruction.artifactSha256, GOVERNED_SHA256);
    assert.equal(reconstruction.structuralRecognitionSnapshotId, recognition.snapshot.snapshotId);
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
      'reconstruction output must not contain evidence from outside its mapped scope'
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

    const allEvidence = [
      ...reconstruction.elements.flatMap((element) => element.evidence),
      ...reconstruction.relations.flatMap((relation) => relation.evidence),
    ];
    assert.equal(
      allEvidence.every((evidence) => isInsideRange(evidence.page.physicalPageNumber, partScope.pageRange)),
      true,
      'every reconstruction evidence locator must remain inside the governed two-page scope'
    );
    assert.equal(
      reconstruction.warnings.some((warning) => warning.code === 'part_title_not_found'),
      false,
      'the governed section title must not remain unresolved after body corroboration'
    );

    const candidateBeforeReview = JSON.stringify(reconstruction);
    const review = new PartStructuralReviewService().review({
      reviewSnapshotId: 'part-structural-review:first-real-evolucionismo-social',
      candidate: reconstruction,
      reviewerId: 'reviewer:governed-real-pilot',
      createdAt: '2026-08-21T10:50:00.000Z',
      decisions: [
        {
          decisionId: 'structural-review-decision:real-part-title',
          targetKind: 'element',
          targetId: partTitle.elementId,
          disposition: 'confirmed',
          rationale: 'The section title is corroborated by native text inside the governed body scope.',
          evidenceIds: partTitle.evidence.map((evidence) => evidence.evidenceId),
        },
      ],
    });

    assert.equal(review.contractVersion, '1.0.0');
    assert.equal(review.candidateSnapshotId, reconstruction.snapshotId);
    assert.equal(review.decisions.length, 1);
    assert.equal(review.decisions[0].disposition, 'confirmed');
    assert.equal(review.decisions[0].targetId, partTitle.elementId);
    assert.equal(review.decisions[0].evidence.length > 0, true);
    assert.equal(
      review.decisions[0].evidence.every((evidence) =>
        isInsideRange(evidence.page.physicalPageNumber, partScope.pageRange)
      ),
      true,
      'C.4 confirmation evidence must remain inside the governed CartographicPartScope'
    );
    assert.equal(
      JSON.stringify(reconstruction),
      candidateBeforeReview,
      'C.4 review must preserve the original candidate snapshot unchanged'
    );
    assert.deepEqual(
      reconstructionRequests,
      [[{ startPhysicalPage: 34, endPhysicalPage: 35 }]],
      'C.4 review must not trigger any additional PDF inspection'
    );
  }
);
