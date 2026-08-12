import type {
  EntityId,
  ISODateTime,
  SourceAuthorizationEvent,
  SourceAuthorizationState,
  SourcePurpose,
  SourceRegistrationEvent,
} from '@profeplan/types';
import { reason, type DomainReason } from '../domain/reasons.ts';

export interface GovernedSourceEligibilityInput {
  readonly sourceVersionId: EntityId;
  readonly purpose: SourcePurpose;
  readonly instant: ISODateTime;
  readonly registrationEvents: readonly SourceRegistrationEvent[];
  readonly authorizationEvents: readonly SourceAuthorizationEvent[];
}

export type GovernedSourceEligibilityDecision =
  | {
      readonly status: 'ELIGIBLE';
      readonly sourceVersionId: EntityId;
      readonly purpose: SourcePurpose;
      readonly instant: ISODateTime;
      readonly authorizationId: EntityId;
    }
  | {
      readonly status: 'INELIGIBLE';
      readonly sourceVersionId: EntityId;
      readonly purpose: SourcePurpose;
      readonly instant: ISODateTime;
      readonly reasons: readonly DomainReason[];
    };

function compareEvents(
  left: { effectiveAt: ISODateTime; sequence: number; eventId: EntityId },
  right: { effectiveAt: ISODateTime; sequence: number; eventId: EntityId }
): number {
  const byEffectiveAt = Date.parse(left.effectiveAt) - Date.parse(right.effectiveAt);
  if (byEffectiveAt !== 0) {
    return byEffectiveAt;
  }

  const bySequence = left.sequence - right.sequence;
  return bySequence === 0 ? left.eventId.localeCompare(right.eventId) : bySequence;
}

function eventsEffectiveAsOf<T extends { effectiveAt: ISODateTime }>(
  events: readonly T[],
  instantMs: number
): T[] {
  return events.filter((event) => {
    const effectiveAt = Date.parse(event.effectiveAt);
    return Number.isFinite(effectiveAt) && effectiveAt <= instantMs;
  });
}

function uniqueReasons(reasons: readonly DomainReason[]): readonly DomainReason[] {
  const seen = new Set<string>();
  return reasons.filter((item) => {
    const key = `${item.code}:${item.subjectId ?? ''}`;
    if (seen.has(key)) {
      return false;
    }
    seen.add(key);
    return true;
  });
}

function registrationReason(state: string | undefined, sourceVersionId: EntityId): DomainReason {
  if (state === 'BLOCKED') {
    return reason(
      'SOURCE_REGISTRATION_BLOCKED',
      'Source registration is blocked for new uses.',
      sourceVersionId
    );
  }

  return reason(
    'SOURCE_NOT_VALIDATED',
    'Source identity and provenance are not validated for productive use.',
    sourceVersionId,
    state === undefined ? undefined : { registrationState: state }
  );
}

function authorizationStateReason(
  state: SourceAuthorizationState,
  authorizationId: EntityId
): DomainReason {
  switch (state) {
    case 'SUSPENDED':
      return reason(
        'SOURCE_AUTHORIZATION_SUSPENDED',
        'Source authorization is suspended at the requested instant.',
        authorizationId
      );
    case 'REVOKED':
      return reason(
        'SOURCE_AUTHORIZATION_REVOKED',
        'Source authorization is revoked at the requested instant.',
        authorizationId
      );
    case 'EXPIRED':
      return reason(
        'SOURCE_AUTHORIZATION_EXPIRED',
        'Source authorization is expired at the requested instant.',
        authorizationId
      );
    case 'BLOCKED':
      return reason(
        'SOURCE_AUTHORIZATION_BLOCKED',
        'Source authorization is blocked for the requested purpose.',
        authorizationId
      );
    case 'SUPERSEDED':
      return reason(
        'SOURCE_AUTHORIZATION_SUPERSEDED',
        'Source authorization has been superseded by another formal decision.',
        authorizationId
      );
    case 'PENDING_REVIEW':
      return reason(
        'SOURCE_PURPOSE_NOT_AUTHORIZED',
        'Authorization review has not granted the requested purpose.',
        authorizationId
      );
    case 'GRANTED':
      return reason(
        'SOURCE_GOVERNANCE_INFORMATION_MISSING',
        'Granted authorization could not be evaluated from the supplied history.',
        authorizationId
      );
  }
}

