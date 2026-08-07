import type {
  CurriculumState,
  EducationStage,
  EntityId,
  SchoolGrade,
  VersionedEntity,
} from './common.ts';
import type { PedagogicalComponentStatus } from './pedagogical.ts';
import type { SourceStatus, SourceUse } from './source.ts';

export const REQUIRED_QUERY_FILTERS = [
  'schoolComponent',
  'stage',
  'grade',
  'curriculumState',
  'curriculumPackageId',
  'sourceStatus',
  'sourceUse',
  'componentStatus',
] as const;
export type RequiredQueryFilter = (typeof REQUIRED_QUERY_FILTERS)[number];

export interface QueryFilters {
  schoolComponent: string;
  stage: EducationStage;
  grade: SchoolGrade;
  curriculumState: CurriculumState;
  curriculumPackageId: EntityId;
  sourceStatus: SourceStatus;
  sourceUse: SourceUse;
  componentStatus: PedagogicalComponentStatus;
}

export interface QueryPlan extends VersionedEntity {
  query: string;
  filters: QueryFilters;
  maxCandidates: number;
  maxContextItems: number;
}

export const INSUFFICIENCY_REASONS = [
  'no_authorized_sources',
  'no_approved_components',
  'missing_curriculum_alignment',
  'insufficient_evidence',
  'context_budget_exceeded',
] as const;
export type InsufficiencyReason = (typeof INSUFFICIENCY_REASONS)[number];

export interface SufficiencyResult extends VersionedEntity {
  sufficient: boolean;
  reasons: readonly InsufficiencyReason[];
  evidenceCount: number;
  componentCount: number;
}

export interface ContextItem {
  componentVersionId: EntityId;
  evidenceOriginIds: readonly EntityId[];
  curriculumNodeIds: readonly EntityId[];
  summary: string;
}

export interface ContextPackage extends VersionedEntity {
  queryPlanId: EntityId;
  sufficiencyResultId: EntityId;
  items: readonly ContextItem[];
  sourceVersionIds: readonly EntityId[];
  curriculumPackageId: EntityId;
}

export function hasMandatoryQueryFilters(plan: QueryPlan): boolean {
  const filters = plan.filters;

  return Boolean(
    filters.schoolComponent.trim() &&
      filters.stage &&
      filters.grade &&
      filters.curriculumState &&
      filters.curriculumPackageId.trim() &&
      filters.sourceStatus === 'approved' &&
      filters.sourceUse === 'retrieval' &&
      filters.componentStatus === 'approved'
  );
}

export function isSufficient(result: SufficiencyResult): boolean {
  return result.sufficient && result.reasons.length === 0;
}
