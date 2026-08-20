-- =============================================================================
-- ProfePlan Knowledge Factory - Sublote C.3.6
-- Retry/recovery, cancellation closure and repeatable cleanup evidence.
-- Synthetic/disposable validation only. No hosted Storage, OCR or real content.
-- =============================================================================

BEGIN;

ALTER TABLE public.kf_extraction_command_receipts
  DROP CONSTRAINT IF EXISTS kf_extraction_command_receipts_operation_check;
ALTER TABLE public.kf_extraction_command_receipts
  ADD CONSTRAINT kf_extraction_command_receipts_operation_check CHECK (
    operation IN (
      'request_extraction','mark_ready','begin_extraction','begin_validation',
      'request_review','approve_for_segmentation','request_reprocessing',
      'retry_failed_extraction','block_authorization','reject_extraction',
      'fail_extraction','cancel_extraction'
    )
  );

ALTER TABLE public.kf_extraction_events
  DROP CONSTRAINT IF EXISTS kf_extraction_events_event_type_check;
ALTER TABLE public.kf_extraction_events
  ADD CONSTRAINT kf_extraction_events_event_type_check CHECK (
    event_type IN (
      'extraction_requested','extraction_ready','extraction_started',
      'extraction_validation_started','extraction_review_requested',
      'extraction_validated_for_segmentation','extraction_reprocessing_requested',
      'extraction_retry_scheduled','extraction_authorization_blocked',
      'extraction_rejected','extraction_failed','extraction_cancelled'
    )
  );

CREATE TABLE public.kf_extraction_recovery_attempts (
  attempt_id uuid PRIMARY KEY,
  command_id uuid NOT NULL UNIQUE
    REFERENCES public.kf_extraction_command_receipts(command_id) ON DELETE RESTRICT,
  run_id uuid NOT NULL REFERENCES public.kf_extraction_runs(run_id) ON DELETE RESTRICT,
  attempt_number integer NOT NULL CHECK (attempt_number > 0),
  failed_sequence bigint NOT NULL CHECK (failed_sequence > 0),
  resumed_sequence bigint NOT NULL CHECK (resumed_sequence > failed_sequence),
  recorded_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_extraction_recovery_attempts_run_attempt_key UNIQUE(run_id,attempt_number)
);

CREATE TABLE public.kf_extraction_cleanup_receipts (
  cleanup_id uuid PRIMARY KEY,
  fingerprint text NOT NULL CHECK (fingerprint ~ '^[0-9a-f]{64}$'),
  run_id uuid NOT NULL REFERENCES public.kf_extraction_runs(run_id) ON DELETE RESTRICT,
  terminal_state text NOT NULL CHECK (terminal_state IN ('CANCELLED','REJECTED','FAILED')),
  terminal_sequence bigint NOT NULL CHECK (terminal_sequence > 0),
  durable_batch_count integer NOT NULL CHECK (durable_batch_count >= 0),
  durable_page_count integer NOT NULL CHECK (durable_page_count >= 0),
  durable_element_count integer NOT NULL CHECK (durable_element_count >= 0),
  transient_target_count integer NOT NULL CHECK (transient_target_count >= 0),
  status text NOT NULL CHECK (status='COMPLETED_NO_TRANSIENT_TARGETS'),
  completed_at timestamptz NOT NULL,
  CONSTRAINT kf_extraction_cleanup_receipts_run_terminal_key UNIQUE(run_id,terminal_sequence)
);

