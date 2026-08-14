import type { EntityId, ISODateTime, VersionTag } from './common.ts';
import type { SourceActorRef, SourceIdentityRef, SourcePurpose } from './source-lifecycle.ts';

export const INGESTION_CONTRACT_VERSION = '1.0.0' as const;

export const INGESTION_RUN_STATES = [
  'REQUESTED',
  'STAGING',
  'STAGED',
  'VERIFYING',
  'VERIFIED',
  'PENDING_REVIEW',
  'APPROVED_FOR_EXTRACTION',
  'REJECTED',
  'FAILED',
  'CANCELLED',
] as const;
export type IngestionRunState = (typeof INGESTION_RUN_STATES)[number];

export const INGESTION_TERMINAL_STATES = [
  'APPROVED_FOR_EXTRACTION',
  'REJECTED',
  'FAILED',
  'CANCELLED',
] as const satisfies readonly IngestionRunState[];
export type IngestionTerminalState = (typeof INGESTION_TERMINAL_STATES)[number];

export interface IngestionSourceVersionRef extends SourceIdentityRef {
  readonly kind: 'source_version';
}

export interface IngestionReceivedFileRef extends SourceIdentityRef {
  readonly kind: 'received_file';
}

export interface IngestionRunRef extends SourceIdentityRef {
  readonly kind: 'processing_run';
}

export type IngestionAuthorizationPurpose = Extract<
  SourcePurpose,
  'temporary_staging' | 'ingestion' | 'extraction'
>;

export interface IngestionAuthorizationEvidence {
  readonly authorizationId: EntityId;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly purpose: IngestionAuthorizationPurpose;
  readonly evaluatedAt: ISODateTime;
}

export interface TemporaryStagingArtifactRef {
  readonly artifactId: EntityId;
  readonly opaqueLocator: string;
}

export interface IngestionTechnicalMetadata {
  readonly declaredMediaType?: string;
  readonly sizeBytes?: number;
  readonly stagingArtifact?: TemporaryStagingArtifactRef;
}

export interface IngestionRequest {
  readonly requestId: EntityId;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly receivedFile: IngestionReceivedFileRef;
  readonly run: IngestionRunRef;
  readonly requestedBy: SourceActorRef;
  readonly requestedAt: ISODateTime;
  readonly authorizationEvidence: readonly IngestionAuthorizationEvidence[];
  readonly technicalMetadata?: IngestionTechnicalMetadata;
}

export const INGESTION_REVIEW_DECISIONS = ['APPROVE_FOR_EXTRACTION', 'REJECT'] as const;
export type IngestionReviewDecision = (typeof INGESTION_REVIEW_DECISIONS)[number];

export interface IngestionHumanReview {
  readonly reviewId: EntityId;
  readonly reviewer: SourceActorRef;
  readonly decision: IngestionReviewDecision;
  readonly decidedAt: ISODateTime;
  readonly reason: string;
}

export const INGESTION_REASON_CODES = [
  'policy_rejected',
  'technical_failure',
  'human_review_rejected',
  'operator_cancelled',
] as const;
export type IngestionReasonCode = (typeof INGESTION_REASON_CODES)[number];

export interface IngestionCommandEnvelope {
  readonly commandId: EntityId;
  readonly fingerprint: string;
  readonly actor: SourceActorRef;
  readonly occurredAt: ISODateTime;
  readonly correlationId: EntityId;
  readonly reason: string;
  readonly expectedVersion?: VersionTag;
  readonly expectedSequence?: number;
}

export const INGESTION_COMMAND_TYPES = [
  'request_ingestion',
  'begin_staging',
  'mark_staged',
  'begin_verification',
  'confirm_verified',
  'request_review',
  'approve_for_extraction',
  'reject_ingestion',
  'fail_ingestion',
  'cancel_ingestion',
] as const;
export type IngestionCommandType = (typeof INGESTION_COMMAND_TYPES)[number];

export interface RequestIngestionCommand extends IngestionCommandEnvelope {
  readonly commandType: 'request_ingestion';
  readonly request: IngestionRequest;
}

interface IngestionTransitionCommandBase extends IngestionCommandEnvelope {
  readonly run: IngestionRunRef;
  readonly expectedState: IngestionRunState;
}

