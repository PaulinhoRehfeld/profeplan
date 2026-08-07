import type {
  AuditRepository,
  DomainEvent,
} from "@profeplan/knowledge-factory";
import type { EntityId } from "@profeplan/types";
import type { SupabaseSystemContext } from "../context/supabase-system-context.ts";
import {
  invalidPersistenceResponse,
  toPersistenceError,
  type KnowledgeFactoryPersistenceError,
} from "../errors/persistence-error.ts";
import {
  NOOP_PERSISTENCE_LOGGER,
  recordPersistenceLog,
  type PersistenceLogger,
} from "../observability/persistence-logger.ts";
import {
  AUDIT_EVENT_COLUMNS,
  auditRowToDomainEvent,
  domainEventToAuditRow,
} from "./audit.mapper.ts";

const ADAPTER_NAME = "SupabaseAuditRepository";
const TABLE_NAME = "kf_audit_events";

interface ProviderResponse {
  readonly data: unknown;
  readonly error: unknown;
}

function parseProviderResponse(
  value: unknown,
  operation: string,
): ProviderResponse {
  if (
    typeof value !== "object" ||
    value === null ||
    !("data" in value) ||
    !("error" in value)
  ) {
    throw invalidPersistenceResponse(operation);
  }

  return { data: value.data, error: value.error };
}

function recordSuccess(
  logger: PersistenceLogger,
  context: SupabaseSystemContext,
  operation: string,
  startedAt: number,
  aggregateType: string | undefined,
  aggregateId: EntityId,
  rowCount: number,
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: "success",
    aggregateType,
    aggregateId,
    correlationId: context.correlationId,
    rowCount,
  });
}

function recordFailure(
  logger: PersistenceLogger,
  context: SupabaseSystemContext,
  operation: string,
  startedAt: number,
  aggregateType: string | undefined,
  aggregateId: EntityId,
  error: KnowledgeFactoryPersistenceError,
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: "failure",
    aggregateType,
    aggregateId,
    correlationId: context.correlationId,
    errorCode: error.code,
  });
}

export class SupabaseAuditRepository implements AuditRepository {
  private readonly context: SupabaseSystemContext;
  private readonly logger: PersistenceLogger;

  constructor(
    context: SupabaseSystemContext,
    logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER,
  ) {
    this.context = context;
    this.logger = logger;
  }

  async append(event: DomainEvent): Promise<void> {
    const operation = "audit.append";
    const startedAt = Date.now();

    try {
      const row = domainEventToAuditRow(event, operation);
      const rawResponse: unknown = await this.context.client
        .from(TABLE_NAME)
        .insert(row)
        .select(AUDIT_EVENT_COLUMNS)
        .single();
      const response = parseProviderResponse(rawResponse, operation);

      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      if (response.data === null) {
        throw invalidPersistenceResponse(operation);
      }

      auditRowToDomainEvent(response.data, operation);
      recordSuccess(
        this.logger,
        this.context,
        operation,
        startedAt,
        event.aggregateType,
        event.aggregateId,
        1,
      );
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(
        this.logger,
        this.context,
        operation,
        startedAt,
        event.aggregateType,
        event.aggregateId,
        persistenceError,
      );
      throw persistenceError;
    }
  }

  async listByAggregate(
    aggregateId: EntityId,
  ): Promise<readonly DomainEvent[]> {
    const operation = "audit.listByAggregate";
    const startedAt = Date.now();

    try {
      const rawResponse: unknown = await this.context.client
        .from(TABLE_NAME)
        .select(AUDIT_EVENT_COLUMNS)
        .eq("aggregate_id", aggregateId)
        .order("occurred_at", { ascending: true })
        .order("id", { ascending: true });
      const response = parseProviderResponse(rawResponse, operation);

      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      if (!Array.isArray(response.data)) {
        throw invalidPersistenceResponse(operation);
      }

      const events = response.data.map((row) =>
        auditRowToDomainEvent(row, operation),
      );
      recordSuccess(
        this.logger,
        this.context,
        operation,
        startedAt,
        undefined,
        aggregateId,
        events.length,
      );
      return events;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(
        this.logger,
        this.context,
        operation,
        startedAt,
        undefined,
        aggregateId,
        persistenceError,
      );
      throw persistenceError;
    }
  }
}