CREATE TRIGGER kf_extraction_recovery_attempts_append_only
BEFORE UPDATE OR DELETE ON public.kf_extraction_recovery_attempts
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();
CREATE TRIGGER kf_extraction_cleanup_receipts_append_only
BEFORE UPDATE OR DELETE ON public.kf_extraction_cleanup_receipts
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE OR REPLACE FUNCTION public.kf_extraction_retry_fingerprint_internal(
  p_run_id uuid,
  p_expected_version text,
  p_expected_sequence bigint,
  p_occurred_at timestamptz,
  p_correlation_id uuid,
  p_reason text
)
RETURNS text
LANGUAGE sql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT encode(sha256(convert_to(
    public.kf_extraction_canonical_json_internal(jsonb_build_object(
      'fingerprintVersion',1,
      'operation','retry_failed_extraction',
      'runId',p_run_id,
      'expectedVersion',p_expected_version,
      'expectedSequence',p_expected_sequence,
      'occurredAt',p_occurred_at,
      'correlationId',p_correlation_id,
      'reason',p_reason
    )), 'UTF8')), 'hex')
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_retry_failed(
  p_command_id uuid,
  p_fingerprint text,
  p_run_id uuid,
  p_expected_version text,
  p_expected_sequence bigint,
  p_actor_id uuid,
  p_occurred_at timestamptz,
  p_correlation_id uuid,
  p_reason text
)
RETURNS TABLE(
  contract_version text,command_id uuid,fingerprint text,correlation_id uuid,
  operation text,run_id uuid,aggregate_version text,sequence bigint,event_ids uuid[],
  previous_state text,state text,replayed boolean,committed_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_run public.kf_extraction_runs%ROWTYPE;
  v_existing public.kf_extraction_command_receipts%ROWTYPE;
  v_expected_fingerprint text;
  v_payload jsonb;
  v_attempt_number integer;
BEGIN
  IF p_command_id IS NULL OR p_run_id IS NULL OR p_actor_id IS NULL OR p_correlation_id IS NULL
    OR p_expected_sequence <= 0 OR btrim(coalesce(p_expected_version,''))=''
    OR btrim(coalesce(p_reason,''))='' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='invalid retry input';
  END IF;
  v_expected_fingerprint := public.kf_extraction_retry_fingerprint_internal(
    p_run_id,p_expected_version,p_expected_sequence,p_occurred_at,p_correlation_id,p_reason
  );
  IF p_fingerprint<>v_expected_fingerprint THEN
    RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='retry fingerprint mismatch';
  END IF;

  PERFORM pg_advisory_xact_lock(hashtextextended('extraction-command:'||p_command_id::text,0));
  SELECT * INTO v_existing
  FROM public.kf_extraction_command_receipts AS r
  WHERE r.command_id=p_command_id;
  IF FOUND THEN
    IF v_existing.operation<>'retry_failed_extraction' OR v_existing.fingerprint<>p_fingerprint THEN
      RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='retry commandId collides with different effect';
    END IF;
    RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,true);
    RETURN;
  END IF;

  SELECT * INTO v_run
  FROM public.kf_extraction_runs AS r
  WHERE r.run_id=p_run_id
  FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE='P0002', MESSAGE='extraction run was not found';
  END IF;
  IF v_run.state<>'FAILED'
    OR v_run.aggregate_version<>p_expected_version
    OR v_run.sequence<>p_expected_sequence THEN
    RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='retry requires current FAILED run version';
  END IF;
  IF p_occurred_at<v_run.updated_at THEN
    RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='retry would regress committed temporal order';
  END IF;
  PERFORM public.kf_extraction_assert_assignment_internal(p_actor_id,'system_worker',p_occurred_at);

  v_payload := jsonb_build_object(
    'actor',jsonb_build_object('actorId',p_actor_id,'role','system_worker'),
    'occurredAt',p_occurred_at,
    'correlationId',p_correlation_id,
    'reason',p_reason
  );
  PERFORM public.kf_extraction_commit_transition_internal(
    'retry_failed_extraction','extraction_retry_scheduled','READY',NULL,
    p_command_id,p_fingerprint,v_payload,v_run,NULL,NULL,NULL
  );

  SELECT coalesce(max(a.attempt_number),0)+1 INTO v_attempt_number
  FROM public.kf_extraction_recovery_attempts AS a
  WHERE a.run_id=p_run_id;
  INSERT INTO public.kf_extraction_recovery_attempts(
    attempt_id,command_id,run_id,attempt_number,failed_sequence,resumed_sequence,recorded_at
  ) VALUES (
    gen_random_uuid(),p_command_id,p_run_id,v_attempt_number,p_expected_sequence,p_expected_sequence+1,p_occurred_at
  );

  RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_cleanup_fingerprint_internal(
  p_run_id uuid,
  p_terminal_sequence bigint,
  p_completed_at timestamptz
)
RETURNS text
LANGUAGE sql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT encode(sha256(convert_to(
    public.kf_extraction_canonical_json_internal(jsonb_build_object(
      'fingerprintVersion',1,
      'operation','finalize_cleanup',
      'runId',p_run_id,
      'terminalSequence',p_terminal_sequence,
      'completedAt',p_completed_at
    )), 'UTF8')), 'hex')
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_finalize_cleanup(
  p_cleanup_id uuid,
  p_fingerprint text,
  p_run_id uuid,
  p_terminal_sequence bigint,
  p_completed_at timestamptz
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_run public.kf_extraction_runs%ROWTYPE;
  v_existing public.kf_extraction_cleanup_receipts%ROWTYPE;
  v_expected_fingerprint text;
  v_batches integer;
  v_pages integer;
  v_elements integer;
BEGIN
  IF p_cleanup_id IS NULL OR p_run_id IS NULL OR p_terminal_sequence<=0 THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='invalid cleanup identity/input';
  END IF;
  v_expected_fingerprint := public.kf_extraction_cleanup_fingerprint_internal(
    p_run_id,p_terminal_sequence,p_completed_at
  );
  IF p_fingerprint<>v_expected_fingerprint THEN
    RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='cleanup fingerprint mismatch';
  END IF;

  PERFORM pg_advisory_xact_lock(hashtextextended('extraction-cleanup:'||p_run_id::text||':'||p_terminal_sequence::text,0));
  SELECT * INTO v_existing
  FROM public.kf_extraction_cleanup_receipts AS c
  WHERE c.run_id=p_run_id AND c.terminal_sequence=p_terminal_sequence;
  IF FOUND THEN
    IF v_existing.cleanup_id<>p_cleanup_id OR v_existing.fingerprint<>p_fingerprint THEN
      RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='cleanup replay collides with different effect';
    END IF;
    RETURN jsonb_build_object(
      'cleanupId',v_existing.cleanup_id,'runId',v_existing.run_id,
      'terminalState',v_existing.terminal_state,'terminalSequence',v_existing.terminal_sequence,
      'durableBatchCount',v_existing.durable_batch_count,
      'durablePageCount',v_existing.durable_page_count,
      'durableElementCount',v_existing.durable_element_count,
      'transientTargetCount',v_existing.transient_target_count,
      'status',v_existing.status,'replayed',true,'completedAt',v_existing.completed_at
    );
  END IF;

  SELECT * INTO v_run
  FROM public.kf_extraction_runs AS r
  WHERE r.run_id=p_run_id
  FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE='P0002', MESSAGE='extraction run was not found';
  END IF;
  IF NOT (v_run.state=ANY(ARRAY['CANCELLED','REJECTED','FAILED']))
    OR v_run.sequence<>p_terminal_sequence THEN
    RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='cleanup requires current terminal run sequence';
  END IF;
  IF p_completed_at<v_run.updated_at THEN
    RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='cleanup would regress committed temporal order';
  END IF;

  SELECT count(*)::integer INTO v_batches
  FROM public.kf_extraction_batches AS b WHERE b.run_id=p_run_id;
  SELECT count(*)::integer INTO v_pages
  FROM public.kf_extraction_pages AS p WHERE p.run_id=p_run_id;
  SELECT count(*)::integer INTO v_elements
  FROM public.kf_extraction_elements AS e WHERE e.run_id=p_run_id;

  INSERT INTO public.kf_extraction_cleanup_receipts(
    cleanup_id,fingerprint,run_id,terminal_state,terminal_sequence,
    durable_batch_count,durable_page_count,durable_element_count,
    transient_target_count,status,completed_at
  ) VALUES (
    p_cleanup_id,p_fingerprint,p_run_id,v_run.state,p_terminal_sequence,
    v_batches,v_pages,v_elements,0,'COMPLETED_NO_TRANSIENT_TARGETS',p_completed_at
  ) RETURNING * INTO v_existing;

  RETURN jsonb_build_object(
    'cleanupId',v_existing.cleanup_id,'runId',v_existing.run_id,
    'terminalState',v_existing.terminal_state,'terminalSequence',v_existing.terminal_sequence,
    'durableBatchCount',v_existing.durable_batch_count,
    'durablePageCount',v_existing.durable_page_count,
    'durableElementCount',v_existing.durable_element_count,
    'transientTargetCount',v_existing.transient_target_count,
    'status',v_existing.status,'replayed',false,'completedAt',v_existing.completed_at
  );
END;
$function$;

ALTER TABLE public.kf_extraction_recovery_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_extraction_cleanup_receipts ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.kf_extraction_recovery_attempts
  FROM PUBLIC,anon,authenticated,service_role;
REVOKE ALL ON TABLE public.kf_extraction_cleanup_receipts
  FROM PUBLIC,anon,authenticated,service_role;
REVOKE ALL ON FUNCTION public.kf_extraction_retry_fingerprint_internal(uuid,text,bigint,timestamptz,uuid,text)
  FROM PUBLIC,anon,authenticated,service_role;
REVOKE ALL ON FUNCTION public.kf_extraction_cleanup_fingerprint_internal(uuid,bigint,timestamptz)
  FROM PUBLIC,anon,authenticated,service_role;
REVOKE ALL ON FUNCTION public.kf_extraction_retry_failed(uuid,text,uuid,text,bigint,uuid,timestamptz,uuid,text)
  FROM PUBLIC,anon,authenticated;
REVOKE ALL ON FUNCTION public.kf_extraction_finalize_cleanup(uuid,text,uuid,bigint,timestamptz)
  FROM PUBLIC,anon,authenticated;
GRANT EXECUTE ON FUNCTION public.kf_extraction_retry_failed(uuid,text,uuid,text,bigint,uuid,timestamptz,uuid,text)
  TO service_role;
GRANT EXECUTE ON FUNCTION public.kf_extraction_finalize_cleanup(uuid,text,uuid,bigint,timestamptz)
  TO service_role;

COMMIT;
