import type { EntityId, ISODateTime } from './common.ts';
import type { CartographicPartScope } from './cartography.ts';
import type { ExtractionPageRef } from './extraction.ts';
import type { IngestionSourceVersionRef } from './ingestion.ts';

export const PART_RECONSTRUCTION_CONTRACT_VERSION = '1.0.0' as const;

export const PART_RECONSTRUCTION_ELEMENT_KINDS = [
  'part_title',
  'section_heading',
  'body_text',
  'activity_heading',
  'activity_prompt',
  'visual_marker',
  'caption',
  'teacher_guidance_heading',
  'teacher_guidance_text',
] as const;
export type PartReconstructionElementKind =
  (typeof PART_RECONSTRUCTION_ELEMENT_KINDS)[number];

export const PART_RECONSTRUCTION_EVIDENCE_KINDS = [
  'native_text',
  'observed_element',
  'cartographic_node',
  'teacher_manual_text',
] as const;
export type PartReconstructionEvidenceKind =
  (typeof PART_RECONSTRUCTION_EVIDENCE_KINDS)[number];

export interface PartReconstructionEvidenceRef {
  readonly evidenceId: EntityId;
  readonly kind: PartReconstructionEvidenceKind;
  readonly page: ExtractionPageRef;
  readonly logicalLocator?: string;
  readonly cartographicNodeId?: EntityId;
}

export interface PartReconstructionElementCandidate {
  readonly elementId: EntityId;
  readonly kind: PartReconstructionElementKind;
  readonly page: ExtractionPageRef;
  readonly logicalLocator?: string;
  readonly text?: string;
  readonly parentElementId?: EntityId;
  readonly evidence: readonly PartReconstructionEvidenceRef[];
  readonly confidence: number;
}

export const PART_RECONSTRUCTION_RELATION_KINDS = [
  'contains',
  'caption_for_visual',
  'teacher_guidance_for_activity',
] as const;
export type PartReconstructionRelationKind =
  (typeof PART_RECONSTRUCTION_RELATION_KINDS)[number];

export interface PartReconstructionRelationCandidate {
  readonly relationId: EntityId;
  readonly kind: PartReconstructionRelationKind;
  readonly fromElementId: EntityId;
  readonly toElementId: EntityId;
  readonly evidence: readonly PartReconstructionEvidenceRef[];
  readonly confidence: number;
}

export interface PartReconstructionWarning {
  readonly warningId: EntityId;
  readonly code: string;
  readonly message: string;
  readonly page?: ExtractionPageRef;
}

export interface PartReconstructionCandidateSnapshot {
  readonly contractVersion: typeof PART_RECONSTRUCTION_CONTRACT_VERSION;
  readonly snapshotId: EntityId;
  readonly structuralRecognitionSnapshotId: EntityId;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly artifactSha256: string;
  readonly partScope: CartographicPartScope;
  readonly createdAt: ISODateTime;
  readonly inspectedPages: readonly ExtractionPageRef[];
  readonly elements: readonly PartReconstructionElementCandidate[];
  readonly relations: readonly PartReconstructionRelationCandidate[];
  readonly warnings: readonly PartReconstructionWarning[];
}
