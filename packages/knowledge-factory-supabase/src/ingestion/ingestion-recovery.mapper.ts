import {
  BINARY_DUPLICATE_RELATIONSHIPS,
  INGESTION_COMMAND_TYPES,
  INGESTION_REASON_CODES,
  INGESTION_RUN_STATES,
  STAGING_DISCARD_OUTCOMES,
  STAGING_DISCARD_REASON_CODES,
  type BinaryDigest,
  type BinaryDuplicateDecision,
  type BinaryDuplicateMatch,
  type DurableStagingArtifactState,
  type EntityId,
  type IngestionCommandReceipt,
  type IngestionRecoverySnapshot,
  type IngestionRunSnapshot,
  type IngestionStagingArtifactSnapshot,
  type IngestionStagingDiscardSnapshot,
  type PersistedIngestionIntegrityEvidence,
  type TemporaryStagingIntegrityEvidence,
} from '@profeplan/types';
import { invalidPersistenceResponse } from '../errors/persistence-error.ts';

const SHA_256_HEX = /^[0-9a-f]{64}$/u;

const DURABLE_ARTIFACT_STATES: readonly DurableStagingArtifactState[] = [
  'RECEIVING',
  'STAGED',
  'VERIFIED',
  'DISCARD_PENDING',
  'DISCARDED',
  'FAILED',
  'QUARANTINED',
];

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function isDateTime(value: unknown): value is string {
  return typeof value === 'string' && Number.isFinite(Date.parse(value));
}

function isEntityId(value: unknown): value is EntityId {
  return typeof value === 'string' && value.trim().length > 0;
}

function parseRef(
  value: unknown,
  kind: 'processing_run' | 'source_version' | 'received_file',
  operation: string
): { readonly kind: typeof kind; readonly id: EntityId } {
  if (!isRecord(value) || value.kind !== kind || !isEntityId(value.id)) {
    throw invalidPersistenceResponse(operation);
  }
  return { kind, id: value.id };
}

function parseDigest(value: unknown, operation: string): BinaryDigest {
  if (
    !isRecord(value) ||
    value.algorithm !== 'sha-256' ||
    typeof value.value !== 'string' ||
    !SHA_256_HEX.test(value.value)
  ) {
    throw invalidPersistenceResponse(operation);
  }
  return { algorithm: 'sha-256', value: value.value };
}

function parseDiscard(
  value: unknown,
  operation: string
): IngestionStagingDiscardSnapshot | undefined {
  if (value === null || value === undefined) return undefined;
  if (
    !isRecord(value) ||
    !isDateTime(value.requestedAt) ||
    !STAGING_DISCARD_REASON_CODES.includes(value.reasonCode as never) ||
    !isEntityId(value.correlationId)
  ) {
    throw invalidPersistenceResponse(operation);
  }
  if (
    value.confirmedAt !== null &&
    value.confirmedAt !== undefined &&
    !isDateTime(value.confirmedAt)
  ) {
    throw invalidPersistenceResponse(operation);
  }
  if (
    value.outcome !== null &&
    value.outcome !== undefined &&
    !STAGING_DISCARD_OUTCOMES.includes(value.outcome as never)
  ) {
    throw invalidPersistenceResponse(operation);
  }
  return {
    requestedAt: value.requestedAt,
    ...(value.confirmedAt == null ? {} : { confirmedAt: value.confirmedAt }),
    reasonCode: value.reasonCode as IngestionStagingDiscardSnapshot['reasonCode'],
    ...(value.outcome == null
      ? {}
      : { outcome: value.outcome as IngestionStagingDiscardSnapshot['outcome'] }),
    correlationId: value.correlationId,
  };
}

