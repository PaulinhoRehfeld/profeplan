import type { EntityId, ISODateTime } from './common.ts';
import type { CartographicPartScope } from './cartography.ts';
import type { IngestionSourceVersionRef } from './ingestion.ts';
import type {
  PartReconstructionElementKind,
  PartReconstructionRelationKind,
} from './reconstruction.ts';

export const PART_STRUCTURE_CONFIRMATION_CONTRACT_VERSION = '1.0.0' as const;

export const PART_STRUCTURE_DECISION_STATES = ['confirmed', 'corrected', 'rejected'] as const;
export type PartStructureDecisionState = (typeof PART_STRUCTURE_DECISION_STATES)[number];

export interface PartStructureElementCorrection {
  readonly kind?: PartReconstructionElementKind;
  readonly text?: string;
  readonly parentElementId?: EntityId | null;
}

export interface PartStructureRelationCorrection {
  readonly kind?: PartReconstructionRelationKind;
  readonly fromElementId?: EntityId;
  readonly toElementId?: EntityId;
}

interface PartStructureDecisionBase {
  readonly decisionId: EntityId;
  readonly state: PartStructureDecisionState;
  readonly evidenceIds: readonly EntityId[];
  readonly note?: string;
}

export interface PartStructureElementDecision extends PartStructureDecisionBase {
  readonly targetKind: 'element';
  readonly candidateElementId: EntityId;
  readonly correction?: PartStructureElementCorrection;
}

export interface PartStructureRelationDecision extends PartStructureDecisionBase {
  readonly targetKind: 'relation';
  readonly candidateRelationId: EntityId;
  readonly correction?: PartStructureRelationCorrection;
}

export type PartStructureDecision = PartStructureElementDecision | PartStructureRelationDecision;

export interface PartStructureConfirmationWarning {
  readonly warningId: EntityId;
  readonly code: string;
  readonly message: string;
  readonly candidateId?: EntityId;
}

export interface PartStructureConfirmationSnapshot {
  readonly contractVersion: typeof PART_STRUCTURE_CONFIRMATION_CONTRACT_VERSION;
  readonly snapshotId: EntityId;
  readonly reconstructionCandidateSnapshotId: EntityId;
  readonly structuralRecognitionSnapshotId: EntityId;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly artifactSha256: string;
  readonly partScope: CartographicPartScope;
  readonly createdAt: ISODateTime;
  readonly decisions: readonly PartStructureDecision[];
  readonly warnings: readonly PartStructureConfirmationWarning[];
  readonly reviewComplete: boolean;
}
