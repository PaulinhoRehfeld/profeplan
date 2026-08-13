import type { ProductionOrderReadRepository } from '@profeplan/knowledge-factory';
import type { EntityId, OppEvent, PedagogicalProductionOrder } from '@profeplan/types';
import type { SupabaseRequesterContext } from '../context/supabase-requester-context.ts';
import {
  KnowledgeFactoryPersistenceError,
  invalidPersistenceResponse,
  toPersistenceError,
  type KnowledgeFactoryPersistenceError as PersistenceError,
} from '../errors/persistence-error.ts';
import {
  NOOP_PERSISTENCE_LOGGER,
  recordPersistenceLog,
  type PersistenceLogger,
} from '../observability/persistence-logger.ts';
import {
  PRODUCTION_ORDER_COLUMNS,
  PRODUCTION_ORDER_EVENT_COLUMNS,
  productionOrderEventRowToOppEvent,
  productionOrderRowToProductionOrder,
} from './production-order.mapper.ts';

const ADAPTER_NAME = 'SupabaseProductionOrderReadRepository';
const PRODUCTION_ORDER_TABLE = 'kf_production_orders';
const PRODUCTION_ORDER_EVENT_TABLE = 'kf_production_order_events';

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

function isMultipleRowsResponse(error: unknown): boolean {
  return (
    typeof error === 'object' && error !== null && 'code' in error && error.code === 'PGRST116'
  );
}

function throwProviderError(error: unknown, operation: string): never {
  if (isMultipleRowsResponse(error)) {
    throw invalidPersistenceResponse(operation);
  }
  throw toPersistenceError(error, operation);
}

function assertRequesterIdentity(context: SupabaseRequesterContext, operation: string): void {
  if (typeof context.requesterId !== 'string' || context.requesterId.trim().length === 0) {
    throw new KnowledgeFactoryPersistenceError('UNAUTHORIZED', operation);
  }
}

function recordSuccess(
  logger: PersistenceLogger,
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
    aggregateType: 'production_order',
    aggregateId,
    rowCount,
  });
}

function recordFailure(
  logger: PersistenceLogger,
  operation: string,
  startedAt: number,
  aggregateId: EntityId,
  error: PersistenceError
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'failure',
    aggregateType: 'production_order',
    aggregateId,
    errorCode: error.code,
  });
}

export class SupabaseProductionOrderReadRepository implements ProductionOrderReadRepository {
  private readonly context: SupabaseRequesterContext;
  private readonly logger: PersistenceLogger;

  constructor(
    context: SupabaseRequesterContext,
    logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER
  ) {
    this.context = context;
    this.logger = logger;
  }

  async findById(id: EntityId): Promise<PedagogicalProductionOrder | null> {
    const operation = 'productionOrder.findById';
    const startedAt = Date.now();

    try {
      assertRequesterIdentity(this.context, operation);
      const rawResponse: unknown = await this.context.client
        .from(PRODUCTION_ORDER_TABLE)
        .select(PRODUCTION_ORDER_COLUMNS)
        .eq('id', id)
        .maybeSingle();
      const response = parseProviderResponse(rawResponse, operation);
      if (response.error !== null) {
        throwProviderError(response.error, operation);
      }

      const order =
        response.data === null
          ? null
          : productionOrderRowToProductionOrder(response.data, this.context.requesterId, operation);
      recordSuccess(this.logger, operation, startedAt, id, order === null ? 0 : 1);
      return order;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, operation, startedAt, id, persistenceError);
      throw persistenceError;
    }
  }

  async listEvents(oppId: EntityId): Promise<readonly OppEvent[]> {
    const operation = 'productionOrder.listEvents';
    const startedAt = Date.now();

    try {
      assertRequesterIdentity(this.context, operation);
      const rawResponse: unknown = await this.context.client
        .from(PRODUCTION_ORDER_EVENT_TABLE)
        .select(PRODUCTION_ORDER_EVENT_COLUMNS)
        .eq('opp_id', oppId)
        .order('occurred_at', { ascending: true })
        .order('id', { ascending: true });
      const response = parseProviderResponse(rawResponse, operation);
      if (response.error !== null) {
        throwProviderError(response.error, operation);
      }
      if (!Array.isArray(response.data)) {
        throw invalidPersistenceResponse(operation);
      }

      const events = response.data.map((row) =>
        productionOrderEventRowToOppEvent(row, oppId, operation)
      );
      recordSuccess(this.logger, operation, startedAt, oppId, events.length);
      return events;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, operation, startedAt, oppId, persistenceError);
      throw persistenceError;
    }
  }
}
