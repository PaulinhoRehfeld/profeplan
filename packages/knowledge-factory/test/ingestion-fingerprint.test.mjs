import assert from 'node:assert/strict';
import test from 'node:test';
import {
  canonicalizeIngestionFingerprintValue,
  computeIngestionCommandFingerprint,
} from '../src/index.ts';

test('canonical fingerprint key ordering matches PostgreSQL COLLATE C for camelCase prefixes', () => {
  assert.equal(
    canonicalizeIngestionFingerprintValue({
      requestedBy: 'actor',
      requestedAt: '2026-08-15T01:39:00.000Z',
      requestId: 'request',
    }),
    '{"requestId":"request","requestedAt":"2026-08-15T01:39:00.000Z","requestedBy":"actor"}'
  );
});

test('request_ingestion fingerprint matches the PostgreSQL v1 canonical vector', async () => {
  const sourceVersion = {
    kind: 'source_version',
    id: 'e2000000-0000-4000-8000-000000000001',
  };
  const command = {
    commandId: 'e9000000-0000-4000-8000-000000000001',
    commandType: 'request_ingestion',
    actor: {
      actorId: 'e4000000-0000-4000-8000-000000000001',
      role: 'system_worker',
    },
    occurredAt: '2026-08-15T01:39:00.000Z',
    correlationId: 'e7000000-0000-4000-8000-000000000001',
    reason: 'synthetic C.2.6 governed ingestion request',
    request: {
      requestId: 'e6000000-0000-4000-8000-000000000001',
      sourceVersion,
      receivedFile: {
        kind: 'received_file',
        id: 'e3000000-0000-4000-8000-000000000001',
      },
      run: {
        kind: 'processing_run',
        id: 'e1000000-0000-4000-8000-000000000001',
      },
      requestedBy: {
        actorId: 'e4000000-0000-4000-8000-000000000001',
        role: 'system_worker',
      },
      requestedAt: '2026-08-15T01:39:00.000Z',
      authorizationEvidence: [
        {
          authorizationId: 'ef000000-0000-4000-8000-000000000001',
          sourceVersion,
          purpose: 'temporary_staging',
          evaluatedAt: '2026-08-15T01:39:00.000Z',
        },
        {
          authorizationId: 'ef000000-0000-4000-8000-000000000002',
          sourceVersion,
          purpose: 'ingestion',
          evaluatedAt: '2026-08-15T01:39:00.000Z',
        },
      ],
    },
  };

  assert.equal(
    await computeIngestionCommandFingerprint(command),
    '7a812ddb177c2ab737ab429a925b74c167638af7ce4ac6ed63bd86b512399317'
  );
});