export function evaluateGovernedSourceEligibility(
  input: GovernedSourceEligibilityInput
): GovernedSourceEligibilityDecision {
  const instantMs = Date.parse(input.instant);

  if (!Number.isFinite(instantMs)) {
    return {
      status: 'INELIGIBLE',
      sourceVersionId: input.sourceVersionId,
      purpose: input.purpose,
      instant: input.instant,
      reasons: [
        reason(
          'SOURCE_INVALID_QUERY_INSTANT',
          'Eligibility query requires a valid explicit instant.',
          input.sourceVersionId
        ),
      ],
    };
  }

  const registrationEvents = eventsEffectiveAsOf(
    input.registrationEvents.filter((event) => event.subject.id === input.sourceVersionId),
    instantMs
  ).sort(compareEvents);
  const registrationState = registrationEvents.at(-1)?.toState;

  if (registrationState !== 'VALIDATED') {
    return {
      status: 'INELIGIBLE',
      sourceVersionId: input.sourceVersionId,
      purpose: input.purpose,
      instant: input.instant,
      reasons: [registrationReason(registrationState, input.sourceVersionId)],
    };
  }

  const matchingAuthorizationEvents = input.authorizationEvents.filter(
    (event) =>
      event.scope.subject.id === input.sourceVersionId && event.scope.purpose === input.purpose
  );

  if (matchingAuthorizationEvents.length === 0) {
    return {
      status: 'INELIGIBLE',
      sourceVersionId: input.sourceVersionId,
      purpose: input.purpose,
      instant: input.instant,
      reasons: [
        reason(
          'SOURCE_PURPOSE_NOT_AUTHORIZED',
          'No authorization exists for the requested source version and purpose.',
          input.sourceVersionId,
          { purpose: input.purpose }
        ),
      ],
    };
  }

  const byAuthorization = new Map<EntityId, SourceAuthorizationEvent[]>();
  for (const event of matchingAuthorizationEvents) {
    const events = byAuthorization.get(event.authorizationId) ?? [];
    events.push(event);
    byAuthorization.set(event.authorizationId, events);
  }

  const ineligibleReasons: DomainReason[] = [];

  for (const [authorizationId, timeline] of byAuthorization) {
    const effectiveTimeline = eventsEffectiveAsOf(timeline, instantMs).sort(compareEvents);
    const latest = effectiveTimeline.at(-1);

    if (latest === undefined) {
      continue;
    }

    const effectiveFrom = Date.parse(latest.effectiveFrom);
    const effectiveUntil =
      latest.effectiveUntil === undefined ? undefined : Date.parse(latest.effectiveUntil);

    if (!Number.isFinite(effectiveFrom)) {
      ineligibleReasons.push(
        reason(
          'SOURCE_GOVERNANCE_INFORMATION_MISSING',
          'Authorization history has no valid effectiveFrom instant.',
          authorizationId
        )
      );
      continue;
    }

    if (instantMs < effectiveFrom) {
      ineligibleReasons.push(
        reason(
          'SOURCE_AUTHORIZATION_NOT_YET_EFFECTIVE',
          'Source authorization is not yet effective at the requested instant.',
          authorizationId
        )
      );
      continue;
    }

    if (
      effectiveUntil !== undefined &&
      Number.isFinite(effectiveUntil) &&
      instantMs > effectiveUntil
    ) {
      ineligibleReasons.push(
        reason(
          'SOURCE_AUTHORIZATION_EXPIRED',
          'Source authorization effective window ended before the requested instant.',
          authorizationId
        )
      );
      continue;
    }

    if (latest.toState === 'GRANTED') {
      return {
        status: 'ELIGIBLE',
        sourceVersionId: input.sourceVersionId,
        purpose: input.purpose,
        instant: input.instant,
        authorizationId,
      };
    }

    ineligibleReasons.push(authorizationStateReason(latest.toState, authorizationId));
  }

  return {
    status: 'INELIGIBLE',
    sourceVersionId: input.sourceVersionId,
    purpose: input.purpose,
    instant: input.instant,
    reasons:
      ineligibleReasons.length === 0
        ? [
            reason(
              'SOURCE_PURPOSE_NOT_AUTHORIZED',
              'No authorization was effective for the requested purpose at the requested instant.',
              input.sourceVersionId,
              { purpose: input.purpose }
            ),
          ]
        : uniqueReasons(ineligibleReasons),
  };
}
