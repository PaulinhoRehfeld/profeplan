import type {
  ISODateTime,
  KnowledgeSource,
  SourcePermissionEvent,
  SourceUse,
} from '@profeplan/types';
import { domainEvent } from '../domain/events.ts';
import { allow, deny, type DomainDecision } from '../domain/result.ts';
import { reason, type DomainReason } from '../domain/reasons.ts';

export interface SourceEligibilityInput {
  source: KnowledgeSource;
  use: SourceUse;
  permissionEvents?: readonly SourcePermissionEvent[];
  occurredAt: ISODateTime;
}

function latestPermissionEvent(
  events: readonly SourcePermissionEvent[],
  sourceId: string,
  use: SourceUse
): SourcePermissionEvent | undefined {
  return events
    .filter((event) => event.sourceId === sourceId && event.use === use)
    .slice()
    .sort((a, b) => {
      const byTime = a.occurredAt.localeCompare(b.occurredAt);
      return byTime === 0 ? a.version.localeCompare(b.version) : byTime;
    })
    .at(-1);
}

export function evaluateSourceEligibility(
  input: SourceEligibilityInput
): DomainDecision<KnowledgeSource> {
  const { source, use, occurredAt } = input;
  const reasons: DomainReason[] = [];

  if (source.status !== 'approved') {
    reasons.push(reason('SOURCE_NOT_APPROVED', 'Source must be approved for productive use.', source.id));
  }

  if (!source.allowedUses.includes(use)) {
    reasons.push(
      reason('SOURCE_USE_NOT_ALLOWED', `Source does not allow use: ${use}.`, source.id, { use })
    );
  }

  const incompatibleLicense =
    (source.licenseCategory === 'restricted' || source.licenseCategory === 'unknown') &&
    use !== 'internal_review';

  if (incompatibleLicense) {
    reasons.push(
      reason(
        'SOURCE_LICENSE_INCOMPATIBLE',
        `License category ${source.licenseCategory} is incompatible with use ${use}.`,
        source.id,
        { licenseCategory: source.licenseCategory, use }
      )
    );
  }

  const permissionEvent = latestPermissionEvent(input.permissionEvents ?? [], source.id, use);

  if (permissionEvent?.action === 'revoke') {
    reasons.push(
      reason('SOURCE_PERMISSION_REVOKED', 'The latest source permission was revoked.', source.id, {
        use,
      })
    );
  }

  if (permissionEvent?.action === 'block') {
    reasons.push(
      reason('SOURCE_PERMISSION_BLOCKED', 'The latest source permission is blocked.', source.id, {
        use,
      })
    );
  }

  const event = domainEvent(
    reasons.length === 0 ? 'source_authorized' : 'source_blocked',
    'source',
    source.id,
    occurredAt,
    { use, eligible: reasons.length === 0 }
  );

  return reasons.length === 0 ? allow(source, [event]) : deny(reasons, [event]);
}
