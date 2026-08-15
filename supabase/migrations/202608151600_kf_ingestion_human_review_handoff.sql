-- =============================================================================
-- ProfePlan Knowledge Factory - Sublote C.2.5
-- Governed human review and persisted handoff evidence for C.3 eligibility.
--
-- SECURITY / SCOPE:
-- - additive extension of the C.2.4 durable control-plane;
-- - preserves INGESTION_CONTRACT_VERSION = 1.0.0 and the C.2.1 state machine;
-- - C.1 remains authoritative for actor competence and extraction authorization;
-- - APPROVED_FOR_EXTRACTION is a terminal C.2 fact, never execution of C.3;
-- - no queue, worker, parser, OCR, extraction, hosted resource or real content.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Extend existing append-only receipts/events to the C.2.1 review commands
-- ---------------------------------------------------------------------------
ALTER TABLE public.kf_ingestion_command_receipts
  DROP CONSTRAINT kf_ingestion_command_receipts_operation_check,
  DROP CONSTRAINT kf_ingestion_command_receipts_reason_shape_check;

ALTER TABLE public.kf_ingestion_command_receipts
  ADD CONSTRAINT kf_ingestion_command_receipts_operation_check CHECK (
    operation IN (
      'request_ingestion', 'begin_staging', 'mark_staged', 'begin_verification',
      'confirm_verified', 'request_review', 'approve_for_extraction',
      'reject_ingestion', 'fail_ingestion', 'cancel_ingestion'
    )
  ),
  ADD CONSTRAINT kf_ingestion_command_receipts_reason_shape_check CHECK (
    (operation = 'fail_ingestion' AND reason_code = 'technical_failure')
    OR (operation = 'cancel_ingestion' AND reason_code = 'operator_cancelled')
    OR (
      operation = 'reject_ingestion'
      AND reason_code IN ('policy_rejected', 'human_review_rejected')
    )
    OR (
      operation NOT IN ('fail_ingestion', 'cancel_ingestion', 'reject_ingestion')
      AND reason_code IS NULL
    )
  );

ALTER TABLE public.kf_ingestion_events
  DROP CONSTRAINT kf_ingestion_events_event_type_check;

ALTER TABLE public.kf_ingestion_events
  ADD COLUMN review_id uuid,
  ADD COLUMN reviewer_assignment_id uuid
    REFERENCES public.kf_source_actor_assignments(id) ON DELETE RESTRICT,
  ADD COLUMN reviewer_actor_id uuid,
  ADD COLUMN reviewer_actor_role text CHECK (
    reviewer_actor_role IS NULL OR reviewer_actor_role = 'legal_editorial_reviewer'
  ),
  ADD COLUMN review_decision text CHECK (
    review_decision IS NULL OR review_decision IN ('APPROVE_FOR_EXTRACTION', 'REJECT')
  ),
  ADD COLUMN review_decided_at timestamptz,
  ADD COLUMN review_reason text CHECK (review_reason IS NULL OR btrim(review_reason) <> ''),
  ADD COLUMN reviewed_artifact_id uuid
    REFERENCES public.kf_ingestion_staging_artifacts(artifact_id) ON DELETE RESTRICT,
  ADD COLUMN extraction_authorization_id uuid
    REFERENCES public.kf_source_authorizations(id) ON DELETE RESTRICT,
  ADD COLUMN extraction_authorization_evaluated_at timestamptz;

