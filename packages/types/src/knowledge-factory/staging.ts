import type { EntityId, ISODateTime } from './common.ts';
import type { BinaryDuplicateDecision, TemporaryStagingIntegrityEvidence } from './integrity.ts';
import type {
  IngestionReceivedFileRef,
  IngestionRunRef,
  IngestionSourceVersionRef,
  TemporaryStagingArtifactRef,
} from './ingestion.ts';

export const STAGING_CONTRACT_VERSION = '1.0.0' as const;

export const TEMPORARY_STAGING_ARTIFACT_STATES = [
  'EXPECTED',
  'RECEIVING',
  'STAGED',
  'VERIFIED',
  'RELEASED_FOR_EXTRACTION',
  'DISCARD_PENDING',
  'DISCARDED',
  'QUARANTINED',
  'FAILED',
] as const;
export type TemporaryStagingArtifactState = (typeof TEMPORARY_STAGING_ARTIFACT_STATES)[number];

export const STAGING_DISCARD_OUTCOMES = ['discarded', 'already_discarded'] as const;
export type StagingDiscardOutcome = (typeof STAGING_DISCARD_OUTCOMES)[number];

export const STAGING_DISCARD_REASON_CODES = [
  'success_after_stage',
  'policy_rejected',
  'operator_cancelled',
  'technical_failure',
  'retention_expired',
  'orphan_cleanup',
] as const;
export type StagingDiscardReasonCode = (typeof STAGING_DISCARD_REASON_CODES)[number];

export interface TemporaryStagingArtifactDescriptor {
  readonly contractVersion: typeof STAGING_CONTRACT_VERSION;
  readonly state: Extract<TemporaryStagingArtifactState, 'STAGED'>;
  readonly artifact: TemporaryStagingArtifactRef;
  readonly run: IngestionRunRef;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly receivedFile: IngestionReceivedFileRef;
  readonly sizeBytes: number;
  readonly mediaType: string;
  readonly createdAt: ISODateTime;
  readonly expiresAt: ISODateTime;
}

export interface VerifiedTemporaryStagingArtifactDescriptor
  extends Omit<TemporaryStagingArtifactDescriptor, 'state'> {
  readonly state: Extract<TemporaryStagingArtifactState, 'VERIFIED'>;
  readonly integrity: TemporaryStagingIntegrityEvidence;
  readonly duplicateDecision: BinaryDuplicateDecision;
}

export type TemporaryStagingArtifactLifecycleDescriptor =
  | TemporaryStagingArtifactDescriptor
  | VerifiedTemporaryStagingArtifactDescriptor;

export interface TemporaryStagingDiscardReceipt {
  readonly contractVersion: typeof STAGING_CONTRACT_VERSION;
  readonly state: Extract<TemporaryStagingArtifactState, 'DISCARDED'>;
  readonly artifactId: EntityId;
  readonly run: IngestionRunRef;
  readonly requestedAt: ISODateTime;
  readonly confirmedAt: ISODateTime;
  readonly outcome: StagingDiscardOutcome;
  readonly reasonCode: StagingDiscardReasonCode;
  readonly correlationId: EntityId;
}
