\set ON_ERROR_STOP on

-- Synthetic-only C.2.5 proof. Requires the C.2.4 SQL proof to have left
-- c100...001 in VERIFIED. No hosted resource or protected content is used.

INSERT INTO public.kf_source_actor_assignments(
  id, actor_id, actor_role, effective_from, effective_until
) VALUES
  ('ca100000-0000-4000-8000-000000000001','c4000000-0000-4000-8000-000000000001','system_worker','2026-08-15T00:00:00Z','2026-08-15T10:00:00Z'),
  ('ca100000-0000-4000-8000-000000000002','c4100000-0000-4000-8000-000000000001','legal_editorial_reviewer','2026-08-15T00:00:00Z','2026-08-15T10:00:00Z'),
  ('ca100000-0000-4000-8000-000000000003','c4100000-0000-4000-8000-000000000003','legal_editorial_reviewer','2026-08-15T00:00:00Z','2026-08-15T01:43:00Z');

-- C.1 remains the authority for extraction. This fixture records a real C.1
-- authorization history event so C.2.5 can evaluate it as-of the review time.
INSERT INTO public.kf_source_authorizations(
  id, subject_identity_id, purpose, restrictions, basis_id,
  effective_from, effective_until, projected_state, aggregate_version, sequence
) VALUES (
  'cf000000-0000-4000-8000-000000000005',
  'c2000000-0000-4000-8000-000000000001',
  'extraction','{}','ce000000-0000-4000-8000-000000000001',
  '2026-08-15T00:00:00Z','2026-08-15T06:00:00Z','GRANTED','auth-extraction-v1',1
);
INSERT INTO public.kf_source_command_receipts(
  command_id,fingerprint,dimension,operation,aggregate_id,authorization_id,
  aggregate_version,sequence,authorization_state
) VALUES (
  'cb000000-0000-4000-8000-000000000005','synthetic-c25-extraction-grant',
  'authorization','grant_authorization','cf000000-0000-4000-8000-000000000005',
  'cf000000-0000-4000-8000-000000000005','auth-extraction-v1',1,'GRANTED'
);
INSERT INTO public.kf_source_governance_events(
  event_id,dimension,aggregate_id,aggregate_version,sequence,event_type,
  subject_identity_id,authorization_id,purpose,restrictions,basis_id,
  actor_id,actor_role,reason,occurred_at,effective_at,correlation_id,command_id,
  authorization_to_state,effective_from,effective_until
) VALUES (
  'cc000000-0000-4000-8000-000000000005','authorization',
  'cf000000-0000-4000-8000-000000000005','auth-extraction-v1',1,'authorization_granted',
  'c2000000-0000-4000-8000-000000000001','cf000000-0000-4000-8000-000000000005',
  'extraction','{}','ce000000-0000-4000-8000-000000000001',
  'c4100000-0000-4000-8000-000000000001','legal_editorial_reviewer',
  'synthetic extraction authorization','2026-08-15T01:00:00Z','2026-08-15T01:00:00Z',
  'cd000000-0000-4000-8000-000000000005','cb000000-0000-4000-8000-000000000005',
  'GRANTED','2026-08-15T00:00:00Z','2026-08-15T06:00:00Z'
);
INSERT INTO public.kf_source_command_receipt_events(command_id,event_id,event_order)
VALUES ('cb000000-0000-4000-8000-000000000005','cc000000-0000-4000-8000-000000000005',1);

DO $test$
DECLARE
  v_command jsonb;
  v_fp text;
  v_result record;
  v_version text;
  v_sequence bigint;
  v_snapshot jsonb;
  v_count bigint;
