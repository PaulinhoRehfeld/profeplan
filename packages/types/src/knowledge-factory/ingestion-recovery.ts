import type { EntityId, ISODateTime, VersionTag } from './common.ts';
import type {
  BinaryDigest,
  BinaryDuplicateDecision,
  TemporaryStagingIntegrityEvidence,
} from './integrity.ts';
import type {
  IngestionCommandReceipt,
  IngestionReceivedFileRef,
  IngestionRunRef,
  IngestionRunState,
  IngestionSourceVersionRef,
  TemporaryStagingArtifactRef,
} from './ingestion.ts';
import type {
  StagingDiscardOutcome,
  StagingDiscardReasonCode,
  TemporaryStagingArtifactState,
} from './staging.ts';

export const INGESTION_RECOVERY_CONTRACT_VERSION = '1.0.0' as const;

export type DurableStagingArtifactState = Extract<
  TemporaryStagingArtifactState,
  'RECEIVING' | 'STAGED' | 'VERIFIED' | 'DISCARD_PENDING' | 'DISCARDED' | 'FAILED' | 'QUARANTINED'
>;

export interface IngestionRunSnapshot {
  readonly contractVersion: typeof INGESTION_RECOVERY_CONTRACT_VERSION;
  readonly requestId: EntityId;
  readonly run: IngestionRunRef;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly receivedFile: IngestionReceivedFileRef;
  readonly state: IngestionRunState;
  readonly aggregateVersion: VersionTag;
  readonly sequence: number;
  readonly requestedAt: ISODateTime;
  readonly createdAt: ISODateTime;
  readonly updatedAt: ISODateTime;
}

export interface IngestionStagingDiscardSnapshot {
  readonly requestedAt: ISODateTime;
  readonly confirmedAt?: ISODateTime;
  readonly reasonCode: StagingDiscardReasonCode;
  readonly outcome?: StagingDiscardOutcome;
  readonly correlationId: EntityId;
}

export interface IngestionStagingArtifactSnapshot {
  readonly contractVersion: typeof INGESTION_RECOVERY_CONTRACT_VERSION;
  readonly artifactId: EntityId;
  readonly run: IngestionRunRef;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly receivedFile: IngestionReceivedFileRef;
  readonly state: DurableStagingArtifactState;
  readonly sizeBytes: number;
  readonly mediaType: string;
  readonly createdAt: ISODateTime;
  readonly expiresAt: ISODateTime;
  readonly opaqueLocator?: string;
  /**
   * Digest of the bytes that the caller intended to write. This is recovery
   * metadata only; C.2.3 readback evidence remains the integrity authority.
   */
  readonly writeIntentDigest: BinaryDigest;
  readonly correlationId: EntityId;
  readonly discard?: IngestionStagingDiscardSnapshot;
}

export interface PersistedIngestionIntegrityEvidence {
  readonly evidence: TemporaryStagingIntegrityEvidence;
  readonly duplicateDecision: BinaryDuplicateDecision;
}

export interface IngestionRecoverySnapshot {
  readonly contractVersion: typeof INGESTION_RECOVERY_CONTRACT_VERSION;
  readonly run: IngestionRunSnapshot;
  readonly artifacts: readonly IngestionStagingArtifactSnapshot[];
  readonly integrityEvidence: readonly PersistedIngestionIntegrityEvidence[];
  readonly latestReceipt?: IngestionCommandReceipt;
}

export interface PrepareIngestionStagingArtifact {
  readonly artifactId: EntityId;
  readonly run: IngestionRunRef;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly receivedFile: IngestionReceivedFileRef;
  readonly sizeBytes: number;
  readonly mediaType: string;
  readonly createdAt: ISODateTime;
  readonly expiresAt: ISODateTime;
  readonly writeIntentDigest: BinaryDigest;
  readonly correlationId: EntityId;
}

export const STAGING_RECOVERY_PROBE_OUTCOMES = ['absent', 'present'] as const;
export type StagingRecoveryProbeOutcome = (typeof STAGING_RECOVERY_PROBE_OUTCOMES)[number];

export interface AbsentTemporaryStagingRecoveryProbe {
  readonly outcome: 'absent';
  readonly artifactId: EntityId;
  readonly run: IngestionRunRef;
  readonly observedAt: ISODateTime;
}

export interface PresentTemporaryStagingRecoveryProbe {
  readonly outcome: 'present';
  readonly artifact: TemporaryStagingArtifactRef;
  readonly run: IngestionRunRef;
  readonly observedDigest: BinaryDigest;
  readonly observedSizeBytes: number;
  readonly observedAt: ISODateTime;
}

export type TemporaryStagingRecoveryProbe =
  | AbsentTemporaryStagingRecoveryProbe
  | PresentTemporaryStagingRecoveryProbe;

export type StagingRecoveryAction =
  | { readonly outcome: 'retry_upload' }
  | {
      readonly outcome: 'reuse_existing';
      readonly artifact: TemporaryStagingArtifactRef;
      readonly observedDigest: BinaryDigest;
      readonly observedSizeBytes: number;
    };
