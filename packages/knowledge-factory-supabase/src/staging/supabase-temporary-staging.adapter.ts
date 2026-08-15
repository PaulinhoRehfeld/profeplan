import type {
  TemporaryStagingDiscardCommand,
  TemporaryStagingIntegrityPort,
  TemporaryStagingIntegrityVerificationCommand,
  TemporaryStagingPort,
  TemporaryStagingRecoveryPort,
  TemporaryStagingRecoveryProbeCommand,
  TemporaryStagingWrite,
} from '@profeplan/knowledge-factory';
import type {
  ISODateTime,
  TemporaryStagingArtifactDescriptor,
  TemporaryStagingDiscardReceipt,
  TemporaryStagingIntegrityEvidence,
  TemporaryStagingRecoveryProbe,
} from '@profeplan/types';
import type { SupabaseSystemContext } from '../context/supabase-system-context.ts';
import {
  KnowledgeFactoryPersistenceError,
  toPersistenceError,
} from '../errors/persistence-error.ts';
import {
  NOOP_PERSISTENCE_LOGGER,
  recordPersistenceLog,
  type PersistenceLogger,
} from '../observability/persistence-logger.ts';

const ADAPTER_NAME = 'SupabaseTemporaryStagingAdapter';
const OPAQUE_LOCATOR_PREFIX = 'temporary-staging:v1:';

export interface SupabaseTemporaryStagingAdapterOptions {
  readonly bucketName: string;
  readonly now?: () => ISODateTime;
}

function safeSegment(value: string): string {
  return encodeURIComponent(value);
}

function objectPath(runId: string, artifactId: string): string {
  return `runs/${safeSegment(runId)}/artifacts/${safeSegment(artifactId)}`;
}

function locatorFor(runId: string, artifactId: string): string {
  return `${OPAQUE_LOCATOR_PREFIX}${safeSegment(runId)}:${safeSegment(artifactId)}`;
}

function pathParts(path: string): { readonly folder: string; readonly filename: string } {
  const separator = path.lastIndexOf('/');
  return {
    folder: path.slice(0, separator),
    filename: path.slice(separator + 1),
  };
}

async function sha256Hex(bytes: ArrayBuffer): Promise<string> {
  const digest = await globalThis.crypto.subtle.digest('SHA-256', bytes);
  return Array.from(new Uint8Array(digest), (byte) => byte.toString(16).padStart(2, '0')).join('');
}

function recordSuccess(
  logger: PersistenceLogger,
  context: SupabaseSystemContext,
  operation: string,
  startedAt: number,
  artifactId: string
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'success',
    aggregateType: 'temporary_staging',
    aggregateId: artifactId,
    correlationId: context.correlationId,
  });
}

function recordFailure(
  logger: PersistenceLogger,
  context: SupabaseSystemContext,
  operation: string,
  startedAt: number,
  artifactId: string,
  error: KnowledgeFactoryPersistenceError
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'failure',
    aggregateType: 'temporary_staging',
    aggregateId: artifactId,
    correlationId: context.correlationId,
    errorCode: error.code,
  });
}