BEGIN
  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_ingestion_runs WHERE run_id='c1000000-0000-4000-8000-000000000001';
  IF v_sequence <> 5 OR (SELECT state FROM public.kf_ingestion_runs WHERE run_id='c1000000-0000-4000-8000-000000000001') <> 'VERIFIED' THEN
    RAISE EXCEPTION 'C.2.4 verified fixture is not available for C.2.5';
  END IF;

  -- VERIFIED -> PENDING_REVIEW uses the existing C.2.1 state machine.
  v_command := jsonb_build_object(
    'commandType','request_review',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T01:44:00.000Z',
    'correlationId','c5000000-0000-4000-8000-000000000005',
    'reason','synthetic request for governed human review',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000001'),
    'expectedState','VERIFIED','expectedVersion',v_version,'expectedSequence',v_sequence
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('request_review',v_command);
  SELECT * INTO v_result FROM public.kf_ingestion_request_review(
    'd5000000-0000-4000-8000-000000000001',v_fp,v_command
  );
  IF v_result.state <> 'PENDING_REVIEW' OR v_result.sequence <> 6 OR v_result.replayed THEN
    RAISE EXCEPTION 'request_review did not advance to PENDING_REVIEW';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.kf_ingestion_events
    WHERE command_id='d5000000-0000-4000-8000-000000000001'
      AND (review_id IS NOT NULL OR extraction_authorization_id IS NOT NULL)
  ) THEN
    RAISE EXCEPTION 'request_review incorrectly materialized a human decision';
  END IF;

  -- Lost response / identical replay returns the original receipt only.
  SELECT * INTO v_result FROM public.kf_ingestion_request_review(
    'd5000000-0000-4000-8000-000000000001',v_fp,v_command
  );
  IF NOT v_result.replayed OR v_result.sequence <> 6 THEN
    RAISE EXCEPTION 'request_review replay did not return the committed receipt';
  END IF;
  SELECT count(*) INTO v_count FROM public.kf_ingestion_events
  WHERE command_id='d5000000-0000-4000-8000-000000000001';
  IF v_count <> 1 THEN RAISE EXCEPTION 'request_review replay duplicated the event'; END IF;

  -- Divergent replay fails closed.
  BEGIN
    PERFORM * FROM public.kf_ingestion_request_review(
      'd5000000-0000-4000-8000-000000000001',
      public.kf_ingestion_command_fingerprint_internal(
        'request_review',jsonb_set(v_command,'{reason}','"divergent review request"'::jsonb)
      ),
      jsonb_set(v_command,'{reason}','"divergent review request"'::jsonb)
    );
    RAISE EXCEPTION 'expected divergent request_review replay conflict';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;

  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_ingestion_runs WHERE run_id='c1000000-0000-4000-8000-000000000001';

  -- Prepare an unauthorized-reviewer command for the explicit service_role test below.
  v_command := jsonb_build_object(
    'commandType','approve_for_extraction',
    'actor',jsonb_build_object('actorId','c4100000-0000-4000-8000-000000000002','role','legal_editorial_reviewer'),
    'occurredAt','2026-08-15T01:45:00.000Z',
    'correlationId','c5000000-0000-4000-8000-000000000006',
    'reason','unauthorized reviewer must fail',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000001'),
    'expectedState','PENDING_REVIEW','expectedVersion',v_version,'expectedSequence',v_sequence,
    'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000001'),
    'review',jsonb_build_object(
      'reviewId','c8000000-0000-4000-8000-000000000001','reviewMode','human',
      'reviewer',jsonb_build_object('actorId','c4100000-0000-4000-8000-000000000002','role','legal_editorial_reviewer'),
      'decision','APPROVE_FOR_EXTRACTION','decidedAt','2026-08-15T01:45:00.000Z','reason','unauthorized synthetic reviewer'
    ),
    'authorizationEvidence',jsonb_build_array(jsonb_build_object(
      'authorizationId','cf000000-0000-4000-8000-000000000005',
      'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000001'),
      'purpose','extraction','evaluatedAt','2026-08-15T01:45:00.000Z'
    ))
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('approve_for_extraction',v_command);
  PERFORM set_config('kf.c25.unauthorized_payload',v_command::text,false);
  PERFORM set_config('kf.c25.unauthorized_fingerprint',v_fp,false);
