import type {
  SourceAuthorizationState,
  SourceCommandReceipt,
  SourceCommandReplayRecord,
  SourceRegistrationState,
  VersionTag,
} from '@profeplan/types';
import { allow, deny, type DomainDecision } from '../domain/result.ts';
import { reason, type DomainReason } from '../domain/reasons.ts';

const REGISTRATION_TRANSITIONS: Readonly<
  Record<SourceRegistrationState, readonly SourceRegistrationState[]>
> = {
  REGISTERED: ['PENDING_VALIDATION', 'BLOCKED', 'ARCHIVED'],
  PENDING_VALIDATION: ['VALIDATED', 'BLOCKED', 'ARCHIVED'],
  VALIDATED: ['BLOCKED', 'REPLACED', 'ARCHIVED'],
  BLOCKED: ['PENDING_VALIDATION', 'REPLACED', 'ARCHIVED'],
  REPLACED: ['ARCHIVED'],
  ARCHIVED: [],
};

const AUTHORIZATION_TRANSITIONS: Readonly<
  Record<SourceAuthorizationState, readonly SourceAuthorizationState[]>
> = {
  PENDING_REVIEW: ['GRANTED', 'BLOCKED', 'SUPERSEDED'],
  GRANTED: ['SUSPENDED', 'REVOKED', 'EXPIRED', 'SUPERSEDED'],
  SUSPENDED: ['GRANTED', 'REVOKED', 'EXPIRED', 'BLOCKED', 'SUPERSEDED'],
  REVOKED: [],
  EXPIRED: [],
  BLOCKED: ['SUPERSEDED'],
  SUPERSEDED: [],
};

export function canTransitionSourceRegistration(
  from: SourceRegistrationState,
  to: SourceRegistrationState
): boolean {
  return REGISTRATION_TRANSITIONS[from].includes(to);
}

export function canTransitionSourceAuthorization(
  from: SourceAuthorizationState,
  to: SourceAuthorizationState
): boolean {
  return AUTHORIZATION_TRANSITIONS[from].includes(to);
}

export interface SourceRegistrationTransitionInput {
  readonly currentState: SourceRegistrationState;
  readonly toState: SourceRegistrationState;
  readonly expectedState?: SourceRegistrationState;
}

export function evaluateSourceRegistrationTransition(
  input: SourceRegistrationTransitionInput
): DomainDecision<SourceRegistrationState> {
  if (input.expectedState !== undefined && input.expectedState !== input.currentState) {
    return deny([
      reason(
        'SOURCE_EXPECTED_STATE_MISMATCH',
        'Expected source registration state does not match the current state.',
        undefined,
        { expectedState: input.expectedState, currentState: input.currentState }
      ),
    ]);
  }

  if (!canTransitionSourceRegistration(input.currentState, input.toState)) {
    return deny([
      reason(
        'SOURCE_INVALID_REGISTRATION_TRANSITION',
        `Invalid source registration transition: ${input.currentState} -> ${input.toState}.`
      ),
    ]);
  }

  return allow(input.toState);
}

export interface SourceAuthorizationTransitionInput {
  readonly currentState: SourceAuthorizationState;
  readonly toState: SourceAuthorizationState;
  readonly expectedState?: SourceAuthorizationState;
}

export function evaluateSourceAuthorizationTransition(
  input: SourceAuthorizationTransitionInput
): DomainDecision<SourceAuthorizationState> {
  if (input.expectedState !== undefined && input.expectedState !== input.currentState) {
    return deny([
      reason(
        'SOURCE_EXPECTED_STATE_MISMATCH',
        'Expected source authorization state does not match the current state.',
        undefined,
        { expectedState: input.expectedState, currentState: input.currentState }
      ),
    ]);
  }

  if (!canTransitionSourceAuthorization(input.currentState, input.toState)) {
    return deny([
      reason(
        'SOURCE_INVALID_AUTHORIZATION_TRANSITION',
        `Invalid source authorization transition: ${input.currentState} -> ${input.toState}.`
      ),
    ]);
  }

  return allow(input.toState);
}

export interface SourceIdempotencyInput {
  readonly commandId: string;
  readonly fingerprint: string;
  readonly existing?: SourceCommandReplayRecord;
}

export interface SourceIdempotencyDecision {
  readonly outcome: 'new' | 'replay';
  readonly receipt?: SourceCommandReceipt;
}

export function evaluateSourceCommandIdempotency(
  input: SourceIdempotencyInput
): DomainDecision<SourceIdempotencyDecision> {
  if (input.existing === undefined) {
    return allow({ outcome: 'new' });
  }

  if (input.existing.commandId !== input.commandId) {
    return allow({ outcome: 'new' });
  }

  if (input.existing.fingerprint !== input.fingerprint) {
    return deny([
      reason(
        'SOURCE_IDEMPOTENCY_CONFLICT',
        'The command ID was already used with a different payload fingerprint.',
        input.commandId
      ),
    ]);
  }

  return allow({ outcome: 'replay', receipt: input.existing.receipt });
}

export interface SourceOptimisticConcurrencyInput {
  readonly expectedVersion?: VersionTag;
  readonly currentVersion: VersionTag;
  readonly expectedSequence?: number;
  readonly currentSequence: number;
}

export function evaluateSourceOptimisticConcurrency(
  input: SourceOptimisticConcurrencyInput
): DomainDecision<SourceOptimisticConcurrencyInput> {
  const reasons: DomainReason[] = [];

  if (input.expectedVersion !== undefined && input.expectedVersion !== input.currentVersion) {
    reasons.push(
      reason(
        'SOURCE_EXPECTED_VERSION_MISMATCH',
        'Expected aggregate version does not match the current version.',
        undefined,
        { expectedVersion: input.expectedVersion, currentVersion: input.currentVersion }
      )
    );
  }

  if (input.expectedSequence !== undefined && input.expectedSequence !== input.currentSequence) {
    reasons.push(
      reason(
        'SOURCE_EXPECTED_SEQUENCE_MISMATCH',
        'Expected aggregate sequence does not match the current sequence.',
        undefined,
        { expectedSequence: input.expectedSequence, currentSequence: input.currentSequence }
      )
    );
  }

  return reasons.length === 0 ? allow(input) : deny(reasons);
}
