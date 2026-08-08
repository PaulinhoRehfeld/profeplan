import type {
  CurriculumNode,
  CurriculumNodeType,
  CurriculumPackage,
  CurriculumPackageStatus,
  CurriculumState,
  EducationStage,
  EntityId,
  SchoolGrade,
} from '@profeplan/types';
import { invalidPersistenceResponse } from '../errors/persistence-error.ts';

const CURRICULUM_STATES = ['MG', 'RS'] as const satisfies readonly CurriculumState[];
const EDUCATION_STAGES = [
  'fundamental_ii',
  'ensino_medio',
] as const satisfies readonly EducationStage[];
const CURRICULUM_PACKAGE_STATUSES = [
  'draft',
  'active',
  'retired',
  'blocked',
] as const satisfies readonly CurriculumPackageStatus[];
const CURRICULUM_NODE_TYPES = [
  'competency',
  'skill',
  'knowledge_object',
  'learning_expectation',
] as const satisfies readonly CurriculumNodeType[];
const SCHOOL_GRADES = [
  '6',
  '7',
  '8',
  '9',
  '1_em',
  '2_em',
  '3_em',
] as const satisfies readonly SchoolGrade[];

export const CURRICULUM_PACKAGE_COLUMNS =
  'id,version,state,stage,status,title,effective_from,effective_until' as const;
export const CURRICULUM_PACKAGE_SOURCE_COLUMNS = 'source_version_id' as const;
export const CURRICULUM_NODE_COLUMNS =
  'id,version,curriculum_package_id,node_type,code,title,description,component,grades' as const;

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

export function curriculumPackageRowToCurriculumPackage(
  row: unknown,
  sourceVersionIds: unknown,
  operation = 'curriculum.package.mapper.fromRow'
): CurriculumPackage {
  if (
    !isRecord(row) ||
    !isNonEmptyString(row.id) ||
    !isNonEmptyString(row.version) ||
    !isOneOf(row.state, CURRICULUM_STATES) ||
    !isOneOf(row.stage, EDUCATION_STAGES) ||
    !isOneOf(row.status, CURRICULUM_PACKAGE_STATUSES) ||
    !isNonEmptyString(row.title) ||
    !isDateTime(row.effective_from) ||
    !Array.isArray(sourceVersionIds) ||
    !sourceVersionIds.every(isNonEmptyString)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  const effectiveUntil = parseOptionalDateTime(row.effective_until, operation);
  return {
    id: row.id,
    version: row.version,
    state: row.state,
    stage: row.stage,
    status: row.status,
    title: row.title,
    effectiveFrom: row.effective_from,
    ...(effectiveUntil === undefined ? {} : { effectiveUntil }),
    sourceVersionIds: [...sourceVersionIds],
  };
}

export function curriculumPackageSourceRowsToIds(
  rows: unknown,
  operation = 'curriculum.package.sources.mapper.fromRows'
): readonly EntityId[] {
  if (!Array.isArray(rows)) {
    throw invalidPersistenceResponse(operation);
  }

  return rows.map((row) => {
    if (!isRecord(row) || !isNonEmptyString(row.source_version_id)) {
      throw invalidPersistenceResponse(operation);
    }
    return row.source_version_id;
  });
}

export function curriculumNodeRowToCurriculumNode(
  row: unknown,
  operation = 'curriculum.node.mapper.fromRow'
): CurriculumNode {
  if (
    !isRecord(row) ||
    !isNonEmptyString(row.id) ||
    !isNonEmptyString(row.version) ||
    !isNonEmptyString(row.curriculum_package_id) ||
    !isOneOf(row.node_type, CURRICULUM_NODE_TYPES) ||
    !isNonEmptyString(row.code) ||
    !isNonEmptyString(row.title) ||
    typeof row.description !== 'string' ||
    !isNonEmptyString(row.component)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  return {
    id: row.id,
    version: row.version,
    curriculumPackageId: row.curriculum_package_id,
    nodeType: row.node_type,
    code: row.code,
    title: row.title,
    description: row.description,
    component: row.component,
    grades: parseGrades(row.grades, operation),
  };
}
