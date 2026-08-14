-- =============================================================================
-- ProfePlan Knowledge Factory - Sublote C.1.3
-- Atomic governed source lifecycle command boundary.
--
-- SECURITY: server-only RPC surface. This migration never grants direct DML
-- to service_role and does not access hosted or production data.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Runtime-authoritative business-role assignments
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_source_actor_assignments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id uuid NOT NULL,
  actor_role text NOT NULL CHECK (
    actor_role IN (
      'curator',
      'legal_editorial_reviewer',
      'system_worker',
      'auditor',
      'technical_admin'
    )
  ),
  effective_from timestamptz NOT NULL,
  effective_until timestamptz,
  created_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_source_actor_assignments_window_check CHECK (
    effective_until IS NULL OR effective_until >= effective_from
  )
);

CREATE INDEX kf_source_actor_assignments_lookup_idx
  ON public.kf_source_actor_assignments (
    actor_id,
    actor_role,
    effective_from,
    effective_until
  );

ALTER TABLE public.kf_source_actor_assignments ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.kf_source_actor_assignments
FROM PUBLIC, anon, authenticated, service_role;

-- ---------------------------------------------------------------------------
-- 2. Closed-schema parsing helpers
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_source_command_assert_object_internal(
  p_value jsonb,
  p_required_keys text[],
  p_allowed_keys text[],
  p_context text
)
RETURNS void
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF p_value IS NULL OR jsonb_typeof(p_value) <> 'object' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must be a JSON object';
  END IF;

  IF NOT (p_value ?& p_required_keys) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' is missing one or more required fields';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM jsonb_object_keys(p_value) AS supplied(key)
    WHERE NOT (supplied.key = ANY(p_allowed_keys))
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' contains an unknown field';
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_command_text_internal(
  p_value jsonb,
  p_context text
)
RETURNS text
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_result text;
BEGIN
  IF p_value IS NULL OR jsonb_typeof(p_value) <> 'string' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must be a JSON string';
  END IF;
  v_result := p_value #>> '{}';
  IF btrim(v_result) = '' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must not be blank';
  END IF;
  RETURN v_result;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_command_uuid_internal(
  p_value jsonb,
  p_context text
)
RETURNS uuid
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_source_command_text_internal(p_value, p_context)::uuid;
EXCEPTION
  WHEN invalid_text_representation THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must be a UUID';
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_command_timestamp_internal(
  p_value jsonb,
  p_context text
)
RETURNS timestamptz
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_source_command_text_internal(p_value, p_context)::timestamptz;
EXCEPTION
  WHEN invalid_datetime_format OR datetime_field_overflow THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must be a valid timestamp with time zone';
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_command_positive_bigint_internal(
  p_value jsonb,
  p_context text
)
RETURNS bigint
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_numeric numeric;
BEGIN
  IF p_value IS NULL OR jsonb_typeof(p_value) <> 'number' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must be a positive integer';
  END IF;
  BEGIN
    v_numeric := (p_value #>> '{}')::numeric;
  EXCEPTION
    WHEN invalid_text_representation OR numeric_value_out_of_range THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must be a positive integer';
  END;
  IF v_numeric <= 0 OR trunc(v_numeric) <> v_numeric OR v_numeric > 9223372036854775807 THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must be a positive integer';
  END IF;
  RETURN v_numeric::bigint;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_command_text_array_internal(
  p_value jsonb,
  p_context text
)
RETURNS text[]
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_result text[];
BEGIN
  IF p_value IS NULL OR jsonb_typeof(p_value) <> 'array' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must be a JSON array';
  END IF;
  IF EXISTS (
    SELECT 1 FROM jsonb_array_elements(p_value) AS item(value)
    WHERE jsonb_typeof(item.value) <> 'string'
  ) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must contain only strings';
  END IF;
  SELECT coalesce(array_agg(item.value #>> '{}' ORDER BY item.ordinality), '{}'::text[])
    INTO v_result
  FROM jsonb_array_elements(p_value) WITH ORDINALITY AS item(value, ordinality);
  IF EXISTS (SELECT 1 FROM unnest(v_result) AS item(value) WHERE btrim(item.value) = '') THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must not contain blank values';
  END IF;
  IF cardinality(v_result) <> (SELECT count(DISTINCT item.value) FROM unnest(v_result) AS item(value)) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must not contain duplicates';
  END IF;
  RETURN v_result;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_command_assert_c13_kind_internal(p_kind text)
RETURNS void
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF NOT (p_kind = ANY(ARRAY[
    'work', 'edition', 'manifestation', 'received_file', 'governed_source', 'source_version'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'source identity kind is outside C.1.3';
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_command_validate_subject_internal(
  p_subject jsonb,
  p_context text
)
RETURNS void
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_kind text;
BEGIN
  PERFORM public.kf_source_command_assert_object_internal(
    p_subject, ARRAY['id', 'kind'], ARRAY['id', 'kind'], p_context
  );
  PERFORM public.kf_source_command_uuid_internal(p_subject -> 'id', p_context || '.id');
  v_kind := public.kf_source_command_text_internal(p_subject -> 'kind', p_context || '.kind');
  PERFORM public.kf_source_command_assert_c13_kind_internal(v_kind);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_command_validate_payload_internal(
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
  v_allowed text[];
  v_actor jsonb;
  v_scope jsonb;
  v_basis jsonb;
  v_role text;
  v_state text;
  v_kind text;
  v_purpose text;
  v_from timestamptz;
  v_until timestamptz;
BEGIN
  CASE p_operation
    WHEN 'register_identity' THEN
      v_required := ARRAY['commandType','actor','subject','occurredAt','effectiveAt','correlationId','reason'];
      v_allowed := v_required;
    WHEN 'request_validation', 'confirm_validation', 'block_source', 'archive_source' THEN
      v_required := ARRAY['commandType','actor','subject','expectedState','expectedVersion','expectedSequence','occurredAt','effectiveAt','correlationId','reason'];
      v_allowed := v_required;
    WHEN 'replace_source' THEN
      v_required := ARRAY['commandType','actor','subject','successor','expectedState','expectedVersion','expectedSequence','occurredAt','effectiveAt','correlationId','reason'];
      v_allowed := v_required;
    WHEN 'grant_authorization' THEN
      v_required := ARRAY['commandType','actor','authorizationId','scope','basis','effectiveFrom','occurredAt','effectiveAt','correlationId','reason'];
      v_allowed := v_required || ARRAY['effectiveUntil'];
    WHEN 'suspend_authorization', 'resume_authorization', 'revoke_authorization', 'block_purpose' THEN
      v_required := ARRAY['commandType','actor','authorizationId','scope','basis','expectedState','expectedVersion','expectedSequence','occurredAt','effectiveAt','correlationId','reason'];
      v_allowed := v_required;
    WHEN 'supersede_authorization' THEN
      v_required := ARRAY['commandType','actor','authorizationId','successorAuthorizationId','scope','basis','effectiveFrom','expectedState','expectedVersion','expectedSequence','occurredAt','effectiveAt','correlationId','reason'];
      v_allowed := v_required || ARRAY['effectiveUntil'];
    WHEN 'open_impact_assessment' THEN
      v_required := ARRAY['commandType','actor','subject','occurredAt','effectiveAt','correlationId','reason'];
      v_allowed := v_required || ARRAY['expectedVersion','expectedSequence','triggeringAuthorizationId'];
    ELSE
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'unsupported source lifecycle operation';
  END CASE;

  PERFORM public.kf_source_command_assert_object_internal(p_payload, v_required, v_allowed, p_operation || ' payload');
  IF public.kf_source_command_text_internal(p_payload -> 'commandType', 'commandType') <> p_operation THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'commandType does not match the RPC operation';
  END IF;

  v_actor := p_payload -> 'actor';
  PERFORM public.kf_source_command_assert_object_internal(v_actor, ARRAY['actorId','role'], ARRAY['actorId','role'], 'actor');
  PERFORM public.kf_source_command_uuid_internal(v_actor -> 'actorId', 'actor.actorId');
  v_role := public.kf_source_command_text_internal(v_actor -> 'role', 'actor.role');
  IF NOT (v_role = ANY(ARRAY['curator','legal_editorial_reviewer','system_worker','auditor','technical_admin'])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'actor.role is unsupported';
  END IF;

  PERFORM public.kf_source_command_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  PERFORM public.kf_source_command_timestamp_internal(p_payload -> 'effectiveAt', 'effectiveAt');
  PERFORM public.kf_source_command_uuid_internal(p_payload -> 'correlationId', 'correlationId');
  PERFORM public.kf_source_command_text_internal(p_payload -> 'reason', 'reason');

  IF p_payload ? 'subject' THEN
    PERFORM public.kf_source_command_validate_subject_internal(p_payload -> 'subject', 'subject');
  END IF;
  IF p_payload ? 'successor' THEN
    PERFORM public.kf_source_command_validate_subject_internal(p_payload -> 'successor', 'successor');
  END IF;

  IF p_payload ? 'expectedVersion' THEN
    PERFORM public.kf_source_command_text_internal(p_payload -> 'expectedVersion', 'expectedVersion');
  END IF;
  IF p_payload ? 'expectedSequence' THEN
    PERFORM public.kf_source_command_positive_bigint_internal(p_payload -> 'expectedSequence', 'expectedSequence');
  END IF;

  IF p_operation = 'open_impact_assessment'
    AND ((p_payload ? 'expectedVersion') <> (p_payload ? 'expectedSequence')) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'impact expectations require both expectedVersion and expectedSequence';
  END IF;

  IF p_payload ? 'expectedState' THEN
    v_state := public.kf_source_command_text_internal(p_payload -> 'expectedState', 'expectedState');
    IF p_operation = ANY(ARRAY['request_validation','confirm_validation','block_source','replace_source','archive_source']) THEN
      IF NOT (v_state = ANY(ARRAY['REGISTERED','PENDING_VALIDATION','VALIDATED','BLOCKED','REPLACED','ARCHIVED'])) THEN
        RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'expectedState is not a registration state';
      END IF;
    ELSE
      IF NOT (v_state = ANY(ARRAY['PENDING_REVIEW','GRANTED','SUSPENDED','REVOKED','EXPIRED','BLOCKED','SUPERSEDED'])) THEN
        RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'expectedState is not an authorization state';
      END IF;
    END IF;
  END IF;

  IF p_payload ? 'authorizationId' THEN
    PERFORM public.kf_source_command_uuid_internal(p_payload -> 'authorizationId', 'authorizationId');
  END IF;
  IF p_payload ? 'successorAuthorizationId' THEN
    PERFORM public.kf_source_command_uuid_internal(p_payload -> 'successorAuthorizationId', 'successorAuthorizationId');
  END IF;
  IF p_payload ? 'triggeringAuthorizationId' THEN
    PERFORM public.kf_source_command_uuid_internal(p_payload -> 'triggeringAuthorizationId', 'triggeringAuthorizationId');
  END IF;

  IF p_payload ? 'scope' THEN
    v_scope := p_payload -> 'scope';
    PERFORM public.kf_source_command_assert_object_internal(
      v_scope, ARRAY['subject','purpose'], ARRAY['subject','purpose','restrictions'], 'scope'
    );
    PERFORM public.kf_source_command_validate_subject_internal(v_scope -> 'subject', 'scope.subject');
    v_purpose := public.kf_source_command_text_internal(v_scope -> 'purpose', 'scope.purpose');
    IF NOT (v_purpose = ANY(ARRAY[
      'temporary_staging','ingestion','extraction','analysis_classification','distillation',
      'quotation','indexing_embedding','retrieval','evidence','generation'
    ])) THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'scope.purpose is unsupported';
    END IF;
    IF v_scope ? 'restrictions' THEN
      PERFORM public.kf_source_command_text_array_internal(v_scope -> 'restrictions', 'scope.restrictions');
    END IF;
  END IF;

  IF p_payload ? 'basis' THEN
    v_basis := p_payload -> 'basis';
    PERFORM public.kf_source_command_assert_object_internal(
      v_basis, ARRAY['id','kind'], ARRAY['id','kind','referenceDigest'], 'basis'
    );
    PERFORM public.kf_source_command_uuid_internal(v_basis -> 'id', 'basis.id');
    v_kind := public.kf_source_command_text_internal(v_basis -> 'kind', 'basis.kind');
    IF NOT (v_kind = ANY(ARRAY[
      'wrtech_ownership','publisher_contract','open_license','express_authorization',
      'legal_norm','other_approved'
    ])) THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'basis.kind is unsupported';
    END IF;
    IF v_basis ? 'referenceDigest' THEN
      PERFORM public.kf_source_command_text_internal(v_basis -> 'referenceDigest', 'basis.referenceDigest');
    END IF;
  END IF;

  IF p_payload ? 'effectiveFrom' THEN
    v_from := public.kf_source_command_timestamp_internal(p_payload -> 'effectiveFrom', 'effectiveFrom');
    IF p_payload ? 'effectiveUntil' THEN
      v_until := public.kf_source_command_timestamp_internal(p_payload -> 'effectiveUntil', 'effectiveUntil');
      IF v_until < v_from THEN
        RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'effectiveUntil must not precede effectiveFrom';
      END IF;
    END IF;
  END IF;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 3. Fingerprint, competence, replay and result helpers
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_source_command_fingerprint_internal(
  p_operation text,
  p_payload jsonb
)
RETURNS text
LANGUAGE sql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT encode(
    sha256(
      convert_to(
        jsonb_build_object(
          'fingerprintVersion', 1,
          'operation', p_operation,
          'payload', p_payload
        )::text,
        'UTF8'
      )
    ),
    'hex'
  )
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_command_actor_allowed_internal(
  p_operation text,
  p_role text
)
RETURNS boolean
LANGUAGE sql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT CASE
    WHEN p_operation = ANY(ARRAY[
      'register_identity','request_validation','confirm_validation','block_source',
      'replace_source','archive_source'
    ]) THEN p_role = 'curator'
    WHEN p_operation = ANY(ARRAY[
      'grant_authorization','suspend_authorization','resume_authorization',
      'revoke_authorization','block_purpose','supersede_authorization'
    ]) THEN p_role = 'legal_editorial_reviewer'
    WHEN p_operation = 'open_impact_assessment' THEN p_role = ANY(ARRAY['curator','legal_editorial_reviewer'])
    ELSE false
  END
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_command_assert_assignment_internal(
  p_actor_id uuid,
  p_role text,
  p_occurred_at timestamptz
)
RETURNS void
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM public.kf_source_actor_assignments AS assignments
    WHERE assignments.actor_id = p_actor_id
      AND assignments.actor_role = p_role
      AND p_occurred_at >= assignments.effective_from
      AND (assignments.effective_until IS NULL OR p_occurred_at <= assignments.effective_until)
  ) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'actor is not competent for this decision time';
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_command_precheck_internal(
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
  v_actor_id uuid;
  v_role text;
  v_occurred_at timestamptz;
BEGIN
  IF p_command_id IS NULL THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'commandId is required';
  END IF;
  IF p_fingerprint IS NULL OR p_fingerprint !~ '^[0-9a-f]{64}$' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'fingerprint must be lowercase SHA-256 hex';
  END IF;

  PERFORM public.kf_source_command_validate_payload_internal(p_operation, p_payload);
  v_calculated := public.kf_source_command_fingerprint_internal(p_operation, p_payload);
  IF v_calculated <> p_fingerprint THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'fingerprint does not match canonical command payload';
  END IF;

  PERFORM pg_advisory_xact_lock(hashtextextended('command:' || p_command_id::text, 0));

  SELECT receipts.operation, receipts.fingerprint
    INTO v_existing_operation, v_existing_fingerprint
  FROM public.kf_source_command_receipts AS receipts
  WHERE receipts.command_id = p_command_id;

  IF FOUND THEN
    IF v_existing_operation <> p_operation OR v_existing_fingerprint <> v_calculated THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'commandId was already used with a different command';
    END IF;
    RETURN true;
  END IF;

  v_actor_id := public.kf_source_command_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_role := public.kf_source_command_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_occurred_at := public.kf_source_command_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');

  IF NOT public.kf_source_command_actor_allowed_internal(p_operation, v_role) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'actor role is not permitted for this command';
  END IF;
  PERFORM public.kf_source_command_assert_assignment_internal(v_actor_id, v_role, v_occurred_at);
  RETURN false;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_command_receipt_result_internal(
  p_command_id uuid,
  p_replayed boolean
)
RETURNS TABLE (
  dimension text,
  command_id uuid,
  fingerprint text,
  operation text,
  aggregate_id uuid,
  aggregate_version text,
  sequence bigint,
  event_ids uuid[],
  state text,
  replayed boolean,
  committed_at timestamptz
)
LANGUAGE sql
STABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT
    receipts.dimension,
    receipts.command_id,
    receipts.fingerprint,
    receipts.operation,
    receipts.aggregate_id,
    receipts.aggregate_version,
    receipts.sequence,
    coalesce(array_agg(rel.event_id ORDER BY rel.event_order) FILTER (WHERE rel.event_id IS NOT NULL), '{}'::uuid[]),
    coalesce(receipts.registration_state, receipts.authorization_state),
    p_replayed,
    receipts.committed_at
  FROM public.kf_source_command_receipts AS receipts
  LEFT JOIN public.kf_source_command_receipt_events AS rel
    ON rel.command_id = receipts.command_id
  WHERE receipts.command_id = p_command_id
  GROUP BY receipts.command_id
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_command_assert_subject_internal(
  p_subject jsonb
)
RETURNS uuid
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_id uuid;
  v_expected_kind text;
  v_actual_kind text;
BEGIN
  v_id := public.kf_source_command_uuid_internal(p_subject -> 'id', 'subject.id');
  v_expected_kind := public.kf_source_command_text_internal(p_subject -> 'kind', 'subject.kind');
  PERFORM public.kf_source_command_assert_c13_kind_internal(v_expected_kind);
  SELECT identities.kind INTO v_actual_kind
  FROM public.kf_source_identities AS identities
  WHERE identities.id = v_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'source identity was not found';
  END IF;
  IF v_actual_kind <> v_expected_kind THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'source identity kind does not match persisted identity';
  END IF;
  RETURN v_id;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 4. Conservative impact helper for restrictive commands
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_source_command_append_impact_internal(
  p_command_id uuid,
  p_event_order integer,
  p_subject_id uuid,
  p_triggering_authorization_id uuid,
  p_actor_id uuid,
  p_actor_role text,
  p_reason text,
  p_occurred_at timestamptz,
  p_effective_at timestamptz,
  p_correlation_id uuid
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_last_sequence bigint;
  v_last_occurred_at timestamptz;
  v_last_effective_at timestamptz;
  v_sequence bigint;
  v_version text := gen_random_uuid()::text;
  v_event_id uuid := gen_random_uuid();
BEGIN
  PERFORM pg_advisory_xact_lock(hashtextextended('impact:' || p_subject_id::text, 0));

  IF p_triggering_authorization_id IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM public.kf_source_authorizations AS authorizations
    WHERE authorizations.id = p_triggering_authorization_id
      AND authorizations.subject_identity_id = p_subject_id
  ) THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'triggering authorization was not found for subject';
  END IF;

  SELECT events.sequence, events.occurred_at, events.effective_at
    INTO v_last_sequence, v_last_occurred_at, v_last_effective_at
  FROM public.kf_source_governance_events AS events
  WHERE events.dimension = 'impact' AND events.aggregate_id = p_subject_id
  ORDER BY events.sequence DESC
  LIMIT 1;

  IF FOUND THEN
    IF p_occurred_at < v_last_occurred_at OR p_effective_at < v_last_effective_at THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'impact event would regress committed temporal order';
    END IF;
    v_sequence := v_last_sequence + 1;
  ELSE
    v_sequence := 1;
  END IF;

  INSERT INTO public.kf_source_governance_events (
    event_id, dimension, aggregate_id, aggregate_version, sequence, event_type,
    subject_identity_id, actor_id, actor_role, reason, occurred_at, effective_at,
    correlation_id, command_id, triggering_authorization_id
  ) VALUES (
    v_event_id, 'impact', p_subject_id, v_version, v_sequence,
    'source_impact_assessment_opened', p_subject_id, p_actor_id, p_actor_role,
    p_reason, p_occurred_at, p_effective_at, p_correlation_id, p_command_id,
    p_triggering_authorization_id
  );

  INSERT INTO public.kf_source_command_receipt_events(command_id, event_id, event_order)
  VALUES (p_command_id, v_event_id, p_event_order);
END;
$function$;

-- ---------------------------------------------------------------------------
-- 5. Registration command internals
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_source_register_identity_internal(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_subject jsonb := p_payload -> 'subject';
  v_subject_id uuid;
  v_kind text;
  v_actor_id uuid;
  v_actor_role text;
  v_reason text;
  v_occurred_at timestamptz;
  v_effective_at timestamptz;
  v_correlation_id uuid;
  v_version text := gen_random_uuid()::text;
  v_event_id uuid := gen_random_uuid();
BEGIN
  v_subject_id := public.kf_source_command_uuid_internal(v_subject -> 'id', 'subject.id');
  v_kind := public.kf_source_command_text_internal(v_subject -> 'kind', 'subject.kind');
  PERFORM public.kf_source_command_assert_c13_kind_internal(v_kind);
  v_actor_id := public.kf_source_command_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_actor_role := public.kf_source_command_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_reason := public.kf_source_command_text_internal(p_payload -> 'reason', 'reason');
  v_occurred_at := public.kf_source_command_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  v_effective_at := public.kf_source_command_timestamp_internal(p_payload -> 'effectiveAt', 'effectiveAt');
  v_correlation_id := public.kf_source_command_uuid_internal(p_payload -> 'correlationId', 'correlationId');

  PERFORM pg_advisory_xact_lock(hashtextextended('registration:' || v_subject_id::text, 0));
  IF EXISTS (SELECT 1 FROM public.kf_source_identities WHERE id = v_subject_id)
    OR EXISTS (SELECT 1 FROM public.kf_source_registration_projections WHERE subject_identity_id = v_subject_id) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'source identity already exists';
  END IF;

  INSERT INTO public.kf_source_identities(id, kind) VALUES (v_subject_id, v_kind);
  INSERT INTO public.kf_source_registration_projections(
    subject_identity_id, projected_state, aggregate_version, sequence
  ) VALUES (v_subject_id, 'REGISTERED', v_version, 1);

  INSERT INTO public.kf_source_command_receipts(
    command_id, fingerprint, dimension, operation, aggregate_id,
    subject_identity_id, aggregate_version, sequence, registration_state
  ) VALUES (
    p_command_id, p_fingerprint, 'registration', 'register_identity', v_subject_id,
    v_subject_id, v_version, 1, 'REGISTERED'
  );

  INSERT INTO public.kf_source_governance_events(
    event_id, dimension, aggregate_id, aggregate_version, sequence, event_type,
    subject_identity_id, actor_id, actor_role, reason, occurred_at, effective_at,
    correlation_id, command_id, registration_to_state
  ) VALUES (
    v_event_id, 'registration', v_subject_id, v_version, 1, 'source_registered',
    v_subject_id, v_actor_id, v_actor_role, v_reason, v_occurred_at,
    v_effective_at, v_correlation_id, p_command_id, 'REGISTERED'
  );

  INSERT INTO public.kf_source_command_receipt_events(command_id, event_id, event_order)
  VALUES (p_command_id, v_event_id, 1);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_registration_transition_internal(
  p_operation text,
  p_event_type text,
  p_to_state text,
  p_allowed_from text[],
  p_open_impact boolean,
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_subject jsonb := p_payload -> 'subject';
  v_subject_id uuid;
  v_subject_kind text;
  v_current_state text;
  v_current_version text;
  v_current_sequence bigint;
  v_expected_state text;
  v_expected_version text;
  v_expected_sequence bigint;
  v_history_sequence bigint;
  v_history_occurred_at timestamptz;
  v_history_effective_at timestamptz;
  v_successor_id uuid;
  v_successor_kind text;
  v_new_version text := gen_random_uuid()::text;
  v_new_sequence bigint;
  v_event_id uuid := gen_random_uuid();
  v_actor_id uuid;
  v_actor_role text;
  v_reason text;
  v_occurred_at timestamptz;
  v_effective_at timestamptz;
  v_correlation_id uuid;
BEGIN
  v_subject_id := public.kf_source_command_uuid_internal(v_subject -> 'id', 'subject.id');
  v_subject_kind := public.kf_source_command_text_internal(v_subject -> 'kind', 'subject.kind');
  v_expected_state := public.kf_source_command_text_internal(p_payload -> 'expectedState', 'expectedState');
  v_expected_version := public.kf_source_command_text_internal(p_payload -> 'expectedVersion', 'expectedVersion');
  v_expected_sequence := public.kf_source_command_positive_bigint_internal(p_payload -> 'expectedSequence', 'expectedSequence');
  v_actor_id := public.kf_source_command_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_actor_role := public.kf_source_command_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_reason := public.kf_source_command_text_internal(p_payload -> 'reason', 'reason');
  v_occurred_at := public.kf_source_command_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  v_effective_at := public.kf_source_command_timestamp_internal(p_payload -> 'effectiveAt', 'effectiveAt');
  v_correlation_id := public.kf_source_command_uuid_internal(p_payload -> 'correlationId', 'correlationId');

  SELECT identities.kind, projections.projected_state, projections.aggregate_version, projections.sequence
    INTO v_subject_kind, v_current_state, v_current_version, v_current_sequence
  FROM public.kf_source_registration_projections AS projections
  JOIN public.kf_source_identities AS identities ON identities.id = projections.subject_identity_id
  WHERE projections.subject_identity_id = v_subject_id
  FOR UPDATE OF projections;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'source registration aggregate was not found';
  END IF;
  IF v_subject_kind <> public.kf_source_command_text_internal(v_subject -> 'kind', 'subject.kind') THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'source identity kind does not match persisted identity';
  END IF;
  PERFORM public.kf_source_command_assert_c13_kind_internal(v_subject_kind);

  IF v_current_state <> v_expected_state
    OR v_current_version <> v_expected_version
    OR v_current_sequence <> v_expected_sequence THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'source registration state does not match command expectations';
  END IF;
  IF NOT (v_current_state = ANY(p_allowed_from)) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'source registration transition is not allowed';
  END IF;

  SELECT events.sequence, events.occurred_at, events.effective_at
    INTO v_history_sequence, v_history_occurred_at, v_history_effective_at
  FROM public.kf_source_governance_events AS events
  WHERE events.dimension = 'registration' AND events.aggregate_id = v_subject_id
  ORDER BY events.sequence DESC LIMIT 1;
  IF NOT FOUND OR v_history_sequence <> v_current_sequence THEN
    RAISE EXCEPTION USING ERRCODE = '23514', MESSAGE = 'registration projection and history are inconsistent';
  END IF;
  IF v_occurred_at < v_history_occurred_at OR v_effective_at < v_history_effective_at THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'registration transition would regress committed temporal order';
  END IF;

  IF p_operation = 'replace_source' THEN
    v_successor_id := public.kf_source_command_uuid_internal(p_payload -> 'successor' -> 'id', 'successor.id');
    IF v_successor_id = v_subject_id THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'successor must differ from predecessor';
    END IF;
    SELECT identities.kind INTO v_successor_kind FROM public.kf_source_identities AS identities
    WHERE identities.id = v_successor_id;
    IF NOT FOUND THEN
      RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'successor source identity was not found';
    END IF;
    IF v_successor_kind <> public.kf_source_command_text_internal(p_payload -> 'successor' -> 'kind', 'successor.kind')
      OR v_successor_kind <> v_subject_kind THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'successor source identity is not compatible';
    END IF;
  END IF;

  v_new_sequence := v_current_sequence + 1;
  UPDATE public.kf_source_registration_projections
  SET projected_state = p_to_state,
      aggregate_version = v_new_version,
      sequence = v_new_sequence,
      successor_identity_id = CASE WHEN p_to_state = 'REPLACED' THEN v_successor_id ELSE NULL END,
      updated_at = clock_timestamp()
  WHERE subject_identity_id = v_subject_id;

  INSERT INTO public.kf_source_command_receipts(
    command_id, fingerprint, dimension, operation, aggregate_id,
    subject_identity_id, aggregate_version, sequence, registration_state
  ) VALUES (
    p_command_id, p_fingerprint, 'registration', p_operation, v_subject_id,
    v_subject_id, v_new_version, v_new_sequence, p_to_state
  );

  INSERT INTO public.kf_source_governance_events(
    event_id, dimension, aggregate_id, aggregate_version, sequence, event_type,
    subject_identity_id, actor_id, actor_role, reason, occurred_at, effective_at,
    correlation_id, command_id, registration_from_state, registration_to_state,
    successor_identity_id
  ) VALUES (
    v_event_id, 'registration', v_subject_id, v_new_version, v_new_sequence,
    p_event_type, v_subject_id, v_actor_id, v_actor_role, v_reason, v_occurred_at,
    v_effective_at, v_correlation_id, p_command_id, v_current_state, p_to_state,
    v_successor_id
  );
  INSERT INTO public.kf_source_command_receipt_events(command_id, event_id, event_order)
  VALUES (p_command_id, v_event_id, 1);

  IF p_open_impact THEN
    PERFORM public.kf_source_command_append_impact_internal(
      p_command_id, 2, v_subject_id, NULL, v_actor_id, v_actor_role, v_reason,
      v_occurred_at, v_effective_at, v_correlation_id
    );
  END IF;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 6. Authorization command internals
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_source_command_resolve_basis_internal(
  p_basis jsonb,
  p_allow_create boolean
)
RETURNS uuid
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_id uuid;
  v_kind text;
  v_digest text;
  v_existing_kind text;
  v_existing_digest text;
BEGIN
  v_id := public.kf_source_command_uuid_internal(p_basis -> 'id', 'basis.id');
  v_kind := public.kf_source_command_text_internal(p_basis -> 'kind', 'basis.kind');
  v_digest := CASE WHEN p_basis ? 'referenceDigest'
    THEN public.kf_source_command_text_internal(p_basis -> 'referenceDigest', 'basis.referenceDigest')
    ELSE NULL END;

  PERFORM pg_advisory_xact_lock(hashtextextended('basis:' || v_id::text, 0));
  SELECT bases.kind, bases.reference_digest INTO v_existing_kind, v_existing_digest
  FROM public.kf_source_authorization_bases AS bases WHERE bases.id = v_id;
  IF FOUND THEN
    IF v_existing_kind <> v_kind OR v_existing_digest IS DISTINCT FROM v_digest THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'authorization basis conflicts with persisted immutable basis';
    END IF;
    RETURN v_id;
  END IF;

  IF NOT p_allow_create THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'authorization basis was not found';
  END IF;
  INSERT INTO public.kf_source_authorization_bases(id, kind, reference_digest)
  VALUES (v_id, v_kind, v_digest);
  RETURN v_id;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_grant_authorization_internal(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_authorization_id uuid;
  v_scope jsonb := p_payload -> 'scope';
  v_subject_id uuid;
  v_subject_kind text;
  v_registration_state text;
  v_purpose text;
  v_restrictions text[];
  v_basis_id uuid;
  v_effective_from timestamptz;
  v_effective_until timestamptz;
  v_actor_id uuid;
  v_actor_role text;
  v_reason text;
  v_occurred_at timestamptz;
  v_effective_at timestamptz;
  v_correlation_id uuid;
  v_version text := gen_random_uuid()::text;
  v_event_id uuid := gen_random_uuid();
BEGIN
  v_authorization_id := public.kf_source_command_uuid_internal(p_payload -> 'authorizationId', 'authorizationId');
  v_subject_id := public.kf_source_command_uuid_internal(v_scope -> 'subject' -> 'id', 'scope.subject.id');
  v_subject_kind := public.kf_source_command_text_internal(v_scope -> 'subject' -> 'kind', 'scope.subject.kind');
  v_purpose := public.kf_source_command_text_internal(v_scope -> 'purpose', 'scope.purpose');
  v_restrictions := CASE WHEN v_scope ? 'restrictions'
    THEN public.kf_source_command_text_array_internal(v_scope -> 'restrictions', 'scope.restrictions')
    ELSE '{}'::text[] END;
  v_effective_from := public.kf_source_command_timestamp_internal(p_payload -> 'effectiveFrom', 'effectiveFrom');
  v_effective_until := CASE WHEN p_payload ? 'effectiveUntil'
    THEN public.kf_source_command_timestamp_internal(p_payload -> 'effectiveUntil', 'effectiveUntil') ELSE NULL END;
  v_actor_id := public.kf_source_command_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_actor_role := public.kf_source_command_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_reason := public.kf_source_command_text_internal(p_payload -> 'reason', 'reason');
  v_occurred_at := public.kf_source_command_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  v_effective_at := public.kf_source_command_timestamp_internal(p_payload -> 'effectiveAt', 'effectiveAt');
  v_correlation_id := public.kf_source_command_uuid_internal(p_payload -> 'correlationId', 'correlationId');

  PERFORM pg_advisory_xact_lock(hashtextextended('authorization:' || v_authorization_id::text, 0));
  IF EXISTS (SELECT 1 FROM public.kf_source_authorizations WHERE id = v_authorization_id) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'authorization already exists';
  END IF;

  SELECT identities.kind, projections.projected_state
    INTO v_subject_kind, v_registration_state
  FROM public.kf_source_registration_projections AS projections
  JOIN public.kf_source_identities AS identities ON identities.id = projections.subject_identity_id
  WHERE projections.subject_identity_id = v_subject_id
  FOR UPDATE OF projections;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'authorization subject was not found';
  END IF;
  IF v_subject_kind <> public.kf_source_command_text_internal(v_scope -> 'subject' -> 'kind', 'scope.subject.kind') THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'authorization subject kind does not match persisted identity';
  END IF;
  PERFORM public.kf_source_command_assert_c13_kind_internal(v_subject_kind);
  IF v_registration_state <> 'VALIDATED' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'authorization subject is not registrally VALIDATED';
  END IF;

  v_basis_id := public.kf_source_command_resolve_basis_internal(p_payload -> 'basis', true);

  INSERT INTO public.kf_source_authorizations(
    id, subject_identity_id, purpose, restrictions, basis_id,
    effective_from, effective_until, projected_state, aggregate_version, sequence
  ) VALUES (
    v_authorization_id, v_subject_id, v_purpose, v_restrictions, v_basis_id,
    v_effective_from, v_effective_until, 'GRANTED', v_version, 1
  );

  INSERT INTO public.kf_source_command_receipts(
    command_id, fingerprint, dimension, operation, aggregate_id,
    authorization_id, aggregate_version, sequence, authorization_state
  ) VALUES (
    p_command_id, p_fingerprint, 'authorization', 'grant_authorization',
    v_authorization_id, v_authorization_id, v_version, 1, 'GRANTED'
  );

  INSERT INTO public.kf_source_governance_events(
    event_id, dimension, aggregate_id, aggregate_version, sequence, event_type,
    subject_identity_id, authorization_id, purpose, restrictions, basis_id,
    actor_id, actor_role, reason, occurred_at, effective_at, correlation_id,
    command_id, authorization_to_state, effective_from, effective_until
  ) VALUES (
    v_event_id, 'authorization', v_authorization_id, v_version, 1,
    'authorization_granted', v_subject_id, v_authorization_id, v_purpose,
    v_restrictions, v_basis_id, v_actor_id, v_actor_role, v_reason,
    v_occurred_at, v_effective_at, v_correlation_id, p_command_id,
    'GRANTED', v_effective_from, v_effective_until
  );
  INSERT INTO public.kf_source_command_receipt_events(command_id, event_id, event_order)
  VALUES (p_command_id, v_event_id, 1);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_authorization_transition_internal(
  p_operation text,
  p_event_type text,
  p_to_state text,
  p_allowed_from text[],
  p_open_impact boolean,
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_authorization_id uuid;
  v_scope jsonb := p_payload -> 'scope';
  v_basis jsonb := p_payload -> 'basis';
  v_subject_id uuid;
  v_subject_kind text;
  v_purpose text;
  v_restrictions text[];
  v_basis_id uuid;
  v_basis_kind text;
  v_basis_digest text;
  v_effective_from timestamptz;
  v_effective_until timestamptz;
  v_current_state text;
  v_current_version text;
  v_current_sequence bigint;
  v_expected_state text;
  v_expected_version text;
  v_expected_sequence bigint;
  v_history_sequence bigint;
  v_history_occurred_at timestamptz;
  v_history_effective_at timestamptz;
  v_new_version text := gen_random_uuid()::text;
  v_new_sequence bigint;
  v_event_id uuid := gen_random_uuid();
  v_actor_id uuid;
  v_actor_role text;
  v_reason text;
  v_occurred_at timestamptz;
  v_effective_at timestamptz;
  v_correlation_id uuid;
BEGIN
  v_authorization_id := public.kf_source_command_uuid_internal(p_payload -> 'authorizationId', 'authorizationId');
  v_expected_state := public.kf_source_command_text_internal(p_payload -> 'expectedState', 'expectedState');
  v_expected_version := public.kf_source_command_text_internal(p_payload -> 'expectedVersion', 'expectedVersion');
  v_expected_sequence := public.kf_source_command_positive_bigint_internal(p_payload -> 'expectedSequence', 'expectedSequence');
  v_actor_id := public.kf_source_command_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_actor_role := public.kf_source_command_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_reason := public.kf_source_command_text_internal(p_payload -> 'reason', 'reason');
  v_occurred_at := public.kf_source_command_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  v_effective_at := public.kf_source_command_timestamp_internal(p_payload -> 'effectiveAt', 'effectiveAt');
  v_correlation_id := public.kf_source_command_uuid_internal(p_payload -> 'correlationId', 'correlationId');

  SELECT authorizations.subject_identity_id, identities.kind, authorizations.purpose,
         authorizations.restrictions, authorizations.basis_id, bases.kind,
         bases.reference_digest, authorizations.effective_from,
         authorizations.effective_until, authorizations.projected_state,
         authorizations.aggregate_version, authorizations.sequence
    INTO v_subject_id, v_subject_kind, v_purpose, v_restrictions, v_basis_id,
         v_basis_kind, v_basis_digest, v_effective_from, v_effective_until,
         v_current_state, v_current_version, v_current_sequence
  FROM public.kf_source_authorizations AS authorizations
  JOIN public.kf_source_identities AS identities ON identities.id = authorizations.subject_identity_id
  JOIN public.kf_source_authorization_bases AS bases ON bases.id = authorizations.basis_id
  WHERE authorizations.id = v_authorization_id
  FOR UPDATE OF authorizations;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'authorization was not found';
  END IF;

  IF v_current_state <> v_expected_state OR v_current_version <> v_expected_version
    OR v_current_sequence <> v_expected_sequence THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'authorization state does not match command expectations';
  END IF;
  IF NOT (v_current_state = ANY(p_allowed_from)) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'authorization transition is not allowed';
  END IF;

  IF public.kf_source_command_uuid_internal(v_scope -> 'subject' -> 'id', 'scope.subject.id') <> v_subject_id
    OR public.kf_source_command_text_internal(v_scope -> 'subject' -> 'kind', 'scope.subject.kind') <> v_subject_kind
    OR public.kf_source_command_text_internal(v_scope -> 'purpose', 'scope.purpose') <> v_purpose
    OR (CASE WHEN v_scope ? 'restrictions'
        THEN public.kf_source_command_text_array_internal(v_scope -> 'restrictions', 'scope.restrictions')
        ELSE '{}'::text[] END) <> v_restrictions THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'authorization scope does not match immutable persisted scope';
  END IF;

  IF public.kf_source_command_uuid_internal(v_basis -> 'id', 'basis.id') <> v_basis_id
    OR public.kf_source_command_text_internal(v_basis -> 'kind', 'basis.kind') <> v_basis_kind
    OR (CASE WHEN v_basis ? 'referenceDigest'
        THEN public.kf_source_command_text_internal(v_basis -> 'referenceDigest', 'basis.referenceDigest')
        ELSE NULL END) IS DISTINCT FROM v_basis_digest THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'authorization basis does not match immutable persisted basis';
  END IF;

  SELECT events.sequence, events.occurred_at, events.effective_at
    INTO v_history_sequence, v_history_occurred_at, v_history_effective_at
  FROM public.kf_source_governance_events AS events
  WHERE events.dimension = 'authorization' AND events.aggregate_id = v_authorization_id
  ORDER BY events.sequence DESC LIMIT 1;
  IF NOT FOUND OR v_history_sequence <> v_current_sequence THEN
    RAISE EXCEPTION USING ERRCODE = '23514', MESSAGE = 'authorization projection and history are inconsistent';
  END IF;
  IF v_occurred_at < v_history_occurred_at OR v_effective_at < v_history_effective_at THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'authorization transition would regress committed temporal order';
  END IF;

  v_new_sequence := v_current_sequence + 1;
  UPDATE public.kf_source_authorizations
  SET projected_state = p_to_state,
      aggregate_version = v_new_version,
      sequence = v_new_sequence,
      superseded_by_authorization_id = NULL,
      updated_at = clock_timestamp()
  WHERE id = v_authorization_id;

  INSERT INTO public.kf_source_command_receipts(
    command_id, fingerprint, dimension, operation, aggregate_id,
    authorization_id, aggregate_version, sequence, authorization_state
  ) VALUES (
    p_command_id, p_fingerprint, 'authorization', p_operation,
    v_authorization_id, v_authorization_id, v_new_version, v_new_sequence, p_to_state
  );

  INSERT INTO public.kf_source_governance_events(
    event_id, dimension, aggregate_id, aggregate_version, sequence, event_type,
    subject_identity_id, authorization_id, purpose, restrictions, basis_id,
    actor_id, actor_role, reason, occurred_at, effective_at, correlation_id,
    command_id, authorization_from_state, authorization_to_state,
    effective_from, effective_until
  ) VALUES (
    v_event_id, 'authorization', v_authorization_id, v_new_version, v_new_sequence,
    p_event_type, v_subject_id, v_authorization_id, v_purpose, v_restrictions,
    v_basis_id, v_actor_id, v_actor_role, v_reason, v_occurred_at,
    v_effective_at, v_correlation_id, p_command_id, v_current_state, p_to_state,
    v_effective_from, v_effective_until
  );
  INSERT INTO public.kf_source_command_receipt_events(command_id, event_id, event_order)
  VALUES (p_command_id, v_event_id, 1);

  IF p_open_impact THEN
    PERFORM public.kf_source_command_append_impact_internal(
      p_command_id, 2, v_subject_id, v_authorization_id, v_actor_id,
      v_actor_role, v_reason, v_occurred_at, v_effective_at, v_correlation_id
    );
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_supersede_authorization_internal(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_predecessor_id uuid;
  v_successor_id uuid;
  v_scope jsonb := p_payload -> 'scope';
  v_pre_subject_id uuid;
  v_subject_id uuid;
  v_subject_kind text;
  v_registration_state text;
  v_pre_purpose text;
  v_pre_restrictions text[];
  v_pre_basis_id uuid;
  v_pre_effective_from timestamptz;
  v_pre_effective_until timestamptz;
  v_current_state text;
  v_current_version text;
  v_current_sequence bigint;
  v_expected_state text;
  v_expected_version text;
  v_expected_sequence bigint;
  v_history_sequence bigint;
  v_history_occurred_at timestamptz;
  v_history_effective_at timestamptz;
  v_successor_purpose text;
  v_successor_restrictions text[];
  v_successor_basis_id uuid;
  v_successor_effective_from timestamptz;
  v_successor_effective_until timestamptz;
  v_pre_new_version text := gen_random_uuid()::text;
  v_pre_new_sequence bigint;
  v_successor_version text := gen_random_uuid()::text;
  v_pre_event_id uuid := gen_random_uuid();
  v_successor_event_id uuid := gen_random_uuid();
  v_actor_id uuid;
  v_actor_role text;
  v_reason text;
  v_occurred_at timestamptz;
  v_effective_at timestamptz;
  v_correlation_id uuid;
BEGIN
  v_predecessor_id := public.kf_source_command_uuid_internal(p_payload -> 'authorizationId', 'authorizationId');
  v_successor_id := public.kf_source_command_uuid_internal(p_payload -> 'successorAuthorizationId', 'successorAuthorizationId');
  IF v_predecessor_id = v_successor_id THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'successor authorization must differ from predecessor';
  END IF;

  IF v_predecessor_id::text < v_successor_id::text THEN
    PERFORM pg_advisory_xact_lock(hashtextextended('authorization:' || v_predecessor_id::text, 0));
    PERFORM pg_advisory_xact_lock(hashtextextended('authorization:' || v_successor_id::text, 0));
  ELSE
    PERFORM pg_advisory_xact_lock(hashtextextended('authorization:' || v_successor_id::text, 0));
    PERFORM pg_advisory_xact_lock(hashtextextended('authorization:' || v_predecessor_id::text, 0));
  END IF;

  v_expected_state := public.kf_source_command_text_internal(p_payload -> 'expectedState', 'expectedState');
  v_expected_version := public.kf_source_command_text_internal(p_payload -> 'expectedVersion', 'expectedVersion');
  v_expected_sequence := public.kf_source_command_positive_bigint_internal(p_payload -> 'expectedSequence', 'expectedSequence');
  v_actor_id := public.kf_source_command_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_actor_role := public.kf_source_command_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_reason := public.kf_source_command_text_internal(p_payload -> 'reason', 'reason');
  v_occurred_at := public.kf_source_command_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  v_effective_at := public.kf_source_command_timestamp_internal(p_payload -> 'effectiveAt', 'effectiveAt');
  v_correlation_id := public.kf_source_command_uuid_internal(p_payload -> 'correlationId', 'correlationId');

  SELECT authorizations.subject_identity_id, authorizations.purpose,
         authorizations.restrictions, authorizations.basis_id,
         authorizations.effective_from, authorizations.effective_until,
         authorizations.projected_state, authorizations.aggregate_version,
         authorizations.sequence
    INTO v_pre_subject_id, v_pre_purpose, v_pre_restrictions, v_pre_basis_id,
         v_pre_effective_from, v_pre_effective_until, v_current_state,
         v_current_version, v_current_sequence
  FROM public.kf_source_authorizations AS authorizations
  WHERE authorizations.id = v_predecessor_id
  FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'predecessor authorization was not found';
  END IF;
  IF v_current_state <> v_expected_state OR v_current_version <> v_expected_version
    OR v_current_sequence <> v_expected_sequence THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'predecessor authorization does not match command expectations';
  END IF;
  IF NOT (v_current_state = ANY(ARRAY['PENDING_REVIEW','GRANTED','SUSPENDED','BLOCKED'])) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'predecessor authorization cannot be superseded from current state';
  END IF;

  SELECT events.sequence, events.occurred_at, events.effective_at
    INTO v_history_sequence, v_history_occurred_at, v_history_effective_at
  FROM public.kf_source_governance_events AS events
  WHERE events.dimension = 'authorization' AND events.aggregate_id = v_predecessor_id
  ORDER BY events.sequence DESC LIMIT 1;
  IF NOT FOUND OR v_history_sequence <> v_current_sequence THEN
    RAISE EXCEPTION USING ERRCODE = '23514', MESSAGE = 'predecessor authorization projection and history are inconsistent';
  END IF;
  IF v_occurred_at < v_history_occurred_at OR v_effective_at < v_history_effective_at THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'supersession would regress committed temporal order';
  END IF;

  IF EXISTS (SELECT 1 FROM public.kf_source_authorizations WHERE id = v_successor_id) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'successor authorization already exists';
  END IF;

  v_subject_id := public.kf_source_command_uuid_internal(v_scope -> 'subject' -> 'id', 'scope.subject.id');
  IF v_subject_id <> v_pre_subject_id THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'successor authorization must govern the predecessor subject';
  END IF;
  SELECT identities.kind, projections.projected_state
    INTO v_subject_kind, v_registration_state
  FROM public.kf_source_registration_projections AS projections
  JOIN public.kf_source_identities AS identities ON identities.id = projections.subject_identity_id
  WHERE projections.subject_identity_id = v_subject_id
  FOR UPDATE OF projections;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'supersession subject was not found';
  END IF;
  IF v_subject_kind <> public.kf_source_command_text_internal(v_scope -> 'subject' -> 'kind', 'scope.subject.kind') THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'supersession subject kind does not match persisted identity';
  END IF;
  PERFORM public.kf_source_command_assert_c13_kind_internal(v_subject_kind);
  IF v_registration_state <> 'VALIDATED' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'successor authorization subject is not registrally VALIDATED';
  END IF;

  v_successor_purpose := public.kf_source_command_text_internal(v_scope -> 'purpose', 'scope.purpose');
  v_successor_restrictions := CASE WHEN v_scope ? 'restrictions'
    THEN public.kf_source_command_text_array_internal(v_scope -> 'restrictions', 'scope.restrictions')
    ELSE '{}'::text[] END;
  v_successor_basis_id := public.kf_source_command_resolve_basis_internal(p_payload -> 'basis', true);
  v_successor_effective_from := public.kf_source_command_timestamp_internal(p_payload -> 'effectiveFrom', 'effectiveFrom');
  v_successor_effective_until := CASE WHEN p_payload ? 'effectiveUntil'
    THEN public.kf_source_command_timestamp_internal(p_payload -> 'effectiveUntil', 'effectiveUntil') ELSE NULL END;

  v_pre_new_sequence := v_current_sequence + 1;
  UPDATE public.kf_source_authorizations
  SET projected_state = 'SUPERSEDED', aggregate_version = v_pre_new_version,
      sequence = v_pre_new_sequence, superseded_by_authorization_id = v_successor_id,
      updated_at = clock_timestamp()
  WHERE id = v_predecessor_id;

  INSERT INTO public.kf_source_authorizations(
    id, subject_identity_id, purpose, restrictions, basis_id, effective_from,
    effective_until, projected_state, aggregate_version, sequence
  ) VALUES (
    v_successor_id, v_subject_id, v_successor_purpose, v_successor_restrictions,
    v_successor_basis_id, v_successor_effective_from, v_successor_effective_until,
    'GRANTED', v_successor_version, 1
  );

  INSERT INTO public.kf_source_command_receipts(
    command_id, fingerprint, dimension, operation, aggregate_id,
    authorization_id, aggregate_version, sequence, authorization_state
  ) VALUES (
    p_command_id, p_fingerprint, 'authorization', 'supersede_authorization',
    v_predecessor_id, v_predecessor_id, v_pre_new_version,
    v_pre_new_sequence, 'SUPERSEDED'
  );

  INSERT INTO public.kf_source_governance_events(
    event_id, dimension, aggregate_id, aggregate_version, sequence, event_type,
    subject_identity_id, authorization_id, purpose, restrictions, basis_id,
    actor_id, actor_role, reason, occurred_at, effective_at, correlation_id,
    command_id, authorization_from_state, authorization_to_state,
    effective_from, effective_until, superseded_by_authorization_id
  ) VALUES (
    v_pre_event_id, 'authorization', v_predecessor_id, v_pre_new_version,
    v_pre_new_sequence, 'authorization_superseded', v_pre_subject_id,
    v_predecessor_id, v_pre_purpose, v_pre_restrictions, v_pre_basis_id,
    v_actor_id, v_actor_role, v_reason, v_occurred_at, v_effective_at,
    v_correlation_id, p_command_id, v_current_state, 'SUPERSEDED',
    v_pre_effective_from, v_pre_effective_until, v_successor_id
  );
  INSERT INTO public.kf_source_command_receipt_events(command_id, event_id, event_order)
  VALUES (p_command_id, v_pre_event_id, 1);

  INSERT INTO public.kf_source_governance_events(
    event_id, dimension, aggregate_id, aggregate_version, sequence, event_type,
    subject_identity_id, authorization_id, purpose, restrictions, basis_id,
    actor_id, actor_role, reason, occurred_at, effective_at, correlation_id,
    command_id, authorization_to_state, effective_from, effective_until
  ) VALUES (
    v_successor_event_id, 'authorization', v_successor_id, v_successor_version, 1,
    'authorization_granted', v_subject_id, v_successor_id, v_successor_purpose,
    v_successor_restrictions, v_successor_basis_id, v_actor_id, v_actor_role,
    v_reason, v_occurred_at, v_effective_at, v_correlation_id, p_command_id,
    'GRANTED', v_successor_effective_from, v_successor_effective_until
  );
  INSERT INTO public.kf_source_command_receipt_events(command_id, event_id, event_order)
  VALUES (p_command_id, v_successor_event_id, 2);

  PERFORM public.kf_source_command_append_impact_internal(
    p_command_id, 3, v_subject_id, v_predecessor_id, v_actor_id,
    v_actor_role, v_reason, v_occurred_at, v_effective_at, v_correlation_id
  );
END;
$function$;

-- ---------------------------------------------------------------------------
-- 7. Explicit impact command internal
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_source_open_impact_assessment_internal(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_subject_id uuid;
  v_triggering_authorization_id uuid;
  v_last_sequence bigint;
  v_last_version text;
  v_last_occurred_at timestamptz;
  v_last_effective_at timestamptz;
  v_expected_sequence bigint;
  v_expected_version text;
  v_new_sequence bigint;
  v_new_version text := gen_random_uuid()::text;
  v_event_id uuid := gen_random_uuid();
  v_actor_id uuid;
  v_actor_role text;
  v_reason text;
  v_occurred_at timestamptz;
  v_effective_at timestamptz;
  v_correlation_id uuid;
BEGIN
  v_subject_id := public.kf_source_command_assert_subject_internal(p_payload -> 'subject');
  v_triggering_authorization_id := CASE WHEN p_payload ? 'triggeringAuthorizationId'
    THEN public.kf_source_command_uuid_internal(p_payload -> 'triggeringAuthorizationId', 'triggeringAuthorizationId')
    ELSE NULL END;
  v_actor_id := public.kf_source_command_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_actor_role := public.kf_source_command_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_reason := public.kf_source_command_text_internal(p_payload -> 'reason', 'reason');
  v_occurred_at := public.kf_source_command_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  v_effective_at := public.kf_source_command_timestamp_internal(p_payload -> 'effectiveAt', 'effectiveAt');
  v_correlation_id := public.kf_source_command_uuid_internal(p_payload -> 'correlationId', 'correlationId');

  IF v_triggering_authorization_id IS NOT NULL AND NOT EXISTS (
    SELECT 1 FROM public.kf_source_authorizations AS authorizations
    WHERE authorizations.id = v_triggering_authorization_id
      AND authorizations.subject_identity_id = v_subject_id
  ) THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'triggering authorization was not found for subject';
  END IF;

  PERFORM pg_advisory_xact_lock(hashtextextended('impact:' || v_subject_id::text, 0));
  SELECT events.sequence, events.aggregate_version, events.occurred_at, events.effective_at
    INTO v_last_sequence, v_last_version, v_last_occurred_at, v_last_effective_at
  FROM public.kf_source_governance_events AS events
  WHERE events.dimension = 'impact' AND events.aggregate_id = v_subject_id
  ORDER BY events.sequence DESC LIMIT 1;

  IF p_payload ? 'expectedVersion' THEN
    v_expected_version := public.kf_source_command_text_internal(p_payload -> 'expectedVersion', 'expectedVersion');
    v_expected_sequence := public.kf_source_command_positive_bigint_internal(p_payload -> 'expectedSequence', 'expectedSequence');
    IF NOT FOUND OR v_last_version <> v_expected_version OR v_last_sequence <> v_expected_sequence THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'impact history does not match command expectations';
    END IF;
  END IF;

  IF v_last_sequence IS NOT NULL THEN
    IF v_occurred_at < v_last_occurred_at OR v_effective_at < v_last_effective_at THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'impact event would regress committed temporal order';
    END IF;
    v_new_sequence := v_last_sequence + 1;
  ELSE
    v_new_sequence := 1;
  END IF;

  INSERT INTO public.kf_source_command_receipts(
    command_id, fingerprint, dimension, operation, aggregate_id,
    subject_identity_id, aggregate_version, sequence
  ) VALUES (
    p_command_id, p_fingerprint, 'impact', 'open_impact_assessment', v_subject_id,
    v_subject_id, v_new_version, v_new_sequence
  );

  INSERT INTO public.kf_source_governance_events(
    event_id, dimension, aggregate_id, aggregate_version, sequence, event_type,
    subject_identity_id, actor_id, actor_role, reason, occurred_at, effective_at,
    correlation_id, command_id, triggering_authorization_id
  ) VALUES (
    v_event_id, 'impact', v_subject_id, v_new_version, v_new_sequence,
    'source_impact_assessment_opened', v_subject_id, v_actor_id, v_actor_role,
    v_reason, v_occurred_at, v_effective_at, v_correlation_id, p_command_id,
    v_triggering_authorization_id
  );
  INSERT INTO public.kf_source_command_receipt_events(command_id, event_id, event_order)
  VALUES (p_command_id, v_event_id, 1);
END;
$function$;

-- ---------------------------------------------------------------------------
-- 8. Narrow public SECURITY DEFINER RPCs
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_source_register_identity(p_command_id uuid, p_fingerprint text, p_payload jsonb)
RETURNS TABLE(dimension text, command_id uuid, fingerprint text, operation text, aggregate_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], state text, replayed boolean, committed_at timestamptz)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_source_command_precheck_internal('register_identity', p_command_id, p_fingerprint, p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, true); RETURN;
  END IF;
  PERFORM public.kf_source_register_identity_internal(p_command_id, p_fingerprint, p_payload);
  RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_request_validation(p_command_id uuid, p_fingerprint text, p_payload jsonb)
RETURNS TABLE(dimension text, command_id uuid, fingerprint text, operation text, aggregate_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], state text, replayed boolean, committed_at timestamptz)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_source_command_precheck_internal('request_validation', p_command_id, p_fingerprint, p_payload) THEN RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, true); RETURN; END IF;
  PERFORM public.kf_source_registration_transition_internal('request_validation','source_validation_requested','PENDING_VALIDATION',ARRAY['REGISTERED','BLOCKED'],false,p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_confirm_validation(p_command_id uuid, p_fingerprint text, p_payload jsonb)
RETURNS TABLE(dimension text, command_id uuid, fingerprint text, operation text, aggregate_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], state text, replayed boolean, committed_at timestamptz)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_source_command_precheck_internal('confirm_validation', p_command_id, p_fingerprint, p_payload) THEN RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, true); RETURN; END IF;
  PERFORM public.kf_source_registration_transition_internal('confirm_validation','source_validated','VALIDATED',ARRAY['PENDING_VALIDATION'],false,p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_block(p_command_id uuid, p_fingerprint text, p_payload jsonb)
RETURNS TABLE(dimension text, command_id uuid, fingerprint text, operation text, aggregate_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], state text, replayed boolean, committed_at timestamptz)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_source_command_precheck_internal('block_source', p_command_id, p_fingerprint, p_payload) THEN RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, true); RETURN; END IF;
  PERFORM public.kf_source_registration_transition_internal('block_source','source_blocked','BLOCKED',ARRAY['REGISTERED','PENDING_VALIDATION','VALIDATED'],true,p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_replace(p_command_id uuid, p_fingerprint text, p_payload jsonb)
RETURNS TABLE(dimension text, command_id uuid, fingerprint text, operation text, aggregate_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], state text, replayed boolean, committed_at timestamptz)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_source_command_precheck_internal('replace_source', p_command_id, p_fingerprint, p_payload) THEN RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, true); RETURN; END IF;
  PERFORM public.kf_source_registration_transition_internal('replace_source','source_replaced','REPLACED',ARRAY['VALIDATED','BLOCKED'],true,p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_archive(p_command_id uuid, p_fingerprint text, p_payload jsonb)
RETURNS TABLE(dimension text, command_id uuid, fingerprint text, operation text, aggregate_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], state text, replayed boolean, committed_at timestamptz)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_source_command_precheck_internal('archive_source', p_command_id, p_fingerprint, p_payload) THEN RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, true); RETURN; END IF;
  PERFORM public.kf_source_registration_transition_internal('archive_source','source_archived','ARCHIVED',ARRAY['REGISTERED','PENDING_VALIDATION','VALIDATED','BLOCKED','REPLACED'],true,p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_grant_authorization(p_command_id uuid, p_fingerprint text, p_payload jsonb)
RETURNS TABLE(dimension text, command_id uuid, fingerprint text, operation text, aggregate_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], state text, replayed boolean, committed_at timestamptz)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_source_command_precheck_internal('grant_authorization', p_command_id, p_fingerprint, p_payload) THEN RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, true); RETURN; END IF;
  PERFORM public.kf_source_grant_authorization_internal(p_command_id, p_fingerprint, p_payload);
  RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_suspend_authorization(p_command_id uuid, p_fingerprint text, p_payload jsonb)
RETURNS TABLE(dimension text, command_id uuid, fingerprint text, operation text, aggregate_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], state text, replayed boolean, committed_at timestamptz)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_source_command_precheck_internal('suspend_authorization', p_command_id, p_fingerprint, p_payload) THEN RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, true); RETURN; END IF;
  PERFORM public.kf_source_authorization_transition_internal('suspend_authorization','authorization_suspended','SUSPENDED',ARRAY['GRANTED'],true,p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_resume_authorization(p_command_id uuid, p_fingerprint text, p_payload jsonb)
RETURNS TABLE(dimension text, command_id uuid, fingerprint text, operation text, aggregate_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], state text, replayed boolean, committed_at timestamptz)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_source_command_precheck_internal('resume_authorization', p_command_id, p_fingerprint, p_payload) THEN RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, true); RETURN; END IF;
  PERFORM public.kf_source_authorization_transition_internal('resume_authorization','authorization_resumed','GRANTED',ARRAY['SUSPENDED'],false,p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_revoke_authorization(p_command_id uuid, p_fingerprint text, p_payload jsonb)
RETURNS TABLE(dimension text, command_id uuid, fingerprint text, operation text, aggregate_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], state text, replayed boolean, committed_at timestamptz)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_source_command_precheck_internal('revoke_authorization', p_command_id, p_fingerprint, p_payload) THEN RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, true); RETURN; END IF;
  PERFORM public.kf_source_authorization_transition_internal('revoke_authorization','authorization_revoked','REVOKED',ARRAY['GRANTED','SUSPENDED'],true,p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_block_purpose(p_command_id uuid, p_fingerprint text, p_payload jsonb)
RETURNS TABLE(dimension text, command_id uuid, fingerprint text, operation text, aggregate_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], state text, replayed boolean, committed_at timestamptz)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_source_command_precheck_internal('block_purpose', p_command_id, p_fingerprint, p_payload) THEN RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, true); RETURN; END IF;
  PERFORM public.kf_source_authorization_transition_internal('block_purpose','authorization_blocked','BLOCKED',ARRAY['PENDING_REVIEW','SUSPENDED'],true,p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_supersede_authorization(p_command_id uuid, p_fingerprint text, p_payload jsonb)
RETURNS TABLE(dimension text, command_id uuid, fingerprint text, operation text, aggregate_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], state text, replayed boolean, committed_at timestamptz)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_source_command_precheck_internal('supersede_authorization', p_command_id, p_fingerprint, p_payload) THEN RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, true); RETURN; END IF;
  PERFORM public.kf_source_supersede_authorization_internal(p_command_id, p_fingerprint, p_payload);
  RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_open_impact_assessment(p_command_id uuid, p_fingerprint text, p_payload jsonb)
