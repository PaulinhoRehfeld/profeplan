import type { EntityId, ISODateTime } from './common.ts';
import type { ExtractionPageRef } from './extraction.ts';
import type { IngestionSourceVersionRef } from './ingestion.ts';

export const STRUCTURAL_RECOGNITION_CONTRACT_VERSION = '1.0.0' as const;

export const FILENAME_HINT_KINDS = [
  'collection',
  'school_component',
  'volume_designation',
  'manifestation_role',
  'program_cycle',
  'other',
] as const;
export type FilenameHintKind = (typeof FILENAME_HINT_KINDS)[number];

export interface FilenameHint {
  readonly hintId: EntityId;
  readonly kind: FilenameHintKind;
  readonly rawToken: string;
  readonly interpretedValue: string;
  readonly confidence: number;
}

export const DOCUMENT_METADATA_OBSERVATION_KINDS = [
  'title',
  'collection',
  'school_component',
  'author',
  'publisher',
  'edition',
  'isbn',
  'volume_designation',
  'manifestation_role',
  'program_cycle',
  'other',
] as const;
export type DocumentMetadataObservationKind =
  (typeof DOCUMENT_METADATA_OBSERVATION_KINDS)[number];

export const CARTOGRAPHY_EVIDENCE_SOURCE_KINDS = [
  'filename',
  'pdf_page_label',
  'page_text',
  'table_of_contents',
  'work_organization',
  'pdf_bookmark',
  'human_review',
] as const;
export type CartographyEvidenceSourceKind =
  (typeof CARTOGRAPHY_EVIDENCE_SOURCE_KINDS)[number];

export interface CartographyEvidenceRef {
  readonly evidenceId: EntityId;
  readonly sourceKind: CartographyEvidenceSourceKind;
  readonly page?: ExtractionPageRef;
  readonly logicalLocator?: string;
}

export interface DocumentMetadataObservation {
  readonly observationId: EntityId;
  readonly kind: DocumentMetadataObservationKind;
  readonly value: string;
  readonly evidence: readonly CartographyEvidenceRef[];
  readonly confidence: number;
}

export const CARTOGRAPHIC_REGION_KINDS = [
  'cover',
  'title_page',
  'cataloging',
  'credits',
  'presentation',
  'work_organization',
  'table_of_contents',
  'curricular_paratext',
  'main_content',
  'teacher_manual',
  'references',
  'glossary_index',
  'appendix',
  'unknown',
] as const;
export type CartographicRegionKind = (typeof CARTOGRAPHIC_REGION_KINDS)[number];

export interface PhysicalPageRange {
  readonly startPhysicalPage: number;
  readonly endPhysicalPage: number;
}

export interface CartographicRegionCandidate {
  readonly regionId: EntityId;
  readonly kind: CartographicRegionKind;
  readonly pageRange: PhysicalPageRange;
  readonly evidence: readonly CartographyEvidenceRef[];
  readonly confidence: number;
}

export const CARTOGRAPHIC_NODE_KINDS = [
  'part',
  'unit',
  'chapter',
  'section',
  'subsection',
  'other',
] as const;
export type CartographicNodeKind = (typeof CARTOGRAPHIC_NODE_KINDS)[number];

export const CARTOGRAPHIC_CANDIDATE_STATES = [
  'candidate',
  'reviewed_candidate',
  'rejected',
] as const;
export type CartographicCandidateState = (typeof CARTOGRAPHIC_CANDIDATE_STATES)[number];

export interface CartographicNodeCandidate {
  readonly nodeId: EntityId;
  readonly kind: CartographicNodeKind;
  readonly observedTitle: string;
  readonly parentNodeId?: EntityId;
  readonly pageRange?: PhysicalPageRange;
  readonly declaredPrintedPageLabel?: string;
  readonly evidence: readonly CartographyEvidenceRef[];
  readonly confidence: number;
  readonly state: CartographicCandidateState;
}

export interface StructuralRecognitionWarning {
  readonly warningId: EntityId;
  readonly code: string;
  readonly message: string;
  readonly page?: ExtractionPageRef;
}

export interface StructuralRecognitionSnapshot {
  readonly contractVersion: typeof STRUCTURAL_RECOGNITION_CONTRACT_VERSION;
  readonly snapshotId: EntityId;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly artifactSha256: string;
  readonly createdAt: ISODateTime;
  readonly totalPhysicalPages?: number;
  readonly inspectedPageRanges: readonly PhysicalPageRange[];
  readonly filenameHints: readonly FilenameHint[];
  readonly metadataObservations: readonly DocumentMetadataObservation[];
  readonly regions: readonly CartographicRegionCandidate[];
  readonly nodes: readonly CartographicNodeCandidate[];
  readonly warnings: readonly StructuralRecognitionWarning[];
}

export const CARTOGRAPHIC_PART_SCOPE_REASONS = [
  'table_of_contents_boundary',
  'work_organization_boundary',
  'body_heading_boundary',
  'pdf_bookmark_boundary',
  'human_review_boundary',
] as const;
export type CartographicPartScopeReason =
  (typeof CARTOGRAPHIC_PART_SCOPE_REASONS)[number];

export interface CartographicPartScope {
  readonly scopeId: EntityId;
  readonly snapshotId: EntityId;
  readonly rootNodeId?: EntityId;
  readonly pageRange: PhysicalPageRange;
  readonly reason: CartographicPartScopeReason;
  readonly confidence: number;
}
