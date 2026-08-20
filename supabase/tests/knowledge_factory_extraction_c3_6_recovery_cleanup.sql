\set ON_ERROR_STOP on

-- Synthetic-only C.3.6 proof.
-- Prerequisites C.3.2, C.3.4 and C.3.5 are applied by the disposable CI.
-- No real PDF/content, hosted Storage, OCR, chunks or embeddings are used.

DO $seed_recovery_run$
DECLARE
  v_source public.kf_extraction_runs%ROWTYPE;
  v_run_id uuid := 'e1000000-0000-4000-8000-000000000036';
  v_pages jsonb;
  v_fp text;
BEGIN
  SELECT * INTO v_source
  FROM public.kf_extraction_runs
  WHERE run_id='e1000000-0000-4000-8000-000000000001';

  IF NOT FOUND THEN
    RAISE EXCEPTION 'C.3.2 prerequisite run is missing';
  END IF;

  INSERT INTO public.kf_extraction_runs(
    run_id,request_id,source_version_id,ingestion_run_id,ingestion_handoff_event_id,
    reviewed_artifact_id,artifact_sha256,artifact_size_bytes,method_kind,method_name,method_version,
    requested_by_actor_id,requested_by_actor_role,requested_at,state,aggregate_version,sequence,
    created_at,updated_at
  ) VALUES (
    v_run_id,'e6000000-0000-4000-8000-000000000036',v_source.source_version_id,
    v_source.ingestion_run_id,v_source.ingestion_handoff_event_id,v_source.reviewed_artifact_id,
    v_source.artifact_sha256,v_source.artifact_size_bytes,v_source.method_kind,v_source.method_name,
    v_source.method_version,v_source.requested_by_actor_id,v_source.requested_by_actor_role,
    '2026-08-15T03:00:00Z','EXTRACTING','c36-seed-v1',3,
    '2026-08-15T03:00:00Z','2026-08-15T03:00:00Z'
  );

  v_pages := jsonb_build_array(
    jsonb_build_object(
      'physicalPageNumber',1,
      'outcome','extracted',
      'text','Conteudo sintetico preservado durante recovery',
      'elements',jsonb_build_array(
        jsonb_build_object(
          'logicalLocator','page:1/text:1',
          'kind','text_block',
          'text','Conteudo sintetico preservado durante recovery'
        )
      )
    )
  );
  v_fp := public.kf_extraction_batch_fingerprint_internal(v_run_id,1,v_pages);
  PERFORM * FROM public.kf_extraction_commit_batch(
    'e8200000-0000-4000-8000-000000000036',v_fp,v_run_id,1,v_pages
  );
END;
$seed_recovery_run$;

DO $fail_retry_cancel_cleanup$
DECLARE
  v_run_id uuid := 'e1000000-0000-4000-8000-000000000036';
  v_cmd jsonb;
  v_fp text;
  v_retry_fp text;
  v_cleanup_fp text;
  v_result record;
  v_cleanup jsonb;
  v_version text;
  v_sequence bigint;
  v_failed_version text;
  v_failed_sequence bigint;
  v_attempts bigint;
