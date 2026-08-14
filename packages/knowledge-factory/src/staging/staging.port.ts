import type {
  EntityId,
  IngestionReceivedFileRef,
  IngestionRunRef,
  IngestionSourceVersionRef,
  ISODateTime,
  StagingDiscardReasonCode,
  TemporaryStagingArtifactDescriptor,
  TemporaryStagingArtifactRef,
  TemporaryStagingDiscardReceipt,
} from '@profeplan/types';

export interface TemporaryStagingWrite {
  readonly artifactId: EntityId;
  readonly run: IngestionRunRef;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly receivedFile: IngestionReceivedFileRef;
  readonly bytes: Uint8Array;
  readonly mediaType: string;
  readonly createdAt: ISODateTime;
  readonly expiresAt: ISODateTime;
  readonly correlationId: EntityId;
}

export interface TemporaryStagingDiscardCommand {
  readonly artifact: TemporaryStagingArtifactRef;
  readonly run: IngestionRunRef;
  readonly requestedAt: ISODateTime;
  readonly reasonCode: StagingDiscardReasonCode;
  readonly correlationId: EntityId;
}

export interface TemporaryStagingPort {
  stage(input: TemporaryStagingWrite): Promise<TemporaryStagingArtifactDescriptor>;
  discard(input: TemporaryStagingDiscardCommand): Promise<TemporaryStagingDiscardReceipt>;
}
