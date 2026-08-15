import type { IngestionCommandRepository } from '@profeplan/knowledge-factory';
import type {
  ApproveIngestionForExtractionCommand,
  BeginIngestionStagingCommand,
  BeginIngestionVerificationCommand,
  CancelIngestionCommand,
  ConfirmIngestionVerifiedCommand,
  FailIngestionCommand,
  IngestionCommandReceipt,
  MarkIngestionStagedCommand,
  RejectIngestionCommand,
  RequestIngestionCommand,
  RequestIngestionReviewCommand,
  TemporaryStagingArtifactDescriptor,
  VerifiedTemporaryStagingArtifactDescriptor,
} from '@profeplan/types';
import type { SupabaseSystemContext } from '../context/supabase-system-context.ts';
import {
  invalidPersistenceResponse,
  toPersistenceError,
  type KnowledgeFactoryPersistenceError,
} from '../errors/persistence-error.ts';
import {
  NOOP_PERSISTENCE_LOGGER,
  recordPersistenceLog,
  type PersistenceLogger,
} from '../observability/persistence-logger.ts';
import {
  ingestionCommandRunId,
  ingestionCommandToRpcPayload,
  ingestionReceiptRowToReceipt,
  stagingArtifactToRpcPayload,
  verifiedArtifactToRpcPayload,
  type GovernedIngestionCommand,
} from './ingestion-command.mapper.ts';

const ADAPTER_NAME = 'SupabaseIngestionCommandRepository';

const RPC_NAMES = Object.freeze({
  request_ingestion: 'kf_ingestion_request',
  begin_staging: 'kf_ingestion_begin_staging',
  mark_staged: 'kf_ingestion_mark_staged',
  begin_verification: 'kf_ingestion_begin_verification',
  confirm_verified: 'kf_ingestion_confirm_verified',
  request_review: 'kf_ingestion_request_review',
  approve_for_extraction: 'kf_ingestion_approve_for_extraction',
  reject_ingestion: 'kf_ingestion_reject',
  fail_ingestion: 'kf_ingestion_fail',
  cancel_ingestion: 'kf_ingestion_cancel',
} as const);

interface ProviderResponse {
  readonly data: unknown;
  readonly error: unknown;
}

interface RpcClient {
  rpc(name: string, args: Readonly<Record<string, unknown>>): Promise<unknown>;
}

function parseProviderResponse(value: unknown, operation: string): ProviderResponse {
  if (typeof value !== 'object' || value === null || !('data' in value) || !('error' in value)) {
    throw invalidPersistenceResponse(operation);
  }
  return { data: value.data, error: value.error };
}

function recordSuccess(
  logger: PersistenceLogger,
  command: GovernedIngestionCommand,
  operation: string,
  startedAt: number
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'success',
    aggregateType: 'ingestion_run',
    aggregateId: ingestionCommandRunId(command),
    correlationId: command.correlationId,
  });
}

function recordFailure(
  logger: PersistenceLogger,
  command: GovernedIngestionCommand,
  operation: string,
  startedAt: number,
  error: KnowledgeFactoryPersistenceError
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'failure',
    aggregateType: 'ingestion_run',
    aggregateId: ingestionCommandRunId(command),
    correlationId: command.correlationId,
    errorCode: error.code,
  });
}

export class SupabaseIngestionCommandRepository implements IngestionCommandRepository {
  private readonly context: SupabaseSystemContext;
  private readonly logger: PersistenceLogger;

  constructor(context: SupabaseSystemContext, logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER) {
    this.context = context;
    this.logger = logger;
  }

  private async execute(
    command: GovernedIngestionCommand,
    extraArgs: Readonly<Record<string, unknown>> = {}
  ): Promise<IngestionCommandReceipt> {
    const operation = `ingestion.${command.commandType}`;
    const startedAt = Date.now();

    try {
      const rpcName = RPC_NAMES[command.commandType];
      const rawResponse = await (this.context.client as unknown as RpcClient).rpc(rpcName, {
        p_command_id: command.commandId,
        p_fingerprint: command.fingerprint,
        p_payload: ingestionCommandToRpcPayload(command, operation),
        ...extraArgs,
      });
      const response = parseProviderResponse(rawResponse, operation);
      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      const receipt = ingestionReceiptRowToReceipt(response.data, command, operation);
      recordSuccess(this.logger, command, operation, startedAt);
      return receipt;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, command, operation, startedAt, persistenceError);
      throw persistenceError;
    }
  }

  requestIngestion(command: RequestIngestionCommand): Promise<IngestionCommandReceipt> {
    return this.execute(command);
  }

  beginStaging(command: BeginIngestionStagingCommand): Promise<IngestionCommandReceipt> {
    return this.execute(command);
  }

  markStaged(
    command: MarkIngestionStagedCommand,
    artifact: TemporaryStagingArtifactDescriptor
  ): Promise<IngestionCommandReceipt> {
    return this.execute(command, { p_artifact: stagingArtifactToRpcPayload(artifact) });
  }

  beginVerification(command: BeginIngestionVerificationCommand): Promise<IngestionCommandReceipt> {
    return this.execute(command);
  }

  confirmVerified(
    command: ConfirmIngestionVerifiedCommand,
    artifact: VerifiedTemporaryStagingArtifactDescriptor
  ): Promise<IngestionCommandReceipt> {
    return this.execute(command, { p_verification: verifiedArtifactToRpcPayload(artifact) });
  }

  requestReview(command: RequestIngestionReviewCommand): Promise<IngestionCommandReceipt> {
    return this.execute(command);
  }

  approveForExtraction(
    command: ApproveIngestionForExtractionCommand
  ): Promise<IngestionCommandReceipt> {
    return this.execute(command);
  }

  rejectAfterHumanReview(command: RejectIngestionCommand): Promise<IngestionCommandReceipt> {
    return this.execute(command);
  }

  failIngestion(command: FailIngestionCommand): Promise<IngestionCommandReceipt> {
    return this.execute(command);
  }

  cancelIngestion(command: CancelIngestionCommand): Promise<IngestionCommandReceipt> {
    return this.execute(command);
  }
}
