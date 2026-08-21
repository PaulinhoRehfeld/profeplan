import type {
  PartReconstructionCandidateSnapshot,
  PartReconstructionEvidenceRef,
  PartStructuralReviewCorrection,
  PartStructuralReviewDecision,
  PartStructuralReviewSnapshot,
} from '@profeplan/types';

const REVIEW_CONTRACT_VERSION: PartStructuralReviewSnapshot['contractVersion'] = '1.0.0';

export interface PartStructuralReviewRequest {
  readonly reviewSnapshotId: string;
  readonly candidate: PartReconstructionCandidateSnapshot;
  readonly reviewerId: string;
  readonly createdAt: string;
  readonly decisions: readonly PartStructuralReviewDecision[];
}

function hasCorrectionValue(correction: PartStructuralReviewCorrection | undefined): boolean {
  return Boolean(
    correction &&
    (correction.elementKind ||
      correction.relationKind ||
      correction.parentElementId ||
      correction.fromElementId ||
      correction.toElementId)
  );
}

function evidenceById(
  evidence: readonly PartReconstructionEvidenceRef[]
): ReadonlyMap<string, PartReconstructionEvidenceRef> {
  return new Map(evidence.map((item) => [item.evidenceId, item]));
}

export class PartStructuralReviewService {
  review(request: PartStructuralReviewRequest): PartStructuralReviewSnapshot {
    if (!request.reviewerId.trim()) {
      throw new Error('reviewerId is required for structural confirmation');
    }

    const elementById = new Map(
      request.candidate.elements.map((element) => [element.elementId, element])
    );
    const relationById = new Map(
      request.candidate.relations.map((relation) => [relation.relationId, relation])
    );
    const reviewedTargets = new Set<string>();

    const decisions = request.decisions.map((decision) => {
      const targetKey = `${decision.targetKind}:${decision.targetId}`;
      if (reviewedTargets.has(targetKey)) {
        throw new Error(`duplicate structural review target: ${targetKey}`);
      }
      reviewedTargets.add(targetKey);

      if (!decision.rationale.trim()) {
        throw new Error(
          `rationale is required for structural review decision ${decision.decisionId}`
        );
      }
      if (decision.evidenceIds.length === 0) {
        throw new Error(
          `evidence is required for structural review decision ${decision.decisionId}`
        );
      }

      const target =
        decision.targetKind === 'element'
          ? elementById.get(decision.targetId)
          : relationById.get(decision.targetId);
      if (!target) {
        throw new Error(`structural review target not found in candidate snapshot: ${targetKey}`);
      }

      const correctionPresent = hasCorrectionValue(decision.correction);
      if (decision.disposition === 'corrected' && !correctionPresent) {
        throw new Error(`corrected decision ${decision.decisionId} requires a correction`);
      }
      if (decision.disposition !== 'corrected' && correctionPresent) {
        throw new Error(
          `${decision.disposition} decision ${decision.decisionId} cannot carry a correction`
        );
      }

      if (decision.targetKind === 'element' && decision.correction?.relationKind) {
        throw new Error(`element decision ${decision.decisionId} cannot correct relation kind`);
      }
      if (
        decision.targetKind === 'element' &&
        (decision.correction?.fromElementId || decision.correction?.toElementId)
      ) {
        throw new Error(
          `element decision ${decision.decisionId} cannot correct relation endpoints`
        );
      }
      if (
        decision.targetKind === 'relation' &&
        (decision.correction?.elementKind || decision.correction?.parentElementId)
      ) {
        throw new Error(`relation decision ${decision.decisionId} cannot correct element fields`);
      }

      const availableEvidence = evidenceById(target.evidence);
      const resolvedEvidence = decision.evidenceIds.map((evidenceId) => {
        const evidence = availableEvidence.get(evidenceId);
        if (!evidence) {
          throw new Error(
            `evidence ${evidenceId} does not belong to structural review target ${targetKey}`
          );
        }
        return evidence;
      });

      return {
        ...decision,
        evidence: resolvedEvidence,
      };
    });

    return {
      contractVersion: REVIEW_CONTRACT_VERSION,
      reviewSnapshotId: request.reviewSnapshotId,
      candidateSnapshotId: request.candidate.snapshotId,
      createdAt: request.createdAt,
      reviewerId: request.reviewerId,
      decisions,
      warnings: [],
    };
  }
}
