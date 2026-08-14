import type { EntityId } from '@profeplan/types';
import type { DomainEvent } from '../domain/events.ts';

export interface AuditRepository {
  append(event: DomainEvent): Promise<void>;
  listByAggregate(aggregateId: EntityId): Promise<readonly DomainEvent[]>;
}
