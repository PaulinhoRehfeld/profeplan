import type { IngestionHandoffRepository } from '@profeplan/knowledge-factory';
import type { IngestionHandoffEvidence, IngestionRunRef } from '@profeplan/types';
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
import { ingestionHandoffEvidenceFromData } from './ingestion-handoff.mapper.ts';

const ADAPTER_NAME = 'SupabaseIngestionHandoffRepository';

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

function record(
  logger: PersistenceLogger,
  context: SupabaseSystemContext,
  operation: string,
  startedAt: number,
  runId: string,
  outcome: 'success' | 'failure',
  error?: KnowledgeFactoryPersistenceError
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome,
    aggregateType: 'ingestion_handoff',
    aggregateId: runId,
    correlationId: context.correlationId,
    ...(error === undefined ? {} : { errorCode: error.code }),
  });
}

export class SupabaseIngestionHandoffRepository implements IngestionHandoffRepository {
  private readonly context: SupabaseSystemContext;
  private readonly logger: PersistenceLogger;

  constructor(context: SupabaseSystemContext, logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER) {
    this.context = context;
    this.logger = logger;
  }

  async getHandoffEvidence(run: IngestionRunRef): Promise<IngestionHandoffEvidence> {
    const operation = 'ingestionHandoff.getHandoffEvidence';
    const startedAt = Date.now();
    try {
      const rawResponse = await (this.context.client as unknown as RpcClient).rpc(
        'kf_ingestion_handoff_snapshot',
        { p_run_id: run.id }
      );
      const response = parseProviderResponse(rawResponse, operation);
      if (response.error !== null) throw toPersistenceError(response.error, operation);
      const evidence = ingestionHandoffEvidenceFromData(response.data, operation);
      if (evidence.run.id !== run.id) throw invalidPersistenceResponse(operation);
      record(this.logger, this.context, operation, startedAt, run.id, 'success');
      return evidence;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      record(this.logger, this.context, operation, startedAt, run.id, 'failure', persistenceError);
      throw persistenceError;
    }
  }
}
