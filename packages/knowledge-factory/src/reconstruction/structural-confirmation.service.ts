import type {
  CartographicNodeCandidate,
  CartographicNodeKind,
  PartReconstructionCandidateSnapshot,
  PhysicalPageRange,
  StructuralConfirmationEvidenceRef,
  StructuralConfirmationSnapshot,
  StructuralRecognitionSnapshot,
} from '@profeplan/types';

const STRUCTURAL_CONFIRMATION_VERSION: StructuralConfirmationSnapshot['contractVersion'] = '1.0.0';

export interface StructuralCorrectionInput {
  readonly kind?: CartographicNodeKind;
  readonly title?: string;
  readonly pageRange?: PhysicalPageRange;
  readonly declaredPrintedPageLabel?: string;
  readonly evidenceElementIds: readonly string[];
  readonly reason: string;
}

export type StructuralConfirmationDecision =
  | { readonly mode: 'confirm' }
  | { readonly mode: 'correct'; readonly correction: StructuralCorrectionInput }
  | {
      readonly mode: 'reject';
      readonly evidenceElementIds: readonly string[];
      readonly reason: string;
    };

export interface StructuralConfirmationRequest {
  readonly decisionId: string;
  readonly recognition: StructuralRecognitionSnapshot;
  readonly reconstruction: PartReconstructionCandidateSnapshot;
  readonly createdAt: string;
  readonly decision: StructuralConfirmationDecision;
}

function normalize(value: string): string {
  return value
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLocaleLowerCase('pt-BR')
    .replace(/\s+/g, ' ')
    .trim();
}

function samePageRange(left: PhysicalPageRange, right: PhysicalPageRange): boolean {
  return (
    left.startPhysicalPage === right.startPhysicalPage &&
    left.endPhysicalPage === right.endPhysicalPage
  );
}

function assertLinkedSnapshots(
  recognition: StructuralRecognitionSnapshot,
  reconstruction: PartReconstructionCandidateSnapshot
): void {
  if (reconstruction.structuralRecognitionSnapshotId !== recognition.snapshotId) {
    throw new Error('structural confirmation requires reconstruction from the supplied recognition');
  }
  if (reconstruction.artifactSha256 !== recognition.artifactSha256) {
    throw new Error('structural confirmation artifact digest mismatch');
  }
  if (
    reconstruction.sourceVersion.kind !== recognition.sourceVersion.kind ||
    reconstruction.sourceVersion.id !== recognition.sourceVersion.id
  ) {
    throw new Error('structural confirmation source version mismatch');
  }
}

function rootNode(
  recognition: StructuralRecognitionSnapshot,
  reconstruction: PartReconstructionCandidateSnapshot
): CartographicNodeCandidate {
  const rootNodeId = reconstruction.partScope.rootNodeId;
  if (!rootNodeId) {
    throw new Error('structural confirmation requires a cartographic root node');
  }
  const node = recognition.nodes.find((candidate) => candidate.nodeId === rootNodeId);
  if (!node) {
    throw new Error('structural confirmation root node is absent from recognition');
  }
  if (node.state === 'rejected') {
    throw new Error('rejected cartographic node cannot be structurally confirmed');
  }
  if (node.pageRange && !samePageRange(node.pageRange, reconstruction.partScope.pageRange)) {
    throw new Error('structural confirmation scope does not match the root candidate boundary');
  }
  return node;
}

function ancestry(
  recognition: StructuralRecognitionSnapshot,
  root: CartographicNodeCandidate
): StructuralConfirmationSnapshot['ancestry'] {
  const byId = new Map(recognition.nodes.map((node) => [node.nodeId, node]));
  const chain: CartographicNodeCandidate[] = [];
  const seen = new Set<string>();
  let current: CartographicNodeCandidate | undefined = root;

  while (current) {
    if (seen.has(current.nodeId)) {
      throw new Error('structural confirmation detected a cartographic ancestry cycle');
    }
    seen.add(current.nodeId);
    chain.push(current);
    current = current.parentNodeId ? byId.get(current.parentNodeId) : undefined;
  }

  return chain.reverse().map((node) => ({
    nodeId: node.nodeId,
    kind: node.kind,
    observedTitle: node.observedTitle,
    ...(node.parentNodeId ? { parentNodeId: node.parentNodeId } : {}),
    ...(node.pageRange ? { pageRange: node.pageRange } : {}),
    ...(node.declaredPrintedPageLabel
      ? { declaredPrintedPageLabel: node.declaredPrintedPageLabel }
      : {}),
  }));
}

