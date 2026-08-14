import type { EntityId, ISODateTime, VersionTag } from './common.ts';

export const SOURCE_LIFECYCLE_CONTRACT_VERSION = '1.0.0' as const;

export const SOURCE_REGISTRATION_STATES = [
  'REGISTERED',
  'PENDING_VALIDATION',
  'VALIDATED',
  'BLOCKED',
  'REPLACED',
  'ARCHIVED',
] as const;
export type SourceRegistrationState = (typeof SOURCE_REGISTRATION_STATES)[number];

export const SOURCE_AUTHORIZATION_STATES = [
  'PENDING_REVIEW',
  'GRANTED',
  'SUSPENDED',
  'REVOKED',
  'EXPIRED',
  'BLOCKED',
  'SUPERSEDED',
] as const;
export type SourceAuthorizationState = (typeof SOURCE_AUTHORIZATION_STATES)[number];

export const SOURCE_PURPOSES = [
  'temporary_staging',
  'ingestion',
  'extraction',
  'analysis_classification',
  'distillation',
  'quotation',
  'indexing_embedding',
  'retrieval',
  'evidence',
  'generation',
] as const;
export type SourcePurpose = (typeof SOURCE_PURPOSES)[number];

export const SOURCE_IDENTITY_KINDS = [
  'work',
  'edition',
  'manifestation',
  'received_file',
  'governed_source',
  'source_version',
  'processing_run',
  'derived_artifact',
] as const;
export type SourceIdentityKind = (typeof SOURCE_IDENTITY_KINDS)[number];

export interface SourceIdentityRef {
  readonly kind: SourceIdentityKind;
  readonly id: EntityId;
}

export const SOURCE_ACTOR_ROLES = [
  'curator',
  'legal_editorial_reviewer',
  'system_worker',
  'auditor',
  'technical_admin',
] as const;
export type SourceActorRole = (typeof SOURCE_ACTOR_ROLES)[number];

export interface SourceActorRef {
  readonly actorId: EntityId;
  readonly role: SourceActorRole;
}

export const SOURCE_AUTHORIZATION_BASIS_KINDS = [
  'wrtech_ownership',
  'publisher_contract',
  'open_license',
  'express_authorization',
  'legal_norm',
  'other_approved',
] as const;
export type SourceAuthorizationBasisKind = (typeof SOURCE_AUTHORIZATION_BASIS_KINDS)[number];

export interface SourceAuthorizationBasisRef {
  readonly id: EntityId;
  readonly kind: SourceAuthorizationBasisKind;
  readonly referenceDigest?: string;
}

export interface SourceAuthorizationScope {
  readonly subject: SourceIdentityRef;
  readonly purpose: SourcePurpose;
  readonly restrictions?: readonly string[];
}

export interface SourceCommandEnvelope {
  readonly commandId: EntityId;
  readonly fingerprint: string;
  readonly actor: SourceActorRef;
  readonly expectedVersion?: VersionTag;
  readonly expectedSequence?: number;
  readonly occurredAt: ISODateTime;
  readonly effectiveAt: ISODateTime;
  readonly correlationId: EntityId;
  readonly reason: string;
}

export const SOURCE_REGISTRATION_COMMAND_TYPES = [
  'register_identity',
  'request_validation',
  'confirm_validation',
  'block_source',
  'replace_source',
  'archive_source',
] as const;
export type SourceRegistrationCommandType = (typeof SOURCE_REGISTRATION_COMMAND_TYPES)[number];

interface SourceRegistrationCommandBase extends SourceCommandEnvelope {
  readonly subject: SourceIdentityRef;
  readonly expectedState?: SourceRegistrationState;
}

export interface RegisterSourceIdentityCommand extends SourceRegistrationCommandBase {
  readonly commandType: 'register_identity';
}

export interface RequestSourceValidationCommand extends SourceRegistrationCommandBase {
  readonly commandType: 'request_validation';
}

