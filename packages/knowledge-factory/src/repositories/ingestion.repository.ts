import type {
  BeginIngestionStagingCommand,
  BeginIngestionVerificationCommand,
  CancelIngestionCommand,
  ConfirmIngestionVerifiedCommand,
  FailIngestionCommand,
  IngestionCommandReceipt,
  IngestionRecoverySnapshot,
  IngestionRunRef,
  IngestionStagingArtifactSnapshot,
  MarkIngestionStagedCommand,
  PrepareIngestionStagingArtifact,
  RequestIngestionCommand,
  TemporaryStagingArtifactDescriptor,
  TemporaryStagingDiscardReceipt,
  VerifiedTemporaryStagingArtifactDescriptor,
} from '@profeplan/types';
import type { TemporaryStagingDiscardCommand } from '../staging/staging.port.ts';

/**
 * C.2.4 command boundary. It materializes only the C.2.1 operations required
 * through VERIFIED plus technical failure/cancellation. Human review and the
 * C.2.5 handoff remain outside this port.
 */
export interface IngestionCommandRepository {
  requestIngestion(command: RequestIngestionCommand): Promise<IngestionCommandReceipt>;
  beginStaging(command: BeginIngestionStagingCommand): Promise<IngestionCommandReceipt>;
  markStaged(
    command: MarkIngestionStagedCommand,
    artifact: TemporaryStagingArtifactDescriptor
  ): Promise<IngestionCommandReceipt>;
  beginVerification(command: BeginIngestionVerificationCommand): Promise<IngestionCommandReceipt>;
  confirmVerified(
    command: ConfirmIngestionVerifiedCommand,
    artifact: VerifiedTemporaryStagingArtifactDescriptor
  ): Promise<IngestionCommandReceipt>;
  failIngestion(command: FailIngestionCommand): Promise<IngestionCommandReceipt>;
  cancelIngestion(command: CancelIngestionCommand): Promise<IngestionCommandReceipt>;
}

/**
 * Durable recovery/control-plane boundary. Physical bytes remain owned by the
 * staging provider; this repository persists only the facts required to resume
 * or clean up safely.
 */
export interface IngestionRecoveryRepository {
  prepareStagingArtifact(
    input: PrepareIngestionStagingArtifact
  ): Promise<IngestionStagingArtifactSnapshot>;
  prepareDiscard(input: TemporaryStagingDiscardCommand): Promise<IngestionStagingArtifactSnapshot>;
  confirmDiscard(input: TemporaryStagingDiscardReceipt): Promise<IngestionStagingArtifactSnapshot>;
  getRecoverySnapshot(run: IngestionRunRef): Promise<IngestionRecoverySnapshot>;
}

export interface IngestionRepository
  extends IngestionCommandRepository, IngestionRecoveryRepository {}
