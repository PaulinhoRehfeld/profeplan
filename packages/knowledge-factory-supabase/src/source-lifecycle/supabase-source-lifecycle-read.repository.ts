import type { SourceLifecycleReadRepository } from '@profeplan/knowledge-factory';
import type {
  EntityId,
  ISODateTime,
  SourceAuthorizationEvent,
  SourceImpactEvent,
  SourcePurpose,
  SourceRegistrationEvent,
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
  authorizationHistoryRowsToEvents,
  impactHistoryRowsToEvents,
  registrationHistoryRowsToEvents,
} from './source-lifecycle.mapper.ts';

const ADAPTER_NAME = 'SupabaseSourceLifecycleReadRepository';

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
  aggregateId: EntityId,
  rowCount: number
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'success',
    aggregateType: 'source_lifecycle',
    aggregateId,
    correlationId: context.correlationId,
    rowCount,
  });
}

function recordFailure(
  logger: PersistenceLogger,
  context: SupabaseSystemContext,
  operation: string,
  startedAt: number,
  aggregateId: EntityId,
  error: KnowledgeFactoryPersistenceError
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'failure',
    aggregateType: 'source_lifecycle',
    aggregateId,
    correlationId: context.correlationId,
    errorCode: error.code,
  });
}

export class SupabaseSourceLifecycleReadRepository implements SourceLifecycleReadRepository {
  private readonly context: SupabaseSystemContext;
  private readonly logger: PersistenceLogger;

  constructor(context: SupabaseSystemContext, logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER) {
    this.context = context;
    this.logger = logger;
  }

  async listRegistrationHistory(
    subjectIdentityId: EntityId,
    asOf?: ISODateTime
  ): Promise<readonly SourceRegistrationEvent[]> {
    const operation = 'sourceLifecycle.listRegistrationHistory';
    const startedAt = Date.now();

    try {
      const rawResponse = await (this.context.client as unknown as RpcClient).rpc(
        'kf_source_list_registration_history',
        { p_subject_identity_id: subjectIdentityId, p_as_of: asOf ?? null }
      );
      const response = parseProviderResponse(rawResponse, operation);
      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      const events = registrationHistoryRowsToEvents(response.data, operation);
      recordSuccess(this.logger, this.context, operation, startedAt, subjectIdentityId, events.length);
      return events;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, this.context, operation, startedAt, subjectIdentityId, persistenceError);
      throw persistenceError;
    }
  }

  async listAuthorizationHistory(
    subjectIdentityId: EntityId,
    purpose?: SourcePurpose,
    asOf?: ISODateTime
  ): Promise<readonly SourceAuthorizationEvent[]> {
    const operation = 'sourceLifecycle.listAuthorizationHistory';
    const startedAt = Date.now();

    try {
      const rawResponse = await (this.context.client as unknown as RpcClient).rpc(
        'kf_source_list_authorization_history',
        {
          p_subject_identity_id: subjectIdentityId,
          p_purpose: purpose ?? null,
          p_as_of: asOf ?? null,
        }
      );
      const response = parseProviderResponse(rawResponse, operation);
      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      const events = authorizationHistoryRowsToEvents(response.data, operation);
      recordSuccess(this.logger, this.context, operation, startedAt, subjectIdentityId, events.length);
      return events;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, this.context, operation, startedAt, subjectIdentityId, persistenceError);
      throw persistenceError;
    }
  }

  async listImpactHistory(
    subjectIdentityId: EntityId,
    asOf?: ISODateTime
  ): Promise<readonly SourceImpactEvent[]> {
    const operation = 'sourceLifecycle.listImpactHistory';
    const startedAt = Date.now();

    try {
      const rawResponse = await (this.context.client as unknown as RpcClient).rpc(
        'kf_source_list_impact_history',
        { p_subject_identity_id: subjectIdentityId, p_as_of: asOf ?? null }
      );
      const response = parseProviderResponse(rawResponse, operation);
      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      const events = impactHistoryRowsToEvents(response.data, operation);
      recordSuccess(this.logger, this.context, operation, startedAt, subjectIdentityId, events.length);
      return events;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, this.context, operation, startedAt, subjectIdentityId, persistenceError);
      throw persistenceError;
    }
  }
}
