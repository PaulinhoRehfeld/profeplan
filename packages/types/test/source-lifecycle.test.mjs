import assert from 'node:assert/strict';
import test from 'node:test';
import {
  SOURCE_ACTOR_ROLES,
  SOURCE_AUTHORIZATION_STATES,
  SOURCE_IDENTITY_KINDS,
  SOURCE_LIFECYCLE_CONTRACT_VERSION,
  SOURCE_PURPOSES,
  SOURCE_REGISTRATION_STATES,
  SOURCE_STATUSES,
  SOURCE_USES,
} from '../src/index.ts';

test('source lifecycle contract is independently versioned', () => {
  assert.equal(SOURCE_LIFECYCLE_CONTRACT_VERSION, '1.0.0');
});

test('registration and authorization states remain orthogonal', () => {
  assert.deepEqual(SOURCE_REGISTRATION_STATES, [
    'REGISTERED',
    'PENDING_VALIDATION',
    'VALIDATED',
    'BLOCKED',
    'REPLACED',
    'ARCHIVED',
  ]);
  assert.deepEqual(SOURCE_AUTHORIZATION_STATES, [
    'PENDING_REVIEW',
    'GRANTED',
    'SUSPENDED',
    'REVOKED',
    'EXPIRED',
    'BLOCKED',
    'SUPERSEDED',
  ]);
});

test('source purposes cover the governed pipeline without implicit equivalence', () => {
  assert.deepEqual(SOURCE_PURPOSES, [
    'temporary_staging',
    'ingestion',
    'extraction',
    'analysis_classification',
    'distillation',
    'quotation',
    'indexing_embedding',
    'retrieval',
    'evidence',
    'generation',
  ]);
});

test('identity references distinguish bibliographic, file, processing and derived identities', () => {
  assert.deepEqual(SOURCE_IDENTITY_KINDS, [
    'work',
    'edition',
    'manifestation',
    'received_file',
    'governed_source',
    'source_version',
    'processing_run',
    'derived_artifact',
  ]);
});

test('business actor roles do not collapse technical administration into legal review', () => {
  assert.deepEqual(SOURCE_ACTOR_ROLES, [
    'curator',
    'legal_editorial_reviewer',
    'system_worker',
    'auditor',
    'technical_admin',
  ]);
});

test('legacy source status and use contracts remain unchanged in C.1.1', () => {
  assert.deepEqual(SOURCE_STATUSES, ['draft', 'approved', 'blocked', 'archived']);
  assert.deepEqual(SOURCE_USES, ['retrieval', 'generation', 'quotation', 'internal_review']);
});
