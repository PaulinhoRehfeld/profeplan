import type { ProductionOrderTransitionRepository } from '@profeplan/knowledge-factory';
import type {
  EntityId,
  ProductionOrderWriteReceipt,
  TransitionProductionOrderCommand,
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
  productionOrderWriteReceiptRowToReceipt,
  transitionProductionOrderCommandToRpcPayload,
} from './production-order-command.mapper.ts';

const ADAPTER_NAME = 'SupabaseProductionOrderTransitionRepository';
const RPC_NAME = 'kf_transition_production_order';
const OPERATION = 'productionOrder.transitionProductionOrder';

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

function recordSuccess(
  logger: PersistenceLogger,
  context: SupabaseSystemContext,
  startedAt: number,
  aggregateId: EntityId
): void {
  recordPersistenceLog(logger, {
    operation: OPERATION,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'success',
    aggregateType: 'production_order',
    aggregateId,
    correlationId: context.correlationId,
    rowCount: 1,
  });
}

function recordFailure(
  logger: PersistenceLogger,
  context: SupabaseSystemContext,
  startedAt: number,
  aggregateId: EntityId,
  error: KnowledgeFactoryPersistenceError
): void {
  recordPersistenceLog(logger, {
    operation: OPERATION,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'failure',
    aggregateType: 'production_order',
    aggregateId,
    correlationId: context.correlationId,
    errorCode: error.code,
  });
}

export class SupabaseProductionOrderTransitionRepository implements ProductionOrderTransitionRepository {
  private readonly context: SupabaseSystemContext;
  private readonly logger: PersistenceLogger;

  constructor(context: SupabaseSystemContext, logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER) {
    this.context = context;
    this.logger = logger;
  }

  async transitionProductionOrder(
    command: TransitionProductionOrderCommand
  ): Promise<ProductionOrderWriteReceipt> {
    const startedAt = Date.now();

    try {
      const rawResponse = await (this.context.client as unknown as RpcClient).rpc(RPC_NAME, {
        p_command_id: command.commandId,
        p_payload: transitionProductionOrderCommandToRpcPayload(command, OPERATION),
      });
      const response = parseProviderResponse(rawResponse);
      if (response.error !== null) {
        throw toPersistenceError(response.error, OPERATION);
      }

      const receipt = productionOrderWriteReceiptRowToReceipt(
        response.data,
        {
          commandId: command.commandId,
          operation: 'transition_production_order',
          oppId: command.oppId,
          eventId: command.eventId,
          status: command.toStatus,
        },
        OPERATION
      );
      recordSuccess(this.logger, this.context, startedAt, command.oppId);
      return receipt;
    } catch (error) {
      const persistenceError = toPersistenceError(error, OPERATION);
      recordFailure(this.logger, this.context, startedAt, command.oppId, persistenceError);
      throw persistenceError;
    }
  }
}