ALTER TABLE public.kf_ingestion_events
  ADD CONSTRAINT kf_ingestion_events_event_type_check CHECK (
    event_type IN (
      'ingestion_requested', 'ingestion_staging_started', 'ingestion_staged',
      'ingestion_verification_started', 'ingestion_verified',
      'ingestion_review_requested', 'ingestion_approved_for_extraction',
      'ingestion_rejected', 'ingestion_failed', 'ingestion_cancelled'
    )
  ),
  ADD CONSTRAINT kf_ingestion_events_review_shape_check CHECK (
    (
      event_type = 'ingestion_approved_for_extraction'
      AND reason_code IS NULL
      AND review_id IS NOT NULL
      AND reviewer_assignment_id IS NOT NULL
      AND reviewer_actor_id IS NOT NULL
      AND reviewer_actor_role = 'legal_editorial_reviewer'
      AND review_decision = 'APPROVE_FOR_EXTRACTION'
      AND review_decided_at IS NOT NULL
      AND review_reason IS NOT NULL
      AND reviewed_artifact_id IS NOT NULL
      AND extraction_authorization_id IS NOT NULL
      AND extraction_authorization_evaluated_at IS NOT NULL
    )
    OR (
      event_type = 'ingestion_rejected'
      AND reason_code = 'human_review_rejected'
      AND review_id IS NOT NULL
      AND reviewer_assignment_id IS NOT NULL
      AND reviewer_actor_id IS NOT NULL
      AND reviewer_actor_role = 'legal_editorial_reviewer'
      AND review_decision = 'REJECT'
      AND review_decided_at IS NOT NULL
      AND review_reason IS NOT NULL
      AND reviewed_artifact_id IS NOT NULL
      AND extraction_authorization_id IS NULL
      AND extraction_authorization_evaluated_at IS NULL
    )
    OR (
      event_type = 'ingestion_rejected'
      AND reason_code = 'policy_rejected'
      AND review_id IS NULL
      AND reviewer_assignment_id IS NULL
      AND reviewer_actor_id IS NULL
      AND reviewer_actor_role IS NULL
      AND review_decision IS NULL
      AND review_decided_at IS NULL
      AND review_reason IS NULL
      AND reviewed_artifact_id IS NULL
      AND extraction_authorization_id IS NULL
      AND extraction_authorization_evaluated_at IS NULL
    )
    OR (
      event_type NOT IN ('ingestion_approved_for_extraction', 'ingestion_rejected')
      AND review_id IS NULL
      AND reviewer_assignment_id IS NULL
      AND reviewer_actor_id IS NULL
      AND reviewer_actor_role IS NULL
      AND review_decision IS NULL
      AND review_decided_at IS NULL
      AND review_reason IS NULL
      AND reviewed_artifact_id IS NULL
      AND extraction_authorization_id IS NULL
      AND extraction_authorization_evaluated_at IS NULL
    )
  );

CREATE UNIQUE INDEX kf_ingestion_events_review_id_key
  ON public.kf_ingestion_events(review_id)
  WHERE review_id IS NOT NULL;

-- ---------------------------------------------------------------------------
-- 2. Closed C.2.5 payload validation
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_ingestion_c25_validate_review_internal(
  p_review jsonb,
  p_expected_decision text
)
RETURNS void
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_decision text;
  v_role text;
BEGIN
  PERFORM public.kf_ingestion_assert_object_internal(
    p_review,
    ARRAY['reviewId','reviewMode','reviewer','decision','decidedAt','reason'],
    ARRAY['reviewId','reviewMode','reviewer','decision','decidedAt','reason'],
    'review'
  );
  PERFORM public.kf_ingestion_uuid_internal(p_review -> 'reviewId', 'review.reviewId');
  IF public.kf_ingestion_text_internal(p_review -> 'reviewMode', 'review.reviewMode') <> 'human' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'review.reviewMode must be human';
  END IF;
  PERFORM public.kf_ingestion_assert_actor_internal(p_review -> 'reviewer', 'review.reviewer');
  v_role := public.kf_ingestion_text_internal(p_review -> 'reviewer' -> 'role', 'review.reviewer.role');
  IF v_role <> 'legal_editorial_reviewer' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'human ingestion decision requires legal_editorial_reviewer competence';
  END IF;
  v_decision := public.kf_ingestion_text_internal(p_review -> 'decision', 'review.decision');
  IF v_decision <> p_expected_decision THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'review.decision does not match ingestion command';
  END IF;
  PERFORM public.kf_ingestion_timestamp_internal(p_review -> 'decidedAt', 'review.decidedAt');
  PERFORM public.kf_ingestion_text_internal(p_review -> 'reason', 'review.reason');
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_c25_validate_payload_internal(
  p_operation text,
  p_payload jsonb
)
RETURNS void
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_expected_state text;
  v_reason_code text;
  v_evidence jsonb;
