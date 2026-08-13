import type { KnowledgeSourceRepository } from '@profeplan/knowledge-factory';
import type {
  EntityId,
  KnowledgeSource,
  SourcePermissionEvent,
  SourceVersion,
  VersionTag,
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
  KNOWLEDGE_SOURCE_COLUMNS,
  SOURCE_PERMISSION_EVENT_COLUMNS,
  SOURCE_VERSION_COLUMNS,
  knowledgeSourceToRow,
  sourcePermissionEventRowToSourcePermissionEvent,
  sourceRowToKnowledgeSource,
  sourceVersionRowToSourceVersion,
} from './source.mapper.ts';

const ADAPTER_NAME = 'SupabaseKnowledgeSourceRepository';
const SOURCE_TABLE = 'kf_sources';
const SOURCE_VERSION_TABLE = 'kf_source_versions';
const SOURCE_PERMISSION_EVENT_TABLE = 'kf_source_permission_events';

interface ProviderResponse {
  readonly data: unknown;
  readonly error: unknown;
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
  sourceId: EntityId,
  rowCount: number
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'success',
    aggregateType: 'source',
    aggregateId: sourceId,
    correlationId: context.correlationId,
    rowCount,
  });
}

function recordFailure(
  logger: PersistenceLogger,
  context: SupabaseSystemContext,
  operation: string,
  startedAt: number,
  sourceId: EntityId,
  error: KnowledgeFactoryPersistenceError
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'failure',
    aggregateType: 'source',
    aggregateId: sourceId,
    correlationId: context.correlationId,
    errorCode: error.code,
  });
}

export class SupabaseKnowledgeSourceRepository implements KnowledgeSourceRepository {
  private readonly context: SupabaseSystemContext;
  private readonly logger: PersistenceLogger;

  constructor(context: SupabaseSystemContext, logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER) {
    this.context = context;
    this.logger = logger;
  }

  async findById(id: EntityId): Promise<KnowledgeSource | null> {
    const operation = 'source.findById';
    const startedAt = Date.now();

    try {
      const rawResponse: unknown = await this.context.client
        .from(SOURCE_TABLE)
        .select(KNOWLEDGE_SOURCE_COLUMNS)
        .eq('id', id)
        .maybeSingle();
      const response = parseProviderResponse(rawResponse, operation);

      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      const source =
        response.data === null ? null : sourceRowToKnowledgeSource(response.data, operation);
      recordSuccess(this.logger, this.context, operation, startedAt, id, source === null ? 0 : 1);
      return source;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, this.context, operation, startedAt, id, persistenceError);
      throw persistenceError;
    }
  }

  async findVersion(sourceId: EntityId, version: VersionTag): Promise<SourceVersion | null> {
    const operation = 'source.findVersion';
    const startedAt = Date.now();

    try {
      const rawResponse: unknown = await this.context.client
        .from(SOURCE_VERSION_TABLE)
        .select(SOURCE_VERSION_COLUMNS)
        .eq('source_id', sourceId)
        .eq('version', version)
        .maybeSingle();
      const response = parseProviderResponse(rawResponse, operation);

      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      const sourceVersion =
        response.data === null ? null : sourceVersionRowToSourceVersion(response.data, operation);
      recordSuccess(
        this.logger,
        this.context,
        operation,
        startedAt,
        sourceId,
        sourceVersion === null ? 0 : 1
      );
      return sourceVersion;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, this.context, operation, startedAt, sourceId, persistenceError);
      throw persistenceError;
    }
  }

  async listPermissionEvents(sourceId: EntityId): Promise<readonly SourcePermissionEvent[]> {
    const operation = 'source.listPermissionEvents';
    const startedAt = Date.now();

    try {
      const rawResponse: unknown = await this.context.client
        .from(SOURCE_PERMISSION_EVENT_TABLE)
        .select(SOURCE_PERMISSION_EVENT_COLUMNS)
        .eq('source_id', sourceId)
        .order('occurred_at', { ascending: true })
        .order('id', { ascending: true });
      const response = parseProviderResponse(rawResponse, operation);

      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      if (!Array.isArray(response.data)) {
        throw invalidPersistenceResponse(operation);
      }

      const events = response.data.map((row) =>
        sourcePermissionEventRowToSourcePermissionEvent(row, operation)
      );
      recordSuccess(this.logger, this.context, operation, startedAt, sourceId, events.length);
      return events;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, this.context, operation, startedAt, sourceId, persistenceError);
      throw persistenceError;
    }
  }

  async save(source: KnowledgeSource): Promise<void> {
    const operation = 'source.save';
    const startedAt = Date.now();

    try {
      const row = knowledgeSourceToRow(source, operation);
      const rawResponse: unknown = await this.context.client
        .from(SOURCE_TABLE)
        .upsert(row, { onConflict: 'id' })
        .select(KNOWLEDGE_SOURCE_COLUMNS)
        .single();
      const response = parseProviderResponse(rawResponse, operation);

      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      if (response.data === null) {
        throw invalidPersistenceResponse(operation);
      }

      sourceRowToKnowledgeSource(response.data, operation);
      recordSuccess(this.logger, this.context, operation, startedAt, source.id, 1);
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, this.context, operation, startedAt, source.id, persistenceError);
      throw persistenceError;
    }
  }
}
