import type {
  EntityId,
  PedagogicalComponentWriteOperation,
  PedagogicalComponentWriteReceipt,
} from '@profeplan/types';
import { invalidPersistenceResponse } from '../errors/persistence-error.ts';

export interface ComponentCommandExpectation {
  readonly commandId: EntityId;
  readonly operation: PedagogicalComponentWriteOperation;
  readonly componentId: EntityId;
  readonly componentVersionId: EntityId;
}

export interface ComponentCommandWithId {
  readonly commandId: EntityId;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

const ISO_DATE_TIME_PATTERN =
  /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|([+-])(\d{2}):(\d{2}))$/;

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

export function componentCommandToRpcPayload(
  command: ComponentCommandWithId,
  operation = 'component.command.mapper.toPayload'
): Readonly<Record<string, unknown>> {
  if (typeof command.commandId !== 'string') {
    throw invalidPersistenceResponse(operation);
  }

  return Object.fromEntries(Object.entries(command).filter(([key]) => key !== 'commandId'));
}

export function componentWriteReceiptRowToReceipt(
  data: unknown,
  expected: ComponentCommandExpectation,
  operation = 'component.command.mapper.fromReceipt'
): PedagogicalComponentWriteReceipt {
  if (!Array.isArray(data) || data.length !== 1 || !isRecord(data[0])) {
    throw invalidPersistenceResponse(operation);
  }

  const row = data[0];
  if (
    row.command_id !== expected.commandId ||
    row.operation !== expected.operation ||
    row.component_id !== expected.componentId ||
    row.component_version_id !== expected.componentVersionId ||
    typeof row.replayed !== 'boolean' ||
    !isDateTime(row.committed_at)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  return Object.freeze({
    commandId: row.command_id,
    operation: expected.operation,
    componentId: row.component_id,
    componentVersionId: row.component_version_id,
    replayed: row.replayed,
    committedAt: row.committed_at,
  });
}
