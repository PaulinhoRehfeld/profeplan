import assert from 'node:assert/strict';
import test from 'node:test';
import { PartStructuralReviewService } from '../src/index.ts';

function candidateSnapshot() {
  return {
    contractVersion: '1.0.0',
    snapshotId: 'candidate:part:001',
    structuralRecognitionSnapshotId: 'recognition:001',
    sourceVersion: { kind: 'source_version', id: 'source-version:001' },
    artifactSha256: 'abc123',
    partScope: {
      scopeId: 'scope:001',
      snapshotId: 'recognition:001',
      rootNodeId: 'node:section',
      pageRange: { startPhysicalPage: 34, endPhysicalPage: 35 },
      reason: 'table_of_contents_boundary',
      confidence: 0.99,
    },
    createdAt: '2026-08-21T10:00:00.000Z',
    inspectedPages: [
      { physicalPageNumber: 34, printedPageLabel: '33' },
      { physicalPageNumber: 35, printedPageLabel: '34' },
    ],
    elements: [
      {
        elementId: 'element:section',
        kind: 'part_title',
        page: { physicalPageNumber: 34, printedPageLabel: '33' },
        logicalLocator: 'text:0',
        text: 'Evolucionismo social',
        evidence: [
          {
            evidenceId: 'evidence:section',
            kind: 'native_text',
            page: { physicalPageNumber: 34, printedPageLabel: '33' },
            logicalLocator: 'text:0',
            cartographicNodeId: 'node:section',
          },
        ],
        confidence: 0.99,
      },
      {
        elementId: 'element:misclassified',
        kind: 'body_text',
        page: { physicalPageNumber: 35, printedPageLabel: '34' },
        logicalLocator: 'text:4',
        text: 'Atividade de análise',
        parentElementId: 'element:section',
        evidence: [
          {
            evidenceId: 'evidence:misclassified',
            kind: 'native_text',
            page: { physicalPageNumber: 35, printedPageLabel: '34' },
            logicalLocator: 'text:4',
          },
        ],
        confidence: 0.7,
      },
    ],
    relations: [
      {
        relationId: 'relation:contains',
        kind: 'contains',
        fromElementId: 'element:section',
        toElementId: 'element:misclassified',
        evidence: [
          {
            evidenceId: 'evidence:relation',
            kind: 'native_text',
            page: { physicalPageNumber: 35, printedPageLabel: '34' },
            logicalLocator: 'text:4',
          },
        ],
        confidence: 0.9,
      },
    ],
    warnings: [],
  };
}

test('C.4 review confirms a candidate without mutating the candidate snapshot', () => {
  const candidate = candidateSnapshot();
  const before = structuredClone(candidate);

  const review = new PartStructuralReviewService().review({
    reviewSnapshotId: 'review:001',
    candidate,
    reviewerId: 'reviewer:human:001',
    createdAt: '2026-08-21T10:05:00.000Z',
    decisions: [
      {
        decisionId: 'decision:confirm-section',
        targetKind: 'element',
        targetId: 'element:section',
        disposition: 'confirmed',
        rationale: 'Heading is corroborated by body text and cartographic evidence.',
        evidenceIds: ['evidence:section'],
      },
    ],
  });

  assert.equal(review.contractVersion, '1.0.0');
  assert.equal(review.candidateSnapshotId, candidate.snapshotId);
  assert.equal(review.decisions[0].disposition, 'confirmed');
  assert.deepEqual(review.decisions[0].evidence.map((item) => item.evidenceId), [
    'evidence:section',
  ]);
  assert.deepEqual(candidate, before);
});

test('C.4 review corrects a misclassified candidate while preserving original evidence', () => {
  const candidate = candidateSnapshot();

  const review = new PartStructuralReviewService().review({
    reviewSnapshotId: 'review:002',
    candidate,
    reviewerId: 'reviewer:human:001',
    createdAt: '2026-08-21T10:06:00.000Z',
    decisions: [
      {
        decisionId: 'decision:correct-kind',
        targetKind: 'element',
        targetId: 'element:misclassified',
        disposition: 'corrected',
        rationale: 'Observed heading functions as an activity heading, not body text.',
        evidenceIds: ['evidence:misclassified'],
        correction: {
          elementKind: 'activity_heading',
          parentElementId: 'element:section',
        },
      },
    ],
  });

  assert.equal(review.decisions[0].disposition, 'corrected');
  assert.deepEqual(review.decisions[0].correction, {
    elementKind: 'activity_heading',
    parentElementId: 'element:section',
  });
  assert.equal(candidate.elements[1].kind, 'body_text');
  assert.equal(review.decisions[0].evidence[0].logicalLocator, 'text:4');
});

test('C.4 review rejects promotion when evidence is missing or foreign to the target', () => {
  const candidate = candidateSnapshot();
  const service = new PartStructuralReviewService();

  assert.throws(
    () =>
      service.review({
        reviewSnapshotId: 'review:003',
        candidate,
        reviewerId: 'reviewer:human:001',
        createdAt: '2026-08-21T10:07:00.000Z',
        decisions: [
          {
            decisionId: 'decision:no-evidence',
            targetKind: 'element',
            targetId: 'element:section',
            disposition: 'confirmed',
            rationale: 'Would confirm without evidence.',
            evidenceIds: [],
          },
        ],
      }),
    /evidence is required/
  );

  assert.throws(
    () =>
      service.review({
        reviewSnapshotId: 'review:004',
        candidate,
        reviewerId: 'reviewer:human:001',
        createdAt: '2026-08-21T10:08:00.000Z',
        decisions: [
          {
            decisionId: 'decision:foreign-evidence',
            targetKind: 'element',
            targetId: 'element:section',
            disposition: 'confirmed',
            rationale: 'Would reuse evidence from another target.',
            evidenceIds: ['evidence:misclassified'],
          },
        ],
      }),
    /does not belong to structural review target/
  );
});

test('C.4 review records rejection and forbids correction payload on non-corrected decisions', () => {
  const candidate = candidateSnapshot();
  const service = new PartStructuralReviewService();

  const review = service.review({
    reviewSnapshotId: 'review:005',
    candidate,
    reviewerId: 'reviewer:human:001',
    createdAt: '2026-08-21T10:09:00.000Z',
    decisions: [
      {
        decisionId: 'decision:reject-relation',
        targetKind: 'relation',
        targetId: 'relation:contains',
        disposition: 'rejected',
        rationale: 'Relationship is not sufficiently supported as modeled.',
        evidenceIds: ['evidence:relation'],
      },
    ],
  });

  assert.equal(review.decisions[0].disposition, 'rejected');

  assert.throws(
    () =>
      service.review({
        reviewSnapshotId: 'review:006',
        candidate,
        reviewerId: 'reviewer:human:001',
        createdAt: '2026-08-21T10:10:00.000Z',
        decisions: [
          {
            decisionId: 'decision:invalid-confirmation',
            targetKind: 'element',
            targetId: 'element:section',
            disposition: 'confirmed',
            rationale: 'Invalid correction payload.',
            evidenceIds: ['evidence:section'],
            correction: { elementKind: 'section_heading' },
          },
        ],
      }),
    /cannot carry a correction/
  );
});