function cartographicEvidence(root: CartographicNodeCandidate): StructuralConfirmationEvidenceRef[] {
  return root.evidence.map((evidence) => ({
    evidenceId: `structural-confirmation:${evidence.evidenceId}`,
    kind: 'cartographic_node' as const,
    sourceId: root.nodeId,
    ...(evidence.page ? { page: evidence.page } : {}),
    ...(evidence.logicalLocator ? { logicalLocator: evidence.logicalLocator } : {}),
  }));
}

function reconstructionEvidence(
  reconstruction: PartReconstructionCandidateSnapshot,
  elementIds: readonly string[]
): StructuralConfirmationEvidenceRef[] {
  const requested = new Set(elementIds);
  const elements = reconstruction.elements.filter((element) => requested.has(element.elementId));
  if (elements.length !== requested.size) {
    throw new Error('structural confirmation evidence element is absent from reconstruction');
  }

  return elements.flatMap((element) =>
    element.evidence.map((evidence) => ({
      evidenceId: `structural-confirmation:${evidence.evidenceId}`,
      kind: 'reconstruction_element' as const,
      sourceId: element.elementId,
      page: evidence.page,
      ...(evidence.logicalLocator ? { logicalLocator: evidence.logicalLocator } : {}),
    }))
  );
}

function bodyCorroboration(
  reconstruction: PartReconstructionCandidateSnapshot,
  root: CartographicNodeCandidate
) {
  return reconstruction.elements.find(
    (element) =>
      element.kind === 'part_title' &&
      element.text !== undefined &&
      normalize(element.text) === normalize(root.observedTitle) &&
      element.evidence.some((evidence) => evidence.cartographicNodeId === root.nodeId)
  );
}

function assertEvidenceInsideScope(
  evidence: readonly StructuralConfirmationEvidenceRef[],
  scope: PhysicalPageRange
): void {
  for (const item of evidence) {
    if (!item.page) {
      continue;
    }
    if (
      item.page.physicalPageNumber < scope.startPhysicalPage ||
      item.page.physicalPageNumber > scope.endPhysicalPage
    ) {
      throw new Error('structural confirmation local evidence escapes CartographicPartScope');
    }
  }
}

