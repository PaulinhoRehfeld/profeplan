import assert from 'node:assert/strict';
import test from 'node:test';
import { createClient } from '@supabase/supabase-js';
import {
  computeIngestionCommandFingerprint,
  evaluateStagingIntegrity,
} from '@profeplan/knowledge-factory';
import {
  SupabaseIngestionCommandRepository,
  SupabaseIngestionHandoffRepository,
  SupabaseIngestionRecoveryRepository,
  SupabaseTemporaryStagingAdapter,
} from '../src/index.ts';

const required = ['KF_SUPABASE_URL', 'KF_SUPABASE_SERVICE_ROLE_KEY', 'KF_SUPABASE_ANON_KEY'];
const missing = required.filter((name) => !process.env[name]);
const enabled = process.env.KF_C2_6_E2E === '1';
const integration = missing.length === 0 && enabled ? test : test.skip;

const ACTOR = { actorId: 'e4000000-0000-4000-8000-000000000001', role: 'system_worker' };
const REVIEWER = {
  actorId: 'e4100000-0000-4000-8000-000000000001',
  role: 'legal_editorial_reviewer',
};
const BASIS_TIME = '2026-08-15T01:39:00.000Z';

const success = {
  run: { kind: 'processing_run', id: 'e1000000-0000-4000-8000-000000000001' },
  sourceVersion: { kind: 'source_version', id: 'e2000000-0000-4000-8000-000000000001' },
  receivedFile: { kind: 'received_file', id: 'e3000000-0000-4000-8000-000000000001' },
  artifactId: 'e5000000-0000-4000-8000-000000000001',
  requestId: 'e6000000-0000-4000-8000-000000000001',
  correlationId: 'e7000000-0000-4000-8000-000000000001',
  temporaryStagingAuthorizationId: 'ef000000-0000-4000-8000-000000000001',
  ingestionAuthorizationId: 'ef000000-0000-4000-8000-000000000002',
  extractionAuthorizationId: 'ef000000-0000-4000-8000-000000000003',
};

const cancelled = {
  run: { kind: 'processing_run', id: 'e1000000-0000-4000-8000-000000000002' },
  sourceVersion: { kind: 'source_version', id: 'e2000000-0000-4000-8000-000000000002' },
  receivedFile: { kind: 'received_file', id: 'e3000000-0000-4000-8000-000000000002' },
  artifactId: 'e5000000-0000-4000-8000-000000000002',
  requestId: 'e6000000-0000-4000-8000-000000000002',
  correlationId: 'e7000000-0000-4000-8000-000000000002',
  temporaryStagingAuthorizationId: 'ef000000-0000-4000-8000-000000000004',
  ingestionAuthorizationId: 'ef000000-0000-4000-8000-000000000005',
};

const successBytes = new TextEncoder().encode(
  '%PDF-1.7\nsynthetic C.2.6 governed end-to-end integration fixture'
);
const cancelledBytes = new TextEncoder().encode(
  '%PDF-1.7\nsynthetic C.2.6 cancellation and cleanup fixture'
);

async function sha256(value) {
  const digest = await globalThis.crypto.subtle.digest('SHA-256', value);
  return Array.from(new Uint8Array(digest), (byte) => byte.toString(16).padStart(2, '0')).join('');
}

async function fingerprinted(command) {
  return {
    ...command,
    fingerprint: await computeIngestionCommandFingerprint(command),
  };
}

function authorizationEvidence(fixture, at) {
  return [
    {
      authorizationId: fixture.temporaryStagingAuthorizationId,
      sourceVersion: fixture.sourceVersion,
      purpose: 'temporary_staging',
      evaluatedAt: at,
    },
    {
      authorizationId: fixture.ingestionAuthorizationId,
      sourceVersion: fixture.sourceVersion,
      purpose: 'ingestion',
      evaluatedAt: at,
    },
  ];
}

async function openRun(repository, fixture, commandId, at) {
  return repository.requestIngestion(
    await fingerprinted({
      commandId,
      commandType: 'request_ingestion',
      actor: ACTOR,
      occurredAt: at,
      correlationId: fixture.correlationId,
      reason: 'synthetic C.2.6 governed ingestion request',
      request: {
        requestId: fixture.requestId,
        sourceVersion: fixture.sourceVersion,
        receivedFile: fixture.receivedFile,
        run: fixture.run,
        requestedBy: ACTOR,
        requestedAt: at,
        authorizationEvidence: authorizationEvidence(fixture, at),
      },
    })
  );
}

