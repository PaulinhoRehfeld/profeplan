import assert from 'node:assert/strict';
import test from 'node:test';
import { PartStructureConfirmationService } from '../src/index.ts';

function candidateSnapshot() {
  return {
    contractVersion: '1.0.0',
    snapshotId: 'part-reconstruction:c4-fixture:001',
    structuralRecognitionSnapshotId: 'structural-recognition:c4-fixture:001',
    sourceVersion: { kind: 'source_version', id: 'source-version:c4-fixture:001' },
    artifactSha256: 'fixture-sha256',
    partScope: {
      scopeId: 'cartographic-scope:c4-fixture',
      snapshotId: 'structural-recognition:c4-fixture:001',
      rootNodeId: 'cartographic-node:unit-1',
      pageRange: { startPhysicalPage: 34, endPhysicalPage: 35 },
      reason: 'table_of_contents_boundary',
      confidence: 0.97,
    },
    createdAt: '2026-08-20T18:00:00.000Z',
    inspectedPages: [
      { physicalPageNumber: 34, printedPageLabel: '33' },
      { physicalPageNumber: 35, printedPageLabel: '34' },
    ],
    elements: [
      {
        elementId: 'part-element:1',
        kind: 'part_title',
        page: { physicalPageNumber: 34, printedPageLabel: '33' },
        logicalLocator: 'page[34].text[1]',
        text: 'Evolucionismo social',
        evidence: [
          {
            evidenceId: 'part-evidence:1',
            kind: 'native_text',
            page: { physicalPageNumber: 34, printedPageLabel: '33' },
            logicalLocator: 'page[34].text[1]',
            cartographicNodeId: 'cartographic-node:section-1',
          },
        ],
        confidence: 0.99,
      },
      {
        elementId: 'part-element:2',
        kind: 'body_text',
        page: { physicalPageNumber: 34, printedPageLabel: '33' },
        logicalLocator: 'page[34].text[2]',
        text: 'Synthetic fixture body.',
        parentElementId: 'part-element:1',
        evidence: [
          {
            evidenceId: 'part-evidence:2',
            kind: 'native_text',
            page: { physicalPageNumber: 34, printedPageLabel: '33' },
            logicalLocator: 'page[34].text[2]',
          },
        ],
        confidence: 0.94,
      },
    ],
    relations: [
      {
        relationId: 'part-relation:1',
        kind: 'contains',
        fromElementId: 'part-element:1',
        toElementId: 'part-element:2',
        evidence: [
          {
            evidenceId: 'part-evidence:2',
            kind: 'native_text',
            page: { physicalPageNumber: 34, printedPageLabel: '33' },
            logicalLocator: 'page[34].text[2]',
          },
        ],
        confidence: 0.96,
      },
    ],
    warnings: [],
  };
}

function confirmAllDecisions() {
  return [
    {
      decisionId: 'decision:element:1',
      targetKind: 'element',
      candidateElementId: 'part-element:1',
      state: 'confirmed',
      evidenceIds: ['part-evidence:1'],
    },
    {
      decisionId: 'decision:element:2',
      targetKind: 'element',
      candidateElementId: 'part-element:2',
      state: 'confirmed',
      evidenceIds: ['part-evidence:2'],
    },
    {
      decisionId: 'decision:relation:1',
      targetKind: 'relation',
      candidateRelationId: 'part-relation:1',
      state: 'confirmed',
      evidenceIds: ['part-evidence:2'],
    },
  ];
}

test('C4 creates a separate complete confirmation snapshot without mutating the candidate', () => {
  const candidate = candidateSnapshot();
  const before = structuredClone(candidate);

  const result = new PartStructureConfirmationService().confirm({
    snapshotId: 'part-confirmation:c4-fixture:001',
    candidate,
    createdAt: '2026-08-20T18:05:00.000Z',
    decisions: confirmAllDecisions(),
  });

  assert.equal(result.allowed, true);
  assert.ok(result.value);
  assert.equal(result.value.contractVersion, '1.0.0');
  assert.equal(result.value.reconstructionCandidateSnapshotId, candidate.snapshotId);
  assert.equal(
    result.value.structuralRecognitionSnapshotId,
    candidate.structuralRecognitionSnapshotId
  );
  assert.deepEqual(result.value.partScope, candidate.partScope);
  assert.equal(result.value.reviewComplete, true);
  assert.deepEqual(result.value.warnings, []);
  assert.deepEqual(candidate, before, 'candidate snapshot must remain unchanged');
});