export class StructuralConfirmationService {
  decide(request: StructuralConfirmationRequest): StructuralConfirmationSnapshot {
    assertLinkedSnapshots(request.recognition, request.reconstruction);
    const root = rootNode(request.recognition, request.reconstruction);
    const candidateEvidence = cartographicEvidence(root);
    const warnings: StructuralConfirmationSnapshot['warnings'] = [];

    if (request.decision.mode === 'confirm') {
      const corroboration = bodyCorroboration(request.reconstruction, root);
      if (!corroboration) {
        throw new Error('structural confirmation requires body corroboration of the root title');
      }
      const localEvidence = reconstructionEvidence(request.reconstruction, [corroboration.elementId]);
      assertEvidenceInsideScope(localEvidence, request.reconstruction.partScope.pageRange);

      return {
        contractVersion: STRUCTURAL_CONFIRMATION_VERSION,
        decisionId: request.decisionId,
        structuralRecognitionSnapshotId: request.recognition.snapshotId,
        partReconstructionSnapshotId: request.reconstruction.snapshotId,
        sourceVersion: request.recognition.sourceVersion,
        artifactSha256: request.recognition.artifactSha256,
        partScope: request.reconstruction.partScope,
        createdAt: request.createdAt,
        ancestry: ancestry(request.recognition, root),
        rootDecision: {
          sourceNodeId: root.nodeId,
          state: 'confirmed',
          kind: root.kind,
          title: root.observedTitle,
          ...(root.parentNodeId ? { parentNodeId: root.parentNodeId } : {}),
          ...(root.pageRange ? { pageRange: root.pageRange } : {}),
          ...(root.declaredPrintedPageLabel
            ? { declaredPrintedPageLabel: root.declaredPrintedPageLabel }
            : {}),
          evidence: [...candidateEvidence, ...localEvidence],
        },
        warnings,
      };
    }

    if (request.decision.mode === 'correct') {
      const correction = request.decision.correction;
      if (!correction.reason.trim()) {
        throw new Error('structural correction requires a non-blank reason');
      }
      if (correction.evidenceElementIds.length === 0) {
        throw new Error('structural correction requires reconstruction evidence');
      }
      const localEvidence = reconstructionEvidence(
        request.reconstruction,
        correction.evidenceElementIds
      );
      assertEvidenceInsideScope(localEvidence, request.reconstruction.partScope.pageRange);

      return {
        contractVersion: STRUCTURAL_CONFIRMATION_VERSION,
        decisionId: request.decisionId,
        structuralRecognitionSnapshotId: request.recognition.snapshotId,
        partReconstructionSnapshotId: request.reconstruction.snapshotId,
        sourceVersion: request.recognition.sourceVersion,
        artifactSha256: request.recognition.artifactSha256,
        partScope: request.reconstruction.partScope,
        createdAt: request.createdAt,
        ancestry: ancestry(request.recognition, root),
        rootDecision: {
          sourceNodeId: root.nodeId,
          state: 'corrected',
          kind: correction.kind ?? root.kind,
          title: correction.title?.trim() || root.observedTitle,
          ...(root.parentNodeId ? { parentNodeId: root.parentNodeId } : {}),
          ...(correction.pageRange ?? root.pageRange
            ? { pageRange: correction.pageRange ?? root.pageRange }
            : {}),
          ...(correction.declaredPrintedPageLabel ?? root.declaredPrintedPageLabel
            ? {
                declaredPrintedPageLabel:
                  correction.declaredPrintedPageLabel ?? root.declaredPrintedPageLabel,
              }
            : {}),
          evidence: [...candidateEvidence, ...localEvidence],
          reason: correction.reason.trim(),
        },
        warnings,
      };
    }

    if (!request.decision.reason.trim()) {
      throw new Error('structural rejection requires a non-blank reason');
    }
    if (request.decision.evidenceElementIds.length === 0) {
      throw new Error('structural rejection requires reconstruction evidence');
    }
    const localEvidence = reconstructionEvidence(
      request.reconstruction,
      request.decision.evidenceElementIds
    );
    assertEvidenceInsideScope(localEvidence, request.reconstruction.partScope.pageRange);

    return {
      contractVersion: STRUCTURAL_CONFIRMATION_VERSION,
      decisionId: request.decisionId,
      structuralRecognitionSnapshotId: request.recognition.snapshotId,
      partReconstructionSnapshotId: request.reconstruction.snapshotId,
      sourceVersion: request.recognition.sourceVersion,
      artifactSha256: request.recognition.artifactSha256,
      partScope: request.reconstruction.partScope,
      createdAt: request.createdAt,
      ancestry: ancestry(request.recognition, root),
      rootDecision: {
        sourceNodeId: root.nodeId,
        state: 'rejected',
        kind: root.kind,
        title: root.observedTitle,
        ...(root.parentNodeId ? { parentNodeId: root.parentNodeId } : {}),
        ...(root.pageRange ? { pageRange: root.pageRange } : {}),
        ...(root.declaredPrintedPageLabel
          ? { declaredPrintedPageLabel: root.declaredPrintedPageLabel }
          : {}),
        evidence: [...candidateEvidence, ...localEvidence],
        reason: request.decision.reason.trim(),
      },
      warnings,
    };
  }
}
