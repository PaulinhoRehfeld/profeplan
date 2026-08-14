import type {
  ArchiveSourceCommand,
  BlockSourceCommand,
  BlockSourcePurposeCommand,
  ConfirmSourceValidationCommand,
  EntityId,
  GrantSourceAuthorizationCommand,
  ISODateTime,
  OpenSourceImpactAssessmentCommand,
  RegisterSourceIdentityCommand,
  ReplaceSourceCommand,
  RequestSourceValidationCommand,
  ResumeSourceAuthorizationCommand,
  RevokeSourceAuthorizationCommand,
  SourceAuthorizationCommandReceipt,
  SourceAuthorizationEvent,
  SourceImpactCommandReceipt,
  SourceImpactEvent,
  SourcePurpose,
  SourceRegistrationCommandReceipt,
  SourceRegistrationEvent,
  SupersedeSourceAuthorizationCommand,
  SuspendSourceAuthorizationCommand,
} from '@profeplan/types';

export interface SourceRegistrationCommandRepository {
  registerIdentity(command: RegisterSourceIdentityCommand): Promise<SourceRegistrationCommandReceipt>;
  requestValidation(command: RequestSourceValidationCommand): Promise<SourceRegistrationCommandReceipt>;
  confirmValidation(command: ConfirmSourceValidationCommand): Promise<SourceRegistrationCommandReceipt>;
  blockSource(command: BlockSourceCommand): Promise<SourceRegistrationCommandReceipt>;
  replaceSource(command: ReplaceSourceCommand): Promise<SourceRegistrationCommandReceipt>;
  archiveSource(command: ArchiveSourceCommand): Promise<SourceRegistrationCommandReceipt>;
}

export interface SourceAuthorizationCommandRepository {
  grantAuthorization(command: GrantSourceAuthorizationCommand): Promise<SourceAuthorizationCommandReceipt>;
  suspendAuthorization(command: SuspendSourceAuthorizationCommand): Promise<SourceAuthorizationCommandReceipt>;
  resumeAuthorization(command: ResumeSourceAuthorizationCommand): Promise<SourceAuthorizationCommandReceipt>;
  revokeAuthorization(command: RevokeSourceAuthorizationCommand): Promise<SourceAuthorizationCommandReceipt>;
  blockPurpose(command: BlockSourcePurposeCommand): Promise<SourceAuthorizationCommandReceipt>;
  supersedeAuthorization(command: SupersedeSourceAuthorizationCommand): Promise<SourceAuthorizationCommandReceipt>;
}

export interface SourceImpactCommandRepository {
  openImpactAssessment(command: OpenSourceImpactAssessmentCommand): Promise<SourceImpactCommandReceipt>;
}

export interface SourceLifecycleCommandRepository
  extends SourceRegistrationCommandRepository,
    SourceAuthorizationCommandRepository,
    SourceImpactCommandRepository {}

export interface SourceLifecycleReadRepository {
  listRegistrationHistory(
    subjectIdentityId: EntityId,
    asOf?: ISODateTime
  ): Promise<readonly SourceRegistrationEvent[]>;

  listAuthorizationHistory(
    subjectIdentityId: EntityId,
    purpose?: SourcePurpose,
    asOf?: ISODateTime
  ): Promise<readonly SourceAuthorizationEvent[]>;

  listImpactHistory(
    subjectIdentityId: EntityId,
    asOf?: ISODateTime
  ): Promise<readonly SourceImpactEvent[]>;
}

export interface SourceLifecycleRepository
  extends SourceLifecycleCommandRepository,
    SourceLifecycleReadRepository {}
