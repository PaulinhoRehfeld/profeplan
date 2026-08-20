import type {
  CartographicNodeCandidate,
  CartographicPartScope,
  EntityId,
  PartReconstructionCandidateSnapshot,
  PartStructureConfirmationSnapshot,
  PartStructureDecision,
  PartStructureElementCorrection,
  PartStructureNodeCorrection,
  PartStructureRelationCorrection,
  StructuralRecognitionSnapshot,
} from '@profeplan/types';
import { reason, type DomainReason } from '../domain/reasons.ts';
import { allow, deny, type DomainDecision } from '../domain/result.ts';

const PART_STRUCTURE_CONFIRMATION_VERSION: PartStructureConfirmationSnapshot['contractVersion'] =
  '1.0.0';

export interface PartStructureConfirmationRequest {
  readonly snapshotId: EntityId;
  readonly structuralRecognition: StructuralRecognitionSnapshot;
  readonly candidate: PartReconstructionCandidateSnapshot;
  readonly createdAt: string;
  readonly decisions: readonly PartStructureDecision[];
}

function pageRangesOverlap(
  left: { startPhysicalPage: number; endPhysicalPage: number },
  right: { startPhysicalPage: number; endPhysicalPage: number }
): boolean {
  return (
    left.startPhysicalPage <= right.endPhysicalPage &&
    right.startPhysicalPage <= left.endPhysicalPage
  );
}

function relevantCartographicNodes(
  structuralRecognition: StructuralRecognitionSnapshot,
  partScope: CartographicPartScope
): readonly CartographicNodeCandidate[] {
  const activeNodes = structuralRecognition.nodes.filter((node) => node.state !== 'rejected');
  const nodesById = new Map(activeNodes.map((node) => [node.nodeId, node]));

  if (!partScope.rootNodeId || !nodesById.has(partScope.rootNodeId)) {
    return activeNodes.filter(
      (node) => node.pageRange && pageRangesOverlap(node.pageRange, partScope.pageRange)
    );
  }

  const selectedIds = new Set<EntityId>();
  let current = nodesById.get(partScope.rootNodeId);
  while (current) {
    selectedIds.add(current.nodeId);
    current = current.parentNodeId ? nodesById.get(current.parentNodeId) : undefined;
  }

  let changed = true;
  while (changed) {
    changed = false;
    for (const node of activeNodes) {
      if (node.parentNodeId && selectedIds.has(node.parentNodeId) && !selectedIds.has(node.nodeId)) {
        selectedIds.add(node.nodeId);
        changed = true;
      }
    }
  }

  return activeNodes.filter((node) => selectedIds.has(node.nodeId));
}

function hasNodeCorrection(correction: PartStructureNodeCorrection | undefined): boolean {
  return Boolean(
    correction &&
      (correction.kind !== undefined ||
        correction.observedTitle !== undefined ||
        correction.parentNodeId !== undefined ||
        correction.pageRange !== undefined ||
        correction.declaredPrintedPageLabel !== undefined)
  );
}

function hasElementCorrection(correction: PartStructureElementCorrection | undefined): boolean {
  return Boolean(
    correction &&
      (correction.kind !== undefined ||
        correction.text !== undefined ||
        correction.parentElementId !== undefined)
  );
}

function hasRelationCorrection(correction: PartStructureRelationCorrection | undefined): boolean {
  return Boolean(
    correction &&
      (correction.kind !== undefined ||
        correction.fromElementId !== undefined ||
        correction.toElementId !== undefined)
  );
}

function targetKey(decision: PartStructureDecision): string {
  if (decision.targetKind === 'cartographic_node') {
    return `cartographic_node:${decision.candidateNodeId}`;
  }
  return decision.targetKind === 'element'
    ? `element:${decision.candidateElementId}`
    : `relation:${decision.candidateRelationId}`;
}

