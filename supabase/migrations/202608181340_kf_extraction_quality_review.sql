-- =============================================================================
-- ProfePlan Knowledge Factory - Sublote C.3.5
-- Quality evidence, versioned synthetic policy and governed human review.
-- Disposable/synthetic validation only. Thresholds below are fixture policy,
-- not production policy and do not authorize real content or OCR.
-- =============================================================================

BEGIN;

ALTER TABLE public.kf_extraction_command_receipts
  DROP CONSTRAINT IF EXISTS kf_extraction_command_receipts_operation_check;
ALTER TABLE public.kf_extraction_command_receipts
  ADD CONSTRAINT kf_extraction_command_receipts_operation_check CHECK (
    operation IN (
      'request_extraction','mark_ready','begin_extraction','begin_validation',
      'request_review','approve_for_segmentation','request_reprocessing',
      'block_authorization','reject_extraction','fail_extraction','cancel_extraction'
    )
  );
ALTER TABLE public.kf_extraction_command_receipts
  DROP CONSTRAINT IF EXISTS kf_extraction_command_receipts_reason_shape_check;
ALTER TABLE public.kf_extraction_command_receipts
  ADD CONSTRAINT kf_extraction_command_receipts_reason_shape_check CHECK (
    (operation='block_authorization' AND reason_code='authorization_invalid')
    OR (operation='reject_extraction' AND reason_code IN ('human_review_rejected','quality_rejected'))
    OR (operation='fail_extraction' AND reason_code='technical_failure')
    OR (operation='cancel_extraction' AND reason_code='operator_cancelled')
    OR (
      operation NOT IN ('block_authorization','reject_extraction','fail_extraction','cancel_extraction')
      AND reason_code IS NULL
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
      'extraction_authorization_blocked','extraction_rejected',
      'extraction_failed','extraction_cancelled'
    )
  );
ALTER TABLE public.kf_extraction_events
  DROP CONSTRAINT IF EXISTS kf_extraction_events_authorization_shape_check;
ALTER TABLE public.kf_extraction_events
  ADD CONSTRAINT kf_extraction_events_authorization_shape_check CHECK (
    (
      event_type='extraction_started'
      AND authorization_id IS NOT NULL
      AND authorization_checkpoint='claim'
      AND authorization_evaluated_at IS NOT NULL
      AND reason_code IS NULL
    )
    OR (
      event_type='extraction_validated_for_segmentation'
      AND authorization_id IS NOT NULL
      AND authorization_checkpoint='finalization'
      AND authorization_evaluated_at IS NOT NULL
      AND reason_code IS NULL
    )
    OR (
      event_type='extraction_authorization_blocked'
      AND reason_code='authorization_invalid'
      AND authorization_checkpoint IS NULL
      AND authorization_evaluated_at IS NULL
    )
    OR (
      event_type NOT IN (
        'extraction_started','extraction_validated_for_segmentation',
        'extraction_authorization_blocked'
      )
      AND authorization_id IS NULL
      AND authorization_checkpoint IS NULL
      AND authorization_evaluated_at IS NULL
    )
  );

CREATE TABLE public.kf_extraction_quality_policies (
  policy_version text PRIMARY KEY CHECK (btrim(policy_version) <> ''),
  min_page_coverage numeric NOT NULL CHECK (min_page_coverage >= 0 AND min_page_coverage <= 1),
  max_invalid_character_rate numeric NOT NULL CHECK (
    max_invalid_character_rate >= 0 AND max_invalid_character_rate <= 1
  ),
  max_pending_pages integer NOT NULL CHECK (max_pending_pages >= 0),
  fixture_only boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT clock_timestamp()
);

INSERT INTO public.kf_extraction_quality_policies(
  policy_version,min_page_coverage,max_invalid_character_rate,max_pending_pages,fixture_only
) VALUES ('c3.5-synthetic-v1',1.0,0.0,0,true);

