import type {
  EntityId,
  IngestionRequest,
  ISODateTime,
  TemporaryStagingArtifactDescriptor,
} from '@profeplan/types';
import { allow, deny, type DomainDecision } from '../domain/result.ts';
import { reason, type DomainReason } from '../domain/reasons.ts';
import type { TemporaryStagingWrite } from '../staging/staging.port.ts';
import { evaluateIngestionRequest } from './ingestion.ts';

const MIB = 1024 * 1024;

export interface StagingIntakePolicy {
  readonly maxFileSizeBytes: number;
  readonly maxFilesPerRun: number;
  readonly maxTotalBytesPerRun: number;
  readonly maxIntakeDurationMs: number;
  readonly allowedMediaTypes: readonly string[];
  readonly allowedExtensions: readonly string[];
  readonly defaultRetentionMs: number;
  readonly maxRetentionMs: number;
  readonly maxFilenameLength: number;
}

export const DEFAULT_STAGING_INTAKE_POLICY: StagingIntakePolicy = Object.freeze({
  maxFileSizeBytes: 50 * MIB,
  maxFilesPerRun: 10,
  maxTotalBytesPerRun: 200 * MIB,
  maxIntakeDurationMs: 15 * 60 * 1000,
  allowedMediaTypes: ['application/pdf'],
  allowedExtensions: ['.pdf'],
  defaultRetentionMs: 6 * 60 * 60 * 1000,
  maxRetentionMs: 24 * 60 * 60 * 1000,
  maxFilenameLength: 255,
});

export interface StagingIntakeFile {
  readonly originalFilename: string;
  readonly declaredMediaType: string;
  readonly bytes: Uint8Array;
}

export interface StagingRunUsage {
  readonly artifactCount: number;
  readonly totalBytes: number;
}

export interface StagingIntakeEvaluationInput {
  readonly request: IngestionRequest;
  readonly artifactId: EntityId;
  readonly file: StagingIntakeFile;
  readonly runUsage: StagingRunUsage;
  readonly intakeStartedAt: ISODateTime;
  readonly evaluatedAt: ISODateTime;
  readonly correlationId: EntityId;
  readonly requestedRetentionMs?: number;
  readonly policy?: StagingIntakePolicy;
}

export interface PreparedStagingIntake extends TemporaryStagingWrite {
  readonly normalizedFilename: string;
}

function parseInstant(value: ISODateTime): number | undefined {
  const parsed = Date.parse(value);
  return Number.isFinite(parsed) ? parsed : undefined;
}

function normalizeMediaType(value: string): string {
  return value.split(';', 1)[0]?.trim().toLowerCase() ?? '';
}

function extensionOf(filename: string): string {
  const index = filename.lastIndexOf('.');
  return index < 0 ? '' : filename.slice(index).toLowerCase();
}

function hasHostileFilename(filename: string, maxLength: number): boolean {
  return (
    filename.length === 0 ||
    filename.length > maxLength ||
    filename.includes('/') ||
    filename.includes('\\') ||
    filename.includes('..') ||
    /[\u0000-\u001f\u007f]/u.test(filename)
  );
}

function hasPdfSignature(bytes: Uint8Array): boolean {
  return (
    bytes.length >= 5 &&
    bytes[0] === 0x25 &&
    bytes[1] === 0x50 &&
    bytes[2] === 0x44 &&
    bytes[3] === 0x46 &&
    bytes[4] === 0x2d
  );
}

