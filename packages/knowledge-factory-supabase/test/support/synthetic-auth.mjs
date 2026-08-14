import { randomBytes } from 'node:crypto';

export const SUPABASE_AUTH_PASSWORD_MAX_BYTES = 72;

export function createSyntheticAuthPassword() {
  const password = randomBytes(32).toString('base64url');

  if (Buffer.byteLength(password, 'utf8') > SUPABASE_AUTH_PASSWORD_MAX_BYTES) {
    throw new Error('Synthetic Supabase Auth password exceeds the supported byte limit');
  }

  return password;
}
