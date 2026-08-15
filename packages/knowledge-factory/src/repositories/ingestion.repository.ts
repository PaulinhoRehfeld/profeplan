import type {
  ApproveIngestionForExtractionCommand,
  BeginIngestionStagingCommand,
  BeginIngestionVerificationCommand,
  CancelIngestionCommand,
  ConfirmIngestionVerifiedCommand,
  FailIngestionCommand,
  IngestionCommandReceipt,
  IngestionHandoffEvidence,
  IngestionRecoverySnapshot,
  IngestionRunRef,
  IngestionStagingArtifactSnapshot,
  MarkIngestionStagedCommand,
  PrepareIngestionStagingArtifact,
  RejectIngestionCommand,
  RequestIngestionCommand,
  RequestIngestionReviewCommand,
  TemporaryStagingArtifactDescriptor,
  TemporaryStagingDiscardReceipt,
  VerifiedTemporaryStagingArtifactDescriptor,
} from '@profeplan/types';
import type { TemporaryStagingDiscardCommand } from '../staging/staging.port.ts';

/**
 * Governed C.2 command boundary. C.2.4 owns durable idempotency/recovery;
 * C.2.5 adds only the already-contracted review transitions through the
 * terminal APPROVED_FOR_EXTRACTION/REJECTED states. No method starts C.3.
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
  requestReview(command: RequestIngestionReviewCommand): Promise<IngestionCommandReceipt>;
  approveForExtraction(
    command: ApproveIngestionForExtractionCommand
  ): Promise<IngestionCommandReceipt>;
  rejectAfterHumanReview(command: RejectIngestionCommand): Promise<IngestionCommandReceipt>;
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

/**
 * Read-only C.2.5 handoff boundary. The returned evidence proves what was
 * approved at the human decision instant; a future C.3 executor must re-check
 * its own extraction authorization before performing any extraction.
 */
export interface IngestionHandoffRepository {
  getHandoffEvidence(run: IngestionRunRef): Promise<IngestionHandoffEvidence>;
}

export interface IngestionRepository
  extends IngestionCommandRepository, IngestionRecoveryRepository, IngestionHandoffRepository {}
