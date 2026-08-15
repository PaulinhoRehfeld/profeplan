import assert from 'node:assert/strict';
import test from 'node:test';
import { SupabaseIngestionHandoffRepository } from '../src/index.ts';

const RUN_ID = 'a1000000-0000-4000-8000-000000000001';
const SOURCE_VERSION_ID = 'a2000000-0000-4000-8000-000000000001';
const REVIEWER_ID = 'a4000000-0000-4000-8000-000000000002';
const NOW = '2026-08-15T01:45:00.000Z';

function evidence() {
  return {
    contractVersion: '1.0.0',
    run: { kind: 'processing_run', id: RUN_ID },
    sourceVersion: { kind: 'source_version', id: SOURCE_VERSION_ID },
    state: 'APPROVED_FOR_EXTRACTION',
    aggregateVersion: 'revision-7',
    sequence: 7,
    review: {
      reviewId: 'ab000000-0000-4000-8000-000000000001',
      reviewMode: 'human',
      reviewer: { actorId: REVIEWER_ID, role: 'legal_editorial_reviewer' },
      decision: 'APPROVE_FOR_EXTRACTION',
      decidedAt: NOW,
      reason: 'synthetic reviewed handoff',
    },
    extractionAuthorization: {
      authorizationId: 'ac000000-0000-4000-8000-000000000001',
      sourceVersion: { kind: 'source_version', id: SOURCE_VERSION_ID },
      purpose: 'extraction',
      evaluatedAt: NOW,
    },
    reviewedArtifactId: 'ad000000-0000-4000-8000-000000000001',
    decisionCommandId: 'ae000000-0000-4000-8000-000000000001',
    approvalEventId: 'af000000-0000-4000-8000-000000000001',
    committedAt: NOW,
  };
}

test('C.2.5 handoff repository exposes only persisted eligibility evidence', async () => {
  const calls = [];
  const repository = new SupabaseIngestionHandoffRepository({
    client: {
      async rpc(name, args) {
        calls.push({ name, args });
        return { data: evidence(), error: null };
      },
    },
  });

  const result = await repository.getHandoffEvidence({ kind: 'processing_run', id: RUN_ID });
  assert.equal(result.state, 'APPROVED_FOR_EXTRACTION');
  assert.equal(result.review.decision, 'APPROVE_FOR_EXTRACTION');
  assert.equal(result.extractionAuthorization.purpose, 'extraction');
  assert.deepEqual(calls, [
    { name: 'kf_ingestion_handoff_snapshot', args: { p_run_id: RUN_ID } },
  ]);
  assert.equal('executeExtraction' in repository, false);
  assert.equal('startExtraction' in repository, false);
});

test('C.2.5 handoff mapper rejects malformed or provider-conflicting evidence', async () => {
  const wrongRole = evidence();
  wrongRole.review.reviewer.role = 'technical_admin';
  const malformed = new SupabaseIngestionHandoffRepository({
    client: { async rpc() { return { data: wrongRole, error: null }; } },
  });
  await assert.rejects(
    malformed.getHandoffEvidence({ kind: 'processing_run', id: RUN_ID }),
    (error) => error.code === 'INVALID_RESPONSE'
  );

  const providerFailure = new SupabaseIngestionHandoffRepository({
    client: {
      async rpc() {
        return { data: null, error: { code: 'PT403', message: 'raw provider authorization detail' } };
      },
    },
  });
  await assert.rejects(
    providerFailure.getHandoffEvidence({ kind: 'processing_run', id: RUN_ID }),
    (error) => error.code === 'FORBIDDEN' && !error.message.includes('raw provider authorization detail')
  );
});