CREATE TABLE public.kf_extraction_quality_assessments (
  assessment_id uuid PRIMARY KEY,
  fingerprint text NOT NULL CHECK (fingerprint ~ '^[0-9a-f]{64}$'),
  run_id uuid NOT NULL REFERENCES public.kf_extraction_runs(run_id) ON DELETE RESTRICT,
  aggregate_version text NOT NULL CHECK (btrim(aggregate_version) <> ''),
  policy_version text NOT NULL REFERENCES public.kf_extraction_quality_policies(policy_version),
  expected_page_count integer NOT NULL CHECK (expected_page_count > 0),
  recorded_page_count integer NOT NULL CHECK (recorded_page_count >= 0),
  page_coverage numeric NOT NULL CHECK (page_coverage >= 0 AND page_coverage <= 1),
  invalid_character_rate numeric NOT NULL CHECK (
    invalid_character_rate >= 0 AND invalid_character_rate <= 1
  ),
  pending_page_count integer NOT NULL CHECK (pending_page_count >= 0),
  passed boolean NOT NULL,
  measured_at timestamptz NOT NULL,
  CONSTRAINT kf_extraction_quality_assessments_binding_key UNIQUE(
    run_id,aggregate_version,policy_version
  )
);

CREATE INDEX kf_extraction_quality_assessments_run_idx
  ON public.kf_extraction_quality_assessments(run_id, measured_at DESC);

CREATE TABLE public.kf_extraction_reviews (
  review_id uuid PRIMARY KEY,
  command_id uuid NOT NULL UNIQUE
    REFERENCES public.kf_extraction_command_receipts(command_id) ON DELETE RESTRICT,
  run_id uuid NOT NULL REFERENCES public.kf_extraction_runs(run_id) ON DELETE RESTRICT,
  assessment_id uuid NOT NULL
    REFERENCES public.kf_extraction_quality_assessments(assessment_id) ON DELETE RESTRICT,
  reviewer_actor_id uuid NOT NULL,
  reviewer_actor_role text NOT NULL CHECK (reviewer_actor_role='legal_editorial_reviewer'),
  decision text NOT NULL CHECK (decision IN ('APPROVE','REJECT','REPROCESS')),
  reason text NOT NULL CHECK (btrim(reason) <> ''),
  decided_at timestamptz NOT NULL
);

CREATE INDEX kf_extraction_reviews_run_idx
  ON public.kf_extraction_reviews(run_id, decided_at DESC);

