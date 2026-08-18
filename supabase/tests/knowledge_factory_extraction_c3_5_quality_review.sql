\set ON_ERROR_STOP on

-- Synthetic-only C.3.5 proof. C.3.2 has left run e100...001 in EXTRACTING.
-- C.3.4 schema is present but no real PDF/content is used.

DO $pass_path$
DECLARE
  v_run_id uuid := 'e1000000-0000-4000-8000-000000000001';
  v_pages jsonb;
  v_fp text;
  v_cmd jsonb;
  v_result record;
  v_version text;
  v_sequence bigint;
  v_assessment jsonb;
  v_reviews_before bigint;
BEGIN
  v_pages := jsonb_build_array(
    jsonb_build_object(
      'physicalPageNumber',1,'outcome','extracted','text','Texto sintetico pagina um',
      'elements',jsonb_build_array(jsonb_build_object(
        'logicalLocator','page:1/text:1','kind','text_block','text','Texto sintetico pagina um'
      ))
    ),
    jsonb_build_object(
      'physicalPageNumber',2,'outcome','empty','text','','elements','[]'::jsonb
    )
  );
  v_fp := public.kf_extraction_batch_fingerprint_internal(v_run_id,1,v_pages);
  PERFORM * FROM public.kf_extraction_commit_batch(
    'e8200000-0000-4000-8000-000000000001',v_fp,v_run_id,1,v_pages
  );

  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_extraction_runs WHERE run_id=v_run_id;
  v_cmd := jsonb_build_object(
    'commandType','begin_validation',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T02:03:00.000Z',
    'correlationId','e5300000-0000-4000-8000-000000000001',
    'reason','synthetic C.3.5 validation start',
    'run',jsonb_build_object('kind','extraction_run','id',v_run_id),
    'expectedState','EXTRACTING','expectedVersion',v_version,'expectedSequence',v_sequence
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('begin_validation',v_cmd);
  SELECT * INTO v_result FROM public.kf_extraction_transition_c3_5(
    'begin_validation','e8300000-0000-4000-8000-000000000001',v_fp,v_cmd
  );
  IF v_result.state<>'VALIDATING' OR v_result.replayed THEN
    RAISE EXCEPTION 'begin_validation did not advance to VALIDATING';
  END IF;

  SELECT aggregate_version INTO v_version FROM public.kf_extraction_runs WHERE run_id=v_run_id;
  v_fp := public.kf_extraction_quality_fingerprint_internal(
    v_run_id,v_version,'c3.5-synthetic-v1',2,'2026-08-15T02:03:30.000Z'
  );
  v_assessment := public.kf_extraction_assess_quality(
    'e8400000-0000-4000-8000-000000000001',v_fp,v_run_id,'c3.5-synthetic-v1',2,
    '2026-08-15T02:03:30.000Z'
  );
  IF NOT (v_assessment->>'passed')::boolean
    OR (v_assessment->>'pageCoverage')::numeric<>1.0
    OR (v_assessment->>'pendingPageCount')::integer<>0 THEN
    RAISE EXCEPTION 'synthetic passing assessment did not pass deterministic policy';
  END IF;
  IF NOT (public.kf_extraction_assess_quality(
    'e8400000-0000-4000-8000-000000000001',v_fp,v_run_id,'c3.5-synthetic-v1',2,
    '2026-08-15T02:03:30.000Z'
  )->>'replayed')::boolean THEN
    RAISE EXCEPTION 'quality assessment replay did not return original effect';
  END IF;

  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_extraction_runs WHERE run_id=v_run_id;
  v_cmd := jsonb_build_object(
    'commandType','request_review',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T02:04:00.000Z',
    'correlationId','e5300000-0000-4000-8000-000000000001',
    'reason','synthetic C.3.5 human review request',
    'run',jsonb_build_object('kind','extraction_run','id',v_run_id),
    'expectedState','VALIDATING','expectedVersion',v_version,'expectedSequence',v_sequence
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('request_review',v_cmd);
  SELECT * INTO v_result FROM public.kf_extraction_transition_c3_5(
    'request_review','e8300000-0000-4000-8000-000000000002',v_fp,v_cmd
  );
  IF v_result.state<>'PENDING_REVIEW' OR v_result.replayed THEN
    RAISE EXCEPTION 'request_review did not advance to PENDING_REVIEW';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.kf_extraction_review_requests
    WHERE command_id='e8300000-0000-4000-8000-000000000002'
      AND assessment_id='e8400000-0000-4000-8000-000000000001'
  ) THEN
    RAISE EXCEPTION 'review request did not bind the current assessment';
  END IF;

  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_extraction_runs WHERE run_id=v_run_id;
  v_cmd := jsonb_build_object(
    'commandType','approve_for_segmentation',
    'actor',jsonb_build_object('actorId','c4100000-0000-4000-8000-000000000001','role','legal_editorial_reviewer'),
    'occurredAt','2026-08-15T02:05:00.000Z',
    'correlationId','e5300000-0000-4000-8000-000000000001',
    'reason','synthetic quality and human review approval',
    'run',jsonb_build_object('kind','extraction_run','id',v_run_id),
    'expectedState','PENDING_REVIEW','expectedVersion',v_version,'expectedSequence',v_sequence,
    'assessmentId','e8400000-0000-4000-8000-000000000001',
    'reviewId','e8500000-0000-4000-8000-000000000001',
    'authorizationEvidence',jsonb_build_object(
      'authorizationId','cf000000-0000-4000-8000-000000000005',
      'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000001'),
      'purpose','extraction','checkpoint','finalization','evaluatedAt','2026-08-15T02:05:00.000Z'
    )
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('approve_for_segmentation',v_cmd);
  SELECT count(*) INTO v_reviews_before FROM public.kf_extraction_reviews WHERE run_id=v_run_id;
  SELECT * INTO v_result FROM public.kf_extraction_transition_c3_5(
    'approve_for_segmentation','e8300000-0000-4000-8000-000000000003',v_fp,v_cmd
  );
  IF v_result.state<>'VALIDATED_FOR_SEGMENTATION' OR v_result.replayed THEN
    RAISE EXCEPTION 'passing quality + human review did not validate for segmentation';
  END IF;
  IF (SELECT count(*) FROM public.kf_extraction_reviews WHERE run_id=v_run_id)<>v_reviews_before+1 THEN
    RAISE EXCEPTION 'human approval audit record is missing';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.kf_extraction_events
    WHERE command_id='e8300000-0000-4000-8000-000000000003'
      AND authorization_checkpoint='finalization'
      AND authorization_id='cf000000-0000-4000-8000-000000000005'
  ) THEN
    RAISE EXCEPTION 'finalization authorization evidence was not persisted';
  END IF;

  SELECT * INTO v_result FROM public.kf_extraction_transition_c3_5(
    'approve_for_segmentation','e8300000-0000-4000-8000-000000000003',v_fp,v_cmd
  );
  IF NOT v_result.replayed
    OR (SELECT count(*) FROM public.kf_extraction_reviews WHERE run_id=v_run_id)<>v_reviews_before+1 THEN
    RAISE EXCEPTION 'human approval replay duplicated durable review';
  END IF;

  -- Previously closed state rule: terminal validated run cannot be cancelled.
  v_cmd := jsonb_build_object(
    'commandType','cancel_extraction',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T02:06:00.000Z','correlationId','e5300000-0000-4000-8000-000000000001',
    'reason','terminal state guard regression proof',
    'run',jsonb_build_object('kind','extraction_run','id',v_run_id),
    'expectedState','VALIDATED_FOR_SEGMENTATION','expectedVersion',v_result.aggregate_version,
    'expectedSequence',v_result.sequence,'reasonCode','operator_cancelled'
  );
  BEGIN
    PERFORM public.kf_extraction_precheck_internal(
      'cancel_extraction','e8300000-0000-4000-8000-000000000004',
      public.kf_extraction_command_fingerprint_internal('cancel_extraction',v_cmd),v_cmd
    );
    RAISE EXCEPTION 'terminal cancellation state regression was accepted';
  EXCEPTION WHEN SQLSTATE '22023' THEN NULL;
  END;