export class SupabaseTemporaryStagingAdapter
  implements TemporaryStagingPort, TemporaryStagingIntegrityPort, TemporaryStagingRecoveryPort
{
  private readonly context: SupabaseSystemContext;
  private readonly bucketName: string;
  private readonly logger: PersistenceLogger;
  private readonly now: () => ISODateTime;

  constructor(
    context: SupabaseSystemContext,
    options: SupabaseTemporaryStagingAdapterOptions,
    logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER
  ) {
    this.context = context;
    this.bucketName = options.bucketName;
    this.now = options.now ?? (() => new Date().toISOString());
    this.logger = logger;
  }

  async stage(input: TemporaryStagingWrite): Promise<TemporaryStagingArtifactDescriptor> {
    const operation = 'staging.stage';
    const startedAt = Date.now();
    const path = objectPath(input.run.id, input.artifactId);
    const bucket = this.context.client.storage.from(this.bucketName);

    try {
      const { error } = await bucket.upload(path, input.bytes, {
        contentType: input.mediaType,
        upsert: false,
      });

      if (error !== null) {
        throw toPersistenceError(error, operation);
      }

      const descriptor: TemporaryStagingArtifactDescriptor = {
        contractVersion: '1.0.0',
        state: 'STAGED',
        artifact: {
          artifactId: input.artifactId,
          opaqueLocator: locatorFor(input.run.id, input.artifactId),
        },
        run: input.run,
        sourceVersion: input.sourceVersion,
        receivedFile: input.receivedFile,
        sizeBytes: input.bytes.byteLength,
        mediaType: input.mediaType,
        createdAt: input.createdAt,
        expiresAt: input.expiresAt,
      };

      recordSuccess(this.logger, this.context, operation, startedAt, input.artifactId);
      return descriptor;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);

      // An unavailable/unknown provider response is ambiguous: the object may
      // already exist. C.2.4 deliberately leaves it in place for deterministic
      // reconciliation instead of deleting a potentially successful write.
      if (
        persistenceError.code !== 'CONFLICT' &&
        persistenceError.code !== 'UNAVAILABLE' &&
        persistenceError.code !== 'UNKNOWN'
      ) {
        try {
          await bucket.remove([path]);
        } catch {
          // Best-effort cleanup must not leak provider details or replace the original safe error.
        }
      }

      recordFailure(
        this.logger,
        this.context,
        operation,
        startedAt,
        input.artifactId,
        persistenceError
      );
      throw persistenceError;
    }
  }

  async inspect(
    input: TemporaryStagingRecoveryProbeCommand
  ): Promise<TemporaryStagingRecoveryProbe> {
    const operation = 'staging.inspect_recovery';
    const startedAt = Date.now();
    const artifactId = input.artifactId;
    const path = objectPath(input.run.id, artifactId);
    const { folder, filename } = pathParts(path);
    const bucket = this.context.client.storage.from(this.bucketName);

    try {
      const { data: listed, error: listError } = await bucket.list(folder, {
        limit: 2,
        search: filename,
      });
      if (listError !== null) {
        throw toPersistenceError(listError, operation);
      }

      if (!(listed ?? []).some((item) => item.name === filename)) {
        const probe: TemporaryStagingRecoveryProbe = {
          outcome: 'absent',
          artifactId,
          run: input.run,
          observedAt: this.now(),
        };
        recordSuccess(this.logger, this.context, operation, startedAt, artifactId);
        return probe;
      }

      const { data, error } = await bucket.download(path);
      if (error !== null) {
        throw toPersistenceError(error, operation);
      }
      if (data === null) {
        throw new KnowledgeFactoryPersistenceError('UNKNOWN', operation);
      }

      const storedBytes = await data.arrayBuffer();
      const probe: TemporaryStagingRecoveryProbe = {
        outcome: 'present',
        artifact: {
          artifactId,
          opaqueLocator: locatorFor(input.run.id, artifactId),
        },
        run: input.run,
        observedDigest: {
          algorithm: 'sha-256',
          value: await sha256Hex(storedBytes),
        },
        observedSizeBytes: storedBytes.byteLength,
        observedAt: this.now(),
      };
      recordSuccess(this.logger, this.context, operation, startedAt, artifactId);
      return probe;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, this.context, operation, startedAt, artifactId, persistenceError);
      throw persistenceError;
    }
  }

  async verify(
    input: TemporaryStagingIntegrityVerificationCommand
  ): Promise<TemporaryStagingIntegrityEvidence> {
    const operation = 'staging.verify_integrity';
    const startedAt = Date.now();
    const artifactId = input.artifact.artifact.artifactId;
    const runId = input.artifact.run.id;
    const expectedLocator = locatorFor(runId, artifactId);

    if (
      input.algorithm !== 'sha-256' ||
      input.artifact.artifact.opaqueLocator !== expectedLocator
    ) {
      const error = new KnowledgeFactoryPersistenceError('INVALID_INPUT', operation);
      recordFailure(this.logger, this.context, operation, startedAt, artifactId, error);
      throw error;
    }

    const path = objectPath(runId, artifactId);
    const bucket = this.context.client.storage.from(this.bucketName);

    try {
      const { data, error } = await bucket.download(path);
      if (error !== null) {
        throw toPersistenceError(error, operation);
      }
      if (data === null) {
        throw new KnowledgeFactoryPersistenceError('UNKNOWN', operation);
      }

      const storedBytes = await data.arrayBuffer();
      const evidence: TemporaryStagingIntegrityEvidence = {
        contractVersion: '1.0.0',
        artifactId,
        run: input.artifact.run,
        sourceVersion: input.artifact.sourceVersion,
        receivedFile: input.artifact.receivedFile,
        digest: {
          algorithm: 'sha-256',
          value: await sha256Hex(storedBytes),
        },
        byteLength: storedBytes.byteLength,
        verifiedAt: this.now(),
        correlationId: input.correlationId,
      };

      recordSuccess(this.logger, this.context, operation, startedAt, artifactId);
      return evidence;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, this.context, operation, startedAt, artifactId, persistenceError);
      throw persistenceError;
    }
  }

  async discard(input: TemporaryStagingDiscardCommand): Promise<TemporaryStagingDiscardReceipt> {
    const operation = 'staging.discard';
    const startedAt = Date.now();
    const artifactId = input.artifact.artifactId;
    const expectedLocator = locatorFor(input.run.id, artifactId);

    if (input.artifact.opaqueLocator !== expectedLocator) {
      const error = new KnowledgeFactoryPersistenceError('INVALID_INPUT', operation);
      recordFailure(this.logger, this.context, operation, startedAt, artifactId, error);
      throw error;
    }

    const path = objectPath(input.run.id, artifactId);
    const { folder, filename } = pathParts(path);
    const bucket = this.context.client.storage.from(this.bucketName);

    try {
      const { data: before, error: beforeError } = await bucket.list(folder, {
        limit: 2,
        search: filename,
      });
      if (beforeError !== null) {
        throw toPersistenceError(beforeError, operation);
      }

      const existsBefore = (before ?? []).some((item) => item.name === filename);
      if (!existsBefore) {
        const receipt: TemporaryStagingDiscardReceipt = {
          contractVersion: '1.0.0',
          state: 'DISCARDED',
          artifactId,
          run: input.run,
          requestedAt: input.requestedAt,
          confirmedAt: this.now(),
          outcome: 'already_discarded',
          reasonCode: input.reasonCode,
          correlationId: input.correlationId,
        };
        recordSuccess(this.logger, this.context, operation, startedAt, artifactId);
        return receipt;
      }

      const { error } = await bucket.remove([path]);
      if (error !== null) {
        throw toPersistenceError(error, operation);
      }

      const { data: remaining, error: listError } = await bucket.list(folder, {
        limit: 2,
        search: filename,
      });

      if (listError !== null) {
        throw toPersistenceError(listError, operation);
      }

      if ((remaining ?? []).some((item) => item.name === filename)) {
        throw toPersistenceError({ message: 'delete verification failed' }, operation);
      }

      const receipt: TemporaryStagingDiscardReceipt = {
        contractVersion: '1.0.0',
        state: 'DISCARDED',
        artifactId,
        run: input.run,
        requestedAt: input.requestedAt,
        confirmedAt: this.now(),
        outcome: 'discarded',
        reasonCode: input.reasonCode,
        correlationId: input.correlationId,
      };

      recordSuccess(this.logger, this.context, operation, startedAt, artifactId);
      return receipt;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, this.context, operation, startedAt, artifactId, persistenceError);
      throw persistenceError;
    }
  }
}
