import type { PedagogicalComponentCommandRepository } from '@profeplan/knowledge-factory';
import type {
  AppendPedagogicalComponentVersionCommand,
  CreatePedagogicalComponentAggregateCommand,
  EntityId,
  PedagogicalComponentWriteOperation,
  PedagogicalComponentWriteReceipt,
  PromotePedagogicalComponentVersionCommand,
  TransitionPedagogicalComponentVersionStatusCommand,
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
  componentCommandToRpcPayload,
  componentWriteReceiptRowToReceipt,
  type ComponentCommandExpectation,
  type ComponentCommandWithId,
} from './pedagogical-component-command.mapper.ts';

const ADAPTER_NAME = 'SupabasePedagogicalComponentCommandRepository';

interface ProviderResponse {
  readonly data: unknown;
  readonly error: unknown;
}

interface RpcClient {
  rpc(name: string, args: Readonly<Record<string, unknown>>): Promise<unknown>;
}

interface CommandSpecification {
  readonly rpcName: string;
  readonly operation: string;
  readonly receiptOperation: PedagogicalComponentWriteOperation;
  readonly componentId: EntityId;
  readonly componentVersionId: EntityId;
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
  aggregateId: EntityId
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'success',
    aggregateType: 'pedagogical_component',
    aggregateId,
    correlationId: context.correlationId,
    rowCount: 1,
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
    aggregateType: 'pedagogical_component',
    aggregateId,
    correlationId: context.correlationId,
    errorCode: error.code,
  });
}

export class SupabasePedagogicalComponentCommandRepository implements PedagogicalComponentCommandRepository {
  private readonly context: SupabaseSystemContext;
  private readonly logger: PersistenceLogger;

  constructor(context: SupabaseSystemContext, logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER) {
    this.context = context;
    this.logger = logger;
  }

  private async execute(
    command: ComponentCommandWithId,
    specification: CommandSpecification
  ): Promise<PedagogicalComponentWriteReceipt> {
    const startedAt = Date.now();

    try {
      const rawResponse = await (this.context.client as unknown as RpcClient).rpc(
        specification.rpcName,
        {
          p_command_id: command.commandId,
          p_payload: componentCommandToRpcPayload(command, specification.operation),
        }
      );
      const response = parseProviderResponse(rawResponse, specification.operation);
      if (response.error !== null) {
        throw toPersistenceError(response.error, specification.operation);
      }

      const expectation: ComponentCommandExpectation = {
        commandId: command.commandId,
        operation: specification.receiptOperation,
        componentId: specification.componentId,
        componentVersionId: specification.componentVersionId,
      };
      const receipt = componentWriteReceiptRowToReceipt(
        response.data,
        expectation,
        specification.operation
      );
      recordSuccess(
        this.logger,
        this.context,
        specification.operation,
        startedAt,
        specification.componentId
      );
      return receipt;
    } catch (error) {
      const persistenceError = toPersistenceError(error, specification.operation);
      recordFailure(
        this.logger,
        this.context,
        specification.operation,
        startedAt,
        specification.componentId,
        persistenceError
      );
      throw persistenceError;
    }
  }

  createComponentAggregate(
    command: CreatePedagogicalComponentAggregateCommand
  ): Promise<PedagogicalComponentWriteReceipt> {
    return this.execute(command, {
      rpcName: 'kf_create_pedagogical_component_aggregate',
      operation: 'component.createComponentAggregate',
      receiptOperation: 'create_component_aggregate',
      componentId: command.component.id,
      componentVersionId: command.initialVersion.id,
    });
  }

  appendComponentVersion(
    command: AppendPedagogicalComponentVersionCommand
  ): Promise<PedagogicalComponentWriteReceipt> {
    return this.execute(command, {
      rpcName: 'kf_append_pedagogical_component_version',
      operation: 'component.appendComponentVersion',
      receiptOperation: 'append_component_version',
      componentId: command.version.componentId,
      componentVersionId: command.version.id,
    });
  }

  transitionComponentVersionStatus(
    command: TransitionPedagogicalComponentVersionStatusCommand
  ): Promise<PedagogicalComponentWriteReceipt> {
    return this.execute(command, {
      rpcName: 'kf_transition_pedagogical_component_version_status',
      operation: 'component.transitionComponentVersionStatus',
      receiptOperation: 'transition_component_version_status',
      componentId: command.componentId,
      componentVersionId: command.componentVersionId,
    });
  }

  promoteComponentVersion(
    command: PromotePedagogicalComponentVersionCommand
  ): Promise<PedagogicalComponentWriteReceipt> {
    return this.execute(command, {
      rpcName: 'kf_promote_pedagogical_component_version',
      operation: 'component.promoteComponentVersion',
      receiptOperation: 'promote_component_version',
      componentId: command.componentId,
      componentVersionId: command.targetVersionId,
    });
  }
}