test('C4 supports an evidence-backed correction without rewriting the candidate element', () => {
  const candidate = candidateSnapshot();
  const originalText = candidate.elements[1].text;
  const decisions = confirmAllDecisions().map((decision) =>
    decision.decisionId === 'decision:element:2'
      ? {
          ...decision,
          state: 'corrected',
          correction: { text: 'Corrected synthetic fixture body.' },
          note: 'Human review corrected the observed text classification/output.',
        }
      : decision
  );

  const result = new PartStructureConfirmationService().confirm({
    snapshotId: 'part-confirmation:c4-fixture:corrected',
    candidate,
    createdAt: '2026-08-20T18:06:00.000Z',
    decisions,
  });

  assert.equal(result.allowed, true);
  assert.ok(result.value);
  const corrected = result.value.decisions.find(
    (decision) => decision.decisionId === 'decision:element:2'
  );
  assert.equal(corrected?.state, 'corrected');
  assert.deepEqual(corrected?.correction, { text: 'Corrected synthetic fixture body.' });
  assert.equal(candidate.elements[1].text, originalText);
});

test('C4 allows explicit rejection as a structural decision', () => {
  const candidate = candidateSnapshot();
  const decisions = confirmAllDecisions().map((decision) =>
    decision.targetKind === 'relation'
      ? { ...decision, state: 'rejected', note: 'Synthetic negative review.' }
      : decision
  );

  const result = new PartStructureConfirmationService().confirm({
    snapshotId: 'part-confirmation:c4-fixture:rejected',
    candidate,
    createdAt: '2026-08-20T18:07:00.000Z',
    decisions,
  });

  assert.equal(result.allowed, true);
  assert.equal(result.value?.reviewComplete, true);
  assert.equal(
    result.value?.decisions.find((decision) => decision.targetKind === 'relation')?.state,
    'rejected'
  );
});

test('C4 rejects a decision whose evidence does not belong to its candidate target', () => {
  const candidate = candidateSnapshot();
  const result = new PartStructureConfirmationService().confirm({
    snapshotId: 'part-confirmation:c4-fixture:bad-evidence',
    candidate,
    createdAt: '2026-08-20T18:08:00.000Z',
    decisions: [
      {
        decisionId: 'decision:bad-evidence',
        targetKind: 'element',
        candidateElementId: 'part-element:1',
        state: 'confirmed',
        evidenceIds: ['part-evidence:2'],
      },
    ],
  });

  assert.equal(result.allowed, false);
  assert.equal(result.value, undefined);
  assert.equal(
    result.reasons.some((item) => item.code === 'PART_CONFIRMATION_EVIDENCE_MISMATCH'),
    true
  );
});

test('C4 rejects corrected state without a material correction', () => {
  const candidate = candidateSnapshot();
  const result = new PartStructureConfirmationService().confirm({
    snapshotId: 'part-confirmation:c4-fixture:missing-correction',
    candidate,
    createdAt: '2026-08-20T18:09:00.000Z',
    decisions: [
      {
        decisionId: 'decision:missing-correction',
        targetKind: 'element',
        candidateElementId: 'part-element:1',
        state: 'corrected',
        evidenceIds: ['part-evidence:1'],
      },
    ],
  });

  assert.equal(result.allowed, false);
  assert.equal(
    result.reasons.some((item) => item.code === 'PART_CONFIRMATION_CORRECTION_REQUIRED'),
    true
  );
});

test('C4 keeps partial review explicit instead of silently promoting undecided candidates', () => {
  const candidate = candidateSnapshot();
  const result = new PartStructureConfirmationService().confirm({
    snapshotId: 'part-confirmation:c4-fixture:partial',
    candidate,
    createdAt: '2026-08-20T18:10:00.000Z',
    decisions: [
      {
        decisionId: 'decision:element:1-only',
        targetKind: 'element',
        candidateElementId: 'part-element:1',
        state: 'confirmed',
        evidenceIds: ['part-evidence:1'],
      },
    ],
  });

  assert.equal(result.allowed, true);
  assert.ok(result.value);
  assert.equal(result.value.reviewComplete, false);
  assert.equal(result.value.warnings.length, 2);
  assert.deepEqual(
    new Set(result.value.warnings.map((warning) => warning.candidateId)),
    new Set(['part-element:2', 'part-relation:1'])
  );
});

test('C4 rejects duplicate decisions for the same candidate target', () => {
  const candidate = candidateSnapshot();
  const result = new PartStructureConfirmationService().confirm({
    snapshotId: 'part-confirmation:c4-fixture:duplicate',
    candidate,
    createdAt: '2026-08-20T18:11:00.000Z',
    decisions: [
      {
        decisionId: 'decision:duplicate:1',
        targetKind: 'element',
        candidateElementId: 'part-element:1',
        state: 'confirmed',
        evidenceIds: ['part-evidence:1'],
      },
      {
        decisionId: 'decision:duplicate:2',
        targetKind: 'element',
        candidateElementId: 'part-element:1',
        state: 'rejected',
        evidenceIds: ['part-evidence:1'],
      },
    ],
  });

  assert.equal(result.allowed, false);
  assert.equal(
    result.reasons.some((item) => item.code === 'PART_CONFIRMATION_DUPLICATE_TARGET'),
    true
  );
});