export interface ConfirmSourceValidationCommand extends SourceRegistrationCommandBase {
  readonly commandType: 'confirm_validation';
}

export interface BlockSourceCommand extends SourceRegistrationCommandBase {
  readonly commandType: 'block_source';
}

export interface ReplaceSourceCommand extends SourceRegistrationCommandBase {
  readonly commandType: 'replace_source';
  readonly successor: SourceIdentityRef;
}

export interface ArchiveSourceCommand extends SourceRegistrationCommandBase {
  readonly commandType: 'archive_source';
}

export type SourceRegistrationCommand =
  | RegisterSourceIdentityCommand
  | RequestSourceValidationCommand
  | ConfirmSourceValidationCommand
  | BlockSourceCommand
  | ReplaceSourceCommand
  | ArchiveSourceCommand;

export const SOURCE_AUTHORIZATION_COMMAND_TYPES = [
  'grant_authorization',
  'suspend_authorization',
  'resume_authorization',
  'revoke_authorization',
  'block_purpose',
  'supersede_authorization',
] as const;
export type SourceAuthorizationCommandType = (typeof SOURCE_AUTHORIZATION_COMMAND_TYPES)[number];

interface SourceAuthorizationCommandBase extends SourceCommandEnvelope {
  readonly authorizationId: EntityId;
  readonly scope: SourceAuthorizationScope;
  readonly expectedState?: SourceAuthorizationState;
  readonly basis: SourceAuthorizationBasisRef;
}

export interface GrantSourceAuthorizationCommand extends SourceAuthorizationCommandBase {
  readonly commandType: 'grant_authorization';
  readonly effectiveFrom: ISODateTime;
  readonly effectiveUntil?: ISODateTime;
}

export interface SuspendSourceAuthorizationCommand extends SourceAuthorizationCommandBase {
  readonly commandType: 'suspend_authorization';
}

export interface ResumeSourceAuthorizationCommand extends SourceAuthorizationCommandBase {
  readonly commandType: 'resume_authorization';
}

export interface RevokeSourceAuthorizationCommand extends SourceAuthorizationCommandBase {
  readonly commandType: 'revoke_authorization';
}

export interface BlockSourcePurposeCommand extends SourceAuthorizationCommandBase {
  readonly commandType: 'block_purpose';
}

export interface SupersedeSourceAuthorizationCommand extends SourceAuthorizationCommandBase {
  readonly commandType: 'supersede_authorization';
  readonly successorAuthorizationId: EntityId;
  readonly effectiveFrom: ISODateTime;
  readonly effectiveUntil?: ISODateTime;
}

export type SourceAuthorizationCommand =
  | GrantSourceAuthorizationCommand
  | SuspendSourceAuthorizationCommand
  | ResumeSourceAuthorizationCommand
  | RevokeSourceAuthorizationCommand
  | BlockSourcePurposeCommand
  | SupersedeSourceAuthorizationCommand;

export interface OpenSourceImpactAssessmentCommand extends SourceCommandEnvelope {
  readonly commandType: 'open_impact_assessment';
  readonly subject: SourceIdentityRef;
  readonly triggeringAuthorizationId?: EntityId;
}

export type SourceGovernanceCommand =
  | SourceRegistrationCommand
  | SourceAuthorizationCommand
  | OpenSourceImpactAssessmentCommand;

export interface SourceGovernanceEventEnvelope {
  readonly eventId: EntityId;
  readonly aggregateId: EntityId;
  readonly aggregateVersion: VersionTag;
  readonly sequence: number;
  readonly actor: SourceActorRef;
  readonly reason: string;
  readonly occurredAt: ISODateTime;
  readonly effectiveAt: ISODateTime;
  readonly correlationId: EntityId;
  readonly commandId: EntityId;
}