BEGIN
  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_extraction_runs WHERE run_id=v_run_id;

  v_cmd := jsonb_build_object(
    'commandType','fail_extraction',
    'actor',jsonb_build_object(
      'actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'
    ),
    'occurredAt','2026-08-15T03:01:00.000Z',
    'correlationId','e5300000-0000-4000-8000-000000000036',
    'reason','synthetic injected worker failure',
    'run',jsonb_build_object('kind','extraction_run','id',v_run_id),
    'expectedState','EXTRACTING','expectedVersion',v_version,'expectedSequence',v_sequence,
    'reasonCode','technical_failure'
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('fail_extraction',v_cmd);
  SELECT * INTO v_result FROM public.kf_extraction_transition_c3_5(
    'fail_extraction','e8300000-0000-4000-8000-000000000036',v_fp,v_cmd
  );
  IF v_result.state<>'FAILED' OR v_result.replayed THEN
    RAISE EXCEPTION 'injected failure did not become FAILED exactly once';
  END IF;

  v_failed_version := v_result.aggregate_version;
  v_failed_sequence := v_result.sequence;
  v_retry_fp := public.kf_extraction_retry_fingerprint_internal(
    v_run_id,v_failed_version,v_failed_sequence,
    '2026-08-15T03:02:00.000Z','e5300000-0000-4000-8000-000000000036',
    'resume from last durable batch after synthetic worker failure'
  );
  SELECT * INTO v_result FROM public.kf_extraction_retry_failed(
    'e8600000-0000-4000-8000-000000000036',v_retry_fp,v_run_id,
    v_failed_version,v_failed_sequence,
    'c4000000-0000-4000-8000-000000000001','2026-08-15T03:02:00.000Z',
    'e5300000-0000-4000-8000-000000000036',
    'resume from last durable batch after synthetic worker failure'
  );
  IF v_result.state<>'READY' OR v_result.replayed THEN
    RAISE EXCEPTION 'FAILED recovery did not return the run to READY';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.kf_extraction_recovery_attempts
    WHERE run_id=v_run_id AND attempt_number=1
      AND failed_sequence=v_failed_sequence AND resumed_sequence=v_failed_sequence+1
  ) THEN
    RAISE EXCEPTION 'recovery attempt evidence is missing or incorrectly bound';
  END IF;

  SELECT count(*) INTO v_attempts
  FROM public.kf_extraction_recovery_attempts WHERE run_id=v_run_id;
  SELECT * INTO v_result FROM public.kf_extraction_retry_failed(
    'e8600000-0000-4000-8000-000000000036',v_retry_fp,v_run_id,
    v_failed_version,v_failed_sequence,
    'c4000000-0000-4000-8000-000000000001','2026-08-15T03:02:00.000Z',
    'e5300000-0000-4000-8000-000000000036',
    'resume from last durable batch after synthetic worker failure'
  );
  IF NOT v_result.replayed
    OR (SELECT count(*) FROM public.kf_extraction_recovery_attempts WHERE run_id=v_run_id)<>v_attempts THEN
    RAISE EXCEPTION 'retry replay duplicated recovery evidence';
  END IF;

  BEGIN
    PERFORM * FROM public.kf_extraction_retry_failed(
      'e8600000-0000-4000-8000-000000000036',repeat('a',64),v_run_id,
      v_failed_version,v_failed_sequence,
      'c4000000-0000-4000-8000-000000000001','2026-08-15T03:02:00.000Z',
      'e5300000-0000-4000-8000-000000000036','different retry effect'
    );
    RAISE EXCEPTION 'retry command collision was accepted';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;

  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_extraction_runs WHERE run_id=v_run_id;
  v_cmd := jsonb_build_object(
    'commandType','cancel_extraction',
    'actor',jsonb_build_object(
      'actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'
    ),
    'occurredAt','2026-08-15T03:03:00.000Z',
    'correlationId','e5300000-0000-4000-8000-000000000036',
    'reason','operator cancels recovered synthetic run before new claim',
    'run',jsonb_build_object('kind','extraction_run','id',v_run_id),
    'expectedState','READY','expectedVersion',v_version,'expectedSequence',v_sequence,
    'reasonCode','operator_cancelled'
  );
  v_fp := public.kf_extraction_command_fingerprint_internal('cancel_extraction',v_cmd);
  SELECT * INTO v_result FROM public.kf_extraction_transition_c3_5(
    'cancel_extraction','e8300000-0000-4000-8000-000000000037',v_fp,v_cmd
  );
  IF v_result.state<>'CANCELLED' OR v_result.replayed THEN
    RAISE EXCEPTION 'cancellation after recovery did not close the run';
  END IF;

  v_cleanup_fp := public.kf_extraction_cleanup_fingerprint_internal(
    v_run_id,v_result.sequence,'2026-08-15T03:04:00.000Z'
  );
  v_cleanup := public.kf_extraction_finalize_cleanup(
    'e8700000-0000-4000-8000-000000000036',v_cleanup_fp,v_run_id,
    v_result.sequence,'2026-08-15T03:04:00.000Z'
  );
  IF v_cleanup->>'terminalState'<>'CANCELLED'
    OR (v_cleanup->>'durableBatchCount')::integer<>1
    OR (v_cleanup->>'durablePageCount')::integer<>1
    OR (v_cleanup->>'durableElementCount')::integer<>1
    OR (v_cleanup->>'transientTargetCount')::integer<>0
    OR v_cleanup->>'status'<>'COMPLETED_NO_TRANSIENT_TARGETS'
    OR (v_cleanup->>'replayed')::boolean THEN
    RAISE EXCEPTION 'cleanup evidence does not preserve durable data and close transient scope';
  END IF;

  v_cleanup := public.kf_extraction_finalize_cleanup(
    'e8700000-0000-4000-8000-000000000036',v_cleanup_fp,v_run_id,
    v_result.sequence,'2026-08-15T03:04:00.000Z'
  );
  IF NOT (v_cleanup->>'replayed')::boolean
    OR (SELECT count(*) FROM public.kf_extraction_cleanup_receipts WHERE run_id=v_run_id)<>1 THEN
    RAISE EXCEPTION 'cleanup replay duplicated durable evidence';
  END IF;

  BEGIN
    PERFORM public.kf_extraction_finalize_cleanup(
      'e8700000-0000-4000-8000-000000000037',v_cleanup_fp,v_run_id,
      v_result.sequence,'2026-08-15T03:04:00.000Z'
    );
    RAISE EXCEPTION 'cleanup identity collision was accepted';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;

  IF (SELECT state FROM public.kf_extraction_runs WHERE run_id=v_run_id)<>'CANCELLED'
    OR (SELECT count(*) FROM public.kf_extraction_batches WHERE run_id=v_run_id)<>1
    OR (SELECT count(*) FROM public.kf_extraction_pages WHERE run_id=v_run_id)<>1
    OR (SELECT count(*) FROM public.kf_extraction_elements WHERE run_id=v_run_id)<>1 THEN
    RAISE EXCEPTION 'cleanup mutated append-only durable extraction evidence';
  END IF;
