import type { EntityId, ISODateTime } from './common.ts';
import type {
  IngestionReceivedFileRef,
  IngestionRunRef,
  IngestionSourceVersionRef,
} from './ingestion.ts';

export const INTEGRITY_CONTRACT_VERSION = '1.0.0' as const;

export const INTEGRITY_DIGEST_ALGORITHMS = ['sha-256'] as const;
export type IntegrityDigestAlgorithm = (typeof INTEGRITY_DIGEST_ALGORITHMS)[number];

export interface BinaryDigest {
  readonly algorithm: IntegrityDigestAlgorithm;
  /** Lowercase hexadecimal representation of the digest bytes. */
  readonly value: string;
}

export interface TemporaryStagingIntegrityEvidence {
  readonly contractVersion: typeof INTEGRITY_CONTRACT_VERSION;
  readonly artifactId: EntityId;
  readonly run: IngestionRunRef;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly receivedFile: IngestionReceivedFileRef;
  readonly digest: BinaryDigest;
  /** Number of bytes physically observed during staging readback. */
  readonly byteLength: number;
  readonly verifiedAt: ISODateTime;
  readonly correlationId: EntityId;
}

export const BINARY_DUPLICATE_RELATIONSHIPS = [
  'same_artifact',
  'same_run',
  'same_source_version',
  'cross_source_version',
] as const;
export type BinaryDuplicateRelationship = (typeof BINARY_DUPLICATE_RELATIONSHIPS)[number];

export interface BinaryDuplicateMatch {
  readonly relationship: BinaryDuplicateRelationship;
  readonly artifactId: EntityId;
  readonly run: IngestionRunRef;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly receivedFile: IngestionReceivedFileRef;
}

export const BINARY_DUPLICATE_OUTCOMES = ['unique', 'duplicate'] as const;
export type BinaryDuplicateOutcome = (typeof BINARY_DUPLICATE_OUTCOMES)[number];

export interface BinaryDuplicateDecision {
  readonly contractVersion: typeof INTEGRITY_CONTRACT_VERSION;
  readonly digest: BinaryDigest;
  readonly outcome: BinaryDuplicateOutcome;
  /**
   * Binary equality is audit information only. It never means bibliographic,
   * legal, editorial or semantic equivalence and never merges identities.
   */
  readonly matches: readonly BinaryDuplicateMatch[];
  readonly evaluatedAt: ISODateTime;
}
