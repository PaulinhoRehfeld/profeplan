import type {
  EntityId,
  OppEvent,
  PedagogicalProductionOrder,
} from '@profeplan/types';

export interface ProductionOrderRepository {
  findById(id: EntityId): Promise<PedagogicalProductionOrder | null>;
  save(order: PedagogicalProductionOrder): Promise<void>;
  appendEvent(event: OppEvent): Promise<void>;
  listEvents(oppId: EntityId): Promise<readonly OppEvent[]>;
}
