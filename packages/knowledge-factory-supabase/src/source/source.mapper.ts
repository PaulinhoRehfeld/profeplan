import type {
  KnowledgeSource,
  LicenseCategory,
  PermissionAction,
  SourcePermissionEvent,
  SourceStatus,
  SourceType,
  SourceUse,
  SourceVersion,
} from '@profeplan/types';
import { invalidPersistenceResponse } from '../errors/persistence-error.ts';

const SOURCE_TYPES = [
  'curriculum',
  'pnld',
  'open_content',
  'wrtech_owned',
  'legal_reference',
] as const satisfies readonly SourceType[];
const SOURCE_STATUSES = [
  'draft',
  'approved',
  'blocked',
  'archived',
] as const satisfies readonly SourceStatus[];
const LICENSE_CATEGORIES = [
  'owned',
  'licensed',
  'open',
  'restricted',
  'unknown',
] as const satisfies readonly LicenseCategory[];
const SOURCE_USES = [
  'retrieval',
  'generation',
  'quotation',
  'internal_review',
] as const satisfies readonly SourceUse[];
const PERMISSION_ACTIONS = [
  'grant',
  'revoke',
  'block',
] as const satisfies readonly PermissionAction[];

export const KNOWLEDGE_SOURCE_COLUMNS =
  'id,version,title,source_type,status,license_category,allowed_uses,provenance_uri,created_at,updated_at' as const;
export const SOURCE_VERSION_COLUMNS =
  'id,version,source_id,checksum,effective_at,supersedes_version' as const;
export const SOURCE_PERMISSION_EVENT_COLUMNS =
  'id,version,source_id,action,use_type,reason,occurred_at' as const;

export interface KnowledgeSourceRow {
  readonly id: string;
  readonly version: string;
  readonly title: string;
  readonly source_type: string;
  readonly status: string;
  readonly license_category: string;
  readonly allowed_uses: readonly string[];
  readonly provenance_uri: string | null;
  readonly created_at: string;
  readonly updated_at: string;
}

export interface SourceVersionRow {
  readonly id: string;
  readonly version: string;
  readonly source_id: string;
  readonly checksum: string;
  readonly effective_at: string;
  readonly supersedes_version: string | null;
}

export interface SourcePermissionEventRow {
  readonly id: string;
  readonly version: string;
  readonly source_id: string;
  readonly action: string;
  readonly use_type: string;
  readonly reason: string;
  readonly occurred_at: string;
}

const ISO_DATE_TIME_PATTERN =
  /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|([+-])(\d{2}):(\d{2}))$/;

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function isNonEmptyString(value: unknown): value is string {
  return typeof value === 'string' && value.trim().length > 0;
}

function isOneOf<T extends string>(value: unknown, values: readonly T[]): value is T {
  return typeof value === 'string' && values.some((candidate) => candidate === value);
}

function isSourceType(value: unknown): value is SourceType {
  return isOneOf(value, SOURCE_TYPES);
}

function isSourceStatus(value: unknown): value is SourceStatus {
  return isOneOf(value, SOURCE_STATUSES);
}

function isLicenseCategory(value: unknown): value is LicenseCategory {
  return isOneOf(value, LICENSE_CATEGORIES);
}

function isSourceUse(value: unknown): value is SourceUse {
  return isOneOf(value, SOURCE_USES);
}

function isPermissionAction(value: unknown): value is PermissionAction {
  return isOneOf(value, PERMISSION_ACTIONS);
}

function parseSourceUses(value: unknown, operation: string): readonly SourceUse[] {
  if (!Array.isArray(value) || !value.every(isSourceUse)) {
    throw invalidPersistenceResponse(operation);
  }
  return value;
}

function parseOptionalString(value: unknown, operation: string): string | undefined {
  if (value === null || value === undefined) {
    return undefined;
  }
  if (typeof value !== 'string') {
    throw invalidPersistenceResponse(operation);
  }
  return value;
}