export function evaluateStagingIntake(
  input: StagingIntakeEvaluationInput
): DomainDecision<PreparedStagingIntake> {
  const authorizationDecision = evaluateIngestionRequest(input.request);
  if (!authorizationDecision.allowed) {
    return deny(authorizationDecision.reasons);
  }

  const policy = input.policy ?? DEFAULT_STAGING_INTAKE_POLICY;
  const reasons: DomainReason[] = [];
  const normalizedFilename = input.file.originalFilename.normalize('NFC').trim();
  const mediaType = normalizeMediaType(input.file.declaredMediaType);
  const extension = extensionOf(normalizedFilename);
  const sizeBytes = input.file.bytes.byteLength;
  const startedAt = parseInstant(input.intakeStartedAt);
  const evaluatedAt = parseInstant(input.evaluatedAt);
  const retentionMs = input.requestedRetentionMs ?? policy.defaultRetentionMs;

  if (hasHostileFilename(normalizedFilename, policy.maxFilenameLength)) {
    reasons.push(
      reason(
        'STAGING_FILENAME_REJECTED',
        'The staging filename violates the intake safety policy.',
        input.request.receivedFile.id
      )
    );
  }

  if (!policy.allowedMediaTypes.includes(mediaType)) {
    reasons.push(
      reason(
        'STAGING_MEDIA_TYPE_NOT_ALLOWED',
        'The declared media type is not allowed by the staging policy.',
        input.request.receivedFile.id,
        { mediaType }
      )
    );
  }

  if (!policy.allowedExtensions.includes(extension)) {
    reasons.push(
      reason(
        'STAGING_EXTENSION_NOT_ALLOWED',
        'The file extension is not allowed by the staging policy.',
        input.request.receivedFile.id,
        { extension }
      )
    );
  }

  if (sizeBytes > policy.maxFileSizeBytes) {
    reasons.push(
      reason(
        'STAGING_FILE_TOO_LARGE',
        'The file exceeds the maximum staging size.',
        input.request.receivedFile.id,
        { sizeBytes, maxFileSizeBytes: policy.maxFileSizeBytes }
      )
    );
  }

  if (input.runUsage.artifactCount + 1 > policy.maxFilesPerRun) {
    reasons.push(
      reason(
        'STAGING_RUN_FILE_LIMIT_EXCEEDED',
        'The processing run exceeds the maximum number of staging artifacts.',
        input.request.run.id,
        { maxFilesPerRun: policy.maxFilesPerRun }
      )
    );
  }

  if (input.runUsage.totalBytes + sizeBytes > policy.maxTotalBytesPerRun) {
    reasons.push(
      reason(
        'STAGING_RUN_BYTE_LIMIT_EXCEEDED',
        'The processing run exceeds the maximum staging byte volume.',
        input.request.run.id,
        { maxTotalBytesPerRun: policy.maxTotalBytesPerRun }
      )
    );
  }

  if (
    startedAt === undefined ||
    evaluatedAt === undefined ||
    evaluatedAt < startedAt ||
    evaluatedAt - startedAt > policy.maxIntakeDurationMs
  ) {
    reasons.push(
      reason(
        'STAGING_INTAKE_DURATION_EXCEEDED',
        'The staging intake duration is invalid or exceeds the configured maximum.',
        input.request.run.id,
        { maxIntakeDurationMs: policy.maxIntakeDurationMs }
      )
    );
  }

  if (!Number.isFinite(retentionMs) || retentionMs <= 0 || retentionMs > policy.maxRetentionMs) {
    reasons.push(
      reason(
        'STAGING_RETENTION_INVALID',
        'The requested staging retention is outside the configured policy.',
        input.artifactId,
        { maxRetentionMs: policy.maxRetentionMs }
      )
    );
  }

  if (mediaType === 'application/pdf' && !hasPdfSignature(input.file.bytes)) {
    reasons.push(
      reason(
        'STAGING_FILE_SIGNATURE_MISMATCH',
        'The file does not match the minimum physical signature required for the declared type.',
        input.request.receivedFile.id
      )
    );
  }

  if (reasons.length > 0 || evaluatedAt === undefined) {
    return deny(reasons);
  }

  const expiresAt = new Date(evaluatedAt + retentionMs).toISOString();

  return allow({
    artifactId: input.artifactId,
    run: input.request.run,
    sourceVersion: input.request.sourceVersion,
    receivedFile: input.request.receivedFile,
    bytes: input.file.bytes,
    mediaType,
    createdAt: input.evaluatedAt,
    expiresAt,
    correlationId: input.correlationId,
    normalizedFilename,
  });
}

export function evaluateStagingArtifactAvailability(
  artifact: TemporaryStagingArtifactDescriptor,
  evaluatedAt: ISODateTime
): DomainDecision<TemporaryStagingArtifactDescriptor> {
  const now = parseInstant(evaluatedAt);
  const expiresAt = parseInstant(artifact.expiresAt);

  if (now === undefined || expiresAt === undefined || now >= expiresAt) {
    return deny([
      reason(
        'STAGING_ARTIFACT_EXPIRED',
        'The temporary staging artifact has expired and cannot be used for further processing.',
        artifact.artifact.artifactId
      ),
    ]);
  }

  return allow(artifact);
}