export const SOURCE_REGISTRATION_EVENT_TYPES = [
  'source_registered',
  'source_validation_requested',
  'source_validated',
  'source_blocked',
  'source_replaced',
  'source_archived',
] as const;
export type SourceRegistrationEventType = (typeof SOURCE_REGISTRATION_EVENT_TYPES)[number];

export interface SourceRegistrationEvent extends SourceGovernanceEventEnvelope {
  readonly eventType: SourceRegistrationEventType;
  readonly subject: SourceIdentityRef;
  readonly fromState?: SourceRegistrationState;
  readonly toState: SourceRegistrationState;
  readonly successor?: SourceIdentityRef;
}

export const SOURCE_AUTHORIZATION_EVENT_TYPES = [
  'authorization_granted',
  'authorization_suspended',
  'authorization_resumed',
  'authorization_revoked',
  'authorization_expired',
  'authorization_blocked',
  'authorization_superseded',
] as const;
export type SourceAuthorizationEventType = (typeof SOURCE_AUTHORIZATION_EVENT_TYPES)[number];

export interface SourceAuthorizationEvent extends SourceGovernanceEventEnvelope {
  readonly eventType: SourceAuthorizationEventType;
  readonly authorizationId: EntityId;
  readonly scope: SourceAuthorizationScope;
  readonly basis: SourceAuthorizationBasisRef;
  readonly fromState?: SourceAuthorizationState;
  readonly toState: SourceAuthorizationState;
  readonly effectiveFrom: ISODateTime;
  readonly effectiveUntil?: ISODateTime;
  readonly supersededByAuthorizationId?: EntityId;
}

export const SOURCE_IMPACT_EVENT_TYPES = ['source_impact_assessment_opened'] as const;
export type SourceImpactEventType = (typeof SOURCE_IMPACT_EVENT_TYPES)[number];

export interface SourceImpactEvent extends SourceGovernanceEventEnvelope {
  readonly eventType: SourceImpactEventType;
  readonly subject: SourceIdentityRef;
  readonly triggeringAuthorizationId?: EntityId;
}

export type SourceGovernanceEvent =
  | SourceRegistrationEvent
  | SourceAuthorizationEvent
  | SourceImpactEvent;

export interface SourceRegistrationCommandReceipt {
  readonly dimension: 'registration';
  readonly commandId: EntityId;
  readonly fingerprint: string;
  readonly operation: SourceRegistrationCommandType;
  readonly aggregateId: EntityId;
  readonly aggregateVersion: VersionTag;
  readonly sequence: number;
  readonly eventIds: readonly EntityId[];
  readonly state: SourceRegistrationState;
  readonly replayed: boolean;
  readonly committedAt: ISODateTime;
}

export interface SourceAuthorizationCommandReceipt {
  readonly dimension: 'authorization';
  readonly commandId: EntityId;
  readonly fingerprint: string;
  readonly operation: SourceAuthorizationCommandType;
  readonly aggregateId: EntityId;
  readonly aggregateVersion: VersionTag;
  readonly sequence: number;
  readonly eventIds: readonly EntityId[];
  readonly state: SourceAuthorizationState;
  readonly replayed: boolean;
  readonly committedAt: ISODateTime;
}

export interface SourceImpactCommandReceipt {
  readonly dimension: 'impact';
  readonly commandId: EntityId;
  readonly fingerprint: string;
  readonly operation: 'open_impact_assessment';
  readonly aggregateId: EntityId;
  readonly aggregateVersion: VersionTag;
  readonly sequence: number;
  readonly eventIds: readonly EntityId[];
  readonly replayed: boolean;
  readonly committedAt: ISODateTime;
}

export type SourceCommandReceipt =
  | SourceRegistrationCommandReceipt
  | SourceAuthorizationCommandReceipt
  | SourceImpactCommandReceipt;

export interface SourceCommandReplayRecord {
  readonly commandId: EntityId;
  readonly fingerprint: string;
  readonly receipt: SourceCommandReceipt;
}
