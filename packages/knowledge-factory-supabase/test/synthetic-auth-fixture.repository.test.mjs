import assert from 'node:assert/strict';
import test from 'node:test';
import {
  SUPABASE_AUTH_PASSWORD_MAX_BYTES,
  createSyntheticAuthPassword,
} from './support/synthetic-auth.mjs';

test('synthetic Supabase Auth passwords stay strong and within the bcrypt byte limit', () => {
  const passwords = Array.from({ length: 64 }, () => createSyntheticAuthPassword());

  assert.equal(new Set(passwords).size, passwords.length);
  for (const password of passwords) {
    assert.match(password, /^[A-Za-z0-9_-]+$/);
    assert.equal(Buffer.byteLength(password, 'utf8'), 43);
    assert.ok(Buffer.byteLength(password, 'utf8') <= SUPABASE_AUTH_PASSWORD_MAX_BYTES);
  }
});
