\set ON_ERROR_STOP on

-- Synthetic-only C.3.2 proof. Requires C.2.4 + C.2.5 SQL proofs to have
-- produced one APPROVED_FOR_EXTRACTION handoff in the disposable database.
-- No PDF bytes, extracted text, OCR, embeddings, chunks or real content.

DO $test$
DECLARE
  v_ingestion public.kf_ingestion_runs%ROWTYPE;
  v_approval public.kf_ingestion_events%ROWTYPE;
  v_approval_receipt public.kf_ingestion_command_receipts%ROWTYPE;
  v_artifact public.kf_ingestion_staging_artifacts%ROWTYPE;
  v_integrity public.kf_ingestion_integrity_evidence%ROWTYPE;
  v_payload jsonb;
  v_divergent jsonb;
  v_fp text;
  v_result record;
  v_version text;
  v_sequence bigint;
  v_receipts_before bigint;
  v_events_before bigint;
  v_snapshot jsonb;
BEGIN
  SELECT * INTO v_ingestion
  FROM public.kf_ingestion_runs
  WHERE state = 'APPROVED_FOR_EXTRACTION'
  ORDER BY updated_at DESC
  LIMIT 1;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'C.2 approved handoff fixture is unavailable for C.3.2';
  END IF;

  SELECT * INTO v_approval
  FROM public.kf_ingestion_events
  WHERE run_id = v_ingestion.run_id
    AND event_type = 'ingestion_approved_for_extraction'
  ORDER BY sequence DESC
  LIMIT 1;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'C.2 approval event fixture is unavailable for C.3.2';
  END IF;

  SELECT * INTO v_approval_receipt
  FROM public.kf_ingestion_command_receipts
  WHERE command_id = v_approval.command_id;

  SELECT * INTO v_artifact
  FROM public.kf_ingestion_staging_artifacts
  WHERE artifact_id = v_approval.reviewed_artifact_id;

  SELECT * INTO v_integrity
  FROM public.kf_ingestion_integrity_evidence
  WHERE artifact_id = v_approval.reviewed_artifact_id;

  IF v_artifact.state <> 'VERIFIED' OR v_integrity.digest_algorithm <> 'sha-256' THEN
    RAISE EXCEPTION 'C.2 verified artifact/integrity fixture is inconsistent';
  END IF;

  -- Canonical request binds exactly to the immutable C.2 handoff.
  v_payload := jsonb_build_object(
    'commandType','request_extraction',
    'actor',jsonb_build_object(
      'actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'
    ),
    'occurredAt','2026-08-15T02:00:00.000Z',
    'correlationId','e5000000-0000-4000-8000-000000000001',
    'reason','synthetic C.3.2 extraction request',
    'request',jsonb_build_object(
      'requestId','e6000000-0000-4000-8000-000000000001',
      'run',jsonb_build_object(
        'kind','extraction_run','id','e1000000-0000-4000-8000-000000000001'
      ),
      'sourceVersion',jsonb_build_object(
        'kind','source_version','id',v_ingestion.source_version_id
      ),
      'ingestionHandoff',jsonb_build_object(
        'contractVersion','1.0.0',
        'ingestionRun',jsonb_build_object('kind','processing_run','id',v_ingestion.run_id),
        'aggregateVersion',v_ingestion.aggregate_version,
        'sequence',v_ingestion.sequence,
        'reviewedArtifactId',v_approval.reviewed_artifact_id,
        'approvalEventId',v_approval.event_id,
        'committedAt',to_char(v_approval_receipt.committed_at AT TIME ZONE 'UTC','YYYY-MM-DD"T"HH24:MI:SS.US"Z"')
      ),
      'artifact',jsonb_build_object(
        'artifactId',v_artifact.artifact_id,
        'sha256',v_integrity.digest_value,
        'sizeBytes',v_integrity.byte_length
      ),
      'method',jsonb_build_object(
        'kind','native_text','name','synthetic-native-text-extractor','version','1.0.0'
      ),
      'requestedBy',jsonb_build_object(
        'actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'
      ),
      'requestedAt','2026-08-15T02:00:00.000Z'
    )
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('request_extraction',v_payload);
  SELECT * INTO v_result FROM public.kf_extraction_request(
    'e7000000-0000-4000-8000-000000000001',v_fp,v_payload
  );
  IF v_result.contract_version <> '1.0.0'
    OR v_result.state <> 'REQUESTED'
    OR v_result.sequence <> 1
    OR v_result.replayed THEN
    RAISE EXCEPTION 'request_extraction did not create the expected durable C.3 run';
  END IF;

  -- Identical lost-response replay returns the original receipt and no duplicate event.
  SELECT * INTO v_result FROM public.kf_extraction_request(
    'e7000000-0000-4000-8000-000000000001',v_fp,v_payload
  );
  IF NOT v_result.replayed OR v_result.sequence <> 1 THEN
    RAISE EXCEPTION 'request_extraction replay did not return original receipt';
  END IF;
  IF (
    SELECT count(*) FROM public.kf_extraction_events
    WHERE command_id='e7000000-0000-4000-8000-000000000001'
  ) <> 1 THEN
    RAISE EXCEPTION 'request_extraction replay duplicated event';
  END IF;

  -- Same commandId with divergent canonical payload fails closed.
  v_divergent := jsonb_set(v_payload,'{reason}','"divergent synthetic request"'::jsonb);
  BEGIN
    PERFORM * FROM public.kf_extraction_request(
      'e7000000-0000-4000-8000-000000000001',
      public.kf_extraction_command_fingerprint_internal('request_extraction',v_divergent),
      v_divergent
    );
    RAISE EXCEPTION 'divergent extraction replay was accepted';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;

  -- A stale/tampered C.2 handoff can never open a second C.3 run.
  v_divergent := jsonb_set(
    v_payload,
    '{request,run,id}',
    '"e1000000-0000-4000-8000-000000000002"'::jsonb
  );
  v_divergent := jsonb_set(
    v_divergent,
    '{request,requestId}',
    '"e6000000-0000-4000-8000-000000000002"'::jsonb
  );
  v_divergent := jsonb_set(
    v_divergent,
    '{request,ingestionHandoff,aggregateVersion}',
    '"tampered-version"'::jsonb
  );
  BEGIN
    PERFORM * FROM public.kf_extraction_request(
      'e7000000-0000-4000-8000-000000000002',
      public.kf_extraction_command_fingerprint_internal('request_extraction',v_divergent),
      v_divergent
    );
    RAISE EXCEPTION 'tampered C.2 handoff was accepted';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;
  IF EXISTS (
    SELECT 1 FROM public.kf_extraction_runs
    WHERE run_id='e1000000-0000-4000-8000-000000000002'
  ) THEN
    RAISE EXCEPTION 'failed handoff request left a partial extraction run';
  END IF;

  -- Alternate extraction/OCR remains outside C.3.2 even though it exists in vocabulary.
  v_divergent := jsonb_set(
    v_payload,
    '{request,run,id}',
    '"e1000000-0000-4000-8000-000000000003"'::jsonb
  );
  v_divergent := jsonb_set(
    v_divergent,
    '{request,requestId}',
    '"e6000000-0000-4000-8000-000000000003"'::jsonb
  );
  v_divergent := jsonb_set(v_divergent,'{request,method,kind}','"alternate_extraction"'::jsonb);
  BEGIN
    PERFORM * FROM public.kf_extraction_request(
      'e7000000-0000-4000-8000-000000000003',
      public.kf_extraction_command_fingerprint_internal('request_extraction',v_divergent),
      v_divergent
    );
    RAISE EXCEPTION 'alternate extraction was accepted before C.3.7';
  EXCEPTION WHEN SQLSTATE 'PT403' THEN NULL;
  END;

  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_extraction_runs
  WHERE run_id='e1000000-0000-4000-8000-000000000001';

  -- REQUESTED -> READY with full state/version/sequence CAS.
  v_payload := jsonb_build_object(
    'commandType','mark_ready',
    'actor',jsonb_build_object(
      'actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'
    ),
    'occurredAt','2026-08-15T02:01:00.000Z',
    'correlationId','e5000000-0000-4000-8000-000000000001',
    'reason','synthetic C.3.2 readiness transition',
    'run',jsonb_build_object(
      'kind','extraction_run','id','e1000000-0000-4000-8000-000000000001'
    ),
    'expectedState','REQUESTED',
    'expectedVersion',v_version,
    'expectedSequence',v_sequence
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('mark_ready',v_payload);
  SELECT * INTO v_result FROM public.kf_extraction_mark_ready(
    'e7000000-0000-4000-8000-000000000004',v_fp,v_payload
  );
  IF v_result.state <> 'READY' OR v_result.sequence <> 2 OR v_result.replayed THEN
    RAISE EXCEPTION 'mark_ready did not advance atomically';
  END IF;

  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_extraction_runs
  WHERE run_id='e1000000-0000-4000-8000-000000000001';

  -- Stale CAS fails before any receipt/event is appended.
  SELECT count(*) INTO v_receipts_before FROM public.kf_extraction_command_receipts
  WHERE run_id='e1000000-0000-4000-8000-000000000001';
  SELECT count(*) INTO v_events_before FROM public.kf_extraction_events
  WHERE run_id='e1000000-0000-4000-8000-000000000001';
  v_payload := jsonb_build_object(
    'commandType','begin_extraction',
    'actor',jsonb_build_object(
      'actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'
    ),
    'occurredAt','2026-08-15T02:02:00.000Z',
    'correlationId','e5000000-0000-4000-8000-000000000001',
    'reason','stale CAS must fail',
    'run',jsonb_build_object(
      'kind','extraction_run','id','e1000000-0000-4000-8000-000000000001'
    ),
    'expectedState','READY','expectedVersion','stale-version','expectedSequence',v_sequence,
    'authorizationEvidence',jsonb_build_object(
      'authorizationId','cf000000-0000-4000-8000-000000000005',
      'sourceVersion',jsonb_build_object('kind','source_version','id',v_ingestion.source_version_id),
      'purpose','extraction','checkpoint','claim','evaluatedAt','2026-08-15T02:02:00.000Z'
    )
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('begin_extraction',v_payload);
  BEGIN
    PERFORM * FROM public.kf_extraction_begin(
      'e7000000-0000-4000-8000-000000000005',v_fp,v_payload
    );
    RAISE EXCEPTION 'stale extraction CAS was accepted';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;
  IF (SELECT count(*) FROM public.kf_extraction_command_receipts
      WHERE run_id='e1000000-0000-4000-8000-000000000001') <> v_receipts_before
    OR (SELECT count(*) FROM public.kf_extraction_events
        WHERE run_id='e1000000-0000-4000-8000-000000000001') <> v_events_before THEN
    RAISE EXCEPTION 'failed stale CAS left partial durable effects';
  END IF;

  -- Authorization valid historically at C.2 approval but expired at claim fails now.
  v_payload := jsonb_set(v_payload,'{expectedVersion}',to_jsonb(v_version));
  v_payload := jsonb_set(v_payload,'{occurredAt}','"2026-08-15T06:30:00.000Z"'::jsonb);
  v_payload := jsonb_set(
    v_payload,'{authorizationEvidence,evaluatedAt}','"2026-08-15T06:30:00.000Z"'::jsonb
  );
  v_payload := jsonb_set(v_payload,'{reason}','"expired claim authorization must fail"'::jsonb);
  v_fp := public.kf_extraction_command_fingerprint_internal('begin_extraction',v_payload);
  BEGIN
    PERFORM * FROM public.kf_extraction_begin(
      'e7000000-0000-4000-8000-000000000006',v_fp,v_payload
    );
    RAISE EXCEPTION 'expired claim authorization was accepted';
  EXCEPTION WHEN SQLSTATE 'PT403' THEN NULL;
  END;
  IF (SELECT state FROM public.kf_extraction_runs
      WHERE run_id='e1000000-0000-4000-8000-000000000001') <> 'READY' THEN
    RAISE EXCEPTION 'failed authorization changed extraction state';
  END IF;

  -- Valid current claim authorization advances READY -> EXTRACTING.
  v_payload := jsonb_set(v_payload,'{occurredAt}','"2026-08-15T02:02:00.000Z"'::jsonb);
  v_payload := jsonb_set(
    v_payload,'{authorizationEvidence,evaluatedAt}','"2026-08-15T02:02:00.000Z"'::jsonb
  );
  v_payload := jsonb_set(v_payload,'{reason}','"valid current claim authorization"'::jsonb);
  v_fp := public.kf_extraction_command_fingerprint_internal('begin_extraction',v_payload);
  SELECT * INTO v_result FROM public.kf_extraction_begin(
    'e7000000-0000-4000-8000-000000000007',v_fp,v_payload
  );
  IF v_result.state <> 'EXTRACTING' OR v_result.sequence <> 3 OR v_result.replayed THEN
    RAISE EXCEPTION 'valid begin_extraction did not advance to EXTRACTING';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.kf_extraction_events
    WHERE command_id='e7000000-0000-4000-8000-000000000007'
      AND event_type='extraction_started'
      AND authorization_id='cf000000-0000-4000-8000-000000000005'
      AND authorization_checkpoint='claim'
      AND authorization_evaluated_at='2026-08-15T02:02:00.000Z'
  ) THEN
    RAISE EXCEPTION 'claim authorization evidence was not persisted with extraction_started';
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.kf_extraction_runs WHERE state='AUTHORIZED'
  ) OR EXISTS (
    SELECT 1 FROM public.kf_extraction_events
    WHERE from_state='AUTHORIZED' OR to_state='AUTHORIZED'
  ) THEN
    RAISE EXCEPTION 'durable AUTHORIZED state leaked into C.3';
  END IF;

  -- Projection/history reconstruction must agree exactly at sequence 3.
  IF (
    SELECT count(*) FROM public.kf_extraction_command_receipts
    WHERE run_id='e1000000-0000-4000-8000-000000000001'
  ) <> 3 OR (
    SELECT count(*) FROM public.kf_extraction_events
    WHERE run_id='e1000000-0000-4000-8000-000000000001'
  ) <> 3 THEN
    RAISE EXCEPTION 'C.3.2 projection cannot be reconstructed from receipts/events';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.kf_extraction_runs AS run
    LEFT JOIN LATERAL (
      SELECT event.aggregate_version,event.sequence,event.to_state
      FROM public.kf_extraction_events AS event
      WHERE event.run_id=run.run_id
      ORDER BY event.sequence DESC
      LIMIT 1
    ) AS latest ON true
    WHERE run.run_id='e1000000-0000-4000-8000-000000000001'
      AND (
        latest.aggregate_version IS DISTINCT FROM run.aggregate_version
        OR latest.sequence IS DISTINCT FROM run.sequence
        OR latest.to_state IS DISTINCT FROM run.state
      )
  ) THEN
    RAISE EXCEPTION 'extraction projection diverged from append-only event history';
  END IF;

  v_snapshot := public.kf_extraction_snapshot('e1000000-0000-4000-8000-000000000001');
  IF v_snapshot ->> 'state' <> 'EXTRACTING'
    OR (v_snapshot ->> 'sequence')::bigint <> 3
    OR v_snapshot #>> '{method,kind}' <> 'native_text' THEN
    RAISE EXCEPTION 'read-only extraction snapshot is inconsistent';
  END IF;
