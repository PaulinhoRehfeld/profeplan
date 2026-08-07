import type {
  ISODateTime,
  PedagogicalComponentStatus,
  PedagogicalComponentVersion,
} from '@profeplan/types';
import { domainEvent } from '../domain/events.ts';
import { allow, deny, type DomainDecision } from '../domain/result.ts';
import { reason } from '../domain/reasons.ts';

export const COMPONENT_TRANSITIONS: Readonly<
  Record<PedagogicalComponentStatus, readonly PedagogicalComponentStatus[]>
> = {
  draft: ['in_review', 'blocked', 'archived'],
  in_review: ['approved', 'rejected', 'blocked', 'archived'],
  approved: ['suspended', 'superseded', 'blocked', 'archived'],
  rejected: ['archived'],
  superseded: ['archived'],
  suspended: ['in_review', 'blocked', 'archived'],
  blocked: ['archived'],
  archived: [],
};

export interface ComponentTransitionInput {
  version: PedagogicalComponentVersion;
  toStatus: PedagogicalComponentStatus;
  occurredAt: ISODateTime;
}

export function canTransitionComponent(
  from: PedagogicalComponentStatus,
  to: PedagogicalComponentStatus
): boolean {
  return COMPONENT_TRANSITIONS[from].includes(to);
}

export function evaluateComponentTransition(
  input: ComponentTransitionInput
): DomainDecision<PedagogicalComponentStatus> {
  const { version, toStatus, occurredAt } = input;
  const allowed = canTransitionComponent(version.status, toStatus);
  const event = domainEvent(
    allowed ? 'component_transition_accepted' : 'component_transition_rejected',
    'component',
    version.componentId,
    occurredAt,
    { fromStatus: version.status, toStatus }
  );

  if (!allowed) {
    return deny(
      [
        reason(
          'COMPONENT_INVALID_TRANSITION',
          `Invalid component transition: ${version.status} -> ${toStatus}.`,
          version.componentId,
          { fromStatus: version.status, toStatus }
        ),
      ],
      [event]
    );
  }

  return allow(toStatus, [event]);
}
