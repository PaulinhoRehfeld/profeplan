import type { SourceLifecycleCommandRepository } from '@profeplan/knowledge-factory';
import type {
  ArchiveSourceCommand,
  BlockSourceCommand,
  BlockSourcePurposeCommand,
  ConfirmSourceValidationCommand,
  GrantSourceAuthorizationCommand,
  OpenSourceImpactAssessmentCommand,
  RegisterSourceIdentityCommand,
  ReplaceSourceCommand,
  RequestSourceValidationCommand,
  ResumeSourceAuthorizationCommand,
  RevokeSourceAuthorizationCommand,
  SourceAuthorizationCommandReceipt,
  SourceCommandReceipt,
  SourceGovernanceCommand,
  SourceImpactCommandReceipt,
  SourceRegistrationCommandReceipt,
  SupersedeSourceAuthorizationCommand,
  SuspendSourceAuthorizationCommand,
} from '@profeplan/types';
import type { SupabaseSystemContext } from '../context/supabase-system-context.ts';
import {
  invalidPersistenceResponse,
  toPersistenceError,
  type KnowledgeFactoryPersistenceError,
} from '../errors/persistence-error.ts';
import {
  NOOP_PERSISTENCE_LOGGER,
  recordPersistenceLog,
  type PersistenceLogger,
} from '../observability/persistence-logger.ts';
import {
  sourceGovernanceCommandToRpcPayload,
  sourceLifecycleReceiptRowToReceipt,
  type SourceCommandExpectation,
} from './source-lifecycle-command.mapper.ts';

const ADAPTER_NAME = 'SupabaseSourceLifecycleCommandRepository';

const RPC_NAMES = Object.freeze({
  register_identity: 'kf_source_register_identity',
  request_validation: 'kf_source_request_validation',
  confirm_validation: 'kf_source_confirm_validation',
  block_source: 'kf_source_block',
  replace_source: 'kf_source_replace',
  archive_source: 'kf_source_archive',
  grant_authorization: 'kf_source_grant_authorization',
  suspend_authorization: 'kf_source_suspend_authorization',
  resume_authorization: 'kf_source_resume_authorization',
  revoke_authorization: 'kf_source_revoke_authorization',
  block_purpose: 'kf_source_block_purpose',
  supersede_authorization: 'kf_source_supersede_authorization',
  open_impact_assessment: 'kf_source_open_impact_assessment',
} as const);

interface ProviderResponse {
  readonly data: unknown;
  readonly error: unknown;
}

interface RpcClient {
  rpc(name: string, args: Readonly<Record<string, unknown>>): Promise<unknown>;
}

function parseProviderResponse(value: unknown, operation: string): ProviderResponse {
  if (typeof value !== 'object' || value === null || !('data' in value) || !('error' in value)) {
    throw invalidPersistenceResponse(operation);
  }
  return { data: value.data, error: value.error };
}

function recordSuccess(
  logger: PersistenceLogger,
  command: SourceGovernanceCommand,
  operation: string,
  startedAt: number,
  aggregateId: string,
  eventCount: number
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'success',
    aggregateType: 'source_lifecycle',
    aggregateId,
    correlationId: command.correlationId,
    rowCount: eventCount,
  });
}

function recordFailure(
  logger: PersistenceLogger,
  command: SourceGovernanceCommand,
  operation: string,
  startedAt: number,
  aggregateId: string,
  error: KnowledgeFactoryPersistenceError
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'failure',
    aggregateType: 'source_lifecycle',
    aggregateId,
    correlationId: command.correlationId,
    errorCode: error.code,
  });
}

export class SupabaseSourceLifecycleCommandRepository implements SourceLifecycleCommandRepository {
  private readonly context: SupabaseSystemContext;
  private readonly logger: PersistenceLogger;

  constructor(context: SupabaseSystemContext, logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER) {
    this.context = context;
    this.logger = logger;
  }

