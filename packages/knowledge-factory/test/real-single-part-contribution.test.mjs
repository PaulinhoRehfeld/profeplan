import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  KnowledgeContributionService,
  PartReconstructionService,
  PartStructuralReviewService,
  PdfJsDocumentInspectorAdapter,
  StructuralRecognitionService,
} from '../src/index.ts';

const REAL_PILOT_PATH = process.env.PROFEPLAN_REAL_PILOT_PDF;
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

  assert.equal(sha256, GOVERNED_SHA256, 'real C.5 PDF differs from the governed PNLD artifact');

  return {
    artifact: {
      artifactId: 'artifact:first-real-c5-contribution',
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
  'real PNLD 2026 confirmed part yields one evidence-backed C.5 contribution candidate',
  async () => {
    assert.ok(REAL_PILOT_PATH);

    const artifact = await temporaryVerifiedArtifact(REAL_PILOT_PATH);
    const inspector = new PdfJsDocumentInspectorAdapter();
    const recognition = await new StructuralRecognitionService(inspector).recognize({
      snapshotId: 'snapshot:first-real-c5-contribution',
      sourceVersion: { kind: 'source_version', id: 'source-version:first-real-pilot' },
      artifact,
      createdAt: '2026-08-21T23:20:00.000Z',
      filename: CANONICAL_FILENAME,
      filenameHintRules: filenameRules,
    });

    const section = recognition.snapshot.nodes.find(
      (node) => node.kind === 'section' && normalize(node.observedTitle) === 'evolucionismo social'
    );
    assert.ok(section?.pageRange, 'real C.5 gate requires the governed section to be cartographed');
    assert.deepEqual(section.pageRange, {
      startPhysicalPage: 34,
      endPhysicalPage: 35,
    });

    const partScope = {
      scopeId: 'cartographic-scope:first-real-c5-evolucionismo-social',
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
      snapshotId: 'part-reconstruction:first-real-c5-evolucionismo-social',
      artifact,
      recognition: recognition.snapshot,
      partScope,
      createdAt: '2026-08-21T23:21:00.000Z',
    });

    assert.deepEqual(reconstructionRequests, [[{ startPhysicalPage: 34, endPhysicalPage: 35 }]]);

    const partTitle = reconstruction.elements.find((element) => element.kind === 'part_title');
    const bodyElement = reconstruction.elements.find((element) => element.kind === 'body_text');
    assert.ok(partTitle?.text, 'C.5 requires the confirmed section title');
    assert.ok(bodyElement?.text, 'C.5 requires at least one observed body element');
    assert.equal(normalize(partTitle.text), 'evolucionismo social');

    const review = new PartStructuralReviewService().review({
      reviewSnapshotId: 'part-structural-review:first-real-c5-evolucionismo-social',
      candidate: reconstruction,
      reviewerId: 'reviewer:governed-real-c5',
      createdAt: '2026-08-21T23:22:00.000Z',
      decisions: [
        {
          decisionId: 'structural-review-decision:c5-real-title',
          targetKind: 'element',
          targetId: partTitle.elementId,
          disposition: 'confirmed',
          rationale: 'The section title is corroborated inside the governed part scope.',
          evidenceIds: partTitle.evidence.map((evidence) => evidence.evidenceId),
        },
        {
          decisionId: 'structural-review-decision:c5-real-body',
          targetKind: 'element',
          targetId: bodyElement.elementId,
          disposition: 'confirmed',
          rationale: 'The body element is observed as native text inside the governed part scope.',
          evidenceIds: bodyElement.evidence.map((evidence) => evidence.evidenceId),
        },
      ],
    });

    const contribution = new KnowledgeContributionService().distill({
      reconstruction,
      structuralReview: review,
      createdAt: '2026-08-21T23:23:00.000Z',
      proposals: [
        {
          contributionId: 'knowledge-contribution:first-real:evolucionismo-social:context',
          kind: 'contextual',
          statement: 'A seção confirmada apresenta conteúdo expositivo sobre evolucionismo social.',
          sourceElementIds: [partTitle.elementId, bodyElement.elementId],
        },
      ],
    })[0];

    assert.equal(contribution.contractVersion, '1.0.0');
    assert.equal(contribution.state, 'candidate');
    assert.equal(contribution.kind, 'contextual');
    assert.equal(contribution.structuralReviewSnapshotId, review.reviewSnapshotId);
    assert.equal(contribution.reconstructionCandidateSnapshotId, reconstruction.snapshotId);
    assert.deepEqual(contribution.sourceElementIds, [partTitle.elementId, bodyElement.elementId]);
    assert.equal(contribution.evidence.length > 0, true);
    assert.equal(
      contribution.evidence.every((evidence) =>
        isInsideRange(evidence.page.physicalPageNumber, partScope.pageRange)
      ),
      true,
      'C.5 contribution evidence must remain inside the governed 34–35 scope'
    );
    assert.equal(
      [partTitle.text, bodyElement.text].some(
        (sourceText) => normalize(sourceText) === normalize(contribution.statement)
      ),
      false,
      'C.5 contribution must remain authorial rather than copy source text verbatim'
    );
    assert.deepEqual(
      reconstructionRequests,
      [[{ startPhysicalPage: 34, endPhysicalPage: 35 }]],
      'C.5 must not trigger additional PDF inspection after reconstruction'
    );
  }
);
