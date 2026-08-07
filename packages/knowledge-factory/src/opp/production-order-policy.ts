import type {
  ISODateTime,
  OppStatus,
  PedagogicalProductionOrder,
  SufficiencyResult,
  ValidationFinding,
} from '@profeplan/types';
import { domainEvent } from '../domain/events.ts';
import { allow, deny, type DomainDecision } from '../domain/result.ts';
import { reason, type DomainReason } from '../domain/reasons.ts';

const OPP_TRANSITIONS: Readonly<Record<OppStatus, readonly OppStatus[]>> = {
  requested: ['scoped', 'blocked', 'failed'],
  scoped: ['retrieving', 'blocked', 'failed'],
  retrieving: ['assembling', 'insufficient', 'blocked', 'failed'],
  assembling: ['validating', 'insufficient', 'failed'],
  validating: ['ready', 'insufficient', 'blocked', 'failed'],
  ready: [],
  insufficient: [],
  blocked: [],
  failed: [],
};

export interface OppTransitionInput {
  order: PedagogicalProductionOrder;
  toStatus: OppStatus;
  occurredAt: ISODateTime;
  sufficiency?: SufficiencyResult;
  findings?: readonly ValidationFinding[];
}

function isSufficient(result: SufficiencyResult | undefined): boolean {
  return Boolean(result?.sufficient && result.reasons.length === 0);
}

function hasBlockingFinding(findings: readonly ValidationFinding[] | undefined): boolean {
  return Boolean(
    findings?.some((finding) => finding.priority === 'must' && finding.status === 'open')
  );
}

export function evaluateOppTransition(input: OppTransitionInput): DomainDecision<OppStatus> {
  const { order, toStatus, occurredAt, sufficiency, findings } = input;
  const reasons: DomainReason[] = [];

  if (!OPP_TRANSITIONS[order.status].includes(toStatus)) {
    reasons.push(
      reason(
        'OPP_INVALID_TRANSITION',
        `Invalid OPP transition: ${order.status} -> ${toStatus}.`,
        order.id,
        { fromStatus: order.status, toStatus }
      )
    );
  }

  if (order.status === 'retrieving' && toStatus === 'assembling' && !isSufficient(sufficiency)) {
    reasons.push(
      reason('OPP_GATE_NOT_MET', 'Retrieval must be sufficient before context assembly.', order.id)
    );
  }

  if (toStatus === 'ready') {
    if (!isSufficient(sufficiency)) {
      reasons.push(
        reason('OPP_INSUFFICIENT', 'Insufficient context cannot become ready.', order.id)
      );
    }

    if (hasBlockingFinding(findings)) {
      reasons.push(
        reason('OPP_BLOCKING_FINDING', 'Open Must findings block OPP approval.', order.id)
      );
    }

    if (findings === undefined) {
      reasons.push(
        reason('OPP_GATE_NOT_MET', 'Validation findings must be supplied before approval.', order.id)
      );
    }
  }

  if (toStatus === 'insufficient' && sufficiency?.sufficient) {
    reasons.push(
      reason(
        'OPP_INSUFFICIENCY_NOT_CONFIRMED',
        'A sufficient retrieval result cannot be marked insufficient.',
        order.id
      )
    );
  }

  const event = domainEvent(
    reasons.length === 0 ? 'opp_transition_accepted' : 'opp_transition_rejected',
    'opp',
    order.id,
    occurredAt,
    { fromStatus: order.status, toStatus, eligible: reasons.length === 0 }
  );

  return reasons.length === 0 ? allow(toStatus, [event]) : deny(reasons, [event]);
}
