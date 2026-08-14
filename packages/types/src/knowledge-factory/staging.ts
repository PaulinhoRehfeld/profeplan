import type { EntityId, ISODateTime } from './common.ts';
import type {
  IngestionReceivedFileRef,
  IngestionRunRef,
  IngestionSourceVersionRef,
  TemporaryStagingArtifactRef,
} from './ingestion.ts';

export const STAGING_CONTRACT_VERSION = '1.0.0' as const;

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
  readonly artifact: TemporaryStagingArtifactRef;
  readonly run: IngestionRunRef;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly receivedFile: IngestionReceivedFileRef;
  readonly sizeBytes: number;
  readonly mediaType: string;
  readonly createdAt: ISODateTime;
  readonly expiresAt: ISODateTime;
}

export interface TemporaryStagingDiscardReceipt {
  readonly contractVersion: typeof STAGING_CONTRACT_VERSION;
  readonly artifactId: EntityId;
  readonly run: IngestionRunRef;
  readonly requestedAt: ISODateTime;
  readonly confirmedAt: ISODateTime;
  readonly outcome: StagingDiscardOutcome;
  readonly reasonCode: StagingDiscardReasonCode;
  readonly correlationId: EntityId;
}
