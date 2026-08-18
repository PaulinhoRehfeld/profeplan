import type { EntityId, ISODateTime, VersionTag } from './common.ts';
import type { IngestionRunRef, IngestionSourceVersionRef } from './ingestion.ts';
import type { SourceActorRef } from './source-lifecycle.ts';

export const EXTRACTION_CONTRACT_VERSION = '1.0.0' as const;

export const EXTRACTION_RUN_STATES = [
  'REQUESTED',
  'READY',
  'EXTRACTING',
  'VALIDATING',
  'PENDING_REVIEW',
  'VALIDATED_FOR_SEGMENTATION',
  'REQUIRES_ALTERNATE_EXTRACTION',
  'BLOCKED_AUTHORIZATION',
  'REJECTED',
  'FAILED',
  'CANCELLED',
] as const;
export type ExtractionRunState = (typeof EXTRACTION_RUN_STATES)[number];

export const EXTRACTION_TERMINAL_STATES = [
  'VALIDATED_FOR_SEGMENTATION',
  'REQUIRES_ALTERNATE_EXTRACTION',
  'BLOCKED_AUTHORIZATION',
  'REJECTED',
  'FAILED',
  'CANCELLED',
] as const satisfies readonly ExtractionRunState[];
export type ExtractionTerminalState = (typeof EXTRACTION_TERMINAL_STATES)[number];

export const EXTRACTION_STATE_TRANSITIONS = {
  REQUESTED: ['READY', 'BLOCKED_AUTHORIZATION', 'FAILED', 'CANCELLED'],
  READY: ['EXTRACTING', 'BLOCKED_AUTHORIZATION', 'FAILED', 'CANCELLED'],
  EXTRACTING: [
    'VALIDATING',
    'REQUIRES_ALTERNATE_EXTRACTION',
    'BLOCKED_AUTHORIZATION',
    'FAILED',
    'CANCELLED',
  ],
  VALIDATING: [
    'PENDING_REVIEW',
    'REQUIRES_ALTERNATE_EXTRACTION',
    'BLOCKED_AUTHORIZATION',
    'FAILED',
    'CANCELLED',
  ],
  PENDING_REVIEW: [
    'VALIDATED_FOR_SEGMENTATION',
    'READY',
    'BLOCKED_AUTHORIZATION',
    'REJECTED',
    'FAILED',
    'CANCELLED',
  ],
  VALIDATED_FOR_SEGMENTATION: [],
  REQUIRES_ALTERNATE_EXTRACTION: [],
  BLOCKED_AUTHORIZATION: [],
  REJECTED: [],
  FAILED: [],
  CANCELLED: [],
} as const satisfies Record<ExtractionRunState, readonly ExtractionRunState[]>;

export interface ExtractionRunRef {
  readonly kind: 'extraction_run';
  readonly id: EntityId;
}

export interface ExtractionArtifactRef {
  readonly artifactId: EntityId;
  readonly sha256: string;
  readonly sizeBytes: number;
}

export interface ExtractionIngestionHandoffRef {
  readonly contractVersion: '1.0.0';
  readonly ingestionRun: IngestionRunRef;
  readonly aggregateVersion: VersionTag;
  readonly sequence: number;
  readonly reviewedArtifactId: EntityId;
  readonly approvalEventId: EntityId;
  readonly committedAt: ISODateTime;
}

export const EXTRACTION_AUTHORIZATION_CHECKPOINTS = [
  'claim',
  'artifact_read',
  'finalization',
] as const;
export type ExtractionAuthorizationCheckpoint =
  (typeof EXTRACTION_AUTHORIZATION_CHECKPOINTS)[number];

export interface ExtractionAuthorizationEvidence {
  readonly authorizationId: EntityId;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly purpose: 'extraction';
  readonly checkpoint: ExtractionAuthorizationCheckpoint;
  readonly evaluatedAt: ISODateTime;
}

export const EXTRACTION_METHOD_KINDS = ['native_text', 'alternate_extraction'] as const;
export type ExtractionMethodKind = (typeof EXTRACTION_METHOD_KINDS)[number];

export interface ExtractionMethodRef {
  readonly kind: ExtractionMethodKind;
  readonly name: string;
  readonly version: string;
}