export class PartStructureConfirmationService {
  confirm(
    request: PartStructureConfirmationRequest
  ): DomainDecision<PartStructureConfirmationSnapshot> {
    const { structuralRecognition, candidate, decisions } = request;
    const lineageReasons = this.validateLineage(structuralRecognition, candidate);
    if (lineageReasons.length > 0) {
      return deny(lineageReasons);
    }

    const reviewableNodes = relevantCartographicNodes(structuralRecognition, candidate.partScope);
    const reviewableNodesById = new Map(reviewableNodes.map((node) => [node.nodeId, node]));
    const allNodesById = new Map(structuralRecognition.nodes.map((node) => [node.nodeId, node]));
    const elementsById = new Map(
      candidate.elements.map((element) => [element.elementId, element])
    );
    const relationsById = new Map(
      candidate.relations.map((relation) => [relation.relationId, relation])
    );
    const reasons: DomainReason[] = [];
    const seenTargets = new Set<string>();

    for (const decision of decisions) {
      const key = targetKey(decision);
      if (seenTargets.has(key)) {
        reasons.push(
          reason(
            'PART_CONFIRMATION_DUPLICATE_TARGET',
            `More than one decision targets ${key}.`,
            decision.decisionId,
            { target: key }
          )
        );
        continue;
      }
      seenTargets.add(key);

      const candidateTarget =
        decision.targetKind === 'cartographic_node'
          ? reviewableNodesById.get(decision.candidateNodeId)
          : decision.targetKind === 'element'
            ? elementsById.get(decision.candidateElementId)
            : relationsById.get(decision.candidateRelationId);

      if (!candidateTarget) {
        reasons.push(
          reason(
            'PART_CONFIRMATION_TARGET_NOT_FOUND',
            `The decision target ${key} does not exist inside the reviewable candidate scope.`,
            decision.decisionId,
            { target: key }
          )
        );
        continue;
      }

      this.validateEvidence(decision, candidateTarget.evidence, key, reasons);
      this.validateCorrection(
        decision,
        key,
        allNodesById,
        elementsById,
        reasons
      );
    }

    if (reasons.length > 0) {
      return deny(reasons);
    }

    const decidedNodeIds = new Set(
      decisions
        .filter((decision) => decision.targetKind === 'cartographic_node')
        .map((decision) => decision.candidateNodeId)
    );
    const decidedElementIds = new Set(
      decisions
        .filter((decision) => decision.targetKind === 'element')
        .map((decision) => decision.candidateElementId)
    );
    const decidedRelationIds = new Set(
      decisions
        .filter((decision) => decision.targetKind === 'relation')
        .map((decision) => decision.candidateRelationId)
    );

    const warnings: PartStructureConfirmationSnapshot['warnings'][number][] = [
      ...reviewableNodes
        .filter((node) => !decidedNodeIds.has(node.nodeId))
        .map((node, index) => ({
          warningId: `part-confirmation-warning:node:${index + 1}`,
          code: 'candidate_node_not_reviewed',
          message: `Candidate cartographic node ${node.nodeId} has no structural decision.`,
          candidateId: node.nodeId,
        })),
      ...candidate.elements
        .filter((element) => !decidedElementIds.has(element.elementId))
        .map((element, index) => ({
          warningId: `part-confirmation-warning:element:${index + 1}`,
          code: 'candidate_element_not_reviewed',
          message: `Candidate element ${element.elementId} has no structural decision.`,
          candidateId: element.elementId,
        })),
      ...candidate.relations
        .filter((relation) => !decidedRelationIds.has(relation.relationId))
        .map((relation, index) => ({
          warningId: `part-confirmation-warning:relation:${index + 1}`,
          code: 'candidate_relation_not_reviewed',
          message: `Candidate relation ${relation.relationId} has no structural decision.`,
          candidateId: relation.relationId,
        })),
    ];

    return allow({
      contractVersion: PART_STRUCTURE_CONFIRMATION_VERSION,
      snapshotId: request.snapshotId,
      reconstructionCandidateSnapshotId: candidate.snapshotId,
      structuralRecognitionSnapshotId: structuralRecognition.snapshotId,
      sourceVersion: candidate.sourceVersion,
      artifactSha256: candidate.artifactSha256,
      partScope: candidate.partScope,
      inspectedPages: candidate.inspectedPages,
      createdAt: request.createdAt,
      decisions: [...decisions],
      warnings,
      reviewComplete: warnings.length === 0,
    });
  }

  private validateLineage(
    structuralRecognition: StructuralRecognitionSnapshot,
    candidate: PartReconstructionCandidateSnapshot
  ): readonly DomainReason[] {
    const reasons: DomainReason[] = [];
    if (
      candidate.structuralRecognitionSnapshotId !== structuralRecognition.snapshotId ||
      candidate.partScope.snapshotId !== structuralRecognition.snapshotId
    ) {
      reasons.push(
        reason(
          'PART_CONFIRMATION_SNAPSHOT_MISMATCH',
          'The reconstruction candidate and part scope must reference the supplied structural snapshot.',
          candidate.snapshotId
        )
      );
    }
    if (
      candidate.sourceVersion.id !== structuralRecognition.sourceVersion.id ||
      candidate.artifactSha256 !== structuralRecognition.artifactSha256
    ) {
      reasons.push(
        reason(
          'PART_CONFIRMATION_SNAPSHOT_MISMATCH',
          'Structural recognition and reconstruction candidate must belong to the same source artifact.',
          candidate.snapshotId
        )
      );
    }
    return reasons;
  }