END;
$test$;

-- RLS/grants: service_role can use narrow RPCs but cannot directly mutate tables.
DO $privilege_tests$
BEGIN
  IF has_table_privilege('service_role','public.kf_extraction_runs','INSERT')
    OR has_table_privilege('service_role','public.kf_extraction_runs','UPDATE')
    OR has_table_privilege('service_role','public.kf_extraction_runs','DELETE')
    OR has_table_privilege('anon','public.kf_extraction_runs','SELECT')
    OR has_table_privilege('authenticated','public.kf_extraction_events','SELECT') THEN
    RAISE EXCEPTION 'C.3.2 table privilege escaped deny-by-default';
  END IF;
  IF NOT has_function_privilege(
    'service_role','public.kf_extraction_begin(uuid,text,jsonb)','EXECUTE'
  ) THEN
    RAISE EXCEPTION 'service_role lacks the narrow extraction RPC capability';
  END IF;
END;
$privilege_tests$;

-- The technical role does not become a business authorization bypass.
SET ROLE service_role;
DO $service_role_auth_test$
DECLARE
  v_run public.kf_extraction_runs%ROWTYPE;
  v_payload jsonb;
  v_fp text;
BEGIN
  SELECT * INTO v_run
  FROM public.kf_extraction_runs
  WHERE run_id='e1000000-0000-4000-8000-000000000001';

  -- Direct DML must fail despite service_role being the RPC channel.
  BEGIN
    UPDATE public.kf_extraction_runs
    SET state='FAILED'
    WHERE run_id=v_run.run_id;
    RAISE EXCEPTION 'service_role direct DML unexpectedly succeeded';
  EXCEPTION WHEN insufficient_privilege THEN NULL;
  END;

  -- A fresh READY run is created below by postgres; this block only proves the
  -- service_role cannot bypass an invalid current authorization through RPC.
