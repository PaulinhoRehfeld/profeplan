import type {
  PrepareIngestionStagingArtifact,
  StagingRecoveryAction,
  TemporaryStagingRecoveryProbe,
} from '@profeplan/types';
import { allow, deny, type DomainDecision } from '../domain/result.ts';
import { reason } from '../domain/reasons.ts';

function parseInstant(value: string): number | undefined {
  const parsed = Date.parse(value);
  return Number.isFinite(parsed) ? parsed : undefined;
}

function sameDigest(
  left: PrepareIngestionStagingArtifact['writeIntentDigest'],
  right: Extract<TemporaryStagingRecoveryProbe, { outcome: 'present' }>['observedDigest']
): boolean {
  return left.algorithm === right.algorithm && left.value === right.value;
}

export interface StagingRecoveryEvaluationInput {
  readonly preparation: PrepareIngestionStagingArtifact;
  readonly probe: TemporaryStagingRecoveryProbe;
  readonly evaluatedAt: string;
}

/**
 * Reconciles an ambiguous staging write without trusting provider-specific
 * semantics. An absent object can be retried; an observed object can only be
 * reused when its identity, byte length and digest match the persisted write
 * intent and the original retention window is still valid.
 */
export function evaluateStagingRecoveryProbe(
  input: StagingRecoveryEvaluationInput
): DomainDecision<StagingRecoveryAction> {
  const evaluatedAt = parseInstant(input.evaluatedAt);
  const expiresAt = parseInstant(input.preparation.expiresAt);

  if (evaluatedAt === undefined || expiresAt === undefined || evaluatedAt >= expiresAt) {
    return deny([
      reason(
        'STAGING_ARTIFACT_EXPIRED',
        'The temporary staging artifact has expired and cannot be recovered.',
        input.preparation.artifactId
      ),
    ]);
  }

  if (
    input.probe.run.id !== input.preparation.run.id ||
    (input.probe.outcome === 'absent'
      ? input.probe.artifactId !== input.preparation.artifactId
      : input.probe.artifact.artifactId !== input.preparation.artifactId)
  ) {
    return deny([
      reason(
        'STAGING_RECOVERY_BINDING_MISMATCH',
        'The recovery observation does not match the persisted staging identity.',
        input.preparation.artifactId
      ),
    ]);
  }

  if (input.probe.outcome === 'absent') {
    return allow({ outcome: 'retry_upload' });
  }

  if (
    input.probe.observedSizeBytes !== input.preparation.sizeBytes ||
    !sameDigest(input.preparation.writeIntentDigest, input.probe.observedDigest)
  ) {
    return deny([
      reason(
        'STAGING_RECOVERY_OBJECT_CONFLICT',
        'The observed staging object differs from the persisted write intent.',
        input.preparation.artifactId,
        {
          expectedByteLength: input.preparation.sizeBytes,
          observedByteLength: input.probe.observedSizeBytes,
        }
      ),
    ]);
  }

  return allow({
    outcome: 'reuse_existing',
    artifact: input.probe.artifact,
    observedDigest: input.probe.observedDigest,
    observedSizeBytes: input.probe.observedSizeBytes,
  });
}
