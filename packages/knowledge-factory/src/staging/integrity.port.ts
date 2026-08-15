import type {
  EntityId,
  IntegrityDigestAlgorithm,
  TemporaryStagingArtifactDescriptor,
  TemporaryStagingIntegrityEvidence,
} from '@profeplan/types';

export interface TemporaryStagingIntegrityVerificationCommand {
  readonly artifact: TemporaryStagingArtifactDescriptor;
  readonly algorithm: IntegrityDigestAlgorithm;
  readonly correlationId: EntityId;
}

/**
 * Provider-neutral boundary for proving the bytes that are physically present
 * in temporary staging. Implementations must calculate the digest from a
 * readback of the stored object, not merely from the original upload payload.
 */
export interface TemporaryStagingIntegrityPort {
  verify(
    input: TemporaryStagingIntegrityVerificationCommand
  ): Promise<TemporaryStagingIntegrityEvidence>;
}