END;
$pass_path$;

DO $failed_policy_path$
DECLARE
  v_source_run public.kf_extraction_runs%ROWTYPE;
  v_run_id uuid := 'e1000000-0000-4000-8000-000000000099';
  v_fp text;
  v_assessment jsonb;
  v_cmd jsonb;
  v_result record;
  v_version text;
  v_sequence bigint;
BEGIN
  SELECT * INTO v_source_run
  FROM public.kf_extraction_runs
  WHERE run_id='e1000000-0000-4000-8000-000000000001';

  INSERT INTO public.kf_extraction_runs(
    run_id,request_id,source_version_id,ingestion_run_id,ingestion_handoff_event_id,
    reviewed_artifact_id,artifact_sha256,artifact_size_bytes,method_kind,method_name,method_version,
    requested_by_actor_id,requested_by_actor_role,requested_at,state,aggregate_version,sequence,
    created_at,updated_at
  ) VALUES (
    v_run_id,'e6000000-0000-4000-8000-000000000099',v_source_run.source_version_id,
    v_source_run.ingestion_run_id,v_source_run.ingestion_handoff_event_id,v_source_run.reviewed_artifact_id,
    v_source_run.artifact_sha256,v_source_run.artifact_size_bytes,'native_text',v_source_run.method_name,
    v_source_run.method_version,v_source_run.requested_by_actor_id,v_source_run.requested_by_actor_role,
    '2026-08-15T02:00:00Z','VALIDATING','c35-failed-policy-version',4,
    '2026-08-15T02:00:00Z','2026-08-15T02:03:00Z'
  );
  INSERT INTO public.kf_extraction_batches(
    batch_id,run_id,batch_sequence,fingerprint,first_page,last_page,page_count,committed_at
  ) VALUES (
    'e8200000-0000-4000-8000-000000000099',v_run_id,1,
    repeat('9',64),1,1,1,'2026-08-15T02:02:00Z'
  );
  INSERT INTO public.kf_extraction_pages(
    run_id,physical_page_number,batch_id,outcome,text_content,method_name,method_version,recorded_at
  ) VALUES (
    v_run_id,1,'e8200000-0000-4000-8000-000000000099','pending','texto ainda pendente',
    v_source_run.method_name,v_source_run.method_version,'2026-08-15T02:02:00Z'
  );

  v_fp := public.kf_extraction_quality_fingerprint_internal(
    v_run_id,'c35-failed-policy-version','c3.5-synthetic-v1',2,'2026-08-15T02:03:30.000Z'
  );
  v_assessment := public.kf_extraction_assess_quality(
    'e8400000-0000-4000-8000-000000000099',v_fp,v_run_id,'c3.5-synthetic-v1',2,
    '2026-08-15T02:03:30.000Z'
  );
  IF (v_assessment->>'passed')::boolean
    OR (v_assessment->>'pageCoverage')::numeric<>0.5
    OR (v_assessment->>'pendingPageCount')::integer<>1 THEN
    RAISE EXCEPTION 'low-quality synthetic fixture unexpectedly passed policy';
  END IF;

  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_extraction_runs WHERE run_id=v_run_id;
  v_cmd := jsonb_build_object(
    'commandType','request_review',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T02:04:00.000Z','correlationId','e5300000-0000-4000-8000-000000000099',
    'reason','synthetic failed-policy review request',
    'run',jsonb_build_object('kind','extraction_run','id',v_run_id),
    'expectedState','VALIDATING','expectedVersion',v_version,'expectedSequence',v_sequence
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('request_review',v_cmd);
  PERFORM * FROM public.kf_extraction_transition_c3_5(
    'request_review','e8300000-0000-4000-8000-000000000099',v_fp,v_cmd
  );

  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_extraction_runs WHERE run_id=v_run_id;
  v_cmd := jsonb_build_object(
    'commandType','approve_for_segmentation',
    'actor',jsonb_build_object('actorId','c4100000-0000-4000-8000-000000000001','role','legal_editorial_reviewer'),
    'occurredAt','2026-08-15T02:05:00.000Z','correlationId','e5300000-0000-4000-8000-000000000099',
    'reason','failed quality must not validate',
    'run',jsonb_build_object('kind','extraction_run','id',v_run_id),
    'expectedState','PENDING_REVIEW','expectedVersion',v_version,'expectedSequence',v_sequence,
    'assessmentId','e8400000-0000-4000-8000-000000000099',
    'reviewId','e8500000-0000-4000-8000-000000000099',
    'authorizationEvidence',jsonb_build_object(
      'authorizationId','cf000000-0000-4000-8000-000000000005',
      'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000001'),
      'purpose','extraction','checkpoint','finalization','evaluatedAt','2026-08-15T02:05:00.000Z'
    )
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('approve_for_segmentation',v_cmd);
  BEGIN
    PERFORM * FROM public.kf_extraction_transition_c3_5(
      'approve_for_segmentation','e8300000-0000-4000-8000-000000000100',v_fp,v_cmd
    );
    RAISE EXCEPTION 'failed quality assessment reached VALIDATED_FOR_SEGMENTATION';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;
  IF (SELECT state FROM public.kf_extraction_runs WHERE run_id=v_run_id)<>'PENDING_REVIEW' THEN
    RAISE EXCEPTION 'failed approval attempt changed low-quality run state';
  END IF;
END;
$failed_policy_path$;

DO $privileges$
BEGIN
  IF has_table_privilege('service_role','public.kf_extraction_quality_assessments','INSERT')
    OR has_table_privilege('service_role','public.kf_extraction_reviews','INSERT')
    OR has_table_privilege('service_role','public.kf_extraction_review_requests','INSERT') THEN
    RAISE EXCEPTION 'service_role received direct C.3.5 table DML';
  END IF;
  IF NOT has_function_privilege(
    'service_role','public.kf_extraction_assess_quality(uuid,text,uuid,text,integer,timestamptz)','EXECUTE'
  ) OR NOT has_function_privilege(
    'service_role','public.kf_extraction_transition_c3_5(text,uuid,text,jsonb)','EXECUTE'
  ) THEN
    RAISE EXCEPTION 'service_role lacks narrow C.3.5 RPC grants';
  END IF;
END;
$privileges$;

SELECT 'C.3.5 quality/policy/human-review proof passed' AS result;