function isDateTime(value: unknown): value is string {
  if (typeof value !== 'string') {
    return false;
  }

  const match = ISO_DATE_TIME_PATTERN.exec(value);
  if (match === null) {
    return false;
  }

  const year = Number(match[1]);
  const month = Number(match[2]);
  const day = Number(match[3]);
  const hour = Number(match[4]);
  const minute = Number(match[5]);
  const second = Number(match[6]);
  const offsetHour = match[8] === undefined ? 0 : Number(match[8]);
  const offsetMinute = match[9] === undefined ? 0 : Number(match[9]);
  const leapYear = year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0);
  const daysInMonth = [31, leapYear ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  return (
    month >= 1 &&
    month <= 12 &&
    day >= 1 &&
    day <= daysInMonth[month - 1] &&
    hour <= 23 &&
    minute <= 59 &&
    second <= 59 &&
    offsetHour <= 14 &&
    offsetMinute <= 59 &&
    (offsetHour < 14 || offsetMinute === 0) &&
    Number.isFinite(Date.parse(value))
  );
}

export function knowledgeSourceToRow(
  source: KnowledgeSource,
  operation = 'source.mapper.toRow'
): KnowledgeSourceRow {
  if (
    !isNonEmptyString(source.id) ||
    !isNonEmptyString(source.version) ||
    !isNonEmptyString(source.title) ||
    !isSourceType(source.sourceType) ||
    !isSourceStatus(source.status) ||
    !isLicenseCategory(source.licenseCategory) ||
    !isDateTime(source.createdAt) ||
    !isDateTime(source.updatedAt)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  return {
    id: source.id,
    version: source.version,
    title: source.title,
    source_type: source.sourceType,
    status: source.status,
    license_category: source.licenseCategory,
    allowed_uses: parseSourceUses(source.allowedUses, operation),
    provenance_uri: source.provenanceUri ?? null,
    created_at: source.createdAt,
    updated_at: source.updatedAt,
  };
}

export function sourceRowToKnowledgeSource(
  row: unknown,
  operation = 'source.mapper.fromRow'
): KnowledgeSource {
  if (
    !isRecord(row) ||
    !isNonEmptyString(row.id) ||
    !isNonEmptyString(row.version) ||
    !isNonEmptyString(row.title) ||
    !isSourceType(row.source_type) ||
    !isSourceStatus(row.status) ||
    !isLicenseCategory(row.license_category) ||
    !isDateTime(row.created_at) ||
    !isDateTime(row.updated_at)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  const provenanceUri = parseOptionalString(row.provenance_uri, operation);
  return {
    id: row.id,
    version: row.version,
    title: row.title,
    sourceType: row.source_type,
    status: row.status,
    licenseCategory: row.license_category,
    allowedUses: parseSourceUses(row.allowed_uses, operation),
    ...(provenanceUri === undefined ? {} : { provenanceUri }),
    createdAt: row.created_at,
    updatedAt: row.updated_at,
  };
}

export function sourceVersionRowToSourceVersion(
  row: unknown,
  operation = 'source.version.mapper.fromRow'
): SourceVersion {
  if (
    !isRecord(row) ||
    !isNonEmptyString(row.id) ||
    !isNonEmptyString(row.version) ||
    !isNonEmptyString(row.source_id) ||
    !isNonEmptyString(row.checksum) ||
    !isDateTime(row.effective_at)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  const supersedesVersion = parseOptionalString(row.supersedes_version, operation);
  if (supersedesVersion !== undefined && supersedesVersion.trim().length === 0) {
    throw invalidPersistenceResponse(operation);
  }

  return {
    id: row.id,
    version: row.version,
    sourceId: row.source_id,
    checksum: row.checksum,
    effectiveAt: row.effective_at,
    ...(supersedesVersion === undefined ? {} : { supersedesVersion }),
  };
}

export function sourcePermissionEventRowToSourcePermissionEvent(
  row: unknown,
  operation = 'source.permission.mapper.fromRow'
): SourcePermissionEvent {
  if (
    !isRecord(row) ||
    !isNonEmptyString(row.id) ||
    !isNonEmptyString(row.version) ||
    !isNonEmptyString(row.source_id) ||
    !isPermissionAction(row.action) ||
    !isSourceUse(row.use_type) ||
    !isNonEmptyString(row.reason) ||
    !isDateTime(row.occurred_at)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  return {
    id: row.id,
    version: row.version,
    sourceId: row.source_id,
    action: row.action,
    use: row.use_type,
    reason: row.reason,
    occurredAt: row.occurred_at,
  };
}
