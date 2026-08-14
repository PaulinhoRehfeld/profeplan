import {
  SOURCE_AUTHORIZATION_STATES,
  SOURCE_REGISTRATION_STATES,
  type EntityId,
  type SourceAuthorizationCommandReceipt,
  type SourceAuthorizationCommandType,
  type SourceAuthorizationState,
  type SourceCommandReceipt,
  type SourceGovernanceCommand,
  type SourceImpactCommandReceipt,
  type SourceRegistrationCommandReceipt,
  type SourceRegistrationCommandType,
  type SourceRegistrationState,
} from '@profeplan/types';
import { invalidPersistenceResponse } from '../errors/persistence-error.ts';

const ISO_DATE_TIME_PATTERN =
  /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|([+-])(\d{2}):(\d{2}))$/;

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function isDateTime(value: unknown): value is string {
  return (
    typeof value === 'string' &&
    ISO_DATE_TIME_PATTERN.test(value) &&
    Number.isFinite(Date.parse(value))
  );
}

function isStringArray(value: unknown): value is string[] {
  return Array.isArray(value) && value.every((item) => typeof item === 'string' && item.length > 0);
}

function hasExactReceiptKeys(row: Record<string, unknown>): boolean {
  const expected = [
    'dimension',
    'command_id',
    'fingerprint',
    'operation',
    'aggregate_id',
    'aggregate_version',
    'sequence',
    'event_ids',
    'state',
    'replayed',
    'committed_at',
  ];
  return Object.keys(row).length === expected.length && expected.every((key) => key in row);
}

export type SourceCommandExpectation =
  | {
      readonly dimension: 'registration';
      readonly commandId: EntityId;
      readonly fingerprint: string;
      readonly operation: SourceRegistrationCommandType;
      readonly aggregateId: EntityId;
      readonly state: SourceRegistrationState;
    }
  | {
      readonly dimension: 'authorization';
      readonly commandId: EntityId;
      readonly fingerprint: string;
      readonly operation: SourceAuthorizationCommandType;
      readonly aggregateId: EntityId;
      readonly state: SourceAuthorizationState;
    }
  | {
      readonly dimension: 'impact';
      readonly commandId: EntityId;
      readonly fingerprint: string;
      readonly operation: 'open_impact_assessment';
      readonly aggregateId: EntityId;
    };

export function sourceGovernanceCommandToRpcPayload(
  command: SourceGovernanceCommand,
  operation = 'sourceLifecycle.command.mapper.toPayload'
): Readonly<Record<string, unknown>> {
  if (
    !isRecord(command) ||
    typeof command.commandId !== 'string' ||
    command.commandId.trim().length === 0 ||
    typeof command.fingerprint !== 'string' ||
    command.fingerprint.trim().length === 0
  ) {
    throw invalidPersistenceResponse(operation);
  }

  const { commandId: _commandId, fingerprint: _fingerprint, ...payload } = command;
  return Object.freeze({ ...payload });
}

export function sourceLifecycleReceiptRowToReceipt(
  data: unknown,
  expected: SourceCommandExpectation,
  operation = 'sourceLifecycle.command.mapper.fromReceipt'
): SourceCommandReceipt {
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
    row.dimension !== expected.dimension ||
    row.command_id !== expected.commandId ||
    row.fingerprint !== expected.fingerprint ||
    row.operation !== expected.operation ||
    row.aggregate_id !== expected.aggregateId ||
    typeof row.aggregate_version !== 'string' ||
    row.aggregate_version.trim().length === 0 ||
    typeof row.sequence !== 'number' ||
    !Number.isSafeInteger(row.sequence) ||
    row.sequence <= 0 ||
    !isStringArray(row.event_ids) ||
    typeof row.replayed !== 'boolean' ||
    !isDateTime(row.committed_at)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  const common = {
    commandId: row.command_id,
    fingerprint: row.fingerprint,
    aggregateId: row.aggregate_id,
    aggregateVersion: row.aggregate_version,
    sequence: row.sequence,
    eventIds: Object.freeze([...row.event_ids]),
    replayed: row.replayed,
    committedAt: row.committed_at,
  } as const;

  if (expected.dimension === 'registration') {
    if (
      row.state !== expected.state ||
      !SOURCE_REGISTRATION_STATES.some((state) => state === row.state)
    ) {
      throw invalidPersistenceResponse(operation);
    }

    return Object.freeze({
      dimension: 'registration',
      operation: expected.operation,
      state: expected.state,
      ...common,
    }) satisfies SourceRegistrationCommandReceipt;
  }

  if (expected.dimension === 'authorization') {
    if (
      row.state !== expected.state ||
      !SOURCE_AUTHORIZATION_STATES.some((state) => state === row.state)
    ) {
      throw invalidPersistenceResponse(operation);
    }

    return Object.freeze({
      dimension: 'authorization',
      operation: expected.operation,
      state: expected.state,
      ...common,
    }) satisfies SourceAuthorizationCommandReceipt;
  }

  if (row.state !== null) {
    throw invalidPersistenceResponse(operation);
  }

  return Object.freeze({
    dimension: 'impact',
    operation: 'open_impact_assessment',
    ...common,
  }) satisfies SourceImpactCommandReceipt;
}