END;
$test$;

-- service_role is only a technical channel. Its EXECUTE grant must not grant
-- business competence to a reviewer without a C.1 assignment.
SET ROLE service_role;
DO $service_role_business_auth$
BEGIN
  BEGIN
    PERFORM * FROM public.kf_ingestion_approve_for_extraction(
      'd5000000-0000-4000-8000-000000000002',
      current_setting('kf.c25.unauthorized_fingerprint'),
      current_setting('kf.c25.unauthorized_payload')::jsonb
    );
    RAISE EXCEPTION 'service_role bypassed human reviewer competence';
  EXCEPTION WHEN SQLSTATE 'PT403' THEN NULL;
  END;
END;
$service_role_business_auth$;
RESET ROLE;

DO $approval_tests$
DECLARE
  v_command jsonb;
  v_fp text;
  v_result record;
  v_version text;
  v_sequence bigint;
  v_snapshot jsonb;
  v_before_receipts bigint;
BEGIN
  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_ingestion_runs WHERE run_id='c1000000-0000-4000-8000-000000000001';
  SELECT count(*) INTO v_before_receipts FROM public.kf_ingestion_command_receipts
  WHERE run_id='c1000000-0000-4000-8000-000000000001';

  -- Expired reviewer assignment fails closed.
  v_command := jsonb_build_object(
    'commandType','approve_for_extraction',
    'actor',jsonb_build_object('actorId','c4100000-0000-4000-8000-000000000003','role','legal_editorial_reviewer'),
    'occurredAt','2026-08-15T01:45:00.000Z','correlationId','c5000000-0000-4000-8000-000000000007',
    'reason','expired reviewer assignment test',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000001'),
    'expectedState','PENDING_REVIEW','expectedVersion',v_version,'expectedSequence',v_sequence,
    'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000001'),
    'review',jsonb_build_object(
      'reviewId','c8000000-0000-4000-8000-000000000002','reviewMode','human',
      'reviewer',jsonb_build_object('actorId','c4100000-0000-4000-8000-000000000003','role','legal_editorial_reviewer'),
      'decision','APPROVE_FOR_EXTRACTION','decidedAt','2026-08-15T01:45:00.000Z','reason','expired competence'
    ),
    'authorizationEvidence',jsonb_build_array(jsonb_build_object(
      'authorizationId','cf000000-0000-4000-8000-000000000005',
      'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000001'),
      'purpose','extraction','evaluatedAt','2026-08-15T01:45:00.000Z'
    ))
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('approve_for_extraction',v_command);
  BEGIN
    PERFORM * FROM public.kf_ingestion_approve_for_extraction(
      'd5000000-0000-4000-8000-000000000003',v_fp,v_command
    );
    RAISE EXCEPTION 'expired reviewer assignment was accepted';
  EXCEPTION WHEN SQLSTATE 'PT403' THEN NULL;
  END;

  -- Stale expectedVersion and expectedSequence both fail CAS before a decision.
  v_command := jsonb_set(v_command,'{actor,actorId}','"c4100000-0000-4000-8000-000000000001"'::jsonb);
  v_command := jsonb_set(v_command,'{review,reviewer,actorId}','"c4100000-0000-4000-8000-000000000001"'::jsonb);
  v_command := jsonb_set(v_command,'{review,reviewId}','"c8000000-0000-4000-8000-000000000003"'::jsonb);
  v_command := jsonb_set(v_command,'{expectedVersion}','"stale-version"'::jsonb);
  v_fp := public.kf_ingestion_command_fingerprint_internal('approve_for_extraction',v_command);
  BEGIN
    PERFORM * FROM public.kf_ingestion_approve_for_extraction(
      'd5000000-0000-4000-8000-000000000004',v_fp,v_command
    );
    RAISE EXCEPTION 'stale expectedVersion was accepted';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;

  v_command := jsonb_set(v_command,'{expectedVersion}',to_jsonb(v_version));
  v_command := jsonb_set(v_command,'{expectedSequence}','999'::jsonb);
  v_command := jsonb_set(v_command,'{review,reviewId}','"c8000000-0000-4000-8000-000000000004"'::jsonb);
  v_fp := public.kf_ingestion_command_fingerprint_internal('approve_for_extraction',v_command);
  BEGIN
    PERFORM * FROM public.kf_ingestion_approve_for_extraction(
      'd5000000-0000-4000-8000-000000000005',v_fp,v_command
    );
    RAISE EXCEPTION 'stale expectedSequence was accepted';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;

  -- Authorization that was valid earlier but expired by the decision instant fails historically.
  v_command := jsonb_set(v_command,'{expectedSequence}',to_jsonb(v_sequence));
  v_command := jsonb_set(v_command,'{occurredAt}','"2026-08-15T06:30:00.000Z"'::jsonb);
  v_command := jsonb_set(v_command,'{review,reviewId}','"c8000000-0000-4000-8000-000000000005"'::jsonb);
  v_command := jsonb_set(v_command,'{review,decidedAt}','"2026-08-15T06:30:00.000Z"'::jsonb);
  v_command := jsonb_set(v_command,'{authorizationEvidence,0,evaluatedAt}','"2026-08-15T06:30:00.000Z"'::jsonb);
  v_fp := public.kf_ingestion_command_fingerprint_internal('approve_for_extraction',v_command);
  BEGIN
    PERFORM * FROM public.kf_ingestion_approve_for_extraction(
      'd5000000-0000-4000-8000-000000000006',v_fp,v_command
    );
    RAISE EXCEPTION 'expired extraction authorization was accepted';
  EXCEPTION WHEN SQLSTATE 'PT403' THEN NULL;
  END;

  -- A valid human decision + independently valid extraction authorization commits atomically.
  v_command := jsonb_set(v_command,'{occurredAt}','"2026-08-15T01:45:00.000Z"'::jsonb);
  v_command := jsonb_set(v_command,'{review,reviewId}','"c8000000-0000-4000-8000-000000000006"'::jsonb);
  v_command := jsonb_set(v_command,'{review,decidedAt}','"2026-08-15T01:45:00.000Z"'::jsonb);
  v_command := jsonb_set(v_command,'{review,reason}','"synthetic human approval after technical integrity review"'::jsonb);
  v_command := jsonb_set(v_command,'{authorizationEvidence,0,evaluatedAt}','"2026-08-15T01:45:00.000Z"'::jsonb);
  v_command := jsonb_set(v_command,'{reason}','"materialize governed human approval"'::jsonb);
  v_fp := public.kf_ingestion_command_fingerprint_internal('approve_for_extraction',v_command);
  SELECT * INTO v_result FROM public.kf_ingestion_approve_for_extraction(
    'd5000000-0000-4000-8000-000000000007',v_fp,v_command
  );
  IF v_result.state <> 'APPROVED_FOR_EXTRACTION' OR v_result.sequence <> 7 OR v_result.replayed THEN
    RAISE EXCEPTION 'valid human approval did not commit the C.2 terminal handoff state';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.kf_ingestion_events e
    JOIN public.kf_source_actor_assignments a ON a.id=e.reviewer_assignment_id
    WHERE e.command_id='d5000000-0000-4000-8000-000000000007'
      AND e.event_type='ingestion_approved_for_extraction'
      AND e.review_id='c8000000-0000-4000-8000-000000000006'
      AND e.reviewer_actor_id='c4100000-0000-4000-8000-000000000001'
      AND e.reviewer_actor_role='legal_editorial_reviewer'
      AND e.review_decision='APPROVE_FOR_EXTRACTION'
      AND e.review_decided_at='2026-08-15T01:45:00.000Z'
      AND e.reviewed_artifact_id='c7000000-0000-4000-8000-000000000001'
      AND e.extraction_authorization_id='cf000000-0000-4000-8000-000000000005'
      AND e.extraction_authorization_evaluated_at='2026-08-15T01:45:00.000Z'
      AND a.actor_id=e.reviewer_actor_id
  ) THEN
    RAISE EXCEPTION 'approval event does not preserve the minimum human audit evidence';
  END IF;

  v_snapshot := public.kf_ingestion_handoff_snapshot('c1000000-0000-4000-8000-000000000001');
  IF v_snapshot ->> 'state' <> 'APPROVED_FOR_EXTRACTION'
    OR v_snapshot #>> '{review,decision}' <> 'APPROVE_FOR_EXTRACTION'
    OR v_snapshot #>> '{extractionAuthorization,purpose}' <> 'extraction'
    OR v_snapshot #>> '{run,id}' <> 'c1000000-0000-4000-8000-000000000001' THEN
    RAISE EXCEPTION 'persisted handoff snapshot is incomplete';
  END IF;

  -- Identical replay after terminal state succeeds from the receipt; it does not re-check current competence.
  SELECT * INTO v_result FROM public.kf_ingestion_approve_for_extraction(
    'd5000000-0000-4000-8000-000000000007',v_fp,v_command
  );
  IF NOT v_result.replayed OR v_result.sequence <> 7 THEN
    RAISE EXCEPTION 'approval lost-response replay failed';
  END IF;

  -- Same commandId with different canonical decision is a conflict.
  BEGIN
    PERFORM * FROM public.kf_ingestion_approve_for_extraction(
      'd5000000-0000-4000-8000-000000000007',
      public.kf_ingestion_command_fingerprint_internal(
        'approve_for_extraction',jsonb_set(v_command,'{review,reason}','"divergent approval"'::jsonb)
      ),
      jsonb_set(v_command,'{review,reason}','"divergent approval"'::jsonb)
    );
    RAISE EXCEPTION 'divergent human decision replay was accepted';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;

  -- A second decision cannot leave the terminal state.
  v_command := jsonb_build_object(
    'commandType','reject_ingestion',
    'actor',jsonb_build_object('actorId','c4100000-0000-4000-8000-000000000001','role','legal_editorial_reviewer'),
    'occurredAt','2026-08-15T01:46:00.000Z','correlationId','c5000000-0000-4000-8000-000000000008',
    'reason','terminal state race test',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000001'),
    'expectedState','PENDING_REVIEW','expectedVersion',v_result.aggregate_version,'expectedSequence',v_result.sequence,
    'reasonCode','human_review_rejected',
    'review',jsonb_build_object(
      'reviewId','c8000000-0000-4000-8000-000000000007','reviewMode','human',
      'reviewer',jsonb_build_object('actorId','c4100000-0000-4000-8000-000000000001','role','legal_editorial_reviewer'),
      'decision','REJECT','decidedAt','2026-08-15T01:46:00.000Z','reason','must not override terminal approval'
    )
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('reject_ingestion',v_command);
  BEGIN
    PERFORM * FROM public.kf_ingestion_reject(
      'd5000000-0000-4000-8000-000000000008',v_fp,v_command
    );
    RAISE EXCEPTION 'terminal approved run accepted a second decision';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;

  IF (SELECT count(*) FROM public.kf_ingestion_command_receipts
      WHERE run_id='c1000000-0000-4000-8000-000000000001') <> v_before_receipts + 1 THEN
    RAISE EXCEPTION 'failed commands persisted receipts or valid approval cardinality is wrong';
  END IF;
END;
$approval_tests$;

-- Separate synthetic VERIFIED run proves the human REJECT path.
INSERT INTO public.kf_source_identities(id,kind)
VALUES ('c1000000-0000-4000-8000-000000000005','processing_run');
INSERT INTO public.kf_ingestion_runs(
  run_id,request_id,source_version_id,received_file_id,
  requested_by_actor_id,requested_by_actor_role,requested_at,
  state,aggregate_version,sequence
) VALUES (
  'c1000000-0000-4000-8000-000000000005','c6000000-0000-4000-8000-000000000005',
  'c2000000-0000-4000-8000-000000000002','c3000000-0000-4000-8000-000000000002',
  'c4000000-0000-4000-8000-000000000001','system_worker','2026-08-15T01:40:00Z',
  'VERIFIED','reject-fixture-v5',5
);
INSERT INTO public.kf_ingestion_command_receipts(
  command_id,fingerprint,correlation_id,operation,run_id,aggregate_version,sequence,previous_state,state
) VALUES (
  'd5000000-0000-4000-8000-000000000050',repeat('a',64),
  'c5000000-0000-4000-8000-000000000050','confirm_verified',
  'c1000000-0000-4000-8000-000000000005','reject-fixture-v5',5,'VERIFYING','VERIFIED'
);
INSERT INTO public.kf_ingestion_events(
  event_id,event_type,run_id,aggregate_version,sequence,actor_id,actor_role,
  reason,occurred_at,correlation_id,command_id,from_state,to_state
) VALUES (
  'e5000000-0000-4000-8000-000000000050','ingestion_verified',
  'c1000000-0000-4000-8000-000000000005','reject-fixture-v5',5,
  'c4000000-0000-4000-8000-000000000001','system_worker','synthetic verified rejection fixture',
  '2026-08-15T01:50:00Z','c5000000-0000-4000-8000-000000000050',
  'd5000000-0000-4000-8000-000000000050','VERIFYING','VERIFIED'
);
INSERT INTO public.kf_ingestion_staging_artifacts(
  artifact_id,run_id,source_version_id,received_file_id,state,size_bytes,media_type,
  created_at,expires_at,opaque_locator,write_digest_algorithm,write_digest_value,correlation_id
) VALUES (
  'c7000000-0000-4000-8000-000000000005','c1000000-0000-4000-8000-000000000005',
  'c2000000-0000-4000-8000-000000000002','c3000000-0000-4000-8000-000000000002',
  'VERIFIED',10,'application/pdf','2026-08-15T01:40:00Z','2026-08-15T07:40:00Z',
  'temporary-staging:v1:c1000000-0000-4000-8000-000000000005:c7000000-0000-4000-8000-000000000005',
  'sha-256',repeat('d',64),'c5000000-0000-4000-8000-000000000050'
);
INSERT INTO public.kf_ingestion_integrity_evidence(
  artifact_id,run_id,source_version_id,received_file_id,digest_algorithm,digest_value,
  byte_length,verified_at,correlation_id,duplicate_decision
) VALUES (
  'c7000000-0000-4000-8000-000000000005','c1000000-0000-4000-8000-000000000005',
  'c2000000-0000-4000-8000-000000000002','c3000000-0000-4000-8000-000000000002',
  'sha-256',repeat('e',64),10,'2026-08-15T01:49:00Z','c5000000-0000-4000-8000-000000000050',
  jsonb_build_object('contractVersion','1.0.0','outcome','unique','matches',jsonb_build_array())
);

DO $rejection$
DECLARE
  v_command jsonb;
  v_fp text;
  v_result record;
  v_version text;
  v_sequence bigint;
BEGIN
  v_command := jsonb_build_object(
    'commandType','request_review',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T01:51:00Z','correlationId','c5000000-0000-4000-8000-000000000051',
    'reason','request synthetic rejection review',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000005'),
    'expectedState','VERIFIED','expectedVersion','reject-fixture-v5','expectedSequence',5
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('request_review',v_command);
  PERFORM * FROM public.kf_ingestion_request_review('d5000000-0000-4000-8000-000000000051',v_fp,v_command);
  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_ingestion_runs WHERE run_id='c1000000-0000-4000-8000-000000000005';

  v_command := jsonb_build_object(
    'commandType','reject_ingestion',
    'actor',jsonb_build_object('actorId','c4100000-0000-4000-8000-000000000001','role','legal_editorial_reviewer'),
    'occurredAt','2026-08-15T01:52:00Z','correlationId','c5000000-0000-4000-8000-000000000052',
    'reason','materialize synthetic human rejection',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000005'),
    'expectedState','PENDING_REVIEW','expectedVersion',v_version,'expectedSequence',v_sequence,
    'reasonCode','human_review_rejected',
    'review',jsonb_build_object(
      'reviewId','c8000000-0000-4000-8000-000000000050','reviewMode','human',
      'reviewer',jsonb_build_object('actorId','c4100000-0000-4000-8000-000000000001','role','legal_editorial_reviewer'),
      'decision','REJECT','decidedAt','2026-08-15T01:52:00Z','reason','synthetic human rejection reason'
    )
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('reject_ingestion',v_command);
  SELECT * INTO v_result FROM public.kf_ingestion_reject(
    'd5000000-0000-4000-8000-000000000052',v_fp,v_command
  );
  IF v_result.state <> 'REJECTED' OR v_result.reason_code <> 'human_review_rejected' THEN
    RAISE EXCEPTION 'human rejection did not materialize REJECTED';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.kf_ingestion_events
    WHERE command_id='d5000000-0000-4000-8000-000000000052'
      AND review_decision='REJECT'
      AND reviewer_assignment_id='ca100000-0000-4000-8000-000000000002'
      AND reviewed_artifact_id='c7000000-0000-4000-8000-000000000005'
      AND extraction_authorization_id IS NULL
  ) THEN
    RAISE EXCEPTION 'human rejection audit evidence is incomplete';
  END IF;
  BEGIN
    PERFORM public.kf_ingestion_handoff_snapshot('c1000000-0000-4000-8000-000000000005');
    RAISE EXCEPTION 'rejected run exposed an extraction handoff';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;
END;
$rejection$;

-- Least privilege remains deny-by-default. service_role can execute only the
-- narrow RPCs and cannot mutate the evidence tables directly.
SET ROLE service_role;
DO $least_privilege$
BEGIN
  BEGIN
    UPDATE public.kf_ingestion_runs SET state='FAILED'
    WHERE run_id='c1000000-0000-4000-8000-000000000001';
    RAISE EXCEPTION 'service_role direct ingestion DML unexpectedly succeeded';
  EXCEPTION WHEN insufficient_privilege THEN NULL;
  END;
END;
$least_privilege$;
RESET ROLE;

DO $grants$
BEGIN
  IF NOT has_function_privilege('service_role','public.kf_ingestion_request_review(uuid,text,jsonb)','EXECUTE')
    OR NOT has_function_privilege('service_role','public.kf_ingestion_approve_for_extraction(uuid,text,jsonb)','EXECUTE')
    OR NOT has_function_privilege('service_role','public.kf_ingestion_reject(uuid,text,jsonb)','EXECUTE')
    OR NOT has_function_privilege('service_role','public.kf_ingestion_handoff_snapshot(uuid)','EXECUTE') THEN
    RAISE EXCEPTION 'service_role lacks one or more narrow C.2.5 RPC grants';
  END IF;
  IF has_function_privilege('anon','public.kf_ingestion_approve_for_extraction(uuid,text,jsonb)','EXECUTE')
    OR has_function_privilege('authenticated','public.kf_ingestion_approve_for_extraction(uuid,text,jsonb)','EXECUTE') THEN
    RAISE EXCEPTION 'C.2.5 approval RPC leaked beyond server-only boundary';
  END IF;
  IF has_function_privilege('service_role','public.kf_ingestion_human_decision_internal(text,uuid,text,jsonb)','EXECUTE') THEN
    RAISE EXCEPTION 'service_role can execute an internal C.2.5 helper';
  END IF;
END;
$grants$;

SELECT 'OK:knowledge_factory_ingestion_c2_5' AS result;