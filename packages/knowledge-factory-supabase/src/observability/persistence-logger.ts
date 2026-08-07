import type { EntityId } from "@profeplan/types";

export type PersistenceLogOutcome = "success" | "failure";

export interface PersistenceLogEntry {
  readonly operation: string;
  readonly adapter: string;
  readonly durationMs: number;
  readonly outcome: PersistenceLogOutcome;
  readonly aggregateType?: string;
  readonly aggregateId?: EntityId;
  readonly correlationId?: string;
  readonly rowCount?: number;
  readonly errorCode?: string;
}

export interface PersistenceLogger {
  record(entry: PersistenceLogEntry): void;
}

export const NOOP_PERSISTENCE_LOGGER: PersistenceLogger = Object.freeze({
  record(): void {},
});

export function recordPersistenceLog(
  logger: PersistenceLogger,
  entry: PersistenceLogEntry,
): void {
  try {
    logger.record(entry);
  } catch {
    // Observability must not change the persistence result.
  }
}
