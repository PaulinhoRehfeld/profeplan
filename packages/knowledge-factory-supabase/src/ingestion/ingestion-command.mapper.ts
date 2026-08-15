import { targetStateForIngestionCommand } from '@profeplan/knowledge-factory';
import {
  INGESTION_REASON_CODES,
  INGESTION_RUN_STATES,
  type EntityId,
  type IngestionCommandReceipt,
  type IngestionCommandType,
  type IngestionRunState,
  type TemporaryStagingArtifactDescriptor,
  type VerifiedTemporaryStagingArtifactDescriptor,
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
  return (
    Array.isArray(value) &&
    value.every((item) => typeof item === 'string' && item.length > 0)
  );
}

function isRunState(value: unknown): value is IngestionRunState {
  return typeof value === 'string' && INGESTION_RUN_STATES.some((state) => state === value);
}

function hasExactReceiptKeys(row: Record<string, unknown>): boolean {
  const expected = [
    'command_id',
    'fingerprint',
    'correlation_id',
    'operation',
    'run_id',
    'aggregate_version',
    'sequence',
    'event_ids',
    'previous_state',
    'state',
    'replayed',
    'committed_at',
    'reason_code',
  ];
  return Object.keys(row).length === expected.length && expected.every((key) => key in row);
}

export type C24IngestionCommand =
  | import('@profeplan/types').RequestIngestionCommand
  | import('@profeplan/types').BeginIngestionStagingCommand
  | import('@profeplan/types').MarkIngestionStagedCommand
  | import('@profeplan/types').BeginIngestionVerificationCommand
  | import('@profeplan/types').ConfirmIngestionVerifiedCommand
  | import('@profeplan/types').FailIngestionCommand
  | import('@profeplan/types').CancelIngestionCommand;

export function ingestionCommandRunId(command: C24IngestionCommand): EntityId {
  return command.commandType === 'request_ingestion' ? command.request.run.id : command.run.id;
}

export function ingestionCommandToRpcPayload(
  command: C24IngestionCommand,
  operation = 'ingestion.command.mapper.toPayload'
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

export function stagingArtifactToRpcPayload(
  artifact: TemporaryStagingArtifactDescriptor
): Readonly<Record<string, unknown>> {
  return Object.freeze({
    artifact: artifact.artifact,
    run: artifact.run,
    sourceVersion: artifact.sourceVersion,
    receivedFile: artifact.receivedFile,
    sizeBytes: artifact.sizeBytes,
    mediaType: artifact.mediaType,
    createdAt: artifact.createdAt,
    expiresAt: artifact.expiresAt,
  });
}

export function verifiedArtifactToRpcPayload(
  artifact: VerifiedTemporaryStagingArtifactDescriptor
): Readonly<Record<string, unknown>> {
  return Object.freeze({
    artifact: artifact.artifact,
    run: artifact.run,
    sourceVersion: artifact.sourceVersion,
    receivedFile: artifact.receivedFile,
    sizeBytes: artifact.sizeBytes,
    mediaType: artifact.mediaType,
    createdAt: artifact.createdAt,
    expiresAt: artifact.expiresAt,
    integrity: artifact.integrity,
  });
}

export function ingestionReceiptRowToReceipt(
  data: unknown,
  command: C24IngestionCommand,
  operation = 'ingestion.command.mapper.fromReceipt'
): IngestionCommandReceipt {
  if (
    !Array.isArray(data) ||
    data.length !== 1 ||
    !isRecord(data[0]) ||
    !hasExactReceiptKeys(data[0])
  ) {
    throw invalidPersistenceResponse(operation);
  }

  const row = data[0];
  const runId = ingestionCommandRunId(command);
  const targetState = targetStateForIngestionCommand(command.commandType);
  const expectedPreviousState =
    command.commandType === 'request_ingestion' ? undefined : command.expectedState;

  if (
    row.command_id !== command.commandId ||
    row.fingerprint !== command.fingerprint ||
    row.correlation_id !== command.correlationId ||
    row.operation !== command.commandType ||
    row.run_id !== runId ||
    typeof row.aggregate_version !== 'string' ||
    row.aggregate_version.trim().length === 0 ||
    typeof row.sequence !== 'number' ||
    !Number.isSafeInteger(row.sequence) ||
    row.sequence <= 0 ||
    !isStringArray(row.event_ids) ||
    !isRunState(row.state) ||
    row.state !== targetState ||
    typeof row.replayed !== 'boolean' ||
    !isDateTime(row.committed_at)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  if (
    expectedPreviousState === undefined
      ? row.previous_state !== null
      : row.previous_state !== expectedPreviousState
  ) {
    throw invalidPersistenceResponse(operation);
  }

  const expectedReasonCode =
    command.commandType === 'fail_ingestion' || command.commandType === 'cancel_ingestion'
      ? command.reasonCode
      : undefined;
  if (
    expectedReasonCode === undefined
      ? row.reason_code !== null
      : row.reason_code !== expectedReasonCode ||
        !INGESTION_REASON_CODES.some((reasonCode) => reasonCode === row.reason_code)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  return Object.freeze({
    contractVersion: '1.0.0',
    commandId: row.command_id,
    fingerprint: row.fingerprint,
    correlationId: row.correlation_id,
    operation: row.operation as IngestionCommandType,
    run: { kind: 'processing_run', id: row.run_id as EntityId },
    aggregateVersion: row.aggregate_version,
    sequence: row.sequence,
    eventIds: Object.freeze([...row.event_ids]),
    ...(row.previous_state === null
      ? {}
      : { previousState: row.previous_state as IngestionRunState }),
    state: row.state,
    outcome: row.replayed ? 'replayed' : 'applied',
    committedAt: row.committed_at,
    ...(row.reason_code === null
      ? {}
      : { reasonCode: row.reason_code as IngestionCommandReceipt['reasonCode'] }),
  });
}
