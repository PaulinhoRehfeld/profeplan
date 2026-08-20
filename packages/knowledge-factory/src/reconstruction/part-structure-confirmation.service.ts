import type {
  EntityId,
  PartReconstructionCandidateSnapshot,
  PartStructureConfirmationSnapshot,
  PartStructureDecision,
  PartStructureElementCorrection,
  PartStructureRelationCorrection,
} from '@profeplan/types';
import { allow, deny, type DomainDecision } from '../domain/result.ts';
import { reason, type DomainReason } from '../domain/reasons.ts';

const PART_STRUCTURE_CONFIRMATION_VERSION: PartStructureConfirmationSnapshot['contractVersion'] =
  '1.0.0';

export interface PartStructureConfirmationRequest {
  readonly snapshotId: EntityId;
  readonly candidate: PartReconstructionCandidateSnapshot;
  readonly createdAt: string;
  readonly decisions: readonly PartStructureDecision[];
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
  return decision.targetKind === 'element'
    ? `element:${decision.candidateElementId}`
    : `relation:${decision.candidateRelationId}`;
}

export class PartStructureConfirmationService {
  confirm(
    request: PartStructureConfirmationRequest
  ): DomainDecision<PartStructureConfirmationSnapshot> {
    const { candidate, decisions } = request;
    const reasons: DomainReason[] = [];
    const elementsById = new Map(candidate.elements.map((element) => [element.elementId, element]));
    const relationsById = new Map(
      candidate.relations.map((relation) => [relation.relationId, relation])
    );
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
        decision.targetKind === 'element'
          ? elementsById.get(decision.candidateElementId)
          : relationsById.get(decision.candidateRelationId);

      if (!candidateTarget) {
        reasons.push(
          reason(
            'PART_CONFIRMATION_TARGET_NOT_FOUND',
            `The decision target ${key} does not exist in the candidate snapshot.`,
            decision.decisionId,
            { target: key }
          )
        );
        continue;
      }

      if (decision.evidenceIds.length === 0) {
        reasons.push(
          reason(
            'PART_CONFIRMATION_EVIDENCE_REQUIRED',
            `Decision ${decision.decisionId} must reference candidate evidence.`,
            decision.decisionId,
            { target: key }
          )
        );
      } else {
        const availableEvidence = new Set(
          candidateTarget.evidence.map((evidence) => evidence.evidenceId)
        );
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

      const hasCorrection =
        decision.targetKind === 'element'
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
            `Only corrected decisions may carry correction fields.`,
            decision.decisionId,
            { target: key, state: decision.state }
          )
        );
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

    if (reasons.length > 0) {
      return deny(reasons);
    }

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
    const undecidedElements = candidate.elements.filter(
      (element) => !decidedElementIds.has(element.elementId)
    );
    const undecidedRelations = candidate.relations.filter(
      (relation) => !decidedRelationIds.has(relation.relationId)
    );
    const warnings = [
      ...undecidedElements.map((element, index) => ({
        warningId: `part-confirmation-warning:element:${index + 1}`,
        code: 'candidate_element_not_reviewed',
        message: `Candidate element ${element.elementId} has no structural decision.`,
        candidateId: element.elementId,
      })),
      ...undecidedRelations.map((relation, index) => ({
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
      structuralRecognitionSnapshotId: candidate.structuralRecognitionSnapshotId,
      sourceVersion: candidate.sourceVersion,
      artifactSha256: candidate.artifactSha256,
      partScope: candidate.partScope,
      createdAt: request.createdAt,
      decisions: [...decisions],
      warnings,
      reviewComplete: warnings.length === 0,
    });
  }
}
