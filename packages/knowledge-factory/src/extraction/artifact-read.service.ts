import type { ExtractionArtifactRef } from '@profeplan/types';
import {
  ExtractionArtifactReadError,
  type ExtractionArtifactReadPort,
  type ExtractionArtifactReadRequest,
  type ExtractionArtifactReadResult,
} from './artifact-read.port.ts';

export interface VerifiedExtractionArtifactRead {
  readonly artifact: ExtractionArtifactRef;
  readonly mediaType: string;
  readonly expiresAt: string;
  readonly sha256: string;
  readonly body: Uint8Array;
}

function assertArtifactReadAuthorization(request: ExtractionArtifactReadRequest): void {
  const { authorizationEvidence, sourceVersion, readAt } = request;
  const authorizationInstant = Date.parse(authorizationEvidence.evaluatedAt);
  const readInstant = Date.parse(readAt);

  if (
    authorizationEvidence.purpose !== 'extraction' ||
    authorizationEvidence.checkpoint !== 'artifact_read' ||
    authorizationEvidence.sourceVersion.kind !== 'source_version' ||
    authorizationEvidence.sourceVersion.id !== sourceVersion.id ||
    !Number.isFinite(authorizationInstant) ||
    !Number.isFinite(readInstant) ||
    authorizationInstant !== readInstant
  ) {
    throw new ExtractionArtifactReadError(
      'authorization_denied',
      'Extraction authorization must be re-evaluated for this source version at artifact-read time.'
    );
  }
}

function assertFiniteInstant(value: string, field: string): number {
  const instant = Date.parse(value);
  if (!Number.isFinite(instant)) {
    throw new ExtractionArtifactReadError(
      'artifact_read_failed',
      `${field} must be a valid timestamp.`
    );
  }
  return instant;
}

export async function calculateExtractionArtifactSha256(body: Uint8Array): Promise<string> {
  if (!globalThis.crypto?.subtle) {
    throw new ExtractionArtifactReadError(
      'artifact_read_failed',
      'SHA-256 is unavailable in the current runtime.'
    );
  }

  const input = body.slice().buffer;
  const digest = await globalThis.crypto.subtle.digest('SHA-256', input);
  return Array.from(new Uint8Array(digest), (byte) => byte.toString(16).padStart(2, '0')).join('');
}

export async function readVerifiedExtractionArtifact(
  port: ExtractionArtifactReadPort,
  request: ExtractionArtifactReadRequest
): Promise<VerifiedExtractionArtifactRead> {
  assertArtifactReadAuthorization(request);

  const readAt = assertFiniteInstant(request.readAt, 'readAt');
  const expectedSize = request.artifact.sizeBytes;
  if (!Number.isSafeInteger(expectedSize) || expectedSize <= 0) {
    throw new ExtractionArtifactReadError(
      'artifact_size_mismatch',
      'Expected artifact size must be a positive safe integer.'
    );
  }
  if (!/^[0-9a-f]{64}$/.test(request.artifact.sha256)) {
    throw new ExtractionArtifactReadError(
      'artifact_digest_mismatch',
      'Expected artifact digest must be lowercase SHA-256 hex.'
    );
  }

  let result: ExtractionArtifactReadResult;
  try {
    result = await port.read(request);
  } catch (error) {
    if (error instanceof ExtractionArtifactReadError) {
      throw error;
    }
    throw new ExtractionArtifactReadError(
      'artifact_read_failed',
      'Artifact read failed without a governed error classification.'
    );
  }

  if (result.metadata.artifactId !== request.artifact.artifactId) {
    throw new ExtractionArtifactReadError(
      'artifact_identity_mismatch',
      'Artifact read returned a different governed artifact identity.'
    );
  }

  const expiresAt = assertFiniteInstant(result.metadata.expiresAt, 'expiresAt');
  if (readAt >= expiresAt) {
    throw new ExtractionArtifactReadError(
      'artifact_expired',
      'Artifact is unavailable because its governed retention window has expired.'
    );
  }

  if (
    result.metadata.sizeBytes !== expectedSize ||
    result.body.byteLength !== expectedSize ||
    result.metadata.sizeBytes !== result.body.byteLength
  ) {
    throw new ExtractionArtifactReadError(
      'artifact_size_mismatch',
      'Artifact read size does not match the C.2 integrity handoff.'
    );
  }

  const sha256 = await calculateExtractionArtifactSha256(result.body);
  if (sha256 !== request.artifact.sha256) {
    throw new ExtractionArtifactReadError(
      'artifact_digest_mismatch',
      'Artifact read digest does not match the C.2 integrity handoff.'
    );
  }

  return {
    artifact: request.artifact,
    mediaType: result.metadata.mediaType,
    expiresAt: result.metadata.expiresAt,
    sha256,
    body: result.body.slice(),
  };
}