RETURNS TABLE(dimension text, command_id uuid, fingerprint text, operation text, aggregate_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], state text, replayed boolean, committed_at timestamptz)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_source_command_precheck_internal('open_impact_assessment', p_command_id, p_fingerprint, p_payload) THEN RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, true); RETURN; END IF;
  PERFORM public.kf_source_open_impact_assessment_internal(p_command_id, p_fingerprint, p_payload);
  RETURN QUERY SELECT * FROM public.kf_source_command_receipt_result_internal(p_command_id, false);
END;
$function$;

-- ---------------------------------------------------------------------------
-- 9. Ownership and least privilege
-- ---------------------------------------------------------------------------
ALTER TABLE public.kf_source_actor_assignments OWNER TO postgres;

ALTER FUNCTION public.kf_source_command_assert_object_internal(jsonb,text[],text[],text) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_text_internal(jsonb,text) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_uuid_internal(jsonb,text) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_timestamp_internal(jsonb,text) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_positive_bigint_internal(jsonb,text) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_text_array_internal(jsonb,text) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_assert_c13_kind_internal(text) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_validate_subject_internal(jsonb,text) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_validate_payload_internal(text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_fingerprint_internal(text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_actor_allowed_internal(text,text) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_assert_assignment_internal(uuid,text,timestamptz) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_precheck_internal(text,uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_receipt_result_internal(uuid,boolean) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_assert_subject_internal(jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_append_impact_internal(uuid,integer,uuid,uuid,uuid,text,text,timestamptz,timestamptz,uuid) OWNER TO postgres;
ALTER FUNCTION public.kf_source_register_identity_internal(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_registration_transition_internal(text,text,text,text[],boolean,uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_command_resolve_basis_internal(jsonb,boolean) OWNER TO postgres;
ALTER FUNCTION public.kf_source_grant_authorization_internal(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_authorization_transition_internal(text,text,text,text[],boolean,uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_supersede_authorization_internal(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_open_impact_assessment_internal(uuid,text,jsonb) OWNER TO postgres;

REVOKE ALL ON FUNCTION
  public.kf_source_command_assert_object_internal(jsonb,text[],text[],text),
  public.kf_source_command_text_internal(jsonb,text),
  public.kf_source_command_uuid_internal(jsonb,text),
  public.kf_source_command_timestamp_internal(jsonb,text),
  public.kf_source_command_positive_bigint_internal(jsonb,text),
  public.kf_source_command_text_array_internal(jsonb,text),
  public.kf_source_command_assert_c13_kind_internal(text),
  public.kf_source_command_validate_subject_internal(jsonb,text),
  public.kf_source_command_validate_payload_internal(text,jsonb),
  public.kf_source_command_fingerprint_internal(text,jsonb),
  public.kf_source_command_actor_allowed_internal(text,text),
  public.kf_source_command_assert_assignment_internal(uuid,text,timestamptz),
  public.kf_source_command_precheck_internal(text,uuid,text,jsonb),
  public.kf_source_command_receipt_result_internal(uuid,boolean),
  public.kf_source_command_assert_subject_internal(jsonb),
  public.kf_source_command_append_impact_internal(uuid,integer,uuid,uuid,uuid,text,text,timestamptz,timestamptz,uuid),
  public.kf_source_register_identity_internal(uuid,text,jsonb),
  public.kf_source_registration_transition_internal(text,text,text,text[],boolean,uuid,text,jsonb),
  public.kf_source_command_resolve_basis_internal(jsonb,boolean),
  public.kf_source_grant_authorization_internal(uuid,text,jsonb),
  public.kf_source_authorization_transition_internal(text,text,text,text[],boolean,uuid,text,jsonb),
  public.kf_source_supersede_authorization_internal(uuid,text,jsonb),
  public.kf_source_open_impact_assessment_internal(uuid,text,jsonb)
FROM PUBLIC, anon, authenticated, service_role;

ALTER FUNCTION public.kf_source_register_identity(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_request_validation(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_confirm_validation(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_block(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_replace(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_archive(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_grant_authorization(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_suspend_authorization(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_resume_authorization(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_revoke_authorization(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_block_purpose(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_supersede_authorization(uuid,text,jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_source_open_impact_assessment(uuid,text,jsonb) OWNER TO postgres;

REVOKE ALL ON FUNCTION
  public.kf_source_register_identity(uuid,text,jsonb),
  public.kf_source_request_validation(uuid,text,jsonb),
  public.kf_source_confirm_validation(uuid,text,jsonb),
  public.kf_source_block(uuid,text,jsonb),
  public.kf_source_replace(uuid,text,jsonb),
  public.kf_source_archive(uuid,text,jsonb),
  public.kf_source_grant_authorization(uuid,text,jsonb),
  public.kf_source_suspend_authorization(uuid,text,jsonb),
  public.kf_source_resume_authorization(uuid,text,jsonb),
  public.kf_source_revoke_authorization(uuid,text,jsonb),
  public.kf_source_block_purpose(uuid,text,jsonb),
  public.kf_source_supersede_authorization(uuid,text,jsonb),
  public.kf_source_open_impact_assessment(uuid,text,jsonb)
FROM PUBLIC, anon, authenticated, service_role;

GRANT EXECUTE ON FUNCTION
  public.kf_source_register_identity(uuid,text,jsonb),
  public.kf_source_request_validation(uuid,text,jsonb),
  public.kf_source_confirm_validation(uuid,text,jsonb),
  public.kf_source_block(uuid,text,jsonb),
  public.kf_source_replace(uuid,text,jsonb),
  public.kf_source_archive(uuid,text,jsonb),
  public.kf_source_grant_authorization(uuid,text,jsonb),
  public.kf_source_suspend_authorization(uuid,text,jsonb),
  public.kf_source_resume_authorization(uuid,text,jsonb),
  public.kf_source_revoke_authorization(uuid,text,jsonb),
  public.kf_source_block_purpose(uuid,text,jsonb),
  public.kf_source_supersede_authorization(uuid,text,jsonb),
  public.kf_source_open_impact_assessment(uuid,text,jsonb)
TO service_role;

-- Defense in depth: the technical executor reaches lifecycle writes only via RPC.
REVOKE INSERT, UPDATE, DELETE ON TABLE
  public.kf_source_identities,
  public.kf_source_authorization_bases,
  public.kf_source_registration_projections,
  public.kf_source_authorizations,
  public.kf_source_command_receipts,
  public.kf_source_governance_events,
  public.kf_source_command_receipt_events,
  public.kf_source_actor_assignments
FROM service_role;

COMMIT;
