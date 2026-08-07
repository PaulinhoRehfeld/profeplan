import type { EntityId, ISODateTime } from '@profeplan/types';
import type { DomainMetadataValue } from './reasons.ts';

export const DOMAIN_EVENT_TYPES = [
  'source_authorized',
  'source_blocked',
  'component_transition_accepted',
  'component_transition_rejected',
  'component_eligibility_accepted',
  'component_eligibility_rejected',
  'curriculum_scope_accepted',
  'curriculum_scope_rejected',
  'agent_scope_accepted',
  'agent_scope_rejected',
  'opp_transition_accepted',
  'opp_transition_rejected',
] as const;

export type DomainEventType = (typeof DOMAIN_EVENT_TYPES)[number];

export interface DomainEvent {
  eventType: DomainEventType;
  aggregateType: 'source' | 'component' | 'curriculum' | 'agent' | 'opp';
  aggregateId: EntityId;
  occurredAt: ISODateTime;
  metadata: Readonly<Record<string, DomainMetadataValue>>;
}

export function domainEvent(
  eventType: DomainEventType,
  aggregateType: DomainEvent['aggregateType'],
  aggregateId: EntityId,
  occurredAt: ISODateTime,
  metadata: Readonly<Record<string, DomainMetadataValue>> = {}
): DomainEvent {
  return { eventType, aggregateType, aggregateId, occurredAt, metadata };
}
