import type {
  CreateProductionOrderCommand,
  EntityId,
  OppEvent,
  PedagogicalProductionOrder,
  ProductionOrderWriteReceipt,
  TransitionProductionOrderCommand,
} from '@profeplan/types';

export interface ProductionOrderReadRepository {
  findById(id: EntityId): Promise<PedagogicalProductionOrder | null>;
  listEvents(oppId: EntityId): Promise<readonly OppEvent[]>;
}

export interface ProductionOrderRequestRepository {
  createProductionOrder(
    command: CreateProductionOrderCommand
  ): Promise<ProductionOrderWriteReceipt>;
}

export interface ProductionOrderTransitionRepository {
  transitionProductionOrder(
    command: TransitionProductionOrderCommand
  ): Promise<ProductionOrderWriteReceipt>;
}

export interface ProductionOrderRepository
  extends
    ProductionOrderReadRepository,
    ProductionOrderRequestRepository,
    ProductionOrderTransitionRepository {}
