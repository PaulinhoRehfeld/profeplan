import type { ProductionOrderRequestRepository } from '@profeplan/knowledge-factory';
import type {
  CreateProductionOrderCommand,
  EntityId,
  ProductionOrderWriteReceipt,
} from '@profeplan/types';
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
  createProductionOrderCommandToRpcPayload,
  productionOrderWriteReceiptRowToReceipt,
} from './production-order-command.mapper.ts';

const ADAPTER_NAME = 'SupabaseProductionOrderRequestRepository';
const RPC_NAME = 'kf_create_production_order';
const OPERATION = 'productionOrder.createProductionOrder';

interface ProviderResponse {
  readonly data: unknown;
  readonly error: unknown;
}

interface RpcClient {
  rpc(name: string, args: Readonly<Record<string, unknown>>): Promise<unknown>;
}

function parseProviderResponse(value: unknown): ProviderResponse {
  if (typeof value !== 'object' || value === null || !('data' in value) || !('error' in value)) {
    throw invalidPersistenceResponse(OPERATION);
  }
  return { data: value.data, error: value.error };
}

function assertRequesterIdentity(context: SupabaseRequesterContext): void {
  if (typeof context.requesterId !== 'string' || context.requesterId.trim().length === 0) {
    throw new KnowledgeFactoryPersistenceError('UNAUTHORIZED', OPERATION);
  }
}

function recordSuccess(logger: PersistenceLogger, startedAt: number, aggregateId: EntityId): void {
  recordPersistenceLog(logger, {
    operation: OPERATION,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'success',
    aggregateType: 'production_order',
    aggregateId,
    rowCount: 1,
  });
}

function recordFailure(
  logger: PersistenceLogger,
  startedAt: number,
  aggregateId: EntityId,
  error: PersistenceError
): void {
  recordPersistenceLog(logger, {
    operation: OPERATION,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'failure',
    aggregateType: 'production_order',
    aggregateId,
    errorCode: error.code,
  });
}

export class SupabaseProductionOrderRequestRepository implements ProductionOrderRequestRepository {
  private readonly context: SupabaseRequesterContext;
  private readonly logger: PersistenceLogger;

  constructor(
    context: SupabaseRequesterContext,
    logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER
  ) {
    this.context = context;
    this.logger = logger;
  }

  async createProductionOrder(
    command: CreateProductionOrderCommand
  ): Promise<ProductionOrderWriteReceipt> {
    const startedAt = Date.now();
    const aggregateId = command.order.id;

    try {
      assertRequesterIdentity(this.context);
      const rawResponse = await (this.context.client as unknown as RpcClient).rpc(RPC_NAME, {
        p_command_id: command.commandId,
        p_payload: createProductionOrderCommandToRpcPayload(command, OPERATION),
      });
      const response = parseProviderResponse(rawResponse);
      if (response.error !== null) {
        throw toPersistenceError(response.error, OPERATION);
      }

      const receipt = productionOrderWriteReceiptRowToReceipt(
        response.data,
        {
          commandId: command.commandId,
          operation: 'create_production_order',
          oppId: command.order.id,
          eventId: command.eventId,
          status: 'requested',
        },
        OPERATION
      );
      recordSuccess(this.logger, startedAt, aggregateId);
      return receipt;
    } catch (error) {
      const persistenceError = toPersistenceError(error, OPERATION);
      recordFailure(this.logger, startedAt, aggregateId, persistenceError);
      throw persistenceError;
    }
  }
}
