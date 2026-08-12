import type {
  GrantSourceAuthorizationCommand,
  SourceAuthorizationCommand,
  SourceRegistrationState,
} from '@profeplan/types';
import { allow, deny, type DomainDecision } from '../domain/result.ts';
import { reason, type DomainReason } from '../domain/reasons.ts';

function hasCompetentLegalActor(command: SourceAuthorizationCommand): boolean {
  return Boolean(
    command.actor?.actorId?.trim() && command.actor.role === 'legal_editorial_reviewer'
  );
}

function hasAuthorizationBasis(command: SourceAuthorizationCommand): boolean {
  return Boolean(command.basis?.id?.trim() && command.basis.kind);
}

export interface GrantSourceAuthorizationValidationInput {
  readonly command: GrantSourceAuthorizationCommand;
  readonly registrationState: SourceRegistrationState;
}

export function evaluateGrantSourceAuthorization(
  input: GrantSourceAuthorizationValidationInput
): DomainDecision<GrantSourceAuthorizationCommand> {
  const { command, registrationState } = input;
  const reasons: DomainReason[] = [];

  if (registrationState !== 'VALIDATED') {
    reasons.push(
      reason(
        registrationState === 'BLOCKED' ? 'SOURCE_REGISTRATION_BLOCKED' : 'SOURCE_NOT_VALIDATED',
        registrationState === 'BLOCKED'
          ? 'A blocked source cannot receive a productive authorization.'
          : 'Source identity and provenance must be validated before authorization is granted.',
        command.scope?.subject?.id
      )
    );
  }

  if (!command.actor?.actorId?.trim()) {
    reasons.push(reason('SOURCE_ACTOR_REQUIRED', 'Authorization decision requires an identified actor.'));
  } else if (!hasCompetentLegalActor(command)) {
    reasons.push(
      reason(
        'SOURCE_ACTOR_ROLE_FORBIDDEN',
        'Only a legal/editorial reviewer may grant source authorization.',
        command.actor.actorId,
        { role: command.actor.role }
      )
    );
  }

  if (!hasAuthorizationBasis(command)) {
    reasons.push(
      reason(
        'SOURCE_AUTHORIZATION_BASIS_REQUIRED',
        'Authorization grant requires an identifiable normative or contractual basis.',
        command.scope?.subject?.id
      )
    );
  }

  if (!command.scope?.subject?.id?.trim() || !command.scope.purpose) {
    reasons.push(
      reason(
        'SOURCE_GOVERNANCE_INFORMATION_MISSING',
        'Authorization grant requires an explicit subject and purpose.'
      )
    );
  }

  const effectiveFrom = Date.parse(command.effectiveFrom);
  const effectiveUntil =
    command.effectiveUntil === undefined ? undefined : Date.parse(command.effectiveUntil);

  if (
    !Number.isFinite(effectiveFrom) ||
    (effectiveUntil !== undefined &&
      (!Number.isFinite(effectiveUntil) || effectiveUntil < effectiveFrom))
  ) {
    reasons.push(
      reason(
        'SOURCE_INVALID_EFFECTIVE_WINDOW',
        'Authorization effectiveUntil must be equal to or later than effectiveFrom.'
      )
    );
  }

  return reasons.length === 0 ? allow(command) : deny(reasons);
}

export function evaluateSourceAuthorizationCommandAuthority(
  command: SourceAuthorizationCommand
): DomainDecision<SourceAuthorizationCommand> {
  const reasons: DomainReason[] = [];

  if (!command.actor?.actorId?.trim()) {
    reasons.push(reason('SOURCE_ACTOR_REQUIRED', 'Authorization decision requires an identified actor.'));
  } else if (!hasCompetentLegalActor(command)) {
    reasons.push(
      reason(
        'SOURCE_ACTOR_ROLE_FORBIDDEN',
        'Authorization lifecycle changes require a legal/editorial reviewer.',
        command.actor.actorId,
        { role: command.actor.role }
      )
    );
  }

  if (!hasAuthorizationBasis(command)) {
    reasons.push(
      reason(
        'SOURCE_AUTHORIZATION_BASIS_REQUIRED',
        'Authorization lifecycle changes require an identifiable basis.',
        command.scope?.subject?.id
      )
    );
  }

  return reasons.length === 0 ? allow(command) : deny(reasons);
}
