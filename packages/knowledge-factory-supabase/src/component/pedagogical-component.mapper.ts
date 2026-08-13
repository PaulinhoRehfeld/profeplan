import type {
  EntityId,
  EvidenceOrigin,
  PedagogicalComponent,
  PedagogicalComponentStatus,
  PedagogicalComponentType,
  PedagogicalComponentVersion,
  SchoolGrade,
} from '@profeplan/types';
import { invalidPersistenceResponse } from '../errors/persistence-error.ts';

const COMPONENT_TYPES = [
  'concept',
  'explanation',
  'context',
  'methodology',
  'activity_pattern',
  'assessment_pattern',
  'inclusion_strategy',
] as const satisfies readonly PedagogicalComponentType[];
const COMPONENT_STATUSES = [
  'draft',
  'in_review',
  'approved',
  'rejected',
  'superseded',
  'suspended',
  'blocked',
  'archived',
] as const satisfies readonly PedagogicalComponentStatus[];
const SCHOOL_GRADES = [
  '6',
  '7',
  '8',
  '9',
  '1_em',
  '2_em',
  '3_em',
] as const satisfies readonly SchoolGrade[];
const EVIDENCE_CONTRIBUTIONS = [
  'conceptual',
  'curricular',
  'methodological',
  'contextual',
] as const satisfies readonly EvidenceOrigin['contribution'][];

export const PEDAGOGICAL_COMPONENT_COLUMNS =
  'id,version,canonical_key,title,component_type,school_component,grades,status,current_version_id,created_at,updated_at' as const;
export const PEDAGOGICAL_COMPONENT_VERSION_COLUMNS =
  'id,version,component_id,summary,keywords,supersedes_version,approved_at,status' as const;
export const COMPONENT_SOURCE_EVIDENCE_ID_COLUMNS = 'id' as const;
export const COMPONENT_CURRICULUM_LINK_COLUMNS = 'curriculum_node_id' as const;
export const EVIDENCE_ORIGIN_COLUMNS =
  'id,version,component_version_id,source_id,source_version_id,source_segment_id,contribution,recorded_at' as const;

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

function parseOptionalNonEmptyString(value: unknown, operation: string): string | undefined {
  if (value === null || value === undefined) {
    return undefined;
  }
  if (!isNonEmptyString(value)) {
    throw invalidPersistenceResponse(operation);
  }
  return value;
}

function parseOptionalDateTime(value: unknown, operation: string): string | undefined {
  if (value === null || value === undefined) {
    return undefined;
  }
  if (!isDateTime(value)) {
    throw invalidPersistenceResponse(operation);
  }
  return value;
}

function parseGrades(value: unknown, operation: string): readonly SchoolGrade[] {
  if (!Array.isArray(value) || !value.every((grade) => isOneOf(grade, SCHOOL_GRADES))) {
    throw invalidPersistenceResponse(operation);
  }
  return [...value];
}

function parseStrings(value: unknown, operation: string): readonly string[] {
  if (!Array.isArray(value) || !value.every((item) => typeof item === 'string')) {
    throw invalidPersistenceResponse(operation);
  }
  return [...value];
}

function parseEntityIds(value: unknown, operation: string): readonly EntityId[] {
  if (!Array.isArray(value) || !value.every(isNonEmptyString)) {
    throw invalidPersistenceResponse(operation);
  }
  return [...value];
}

export function pedagogicalComponentRowToPedagogicalComponent(
  row: unknown,
  operation = 'component.mapper.fromRow'
): PedagogicalComponent {
  if (
    !isRecord(row) ||
    !isNonEmptyString(row.id) ||
    !isNonEmptyString(row.version) ||
    !isNonEmptyString(row.canonical_key) ||
    !isNonEmptyString(row.title) ||
    !isOneOf(row.component_type, COMPONENT_TYPES) ||
    !isNonEmptyString(row.school_component) ||
    !isOneOf(row.status, COMPONENT_STATUSES) ||
    !isNonEmptyString(row.current_version_id) ||
    !isDateTime(row.created_at) ||
    !isDateTime(row.updated_at)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  return {
    id: row.id,
    version: row.version,
    canonicalKey: row.canonical_key,
    title: row.title,
    componentType: row.component_type,
    schoolComponent: row.school_component,
    grades: parseGrades(row.grades, operation),
    status: row.status,
    currentVersionId: row.current_version_id,
    createdAt: row.created_at,
    updatedAt: row.updated_at,
  };
}

export function pedagogicalComponentVersionRowToPedagogicalComponentVersion(
  row: unknown,
  sourceEvidenceIds: unknown,
  curriculumNodeIds: unknown,
  operation = 'component.version.mapper.fromRow'
): PedagogicalComponentVersion {
  if (
    !isRecord(row) ||
    !isNonEmptyString(row.id) ||
    !isNonEmptyString(row.version) ||
    !isNonEmptyString(row.component_id) ||
    typeof row.summary !== 'string' ||
    !isOneOf(row.status, COMPONENT_STATUSES)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  const supersedesVersion = parseOptionalNonEmptyString(row.supersedes_version, operation);
  const approvedAt = parseOptionalDateTime(row.approved_at, operation);
  return {
    id: row.id,
    version: row.version,
    componentId: row.component_id,
    summary: row.summary,
    keywords: parseStrings(row.keywords, operation),
    sourceEvidenceIds: parseEntityIds(sourceEvidenceIds, operation),
    curriculumNodeIds: parseEntityIds(curriculumNodeIds, operation),
    ...(supersedesVersion === undefined ? {} : { supersedesVersion }),
    ...(approvedAt === undefined ? {} : { approvedAt }),
    status: row.status,
  };
}

export function componentSourceEvidenceRowsToIds(
  rows: unknown,
  operation = 'component.evidenceIds.mapper.fromRows'
): readonly EntityId[] {
  if (!Array.isArray(rows)) {
    throw invalidPersistenceResponse(operation);
  }
  return rows.map((row) => {
    if (!isRecord(row) || !isNonEmptyString(row.id)) {
      throw invalidPersistenceResponse(operation);
    }
    return row.id;
  });
}

export function componentCurriculumLinkRowsToIds(
  rows: unknown,
  operation = 'component.curriculumNodeIds.mapper.fromRows'
): readonly EntityId[] {
  if (!Array.isArray(rows)) {
    throw invalidPersistenceResponse(operation);
  }
  return rows.map((row) => {
    if (!isRecord(row) || !isNonEmptyString(row.curriculum_node_id)) {
      throw invalidPersistenceResponse(operation);
    }
    return row.curriculum_node_id;
  });
}

export function evidenceOriginRowToEvidenceOrigin(
  row: unknown,
  operation = 'component.evidenceOrigin.mapper.fromRow'
): EvidenceOrigin {
  if (
    !isRecord(row) ||
    !isNonEmptyString(row.id) ||
    !isNonEmptyString(row.version) ||
    !isNonEmptyString(row.component_version_id) ||
    !isNonEmptyString(row.source_id) ||
    !isNonEmptyString(row.source_version_id) ||
    !isNonEmptyString(row.source_segment_id) ||
    !isOneOf(row.contribution, EVIDENCE_CONTRIBUTIONS) ||
    !isDateTime(row.recorded_at)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  return {
    id: row.id,
    version: row.version,
    componentVersionId: row.component_version_id,
    sourceId: row.source_id,
    sourceVersionId: row.source_version_id,
    sourceSegmentId: row.source_segment_id,
    contribution: row.contribution,
    recordedAt: row.recorded_at,
  };
}
