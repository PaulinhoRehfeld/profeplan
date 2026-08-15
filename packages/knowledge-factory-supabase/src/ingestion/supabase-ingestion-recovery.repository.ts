import type { IngestionRecoveryRepository } from '@profeplan/knowledge-factory';
import type {
  IngestionRecoverySnapshot,
  IngestionRunRef,
  IngestionStagingArtifactSnapshot,
  PrepareIngestionStagingArtifact,
  TemporaryStagingDiscardCommand,
  TemporaryStagingDiscardReceipt,
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
  ingestionArtifactSnapshotFromData,
  ingestionRecoverySnapshotFromData,
} from './ingestion-recovery.mapper.ts';

const ADAPTER_NAME = 'SupabaseIngestionRecoveryRepository';

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
  context: SupabaseSystemContext,
  operation: string,
  startedAt: number,
  aggregateId: string
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'success',
    aggregateType: 'ingestion_recovery',
    aggregateId,
    correlationId: context.correlationId,
  });
}

function recordFailure(
  logger: PersistenceLogger,
  context: SupabaseSystemContext,
  operation: string,
  startedAt: number,
  aggregateId: string,
  error: KnowledgeFactoryPersistenceError
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'failure',
    aggregateType: 'ingestion_recovery',
    aggregateId,
    correlationId: context.correlationId,
    errorCode: error.code,
  });
}

export class SupabaseIngestionRecoveryRepository implements IngestionRecoveryRepository {
  private readonly context: SupabaseSystemContext;
  private readonly logger: PersistenceLogger;

  constructor(context: SupabaseSystemContext, logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER) {
    this.context = context;
    this.logger = logger;
  }

  private async executeArtifact(
    rpcName: string,
    args: Readonly<Record<string, unknown>>,
    operation: string,
    aggregateId: string
  ): Promise<IngestionStagingArtifactSnapshot> {
    const startedAt = Date.now();
    try {
      const rawResponse = await (this.context.client as unknown as RpcClient).rpc(rpcName, args);
      const response = parseProviderResponse(rawResponse, operation);
      if (response.error !== null) throw toPersistenceError(response.error, operation);
      const snapshot = ingestionArtifactSnapshotFromData(response.data, operation);
      recordSuccess(this.logger, this.context, operation, startedAt, aggregateId);
      return snapshot;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(
        this.logger,
        this.context,
        operation,
        startedAt,
        aggregateId,
        persistenceError
      );
      throw persistenceError;
    }
  }

  prepareStagingArtifact(
    input: PrepareIngestionStagingArtifact
  ): Promise<IngestionStagingArtifactSnapshot> {
    return this.executeArtifact(
      'kf_ingestion_prepare_staging_artifact',
      { p_payload: input },
      'ingestionRecovery.prepareStagingArtifact',
      input.artifactId
    );
  }

  prepareDiscard(input: TemporaryStagingDiscardCommand): Promise<IngestionStagingArtifactSnapshot> {
    return this.executeArtifact(
      'kf_ingestion_prepare_discard',
      { p_payload: input },
      'ingestionRecovery.prepareDiscard',
      input.artifact.artifactId
    );
  }

  confirmDiscard(input: TemporaryStagingDiscardReceipt): Promise<IngestionStagingArtifactSnapshot> {
    return this.executeArtifact(
      'kf_ingestion_confirm_discard',
      { p_receipt: input },
      'ingestionRecovery.confirmDiscard',
      input.artifactId
    );
  }

  async getRecoverySnapshot(run: IngestionRunRef): Promise<IngestionRecoverySnapshot> {
    const operation = 'ingestionRecovery.getRecoverySnapshot';
    const startedAt = Date.now();
    try {
      const rawResponse = await (this.context.client as unknown as RpcClient).rpc(
        'kf_ingestion_recovery_snapshot',
        { p_run_id: run.id }
      );
      const response = parseProviderResponse(rawResponse, operation);
      if (response.error !== null) throw toPersistenceError(response.error, operation);
      const snapshot = ingestionRecoverySnapshotFromData(response.data, operation);
      if (snapshot.run.run.id !== run.id) throw invalidPersistenceResponse(operation);
      recordSuccess(this.logger, this.context, operation, startedAt, run.id);
      return snapshot;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, this.context, operation, startedAt, run.id, persistenceError);
      throw persistenceError;
    }
  }
}
