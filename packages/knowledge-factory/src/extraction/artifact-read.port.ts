import type {
  ExtractionArtifactRef,
  ExtractionAuthorizationEvidence,
  ExtractionRunRef,
  IngestionSourceVersionRef,
  ISODateTime,
} from '@profeplan/types';

export const EXTRACTION_ARTIFACT_READ_ERROR_CODES = [
  'authorization_denied',
  'artifact_unavailable',
  'artifact_expired',
  'artifact_identity_mismatch',
  'artifact_size_mismatch',
  'artifact_digest_mismatch',
  'artifact_read_failed',
] as const;

export type ExtractionArtifactReadErrorCode =
  (typeof EXTRACTION_ARTIFACT_READ_ERROR_CODES)[number];

export class ExtractionArtifactReadError extends Error {
  readonly code: ExtractionArtifactReadErrorCode;

  constructor(code: ExtractionArtifactReadErrorCode, message: string) {
    super(message);
    this.name = 'ExtractionArtifactReadError';
    this.code = code;
  }
}

export interface ExtractionArtifactReadRequest {
  readonly run: ExtractionRunRef;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly artifact: ExtractionArtifactRef;
  readonly authorizationEvidence: ExtractionAuthorizationEvidence & {
    readonly checkpoint: 'artifact_read';
  };
  readonly readAt: ISODateTime;
}

/**
 * Provider-neutral metadata visible to C.3. The concrete adapter resolves any
 * C.2 opaque locator internally and must not expose bucket names, signed URLs,
 * credentials or provider SDK objects through this boundary.
 */
export interface ExtractionArtifactReadMetadata {
  readonly artifactId: string;
  readonly sizeBytes: number;
  readonly mediaType: string;
  readonly expiresAt: ISODateTime;
}

export interface ExtractionArtifactReadResult {
  readonly metadata: ExtractionArtifactReadMetadata;
  readonly body: Uint8Array;
}

/**
 * Narrow read-only boundary for the governed C.2 artifact. Implementations may
 * resolve storage details internally, but C.3 receives only verified bytes and
 * provider-neutral metadata.
 */
export interface ExtractionArtifactReadPort {
  read(request: ExtractionArtifactReadRequest): Promise<ExtractionArtifactReadResult>;
}
