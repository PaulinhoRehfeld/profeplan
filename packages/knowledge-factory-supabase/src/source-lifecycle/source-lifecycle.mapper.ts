import {
  SOURCE_ACTOR_ROLES,
  SOURCE_AUTHORIZATION_BASIS_KINDS,
  SOURCE_AUTHORIZATION_EVENT_TYPES,
  SOURCE_AUTHORIZATION_STATES,
  SOURCE_IDENTITY_KINDS,
  SOURCE_IMPACT_EVENT_TYPES,
  SOURCE_PURPOSES,
  SOURCE_REGISTRATION_EVENT_TYPES,
  SOURCE_REGISTRATION_STATES,
  type SourceAuthorizationEvent,
  type SourceImpactEvent,
  type SourceRegistrationEvent,
} from '@profeplan/types';
import { invalidPersistenceResponse } from '../errors/persistence-error.ts';

const ISO_DATE_TIME_PATTERN =
  /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|([+-])(\d{2}):(\d{2}))$/;

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function isDateTime(value: unknown): value is string {
  return typeof value === 'string' && ISO_DATE_TIME_PATTERN.test(value) && Number.isFinite(Date.parse(value));
}

function isUuidLike(value: unknown): value is string {
  return typeof value === 'string' && /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(value);
}

function isPositiveSequence(value: unknown): value is number {
  return typeof value === 'number' && Number.isSafeInteger(value) && value > 0;
}

function hasExactKeys(row: Record<string, unknown>, keys: readonly string[]): boolean {
  return Object.keys(row).length === keys.length && keys.every((key) => key in row);
}

function assertRows(data: unknown, operation: string): readonly Record<string, unknown>[] {
  if (!Array.isArray(data) || !data.every(isRecord)) {
    throw invalidPersistenceResponse(operation);
  }
  return data;
}

const COMMON_KEYS = [
  'event_id',
  'aggregate_id',
  'aggregate_version',
  'sequence',
  'event_type',
  'subject_id',
  'subject_kind',
  'actor_id',
  'actor_role',
  'reason',
  'occurred_at',
  'effective_at',
  'correlation_id',
  'command_id',
] as const;

function assertCommon(row: Record<string, unknown>, operation: string): void {
  if (
    !isUuidLike(row.event_id) ||
    !isUuidLike(row.aggregate_id) ||
    typeof row.aggregate_version !== 'string' ||
    row.aggregate_version.trim().length === 0 ||
    !isPositiveSequence(row.sequence) ||
    !isUuidLike(row.subject_id) ||
    !SOURCE_IDENTITY_KINDS.some((kind) => kind === row.subject_kind) ||
    !isUuidLike(row.actor_id) ||
    !SOURCE_ACTOR_ROLES.some((role) => role === row.actor_role) ||
    typeof row.reason !== 'string' ||
    row.reason.trim().length === 0 ||
    !isDateTime(row.occurred_at) ||
    !isDateTime(row.effective_at) ||
    !isUuidLike(row.correlation_id) ||
    !isUuidLike(row.command_id)
  ) {
    throw invalidPersistenceResponse(operation);
  }
}

export function registrationHistoryRowsToEvents(
  data: unknown,
  operation = 'sourceLifecycle.read.mapper.registrationHistory'
): readonly SourceRegistrationEvent[] {
  const rows = assertRows(data, operation);
  const keys = [...COMMON_KEYS, 'from_state', 'to_state', 'successor_id', 'successor_kind'];

  return Object.freeze(
    rows.map((row) => {
      if (!hasExactKeys(row, keys)) {
        throw invalidPersistenceResponse(operation);
      }
      assertCommon(row, operation);
      if (
        !SOURCE_REGISTRATION_EVENT_TYPES.some((eventType) => eventType === row.event_type) ||
        (row.from_state !== null &&
          !SOURCE_REGISTRATION_STATES.some((state) => state === row.from_state)) ||
        !SOURCE_REGISTRATION_STATES.some((state) => state === row.to_state) ||
        ((row.successor_id === null) !== (row.successor_kind === null)) ||
        (row.successor_id !== null &&
          (!isUuidLike(row.successor_id) ||
            !SOURCE_IDENTITY_KINDS.some((kind) => kind === row.successor_kind)))
      ) {
        throw invalidPersistenceResponse(operation);
      }

      return Object.freeze({
        eventId: row.event_id,
        aggregateId: row.aggregate_id,
        aggregateVersion: row.aggregate_version,
        sequence: row.sequence,
        eventType: row.event_type,
        subject: Object.freeze({ id: row.subject_id, kind: row.subject_kind }),
        actor: Object.freeze({ actorId: row.actor_id, role: row.actor_role }),
        reason: row.reason,
        occurredAt: row.occurred_at,
        effectiveAt: row.effective_at,
        correlationId: row.correlation_id,
        commandId: row.command_id,
        ...(row.from_state === null ? {} : { fromState: row.from_state }),
        toState: row.to_state,
        ...(row.successor_id === null
          ? {}
          : {
              successor: Object.freeze({ id: row.successor_id, kind: row.successor_kind }),
            }),
      }) as SourceRegistrationEvent;
    })
  );
}

