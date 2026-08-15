import { describe, expect, it } from 'vitest';
import {
  buildSupabaseAdminHeaders,
  resolveSupabaseAdminKey,
} from '../../../../api/_lib/supabaseCredentials';

describe('Supabase credential migration', () => {
  it('prefers a modern secret key over the legacy service role key', () => {
    expect(
      resolveSupabaseAdminKey({
        SUPABASE_SECRET_KEY: ' sb_secret_preview ',
        SUPABASE_SERVICE_ROLE_KEY: 'legacy-jwt',
      })
    ).toBe('sb_secret_preview');
  });

  it('keeps the legacy key as an explicit rollback fallback', () => {
    expect(
      resolveSupabaseAdminKey({
        SUPABASE_SERVICE_ROLE_KEY: ' legacy-jwt ',
      })
    ).toBe('legacy-jwt');
  });

  it('sends modern secret keys only through the apikey header', () => {
    expect(buildSupabaseAdminHeaders('sb_secret_preview')).toEqual({
      apikey: 'sb_secret_preview',
    });
  });

  it('preserves Bearer compatibility for legacy JWT keys', () => {
    expect(buildSupabaseAdminHeaders('legacy-jwt')).toEqual({
      apikey: 'legacy-jwt',
      Authorization: 'Bearer legacy-jwt',
    });
  });
});
