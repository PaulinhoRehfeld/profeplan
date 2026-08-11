import {
  OPP_STATUSES,
  type CreateProductionOrderCommand,
  type EntityId,
  type OppStatus,
  type ProductionOrderWriteOperation,
  type ProductionOrderWriteReceipt,
  type TransitionProductionOrderCommand,
} from '@profeplan/types';
import { invalidPersistenceResponse } from '../errors/persistence-error.ts';

export interface ProductionOrderCommandExpectation {
  readonly commandId: EntityId;
  readonly operation: ProductionOrderWriteOperation;
  readonly oppId: EntityId;
  readonly eventId: EntityId;
  readonly status: OppStatus;
}

const ISO_DATE_TIME_PATTERN =
  /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|([+-])(\d{2}):(\d{2}))$/;

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
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

function hasExactReceiptKeys(row: Record<string, unknown>): boolean {
  const expected = [
    'command_id',
    'operation',
    'opp_id',
    'event_id',
    'status',
    'replayed',
    'committed_at',
  ];
  return Object.keys(row).length === expected.length && expected.every((key) => key in row);
}

function assertCommandShape(
  command: unknown,
  operation: string
): asserts command is Record<string, unknown> & { readonly commandId: EntityId } {
  if (
    !isRecord(command) ||
    typeof command.commandId !== 'string' ||
    command.commandId.trim().length === 0
  ) {
    throw invalidPersistenceResponse(operation);
  }
}

export function createProductionOrderCommandToRpcPayload(
  command: CreateProductionOrderCommand,
  operation = 'productionOrder.command.mapper.createPayload'
): Readonly<Record<string, unknown>> {
  assertCommandShape(command, operation);
  if (!isRecord(command.order)) {
    throw invalidPersistenceResponse(operation);
  }

  const order = {
    id: command.order.id,
    version: command.order.version,
    agentProfileId: command.order.agentProfileId,
    curriculumPackageId: command.order.curriculumPackageId,
    productType: command.order.productType,
    theme: command.order.theme,
    ...(command.order.durationMinutes === undefined
      ? {}
      : { durationMinutes: command.order.durationMinutes }),
  };

  return {
    order,
    eventId: command.eventId,
    eventVersion: command.eventVersion,
    occurredAt: command.occurredAt,
  };
}

export function transitionProductionOrderCommandToRpcPayload(
  command: TransitionProductionOrderCommand,
  operation = 'productionOrder.command.mapper.transitionPayload'
): Readonly<Record<string, unknown>> {
  assertCommandShape(command, operation);

  return {
    requesterId: command.requesterId,
    oppId: command.oppId,
    expectedStatus: command.expectedStatus,
    expectedUpdatedAt: command.expectedUpdatedAt,
    toStatus: command.toStatus,
    eventId: command.eventId,
    eventVersion: command.eventVersion,
    ...(command.reason === undefined ? {} : { reason: command.reason }),
    occurredAt: command.occurredAt,
  };
}

export function productionOrderWriteReceiptRowToReceipt(
  data: unknown,
  expected: ProductionOrderCommandExpectation,
  operation = 'productionOrder.command.mapper.fromReceipt'
): ProductionOrderWriteReceipt {
  if (
    !Array.isArray(data) ||
    data.length !== 1 ||
    !isRecord(data[0]) ||
    !hasExactReceiptKeys(data[0])
  ) {
    throw invalidPersistenceResponse(operation);
  }

  const row = data[0];
  if (
    row.command_id !== expected.commandId ||
    row.operation !== expected.operation ||
    row.opp_id !== expected.oppId ||
    row.event_id !== expected.eventId ||
    row.status !== expected.status ||
    !OPP_STATUSES.some((status) => status === row.status) ||
    typeof row.replayed !== 'boolean' ||
    !isDateTime(row.committed_at)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  return Object.freeze({
    commandId: row.command_id,
    operation: expected.operation,
    oppId: row.opp_id,
    eventId: row.event_id,
    status: expected.status,
    replayed: row.replayed,
    committedAt: row.committed_at,
  });
}