BEGIN
  IF NOT (p_operation = ANY(ARRAY[
    'request_review','approve_for_extraction','reject_ingestion'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'ingestion operation is outside C.2.5';
  END IF;

  PERFORM public.kf_ingestion_assert_object_internal(
    p_payload,
    CASE p_operation
      WHEN 'request_review' THEN ARRAY[
        'commandType','actor','occurredAt','correlationId','reason','run',
        'expectedState','expectedVersion','expectedSequence'
      ]
      WHEN 'approve_for_extraction' THEN ARRAY[
        'commandType','actor','occurredAt','correlationId','reason','run',
        'expectedState','expectedVersion','expectedSequence','sourceVersion',
        'review','authorizationEvidence'
      ]
      ELSE ARRAY[
        'commandType','actor','occurredAt','correlationId','reason','run',
        'expectedState','expectedVersion','expectedSequence','reasonCode','review'
      ]
    END,
    CASE p_operation
      WHEN 'request_review' THEN ARRAY[
        'commandType','actor','occurredAt','correlationId','reason','run',
        'expectedState','expectedVersion','expectedSequence'
      ]
      WHEN 'approve_for_extraction' THEN ARRAY[
        'commandType','actor','occurredAt','correlationId','reason','run',
        'expectedState','expectedVersion','expectedSequence','sourceVersion',
        'review','authorizationEvidence'
      ]
      ELSE ARRAY[
        'commandType','actor','occurredAt','correlationId','reason','run',
        'expectedState','expectedVersion','expectedSequence','reasonCode','review'
      ]
    END,
    'C.2.5 ingestion command payload'
  );

  IF public.kf_ingestion_text_internal(p_payload -> 'commandType', 'commandType') <> p_operation THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'commandType does not match RPC operation';
  END IF;
  PERFORM public.kf_ingestion_assert_actor_internal(p_payload -> 'actor', 'actor');
  PERFORM public.kf_ingestion_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  PERFORM public.kf_ingestion_uuid_internal(p_payload -> 'correlationId', 'correlationId');
  PERFORM public.kf_ingestion_text_internal(p_payload -> 'reason', 'reason');
  PERFORM public.kf_ingestion_ref_uuid_internal(p_payload -> 'run', 'processing_run', 'run');
  PERFORM public.kf_ingestion_text_internal(p_payload -> 'expectedVersion', 'expectedVersion');
  PERFORM public.kf_ingestion_positive_bigint_internal(p_payload -> 'expectedSequence', 'expectedSequence');

  v_expected_state := public.kf_ingestion_text_internal(p_payload -> 'expectedState', 'expectedState');
  IF p_operation = 'request_review' AND v_expected_state <> 'VERIFIED' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'request_review requires expectedState VERIFIED';
  END IF;
  IF p_operation IN ('approve_for_extraction','reject_ingestion')
    AND v_expected_state <> 'PENDING_REVIEW' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'human review decision requires expectedState PENDING_REVIEW';
  END IF;

  IF p_operation = 'approve_for_extraction' THEN
    PERFORM public.kf_ingestion_ref_uuid_internal(
      p_payload -> 'sourceVersion', 'source_version', 'sourceVersion'
    );
    PERFORM public.kf_ingestion_c25_validate_review_internal(
      p_payload -> 'review', 'APPROVE_FOR_EXTRACTION'
    );
    IF jsonb_typeof(p_payload -> 'authorizationEvidence') <> 'array'
      OR jsonb_array_length(p_payload -> 'authorizationEvidence') <> 1 THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'approval requires exactly one extraction authorization evidence item';
    END IF;
    v_evidence := (p_payload -> 'authorizationEvidence') -> 0;
    PERFORM public.kf_ingestion_assert_object_internal(
      v_evidence,
      ARRAY['authorizationId','sourceVersion','purpose','evaluatedAt'],
      ARRAY['authorizationId','sourceVersion','purpose','evaluatedAt'],
      'extraction authorization evidence'
    );
    PERFORM public.kf_ingestion_uuid_internal(
      v_evidence -> 'authorizationId', 'authorizationEvidence.authorizationId'
    );
    PERFORM public.kf_ingestion_ref_uuid_internal(
      v_evidence -> 'sourceVersion', 'source_version', 'authorizationEvidence.sourceVersion'
    );
    IF public.kf_ingestion_text_internal(v_evidence -> 'purpose', 'authorizationEvidence.purpose') <> 'extraction' THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'approval evidence purpose must be extraction';
    END IF;
    PERFORM public.kf_ingestion_timestamp_internal(
      v_evidence -> 'evaluatedAt', 'authorizationEvidence.evaluatedAt'
    );
  ELSEIF p_operation = 'reject_ingestion' THEN
    v_reason_code := public.kf_ingestion_text_internal(p_payload -> 'reasonCode', 'reasonCode');
    IF v_reason_code <> 'human_review_rejected' THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'C.2.5 rejection requires human_review_rejected';
    END IF;
    PERFORM public.kf_ingestion_c25_validate_review_internal(p_payload -> 'review', 'REJECT');
  END IF;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 3. C.1-backed competence and historical extraction authorization evidence
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_ingestion_c25_assignment_internal(
  p_actor_id uuid,
  p_role text,
  p_at timestamptz
)
RETURNS uuid
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_count bigint;
  v_assignment_id uuid;
BEGIN
  SELECT count(*), min(assignments.id)
    INTO v_count, v_assignment_id
  FROM public.kf_source_actor_assignments AS assignments
  WHERE assignments.actor_id = p_actor_id
    AND assignments.actor_role = p_role
    AND p_at >= assignments.effective_from
    AND (assignments.effective_until IS NULL OR p_at <= assignments.effective_until);

  IF v_count = 0 THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'actor is not competent for this ingestion decision time';
  END IF;
  IF v_count <> 1 THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'actor competence is ambiguous for this ingestion decision time';
  END IF;
  RETURN v_assignment_id;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_c25_assert_extraction_authorization_internal(
  p_authorization_id uuid,
  p_source_version_id uuid,
  p_at timestamptz
)
RETURNS void
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_state text;
  v_effective_from timestamptz;
  v_effective_until timestamptz;
BEGIN
  SELECT
    events.authorization_to_state,
    events.effective_from,
    events.effective_until
  INTO v_state, v_effective_from, v_effective_until
  FROM public.kf_source_governance_events AS events
  WHERE events.dimension = 'authorization'
    AND events.authorization_id = p_authorization_id
    AND events.subject_identity_id = p_source_version_id
    AND events.purpose = 'extraction'
    AND events.effective_at <= p_at
  ORDER BY events.effective_at DESC, events.sequence DESC, events.event_id DESC
  LIMIT 1;

  IF NOT FOUND
    OR v_state <> 'GRANTED'
    OR p_at < v_effective_from
    OR (v_effective_until IS NOT NULL AND p_at > v_effective_until) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'extraction authorization is not valid at the human decision time';
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_c25_reviewed_artifact_internal(
  p_run_id uuid,
  p_decision_at timestamptz,
  p_require_available boolean
)
RETURNS uuid
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_count bigint;
  v_artifact public.kf_ingestion_staging_artifacts%ROWTYPE;
BEGIN
  SELECT count(*) INTO v_count
  FROM public.kf_ingestion_staging_artifacts AS artifacts
  WHERE artifacts.run_id = p_run_id;
  IF v_count <> 1 THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'ingestion review requires exactly one staging artifact';
  END IF;

  SELECT * INTO v_artifact
  FROM public.kf_ingestion_staging_artifacts AS artifacts
  WHERE artifacts.run_id = p_run_id
  LIMIT 1;

  IF NOT EXISTS (
    SELECT 1
    FROM public.kf_ingestion_integrity_evidence AS evidence
    WHERE evidence.artifact_id = v_artifact.artifact_id
      AND evidence.run_id = v_artifact.run_id
      AND evidence.source_version_id = v_artifact.source_version_id
      AND evidence.received_file_id = v_artifact.received_file_id
  ) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'ingestion review requires persisted integrity evidence';
  END IF;

  IF p_require_available AND (
    v_artifact.state <> 'VERIFIED' OR p_decision_at >= v_artifact.expires_at
  ) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'verified staging artifact is not available for governed handoff';
  END IF;

  RETURN v_artifact.artifact_id;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 4. Idempotency precheck: same commandId + same canonical fingerprint = replay
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_ingestion_c25_precheck_internal(
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
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'commandId is required';
  END IF;
  IF p_fingerprint IS NULL OR p_fingerprint !~ '^[0-9a-f]{64}$' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'fingerprint must be lowercase SHA-256 hex';
  END IF;

  PERFORM public.kf_ingestion_c25_validate_payload_internal(p_operation, p_payload);
  v_calculated := public.kf_ingestion_command_fingerprint_internal(p_operation, p_payload);
  IF v_calculated <> p_fingerprint THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'fingerprint does not match canonical ingestion payload';
  END IF;

  PERFORM pg_advisory_xact_lock(hashtextextended('ingestion-command:' || p_command_id::text, 0));
  SELECT receipt.operation, receipt.fingerprint
    INTO v_existing_operation, v_existing_fingerprint
  FROM public.kf_ingestion_command_receipts AS receipt
  WHERE receipt.command_id = p_command_id;

  IF FOUND THEN
    IF v_existing_operation <> p_operation OR v_existing_fingerprint <> v_calculated THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'commandId was already used with a different ingestion command';
    END IF;
    RETURN true;
  END IF;
  RETURN false;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 5. Review request and human decision transitions
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_ingestion_request_review_internal(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_run public.kf_ingestion_runs%ROWTYPE;
  v_actor_id uuid;
  v_actor_role text;
  v_occurred_at timestamptz;
BEGIN
  v_run := public.kf_ingestion_lock_run_internal(p_payload);
  IF v_run.state <> 'VERIFIED' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'request_review transition is not allowed';
  END IF;

  v_actor_id := public.kf_ingestion_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_actor_role := public.kf_ingestion_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_occurred_at := public.kf_ingestion_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  IF v_actor_role <> 'system_worker' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'request_review requires system_worker operational competence';
  END IF;
  PERFORM public.kf_ingestion_c25_assignment_internal(v_actor_id, v_actor_role, v_occurred_at);
  PERFORM public.kf_ingestion_c25_reviewed_artifact_internal(v_run.run_id, v_occurred_at, true);

  PERFORM public.kf_ingestion_commit_transition_internal(
    'request_review', 'ingestion_review_requested', 'PENDING_REVIEW', NULL,
    p_command_id, p_fingerprint, p_payload, v_run
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_human_decision_internal(
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
  v_run public.kf_ingestion_runs%ROWTYPE;
  v_last_event public.kf_ingestion_events%ROWTYPE;
  v_actor_id uuid;
  v_actor_role text;
  v_reviewer_id uuid;
  v_reviewer_role text;
  v_assignment_id uuid;
  v_review_id uuid;
  v_decided_at timestamptz;
  v_review_reason text;
  v_command_occurred_at timestamptz;
  v_command_reason text;
  v_correlation_id uuid;
  v_artifact_id uuid;
  v_source_version_id uuid;
  v_authorization_id uuid;
  v_authorization_evaluated_at timestamptz;
  v_evidence jsonb;
  v_reason_code text;
  v_to_state text;
  v_event_type text;
  v_decision text;
  v_new_version text := gen_random_uuid()::text;
  v_new_sequence bigint;
  v_event_id uuid := gen_random_uuid();
BEGIN
  v_run := public.kf_ingestion_lock_run_internal(p_payload);
  IF v_run.state <> 'PENDING_REVIEW' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'human review decision transition is not allowed';
  END IF;

  v_actor_id := public.kf_ingestion_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_actor_role := public.kf_ingestion_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_reviewer_id := public.kf_ingestion_uuid_internal(p_payload -> 'review' -> 'reviewer' -> 'actorId', 'review.reviewer.actorId');
  v_reviewer_role := public.kf_ingestion_text_internal(p_payload -> 'review' -> 'reviewer' -> 'role', 'review.reviewer.role');
  v_review_id := public.kf_ingestion_uuid_internal(p_payload -> 'review' -> 'reviewId', 'review.reviewId');
  v_decided_at := public.kf_ingestion_timestamp_internal(p_payload -> 'review' -> 'decidedAt', 'review.decidedAt');
  v_review_reason := public.kf_ingestion_text_internal(p_payload -> 'review' -> 'reason', 'review.reason');
  v_command_occurred_at := public.kf_ingestion_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  v_command_reason := public.kf_ingestion_text_internal(p_payload -> 'reason', 'reason');
  v_correlation_id := public.kf_ingestion_uuid_internal(p_payload -> 'correlationId', 'correlationId');

  IF v_actor_role <> 'legal_editorial_reviewer'
    OR v_reviewer_role <> 'legal_editorial_reviewer'
    OR v_actor_id <> v_reviewer_id THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'command actor must be the competent human reviewer';
  END IF;
  IF v_command_occurred_at <> v_decided_at THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'review.decidedAt must equal command occurredAt';
  END IF;
  v_assignment_id := public.kf_ingestion_c25_assignment_internal(
    v_reviewer_id, v_reviewer_role, v_decided_at
  );

  SELECT * INTO v_last_event
  FROM public.kf_ingestion_events
  WHERE run_id = v_run.run_id
  ORDER BY sequence DESC LIMIT 1;
  IF NOT FOUND OR v_last_event.sequence <> v_run.sequence
    OR v_last_event.aggregate_version <> v_run.aggregate_version THEN
    RAISE EXCEPTION USING ERRCODE = '23514', MESSAGE = 'ingestion run projection and history are inconsistent';
  END IF;
  IF v_decided_at < v_last_event.occurred_at THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'human review would regress committed ingestion temporal order';
  END IF;

  IF p_operation = 'approve_for_extraction' THEN
    v_source_version_id := public.kf_ingestion_ref_uuid_internal(
      p_payload -> 'sourceVersion', 'source_version', 'sourceVersion'
    );
    IF v_source_version_id <> v_run.source_version_id THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'approval sourceVersion does not match ingestion run';
    END IF;
    v_artifact_id := public.kf_ingestion_c25_reviewed_artifact_internal(
      v_run.run_id, v_decided_at, true
    );
    v_evidence := (p_payload -> 'authorizationEvidence') -> 0;
    v_authorization_id := public.kf_ingestion_uuid_internal(
      v_evidence -> 'authorizationId', 'authorizationEvidence.authorizationId'
    );
    IF public.kf_ingestion_ref_uuid_internal(
      v_evidence -> 'sourceVersion', 'source_version', 'authorizationEvidence.sourceVersion'
    ) <> v_source_version_id THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'extraction authorization evidence sourceVersion does not match run';
    END IF;
    v_authorization_evaluated_at := public.kf_ingestion_timestamp_internal(
      v_evidence -> 'evaluatedAt', 'authorizationEvidence.evaluatedAt'
    );
    IF v_authorization_evaluated_at <> v_decided_at THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'extraction authorization must be evaluated at the human decision time';
    END IF;
    PERFORM public.kf_ingestion_c25_assert_extraction_authorization_internal(
      v_authorization_id, v_source_version_id, v_authorization_evaluated_at
    );
    v_to_state := 'APPROVED_FOR_EXTRACTION';
    v_event_type := 'ingestion_approved_for_extraction';
    v_decision := 'APPROVE_FOR_EXTRACTION';
    v_reason_code := NULL;
  ELSIF p_operation = 'reject_ingestion' THEN
    v_artifact_id := public.kf_ingestion_c25_reviewed_artifact_internal(
      v_run.run_id, v_decided_at, false
    );
    v_source_version_id := v_run.source_version_id;
    v_to_state := 'REJECTED';
    v_event_type := 'ingestion_rejected';
    v_decision := 'REJECT';
    v_reason_code := 'human_review_rejected';
  ELSE
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'unsupported human review decision';
  END IF;

  v_new_sequence := v_run.sequence + 1;
  UPDATE public.kf_ingestion_runs
  SET state = v_to_state,
      aggregate_version = v_new_version,
      sequence = v_new_sequence,
      updated_at = clock_timestamp()
  WHERE run_id = v_run.run_id;

  INSERT INTO public.kf_ingestion_command_receipts(
    command_id, fingerprint, correlation_id, operation, run_id,
    aggregate_version, sequence, previous_state, state, reason_code
  ) VALUES (
    p_command_id, p_fingerprint, v_correlation_id, p_operation, v_run.run_id,
    v_new_version, v_new_sequence, v_run.state, v_to_state, v_reason_code
  );

  INSERT INTO public.kf_ingestion_events(
    event_id, event_type, run_id, aggregate_version, sequence,
    actor_id, actor_role, reason, occurred_at, correlation_id, command_id,
    from_state, to_state, reason_code,
    review_id, reviewer_assignment_id, reviewer_actor_id, reviewer_actor_role,
    review_decision, review_decided_at, review_reason, reviewed_artifact_id,
    extraction_authorization_id, extraction_authorization_evaluated_at
  ) VALUES (
    v_event_id, v_event_type, v_run.run_id, v_new_version, v_new_sequence,
    v_actor_id, v_actor_role, v_command_reason, v_command_occurred_at,
    v_correlation_id, p_command_id, v_run.state, v_to_state, v_reason_code,
    v_review_id, v_assignment_id, v_reviewer_id, v_reviewer_role,
    v_decision, v_decided_at, v_review_reason, v_artifact_id,
    v_authorization_id, v_authorization_evaluated_at
  );
END;
$function$;

-- ---------------------------------------------------------------------------
-- 6. Read-only persisted handoff evidence. No extraction side effect exists.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_ingestion_handoff_snapshot_internal(p_run_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_run public.kf_ingestion_runs%ROWTYPE;
  v_event public.kf_ingestion_events%ROWTYPE;
  v_receipt public.kf_ingestion_command_receipts%ROWTYPE;
BEGIN
  SELECT * INTO v_run FROM public.kf_ingestion_runs WHERE run_id = p_run_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'ingestion run was not found';
  END IF;
  IF v_run.state <> 'APPROVED_FOR_EXTRACTION' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'ingestion run has no governed extraction handoff';
  END IF;

  SELECT * INTO v_event
  FROM public.kf_ingestion_events
  WHERE run_id = p_run_id
    AND event_type = 'ingestion_approved_for_extraction'
    AND sequence = v_run.sequence
    AND aggregate_version = v_run.aggregate_version;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = '23514', MESSAGE = 'approved ingestion run lacks matching approval evidence';
  END IF;

  SELECT * INTO v_receipt
  FROM public.kf_ingestion_command_receipts
  WHERE command_id = v_event.command_id
    AND run_id = p_run_id
    AND operation = 'approve_for_extraction'
    AND sequence = v_run.sequence
    AND aggregate_version = v_run.aggregate_version;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = '23514', MESSAGE = 'approved ingestion run lacks matching command receipt';
  END IF;

  RETURN jsonb_build_object(
    'contractVersion','1.0.0',
    'run',jsonb_build_object('kind','processing_run','id',v_run.run_id),
    'sourceVersion',jsonb_build_object('kind','source_version','id',v_run.source_version_id),
    'state','APPROVED_FOR_EXTRACTION',
    'aggregateVersion',v_run.aggregate_version,
    'sequence',v_run.sequence,
    'review',jsonb_build_object(
      'reviewId',v_event.review_id,
      'reviewMode','human',
      'reviewer',jsonb_build_object(
        'actorId',v_event.reviewer_actor_id,
        'role',v_event.reviewer_actor_role
      ),
      'decision',v_event.review_decision,
      'decidedAt',v_event.review_decided_at,
      'reason',v_event.review_reason
    ),
    'extractionAuthorization',jsonb_build_object(
      'authorizationId',v_event.extraction_authorization_id,
      'sourceVersion',jsonb_build_object('kind','source_version','id',v_run.source_version_id),
      'purpose','extraction',
      'evaluatedAt',v_event.extraction_authorization_evaluated_at
    ),
    'reviewedArtifactId',v_event.reviewed_artifact_id,
    'decisionCommandId',v_event.command_id,
    'approvalEventId',v_event.event_id,
    'committedAt',v_receipt.committed_at
  );
END;
$function$;

-- ---------------------------------------------------------------------------
-- 7. Narrow SECURITY DEFINER RPC surface
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_ingestion_request_review(
  p_command_id uuid, p_fingerprint text, p_payload jsonb
)
RETURNS TABLE(command_id uuid, fingerprint text, correlation_id uuid, operation text, run_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], previous_state text, state text, replayed boolean, committed_at timestamptz, reason_code text)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_ingestion_c25_precheck_internal('request_review',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_ingestion_request_review_internal(p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_approve_for_extraction(
  p_command_id uuid, p_fingerprint text, p_payload jsonb
)
RETURNS TABLE(command_id uuid, fingerprint text, correlation_id uuid, operation text, run_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], previous_state text, state text, replayed boolean, committed_at timestamptz, reason_code text)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_ingestion_c25_precheck_internal('approve_for_extraction',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_ingestion_human_decision_internal('approve_for_extraction',p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_reject(
  p_command_id uuid, p_fingerprint text, p_payload jsonb
)
RETURNS TABLE(command_id uuid, fingerprint text, correlation_id uuid, operation text, run_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], previous_state text, state text, replayed boolean, committed_at timestamptz, reason_code text)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_ingestion_c25_precheck_internal('reject_ingestion',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_ingestion_human_decision_internal('reject_ingestion',p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_handoff_snapshot(p_run_id uuid)
RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER STABLE SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_ingestion_handoff_snapshot_internal(p_run_id);
END;
$function$;

ALTER FUNCTION public.kf_ingestion_c25_validate_review_internal(jsonb,text) OWNER TO postgres;
ALTER FUNCTION public.kf_ingestion_c25_validate_payload_internal(text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_ingestion_c25_assignment_internal(uuid,text,timestamptz) OWNER TO postgres;
ALTER FUNCTION public.kf_ingestion_c25_assert_extraction_authorization_internal(uuid,uuid,timestamptz) OWNER TO postgres;
ALTER FUNCTION public.kf_ingestion_c25_reviewed_artifact_internal(uuid,timestamptz,boolean) OWNER TO postgres;
ALTER FUNCTION public.kf_ingestion_c25_precheck_internal(text,uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_ingestion_request_review_internal(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_ingestion_human_decision_internal(text,uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_ingestion_handoff_snapshot_internal(uuid) OWNER TO postgres;
ALTER FUNCTION public.kf_ingestion_request_review(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_ingestion_approve_for_extraction(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_ingestion_reject(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_ingestion_handoff_snapshot(uuid) OWNER TO postgres;

REVOKE ALL ON FUNCTION
  public.kf_ingestion_c25_validate_review_internal(jsonb,text),
  public.kf_ingestion_c25_validate_payload_internal(text,jsonb),
  public.kf_ingestion_c25_assignment_internal(uuid,text,timestamptz),
  public.kf_ingestion_c25_assert_extraction_authorization_internal(uuid,uuid,timestamptz),
  public.kf_ingestion_c25_reviewed_artifact_internal(uuid,timestamptz,boolean),
  public.kf_ingestion_c25_precheck_internal(text,uuid,text,jsonb),
  public.kf_ingestion_request_review_internal(uuid,text,jsonb),
  public.kf_ingestion_human_decision_internal(text,uuid,text,jsonb),
  public.kf_ingestion_handoff_snapshot_internal(uuid)
FROM PUBLIC, anon, authenticated, service_role;

REVOKE ALL ON FUNCTION
  public.kf_ingestion_request_review(uuid,text,jsonb),
  public.kf_ingestion_approve_for_extraction(uuid,text,jsonb),
  public.kf_ingestion_reject(uuid,text,jsonb),
  public.kf_ingestion_handoff_snapshot(uuid)
FROM PUBLIC, anon, authenticated, service_role;

GRANT EXECUTE ON FUNCTION
  public.kf_ingestion_request_review(uuid,text,jsonb),
  public.kf_ingestion_approve_for_extraction(uuid,text,jsonb),
  public.kf_ingestion_reject(uuid,text,jsonb),
  public.kf_ingestion_handoff_snapshot(uuid)
TO service_role;

-- Defense in depth remains unchanged: service_role gets no table DML.
REVOKE INSERT, UPDATE, DELETE ON TABLE
  public.kf_source_actor_assignments,
  public.kf_source_authorizations,
  public.kf_source_governance_events,
  public.kf_ingestion_runs,
  public.kf_ingestion_command_receipts,
  public.kf_ingestion_events,
  public.kf_ingestion_staging_artifacts,
  public.kf_ingestion_integrity_evidence
FROM service_role;

COMMIT;