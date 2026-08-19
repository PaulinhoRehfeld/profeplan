import assert from 'node:assert/strict';
import test from 'node:test';
import { StructuralConfirmationService } from '../src/index.ts';

const sourceVersion = { kind: 'source_version', id: 'source-version:c4-test' };
const partScope = {
  scopeId: 'scope:evolucionismo',
  snapshotId: 'recognition:c4-test',
  rootNodeId: 'node:section',
  pageRange: { startPhysicalPage: 34, endPhysicalPage: 35 },
  reason: 'table_of_contents_boundary',
  confidence: 0.97,
};

function recognition(overrides = {}) {
  return {
    contractVersion: '1.0.0',
    snapshotId: 'recognition:c4-test',
    sourceVersion,
    artifactSha256: 'a'.repeat(64),
    createdAt: '2026-08-19T22:00:00.000Z',
    totalPhysicalPages: 449,
    inspectedPageRanges: [{ startPhysicalPage: 1, endPhysicalPage: 8 }],
    filenameHints: [],
    metadataObservations: [],
    regions: [],
    nodes: [
      {
        nodeId: 'node:unit',
        kind: 'unit',
        observedTitle: 'Unidade 1 — Antropologia',
        pageRange: { startPhysicalPage: 29, endPhysicalPage: 120 },
        declaredPrintedPageLabel: '28',
        evidence: [{ evidenceId: 'cartography:unit', sourceKind: 'table_of_contents' }],
        confidence: 0.97,
        state: 'candidate',
      },
      {
        nodeId: 'node:chapter',
        kind: 'chapter',
        observedTitle: 'Capítulo 1 — O pensamento antropológico',
        parentNodeId: 'node:unit',
        pageRange: { startPhysicalPage: 31, endPhysicalPage: 60 },
        declaredPrintedPageLabel: '30',
        evidence: [{ evidenceId: 'cartography:chapter', sourceKind: 'table_of_contents' }],
        confidence: 0.97,
        state: 'candidate',
      },
      {
        nodeId: 'node:section',
        kind: 'section',
        observedTitle: 'Evolucionismo social',
        parentNodeId: 'node:chapter',
        pageRange: { startPhysicalPage: 34, endPhysicalPage: 35 },
        declaredPrintedPageLabel: '33',
        evidence: [
          {
            evidenceId: 'cartography:section',
            sourceKind: 'table_of_contents',
            page: { physicalPageNumber: 7, printedPageLabel: '6' },
          },
        ],
        confidence: 0.97,
        state: 'candidate',
      },
    ],
    warnings: [],
    ...overrides,
  };
}

function reconstruction(overrides = {}) {
  return {
    contractVersion: '1.0.0',
    snapshotId: 'reconstruction:c4-test',
    structuralRecognitionSnapshotId: 'recognition:c4-test',
    sourceVersion,
    artifactSha256: 'a'.repeat(64),
    partScope,
    createdAt: '2026-08-19T22:01:00.000Z',
    inspectedPages: [
      { physicalPageNumber: 34, printedPageLabel: '33' },
      { physicalPageNumber: 35, printedPageLabel: '34' },
    ],
    elements: [
      {
        elementId: 'element:title',
        kind: 'part_title',
        page: { physicalPageNumber: 34, printedPageLabel: '33' },
        logicalLocator: 'page:34/text:1',
        text: 'Evolucionismo social',
        evidence: [
          {
            evidenceId: 'evidence:title',
            kind: 'native_text',
            page: { physicalPageNumber: 34, printedPageLabel: '33' },
            logicalLocator: 'page:34/text:1',
            cartographicNodeId: 'node:section',
          },
        ],
        confidence: 0.99,
      },
      {
        elementId: 'element:boundary',
        kind: 'body_text',
        page: { physicalPageNumber: 35, printedPageLabel: '34' },
        logicalLocator: 'page:35/text:4',
        text: 'Synthetic boundary evidence',
        evidence: [
          {
            evidenceId: 'evidence:boundary',
            kind: 'native_text',
            page: { physicalPageNumber: 35, printedPageLabel: '34' },
            logicalLocator: 'page:35/text:4',
          },
        ],
        confidence: 0.95,
      },
    ],
    relations: [],
    warnings: [],
    ...overrides,
  };
}

