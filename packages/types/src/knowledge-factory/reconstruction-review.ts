import type { EntityId, ISODateTime } from './common.ts';
import type {
  PartReconstructionElementKind,
  PartReconstructionEvidenceRef,
  PartReconstructionRelationKind,
} from './reconstruction.ts';

export const PART_STRUCTURAL_REVIEW_CONTRACT_VERSION = '1.0.0' as const;

export const PART_STRUCTURAL_REVIEW_DISPOSITIONS = [
  'confirmed',
  'corrected',
  'rejected',
] as const;
export type PartStructuralReviewDisposition =
  (typeof PART_STRUCTURAL_REVIEW_DISPOSITIONS)[number];

export type PartStructuralReviewTargetKind = 'element' | 'relation';

export interface PartStructuralReviewCorrection {
  readonly elementKind?: PartReconstructionElementKind;
  readonly relationKind?: PartReconstructionRelationKind;
  readonly parentElementId?: EntityId;
  readonly fromElementId?: EntityId;
  readonly toElementId?: EntityId;
}

export interface PartStructuralReviewDecision {
  readonly decisionId: EntityId;
  readonly targetKind: PartStructuralReviewTargetKind;
  readonly targetId: EntityId;
  readonly disposition: PartStructuralReviewDisposition;
  readonly rationale: string;
  readonly evidenceIds: readonly EntityId[];
  readonly correction?: PartStructuralReviewCorrection;
}

export interface PartStructuralReviewResolvedDecision extends PartStructuralReviewDecision {
  readonly evidence: readonly PartReconstructionEvidenceRef[];
}

export interface PartStructuralReviewWarning {
  readonly warningId: EntityId;
  readonly code: string;
  readonly message: string;
  readonly targetId?: EntityId;
}

export interface PartStructuralReviewSnapshot {
  readonly contractVersion: typeof PART_STRUCTURAL_REVIEW_CONTRACT_VERSION;
  readonly reviewSnapshotId: EntityId;
  readonly candidateSnapshotId: EntityId;
  readonly createdAt: ISODateTime;
  readonly reviewerId: EntityId;
  readonly decisions: readonly PartStructuralReviewResolvedDecision[];
  readonly warnings: readonly PartStructuralReviewWarning[];
}
