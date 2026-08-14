import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  INGESTION_COMMAND_TYPES,
  INGESTION_CONTRACT_VERSION,
  INGESTION_RUN_STATES,
  INGESTION_TERMINAL_STATES,
} from '../src/index.ts';
import { syntheticIngestionReceipt, syntheticIngestionRequest } from './ingestion-fixtures.mjs';

test('ingestion contract is independently versioned', () => {
  assert.equal(INGESTION_CONTRACT_VERSION, '1.0.0');
});

test('ingestion state machine symbols match the normative C.2 definition', () => {
  assert.deepEqual(INGESTION_RUN_STATES, [
    'REQUESTED',
    'STAGING',
    'STAGED',
    'VERIFYING',
    'VERIFIED',
    'PENDING_REVIEW',
    'APPROVED_FOR_EXTRACTION',
    'REJECTED',
    'FAILED',
    'CANCELLED',
  ]);
  assert.deepEqual(INGESTION_TERMINAL_STATES, [
    'APPROVED_FOR_EXTRACTION',
    'REJECTED',
    'FAILED',
    'CANCELLED',
  ]);
});

test('ingestion commands are explicit and closed', () => {
  assert.deepEqual(INGESTION_COMMAND_TYPES, [
    'request_ingestion',
    'begin_staging',
    'mark_staged',
    'begin_verification',
    'confirm_verified',
    'request_review',
    'approve_for_extraction',
    'reject_ingestion',
    'fail_ingestion',
    'cancel_ingestion',
  ]);
});

test('synthetic request keeps C.1 identities distinct and authorization purposes explicit', () => {
  assert.equal(syntheticIngestionRequest.sourceVersion.kind, 'source_version');
  assert.equal(syntheticIngestionRequest.receivedFile.kind, 'received_file');
  assert.equal(syntheticIngestionRequest.run.kind, 'processing_run');
  assert.deepEqual(
    syntheticIngestionRequest.authorizationEvidence.map((item) => item.purpose),
    ['temporary_staging', 'ingestion']
  );
});

test('synthetic receipt has a stable serializable provider-neutral shape', () => {
  const serialized = JSON.stringify(syntheticIngestionReceipt);
  const parsed = JSON.parse(serialized);

  assert.equal(parsed.contractVersion, '1.0.0');
  assert.equal(parsed.operation, 'request_ingestion');
  assert.equal(parsed.run.kind, 'processing_run');
  assert.equal(parsed.state, 'REQUESTED');
  assert.equal(parsed.outcome, 'applied');
});

test('shared ingestion contract does not expose provider implementation details', async () => {
  const source = await readFile(
    new URL('../src/knowledge-factory/ingestion.ts', import.meta.url),
    'utf8'
  );
  const forbidden = [
    'SupabaseClient',
    'signedUrl',
    'signed_url',
    'bucketName',
    'bucket_name',
    'SQLSTATE',
    'service_role',
    '@supabase',
  ];

  for (const token of forbidden) {
    assert.equal(source.includes(token), false, `provider detail leaked into ingestion contract: ${token}`);
  }
});
