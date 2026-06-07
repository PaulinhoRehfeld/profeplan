import { logger } from '@profeplan/logger';
import { NextResponse } from 'next/server';

type ApiErrorBody = {
  error: {
    code: string;
    message: string;
    details?: unknown;
  };
};

export class ApiError extends Error {
  readonly status: number;
  readonly code: string;
  readonly details?: unknown;

  constructor(status: number, code: string, message: string, details?: unknown) {
    super(message);
    this.name = 'ApiError';
    this.status = status;
    this.code = code;
    this.details = details;
  }
}

export function apiOk<T>(data: T, status = 200) {
  return NextResponse.json({ data }, { status });
}

export function apiCreated<T>(data: T) {
  return apiOk(data, 201);
}

export function apiError(error: unknown) {
  if (error instanceof ApiError) {
    logger.error(error);
    return NextResponse.json<ApiErrorBody>(
      {
        error: {
          code: error.code,
          message: error.message,
          ...(error.details ? { details: error.details } : {}),
        },
      },
      { status: error.status }
    );
  }

  logger.error(error instanceof Error ? error : new Error(String(error)));

  return NextResponse.json<ApiErrorBody>(
    {
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'Unexpected server error.',
      },
    },
    { status: 500 }
  );
}

export function withApiHandler<TArgs extends unknown[]>(
  handler: (...args: TArgs) => Promise<Response>
) {
  return async (...args: TArgs) => {
    const request = args[0] as Request | undefined;
    let correlationId = '';

    if (request && typeof request.headers?.get === 'function') {
      correlationId = request.headers.get('x-correlation-id') || '';
    }

    if (!correlationId) {
      correlationId = crypto.randomUUID();
    }

    return logger.runWithContext({ correlationId }, async () => {
      try {
        const response = await handler(...args);
        if (response && response.headers) {
          response.headers.set('x-correlation-id', correlationId);
        }
        return response;
      } catch (error) {
        const response = apiError(error);
        if (response && response.headers) {
          response.headers.set('x-correlation-id', correlationId);
        }
        return response;
      }
    });
  };
}

export async function readJsonBody(request: Request) {
  try {
    return await request.json();
  } catch {
    throw new ApiError(400, 'INVALID_JSON', 'Request body must be valid JSON.');
  }
}