async function beginStaging(repository, fixture, commandId, at) {
  return repository.beginStaging(
    await fingerprinted({
      commandId,
      commandType: 'begin_staging',
      actor: ACTOR,
      occurredAt: at,
      correlationId: fixture.correlationId,
      reason: 'synthetic C.2.6 begin staging',
      run: fixture.run,
      expectedState: 'REQUESTED',
    })
  );
}

integration('C.2.6 proves governed synthetic E2E handoff plus fail-safe cleanup without executing C.3', async () => {
  const url = process.env.KF_SUPABASE_URL;
  const serviceRoleKey = process.env.KF_SUPABASE_SERVICE_ROLE_KEY;
  const anonKey = process.env.KF_SUPABASE_ANON_KEY;
  const runId = (process.env.GITHUB_RUN_ID ?? 'local').replace(/[^a-zA-Z0-9-]/gu, '').slice(-24);
  const bucketName = `kf-c2-6-${runId || 'local'}`.toLowerCase();

  const admin = createClient(url, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const anon = createClient(url, anonKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const created = await admin.storage.createBucket(bucketName, {
    public: false,
    fileSizeLimit: 1024 * 1024,
    allowedMimeTypes: ['application/pdf'],
  });
  assert.equal(created.error, null, created.error?.message);

  let now = '2026-08-15T01:40:30.000Z';
  const staging = new SupabaseTemporaryStagingAdapter(
    { client: admin, correlationId: success.correlationId },
    { bucketName, now: () => now }
  );
  const commands = new SupabaseIngestionCommandRepository({ client: admin });
  const recovery = new SupabaseIngestionRecoveryRepository({ client: admin });
  const handoff = new SupabaseIngestionHandoffRepository({ client: admin });

  try {
    // Successful governed path: source authorization -> staging -> integrity -> review -> handoff.
    const requestCommand = await fingerprinted({
      commandId: 'e9000000-0000-4000-8000-000000000001',
      commandType: 'request_ingestion',
      actor: ACTOR,
      occurredAt: BASIS_TIME,
      correlationId: success.correlationId,
      reason: 'synthetic C.2.6 governed ingestion request',
      request: {
        requestId: success.requestId,
        sourceVersion: success.sourceVersion,
        receivedFile: success.receivedFile,
        run: success.run,
        requestedBy: ACTOR,
        requestedAt: BASIS_TIME,
        authorizationEvidence: authorizationEvidence(success, BASIS_TIME),
      },
    });
    const requested = await commands.requestIngestion(requestCommand);
    assert.equal(requested.state, 'REQUESTED');
    assert.equal(requested.outcome, 'applied');

    const replay = await commands.requestIngestion(requestCommand);
    assert.equal(replay.state, 'REQUESTED');
    assert.equal(replay.outcome, 'replayed');
    assert.equal(replay.eventIds.length, requested.eventIds.length);

    const divergent = await fingerprinted({
      ...requestCommand,
      fingerprint: undefined,
      reason: 'divergent synthetic replay must fail closed',
    });
    await assert.rejects(
      commands.requestIngestion(divergent),
      (error) => error.code === 'CONFLICT'
    );

    const stagingStarted = await beginStaging(
      commands,
      success,
      'e9000000-0000-4000-8000-000000000002',
      '2026-08-15T01:40:00.000Z'
    );
    assert.equal(stagingStarted.state, 'STAGING');

    const successDigest = await sha256(successBytes);
    await recovery.prepareStagingArtifact({
      artifactId: success.artifactId,
      run: success.run,
      sourceVersion: success.sourceVersion,
      receivedFile: success.receivedFile,
      sizeBytes: successBytes.byteLength,
      mediaType: 'application/pdf',
      createdAt: '2026-08-15T01:40:30.000Z',
      expiresAt: '2026-08-15T07:40:30.000Z',
      writeIntentDigest: { algorithm: 'sha-256', value: successDigest },
      correlationId: success.correlationId,
    });

    now = '2026-08-15T01:40:31.000Z';
    const staged = await staging.stage({
      artifactId: success.artifactId,
      run: success.run,
      sourceVersion: success.sourceVersion,
      receivedFile: success.receivedFile,
      bytes: successBytes,
      mediaType: 'application/pdf',
      createdAt: '2026-08-15T01:40:30.000Z',
      expiresAt: '2026-08-15T07:40:30.000Z',
      correlationId: success.correlationId,
    });
    assert.equal(staged.state, 'STAGED');
    assert.equal(JSON.stringify(staged).includes(bucketName), false);

    const stagedReceipt = await commands.markStaged(
      await fingerprinted({
        commandId: 'e9000000-0000-4000-8000-000000000003',
        commandType: 'mark_staged',
        actor: ACTOR,
        occurredAt: '2026-08-15T01:41:00.000Z',
        correlationId: success.correlationId,
        reason: 'synthetic physical staging confirmed',
        run: success.run,
        expectedState: 'STAGING',
        expectedSequence: stagingStarted.sequence,
        stagingArtifact: staged.artifact,
        technicalMetadata: {
          declaredMediaType: 'application/pdf',
          sizeBytes: successBytes.byteLength,
        },
      }),
      staged
    );
    assert.equal(stagedReceipt.state, 'STAGED');

    const verificationStarted = await commands.beginVerification(
      await fingerprinted({
        commandId: 'e9000000-0000-4000-8000-000000000004',
        commandType: 'begin_verification',
        actor: ACTOR,
        occurredAt: '2026-08-15T01:42:00.000Z',
        correlationId: success.correlationId,
        reason: 'synthetic integrity readback',
        run: success.run,
        expectedState: 'STAGED',
        expectedSequence: stagedReceipt.sequence,
      })
    );
    assert.equal(verificationStarted.state, 'VERIFYING');

    now = '2026-08-15T01:42:30.000Z';
    const evidence = await staging.verify({
      artifact: staged,
      algorithm: 'sha-256',
      correlationId: success.correlationId,
    });
    assert.equal(evidence.digest.value, successDigest);
    assert.equal(evidence.byteLength, successBytes.byteLength);

    const decision = evaluateStagingIntegrity({
      artifact: staged,
      evidence,
      evaluatedAt: '2026-08-15T01:42:31.000Z',
    });
    assert.equal(decision.allowed, true);
    assert.equal(decision.value.state, 'VERIFIED');

    const verifiedReceipt = await commands.confirmVerified(
      await fingerprinted({
        commandId: 'e9000000-0000-4000-8000-000000000005',
        commandType: 'confirm_verified',
        actor: ACTOR,
        occurredAt: '2026-08-15T01:43:00.000Z',
        correlationId: success.correlationId,
        reason: 'synthetic SHA-256 verification confirmed',
        run: success.run,
        expectedState: 'VERIFYING',
        expectedSequence: verificationStarted.sequence,
        technicalMetadata: {
          declaredMediaType: 'application/pdf',
          sizeBytes: successBytes.byteLength,
        },
      }),
      decision.value
    );
    assert.equal(verifiedReceipt.state, 'VERIFIED');

    const reviewRequested = await commands.requestReview(
      await fingerprinted({
        commandId: 'e9000000-0000-4000-8000-000000000006',
        commandType: 'request_review',
        actor: ACTOR,
        occurredAt: '2026-08-15T01:44:00.000Z',
        correlationId: success.correlationId,
        reason: 'synthetic governed human review requested',
        run: success.run,
        expectedState: 'VERIFIED',
        expectedVersion: verifiedReceipt.aggregateVersion,
        expectedSequence: verifiedReceipt.sequence,
      })
    );
    assert.equal(reviewRequested.state, 'PENDING_REVIEW');

    const approved = await commands.approveForExtraction(
      await fingerprinted({
        commandId: 'e9000000-0000-4000-8000-000000000007',
        commandType: 'approve_for_extraction',
        actor: REVIEWER,
        occurredAt: '2026-08-15T01:45:00.000Z',
        correlationId: success.correlationId,
        reason: 'synthetic human approval for extraction eligibility',
        run: success.run,
        expectedState: 'PENDING_REVIEW',
        expectedVersion: reviewRequested.aggregateVersion,
        expectedSequence: reviewRequested.sequence,
        sourceVersion: success.sourceVersion,
        review: {
          reviewId: 'e8000000-0000-4000-8000-000000000001',
          reviewMode: 'human',
          reviewer: REVIEWER,
          decision: 'APPROVE_FOR_EXTRACTION',
          decidedAt: '2026-08-15T01:45:00.000Z',
          reason: 'synthetic C.2.6 reviewer approval',
        },
        authorizationEvidence: [
          {
            authorizationId: success.extractionAuthorizationId,
            sourceVersion: success.sourceVersion,
            purpose: 'extraction',
            evaluatedAt: '2026-08-15T01:45:00.000Z',
          },
        ],
      })
    );
    assert.equal(approved.state, 'APPROVED_FOR_EXTRACTION');

    const handoffEvidence = await handoff.getHandoffEvidence(success.run);
    assert.equal(handoffEvidence.state, 'APPROVED_FOR_EXTRACTION');
    assert.equal(handoffEvidence.review.decision, 'APPROVE_FOR_EXTRACTION');
    assert.equal(handoffEvidence.extractionAuthorization.purpose, 'extraction');
    assert.equal(handoffEvidence.reviewedArtifactId, success.artifactId);
    assert.equal('startExtraction' in handoff, false);
    assert.equal('executeExtraction' in handoff, false);

    const physicalProbe = await staging.inspect({
      artifactId: success.artifactId,
      run: success.run,
      correlationId: success.correlationId,
    });
    assert.equal(physicalProbe.outcome, 'present');
    assert.equal(physicalProbe.observedDigest.value, successDigest);

    const anonymousRead = await anon.storage
      .from(bucketName)
      .download(`runs/${encodeURIComponent(success.run.id)}/artifacts/${encodeURIComponent(success.artifactId)}`);
    assert.notEqual(anonymousRead.error, null);

    // Independent cancellation path proves controlled discard and idempotent physical cleanup.
    const cancelledRequest = await openRun(
      commands,
      cancelled,
      'e9000000-0000-4000-8000-000000000101',
      '2026-08-15T02:00:00.000Z'
    );
    assert.equal(cancelledRequest.state, 'REQUESTED');
    const cancelledStaging = await beginStaging(
      commands,
      cancelled,
      'e9000000-0000-4000-8000-000000000102',
      '2026-08-15T02:01:00.000Z'
    );
    assert.equal(cancelledStaging.state, 'STAGING');

    const cancelledDigest = await sha256(cancelledBytes);
    await recovery.prepareStagingArtifact({
      artifactId: cancelled.artifactId,
      run: cancelled.run,
      sourceVersion: cancelled.sourceVersion,
      receivedFile: cancelled.receivedFile,
      sizeBytes: cancelledBytes.byteLength,
      mediaType: 'application/pdf',
      createdAt: '2026-08-15T02:01:30.000Z',
      expiresAt: '2026-08-15T07:30:00.000Z',
      writeIntentDigest: { algorithm: 'sha-256', value: cancelledDigest },
      correlationId: cancelled.correlationId,
    });

    now = '2026-08-15T02:01:31.000Z';
    const cancelledArtifact = await staging.stage({
      artifactId: cancelled.artifactId,
      run: cancelled.run,
      sourceVersion: cancelled.sourceVersion,
      receivedFile: cancelled.receivedFile,
      bytes: cancelledBytes,
      mediaType: 'application/pdf',
      createdAt: '2026-08-15T02:01:30.000Z',
      expiresAt: '2026-08-15T07:30:00.000Z',
      correlationId: cancelled.correlationId,
    });

    const cancelledReceipt = await commands.cancelIngestion(
      await fingerprinted({
        commandId: 'e9000000-0000-4000-8000-000000000103',
        commandType: 'cancel_ingestion',
        actor: ACTOR,
        occurredAt: '2026-08-15T02:02:00.000Z',
        correlationId: cancelled.correlationId,
        reason: 'synthetic C.2.6 cancellation before extraction eligibility',
        run: cancelled.run,
        expectedState: 'STAGING',
        expectedSequence: cancelledStaging.sequence,
        reasonCode: 'operator_cancelled',
      })
    );
    assert.equal(cancelledReceipt.state, 'CANCELLED');

    await recovery.prepareDiscard({
      artifact: cancelledArtifact.artifact,
      run: cancelled.run,
      requestedAt: '2026-08-15T02:02:30.000Z',
      reasonCode: 'operator_cancelled',
      correlationId: cancelled.correlationId,
    });

    now = '2026-08-15T02:03:00.000Z';
    const discarded = await staging.discard({
      artifact: cancelledArtifact.artifact,
      run: cancelled.run,
      requestedAt: '2026-08-15T02:02:30.000Z',
      reasonCode: 'operator_cancelled',
      correlationId: cancelled.correlationId,
    });
    assert.equal(discarded.state, 'DISCARDED');
    assert.equal(discarded.outcome, 'discarded');
    const persistedDiscard = await recovery.confirmDiscard(discarded);
    assert.equal(persistedDiscard.state, 'DISCARDED');

    const repeatedDiscard = await staging.discard({
      artifact: cancelledArtifact.artifact,
      run: cancelled.run,
      requestedAt: '2026-08-15T02:02:30.000Z',
      reasonCode: 'operator_cancelled',
      correlationId: cancelled.correlationId,
    });
    assert.equal(repeatedDiscard.outcome, 'already_discarded');

    const cancelledProbe = await staging.inspect({
      artifactId: cancelled.artifactId,
      run: cancelled.run,
      correlationId: cancelled.correlationId,
    });
    assert.equal(cancelledProbe.outcome, 'absent');
  } finally {
    await admin.storage.emptyBucket(bucketName);
    const deleted = await admin.storage.deleteBucket(bucketName);
    assert.equal(deleted.error, null, deleted.error?.message);
  }
});
