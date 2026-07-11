import { describe, expect, it, vi } from 'vitest';

// supabaseClient.ts lança erro no import se as env vars não estiverem definidas
// (CI não tem VITE_SUPABASE_URL/ANON_KEY configuradas para o step de testes) —
// mockado aqui porque authUtils.ts importa resolveAuthUid, que depende do client,
// embora este arquivo só teste isRetryableAuthError (função pura, sem I/O).
vi.mock('../../services/supabaseClient', () => ({
  supabase: { auth: { getUser: vi.fn(), getSession: vi.fn() } },
}));

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