export interface ExtractionRequest {
  readonly requestId: EntityId;
  readonly run: ExtractionRunRef;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly ingestionHandoff: ExtractionIngestionHandoffRef;
  readonly artifact: ExtractionArtifactRef;
  readonly method: ExtractionMethodRef;
  readonly requestedBy: SourceActorRef;
  readonly requestedAt: ISODateTime;
}

export const EXTRACTION_PAGE_OUTCOMES = [
  'extracted',
  'empty',
  'rejected',
  'pending',
  'discarded',
] as const;
export type ExtractionPageOutcome = (typeof EXTRACTION_PAGE_OUTCOMES)[number];

export interface ExtractionPageRef {
  readonly physicalPageNumber: number;
  readonly printedPageLabel?: string;
}

export const EXTRACTION_OBSERVED_ELEMENT_KINDS = [
  'text_block',
  'header',
  'footer',
  'note',
  'box',
  'column',
  'table',
  'image_marker',
  'chart_marker',
  'map_marker',
  'infographic_marker',
] as const;
export type ExtractionObservedElementKind = (typeof EXTRACTION_OBSERVED_ELEMENT_KINDS)[number];

export interface ExtractionObservedElementRef {
  readonly elementId: EntityId;
  readonly page: ExtractionPageRef;
  readonly kind: ExtractionObservedElementKind;
  readonly logicalLocator: string;
}

export const EXTRACTION_QUALITY_METRICS = [
  'page_coverage',
  'element_coverage',
  'invalid_character_rate',
  'text_density',
  'reading_order_ambiguity',
  'table_structure_integrity',
  'provenance_completeness',
] as const;
export type ExtractionQualityMetric = (typeof EXTRACTION_QUALITY_METRICS)[number];

export const EXTRACTION_QUALITY_UNITS = ['ratio', 'count', 'boolean'] as const;
export type ExtractionQualityUnit = (typeof EXTRACTION_QUALITY_UNITS)[number];

export interface ExtractionQualityMeasurement {
  readonly metric: ExtractionQualityMetric;
  readonly value: number | boolean;
  readonly unit: ExtractionQualityUnit;
  readonly measuredAt: ISODateTime;
}

export interface ExtractionProvenanceEvidence {
  readonly run: ExtractionRunRef;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly ingestionRun: IngestionRunRef;
  readonly artifactSha256: string;
  readonly method: ExtractionMethodRef;
  readonly observedAt: ISODateTime;
}

export interface ExtractionCommandEnvelope {
  readonly commandId: EntityId;
  readonly fingerprint: string;
  readonly actor: SourceActorRef;
  readonly occurredAt: ISODateTime;
  readonly correlationId: EntityId;
  readonly reason: string;
  readonly expectedVersion?: VersionTag;
  readonly expectedSequence?: number;
}

export const EXTRACTION_COMMAND_TYPES = [
  'request_extraction',
  'mark_ready',
  'begin_extraction',
  'begin_validation',
  'request_review',
  'approve_for_segmentation',
  'request_reprocessing',
  'require_alternate_extraction',
  'block_authorization',
  'reject_extraction',
  'fail_extraction',
  'cancel_extraction',
] as const;
export type ExtractionCommandType = (typeof EXTRACTION_COMMAND_TYPES)[number];

export interface RequestExtractionCommand extends ExtractionCommandEnvelope {
  readonly commandType: 'request_extraction';
  readonly request: ExtractionRequest;
}

interface ExtractionTransitionCommandBase extends ExtractionCommandEnvelope {
  readonly run: ExtractionRunRef;
  readonly expectedState: ExtractionRunState;
}

export interface MarkExtractionReadyCommand extends ExtractionTransitionCommandBase {
  readonly commandType: 'mark_ready';
}

export interface BeginExtractionCommand extends ExtractionTransitionCommandBase {
  readonly commandType: 'begin_extraction';
  readonly authorizationEvidence: ExtractionAuthorizationEvidence & {
    readonly checkpoint: 'claim';
  };
}

export interface BeginExtractionValidationCommand extends ExtractionTransitionCommandBase {
  readonly commandType: 'begin_validation';
}

export interface RequestExtractionReviewCommand extends ExtractionTransitionCommandBase {
  readonly commandType: 'request_review';
}