export interface BeginIngestionStagingCommand extends IngestionTransitionCommandBase {
  readonly commandType: 'begin_staging';
}

export interface MarkIngestionStagedCommand extends IngestionTransitionCommandBase {
  readonly commandType: 'mark_staged';
  readonly technicalMetadata?: IngestionTechnicalMetadata;
}

export interface BeginIngestionVerificationCommand extends IngestionTransitionCommandBase {
  readonly commandType: 'begin_verification';
}

export interface ConfirmIngestionVerifiedCommand extends IngestionTransitionCommandBase {
  readonly commandType: 'confirm_verified';
  readonly technicalMetadata?: IngestionTechnicalMetadata;
}

export interface RequestIngestionReviewCommand extends IngestionTransitionCommandBase {
  readonly commandType: 'request_review';
}

export interface ApproveIngestionForExtractionCommand extends IngestionTransitionCommandBase {
  readonly commandType: 'approve_for_extraction';
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly review: IngestionHumanReview;
  readonly authorizationEvidence: readonly IngestionAuthorizationEvidence[];
}

export interface RejectIngestionCommand extends IngestionTransitionCommandBase {
  readonly commandType: 'reject_ingestion';
  readonly reasonCode: Extract<IngestionReasonCode, 'policy_rejected' | 'human_review_rejected'>;
  readonly review?: IngestionHumanReview;
}

export interface FailIngestionCommand extends IngestionTransitionCommandBase {
  readonly commandType: 'fail_ingestion';
  readonly reasonCode: Extract<IngestionReasonCode, 'technical_failure'>;
}

export interface CancelIngestionCommand extends IngestionTransitionCommandBase {
  readonly commandType: 'cancel_ingestion';
  readonly reasonCode: Extract<IngestionReasonCode, 'operator_cancelled'>;
}

export type IngestionCommand =
  | RequestIngestionCommand
  | BeginIngestionStagingCommand
  | MarkIngestionStagedCommand
  | BeginIngestionVerificationCommand
  | ConfirmIngestionVerifiedCommand
  | RequestIngestionReviewCommand
  | ApproveIngestionForExtractionCommand
  | RejectIngestionCommand
  | FailIngestionCommand
  | CancelIngestionCommand;

export const INGESTION_EVENT_TYPES = [
  'ingestion_requested',
  'ingestion_staging_started',
  'ingestion_staged',
  'ingestion_verification_started',
  'ingestion_verified',
  'ingestion_review_requested',
  'ingestion_approved_for_extraction',
  'ingestion_rejected',
  'ingestion_failed',
  'ingestion_cancelled',
] as const;
export type IngestionEventType = (typeof INGESTION_EVENT_TYPES)[number];

export interface IngestionEvent {
  readonly eventId: EntityId;
  readonly eventType: IngestionEventType;
  readonly run: IngestionRunRef;
  readonly aggregateVersion: VersionTag;
  readonly sequence: number;
  readonly actor: SourceActorRef;
  readonly reason: string;
  readonly occurredAt: ISODateTime;
  readonly correlationId: EntityId;
  readonly commandId: EntityId;
  readonly fromState?: IngestionRunState;
  readonly toState: IngestionRunState;
  readonly reasonCode?: IngestionReasonCode;
}

export type IngestionReceiptOutcome = 'applied' | 'replayed';

export interface IngestionCommandReceipt {
  readonly contractVersion: typeof INGESTION_CONTRACT_VERSION;
  readonly commandId: EntityId;
  readonly fingerprint: string;
  readonly correlationId: EntityId;
  readonly operation: IngestionCommandType;
  readonly run: IngestionRunRef;
  readonly aggregateVersion: VersionTag;
  readonly sequence: number;
  readonly eventIds: readonly EntityId[];
  readonly previousState?: IngestionRunState;
  readonly state: IngestionRunState;
  readonly outcome: IngestionReceiptOutcome;
  readonly committedAt: ISODateTime;
  readonly reasonCode?: IngestionReasonCode;
}

export interface IngestionCommandReplayRecord {
  readonly commandId: EntityId;
  readonly fingerprint: string;
  readonly receipt: IngestionCommandReceipt;
}
