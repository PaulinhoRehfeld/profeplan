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
const ISO_DATE_TIME_PATTERN =
  /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|([+-])(\d{2}):(\d{2}))$/;

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
  return (
    typeof value === 'string' ||
    (typeof value === 'number' && Number.isFinite(value)) ||
    typeof value === 'boolean'
  );
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
  if (typeof value !== 'string') {
    return false;
  }

  const match = ISO_DATE_TIME_PATTERN.exec(value);
  if (match === null) {
    return false;
  }

  const year = Number(match[1]);
  const month = Number(match[2]);
  const day = Number(match[3]);
  const hour = Number(match[4]);
  const minute = Number(match[5]);
  const second = Number(match[6]);
  const offsetHour = match[8] === undefined ? 0 : Number(match[8]);
  const offsetMinute = match[9] === undefined ? 0 : Number(match[9]);
  const leapYear = year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0);
  const daysInMonth = [31, leapYear ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  return (
    month >= 1 &&
    month <= 12 &&
    day >= 1 &&
    day <= daysInMonth[month - 1] &&
    hour <= 23 &&
    minute <= 59 &&
    second <= 59 &&
    offsetHour <= 14 &&
    offsetMinute <= 59 &&
    (offsetHour < 14 || offsetMinute === 0) &&
    Number.isFinite(Date.parse(value))
  );
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
