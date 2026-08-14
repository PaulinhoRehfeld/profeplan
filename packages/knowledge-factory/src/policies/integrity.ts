import type {
  BinaryDigest,
  BinaryDuplicateDecision,
  BinaryDuplicateMatch,
  BinaryDuplicateRelationship,
  ISODateTime,
  TemporaryStagingArtifactDescriptor,
  TemporaryStagingIntegrityEvidence,
  VerifiedTemporaryStagingArtifactDescriptor,
} from '@profeplan/types';
import { allow, deny, type DomainDecision } from '../domain/result.ts';
import { reason, type DomainReason } from '../domain/reasons.ts';
import { evaluateStagingArtifactAvailability } from './staging.ts';

const SHA_256_HEX = /^[0-9a-f]{64}$/u;

export interface StagingIntegrityEvaluationInput {
  readonly artifact: TemporaryStagingArtifactDescriptor;
  readonly evidence: TemporaryStagingIntegrityEvidence;
  readonly knownEvidence?: readonly TemporaryStagingIntegrityEvidence[];
  readonly evaluatedAt: ISODateTime;
}

function parseInstant(value: ISODateTime): number | undefined {
  const parsed = Date.parse(value);
  return Number.isFinite(parsed) ? parsed : undefined;
}

function sameDigest(left: BinaryDigest, right: BinaryDigest): boolean {
  return left.algorithm === right.algorithm && left.value === right.value;
}

function relationFor(
  current: TemporaryStagingIntegrityEvidence,
  known: TemporaryStagingIntegrityEvidence
): BinaryDuplicateRelationship {
  if (current.artifactId === known.artifactId && current.run.id === known.run.id) {
    return 'same_artifact';
  }
  if (current.run.id === known.run.id) {
    return 'same_run';
  }
  if (current.sourceVersion.id === known.sourceVersion.id) {
    return 'same_source_version';
  }
  return 'cross_source_version';
}

function toDuplicateMatch(
  current: TemporaryStagingIntegrityEvidence,
  known: TemporaryStagingIntegrityEvidence
): BinaryDuplicateMatch {
  return {
    relationship: relationFor(current, known),
    artifactId: known.artifactId,
    run: known.run,
    sourceVersion: known.sourceVersion,
    receivedFile: known.receivedFile,
  };
}

function bindingReasons(
  artifact: TemporaryStagingArtifactDescriptor,
  evidence: TemporaryStagingIntegrityEvidence
): DomainReason[] {
  const reasons: DomainReason[] = [];

  if (
    evidence.artifactId !== artifact.artifact.artifactId ||
    evidence.run.id !== artifact.run.id ||
    evidence.sourceVersion.id !== artifact.sourceVersion.id ||
    evidence.receivedFile.id !== artifact.receivedFile.id
  ) {
    reasons.push(
      reason(
        'STAGING_INTEGRITY_BINDING_MISMATCH',
        'Integrity evidence does not match the staged artifact identity bindings.',
        artifact.artifact.artifactId
      )
    );
  }

  return reasons;
}

function digestReasons(evidence: TemporaryStagingIntegrityEvidence): DomainReason[] {
  const reasons: DomainReason[] = [];

  if (evidence.digest.algorithm !== 'sha-256') {
    reasons.push(
      reason(
        'STAGING_INTEGRITY_ALGORITHM_UNSUPPORTED',
        'The integrity digest algorithm is not supported by this contract version.',
        evidence.artifactId
      )
    );
  }

  if (!SHA_256_HEX.test(evidence.digest.value)) {
    reasons.push(
      reason(
        'STAGING_INTEGRITY_DIGEST_INVALID',
        'The integrity digest is not a canonical lowercase SHA-256 hexadecimal value.',
        evidence.artifactId
      )
    );
  }

  return reasons;
}

