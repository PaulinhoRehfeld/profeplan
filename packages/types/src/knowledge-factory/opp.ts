import type { EntityId, ISODateTime, VersionedEntity } from './common.ts';
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