export function ingestionArtifactSnapshotFromData(
  value: unknown,
  operation = 'ingestion.recovery.mapper.artifact'
): IngestionStagingArtifactSnapshot {
  if (
    !isRecord(value) ||
    value.contractVersion !== '1.0.0' ||
    !isEntityId(value.artifactId) ||
    !DURABLE_ARTIFACT_STATES.includes(value.state as DurableStagingArtifactState) ||
    typeof value.sizeBytes !== 'number' ||
    !Number.isSafeInteger(value.sizeBytes) ||
    value.sizeBytes < 0 ||
    typeof value.mediaType !== 'string' ||
    value.mediaType.trim().length === 0 ||
    !isDateTime(value.createdAt) ||
    !isDateTime(value.expiresAt) ||
    (value.opaqueLocator !== null &&
      value.opaqueLocator !== undefined &&
      (typeof value.opaqueLocator !== 'string' || value.opaqueLocator.trim().length === 0)) ||
    !isEntityId(value.correlationId)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  const discard = parseDiscard(value.discard, operation);
  return {
    contractVersion: '1.0.0',
    artifactId: value.artifactId,
    run: parseRef(value.run, 'processing_run', operation),
    sourceVersion: parseRef(value.sourceVersion, 'source_version', operation),
    receivedFile: parseRef(value.receivedFile, 'received_file', operation),
    state: value.state as DurableStagingArtifactState,
    sizeBytes: value.sizeBytes,
    mediaType: value.mediaType,
    createdAt: value.createdAt,
    expiresAt: value.expiresAt,
    ...(value.opaqueLocator == null ? {} : { opaqueLocator: value.opaqueLocator }),
    writeIntentDigest: parseDigest(value.writeIntentDigest, operation),
    correlationId: value.correlationId,
    ...(discard === undefined ? {} : { discard }),
  };
}

function parseRunSnapshot(value: unknown, operation: string): IngestionRunSnapshot {
  if (
    !isRecord(value) ||
    value.contractVersion !== '1.0.0' ||
    !isEntityId(value.requestId) ||
    !INGESTION_RUN_STATES.includes(value.state as never) ||
    typeof value.aggregateVersion !== 'string' ||
    value.aggregateVersion.trim().length === 0 ||
    typeof value.sequence !== 'number' ||
    !Number.isSafeInteger(value.sequence) ||
    value.sequence <= 0 ||
    !isDateTime(value.requestedAt) ||
    !isDateTime(value.createdAt) ||
    !isDateTime(value.updatedAt)
  ) {
    throw invalidPersistenceResponse(operation);
  }
  return {
    contractVersion: '1.0.0',
    requestId: value.requestId,
    run: parseRef(value.run, 'processing_run', operation),
    sourceVersion: parseRef(value.sourceVersion, 'source_version', operation),
    receivedFile: parseRef(value.receivedFile, 'received_file', operation),
    state: value.state as IngestionRunSnapshot['state'],
    aggregateVersion: value.aggregateVersion,
    sequence: value.sequence,
    requestedAt: value.requestedAt,
    createdAt: value.createdAt,
    updatedAt: value.updatedAt,
  };
}

function parseEvidence(value: unknown, operation: string): TemporaryStagingIntegrityEvidence {
  if (
    !isRecord(value) ||
    value.contractVersion !== '1.0.0' ||
    !isEntityId(value.artifactId) ||
    typeof value.byteLength !== 'number' ||
    !Number.isSafeInteger(value.byteLength) ||
    value.byteLength < 0 ||
    !isDateTime(value.verifiedAt) ||
    !isEntityId(value.correlationId)
  ) {
    throw invalidPersistenceResponse(operation);
  }
  return {
    contractVersion: '1.0.0',
    artifactId: value.artifactId,
    run: parseRef(value.run, 'processing_run', operation),
    sourceVersion: parseRef(value.sourceVersion, 'source_version', operation),
    receivedFile: parseRef(value.receivedFile, 'received_file', operation),
    digest: parseDigest(value.digest, operation),
    byteLength: value.byteLength,
    verifiedAt: value.verifiedAt,
    correlationId: value.correlationId,
  };
}

function parseDuplicateDecision(value: unknown, operation: string): BinaryDuplicateDecision {
  if (
    !isRecord(value) ||
    value.contractVersion !== '1.0.0' ||
    (value.outcome !== 'unique' && value.outcome !== 'duplicate') ||
    !Array.isArray(value.matches) ||
    !isDateTime(value.evaluatedAt)
  ) {
    throw invalidPersistenceResponse(operation);
  }
  const matches: BinaryDuplicateMatch[] = value.matches.map((match) => {
    if (
      !isRecord(match) ||
      !BINARY_DUPLICATE_RELATIONSHIPS.includes(match.relationship as never) ||
      !isEntityId(match.artifactId)
    ) {
      throw invalidPersistenceResponse(operation);
    }
    return {
      relationship: match.relationship as BinaryDuplicateMatch['relationship'],
      artifactId: match.artifactId,
      run: parseRef(match.run, 'processing_run', operation),
      sourceVersion: parseRef(match.sourceVersion, 'source_version', operation),
      receivedFile: parseRef(match.receivedFile, 'received_file', operation),
    };
  });
  if (
    (value.outcome === 'unique' && matches.length !== 0) ||
    (value.outcome === 'duplicate' && matches.length === 0)
  ) {
    throw invalidPersistenceResponse(operation);
  }
  return {
    contractVersion: '1.0.0',
    digest: parseDigest(value.digest, operation),
    outcome: value.outcome,
    matches: Object.freeze(matches),
    evaluatedAt: value.evaluatedAt,
  };
}

function parsePersistedEvidence(
  value: unknown,
  operation: string
): PersistedIngestionIntegrityEvidence {
  if (!isRecord(value)) throw invalidPersistenceResponse(operation);
  return {
    evidence: parseEvidence(value.evidence, operation),
    duplicateDecision: parseDuplicateDecision(value.duplicateDecision, operation),
  };
}

function parseReceipt(value: unknown, operation: string): IngestionCommandReceipt {
  if (
    !isRecord(value) ||
    value.contractVersion !== '1.0.0' ||
    !isEntityId(value.commandId) ||
    typeof value.fingerprint !== 'string' ||
    !SHA_256_HEX.test(value.fingerprint) ||
    !isEntityId(value.correlationId) ||
    !INGESTION_COMMAND_TYPES.includes(value.operation as never) ||
    typeof value.aggregateVersion !== 'string' ||
    value.aggregateVersion.trim().length === 0 ||
    typeof value.sequence !== 'number' ||
    !Number.isSafeInteger(value.sequence) ||
    value.sequence <= 0 ||
    !Array.isArray(value.eventIds) ||
    !value.eventIds.every(isEntityId) ||
    !INGESTION_RUN_STATES.includes(value.state as never) ||
    (value.previousState !== undefined &&
      value.previousState !== null &&
      !INGESTION_RUN_STATES.includes(value.previousState as never)) ||
    (value.outcome !== 'applied' && value.outcome !== 'replayed') ||
    !isDateTime(value.committedAt) ||
    (value.reasonCode !== undefined &&
      value.reasonCode !== null &&
      !INGESTION_REASON_CODES.includes(value.reasonCode as never))
  ) {
    throw invalidPersistenceResponse(operation);
  }
  return {
    contractVersion: '1.0.0',
    commandId: value.commandId,
    fingerprint: value.fingerprint,
    correlationId: value.correlationId,
    operation: value.operation as IngestionCommandReceipt['operation'],
    run: parseRef(value.run, 'processing_run', operation),
    aggregateVersion: value.aggregateVersion,
    sequence: value.sequence,
    eventIds: Object.freeze([...value.eventIds]),
    ...(value.previousState == null
      ? {}
      : { previousState: value.previousState as IngestionRunSnapshot['state'] }),
    state: value.state as IngestionRunSnapshot['state'],
    outcome: value.outcome,
    committedAt: value.committedAt,
    ...(value.reasonCode == null
      ? {}
      : { reasonCode: value.reasonCode as IngestionCommandReceipt['reasonCode'] }),
  };
}

export function ingestionRecoverySnapshotFromData(
  value: unknown,
  operation = 'ingestion.recovery.mapper.snapshot'
): IngestionRecoverySnapshot {
  if (
    !isRecord(value) ||
    value.contractVersion !== '1.0.0' ||
    !Array.isArray(value.artifacts) ||
    !Array.isArray(value.integrityEvidence)
  ) {
    throw invalidPersistenceResponse(operation);
  }
  return {
    contractVersion: '1.0.0',
    run: parseRunSnapshot(value.run, operation),
    artifacts: Object.freeze(
      value.artifacts.map((artifact) => ingestionArtifactSnapshotFromData(artifact, operation))
    ),
    integrityEvidence: Object.freeze(
      value.integrityEvidence.map((item) => parsePersistedEvidence(item, operation))
    ),
    ...(value.latestReceipt == null
      ? {}
      : { latestReceipt: parseReceipt(value.latestReceipt, operation) }),
  };
}
