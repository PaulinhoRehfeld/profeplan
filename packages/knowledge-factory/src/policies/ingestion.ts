import type {
  IngestionAuthorizationEvidence,
  IngestionCommandReceipt,
  IngestionCommandReplayRecord,
  IngestionCommandType,
  IngestionHumanReview,
  IngestionRequest,
  IngestionRunState,
  IngestionSourceVersionRef,
} from '@profeplan/types';
import { allow, deny, type DomainDecision } from '../domain/result.ts';
import { reason, type DomainReason } from '../domain/reasons.ts';

const INGESTION_TRANSITIONS: Readonly<Record<IngestionRunState, readonly IngestionRunState[]>> = {
  REQUESTED: ['STAGING', 'REJECTED', 'FAILED', 'CANCELLED'],
  STAGING: ['STAGED', 'REJECTED', 'FAILED', 'CANCELLED'],
  STAGED: ['VERIFYING', 'REJECTED', 'FAILED', 'CANCELLED'],
  VERIFYING: ['VERIFIED', 'REJECTED', 'FAILED', 'CANCELLED'],
  VERIFIED: ['PENDING_REVIEW', 'REJECTED', 'FAILED', 'CANCELLED'],
  PENDING_REVIEW: ['APPROVED_FOR_EXTRACTION', 'REJECTED', 'FAILED', 'CANCELLED'],
  APPROVED_FOR_EXTRACTION: [],
  REJECTED: [],
  FAILED: [],
  CANCELLED: [],
};

export const INGESTION_COMMAND_TARGET_STATES: Readonly<
  Record<IngestionCommandType, IngestionRunState>
> = {
  request_ingestion: 'REQUESTED',
  begin_staging: 'STAGING',
  mark_staged: 'STAGED',
  begin_verification: 'VERIFYING',
  confirm_verified: 'VERIFIED',
  request_review: 'PENDING_REVIEW',
  approve_for_extraction: 'APPROVED_FOR_EXTRACTION',
  reject_ingestion: 'REJECTED',
  fail_ingestion: 'FAILED',
  cancel_ingestion: 'CANCELLED',
};

export function targetStateForIngestionCommand(
  commandType: IngestionCommandType
): IngestionRunState {
  return INGESTION_COMMAND_TARGET_STATES[commandType];
}

export function canTransitionIngestion(from: IngestionRunState, to: IngestionRunState): boolean {
  return INGESTION_TRANSITIONS[from].includes(to);
}

export interface IngestionTransitionInput {
  readonly currentState: IngestionRunState;
  readonly toState: IngestionRunState;
  readonly expectedState?: IngestionRunState;
}

export function evaluateIngestionTransition(
  input: IngestionTransitionInput
): DomainDecision<IngestionRunState> {
  if (input.expectedState !== undefined && input.expectedState !== input.currentState) {
    return deny([
      reason(
        'INGESTION_EXPECTED_STATE_MISMATCH',
        'Expected ingestion state does not match the current state.',
        undefined,
        { expectedState: input.expectedState, currentState: input.currentState }
      ),
    ]);
  }

  if (!canTransitionIngestion(input.currentState, input.toState)) {
    return deny([
      reason(
        'INGESTION_INVALID_TRANSITION',
        `Invalid ingestion transition: ${input.currentState} -> ${input.toState}.`
      ),
    ]);
  }

  return allow(input.toState);
}

export interface IngestionIdempotencyInput {
  readonly commandId: string;
  readonly fingerprint: string;
  readonly existing?: IngestionCommandReplayRecord;
}

export interface IngestionIdempotencyDecision {
  readonly outcome: 'new' | 'replay';
  readonly receipt?: IngestionCommandReceipt;
}

export function evaluateIngestionCommandIdempotency(
  input: IngestionIdempotencyInput
): DomainDecision<IngestionIdempotencyDecision> {
  if (input.existing === undefined || input.existing.commandId !== input.commandId) {
    return allow({ outcome: 'new' });
  }

  if (input.existing.fingerprint !== input.fingerprint) {
    return deny([
      reason(
        'INGESTION_IDEMPOTENCY_CONFLICT',
        'The ingestion command ID was already used with a different payload fingerprint.',
        input.commandId
      ),
    ]);
  }

  return allow({ outcome: 'replay', receipt: input.existing.receipt });
}

function hasAuthorizationEvidence(
  evidence: readonly IngestionAuthorizationEvidence[],
  sourceVersion: IngestionSourceVersionRef,
  purpose: IngestionAuthorizationEvidence['purpose']
): boolean {
  return evidence.some(
    (item) => item.sourceVersion.id === sourceVersion.id && item.purpose === purpose
  );
}

export function evaluateIngestionRequest(
  request: IngestionRequest
): DomainDecision<IngestionRequest> {
  const reasons: DomainReason[] = [];

  if (
    !hasAuthorizationEvidence(
      request.authorizationEvidence,
      request.sourceVersion,
      'temporary_staging'
    )
  ) {
    reasons.push(
      reason(
        'INGESTION_TEMPORARY_STAGING_AUTHORIZATION_REQUIRED',
        'Ingestion requires explicit temporary_staging authorization evidence.',
        request.sourceVersion.id
      )
    );
  }

  if (
    !hasAuthorizationEvidence(request.authorizationEvidence, request.sourceVersion, 'ingestion')
  ) {
    reasons.push(
      reason(
        'INGESTION_AUTHORIZATION_REQUIRED',
        'Ingestion requires explicit ingestion authorization evidence.',
        request.sourceVersion.id
      )
    );
  }

  return reasons.length === 0 ? allow(request) : deny(reasons);
}

export interface IngestionApprovalInput {
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly review?: IngestionHumanReview;
  readonly authorizationEvidence: readonly IngestionAuthorizationEvidence[];
}

export function evaluateIngestionApproval(
  input: IngestionApprovalInput
): DomainDecision<IngestionApprovalInput> {
  const reasons: DomainReason[] = [];

  if (input.review === undefined) {
    reasons.push(
      reason(
        'INGESTION_HUMAN_REVIEW_REQUIRED',
        'Human review is required before approval for extraction.',
        input.sourceVersion.id
      )
    );
  } else if (input.review.decision !== 'APPROVE_FOR_EXTRACTION') {
    reasons.push(
      reason(
        'INGESTION_HUMAN_REVIEW_NOT_APPROVED',
        'Human review did not approve the ingestion run for extraction.',
        input.review.reviewId
      )
    );
  }

  if (!hasAuthorizationEvidence(input.authorizationEvidence, input.sourceVersion, 'extraction')) {
    reasons.push(
      reason(
        'INGESTION_EXTRACTION_AUTHORIZATION_REQUIRED',
        'Approval for extraction requires independent extraction authorization evidence.',
        input.sourceVersion.id
      )
    );
  }

  return reasons.length === 0 ? allow(input) : deny(reasons);
}
