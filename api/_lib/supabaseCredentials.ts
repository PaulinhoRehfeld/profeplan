export type SupabaseAdminEnvironment = Record<string, string | undefined>;

export function resolveSupabaseAdminKey(env: SupabaseAdminEnvironment = process.env): string {
  return env.SUPABASE_SECRET_KEY?.trim() || env.SUPABASE_SERVICE_ROLE_KEY?.trim() || '';
}

export function buildSupabaseAdminHeaders(key: string): Record<string, string> {
  const headers: Record<string, string> = { apikey: key };

  // Legacy service_role keys are JWTs and must also be sent as Bearer tokens.
  // Modern sb_secret keys are not JWTs and must only use the apikey header.
  if (!key.startsWith('sb_secret_')) {
    headers.Authorization = `Bearer ${key}`;
  }

  return headers;
}
