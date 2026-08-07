export const PERSISTENCE_ERROR_CODES = [
  'NOT_FOUND',
  'CONFLICT',
  'CONSTRAINT_VIOLATION',
  'UNAUTHORIZED',
  'FORBIDDEN',
  'UNAVAILABLE',
  'INVALID_RESPONSE',
  'UNKNOWN',
] as const;

export type PersistenceErrorCode = (typeof PERSISTENCE_ERROR_CODES)[number];

export class KnowledgeFactoryPersistenceError extends Error {
  readonly code: PersistenceErrorCode;
  readonly operation: string;

  constructor(code: PersistenceErrorCode, operation: string) {
    super(`Persistence operation failed (${code})`);
    this.name = 'KnowledgeFactoryPersistenceError';
    this.code = code;
    this.operation = operation;
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function providerText(error: Record<string, unknown>): string {
  return [error.name, error.message, error.details, error.hint]
    .filter((value): value is string => typeof value === 'string')
    .join(' ')
    .toLowerCase();
}

export function toPersistenceError(
  error: unknown,
  operation: string
): KnowledgeFactoryPersistenceError {
  if (error instanceof KnowledgeFactoryPersistenceError) {
    return error;
  }

  if (!isRecord(error)) {
    return new KnowledgeFactoryPersistenceError('UNKNOWN', operation);
  }

  const code = typeof error.code === 'string' ? error.code : undefined;
  const status = typeof error.status === 'number' ? error.status : undefined;
  const text = providerText(error);

  if (code === '23505') {
    return new KnowledgeFactoryPersistenceError('CONFLICT', operation);
  }

  if (code === '23503' || code === '23514' || code === '23502') {
    return new KnowledgeFactoryPersistenceError('CONSTRAINT_VIOLATION', operation);
  }

  if (code === '42501' || /permission denied|insufficient privilege/.test(text)) {
    return new KnowledgeFactoryPersistenceError('FORBIDDEN', operation);
  }

  if (status === 401 || code === 'PGRST301' || /missing.*identity|jwt.*missing/.test(text)) {
    return new KnowledgeFactoryPersistenceError('UNAUTHORIZED', operation);
  }

  if (code === 'PGRST116' || status === 404) {
    return new KnowledgeFactoryPersistenceError('NOT_FOUND', operation);
  }

  if (
    error.name === 'AbortError' ||
    /network|fetch failed|failed to fetch|timeout|timed out|connection/.test(text)
  ) {
    return new KnowledgeFactoryPersistenceError('UNAVAILABLE', operation);
  }

  return new KnowledgeFactoryPersistenceError('UNKNOWN', operation);
}

export function invalidPersistenceResponse(operation: string): KnowledgeFactoryPersistenceError {
  return new KnowledgeFactoryPersistenceError('INVALID_RESPONSE', operation);
}
