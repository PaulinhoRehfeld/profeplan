import assert from 'node:assert/strict';
import test from 'node:test';
import { KnowledgeContributionRelationService } from '../src/index.ts';

const evidence = [
  {
    evidenceId: 'evidence:contribution:one',
    kind: 'native_text',
    page: { physicalPageNumber: 20, printedPageLabel: '19' },
    logicalLocator: 'page:20:text:3',
  },
  {
    evidenceId: 'evidence:contribution:two',
    kind: 'native_text',
    page: { physicalPageNumber: 20, printedPageLabel: '19' },
    logicalLocator: 'page:20:text:4',
  },
];

const contributions = [
  {
    contractVersion: '1.0.0',
    contributionId: 'contribution:one',
    state: 'candidate',
    kind: 'conceptual',
    statement: 'Uma contribuição conceitual candidata.',
    structuralReviewSnapshotId: 'review:shared',
    reconstructionCandidateSnapshotId: 'reconstruction:shared',
    sourceElementIds: ['element:one'],
    evidence: [evidence[0]],
    createdAt: '2026-08-22T18:30:00.000Z',
  },
  {
    contractVersion: '1.0.0',
    contributionId: 'contribution:two',
    state: 'candidate',
    kind: 'contextual',
    statement: 'Uma contribuição contextual candidata.',
    structuralReviewSnapshotId: 'review:shared',
    reconstructionCandidateSnapshotId: 'reconstruction:shared',
    sourceElementIds: ['element:two'],
    evidence: [evidence[1]],
    createdAt: '2026-08-22T18:30:00.000Z',
  },
];

function request(proposal) {
  return {
    contributions,
    createdAt: '2026-08-22T18:31:00.000Z',
    proposals: [proposal],
  };
}

test('C.5.4 creates an evidence-backed local candidate relation', () => {
  const result = new KnowledgeContributionRelationService().relate(
    request({
      relationId: 'relation:contextualizes',
      kind: 'contextualizes',
      sourceContributionId: 'contribution:two',
      targetContributionId: 'contribution:one',
      evidenceIds: ['evidence:contribution:one', 'evidence:contribution:two'],
    })
  );

  assert.deepEqual(result, [
    {
      contractVersion: '1.0.0',
      relationId: 'relation:contextualizes',
      state: 'candidate',
      kind: 'contextualizes',
      sourceContributionId: 'contribution:two',
      targetContributionId: 'contribution:one',
      evidence,
      createdAt: '2026-08-22T18:31:00.000Z',
    },
  ]);
});

test('C.5.4 rejects a relation without contribution evidence', () => {
  assert.throws(
    () =>
      new KnowledgeContributionRelationService().relate(
        request({
          relationId: 'relation:without-evidence',
          kind: 'contextualizes',
          sourceContributionId: 'contribution:two',
          targetContributionId: 'contribution:one',
          evidenceIds: [],
        })
      ),
    /evidence is required/
  );
});

test('C.5.4 rejects evidence outside the two contribution candidates', () => {
  assert.throws(
    () =>
      new KnowledgeContributionRelationService().relate(
        request({
          relationId: 'relation:foreign-evidence',
          kind: 'contextualizes',
          sourceContributionId: 'contribution:two',
          targetContributionId: 'contribution:one',
          evidenceIds: ['evidence:outside'],
        })
      ),
    /relation evidence must belong/
  );
});

test('C.5.4 rejects cross-snapshot relations to avoid a premature global graph', () => {
  const crossSnapshotContributions = [
    contributions[0],
    { ...contributions[1], reconstructionCandidateSnapshotId: 'reconstruction:other' },
  ];

  assert.throws(
    () =>
      new KnowledgeContributionRelationService().relate({
        contributions: crossSnapshotContributions,
        createdAt: '2026-08-22T18:31:00.000Z',
        proposals: [
          {
            relationId: 'relation:cross-snapshot',
            kind: 'contextualizes',
            sourceContributionId: 'contribution:two',
            targetContributionId: 'contribution:one',
            evidenceIds: ['evidence:contribution:one'],
          },
        ],
      }),
    /must share the same structural review and reconstruction snapshot/
  );
});