function verificationTimeReasons(
  artifact: TemporaryStagingArtifactDescriptor,
  evidence: TemporaryStagingIntegrityEvidence,
  evaluatedAt: ISODateTime
): DomainReason[] {
  const createdAt = parseInstant(artifact.createdAt);
  const verifiedAt = parseInstant(evidence.verifiedAt);
  const evaluated = parseInstant(evaluatedAt);
  const expiresAt = parseInstant(artifact.expiresAt);

  if (
    createdAt === undefined ||
    verifiedAt === undefined ||
    evaluated === undefined ||
    expiresAt === undefined ||
    verifiedAt < createdAt ||
    verifiedAt > evaluated ||
    verifiedAt >= expiresAt
  ) {
    return [
      reason(
        'STAGING_INTEGRITY_VERIFICATION_TIME_INVALID',
        'Integrity verification time is invalid for the staged artifact lifecycle.',
        artifact.artifact.artifactId
      ),
    ];
  }

  return [];
}

function historicalConflictReasons(
  evidence: TemporaryStagingIntegrityEvidence,
  knownEvidence: readonly TemporaryStagingIntegrityEvidence[]
): DomainReason[] {
  const conflicting = knownEvidence.find(
    (known) =>
      known.artifactId === evidence.artifactId &&
      known.run.id === evidence.run.id &&
      !sameDigest(known.digest, evidence.digest)
  );

  if (conflicting === undefined) {
    return [];
  }

  return [
    reason(
      'STAGING_INTEGRITY_DIGEST_CONFLICT',
      'The same staged artifact has previously been observed with a different digest.',
      evidence.artifactId
    ),
  ];
}

export function classifyBinaryDuplication(
  evidence: TemporaryStagingIntegrityEvidence,
  knownEvidence: readonly TemporaryStagingIntegrityEvidence[],
  evaluatedAt: ISODateTime
): BinaryDuplicateDecision {
  const matches = knownEvidence
    .filter((known) => sameDigest(known.digest, evidence.digest))
    .map((known) => toDuplicateMatch(evidence, known));

  return {
    contractVersion: '1.0.0',
    digest: evidence.digest,
    outcome: matches.length === 0 ? 'unique' : 'duplicate',
    matches,
    evaluatedAt,
  };
}

/**
 * Materializes the technical STAGED -> VERIFIED artifact transition.
 *
 * VERIFIED means that the stored bytes were read back and cryptographically
 * observed with valid bindings. It does not mean human approval, bibliographic
 * identity, editorial equivalence, semantic equality or release for extraction.
 */
export function evaluateStagingIntegrity(
  input: StagingIntegrityEvaluationInput
): DomainDecision<VerifiedTemporaryStagingArtifactDescriptor> {
  const availability = evaluateStagingArtifactAvailability(input.artifact, input.evaluatedAt);
  if (!availability.allowed) {
    return deny(availability.reasons);
  }

  const knownEvidence = input.knownEvidence ?? [];
  const reasons: DomainReason[] = [
    ...bindingReasons(input.artifact, input.evidence),
    ...digestReasons(input.evidence),
    ...verificationTimeReasons(input.artifact, input.evidence, input.evaluatedAt),
    ...historicalConflictReasons(input.evidence, knownEvidence),
  ];

  if (input.evidence.byteLength !== input.artifact.sizeBytes) {
    reasons.push(
      reason(
        'STAGING_INTEGRITY_BYTE_LENGTH_MISMATCH',
        'The physically observed byte length differs from the staged artifact descriptor.',
        input.artifact.artifact.artifactId,
        {
          expectedByteLength: input.artifact.sizeBytes,
          observedByteLength: input.evidence.byteLength,
        }
      )
    );
  }

  if (reasons.length > 0) {
    return deny(reasons);
  }

  const duplicateDecision = classifyBinaryDuplication(
    input.evidence,
    knownEvidence,
    input.evaluatedAt
  );

  return allow({
    ...input.artifact,
    state: 'VERIFIED',
    integrity: input.evidence,
    duplicateDecision,
  });
}
