-- =============================================================================
-- ProfePlan Knowledge Factory - Sublote C.3.2
-- Corrections discovered by the disposable C.3.2 proof before integration.
--
-- This migration remains additive and non-production. It replaces only the
-- internal transition function; ownership and grants from the base migration
-- remain unchanged.
-- =============================================================================

BEGIN;

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
BEGIN
  v_run := public.kf_extraction_lock_run_internal(p_payload);
  v_actor_id := public.kf_extraction_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_actor_role := public.kf_extraction_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_at := public.kf_extraction_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  IF v_actor_role <> 'system_worker' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'C.3.2 transition requires system_worker operational competence';
  END IF;
  PERFORM public.kf_extraction_assert_assignment_internal(v_actor_id, v_actor_role, v_at);

  IF p_operation = 'mark_ready' THEN
    IF v_run.state <> 'REQUESTED' THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'mark_ready transition is not allowed';
    END IF;
    v_to_state := 'READY';
    v_event_type := 'extraction_ready';
  ELSIF p_operation = 'begin_extraction' THEN
    IF v_run.state <> 'READY' THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'begin_extraction transition is not allowed';
    END IF;
    v_authorization_id := public.kf_extraction_uuid_internal(
      p_payload -> 'authorizationEvidence' -> 'authorizationId',
      'authorizationEvidence.authorizationId'
    );
    v_authorization_source_version_id := public.kf_extraction_ref_uuid_internal(
      p_payload -> 'authorizationEvidence' -> 'sourceVersion',
      'source_version',
      'authorizationEvidence.sourceVersion'
    );
    IF v_authorization_source_version_id <> v_run.source_version_id THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'claim authorization source version does not match extraction run';
    END IF;
    v_authorization_evaluated_at := public.kf_extraction_timestamp_internal(
      p_payload -> 'authorizationEvidence' -> 'evaluatedAt',
      'authorizationEvidence.evaluatedAt'
    );
    PERFORM public.kf_extraction_assert_current_authorization_internal(
      v_authorization_id, v_run.source_version_id, v_authorization_evaluated_at
    );
    v_to_state := 'EXTRACTING';
    v_event_type := 'extraction_started';
  ELSIF p_operation = 'block_authorization' THEN
    IF NOT (v_run.state = ANY(ARRAY['REQUESTED','READY'])) THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'block_authorization transition is not allowed';
    END IF;
    v_to_state := 'BLOCKED_AUTHORIZATION';
    v_event_type := 'extraction_authorization_blocked';
    v_reason_code := 'authorization_invalid';
  ELSIF p_operation = 'fail_extraction' THEN
    IF NOT (v_run.state = ANY(ARRAY['REQUESTED','READY','EXTRACTING'])) THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'fail_extraction transition is not allowed';
    END IF;
    v_to_state := 'FAILED';
    v_event_type := 'extraction_failed';
    v_reason_code := 'technical_failure';
  ELSIF p_operation = 'cancel_extraction' THEN
    IF NOT (v_run.state = ANY(ARRAY['REQUESTED','READY','EXTRACTING'])) THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'cancel_extraction transition is not allowed';
    END IF;
    v_to_state := 'CANCELLED';
    v_event_type := 'extraction_cancelled';
    v_reason_code := 'operator_cancelled';
  ELSE
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'unsupported C.3.2 transition';
  END IF;

  PERFORM public.kf_extraction_commit_transition_internal(
    p_operation,v_event_type,v_to_state,v_reason_code,
    p_command_id,p_fingerprint,p_payload,v_run,
    v_authorization_id,
    CASE WHEN p_operation = 'begin_extraction' THEN 'claim' ELSE NULL END,
    v_authorization_evaluated_at
  );
END;
$function$;

COMMIT;