END;
$fail_retry_cancel_cleanup$;

DO $least_privilege$
BEGIN
  IF has_table_privilege('service_role','public.kf_extraction_recovery_attempts','SELECT')
    OR has_table_privilege('service_role','public.kf_extraction_recovery_attempts','INSERT')
    OR has_table_privilege('service_role','public.kf_extraction_cleanup_receipts','SELECT')
    OR has_table_privilege('service_role','public.kf_extraction_cleanup_receipts','INSERT') THEN
    RAISE EXCEPTION 'C.3.6 table privilege escaped deny-by-default';
  END IF;
  IF NOT has_function_privilege(
    'service_role',
    'public.kf_extraction_retry_failed(uuid,text,uuid,text,bigint,uuid,timestamptz,uuid,text)',
    'EXECUTE'
  ) OR NOT has_function_privilege(
    'service_role',
    'public.kf_extraction_finalize_cleanup(uuid,text,uuid,bigint,timestamptz)',
    'EXECUTE'
  ) THEN
    RAISE EXCEPTION 'service_role lacks narrow C.3.6 RPC capability';
  END IF;
  IF has_function_privilege(
    'service_role',
    'public.kf_extraction_retry_fingerprint_internal(uuid,text,bigint,timestamptz,uuid,text)',
    'EXECUTE'
  ) OR has_function_privilege(
    'service_role',
    'public.kf_extraction_cleanup_fingerprint_internal(uuid,bigint,timestamptz)',
    'EXECUTE'
  ) THEN
    RAISE EXCEPTION 'service_role can execute C.3.6 internal fingerprint helper';
  END IF;
END;
$least_privilege$;

SET ROLE service_role;
DO $no_direct_dml$
BEGIN
  BEGIN
    DELETE FROM public.kf_extraction_cleanup_receipts;
    RAISE EXCEPTION 'service_role direct cleanup DML unexpectedly succeeded';
  EXCEPTION WHEN insufficient_privilege THEN NULL;
  END;
END;
$no_direct_dml$;
RESET ROLE;

SELECT 'C.3.6 recovery, cancellation and cleanup proof passed' AS result;
