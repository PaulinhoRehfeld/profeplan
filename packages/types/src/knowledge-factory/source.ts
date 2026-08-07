import type { EntityId, ISODateTime, VersionTag, VersionedEntity } from './common.ts';

export const SOURCE_TYPES = [
  'curriculum',
  'pnld',
  'open_content',
  'wrtech_owned',
  'legal_reference',
] as const;
export type SourceType = (typeof SOURCE_TYPES)[number];

export const SOURCE_STATUSES = ['draft', 'approved', 'blocked', 'archived'] as const;
export type SourceStatus = (typeof SOURCE_STATUSES)[number];

export const LICENSE_CATEGORIES = ['owned', 'licensed', 'open', 'restricted', 'unknown'] as const;
export type LicenseCategory = (typeof LICENSE_CATEGORIES)[number];

export const SOURCE_USES = ['retrieval', 'generation', 'quotation', 'internal_review'] as const;
export type SourceUse = (typeof SOURCE_USES)[number];

export interface KnowledgeSource extends VersionedEntity {
  title: string;
  sourceType: SourceType;
  status: SourceStatus;
  licenseCategory: LicenseCategory;
  allowedUses: readonly SourceUse[];
  provenanceUri?: string;
  createdAt: ISODateTime;
  updatedAt: ISODateTime;
}

export interface SourceVersion extends VersionedEntity {
  sourceId: EntityId;
  checksum: string;
  effectiveAt: ISODateTime;
  supersedesVersion?: VersionTag;
}

export const PERMISSION_ACTIONS = ['grant', 'revoke', 'block'] as const;
export type PermissionAction = (typeof PERMISSION_ACTIONS)[number];

export interface SourcePermissionEvent extends VersionedEntity {
  sourceId: EntityId;
  action: PermissionAction;
  use: SourceUse;
  reason: string;
  occurredAt: ISODateTime;
}

export interface SourceSegment extends VersionedEntity {
  sourceVersionId: EntityId;
  locator: string;
  contentDigest: string;
  extractedText: string;
  createdAt: ISODateTime;
}

export function isLicenseCompatibleWithUse(
  licenseCategory: LicenseCategory,
  use: SourceUse
): boolean {
  if (licenseCategory === 'restricted' || licenseCategory === 'unknown') {
    return use === 'internal_review';
  }

  return true;
}

export function isSourceRecoverable(source: KnowledgeSource, use: SourceUse): boolean {
  return (
    source.status === 'approved' &&
    source.allowedUses.includes(use) &&
    isLicenseCompatibleWithUse(source.licenseCategory, use)
  );
}
