import assert from 'node:assert/strict';
import test from 'node:test';
import { KnowledgeContributionService } from '../src/index.ts';

const reconstruction = {
  contractVersion: '1.0.0',
  snapshotId: 'part-reconstruction:synthetic-c5',
  structuralRecognitionSnapshotId: 'recognition:synthetic-c5',
  sourceVersion: { kind: 'source_version', id: 'source-version:synthetic-c5' },
  artifactSha256: 'a'.repeat(64),
  partScope: {
    scopeId: 'scope:synthetic-c5',
    snapshotId: 'recognition:synthetic-c5',
    rootNodeId: 'node:culture',
    pageRange: { startPhysicalPage: 20, endPhysicalPage: 20 },
    reason: 'table_of_contents_boundary',
    confidence: 0.99,
  },
  createdAt: '2026-08-21T23:00:00.000Z',
  inspectedPages: [{ physicalPageNumber: 20, printedPageLabel: '19' }],
  elements: [
    {
      elementId: 'element:body:1',
      kind: 'body_text',
      page: { physicalPageNumber: 20, printedPageLabel: '19' },
      logicalLocator: 'page:20:text:3',
      text: 'Cultura corresponde a práticas e significados transmitidos na vida coletiva.',
      evidence: [
        {
          evidenceId: 'evidence:body:1',
          kind: 'native_text',
          page: { physicalPageNumber: 20, printedPageLabel: '19' },
          logicalLocator: 'page:20:text:3',
        },
      ],
      confidence: 0.94,
    },
    {
      elementId: 'element:body:2',
      kind: 'body_text',
      page: { physicalPageNumber: 20, printedPageLabel: '19' },
      logicalLocator: 'page:20:text:4',
      text: 'Este trecho permanece candidato e não foi confirmado.',
      evidence: [
        {
          evidenceId: 'evidence:body:2',
          kind: 'native_text',
          page: { physicalPageNumber: 20, printedPageLabel: '19' },
          logicalLocator: 'page:20:text:4',
        },
      ],
      confidence: 0.9,
    },
  ],
  relations: [],
  warnings: [],
};

const structuralReview = {
  contractVersion: '1.0.0',
  reviewSnapshotId: 'structural-review:synthetic-c5',
  candidateSnapshotId: reconstruction.snapshotId,
  createdAt: '2026-08-21T23:01:00.000Z',
  reviewerId: 'reviewer:synthetic',
  decisions: [
    {
      decisionId: 'decision:confirm:body:1',
      targetKind: 'element',
      targetId: 'element:body:1',
      disposition: 'confirmed',
      rationale: 'The body element is corroborated by native text evidence.',
      evidenceIds: ['evidence:body:1'],
      evidence: [reconstruction.elements[0].evidence[0]],
    },
  ],
  warnings: [],
};

test('C.5 distills an authorial candidate from structurally confirmed evidence', () => {
  const service = new KnowledgeContributionService();
  const result = service.distill({
    reconstruction,
    structuralReview,
    createdAt: '2026-08-21T23:02:00.000Z',
    proposals: [
      {
        contributionId: 'contribution:synthetic:culture:1',
        kind: 'conceptual',
        statement: 'A cultura é socialmente aprendida e compartilhada por meio de práticas e significados.',
        sourceElementIds: ['element:body:1'],
      },
    ],
  });

  assert.equal(result.length, 1);
  assert.equal(result[0].contractVersion, '1.0.0');
  assert.equal(result[0].state, 'candidate');
  assert.equal(result[0].kind, 'conceptual');
  assert.equal(result[0].structuralReviewSnapshotId, structuralReview.reviewSnapshotId);
  assert.equal(result[0].reconstructionCandidateSnapshotId, reconstruction.snapshotId);
  assert.deepEqual(result[0].sourceElementIds, ['element:body:1']);
  assert.deepEqual(result[0].evidence, [reconstruction.elements[0].evidence[0]]);
  assert.notEqual(result[0].statement, reconstruction.elements[0].text);
});

test('C.5 rejects exact source copying as distillation', () => {
  const service = new KnowledgeContributionService();

  assert.throws(
    () =>
      service.distill({
        reconstruction,
        structuralReview,
        createdAt: '2026-08-21T23:03:00.000Z',
        proposals: [
          {
            contributionId: 'contribution:synthetic:copy',
            kind: 'conceptual',
            statement: reconstruction.elements[0].text,
            sourceElementIds: ['element:body:1'],
          },
        ],
      }),
    /must not be an exact copy of source text/
  );
});

test('C.5 rejects an unconfirmed structural source element', () => {
  const service = new KnowledgeContributionService();

  assert.throws(
    () =>
      service.distill({
        reconstruction,
        structuralReview,
        createdAt: '2026-08-21T23:04:00.000Z',
        proposals: [
          {
            contributionId: 'contribution:synthetic:unconfirmed',
            kind: 'contextual',
            statement: 'Uma observação não confirmada não pode sustentar uma contribuição C.5.',
            sourceElementIds: ['element:body:2'],
          },
        ],
      }),
    /source element is not structurally confirmed/
  );
});