END;
$service_role_auth_test$;
RESET ROLE;

-- Create an independent synthetic run for the service_role negative auth and
-- controlled BLOCKED_AUTHORIZATION terminal path.
DO $second_run$
DECLARE
  v_ingestion public.kf_ingestion_runs%ROWTYPE;
  v_approval public.kf_ingestion_events%ROWTYPE;
  v_receipt public.kf_ingestion_command_receipts%ROWTYPE;
  v_artifact public.kf_ingestion_staging_artifacts%ROWTYPE;
  v_integrity public.kf_ingestion_integrity_evidence%ROWTYPE;
  v_payload jsonb;
  v_fp text;
  v_result record;
  v_version text;
  v_sequence bigint;
BEGIN
  SELECT * INTO v_ingestion FROM public.kf_ingestion_runs
  WHERE state='APPROVED_FOR_EXTRACTION' ORDER BY updated_at DESC LIMIT 1;
  SELECT * INTO v_approval FROM public.kf_ingestion_events
  WHERE run_id=v_ingestion.run_id AND event_type='ingestion_approved_for_extraction'
  ORDER BY sequence DESC LIMIT 1;
  SELECT * INTO v_receipt FROM public.kf_ingestion_command_receipts
  WHERE command_id=v_approval.command_id;
  SELECT * INTO v_artifact FROM public.kf_ingestion_staging_artifacts
  WHERE artifact_id=v_approval.reviewed_artifact_id;
  SELECT * INTO v_integrity FROM public.kf_ingestion_integrity_evidence
  WHERE artifact_id=v_artifact.artifact_id;

  v_payload := jsonb_build_object(
    'commandType','request_extraction',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T02:10:00.000Z',
    'correlationId','e5000000-0000-4000-8000-000000000002',
    'reason','second synthetic extraction run',
    'request',jsonb_build_object(
      'requestId','e6000000-0000-4000-8000-000000000004',
      'run',jsonb_build_object('kind','extraction_run','id','e1000000-0000-4000-8000-000000000004'),
      'sourceVersion',jsonb_build_object('kind','source_version','id',v_ingestion.source_version_id),
      'ingestionHandoff',jsonb_build_object(
        'contractVersion','1.0.0',
        'ingestionRun',jsonb_build_object('kind','processing_run','id',v_ingestion.run_id),
        'aggregateVersion',v_ingestion.aggregate_version,'sequence',v_ingestion.sequence,
        'reviewedArtifactId',v_approval.reviewed_artifact_id,'approvalEventId',v_approval.event_id,
        'committedAt',to_char(v_receipt.committed_at AT TIME ZONE 'UTC','YYYY-MM-DD"T"HH24:MI:SS.US"Z"')
      ),
      'artifact',jsonb_build_object(
        'artifactId',v_artifact.artifact_id,'sha256',v_integrity.digest_value,'sizeBytes',v_integrity.byte_length
      ),
      'method',jsonb_build_object('kind','native_text','name','synthetic-native-text-extractor','version','1.0.0'),
      'requestedBy',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
      'requestedAt','2026-08-15T02:10:00.000Z'
    )
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('request_extraction',v_payload);
  PERFORM * FROM public.kf_extraction_request(
    'e7000000-0000-4000-8000-000000000008',v_fp,v_payload
  );
  SELECT aggregate_version,sequence INTO v_version,v_sequence FROM public.kf_extraction_runs
  WHERE run_id='e1000000-0000-4000-8000-000000000004';

  v_payload := jsonb_build_object(
    'commandType','mark_ready',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T02:11:00.000Z','correlationId','e5000000-0000-4000-8000-000000000002',
    'reason','second synthetic run ready',
    'run',jsonb_build_object('kind','extraction_run','id','e1000000-0000-4000-8000-000000000004'),
    'expectedState','REQUESTED','expectedVersion',v_version,'expectedSequence',v_sequence
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('mark_ready',v_payload);
  PERFORM * FROM public.kf_extraction_mark_ready(
    'e7000000-0000-4000-8000-000000000009',v_fp,v_payload
  );
END;
$second_run$;

SET ROLE service_role;
DO $service_role_invalid_claim$
DECLARE
  v_run public.kf_extraction_runs%ROWTYPE;
  v_payload jsonb;
  v_fp text;
BEGIN
  SELECT * INTO v_run FROM public.kf_extraction_runs
  WHERE run_id='e1000000-0000-4000-8000-000000000004';
  v_payload := jsonb_build_object(
    'commandType','begin_extraction',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T06:30:00.000Z','correlationId','e5000000-0000-4000-8000-000000000002',
    'reason','service_role cannot bypass expired extraction authorization',
    'run',jsonb_build_object('kind','extraction_run','id',v_run.run_id),
    'expectedState','READY','expectedVersion',v_run.aggregate_version,'expectedSequence',v_run.sequence,
    'authorizationEvidence',jsonb_build_object(
      'authorizationId','cf000000-0000-4000-8000-000000000005',
      'sourceVersion',jsonb_build_object('kind','source_version','id',v_run.source_version_id),
      'purpose','extraction','checkpoint','claim','evaluatedAt','2026-08-15T06:30:00.000Z'
    )
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('begin_extraction',v_payload);
  BEGIN
    PERFORM * FROM public.kf_extraction_begin(
      'e7000000-0000-4000-8000-000000000010',v_fp,v_payload
    );
    RAISE EXCEPTION 'service_role bypassed current C.1 extraction authorization';
  EXCEPTION WHEN SQLSTATE 'PT403' THEN NULL;
  END;
END;
$service_role_invalid_claim$;
RESET ROLE;

DO $blocked_path$
DECLARE
  v_run public.kf_extraction_runs%ROWTYPE;
  v_payload jsonb;
  v_fp text;
  v_result record;
BEGIN
  SELECT * INTO v_run FROM public.kf_extraction_runs
  WHERE run_id='e1000000-0000-4000-8000-000000000004';
  v_payload := jsonb_build_object(
    'commandType','block_authorization',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T02:12:00.000Z','correlationId','e5000000-0000-4000-8000-000000000002',
    'reason','persist explicit authorization block without AUTHORIZED state',
    'run',jsonb_build_object('kind','extraction_run','id',v_run.run_id),
    'expectedState','READY','expectedVersion',v_run.aggregate_version,'expectedSequence',v_run.sequence,
    'reasonCode','authorization_invalid'
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('block_authorization',v_payload);
  SELECT * INTO v_result FROM public.kf_extraction_block_authorization(
    'e7000000-0000-4000-8000-000000000011',v_fp,v_payload
  );
  IF v_result.state <> 'BLOCKED_AUTHORIZATION' THEN
    RAISE EXCEPTION 'controlled authorization block did not become terminal';
  END IF;
END;
$blocked_path$;

SELECT 'C.3.2 extraction control-plane proof passed' AS result;
