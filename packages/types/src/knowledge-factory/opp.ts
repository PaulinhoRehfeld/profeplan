import type { EntityId, ISODateTime, VersionTag, VersionedEntity } from './common.ts';
import type { ProductType } from './delivery.ts';

export const OPP_STATUSES = [
  'requested',
  'scoped',
  'retrieving',
  'assembling',
  'validating',
  'ready',
  'insufficient',
  'blocked',
  'failed',
] as const;
export type OppStatus = (typeof OPP_STATUSES)[number];

export const OPP_EVENT_TYPES = [
  'created',
  'scope_resolved',
  'retrieval_started',
  'context_assembled',
  'validation_started',
  'approved',
  'insufficiency_detected',
  'blocked',
  'failed',
] as const;
export type OppEventType = (typeof OPP_EVENT_TYPES)[number];

export interface PedagogicalProductionOrder extends VersionedEntity {
  requesterId: EntityId;
  agentProfileId: EntityId;
  curriculumPackageId: EntityId;
  productType: ProductType;
  theme: string;
  durationMinutes?: number;
  status: OppStatus;
  createdAt: ISODateTime;
  updatedAt: ISODateTime;
}

export interface OppEvent extends VersionedEntity {
  oppId: EntityId;
  eventType: OppEventType;
  fromStatus?: OppStatus;
  toStatus: OppStatus;
  reason?: string;
  occurredAt: ISODateTime;
}

export const PRODUCTION_ORDER_WRITE_OPERATIONS = Object.freeze([
  'create_production_order',
  'transition_production_order',
] as const);
export type ProductionOrderWriteOperation = (typeof PRODUCTION_ORDER_WRITE_OPERATIONS)[number];

export interface CreateProductionOrderCommand {
  readonly commandId: EntityId;
  readonly order: Readonly<
    Omit<PedagogicalProductionOrder, 'requesterId' | 'status' | 'createdAt' | 'updatedAt'>
  >;
  readonly eventId: EntityId;
  readonly eventVersion: VersionTag;
  readonly occurredAt: ISODateTime;
}

export interface TransitionProductionOrderCommand {
  readonly commandId: EntityId;
  readonly requesterId: EntityId;
  readonly oppId: EntityId;
  readonly expectedStatus: OppStatus;
  readonly expectedUpdatedAt: ISODateTime;
  readonly toStatus: OppStatus;
  readonly eventId: EntityId;
  readonly eventVersion: VersionTag;
  readonly reason?: string;
  readonly occurredAt: ISODateTime;
}

export interface ProductionOrderWriteReceipt {
  readonly commandId: EntityId;
  readonly operation: ProductionOrderWriteOperation;
  readonly oppId: EntityId;
  readonly eventId: EntityId;
  readonly status: OppStatus;
  readonly replayed: boolean;
  readonly committedAt: ISODateTime;
}

const OPP_TRANSITIONS: Readonly<Record<OppStatus, readonly OppStatus[]>> = {
  requested: ['scoped', 'blocked', 'failed'],
  scoped: ['retrieving', 'blocked', 'failed'],
  retrieving: ['assembling', 'insufficient', 'blocked', 'failed'],
  assembling: ['validating', 'insufficient', 'failed'],
  validating: ['ready', 'insufficient', 'blocked', 'failed'],
  ready: [],
  insufficient: [],
  blocked: [],
  failed: [],
};

export function canTransitionOpp(from: OppStatus, to: OppStatus): boolean {
  return OPP_TRANSITIONS[from].includes(to);
}

export function assertOppTransition(from: OppStatus, to: OppStatus): void {
  if (!canTransitionOpp(from, to)) {
    throw new Error(`Invalid OPP transition: ${from} -> ${to}`);
  }
}
