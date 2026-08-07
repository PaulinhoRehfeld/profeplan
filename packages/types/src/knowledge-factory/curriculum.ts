import type {
  CurriculumState,
  EducationStage,
  EntityId,
  ISODateTime,
  SchoolGrade,
  VersionedEntity,
} from './common.ts';
import { isMvpCurriculumState } from './common.ts';

export const CURRICULUM_PACKAGE_STATUSES = ['draft', 'active', 'retired', 'blocked'] as const;
export type CurriculumPackageStatus = (typeof CURRICULUM_PACKAGE_STATUSES)[number];

export interface CurriculumPackage extends VersionedEntity {
  state: CurriculumState;
  stage: EducationStage;
  status: CurriculumPackageStatus;
  title: string;
  effectiveFrom: ISODateTime;
  effectiveUntil?: ISODateTime;
  sourceVersionIds: readonly EntityId[];
}

export const CURRICULUM_NODE_TYPES = [
  'competency',
  'skill',
  'knowledge_object',
  'learning_expectation',
] as const;
export type CurriculumNodeType = (typeof CURRICULUM_NODE_TYPES)[number];

export interface CurriculumNode extends VersionedEntity {
  curriculumPackageId: EntityId;
  nodeType: CurriculumNodeType;
  code: string;
  title: string;
  description: string;
  component: string;
  grades: readonly SchoolGrade[];
}

export interface CurriculumLink extends VersionedEntity {
  curriculumPackageId: EntityId;
  fromNodeId: EntityId;
  toNodeId: EntityId;
  relation: 'contains' | 'progresses_to' | 'equivalent_to' | 'supports';
}

export function getActiveCurriculumPackages(
  packages: readonly CurriculumPackage[],
): readonly CurriculumPackage[] {
  return packages.filter((item) => item.status === 'active');
}

export function hasSingleActiveCurriculum(packages: readonly CurriculumPackage[]): boolean {
  return getActiveCurriculumPackages(packages).length === 1;
}

export function isCurriculumPackageAllowedForMvp(pkg: CurriculumPackage): boolean {
  return pkg.status === 'active' && isMvpCurriculumState(pkg.state);
}
