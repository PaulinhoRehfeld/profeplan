import type {
  EntityId,
  IngestionRunRef,
  TemporaryStagingRecoveryProbe,
} from '@profeplan/types';

export interface TemporaryStagingRecoveryProbeCommand {
  readonly artifactId: EntityId;
  readonly run: IngestionRunRef;
  readonly correlationId: EntityId;
}

/**
 * Provider-neutral probe used only to reconcile an ambiguous external write.
 * It observes the physical object; it does not decide whether that object is
 * safe to reuse. The domain recovery policy owns that decision.
 */
export interface TemporaryStagingRecoveryPort {
  inspect(input: TemporaryStagingRecoveryProbeCommand): Promise<TemporaryStagingRecoveryProbe>;
}
