import type { EntityId, ISODateTime } from './common.ts';
import type {
  CartographicNodeKind,
  CartographicPartScope,
  PhysicalPageRange,
} from './cartography.ts';
import type { ExtractionPageRef } from './extraction.ts';
import type { IngestionSourceVersionRef } from './ingestion.ts';

export const STRUCTURAL_CONFIRMATION_CONTRACT_VERSION = '1.0.0' as const;

export const STRUCTURAL_RESOLUTION_STATES = ['confirmed', 'corrected', 'rejected'] as const;
export type StructuralResolutionState = (typeof STRUCTURAL_RESOLUTION_STATES)[number];

export const STRUCTURAL_CONFIRMATION_EVIDENCE_KINDS = [
  'cartographic_node',
  'reconstruction_element',
  'human_review',
] as const;
export type StructuralConfirmationEvidenceKind =
  (typeof STRUCTURAL_CONFIRMATION_EVIDENCE_KINDS)[number];

export interface StructuralConfirmationEvidenceRef {
  readonly evidenceId: EntityId;
  readonly kind: StructuralConfirmationEvidenceKind;
  readonly sourceId: EntityId;
  readonly page?: ExtractionPageRef;
  readonly logicalLocator?: string;
}

export interface StructuralAncestryCandidateRef {
  readonly nodeId: EntityId;
  readonly kind: CartographicNodeKind;
  readonly observedTitle: string;
  readonly parentNodeId?: EntityId;
  readonly pageRange?: PhysicalPageRange;
  readonly declaredPrintedPageLabel?: string;
}

export interface ResolvedStructuralNode {
  readonly sourceNodeId: EntityId;
  readonly state: StructuralResolutionState;
  readonly kind: CartographicNodeKind;
  readonly title: string;
  readonly parentNodeId?: EntityId;
  readonly pageRange?: PhysicalPageRange;
  readonly declaredPrintedPageLabel?: string;
  readonly evidence: readonly StructuralConfirmationEvidenceRef[];
  readonly reason?: string;
}

export interface StructuralConfirmationWarning {
  readonly warningId: EntityId;
  readonly code: string;
  readonly message: string;
  readonly page?: ExtractionPageRef;
}

export interface StructuralConfirmationSnapshot {
  readonly contractVersion: typeof STRUCTURAL_CONFIRMATION_CONTRACT_VERSION;
  readonly decisionId: EntityId;
  readonly structuralRecognitionSnapshotId: EntityId;
  readonly partReconstructionSnapshotId: EntityId;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly artifactSha256: string;
  readonly partScope: CartographicPartScope;
  readonly createdAt: ISODateTime;
  readonly ancestry: readonly StructuralAncestryCandidateRef[];
  readonly rootDecision: ResolvedStructuralNode;
  readonly warnings: readonly StructuralConfirmationWarning[];
}