export interface ApproveExtractionForSegmentationCommand extends ExtractionTransitionCommandBase {
  readonly commandType: 'approve_for_segmentation';
  readonly authorizationEvidence: ExtractionAuthorizationEvidence & {
    readonly checkpoint: 'finalization';
  };
}

export interface RequestExtractionReprocessingCommand extends ExtractionTransitionCommandBase {
  readonly commandType: 'request_reprocessing';
}

export interface RequireAlternateExtractionCommand extends ExtractionTransitionCommandBase {
  readonly commandType: 'require_alternate_extraction';
  readonly reasonCode: 'native_text_insufficient';
}

export interface BlockExtractionAuthorizationCommand extends ExtractionTransitionCommandBase {
  readonly commandType: 'block_authorization';
  readonly authorizationEvidence?: ExtractionAuthorizationEvidence;
  readonly reasonCode: 'authorization_invalid';
}

export interface RejectExtractionCommand extends ExtractionTransitionCommandBase {
  readonly commandType: 'reject_extraction';
  readonly reasonCode: 'human_review_rejected' | 'quality_rejected';
}

export interface FailExtractionCommand extends ExtractionTransitionCommandBase {
  readonly commandType: 'fail_extraction';
  readonly reasonCode: 'technical_failure';
}

export interface CancelExtractionCommand extends ExtractionTransitionCommandBase {
  readonly commandType: 'cancel_extraction';
  readonly reasonCode: 'operator_cancelled';
}

export type ExtractionCommand =
  | RequestExtractionCommand
  | MarkExtractionReadyCommand
  | BeginExtractionCommand
  | BeginExtractionValidationCommand
  | RequestExtractionReviewCommand
  | ApproveExtractionForSegmentationCommand
  | RequestExtractionReprocessingCommand
  | RequireAlternateExtractionCommand
  | BlockExtractionAuthorizationCommand
  | RejectExtractionCommand
  | FailExtractionCommand
  | CancelExtractionCommand;

export const EXTRACTION_EVENT_TYPES = [
  'extraction_requested',
  'extraction_ready',
  'extraction_started',
  'extraction_validation_started',
  'extraction_review_requested',
  'extraction_validated_for_segmentation',
  'extraction_reprocessing_requested',
  'extraction_alternate_required',
  'extraction_authorization_blocked',
  'extraction_rejected',
  'extraction_failed',
  'extraction_cancelled',
] as const;
export type ExtractionEventType = (typeof EXTRACTION_EVENT_TYPES)[number];

export interface ExtractionEvent {
  readonly eventId: EntityId;
  readonly eventType: ExtractionEventType;
  readonly run: ExtractionRunRef;
  readonly aggregateVersion: VersionTag;
  readonly sequence: number;
  readonly actor: SourceActorRef;
  readonly reason: string;
  readonly occurredAt: ISODateTime;
  readonly correlationId: EntityId;
  readonly commandId: EntityId;
  readonly fromState?: ExtractionRunState;
  readonly toState: ExtractionRunState;
}

export type ExtractionReceiptOutcome = 'applied' | 'replayed';

export interface ExtractionCommandReceipt {
  readonly contractVersion: typeof EXTRACTION_CONTRACT_VERSION;
  readonly commandId: EntityId;
  readonly fingerprint: string;
  readonly correlationId: EntityId;
  readonly operation: ExtractionCommandType;
  readonly run: ExtractionRunRef;
  readonly aggregateVersion: VersionTag;
  readonly sequence: number;
  readonly eventIds: readonly EntityId[];
  readonly previousState?: ExtractionRunState;
  readonly state: ExtractionRunState;
  readonly outcome: ExtractionReceiptOutcome;
  readonly committedAt: ISODateTime;
}

export interface ExtractionCommandReplayRecord {
  readonly commandId: EntityId;
  readonly fingerprint: string;
  readonly receipt: ExtractionCommandReceipt;
}

export interface ExtractionRunSnapshot {
  readonly contractVersion: typeof EXTRACTION_CONTRACT_VERSION;
  readonly run: ExtractionRunRef;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly ingestionHandoff: ExtractionIngestionHandoffRef;
  readonly state: ExtractionRunState;
  readonly aggregateVersion: VersionTag;
  readonly sequence: number;
  readonly method: ExtractionMethodRef;
  readonly updatedAt: ISODateTime;
}
