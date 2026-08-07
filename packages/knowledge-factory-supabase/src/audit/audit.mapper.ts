import {
  DOMAIN_EVENT_TYPES,
  type DomainEvent,
  type DomainEventType,
  type DomainMetadataValue,
} from '@profeplan/knowledge-factory';
import { invalidPersistenceResponse } from '../errors/persistence-error.ts';

export const AUDIT_EVENT_COLUMNS =
  'event_type,aggregate_type,aggregate_id,occurred_at,metadata' as const;

export interface AuditEventRow {
  readonly event_type: string;
  readonly aggregate_type: string;
  readonly aggregate_id: string;
  readonly occurred_at: string;
  readonly metadata: Readonly<Record<string, DomainMetadataValue>>;
}

const AGGREGATE_TYPES = ['source', 'component', 'curriculum', 'agent', 'opp'] as const;

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function isEventType(value: unknown): value is DomainEventType {
  return typeof value === 'string' && DOMAIN_EVENT_TYPES.some((eventType) => eventType === value);
}

function isAggregateType(value: unknown): value is DomainEvent['aggregateType'] {
  return (
    typeof value === 'string' && AGGREGATE_TYPES.some((aggregateType) => aggregateType === value)
  );
}

function isMetadataValue(value: unknown): value is DomainMetadataValue {
  return typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean';
}

function parseMetadata(
  value: unknown,
  operation: string
): Readonly<Record<string, DomainMetadataValue>> {
  if (!isRecord(value)) {
    throw invalidPersistenceResponse(operation);
  }

  const metadata: Record<string, DomainMetadataValue> = {};
  for (const [key, item] of Object.entries(value)) {
    if (!isMetadataValue(item)) {
      throw invalidPersistenceResponse(operation);
    }
    metadata[key] = item;
  }
  return metadata;
}

function isDateTime(value: unknown): value is string {
  return typeof value === 'string' && value.length > 0 && Number.isFinite(Date.parse(value));
}

export function domainEventToAuditRow(
  event: DomainEvent,
  operation = 'audit.mapper.toRow'
): AuditEventRow {
  if (
    !isEventType(event.eventType) ||
    !isAggregateType(event.aggregateType) ||
    typeof event.aggregateId !== 'string' ||
    event.aggregateId.length === 0 ||
    !isDateTime(event.occurredAt)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  return {
    event_type: event.eventType,
    aggregate_type: event.aggregateType,
    aggregate_id: event.aggregateId,
    occurred_at: event.occurredAt,
    metadata: parseMetadata(event.metadata, operation),
  };
}

export function auditRowToDomainEvent(
  row: unknown,
  operation = 'audit.mapper.fromRow'
): DomainEvent {
  if (!isRecord(row)) {
    throw invalidPersistenceResponse(operation);
  }

  if (
    !isEventType(row.event_type) ||
    !isAggregateType(row.aggregate_type) ||
    typeof row.aggregate_id !== 'string' ||
    row.aggregate_id.length === 0 ||
    !isDateTime(row.occurred_at)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  return {
    eventType: row.event_type,
    aggregateType: row.aggregate_type,
    aggregateId: row.aggregate_id,
    occurredAt: row.occurred_at,
    metadata: parseMetadata(row.metadata, operation),
  };
}
