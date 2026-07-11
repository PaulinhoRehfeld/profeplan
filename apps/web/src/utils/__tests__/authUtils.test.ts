import { describe, expect, it } from 'vitest';
import { isRetryableAuthError } from '../authUtils';

describe('isRetryableAuthError', () => {
  it.each([502, 503, 504])('retorna true para status HTTP %i', (status) => {
    expect(isRetryableAuthError({ status })).toBe(true);
  });

  it('retorna true para AuthRetryableFetchError', () => {
    expect(isRetryableAuthError({ name: 'AuthRetryableFetchError', message: 'fetch failed' })).toBe(true);
  });

  it.each(['Failed to fetch', 'Network error', 'Gateway Timeout', 'Request timeout'])(
    'retorna true para mensagem "%s"',
    (message) => {
      expect(isRetryableAuthError({ message })).toBe(true);
    }
  );

  it('retorna false para token realmente inválido (401)', () => {
    expect(isRetryableAuthError({ status: 401, message: 'invalid token' })).toBe(false);
  });

  it('retorna false para erro sem status/mensagem reconhecida', () => {
    expect(isRetryableAuthError({})).toBe(false);
    expect(isRetryableAuthError(null)).toBe(false);
    expect(isRetryableAuthError(undefined)).toBe(false);
  });
});
