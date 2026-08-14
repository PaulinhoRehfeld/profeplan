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

export const PEDAGOGICAL_COMPONENT_WRITE_OPERATIONS = Object.freeze([
  'create_component_aggregate',
  'append_component_version',
  'transition_component_version_status',
  'promote_component_version',
] as const);
export type PedagogicalComponentWriteOperation =
  (typeof PEDAGOGICAL_COMPONENT_WRITE_OPERATIONS)[number];

export interface CreatePedagogicalComponentAggregateCommand {
  readonly commandId: EntityId;
  readonly component: Readonly<PedagogicalComponent>;
  readonly initialVersion: Readonly<PedagogicalComponentVersion>;
  readonly evidenceOrigins: readonly Readonly<EvidenceOrigin>[];
}

export interface AppendPedagogicalComponentVersionCommand {
  readonly commandId: EntityId;
  readonly expectedCurrentVersionId: EntityId;
  readonly version: Readonly<PedagogicalComponentVersion>;
  readonly evidenceOrigins: readonly Readonly<EvidenceOrigin>[];
}

export interface TransitionPedagogicalComponentVersionStatusCommand {
  readonly commandId: EntityId;
  readonly componentId: EntityId;
  readonly componentVersionId: EntityId;
  readonly expectedStatus: PedagogicalComponentStatus;
  readonly toStatus: PedagogicalComponentStatus;
  readonly occurredAt: ISODateTime;
}

export interface PromotePedagogicalComponentVersionCommand {
  readonly commandId: EntityId;
  readonly componentId: EntityId;
  readonly targetVersionId: EntityId;
  readonly expectedCurrentVersionId: EntityId;
  readonly expectedComponentUpdatedAt: ISODateTime;
  readonly occurredAt: ISODateTime;
}

export interface PedagogicalComponentWriteReceipt {
  readonly commandId: EntityId;
  readonly operation: PedagogicalComponentWriteOperation;
  readonly componentId: EntityId;
  readonly componentVersionId?: EntityId;
  readonly replayed: boolean;
  readonly committedAt: ISODateTime;
}

export function isComponentProductionReady(version: PedagogicalComponentVersion): boolean {
  return (
    version.status === 'approved' &&
    version.sourceEvidenceIds.length > 0 &&
    version.curriculumNodeIds.length > 0
  );
}
