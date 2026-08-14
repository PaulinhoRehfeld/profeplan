import type {
  EntityId,
  OppEvent,
  OppEventType,
  OppStatus,
  PedagogicalProductionOrder,
  ProductType,
} from '@profeplan/types';
import {
  KnowledgeFactoryPersistenceError,
  invalidPersistenceResponse,
} from '../errors/persistence-error.ts';

export const PRODUCTION_ORDER_COLUMNS =
  'id,version,requester_id,agent_profile_id,curriculum_package_id,product_type,theme,duration_minutes,status,created_at,updated_at' as const;
export const PRODUCTION_ORDER_EVENT_COLUMNS =
  'id,version,opp_id,event_type,from_status,to_status,reason,occurred_at' as const;

const PRODUCT_TYPES = [
  'lesson_plan',
  'didactic_text',
  'reflective_activity',
  'formative_assessment',
] as const satisfies readonly ProductType[];
const OPP_STATUSES = [
  'requested',
  'scoped',
  'retrieving',
  'assembling',
  'validating',
  'ready',
  'insufficient',
  'blocked',
  'failed',
] as const satisfies readonly OppStatus[];
const OPP_EVENT_TYPES = [
  'created',
  'scope_resolved',
  'retrieval_started',
  'context_assembled',
  'validation_started',
  'approved',
  'insufficiency_detected',
  'blocked',
  'failed',
] as const satisfies readonly OppEventType[];

const ISO_DATE_TIME_PATTERN =
  /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|([+-])(\d{2}):(\d{2}))$/;

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function isNonEmptyString(value: unknown): value is string {
  return typeof value === 'string' && value.trim().length > 0;
}

function isOneOf<T extends string>(value: unknown, values: readonly T[]): value is T {
  return typeof value === 'string' && values.some((candidate) => candidate === value);
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

function parseOptionalDuration(value: unknown, operation: string): number | undefined {
  if (value === null || value === undefined) {
    return undefined;
  }
  if (!Number.isInteger(value) || (value as number) <= 0) {
    throw invalidPersistenceResponse(operation);
  }
  return value as number;
}

function parseOptionalStatus(value: unknown, operation: string): OppStatus | undefined {
  if (value === null || value === undefined) {
    return undefined;
  }
  if (!isOneOf(value, OPP_STATUSES)) {
    throw invalidPersistenceResponse(operation);
  }
  return value;
}

function parseOptionalReason(value: unknown, operation: string): string | undefined {
  if (value === null || value === undefined) {
    return undefined;
  }
  if (!isNonEmptyString(value)) {
    throw invalidPersistenceResponse(operation);
  }
  return value;
}

export function productionOrderRowToProductionOrder(
  row: unknown,
  expectedRequesterId: EntityId,
  operation = 'productionOrder.mapper.fromRow'
): PedagogicalProductionOrder {
  if (
    !isRecord(row) ||
    !isNonEmptyString(row.id) ||
    !isNonEmptyString(row.version) ||
    !isNonEmptyString(row.requester_id) ||
    !isNonEmptyString(row.agent_profile_id) ||
    !isNonEmptyString(row.curriculum_package_id) ||
    !isOneOf<ProductType>(row.product_type, PRODUCT_TYPES) ||
    !isNonEmptyString(row.theme) ||
    !isOneOf<OppStatus>(row.status, OPP_STATUSES) ||
    !isDateTime(row.created_at) ||
    !isDateTime(row.updated_at)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  if (row.requester_id !== expectedRequesterId) {
    throw new KnowledgeFactoryPersistenceError('FORBIDDEN', operation);
  }

  const durationMinutes = parseOptionalDuration(row.duration_minutes, operation);
  return {
    id: row.id,
    version: row.version,
    requesterId: row.requester_id,
    agentProfileId: row.agent_profile_id,
    curriculumPackageId: row.curriculum_package_id,
    productType: row.product_type,
    theme: row.theme,
    ...(durationMinutes === undefined ? {} : { durationMinutes }),
    status: row.status,
    createdAt: row.created_at,
    updatedAt: row.updated_at,
  };
}

export function productionOrderEventRowToOppEvent(
  row: unknown,
  expectedOppId: EntityId,
  operation = 'productionOrder.event.mapper.fromRow'
): OppEvent {
  if (
    !isRecord(row) ||
    !isNonEmptyString(row.id) ||
    !isNonEmptyString(row.version) ||
    !isNonEmptyString(row.opp_id) ||
    !isOneOf<OppEventType>(row.event_type, OPP_EVENT_TYPES) ||
    !isOneOf<OppStatus>(row.to_status, OPP_STATUSES) ||
    !isDateTime(row.occurred_at) ||
    row.opp_id !== expectedOppId
  ) {
    throw invalidPersistenceResponse(operation);
  }

  const fromStatus = parseOptionalStatus(row.from_status, operation);
  const reason = parseOptionalReason(row.reason, operation);
  return {
    id: row.id,
    version: row.version,
    oppId: row.opp_id,
    eventType: row.event_type,
    ...(fromStatus === undefined ? {} : { fromStatus }),
    toStatus: row.to_status,
    ...(reason === undefined ? {} : { reason }),
    occurredAt: row.occurred_at,
  };
}