export function authorizationHistoryRowsToEvents(
  data: unknown,
  operation = 'sourceLifecycle.read.mapper.authorizationHistory'
): readonly SourceAuthorizationEvent[] {
  const rows = assertRows(data, operation);
  const keys = [
    ...COMMON_KEYS,
    'authorization_id',
    'purpose',
    'restrictions',
    'basis_id',
    'basis_kind',
    'basis_reference_digest',
    'from_state',
    'to_state',
    'effective_from',
    'effective_until',
    'superseded_by_authorization_id',
  ];

  return Object.freeze(
    rows.map((row) => {
      if (!hasExactKeys(row, keys)) {
        throw invalidPersistenceResponse(operation);
      }
      assertCommon(row, operation);
      if (
        !SOURCE_AUTHORIZATION_EVENT_TYPES.some((eventType) => eventType === row.event_type) ||
        !isUuidLike(row.authorization_id) ||
        !SOURCE_PURPOSES.some((purpose) => purpose === row.purpose) ||
        !Array.isArray(row.restrictions) ||
        !row.restrictions.every((item) => typeof item === 'string') ||
        !isUuidLike(row.basis_id) ||
        !SOURCE_AUTHORIZATION_BASIS_KINDS.some((kind) => kind === row.basis_kind) ||
        (row.basis_reference_digest !== null && typeof row.basis_reference_digest !== 'string') ||
        (row.from_state !== null &&
          !SOURCE_AUTHORIZATION_STATES.some((state) => state === row.from_state)) ||
        !SOURCE_AUTHORIZATION_STATES.some((state) => state === row.to_state) ||
        !isDateTime(row.effective_from) ||
        (row.effective_until !== null && !isDateTime(row.effective_until)) ||
        (row.superseded_by_authorization_id !== null &&
          !isUuidLike(row.superseded_by_authorization_id))
      ) {
        throw invalidPersistenceResponse(operation);
      }

      return Object.freeze({
        eventId: row.event_id,
        aggregateId: row.aggregate_id,
        aggregateVersion: row.aggregate_version,
        sequence: row.sequence,
        eventType: row.event_type,
        authorizationId: row.authorization_id,
        scope: Object.freeze({
          subject: Object.freeze({ id: row.subject_id, kind: row.subject_kind }),
          purpose: row.purpose,
          ...(row.restrictions.length === 0
            ? {}
            : { restrictions: Object.freeze([...row.restrictions]) }),
        }),
        basis: Object.freeze({
          id: row.basis_id,
          kind: row.basis_kind,
          ...(row.basis_reference_digest === null
            ? {}
            : { referenceDigest: row.basis_reference_digest }),
        }),
        actor: Object.freeze({ actorId: row.actor_id, role: row.actor_role }),
        reason: row.reason,
        occurredAt: row.occurred_at,
        effectiveAt: row.effective_at,
        correlationId: row.correlation_id,
        commandId: row.command_id,
        ...(row.from_state === null ? {} : { fromState: row.from_state }),
        toState: row.to_state,
        effectiveFrom: row.effective_from,
        ...(row.effective_until === null ? {} : { effectiveUntil: row.effective_until }),
        ...(row.superseded_by_authorization_id === null
          ? {}
          : { supersededByAuthorizationId: row.superseded_by_authorization_id }),
      }) as SourceAuthorizationEvent;
    })
  );
}

export function impactHistoryRowsToEvents(
  data: unknown,
  operation = 'sourceLifecycle.read.mapper.impactHistory'
): readonly SourceImpactEvent[] {
  const rows = assertRows(data, operation);
  const keys = [...COMMON_KEYS, 'triggering_authorization_id'];

  return Object.freeze(
    rows.map((row) => {
      if (!hasExactKeys(row, keys)) {
        throw invalidPersistenceResponse(operation);
      }
      assertCommon(row, operation);
      if (
        !SOURCE_IMPACT_EVENT_TYPES.some((eventType) => eventType === row.event_type) ||
        (row.triggering_authorization_id !== null && !isUuidLike(row.triggering_authorization_id))
      ) {
        throw invalidPersistenceResponse(operation);
      }

      return Object.freeze({
        eventId: row.event_id,
        aggregateId: row.aggregate_id,
        aggregateVersion: row.aggregate_version,
        sequence: row.sequence,
        eventType: row.event_type,
        subject: Object.freeze({ id: row.subject_id, kind: row.subject_kind }),
        actor: Object.freeze({ actorId: row.actor_id, role: row.actor_role }),
        reason: row.reason,
        occurredAt: row.occurred_at,
        effectiveAt: row.effective_at,
        correlationId: row.correlation_id,
        commandId: row.command_id,
        ...(row.triggering_authorization_id === null
          ? {}
          : { triggeringAuthorizationId: row.triggering_authorization_id }),
      }) as SourceImpactEvent;
    })
  );
}