  private validateEvidence(
    decision: PartStructureDecision,
    evidence: readonly { evidenceId: EntityId }[],
    key: string,
    reasons: DomainReason[]
  ): void {
    if (decision.evidenceIds.length === 0) {
      reasons.push(
        reason(
          'PART_CONFIRMATION_EVIDENCE_REQUIRED',
          `Decision ${decision.decisionId} must reference candidate evidence.`,
          decision.decisionId,
          { target: key }
        )
      );
      return;
    }

    const availableEvidence = new Set(evidence.map((item) => item.evidenceId));
    for (const evidenceId of decision.evidenceIds) {
      if (!availableEvidence.has(evidenceId)) {
        reasons.push(
          reason(
            'PART_CONFIRMATION_EVIDENCE_MISMATCH',
            `Evidence ${evidenceId} does not belong to ${key}.`,
            decision.decisionId,
            { target: key, evidenceId }
          )
        );
      }
    }
  }

  private validateCorrection(
    decision: PartStructureDecision,
    key: string,
    nodesById: ReadonlyMap<EntityId, CartographicNodeCandidate>,
    elementsById: ReadonlyMap<EntityId, PartReconstructionCandidateSnapshot['elements'][number]>,
    reasons: DomainReason[]
  ): void {
    const hasCorrection =
      decision.targetKind === 'cartographic_node'
        ? hasNodeCorrection(decision.correction)
        : decision.targetKind === 'element'
          ? hasElementCorrection(decision.correction)
          : hasRelationCorrection(decision.correction);

    if (decision.state === 'corrected' && !hasCorrection) {
      reasons.push(
        reason(
          'PART_CONFIRMATION_CORRECTION_REQUIRED',
          `Corrected decision ${decision.decisionId} must include an explicit correction.`,
          decision.decisionId,
          { target: key }
        )
      );
    }

    if (decision.state !== 'corrected' && hasCorrection) {
      reasons.push(
        reason(
          'PART_CONFIRMATION_CORRECTION_NOT_ALLOWED',
          'Only corrected decisions may carry correction fields.',
          decision.decisionId,
          { target: key, state: decision.state }
        )
      );
    }

    if (decision.targetKind === 'cartographic_node' && decision.correction) {
      const { parentNodeId, pageRange } = decision.correction;
      if (parentNodeId && !nodesById.has(parentNodeId)) {
        reasons.push(
          reason(
            'PART_CONFIRMATION_CORRECTION_TARGET_INVALID',
            `Corrected parent node ${parentNodeId} is not part of the structural snapshot.`,
            decision.decisionId,
            { target: key, correctedNodeId: parentNodeId }
          )
        );
      }
      if (
        pageRange &&
        (pageRange.startPhysicalPage < 1 ||
          pageRange.endPhysicalPage < pageRange.startPhysicalPage)
      ) {
        reasons.push(
          reason(
            'PART_CONFIRMATION_CORRECTION_TARGET_INVALID',
            'Corrected cartographic page range is invalid.',
            decision.decisionId,
            { target: key }
          )
        );
      }
    }

    if (decision.targetKind === 'relation' && decision.correction) {
      const { fromElementId, toElementId } = decision.correction;
      for (const correctedElementId of [fromElementId, toElementId]) {
        if (correctedElementId && !elementsById.has(correctedElementId)) {
          reasons.push(
            reason(
              'PART_CONFIRMATION_CORRECTION_TARGET_INVALID',
              `Corrected relation endpoint ${correctedElementId} is not a candidate element.`,
              decision.decisionId,
              { target: key, correctedElementId }
            )
          );
        }
      }
    }

    if (decision.targetKind === 'element' && decision.correction?.parentElementId) {
      if (!elementsById.has(decision.correction.parentElementId)) {
        reasons.push(
          reason(
            'PART_CONFIRMATION_CORRECTION_TARGET_INVALID',
            `Corrected parent ${decision.correction.parentElementId} is not a candidate element.`,
            decision.decisionId,
            { target: key, correctedElementId: decision.correction.parentElementId }
          )
        );
      }
    }
  }
}
