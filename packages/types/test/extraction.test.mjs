import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  EXTRACTION_AUTHORIZATION_CHECKPOINTS,
  EXTRACTION_COMMAND_TYPES,
  EXTRACTION_CONTRACT_VERSION,
  EXTRACTION_METHOD_KINDS,
  EXTRACTION_RUN_STATES,
  EXTRACTION_STATE_TRANSITIONS,
  EXTRACTION_TERMINAL_STATES,
} from '../src/index.ts';
import {
  syntheticArtifactReadAuthorizationEvidence,
  syntheticClaimAuthorizationEvidence,
  syntheticExtractionProvenance,
  syntheticExtractionQualityMeasurements,
  syntheticExtractionReceipt,
  syntheticExtractionRequest,
  syntheticFinalizationAuthorizationEvidence,
} from './extraction-fixtures.mjs';

test('extraction contract is independently versioned', () => {
  assert.equal(EXTRACTION_CONTRACT_VERSION, '1.0.0');
});

test('C.3 lifecycle matches the approved definition and never persists AUTHORIZED', () => {
  assert.deepEqual(EXTRACTION_RUN_STATES, [
    'REQUESTED',
    'READY',
    'EXTRACTING',
    'VALIDATING',
    'PENDING_REVIEW',
    'VALIDATED_FOR_SEGMENTATION',
    'REQUIRES_ALTERNATE_EXTRACTION',
    'BLOCKED_AUTHORIZATION',
    'REJECTED',
    'FAILED',
    'CANCELLED',
  ]);
  assert.equal(EXTRACTION_RUN_STATES.includes('AUTHORIZED'), false);
});

test('C.3 happy path and controlled exits are explicit', () => {
  assert.ok(EXTRACTION_STATE_TRANSITIONS.REQUESTED.includes('READY'));
  assert.ok(EXTRACTION_STATE_TRANSITIONS.READY.includes('EXTRACTING'));
  assert.ok(EXTRACTION_STATE_TRANSITIONS.EXTRACTING.includes('VALIDATING'));
  assert.ok(EXTRACTION_STATE_TRANSITIONS.VALIDATING.includes('PENDING_REVIEW'));
  assert.ok(
    EXTRACTION_STATE_TRANSITIONS.PENDING_REVIEW.includes('VALIDATED_FOR_SEGMENTATION')
  );
  assert.ok(EXTRACTION_STATE_TRANSITIONS.EXTRACTING.includes('REQUIRES_ALTERNATE_EXTRACTION'));
  assert.ok(EXTRACTION_STATE_TRANSITIONS.READY.includes('BLOCKED_AUTHORIZATION'));
  assert.ok(EXTRACTION_STATE_TRANSITIONS.PENDING_REVIEW.includes('READY'));
});

test('terminal states have no outgoing transitions', () => {
  assert.deepEqual(EXTRACTION_TERMINAL_STATES, [
    'VALIDATED_FOR_SEGMENTATION',
    'REQUIRES_ALTERNATE_EXTRACTION',
    'BLOCKED_AUTHORIZATION',
    'REJECTED',
    'FAILED',
    'CANCELLED',
  ]);

  for (const state of EXTRACTION_TERMINAL_STATES) {
    assert.deepEqual(EXTRACTION_STATE_TRANSITIONS[state], []);
  }
});

test('all transition targets belong to the closed lifecycle vocabulary', () => {
  const states = new Set(EXTRACTION_RUN_STATES);
  for (const targets of Object.values(EXTRACTION_STATE_TRANSITIONS)) {
    for (const target of targets) {
      assert.equal(states.has(target), true, `unknown extraction target state: ${target}`);
    }
  }
});

test('authorization is re-evaluated at claim, artifact read and finalization', () => {
  assert.deepEqual(EXTRACTION_AUTHORIZATION_CHECKPOINTS, [
    'claim',
    'artifact_read',
    'finalization',
  ]);

  const evidence = [
    syntheticClaimAuthorizationEvidence,
    syntheticArtifactReadAuthorizationEvidence,
    syntheticFinalizationAuthorizationEvidence,
  ];
  assert.deepEqual(
    evidence.map((item) => item.checkpoint),
    EXTRACTION_AUTHORIZATION_CHECKPOINTS
  );
  assert.equal(evidence.every((item) => item.purpose === 'extraction'), true);
});

test('C.3 commands are explicit and closed without parser or OCR commands', () => {
  assert.deepEqual(EXTRACTION_COMMAND_TYPES, [
    'request_extraction',
    'mark_ready',
    'begin_extraction',
    'begin_validation',
    'request_review',
    'approve_for_segmentation',
    'request_reprocessing',
    'require_alternate_extraction',
    'block_authorization',
    'reject_extraction',
    'fail_extraction',
    'cancel_extraction',
  ]);
  assert.deepEqual(EXTRACTION_METHOD_KINDS, ['native_text', 'alternate_extraction']);
});

test('synthetic request consumes C.2 handoff as evidence rather than current authorization', () => {
  assert.equal(syntheticExtractionRequest.run.kind, 'extraction_run');
  assert.equal(syntheticExtractionRequest.sourceVersion.kind, 'source_version');
  assert.equal(syntheticExtractionRequest.ingestionHandoff.ingestionRun.kind, 'processing_run');
  assert.equal(syntheticExtractionRequest.ingestionHandoff.contractVersion, '1.0.0');
  assert.equal('extractionAuthorization' in syntheticExtractionRequest.ingestionHandoff, false);
  assert.equal(syntheticExtractionRequest.method.kind, 'native_text');
});

test('provenance binds run, source version, ingestion run, artifact digest and method', () => {
  assert.equal(syntheticExtractionProvenance.run.id, syntheticExtractionRequest.run.id);
  assert.equal(
    syntheticExtractionProvenance.sourceVersion.id,
    syntheticExtractionRequest.sourceVersion.id
  );
  assert.equal(
    syntheticExtractionProvenance.ingestionRun.id,
    syntheticExtractionRequest.ingestionHandoff.ingestionRun.id
  );
  assert.equal(
    syntheticExtractionProvenance.artifactSha256,
    syntheticExtractionRequest.artifact.sha256
  );
  assert.deepEqual(syntheticExtractionProvenance.method, syntheticExtractionRequest.method);
});

test('quality vocabulary is observational and fixture values remain synthetic', () => {
  assert.deepEqual(
    syntheticExtractionQualityMeasurements.map((item) => item.metric),
    ['page_coverage', 'provenance_completeness']
  );
  assert.deepEqual(
    syntheticExtractionQualityMeasurements.map((item) => item.unit),
    ['ratio', 'boolean']
  );
});

test('synthetic receipt has a stable serializable provider-neutral shape', () => {
  const parsed = JSON.parse(JSON.stringify(syntheticExtractionReceipt));
  assert.equal(parsed.contractVersion, '1.0.0');
  assert.equal(parsed.operation, 'request_extraction');
  assert.equal(parsed.run.kind, 'extraction_run');
  assert.equal(parsed.state, 'REQUESTED');
  assert.equal(parsed.outcome, 'applied');
});

test('shared extraction contract does not leak provider, storage, parser or OCR implementations', async () => {
  const source = await readFile(
    new URL('../src/knowledge-factory/extraction.ts', import.meta.url),
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
    'pdfplumber',
    'tesseract',
    'GoogleDocumentAI',
    'Textract',
  ];

  for (const token of forbidden) {
    assert.equal(source.includes(token), false, `implementation detail leaked: ${token}`);
  }
});
