import type { IngestionCommand } from '@profeplan/types';

function canonicalize(value: unknown): string {
  if (Array.isArray(value)) {
    return `[${value.map((item) => canonicalize(item)).join(',')}]`;
  }
  if (value !== null && typeof value === 'object') {
    const entries = Object.entries(value as Record<string, unknown>)
      .filter(([, item]) => item !== undefined)
      .sort(([left], [right]) => left.localeCompare(right, 'en', { sensitivity: 'variant' }));
    return `{${entries
      .map(([key, item]) => `${JSON.stringify(key)}:${canonicalize(item)}`)
      .join(',')}}`;
  }
  const encoded = JSON.stringify(value);
  if (encoded === undefined) {
    throw new TypeError('Ingestion command fingerprint cannot encode undefined values.');
  }
  return encoded;
}

async function sha256Hex(value: string): Promise<string> {
  const bytes = new TextEncoder().encode(value);
  const digest = await globalThis.crypto.subtle.digest('SHA-256', bytes);
  return Array.from(new Uint8Array(digest), (byte) => byte.toString(16).padStart(2, '0')).join('');
}

/**
 * Computes the C.2.4 canonical command fingerprint. commandId and the supplied
 * fingerprint are transport/idempotency fields and are deliberately excluded
 * from the canonical payload. The PostgreSQL boundary independently recomputes
 * the same v1 envelope before accepting a command.
 */
export async function computeIngestionCommandFingerprint(
  command: Omit<IngestionCommand, 'fingerprint'> & { readonly fingerprint?: string }
): Promise<string> {
  const { commandId: _commandId, fingerprint: _fingerprint, ...payload } = command;
  return sha256Hex(
    canonicalize({
      fingerprintVersion: 1,
      operation: command.commandType,
      payload,
    })
  );
}

export function canonicalizeIngestionFingerprintValue(value: unknown): string {
  return canonicalize(value);
}