  private async execute(
    command: SourceGovernanceCommand,
    expected: SourceCommandExpectation
  ): Promise<SourceCommandReceipt> {
    const operation = `sourceLifecycle.${command.commandType}`;
    const startedAt = Date.now();

    try {
      const rpcName = RPC_NAMES[command.commandType];
      const rawResponse = await (this.context.client as unknown as RpcClient).rpc(rpcName, {
        p_command_id: command.commandId,
        p_fingerprint: command.fingerprint,
        p_payload: sourceGovernanceCommandToRpcPayload(command, operation),
      });
      const response = parseProviderResponse(rawResponse, operation);
      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }

      const receipt = sourceLifecycleReceiptRowToReceipt(response.data, expected, operation);
      recordSuccess(this.logger, command, operation, startedAt, expected.aggregateId, receipt.eventIds.length);
      return receipt;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(this.logger, command, operation, startedAt, expected.aggregateId, persistenceError);
      throw persistenceError;
    }
  }

  async registerIdentity(command: RegisterSourceIdentityCommand): Promise<SourceRegistrationCommandReceipt> {
    return (await this.execute(command, {
      dimension: 'registration',
      commandId: command.commandId,
      fingerprint: command.fingerprint,
      operation: 'register_identity',
      aggregateId: command.subject.id,
      state: 'REGISTERED',
    })) as SourceRegistrationCommandReceipt;
  }

  async requestValidation(command: RequestSourceValidationCommand): Promise<SourceRegistrationCommandReceipt> {
    return (await this.execute(command, {
      dimension: 'registration', commandId: command.commandId, fingerprint: command.fingerprint,
      operation: 'request_validation', aggregateId: command.subject.id, state: 'PENDING_VALIDATION',
    })) as SourceRegistrationCommandReceipt;
  }

  async confirmValidation(command: ConfirmSourceValidationCommand): Promise<SourceRegistrationCommandReceipt> {
    return (await this.execute(command, {
      dimension: 'registration', commandId: command.commandId, fingerprint: command.fingerprint,
      operation: 'confirm_validation', aggregateId: command.subject.id, state: 'VALIDATED',
    })) as SourceRegistrationCommandReceipt;
  }

  async blockSource(command: BlockSourceCommand): Promise<SourceRegistrationCommandReceipt> {
    return (await this.execute(command, {
      dimension: 'registration', commandId: command.commandId, fingerprint: command.fingerprint,
      operation: 'block_source', aggregateId: command.subject.id, state: 'BLOCKED',
    })) as SourceRegistrationCommandReceipt;
  }

  async replaceSource(command: ReplaceSourceCommand): Promise<SourceRegistrationCommandReceipt> {
    return (await this.execute(command, {
      dimension: 'registration', commandId: command.commandId, fingerprint: command.fingerprint,
      operation: 'replace_source', aggregateId: command.subject.id, state: 'REPLACED',
    })) as SourceRegistrationCommandReceipt;
  }

  async archiveSource(command: ArchiveSourceCommand): Promise<SourceRegistrationCommandReceipt> {
    return (await this.execute(command, {
      dimension: 'registration', commandId: command.commandId, fingerprint: command.fingerprint,
      operation: 'archive_source', aggregateId: command.subject.id, state: 'ARCHIVED',
    })) as SourceRegistrationCommandReceipt;
  }

  async grantAuthorization(command: GrantSourceAuthorizationCommand): Promise<SourceAuthorizationCommandReceipt> {
    return (await this.execute(command, {
      dimension: 'authorization', commandId: command.commandId, fingerprint: command.fingerprint,
      operation: 'grant_authorization', aggregateId: command.authorizationId, state: 'GRANTED',
    })) as SourceAuthorizationCommandReceipt;
  }

  async suspendAuthorization(command: SuspendSourceAuthorizationCommand): Promise<SourceAuthorizationCommandReceipt> {
    return (await this.execute(command, {
      dimension: 'authorization', commandId: command.commandId, fingerprint: command.fingerprint,
      operation: 'suspend_authorization', aggregateId: command.authorizationId, state: 'SUSPENDED',
    })) as SourceAuthorizationCommandReceipt;
  }

  async resumeAuthorization(command: ResumeSourceAuthorizationCommand): Promise<SourceAuthorizationCommandReceipt> {
    return (await this.execute(command, {
      dimension: 'authorization', commandId: command.commandId, fingerprint: command.fingerprint,
      operation: 'resume_authorization', aggregateId: command.authorizationId, state: 'GRANTED',
    })) as SourceAuthorizationCommandReceipt;
  }

  async revokeAuthorization(command: RevokeSourceAuthorizationCommand): Promise<SourceAuthorizationCommandReceipt> {
    return (await this.execute(command, {
      dimension: 'authorization', commandId: command.commandId, fingerprint: command.fingerprint,
      operation: 'revoke_authorization', aggregateId: command.authorizationId, state: 'REVOKED',
    })) as SourceAuthorizationCommandReceipt;
  }

  async blockPurpose(command: BlockSourcePurposeCommand): Promise<SourceAuthorizationCommandReceipt> {
    return (await this.execute(command, {
      dimension: 'authorization', commandId: command.commandId, fingerprint: command.fingerprint,
      operation: 'block_purpose', aggregateId: command.authorizationId, state: 'BLOCKED',
    })) as SourceAuthorizationCommandReceipt;
  }

  async supersedeAuthorization(command: SupersedeSourceAuthorizationCommand): Promise<SourceAuthorizationCommandReceipt> {
    return (await this.execute(command, {
      dimension: 'authorization', commandId: command.commandId, fingerprint: command.fingerprint,
      operation: 'supersede_authorization', aggregateId: command.authorizationId, state: 'SUPERSEDED',
    })) as SourceAuthorizationCommandReceipt;
  }

  async openImpactAssessment(command: OpenSourceImpactAssessmentCommand): Promise<SourceImpactCommandReceipt> {
    return (await this.execute(command, {
      dimension: 'impact', commandId: command.commandId, fingerprint: command.fingerprint,
      operation: 'open_impact_assessment', aggregateId: command.subject.id,
    })) as SourceImpactCommandReceipt;
  }
}
