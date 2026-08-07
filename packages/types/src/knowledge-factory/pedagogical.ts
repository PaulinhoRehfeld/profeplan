import type { EntityId, ISODateTime, SchoolGrade, VersionTag, VersionedEntity } from './common.ts';

export const PEDAGOGICAL_COMPONENT_TYPES = [
  'concept',
  'explanation',
  'context',
  'methodology',
  'activity_pattern',
  'assessment_pattern',
  'inclusion_strategy',
] as const;
export type PedagogicalComponentType = (typeof PEDAGOGICAL_COMPONENT_TYPES)[number];

export const PEDAGOGICAL_COMPONENT_STATUSES = [
  'draft',
  'in_review',
  'approved',
  'rejected',
  'superseded',
  'suspended',
  'blocked',
  'archived',
] as const;
export type PedagogicalComponentStatus = (typeof PEDAGOGICAL_COMPONENT_STATUSES)[number];

export interface PedagogicalComponent extends VersionedEntity {
  canonicalKey: string;
  title: string;
  componentType: PedagogicalComponentType;
  schoolComponent: string;
  grades: readonly SchoolGrade[];
  status: PedagogicalComponentStatus;
  currentVersionId: EntityId;
  createdAt: ISODateTime;
  updatedAt: ISODateTime;
}

export interface PedagogicalComponentVersion extends VersionedEntity {
  componentId: EntityId;
  summary: string;
  keywords: readonly string[];
  sourceEvidenceIds: readonly EntityId[];
  curriculumNodeIds: readonly EntityId[];
  supersedesVersion?: VersionTag;
  approvedAt?: ISODateTime;
  status: PedagogicalComponentStatus;
}

export interface EvidenceOrigin extends VersionedEntity {
  componentVersionId: EntityId;
  sourceId: EntityId;
  sourceVersionId: EntityId;
  sourceSegmentId: EntityId;
  contribution: 'conceptual' | 'curricular' | 'methodological' | 'contextual';
  recordedAt: ISODateTime;
}

export function isComponentProductionReady(version: PedagogicalComponentVersion): boolean {
  return (
    version.status === 'approved' &&
    version.sourceEvidenceIds.length > 0 &&
    version.curriculumNodeIds.length > 0
  );
}
