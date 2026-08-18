-- =============================================================================
-- ProfePlan Knowledge Factory - C.3.5 pre-gate hardening
-- Binds each human decision to the assessment requested for that review round
-- and preserves the previously closed transition-state rules.
-- =============================================================================

BEGIN;

CREATE TABLE public.kf_extraction_review_requests (
  command_id uuid PRIMARY KEY
    REFERENCES public.kf_extraction_command_receipts(command_id) ON DELETE RESTRICT,
  run_id uuid NOT NULL REFERENCES public.kf_extraction_runs(run_id) ON DELETE RESTRICT,
  assessment_id uuid NOT NULL
    REFERENCES public.kf_extraction_quality_assessments(assessment_id) ON DELETE RESTRICT,
  requested_by_actor_id uuid NOT NULL,
  requested_at timestamptz NOT NULL,
  CONSTRAINT kf_extraction_review_requests_run_assessment_key UNIQUE(run_id,assessment_id)
);

CREATE INDEX kf_extraction_review_requests_run_idx
  ON public.kf_extraction_review_requests(run_id,requested_at DESC);

CREATE TRIGGER kf_extraction_review_requests_append_only
BEFORE UPDATE OR DELETE ON public.kf_extraction_review_requests
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE OR REPLACE FUNCTION public.kf_extraction_assert_transition_state_internal(
  p_operation text,
  p_expected_state text
)
RETURNS void
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF p_operation='mark_ready' AND p_expected_state<>'REQUESTED' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='mark_ready requires REQUESTED';
  ELSIF p_operation='begin_extraction' AND p_expected_state<>'READY' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='begin_extraction requires READY';
  ELSIF p_operation='begin_validation' AND p_expected_state<>'EXTRACTING' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='begin_validation requires EXTRACTING';
  ELSIF p_operation='request_review' AND p_expected_state<>'VALIDATING' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='request_review requires VALIDATING';
  ELSIF p_operation IN ('approve_for_segmentation','request_reprocessing','reject_extraction')
    AND p_expected_state<>'PENDING_REVIEW' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='human review decision requires PENDING_REVIEW';
  ELSIF p_operation='block_authorization'
    AND NOT (p_expected_state=ANY(ARRAY['REQUESTED','READY'])) THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='block_authorization state is invalid';
  ELSIF p_operation IN ('fail_extraction','cancel_extraction')
    AND NOT (p_expected_state=ANY(ARRAY['REQUESTED','READY','EXTRACTING'])) THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='failure/cancellation state is invalid';
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_precheck_internal(
  p_operation text,
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS boolean
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_calculated text;
  v_existing_operation text;
  v_existing_fingerprint text;
BEGIN
  IF p_command_id IS NULL THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='commandId is required';
  END IF;
  IF p_fingerprint IS NULL OR p_fingerprint !~ '^[0-9a-f]{64}$' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='fingerprint must be lowercase SHA-256 hex';
  END IF;
  PERFORM public.kf_extraction_validate_payload_internal(p_operation,p_payload);
  IF p_operation<>'request_extraction' THEN
    PERFORM public.kf_extraction_assert_transition_state_internal(
      p_operation,public.kf_extraction_text_internal(p_payload->'expectedState','expectedState')
    );
  END IF;
  v_calculated := public.kf_extraction_command_fingerprint_internal(p_operation,p_payload);
  IF v_calculated<>p_fingerprint THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='fingerprint does not match canonical extraction payload';
  END IF;
  PERFORM pg_advisory_xact_lock(hashtextextended('extraction-command:'||p_command_id::text,0));
  SELECT receipt.operation,receipt.fingerprint
  INTO v_existing_operation,v_existing_fingerprint
  FROM public.kf_extraction_command_receipts AS receipt
  WHERE receipt.command_id=p_command_id;
  IF FOUND THEN
    IF v_existing_operation<>p_operation OR v_existing_fingerprint<>v_calculated THEN
      RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='commandId was already used with a different extraction command';
    END IF;
    RETURN true;
  END IF;
  RETURN false;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_transition_internal(
  p_operation text,
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_run public.kf_extraction_runs%ROWTYPE;
  v_actor_id uuid;
  v_actor_role text;
  v_at timestamptz;
  v_to_state text;
  v_event_type text;
  v_reason_code text;
  v_authorization_id uuid;
  v_authorization_source_version_id uuid;
  v_authorization_evaluated_at timestamptz;
  v_assessment public.kf_extraction_quality_assessments%ROWTYPE;
  v_requested_assessment_id uuid;
BEGIN
  v_run := public.kf_extraction_lock_run_internal(p_payload);
  PERFORM public.kf_extraction_assert_transition_state_internal(p_operation,v_run.state);
  v_actor_id := public.kf_extraction_uuid_internal(p_payload->'actor'->'actorId','actor.actorId');
  v_actor_role := public.kf_extraction_text_internal(p_payload->'actor'->'role','actor.role');
  v_at := public.kf_extraction_timestamp_internal(p_payload->'occurredAt','occurredAt');

  IF p_operation IN ('approve_for_segmentation','request_reprocessing','reject_extraction') THEN
    IF v_actor_role<>'legal_editorial_reviewer' THEN
      RAISE EXCEPTION USING ERRCODE='PT403', MESSAGE='human review decision requires legal_editorial_reviewer';
    END IF;
  ELSE
    IF v_actor_role<>'system_worker' THEN
      RAISE EXCEPTION USING ERRCODE='PT403', MESSAGE='operational extraction transition requires system_worker';
    END IF;
  END IF;
  PERFORM public.kf_extraction_assert_assignment_internal(v_actor_id,v_actor_role,v_at);

  IF p_operation='mark_ready' THEN
    v_to_state:='READY'; v_event_type:='extraction_ready';
  ELSIF p_operation='begin_extraction' THEN
    v_authorization_id := public.kf_extraction_uuid_internal(
      p_payload->'authorizationEvidence'->'authorizationId','authorizationEvidence.authorizationId'
    );
    v_authorization_source_version_id := public.kf_extraction_ref_uuid_internal(
      p_payload->'authorizationEvidence'->'sourceVersion','source_version','authorizationEvidence.sourceVersion'
    );
    IF v_authorization_source_version_id<>v_run.source_version_id THEN
      RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='claim authorization source version mismatch';
    END IF;
    v_authorization_evaluated_at := public.kf_extraction_timestamp_internal(
      p_payload->'authorizationEvidence'->'evaluatedAt','authorizationEvidence.evaluatedAt'
    );
    PERFORM public.kf_extraction_assert_current_authorization_internal(
      v_authorization_id,v_run.source_version_id,v_authorization_evaluated_at
    );
    v_to_state:='EXTRACTING'; v_event_type:='extraction_started';
  ELSIF p_operation='begin_validation' THEN
    IF NOT EXISTS (SELECT 1 FROM public.kf_extraction_pages AS p WHERE p.run_id=v_run.run_id) THEN
      RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='validation requires persisted extraction pages';
    END IF;
    v_to_state:='VALIDATING'; v_event_type:='extraction_validation_started';
  ELSIF p_operation='request_review' THEN
    SELECT a.assessment_id INTO v_requested_assessment_id
    FROM public.kf_extraction_quality_assessments AS a
    WHERE a.run_id=v_run.run_id AND a.aggregate_version=v_run.aggregate_version
    ORDER BY a.measured_at DESC,a.assessment_id DESC
    LIMIT 1;
    IF v_requested_assessment_id IS NULL THEN
      RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='review requires quality assessment for current version';
    END IF;
    v_to_state:='PENDING_REVIEW'; v_event_type:='extraction_review_requested';
  ELSIF p_operation IN ('approve_for_segmentation','request_reprocessing','reject_extraction') THEN
    SELECT rr.assessment_id INTO v_requested_assessment_id
    FROM public.kf_extraction_review_requests AS rr
    WHERE rr.run_id=v_run.run_id
    ORDER BY rr.requested_at DESC,rr.command_id DESC
    LIMIT 1;
    IF v_requested_assessment_id IS NULL
      OR v_requested_assessment_id<>public.kf_extraction_uuid_internal(p_payload->'assessmentId','assessmentId') THEN
      RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='human decision is not bound to current review assessment';
    END IF;
    SELECT * INTO v_assessment
    FROM public.kf_extraction_quality_assessments AS a
    WHERE a.assessment_id=v_requested_assessment_id AND a.run_id=v_run.run_id;
    IF p_operation='approve_for_segmentation' THEN
      IF NOT v_assessment.passed THEN
        RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='failed quality assessment cannot be approved for segmentation';
      END IF;
      v_authorization_id := public.kf_extraction_uuid_internal(
        p_payload->'authorizationEvidence'->'authorizationId','authorizationEvidence.authorizationId'
      );
      v_authorization_source_version_id := public.kf_extraction_ref_uuid_internal(
        p_payload->'authorizationEvidence'->'sourceVersion','source_version','authorizationEvidence.sourceVersion'
      );
      IF v_authorization_source_version_id<>v_run.source_version_id THEN
        RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='finalization authorization source version mismatch';
      END IF;
      v_authorization_evaluated_at := public.kf_extraction_timestamp_internal(
        p_payload->'authorizationEvidence'->'evaluatedAt','authorizationEvidence.evaluatedAt'
      );
      PERFORM public.kf_extraction_assert_current_authorization_internal(
        v_authorization_id,v_run.source_version_id,v_authorization_evaluated_at
      );
      v_to_state:='VALIDATED_FOR_SEGMENTATION'; v_event_type:='extraction_validated_for_segmentation';
    ELSIF p_operation='request_reprocessing' THEN
      v_to_state:='READY'; v_event_type:='extraction_reprocessing_requested';
    ELSE
      v_to_state:='REJECTED'; v_event_type:='extraction_rejected';
      v_reason_code:=p_payload->>'reasonCode';
    END IF;
  ELSIF p_operation='block_authorization' THEN
    v_to_state:='BLOCKED_AUTHORIZATION'; v_event_type:='extraction_authorization_blocked';
    v_reason_code:='authorization_invalid';
  ELSIF p_operation='fail_extraction' THEN
    v_to_state:='FAILED'; v_event_type:='extraction_failed'; v_reason_code:='technical_failure';
  ELSIF p_operation='cancel_extraction' THEN
    v_to_state:='CANCELLED'; v_event_type:='extraction_cancelled'; v_reason_code:='operator_cancelled';
  ELSE
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='unsupported extraction transition';
  END IF;

  PERFORM public.kf_extraction_commit_transition_internal(
    p_operation,v_event_type,v_to_state,v_reason_code,p_command_id,p_fingerprint,p_payload,v_run,
    v_authorization_id,
    CASE WHEN p_operation='begin_extraction' THEN 'claim'
         WHEN p_operation='approve_for_segmentation' THEN 'finalization' ELSE NULL END,
    v_authorization_evaluated_at
  );

  IF p_operation='request_review' THEN
    INSERT INTO public.kf_extraction_review_requests(
      command_id,run_id,assessment_id,requested_by_actor_id,requested_at
    ) VALUES (p_command_id,v_run.run_id,v_requested_assessment_id,v_actor_id,v_at);
  ELSIF p_operation IN ('approve_for_segmentation','request_reprocessing','reject_extraction') THEN
    INSERT INTO public.kf_extraction_reviews(
      review_id,command_id,run_id,assessment_id,reviewer_actor_id,reviewer_actor_role,
      decision,reason,decided_at
    ) VALUES (
      public.kf_extraction_uuid_internal(p_payload->'reviewId','reviewId'),
      p_command_id,v_run.run_id,v_requested_assessment_id,v_actor_id,v_actor_role,
      CASE p_operation WHEN 'approve_for_segmentation' THEN 'APPROVE'
        WHEN 'request_reprocessing' THEN 'REPROCESS' ELSE 'REJECT' END,
      public.kf_extraction_text_internal(p_payload->'reason','reason'),v_at
    );
  END IF;
END;
$function$;

ALTER TABLE public.kf_extraction_review_requests ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.kf_extraction_review_requests FROM PUBLIC,anon,authenticated,service_role;
REVOKE ALL ON FUNCTION public.kf_extraction_assert_transition_state_internal(text,text)
  FROM PUBLIC,anon,authenticated,service_role;

COMMIT;