CREATE TRIGGER kf_extraction_quality_policies_append_only
BEFORE UPDATE OR DELETE ON public.kf_extraction_quality_policies
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();
CREATE TRIGGER kf_extraction_quality_assessments_append_only
BEFORE UPDATE OR DELETE ON public.kf_extraction_quality_assessments
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();
CREATE TRIGGER kf_extraction_reviews_append_only
BEFORE UPDATE OR DELETE ON public.kf_extraction_reviews
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE OR REPLACE FUNCTION public.kf_extraction_quality_fingerprint_internal(
  p_run_id uuid,
  p_aggregate_version text,
  p_policy_version text,
  p_expected_page_count integer,
  p_measured_at timestamptz
)
RETURNS text
LANGUAGE sql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT encode(sha256(convert_to(
    public.kf_extraction_canonical_json_internal(jsonb_build_object(
      'fingerprintVersion',1,
      'runId',p_run_id,
      'aggregateVersion',p_aggregate_version,
      'policyVersion',p_policy_version,
      'expectedPageCount',p_expected_page_count,
      'measuredAt',p_measured_at
    )), 'UTF8')), 'hex')
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_assess_quality(
  p_assessment_id uuid,
  p_fingerprint text,
  p_run_id uuid,
  p_policy_version text,
  p_expected_page_count integer,
  p_measured_at timestamptz
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_run public.kf_extraction_runs%ROWTYPE;
  v_policy public.kf_extraction_quality_policies%ROWTYPE;
  v_existing public.kf_extraction_quality_assessments%ROWTYPE;
  v_expected_fingerprint text;
  v_recorded integer;
  v_pending integer;
  v_total_chars bigint;
  v_invalid_chars bigint;
  v_page_coverage numeric;
  v_invalid_rate numeric;
  v_passed boolean;
BEGIN
  IF p_assessment_id IS NULL OR p_run_id IS NULL OR p_expected_page_count <= 0 THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='invalid quality assessment identity/input';
  END IF;
  SELECT * INTO v_run FROM public.kf_extraction_runs AS r WHERE r.run_id=p_run_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE='P0002', MESSAGE='extraction run was not found';
  END IF;
  IF v_run.state <> 'VALIDATING' THEN
    RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='quality assessment requires VALIDATING state';
  END IF;
  SELECT * INTO v_policy
  FROM public.kf_extraction_quality_policies AS p
  WHERE p.policy_version=p_policy_version;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE='P0002', MESSAGE='quality policy was not found';
  END IF;

  v_expected_fingerprint := public.kf_extraction_quality_fingerprint_internal(
    p_run_id,v_run.aggregate_version,p_policy_version,p_expected_page_count,p_measured_at
  );
  IF p_fingerprint <> v_expected_fingerprint THEN
    RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='quality assessment fingerprint mismatch';
  END IF;

  SELECT * INTO v_existing
  FROM public.kf_extraction_quality_assessments AS a
  WHERE a.assessment_id=p_assessment_id;
  IF FOUND THEN
    IF v_existing.fingerprint <> p_fingerprint OR v_existing.run_id <> p_run_id THEN
      RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='assessmentId replay collides with different effect';
    END IF;
    RETURN jsonb_build_object(
      'assessmentId',v_existing.assessment_id,'runId',v_existing.run_id,
      'policyVersion',v_existing.policy_version,'pageCoverage',v_existing.page_coverage,
      'invalidCharacterRate',v_existing.invalid_character_rate,
      'pendingPageCount',v_existing.pending_page_count,'passed',v_existing.passed,
      'replayed',true
    );
  END IF;

  SELECT
    count(*)::integer,
    count(*) FILTER (WHERE p.outcome='pending')::integer,
    coalesce(sum(length(coalesce(p.text_content,''))),0)::bigint,
    coalesce(sum(length(coalesce(p.text_content,'')) - length(replace(coalesce(p.text_content,''),'�',''))),0)::bigint
  INTO v_recorded,v_pending,v_total_chars,v_invalid_chars
  FROM public.kf_extraction_pages AS p
  WHERE p.run_id=p_run_id;

  v_page_coverage := least(1.0, v_recorded::numeric / p_expected_page_count::numeric);
  v_invalid_rate := CASE WHEN v_total_chars=0 THEN 0 ELSE v_invalid_chars::numeric/v_total_chars::numeric END;
  v_passed := v_recorded=p_expected_page_count
    AND v_page_coverage >= v_policy.min_page_coverage
    AND v_invalid_rate <= v_policy.max_invalid_character_rate
    AND v_pending <= v_policy.max_pending_pages;

  INSERT INTO public.kf_extraction_quality_assessments(
    assessment_id,fingerprint,run_id,aggregate_version,policy_version,
    expected_page_count,recorded_page_count,page_coverage,invalid_character_rate,
    pending_page_count,passed,measured_at
  ) VALUES (
    p_assessment_id,p_fingerprint,p_run_id,v_run.aggregate_version,p_policy_version,
    p_expected_page_count,v_recorded,v_page_coverage,v_invalid_rate,v_pending,v_passed,p_measured_at
  );

  RETURN jsonb_build_object(
    'assessmentId',p_assessment_id,'runId',p_run_id,'policyVersion',p_policy_version,
    'pageCoverage',v_page_coverage,'invalidCharacterRate',v_invalid_rate,
    'pendingPageCount',v_pending,'passed',v_passed,'replayed',false
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_validate_payload_internal(
  p_operation text,
  p_payload jsonb
)
RETURNS void
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_required text[];
  v_expected_state text;
  v_reason_code text;
  v_evidence jsonb;
BEGIN
  IF NOT (p_operation = ANY(ARRAY[
    'request_extraction','mark_ready','begin_extraction','begin_validation',
    'request_review','approve_for_segmentation','request_reprocessing',
    'block_authorization','reject_extraction','fail_extraction','cancel_extraction'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='unsupported extraction operation';
  END IF;

  IF p_operation='request_extraction' THEN
    PERFORM public.kf_extraction_assert_object_internal(
      p_payload,
      ARRAY['commandType','actor','occurredAt','correlationId','reason','request'],
      ARRAY['commandType','actor','occurredAt','correlationId','reason','expectedVersion','expectedSequence','request'],
      'extraction command payload'
    );
  ELSIF p_operation='approve_for_segmentation' THEN
    v_required := ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','run',
      'expectedState','expectedVersion','expectedSequence','assessmentId','reviewId',
      'authorizationEvidence'
    ];
    PERFORM public.kf_extraction_assert_object_internal(p_payload,v_required,v_required,'extraction command payload');
  ELSIF p_operation IN ('request_reprocessing','reject_extraction') THEN
    v_required := ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','run',
      'expectedState','expectedVersion','expectedSequence','assessmentId','reviewId'
    ];
    IF p_operation='reject_extraction' THEN
      v_required := array_append(v_required,'reasonCode');
    END IF;
    PERFORM public.kf_extraction_assert_object_internal(p_payload,v_required,v_required,'extraction command payload');
  ELSIF p_operation='begin_extraction' THEN
    v_required := ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','run',
      'expectedState','expectedVersion','expectedSequence','authorizationEvidence'
    ];
    PERFORM public.kf_extraction_assert_object_internal(p_payload,v_required,v_required,'extraction command payload');
  ELSIF p_operation IN ('block_authorization','fail_extraction','cancel_extraction') THEN
    v_required := ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','run',
      'expectedState','expectedVersion','expectedSequence','reasonCode'
    ];
    PERFORM public.kf_extraction_assert_object_internal(p_payload,v_required,v_required,'extraction command payload');
  ELSE
    v_required := ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','run',
      'expectedState','expectedVersion','expectedSequence'
    ];
    PERFORM public.kf_extraction_assert_object_internal(p_payload,v_required,v_required,'extraction command payload');
  END IF;

  IF public.kf_extraction_text_internal(p_payload->'commandType','commandType') <> p_operation THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='commandType does not match RPC operation';
  END IF;
  PERFORM public.kf_extraction_assert_actor_internal(p_payload->'actor','actor');
  PERFORM public.kf_extraction_timestamp_internal(p_payload->'occurredAt','occurredAt');
  PERFORM public.kf_extraction_uuid_internal(p_payload->'correlationId','correlationId');
  PERFORM public.kf_extraction_text_internal(p_payload->'reason','reason');

  IF p_operation='request_extraction' THEN
    PERFORM public.kf_extraction_assert_handoff_internal(
      p_payload->'request',public.kf_extraction_timestamp_internal(p_payload->'occurredAt','occurredAt')
    );
    RETURN;
  END IF;

  PERFORM public.kf_extraction_ref_uuid_internal(p_payload->'run','extraction_run','run');
  PERFORM public.kf_extraction_text_internal(p_payload->'expectedVersion','expectedVersion');
  PERFORM public.kf_extraction_positive_bigint_internal(p_payload->'expectedSequence','expectedSequence');
  v_expected_state := public.kf_extraction_text_internal(p_payload->'expectedState','expectedState');

  IF p_operation='mark_ready' AND v_expected_state<>'REQUESTED' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='mark_ready requires REQUESTED';
  ELSIF p_operation='begin_extraction' AND v_expected_state<>'READY' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='begin_extraction requires READY';
  ELSIF p_operation='begin_validation' AND v_expected_state<>'EXTRACTING' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='begin_validation requires EXTRACTING';
  ELSIF p_operation='request_review' AND v_expected_state<>'VALIDATING' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='request_review requires VALIDATING';
  ELSIF p_operation IN ('approve_for_segmentation','request_reprocessing','reject_extraction')
    AND v_expected_state<>'PENDING_REVIEW' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='human review decision requires PENDING_REVIEW';
  END IF;

  IF p_operation IN ('begin_extraction','approve_for_segmentation') THEN
    v_evidence := p_payload->'authorizationEvidence';
    PERFORM public.kf_extraction_assert_object_internal(
      v_evidence,
      ARRAY['authorizationId','sourceVersion','purpose','checkpoint','evaluatedAt'],
      ARRAY['authorizationId','sourceVersion','purpose','checkpoint','evaluatedAt'],
      'authorizationEvidence'
    );
    IF public.kf_extraction_text_internal(v_evidence->'purpose','authorizationEvidence.purpose') <> 'extraction' THEN
      RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='authorization purpose must be extraction';
    END IF;
    IF public.kf_extraction_text_internal(v_evidence->'checkpoint','authorizationEvidence.checkpoint')
      <> CASE WHEN p_operation='begin_extraction' THEN 'claim' ELSE 'finalization' END THEN
      RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='authorization checkpoint is invalid for operation';
    END IF;
    IF public.kf_extraction_timestamp_internal(v_evidence->'evaluatedAt','authorizationEvidence.evaluatedAt')
      <> public.kf_extraction_timestamp_internal(p_payload->'occurredAt','occurredAt') THEN
      RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='authorization must be evaluated at command time';
    END IF;
  END IF;

  IF p_operation IN ('approve_for_segmentation','request_reprocessing','reject_extraction') THEN
    PERFORM public.kf_extraction_uuid_internal(p_payload->'assessmentId','assessmentId');
    PERFORM public.kf_extraction_uuid_internal(p_payload->'reviewId','reviewId');
  END IF;
  IF p_operation='reject_extraction' THEN
    v_reason_code := public.kf_extraction_text_internal(p_payload->'reasonCode','reasonCode');
    IF NOT (v_reason_code = ANY(ARRAY['human_review_rejected','quality_rejected'])) THEN
      RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='reject_extraction reasonCode is invalid';
    END IF;
  ELSIF p_operation='block_authorization' AND p_payload->>'reasonCode'<>'authorization_invalid' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='block_authorization reasonCode is invalid';
  ELSIF p_operation='fail_extraction' AND p_payload->>'reasonCode'<>'technical_failure' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='fail_extraction reasonCode is invalid';
  ELSIF p_operation='cancel_extraction' AND p_payload->>'reasonCode'<>'operator_cancelled' THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='cancel_extraction reasonCode is invalid';
  END IF;
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
BEGIN
  v_run := public.kf_extraction_lock_run_internal(p_payload);
  v_actor_id := public.kf_extraction_uuid_internal(p_payload->'actor'->'actorId','actor.actorId');
  v_actor_role := public.kf_extraction_text_internal(p_payload->'actor'->'role','actor.role');
  v_at := public.kf_extraction_timestamp_internal(p_payload->'occurredAt','occurredAt');

  IF p_operation IN ('approve_for_segmentation','request_reprocessing','reject_extraction') THEN
    IF v_actor_role <> 'legal_editorial_reviewer' THEN
      RAISE EXCEPTION USING ERRCODE='PT403', MESSAGE='human review decision requires legal_editorial_reviewer';
    END IF;
  ELSE
    IF v_actor_role <> 'system_worker' THEN
      RAISE EXCEPTION USING ERRCODE='PT403', MESSAGE='operational extraction transition requires system_worker';
    END IF;
  END IF;
  PERFORM public.kf_extraction_assert_assignment_internal(v_actor_id,v_actor_role,v_at);

  IF p_operation='mark_ready' THEN
    v_to_state:='READY'; v_event_type:='extraction_ready';
  ELSIF p_operation='begin_extraction' THEN
    v_to_state:='EXTRACTING'; v_event_type:='extraction_started';
  ELSIF p_operation='begin_validation' THEN
    IF NOT EXISTS (SELECT 1 FROM public.kf_extraction_pages p WHERE p.run_id=v_run.run_id) THEN
      RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='validation requires persisted extraction pages';
    END IF;
    v_to_state:='VALIDATING'; v_event_type:='extraction_validation_started';
  ELSIF p_operation='request_review' THEN
    IF NOT EXISTS (
      SELECT 1 FROM public.kf_extraction_quality_assessments a
      WHERE a.run_id=v_run.run_id AND a.aggregate_version=v_run.aggregate_version
    ) THEN
      RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='review requires quality assessment for current version';
    END IF;
    v_to_state:='PENDING_REVIEW'; v_event_type:='extraction_review_requested';
  ELSIF p_operation IN ('approve_for_segmentation','request_reprocessing','reject_extraction') THEN
    SELECT * INTO v_assessment FROM public.kf_extraction_quality_assessments a
    WHERE a.assessment_id=public.kf_extraction_uuid_internal(p_payload->'assessmentId','assessmentId')
      AND a.run_id=v_run.run_id;
    IF NOT FOUND THEN
      RAISE EXCEPTION USING ERRCODE='PT409', MESSAGE='review assessment does not belong to extraction run';
    END IF;
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
      v_to_state:='VALIDATED_FOR_SEGMENTATION';
      v_event_type:='extraction_validated_for_segmentation';
    ELSIF p_operation='request_reprocessing' THEN
      v_to_state:='READY'; v_event_type:='extraction_reprocessing_requested';
    ELSE
      v_to_state:='REJECTED'; v_event_type:='extraction_rejected';
      v_reason_code := p_payload->>'reasonCode';
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

  IF p_operation IN ('approve_for_segmentation','request_reprocessing','reject_extraction') THEN
    INSERT INTO public.kf_extraction_reviews(
      review_id,command_id,run_id,assessment_id,reviewer_actor_id,reviewer_actor_role,
      decision,reason,decided_at
    ) VALUES (
      public.kf_extraction_uuid_internal(p_payload->'reviewId','reviewId'),
      p_command_id,v_run.run_id,v_assessment.assessment_id,v_actor_id,v_actor_role,
      CASE p_operation WHEN 'approve_for_segmentation' THEN 'APPROVE'
        WHEN 'request_reprocessing' THEN 'REPROCESS' ELSE 'REJECT' END,
      public.kf_extraction_text_internal(p_payload->'reason','reason'),v_at
    );
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_transition_c3_5(
  p_operation text,
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS TABLE(
  contract_version text,command_id uuid,fingerprint text,correlation_id uuid,
  operation text,run_id uuid,aggregate_version text,sequence bigint,event_ids uuid[],
  previous_state text,state text,replayed boolean,committed_at timestamptz
)
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF NOT (p_operation = ANY(ARRAY[
    'begin_validation','request_review','approve_for_segmentation',
    'request_reprocessing','reject_extraction'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE='22023', MESSAGE='operation is outside C.3.5 transition RPC';
  END IF;
  IF public.kf_extraction_precheck_internal(p_operation,p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,true);
    RETURN;
  END IF;
  PERFORM public.kf_extraction_transition_internal(p_operation,p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,false);
END;
$function$;

ALTER TABLE public.kf_extraction_quality_policies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_extraction_quality_assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_extraction_reviews ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.kf_extraction_quality_policies FROM PUBLIC,anon,authenticated,service_role;
REVOKE ALL ON TABLE public.kf_extraction_quality_assessments FROM PUBLIC,anon,authenticated,service_role;
REVOKE ALL ON TABLE public.kf_extraction_reviews FROM PUBLIC,anon,authenticated,service_role;
REVOKE ALL ON FUNCTION public.kf_extraction_quality_fingerprint_internal(uuid,text,text,integer,timestamptz)
  FROM PUBLIC,anon,authenticated,service_role;
REVOKE ALL ON FUNCTION public.kf_extraction_assess_quality(uuid,text,uuid,text,integer,timestamptz)
  FROM PUBLIC,anon,authenticated;
REVOKE ALL ON FUNCTION public.kf_extraction_transition_c3_5(text,uuid,text,jsonb)
  FROM PUBLIC,anon,authenticated;
GRANT EXECUTE ON FUNCTION public.kf_extraction_assess_quality(uuid,text,uuid,text,integer,timestamptz)
  TO service_role;
GRANT EXECUTE ON FUNCTION public.kf_extraction_transition_c3_5(text,uuid,text,jsonb)
  TO service_role;

COMMIT;