test('C.4 confirms a real-shape candidate without mutating C.3 candidate state', () => {
  const original = recognition();
  const result = new StructuralConfirmationService().decide({
    decisionId: 'decision:confirm',
    recognition: original,
    reconstruction: reconstruction(),
    createdAt: '2026-08-19T22:02:00.000Z',
    decision: { mode: 'confirm' },
  });

  assert.equal(result.contractVersion, '1.0.0');
  assert.equal(result.rootDecision.state, 'confirmed');
  assert.equal(result.rootDecision.sourceNodeId, 'node:section');
  assert.equal(result.rootDecision.title, 'Evolucionismo social');
  assert.deepEqual(result.rootDecision.pageRange, { startPhysicalPage: 34, endPhysicalPage: 35 });
  assert.equal(result.rootDecision.declaredPrintedPageLabel, '33');
  assert.deepEqual(
    result.ancestry.map((node) => node.nodeId),
    ['node:unit', 'node:chapter', 'node:section']
  );
  assert.equal(result.rootDecision.evidence.some((item) => item.kind === 'cartographic_node'), true);
  assert.equal(
    result.rootDecision.evidence.some((item) => item.kind === 'reconstruction_element'),
    true
  );
  assert.equal(original.nodes.find((node) => node.nodeId === 'node:section')?.state, 'candidate');
});

test('C.4 records a narrow correction as a separate decision with local evidence', () => {
  const result = new StructuralConfirmationService().decide({
    decisionId: 'decision:correct',
    recognition: recognition(),
    reconstruction: reconstruction(),
    createdAt: '2026-08-19T22:03:00.000Z',
    decision: {
      mode: 'correct',
      correction: {
        pageRange: { startPhysicalPage: 34, endPhysicalPage: 34 },
        evidenceElementIds: ['element:boundary'],
        reason: 'Synthetic negative case: body evidence narrows the candidate boundary.',
      },
    },
  });

  assert.equal(result.rootDecision.state, 'corrected');
  assert.deepEqual(result.rootDecision.pageRange, { startPhysicalPage: 34, endPhysicalPage: 34 });
  assert.match(result.rootDecision.reason, /narrows the candidate boundary/u);
  assert.equal(
    result.rootDecision.evidence.some((item) => item.sourceId === 'element:boundary'),
    true
  );
});

test('C.4 fails closed when confirmation lacks body corroboration', () => {
  const withoutTitle = reconstruction({ elements: reconstruction().elements.slice(1) });

  assert.throws(
    () =>
      new StructuralConfirmationService().decide({
        decisionId: 'decision:no-body-title',
        recognition: recognition(),
        reconstruction: withoutTitle,
        createdAt: '2026-08-19T22:04:00.000Z',
        decision: { mode: 'confirm' },
      }),
    /requires body corroboration/u
  );
});

test('C.4 rejects evidence that escapes the governed part scope', () => {
  const escapedEvidence = reconstruction({
    elements: [
      ...reconstruction().elements,
      {
        elementId: 'element:outside',
        kind: 'body_text',
        page: { physicalPageNumber: 36, printedPageLabel: '35' },
        text: 'Outside',
        evidence: [
          {
            evidenceId: 'evidence:outside',
            kind: 'native_text',
            page: { physicalPageNumber: 36, printedPageLabel: '35' },
            logicalLocator: 'page:36/text:1',
          },
        ],
        confidence: 0.95,
      },
    ],
  });

  assert.throws(
    () =>
      new StructuralConfirmationService().decide({
        decisionId: 'decision:outside',
        recognition: recognition(),
        reconstruction: escapedEvidence,
        createdAt: '2026-08-19T22:05:00.000Z',
        decision: {
          mode: 'correct',
          correction: {
            title: 'Corrected title',
            evidenceElementIds: ['element:outside'],
            reason: 'must fail',
          },
        },
      }),
    /escapes CartographicPartScope/u
  );
});

test('C.4 fails closed across artifact or snapshot mismatches', () => {
  assert.throws(
    () =>
      new StructuralConfirmationService().decide({
        decisionId: 'decision:mismatch',
        recognition: recognition(),
        reconstruction: reconstruction({ artifactSha256: 'b'.repeat(64) }),
        createdAt: '2026-08-19T22:06:00.000Z',
        decision: { mode: 'confirm' },
      }),
    /artifact digest mismatch/u
  );
});
