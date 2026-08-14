import type {
  TemporaryStagingDiscardCommand,
  TemporaryStagingPort,
  TemporaryStagingWrite,
} from '@profeplan/knowledge-factory';
import type {
  ISODateTime,
  TemporaryStagingArtifactDescriptor,
  TemporaryStagingDiscardReceipt,
} from '@profeplan/types';
import type { SupabaseSystemContext } from '../context/supabase-system-context.ts';
import {
  KnowledgeFactoryPersistenceError,
  toPersistenceError,
  type KnowledgeFactoryPersistenceError as PersistenceError,
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
  error: PersistenceError
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

export class SupabaseTemporaryStagingAdapter implements TemporaryStagingPort {
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

      if (persistenceError.code !== 'CONFLICT') {
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
    const bucket = this.context.client.storage.from(this.bucketName);

    try {
      const { error } = await bucket.remove([path]);
      if (error !== null) {
        throw toPersistenceError(error, operation);
      }

      const separator = path.lastIndexOf('/');
      const folder = path.slice(0, separator);
      const filename = path.slice(separator + 1);
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
