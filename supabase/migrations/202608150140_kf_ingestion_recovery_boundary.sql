-- =============================================================================
-- ProfePlan Knowledge Factory - Sublote C.2.4
-- Durable ingestion idempotency, recovery and fail-safe command boundary.
--
-- SECURITY / SCOPE:
-- - additive only;
-- - PostgreSQL is the authority for run/control-plane facts, not physical bytes;
-- - Storage remains external and is reconciled through provider-neutral ports;
-- - no hosted resource, production cutover, queue, worker or real content;
-- - C.2.5+ commands remain deliberately unavailable.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Durable C.2 control-plane tables
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_ingestion_runs (
  run_id uuid PRIMARY KEY
    REFERENCES public.kf_source_identities(id) ON DELETE RESTRICT,
  request_id uuid NOT NULL UNIQUE,
  source_version_id uuid NOT NULL
    REFERENCES public.kf_source_identities(id) ON DELETE RESTRICT,
  received_file_id uuid NOT NULL
    REFERENCES public.kf_source_identities(id) ON DELETE RESTRICT,
  requested_by_actor_id uuid NOT NULL,
  requested_by_actor_role text NOT NULL CHECK (
    requested_by_actor_role IN (
      'curator', 'legal_editorial_reviewer', 'system_worker', 'auditor', 'technical_admin'
    )
  ),
  requested_at timestamptz NOT NULL,
  state text NOT NULL CHECK (
    state IN (
      'REQUESTED', 'STAGING', 'STAGED', 'VERIFYING', 'VERIFIED',
      'PENDING_REVIEW', 'APPROVED_FOR_EXTRACTION', 'REJECTED', 'FAILED', 'CANCELLED'
    )
  ),
  aggregate_version text NOT NULL CHECK (btrim(aggregate_version) <> ''),
  sequence bigint NOT NULL CHECK (sequence > 0),
  created_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  updated_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_ingestion_runs_time_check CHECK (updated_at >= created_at)
);

CREATE INDEX kf_ingestion_runs_source_version_idx
  ON public.kf_ingestion_runs (source_version_id, state);
CREATE INDEX kf_ingestion_runs_received_file_idx
  ON public.kf_ingestion_runs (received_file_id);

CREATE TABLE public.kf_ingestion_command_receipts (
  command_id uuid PRIMARY KEY,
  fingerprint text NOT NULL CHECK (fingerprint ~ '^[0-9a-f]{64}$'),
  correlation_id uuid NOT NULL,
  operation text NOT NULL CHECK (
    operation IN (
      'request_ingestion', 'begin_staging', 'mark_staged', 'begin_verification',
      'confirm_verified', 'fail_ingestion', 'cancel_ingestion'
    )
  ),
  run_id uuid NOT NULL REFERENCES public.kf_ingestion_runs(run_id) ON DELETE RESTRICT,
  aggregate_version text NOT NULL CHECK (btrim(aggregate_version) <> ''),
  sequence bigint NOT NULL CHECK (sequence > 0),
  previous_state text CHECK (
    previous_state IS NULL OR previous_state IN (
      'REQUESTED', 'STAGING', 'STAGED', 'VERIFYING', 'VERIFIED',
      'PENDING_REVIEW', 'APPROVED_FOR_EXTRACTION', 'REJECTED', 'FAILED', 'CANCELLED'
    )
  ),
  state text NOT NULL CHECK (
    state IN (
      'REQUESTED', 'STAGING', 'STAGED', 'VERIFYING', 'VERIFIED',
      'PENDING_REVIEW', 'APPROVED_FOR_EXTRACTION', 'REJECTED', 'FAILED', 'CANCELLED'
    )
  ),
  reason_code text CHECK (
    reason_code IS NULL OR reason_code IN (
      'policy_rejected', 'technical_failure', 'human_review_rejected', 'operator_cancelled'
    )
  ),
  committed_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_ingestion_command_receipts_run_sequence_key UNIQUE (run_id, sequence),
  CONSTRAINT kf_ingestion_command_receipts_reason_shape_check CHECK (
    (operation = 'fail_ingestion' AND reason_code = 'technical_failure')
    OR (operation = 'cancel_ingestion' AND reason_code = 'operator_cancelled')
    OR (operation NOT IN ('fail_ingestion', 'cancel_ingestion') AND reason_code IS NULL)
  )
);

CREATE INDEX kf_ingestion_command_receipts_run_idx
  ON public.kf_ingestion_command_receipts (run_id, sequence DESC);

CREATE TABLE public.kf_ingestion_events (
  event_id uuid PRIMARY KEY,
  event_type text NOT NULL CHECK (
    event_type IN (
      'ingestion_requested', 'ingestion_staging_started', 'ingestion_staged',
      'ingestion_verification_started', 'ingestion_verified', 'ingestion_failed',
      'ingestion_cancelled'
    )
  ),
  run_id uuid NOT NULL REFERENCES public.kf_ingestion_runs(run_id) ON DELETE RESTRICT,
  aggregate_version text NOT NULL CHECK (btrim(aggregate_version) <> ''),
  sequence bigint NOT NULL CHECK (sequence > 0),
  actor_id uuid NOT NULL,
  actor_role text NOT NULL CHECK (
    actor_role IN (
      'curator', 'legal_editorial_reviewer', 'system_worker', 'auditor', 'technical_admin'
    )
  ),
  reason text NOT NULL CHECK (btrim(reason) <> ''),
  occurred_at timestamptz NOT NULL,
  correlation_id uuid NOT NULL,
  command_id uuid NOT NULL
    REFERENCES public.kf_ingestion_command_receipts(command_id)
    ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED,
  from_state text CHECK (
    from_state IS NULL OR from_state IN (
      'REQUESTED', 'STAGING', 'STAGED', 'VERIFYING', 'VERIFIED',
      'PENDING_REVIEW', 'APPROVED_FOR_EXTRACTION', 'REJECTED', 'FAILED', 'CANCELLED'
    )
  ),
  to_state text NOT NULL CHECK (
    to_state IN (
      'REQUESTED', 'STAGING', 'STAGED', 'VERIFYING', 'VERIFIED',
      'PENDING_REVIEW', 'APPROVED_FOR_EXTRACTION', 'REJECTED', 'FAILED', 'CANCELLED'
    )
  ),
  reason_code text CHECK (
    reason_code IS NULL OR reason_code IN (
      'policy_rejected', 'technical_failure', 'human_review_rejected', 'operator_cancelled'
    )
  ),
  recorded_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_ingestion_events_run_sequence_key UNIQUE (run_id, sequence),
  CONSTRAINT kf_ingestion_events_command_event_key UNIQUE (command_id, event_id)
);

CREATE INDEX kf_ingestion_events_command_idx ON public.kf_ingestion_events(command_id);

CREATE TABLE public.kf_ingestion_staging_artifacts (
  artifact_id uuid PRIMARY KEY,
  run_id uuid NOT NULL REFERENCES public.kf_ingestion_runs(run_id) ON DELETE RESTRICT,
  source_version_id uuid NOT NULL
    REFERENCES public.kf_source_identities(id) ON DELETE RESTRICT,
  received_file_id uuid NOT NULL
    REFERENCES public.kf_source_identities(id) ON DELETE RESTRICT,
  state text NOT NULL CHECK (
    state IN ('RECEIVING', 'STAGED', 'VERIFIED', 'DISCARD_PENDING', 'DISCARDED', 'FAILED', 'QUARANTINED')
  ),
  size_bytes bigint NOT NULL CHECK (size_bytes > 0),
  media_type text NOT NULL CHECK (btrim(media_type) <> ''),
  created_at timestamptz NOT NULL,
  expires_at timestamptz NOT NULL,
  opaque_locator text CHECK (opaque_locator IS NULL OR btrim(opaque_locator) <> ''),
  write_digest_algorithm text NOT NULL CHECK (write_digest_algorithm = 'sha-256'),
  write_digest_value text NOT NULL CHECK (write_digest_value ~ '^[0-9a-f]{64}$'),
  correlation_id uuid NOT NULL,
  discard_requested_at timestamptz,
  discard_confirmed_at timestamptz,
  discard_reason_code text CHECK (
    discard_reason_code IS NULL OR discard_reason_code IN (
      'success_after_stage', 'policy_rejected', 'operator_cancelled', 'technical_failure',
      'retention_expired', 'orphan_cleanup'
    )
  ),
  discard_outcome text CHECK (
    discard_outcome IS NULL OR discard_outcome IN ('discarded', 'already_discarded')
  ),
  discard_correlation_id uuid,
  updated_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_ingestion_staging_artifacts_binding_key
    UNIQUE (artifact_id, run_id, source_version_id, received_file_id),
  CONSTRAINT kf_ingestion_staging_artifacts_window_check CHECK (expires_at > created_at),
  CONSTRAINT kf_ingestion_staging_artifacts_locator_check CHECK (
    state NOT IN ('STAGED', 'VERIFIED', 'DISCARD_PENDING', 'DISCARDED')
    OR opaque_locator IS NOT NULL
  ),
  CONSTRAINT kf_ingestion_staging_artifacts_discard_shape_check CHECK (
    (
      state = 'DISCARD_PENDING'
      AND discard_requested_at IS NOT NULL
      AND discard_confirmed_at IS NULL
      AND discard_reason_code IS NOT NULL
      AND discard_outcome IS NULL
      AND discard_correlation_id IS NOT NULL
    )
    OR (
      state = 'DISCARDED'
      AND discard_requested_at IS NOT NULL
      AND discard_confirmed_at IS NOT NULL
      AND discard_reason_code IS NOT NULL
      AND discard_outcome IS NOT NULL
      AND discard_correlation_id IS NOT NULL
      AND discard_confirmed_at >= discard_requested_at
    )
    OR (
      state NOT IN ('DISCARD_PENDING', 'DISCARDED')
      AND discard_requested_at IS NULL
      AND discard_confirmed_at IS NULL
      AND discard_reason_code IS NULL
      AND discard_outcome IS NULL
      AND discard_correlation_id IS NULL
    )
  )
);

CREATE INDEX kf_ingestion_staging_artifacts_run_idx
  ON public.kf_ingestion_staging_artifacts (run_id, state);
CREATE INDEX kf_ingestion_staging_artifacts_expiry_idx
  ON public.kf_ingestion_staging_artifacts (expires_at, state);

CREATE TABLE public.kf_ingestion_integrity_evidence (
  artifact_id uuid PRIMARY KEY,
  run_id uuid NOT NULL,
  source_version_id uuid NOT NULL,
  received_file_id uuid NOT NULL,
  digest_algorithm text NOT NULL CHECK (digest_algorithm = 'sha-256'),
  digest_value text NOT NULL CHECK (digest_value ~ '^[0-9a-f]{64}$'),
  byte_length bigint NOT NULL CHECK (byte_length > 0),
  verified_at timestamptz NOT NULL,
  correlation_id uuid NOT NULL,
  duplicate_decision jsonb NOT NULL,
  recorded_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_ingestion_integrity_evidence_artifact_fk
    FOREIGN KEY (artifact_id, run_id, source_version_id, received_file_id)
    REFERENCES public.kf_ingestion_staging_artifacts(
      artifact_id, run_id, source_version_id, received_file_id
    ) ON DELETE RESTRICT,
  CONSTRAINT kf_ingestion_integrity_evidence_duplicate_shape_check CHECK (
    jsonb_typeof(duplicate_decision) = 'object'
    AND duplicate_decision ->> 'contractVersion' = '1.0.0'
    AND duplicate_decision ->> 'outcome' IN ('unique', 'duplicate')
    AND jsonb_typeof(duplicate_decision -> 'matches') = 'array'
  )
);

-- Deliberately NON-UNIQUE. Binary equality is evidence, never business identity.
CREATE INDEX kf_ingestion_integrity_digest_lookup_idx
  ON public.kf_ingestion_integrity_evidence (digest_algorithm, digest_value);
CREATE INDEX kf_ingestion_integrity_run_idx
  ON public.kf_ingestion_integrity_evidence (run_id, verified_at);

-- ---------------------------------------------------------------------------
-- 2. Mutation guards
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_prevent_ingestion_run_identity_mutation()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF NEW.run_id IS DISTINCT FROM OLD.run_id
    OR NEW.request_id IS DISTINCT FROM OLD.request_id
    OR NEW.source_version_id IS DISTINCT FROM OLD.source_version_id
    OR NEW.received_file_id IS DISTINCT FROM OLD.received_file_id
    OR NEW.requested_by_actor_id IS DISTINCT FROM OLD.requested_by_actor_id
    OR NEW.requested_by_actor_role IS DISTINCT FROM OLD.requested_by_actor_role
    OR NEW.requested_at IS DISTINCT FROM OLD.requested_at
    OR NEW.created_at IS DISTINCT FROM OLD.created_at THEN
    RAISE EXCEPTION USING ERRCODE = '55000', MESSAGE = 'ingestion run identity fields are immutable';
  END IF;
  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_prevent_ingestion_artifact_identity_mutation()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF NEW.artifact_id IS DISTINCT FROM OLD.artifact_id
    OR NEW.run_id IS DISTINCT FROM OLD.run_id
    OR NEW.source_version_id IS DISTINCT FROM OLD.source_version_id
    OR NEW.received_file_id IS DISTINCT FROM OLD.received_file_id
    OR NEW.size_bytes IS DISTINCT FROM OLD.size_bytes
    OR NEW.media_type IS DISTINCT FROM OLD.media_type
    OR NEW.created_at IS DISTINCT FROM OLD.created_at
    OR NEW.expires_at IS DISTINCT FROM OLD.expires_at
    OR NEW.write_digest_algorithm IS DISTINCT FROM OLD.write_digest_algorithm
    OR NEW.write_digest_value IS DISTINCT FROM OLD.write_digest_value
    OR NEW.correlation_id IS DISTINCT FROM OLD.correlation_id THEN
    RAISE EXCEPTION USING ERRCODE = '55000', MESSAGE = 'staging artifact recovery identity is immutable';
  END IF;
  IF OLD.opaque_locator IS NOT NULL AND NEW.opaque_locator IS DISTINCT FROM OLD.opaque_locator THEN
    RAISE EXCEPTION USING ERRCODE = '55000', MESSAGE = 'staging opaque locator cannot be replaced';
  END IF;
  IF OLD.discard_requested_at IS NOT NULL AND (
    NEW.discard_requested_at IS DISTINCT FROM OLD.discard_requested_at
    OR NEW.discard_reason_code IS DISTINCT FROM OLD.discard_reason_code
    OR NEW.discard_correlation_id IS DISTINCT FROM OLD.discard_correlation_id
  ) THEN
    RAISE EXCEPTION USING ERRCODE = '55000', MESSAGE = 'staging discard request is immutable';
  END IF;
  RETURN NEW;
END;
$function$;

CREATE TRIGGER kf_ingestion_runs_immutable_identity
BEFORE UPDATE ON public.kf_ingestion_runs
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_ingestion_run_identity_mutation();

CREATE TRIGGER kf_ingestion_staging_artifacts_immutable_identity
BEFORE UPDATE ON public.kf_ingestion_staging_artifacts
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_ingestion_artifact_identity_mutation();

CREATE TRIGGER kf_ingestion_command_receipts_append_only
BEFORE UPDATE OR DELETE ON public.kf_ingestion_command_receipts
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE TRIGGER kf_ingestion_events_append_only
BEFORE UPDATE OR DELETE ON public.kf_ingestion_events
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE TRIGGER kf_ingestion_integrity_evidence_append_only
BEFORE UPDATE OR DELETE ON public.kf_ingestion_integrity_evidence
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

-- ---------------------------------------------------------------------------
-- 3. Closed-schema parsers and canonical fingerprint v1
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_ingestion_assert_object_internal(
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
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must be a JSON object';
  END IF;
  IF NOT (p_value ?& p_required_keys) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' is missing required fields';
  END IF;
  IF EXISTS (
    SELECT 1 FROM jsonb_object_keys(p_value) AS supplied(key)
    WHERE NOT (supplied.key = ANY(p_allowed_keys))
  ) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' contains an unknown field';
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_text_internal(p_value jsonb, p_context text)
RETURNS text
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE v_result text;
BEGIN
  IF p_value IS NULL OR jsonb_typeof(p_value) <> 'string' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must be a string';
  END IF;
  v_result := p_value #>> '{}';
  IF btrim(v_result) = '' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must not be blank';
  END IF;
  RETURN v_result;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_uuid_internal(p_value jsonb, p_context text)
RETURNS uuid
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_ingestion_text_internal(p_value, p_context)::uuid;
EXCEPTION WHEN invalid_text_representation THEN
  RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must be a UUID';
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_timestamp_internal(p_value jsonb, p_context text)
RETURNS timestamptz
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_ingestion_text_internal(p_value, p_context)::timestamptz;
EXCEPTION WHEN invalid_datetime_format OR datetime_field_overflow THEN
  RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must be a valid timestamp';
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_positive_bigint_internal(p_value jsonb, p_context text)
RETURNS bigint
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE v_value numeric;
BEGIN
  IF p_value IS NULL OR jsonb_typeof(p_value) <> 'number' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must be a positive integer';
  END IF;
  v_value := (p_value #>> '{}')::numeric;
  IF v_value <= 0 OR trunc(v_value) <> v_value OR v_value > 9223372036854775807 THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must be a positive integer';
  END IF;
  RETURN v_value::bigint;
EXCEPTION WHEN invalid_text_representation OR numeric_value_out_of_range THEN
  RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must be a positive integer';
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_assert_actor_internal(p_value jsonb, p_context text)
RETURNS void
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE v_role text;
BEGIN
  PERFORM public.kf_ingestion_assert_object_internal(
    p_value, ARRAY['actorId','role'], ARRAY['actorId','role'], p_context
  );
  PERFORM public.kf_ingestion_uuid_internal(p_value -> 'actorId', p_context || '.actorId');
  v_role := public.kf_ingestion_text_internal(p_value -> 'role', p_context || '.role');
  IF NOT (v_role = ANY(ARRAY[
    'curator','legal_editorial_reviewer','system_worker','auditor','technical_admin'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || '.role is invalid';
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_ref_uuid_internal(
  p_value jsonb,
  p_expected_kind text,
  p_context text
)
RETURNS uuid
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE v_kind text;
BEGIN
  PERFORM public.kf_ingestion_assert_object_internal(
    p_value, ARRAY['kind','id'], ARRAY['kind','id'], p_context
  );
  v_kind := public.kf_ingestion_text_internal(p_value -> 'kind', p_context || '.kind');
  IF v_kind <> p_expected_kind THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || '.kind is invalid';
  END IF;
  RETURN public.kf_ingestion_uuid_internal(p_value -> 'id', p_context || '.id');
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_assert_identity_kind_internal(
  p_identity_id uuid,
  p_expected_kind text
)
RETURNS void
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE v_kind text;
BEGIN
  SELECT identities.kind INTO v_kind
  FROM public.kf_source_identities AS identities
  WHERE identities.id = p_identity_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'source identity was not found';
  END IF;
  IF v_kind <> p_expected_kind THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'source identity kind does not match ingestion binding';
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_canonical_json_internal(p_value jsonb)
RETURNS text
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE v_result text;
BEGIN
  CASE jsonb_typeof(p_value)
    WHEN 'object' THEN
      SELECT '{' || coalesce(
        string_agg(
          to_jsonb(entry.key)::text || ':' || public.kf_ingestion_canonical_json_internal(entry.value),
          ',' ORDER BY entry.key COLLATE "C"
        ), ''
      ) || '}'
      INTO v_result
      FROM jsonb_each(p_value) AS entry(key, value);
      RETURN v_result;
    WHEN 'array' THEN
      SELECT '[' || coalesce(
        string_agg(
          public.kf_ingestion_canonical_json_internal(item.value),
          ',' ORDER BY item.ordinality
        ), ''
      ) || ']'
      INTO v_result
      FROM jsonb_array_elements(p_value) WITH ORDINALITY AS item(value, ordinality);
      RETURN v_result;
    ELSE
      RETURN p_value::text;
  END CASE;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_command_fingerprint_internal(
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
        public.kf_ingestion_canonical_json_internal(
          jsonb_build_object(
            'fingerprintVersion', 1,
            'operation', p_operation,
            'payload', p_payload
          )
        ),
        'UTF8'
      )
    ),
    'hex'
  )
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_validate_technical_metadata_internal(
  p_value jsonb,
  p_context text
)
RETURNS void
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF p_value IS NULL THEN RETURN; END IF;
  PERFORM public.kf_ingestion_assert_object_internal(
    p_value, ARRAY[]::text[], ARRAY['declaredMediaType','sizeBytes'], p_context
  );
  IF p_value ? 'declaredMediaType' THEN
    PERFORM public.kf_ingestion_text_internal(p_value -> 'declaredMediaType', p_context || '.declaredMediaType');
  END IF;
  IF p_value ? 'sizeBytes' THEN
    PERFORM public.kf_ingestion_positive_bigint_internal(p_value -> 'sizeBytes', p_context || '.sizeBytes');
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_validate_command_payload_internal(
  p_operation text,
  p_payload jsonb
)
RETURNS void
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_allowed text[];
  v_expected_state text;
BEGIN
  IF NOT (p_operation = ANY(ARRAY[
    'request_ingestion','begin_staging','mark_staged','begin_verification',
    'confirm_verified','fail_ingestion','cancel_ingestion'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'ingestion operation is outside C.2.4';
  END IF;

  v_allowed := CASE p_operation
    WHEN 'request_ingestion' THEN ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','expectedVersion','expectedSequence','request'
    ]
    WHEN 'mark_staged' THEN ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','expectedVersion','expectedSequence',
      'run','expectedState','stagingArtifact','technicalMetadata'
    ]
    WHEN 'confirm_verified' THEN ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','expectedVersion','expectedSequence',
      'run','expectedState','technicalMetadata'
    ]
    WHEN 'fail_ingestion' THEN ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','expectedVersion','expectedSequence',
      'run','expectedState','reasonCode'
    ]
    WHEN 'cancel_ingestion' THEN ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','expectedVersion','expectedSequence',
      'run','expectedState','reasonCode'
    ]
    ELSE ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','expectedVersion','expectedSequence',
      'run','expectedState'
    ]
  END;

  PERFORM public.kf_ingestion_assert_object_internal(
    p_payload,
    CASE WHEN p_operation = 'request_ingestion'
      THEN ARRAY['commandType','actor','occurredAt','correlationId','reason','request']
      ELSE CASE WHEN p_operation IN ('fail_ingestion','cancel_ingestion')
        THEN ARRAY['commandType','actor','occurredAt','correlationId','reason','run','expectedState','reasonCode']
        ELSE CASE WHEN p_operation = 'mark_staged'
          THEN ARRAY['commandType','actor','occurredAt','correlationId','reason','run','expectedState','stagingArtifact']
          ELSE ARRAY['commandType','actor','occurredAt','correlationId','reason','run','expectedState']
        END
      END
    END,
    v_allowed,
    'ingestion command payload'
  );

  IF public.kf_ingestion_text_internal(p_payload -> 'commandType', 'commandType') <> p_operation THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'commandType does not match RPC operation';
  END IF;
  PERFORM public.kf_ingestion_assert_actor_internal(p_payload -> 'actor', 'actor');
  PERFORM public.kf_ingestion_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  PERFORM public.kf_ingestion_uuid_internal(p_payload -> 'correlationId', 'correlationId');
  PERFORM public.kf_ingestion_text_internal(p_payload -> 'reason', 'reason');
  IF p_payload ? 'expectedVersion' THEN
    PERFORM public.kf_ingestion_text_internal(p_payload -> 'expectedVersion', 'expectedVersion');
  END IF;
  IF p_payload ? 'expectedSequence' THEN
    PERFORM public.kf_ingestion_positive_bigint_internal(p_payload -> 'expectedSequence', 'expectedSequence');
  END IF;

  IF p_operation = 'request_ingestion' THEN
    RETURN;
  END IF;

  PERFORM public.kf_ingestion_ref_uuid_internal(p_payload -> 'run', 'processing_run', 'run');
  v_expected_state := public.kf_ingestion_text_internal(p_payload -> 'expectedState', 'expectedState');
  IF NOT (v_expected_state = ANY(ARRAY[
    'REQUESTED','STAGING','STAGED','VERIFYING','VERIFIED','PENDING_REVIEW',
    'APPROVED_FOR_EXTRACTION','REJECTED','FAILED','CANCELLED'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'expectedState is invalid';
  END IF;

  IF p_operation = 'mark_staged' THEN
    PERFORM public.kf_ingestion_assert_object_internal(
      p_payload -> 'stagingArtifact',
      ARRAY['artifactId','opaqueLocator'], ARRAY['artifactId','opaqueLocator'], 'stagingArtifact'
    );
    PERFORM public.kf_ingestion_uuid_internal(p_payload -> 'stagingArtifact' -> 'artifactId', 'stagingArtifact.artifactId');
    PERFORM public.kf_ingestion_text_internal(p_payload -> 'stagingArtifact' -> 'opaqueLocator', 'stagingArtifact.opaqueLocator');
    IF p_payload ? 'technicalMetadata' THEN
      PERFORM public.kf_ingestion_validate_technical_metadata_internal(p_payload -> 'technicalMetadata', 'technicalMetadata');
    END IF;
  ELSIF p_operation = 'confirm_verified' AND p_payload ? 'technicalMetadata' THEN
    PERFORM public.kf_ingestion_validate_technical_metadata_internal(p_payload -> 'technicalMetadata', 'technicalMetadata');
  ELSIF p_operation = 'fail_ingestion' THEN
    IF public.kf_ingestion_text_internal(p_payload -> 'reasonCode', 'reasonCode') <> 'technical_failure' THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'fail_ingestion reasonCode is invalid';
    END IF;
  ELSIF p_operation = 'cancel_ingestion' THEN
    IF public.kf_ingestion_text_internal(p_payload -> 'reasonCode', 'reasonCode') <> 'operator_cancelled' THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'cancel_ingestion reasonCode is invalid';
    END IF;
  END IF;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 4. Authorization, idempotency and snapshot helpers
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_ingestion_assert_authorization_internal(
  p_authorization_id uuid,
  p_source_version_id uuid,
  p_purpose text,
  p_evaluated_at timestamptz
)
RETURNS void
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM public.kf_source_authorizations AS authorization
    WHERE authorization.id = p_authorization_id
      AND authorization.subject_identity_id = p_source_version_id
      AND authorization.purpose = p_purpose
      AND authorization.projected_state = 'GRANTED'
      AND p_evaluated_at >= authorization.effective_from
      AND (authorization.effective_until IS NULL OR p_evaluated_at <= authorization.effective_until)
  ) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'required source authorization is not currently valid';
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_command_precheck_internal(
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
  PERFORM public.kf_ingestion_validate_command_payload_internal(p_operation, p_payload);
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

CREATE OR REPLACE FUNCTION public.kf_ingestion_receipt_result_internal(
  p_command_id uuid,
  p_replayed boolean
)
RETURNS TABLE(
  command_id uuid,
  fingerprint text,
  correlation_id uuid,
  operation text,
  run_id uuid,
  aggregate_version text,
  sequence bigint,
  event_ids uuid[],
  previous_state text,
  state text,
  replayed boolean,
  committed_at timestamptz,
  reason_code text
)
LANGUAGE sql
STABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT
    receipt.command_id,
    receipt.fingerprint,
    receipt.correlation_id,
    receipt.operation,
    receipt.run_id,
    receipt.aggregate_version,
    receipt.sequence,
    coalesce(array_agg(event.event_id ORDER BY event.sequence) FILTER (WHERE event.event_id IS NOT NULL), '{}'::uuid[]),
    receipt.previous_state,
    receipt.state,
    p_replayed,
    receipt.committed_at,
    receipt.reason_code
  FROM public.kf_ingestion_command_receipts AS receipt
  LEFT JOIN public.kf_ingestion_events AS event ON event.command_id = receipt.command_id
  WHERE receipt.command_id = p_command_id
  GROUP BY receipt.command_id
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_receipt_json_internal(p_command_id uuid)
RETURNS jsonb
LANGUAGE sql
STABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT jsonb_build_object(
    'contractVersion','1.0.0',
    'commandId', r.command_id,
    'fingerprint', r.fingerprint,
    'correlationId', r.correlation_id,
    'operation', r.operation,
    'run', jsonb_build_object('kind','processing_run','id',r.run_id),
    'aggregateVersion', r.aggregate_version,
    'sequence', r.sequence,
    'eventIds', to_jsonb(coalesce((
      SELECT array_agg(e.event_id ORDER BY e.sequence)
      FROM public.kf_ingestion_events AS e WHERE e.command_id = r.command_id
    ), '{}'::uuid[])),
    'previousState', r.previous_state,
    'state', r.state,
    'outcome', 'applied',
    'committedAt', r.committed_at,
    'reasonCode', r.reason_code
  )
  FROM public.kf_ingestion_command_receipts AS r
  WHERE r.command_id = p_command_id
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_run_snapshot_json_internal(p_run_id uuid)
RETURNS jsonb
LANGUAGE sql
STABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT jsonb_build_object(
    'contractVersion','1.0.0',
    'requestId', run.request_id,
    'run', jsonb_build_object('kind','processing_run','id',run.run_id),
    'sourceVersion', jsonb_build_object('kind','source_version','id',run.source_version_id),
    'receivedFile', jsonb_build_object('kind','received_file','id',run.received_file_id),
    'state', run.state,
    'aggregateVersion', run.aggregate_version,
    'sequence', run.sequence,
    'requestedAt', run.requested_at,
    'createdAt', run.created_at,
    'updatedAt', run.updated_at
  )
  FROM public.kf_ingestion_runs AS run
  WHERE run.run_id = p_run_id
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_artifact_snapshot_json_internal(p_artifact_id uuid)
RETURNS jsonb
LANGUAGE sql
STABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT jsonb_build_object(
    'contractVersion','1.0.0',
    'artifactId', artifact.artifact_id,
    'run', jsonb_build_object('kind','processing_run','id',artifact.run_id),
    'sourceVersion', jsonb_build_object('kind','source_version','id',artifact.source_version_id),
    'receivedFile', jsonb_build_object('kind','received_file','id',artifact.received_file_id),
    'state', artifact.state,
    'sizeBytes', artifact.size_bytes,
    'mediaType', artifact.media_type,
    'createdAt', artifact.created_at,
    'expiresAt', artifact.expires_at,
    'opaqueLocator', artifact.opaque_locator,
    'writeIntentDigest', jsonb_build_object(
      'algorithm', artifact.write_digest_algorithm,
      'value', artifact.write_digest_value
    ),
    'correlationId', artifact.correlation_id,
    'discard', CASE WHEN artifact.discard_requested_at IS NULL THEN NULL ELSE jsonb_build_object(
      'requestedAt', artifact.discard_requested_at,
      'confirmedAt', artifact.discard_confirmed_at,
      'reasonCode', artifact.discard_reason_code,
      'outcome', artifact.discard_outcome,
      'correlationId', artifact.discard_correlation_id
    ) END
  )
  FROM public.kf_ingestion_staging_artifacts AS artifact
  WHERE artifact.artifact_id = p_artifact_id
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_integrity_snapshot_json_internal(p_artifact_id uuid)
RETURNS jsonb
LANGUAGE sql
STABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT jsonb_build_object(
    'evidence', jsonb_build_object(
      'contractVersion','1.0.0',
      'artifactId', evidence.artifact_id,
      'run', jsonb_build_object('kind','processing_run','id',evidence.run_id),
      'sourceVersion', jsonb_build_object('kind','source_version','id',evidence.source_version_id),
      'receivedFile', jsonb_build_object('kind','received_file','id',evidence.received_file_id),
      'digest', jsonb_build_object('algorithm',evidence.digest_algorithm,'value',evidence.digest_value),
      'byteLength', evidence.byte_length,
      'verifiedAt', evidence.verified_at,
      'correlationId', evidence.correlation_id
    ),
    'duplicateDecision', evidence.duplicate_decision
  )
  FROM public.kf_ingestion_integrity_evidence AS evidence
  WHERE evidence.artifact_id = p_artifact_id
$function$;

-- ---------------------------------------------------------------------------
-- 5. Run locking and atomic transition helpers
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_ingestion_lock_run_internal(p_payload jsonb)
RETURNS public.kf_ingestion_runs
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_run_id uuid;
  v_expected_state text;
  v_run public.kf_ingestion_runs%ROWTYPE;
BEGIN
  v_run_id := public.kf_ingestion_ref_uuid_internal(p_payload -> 'run', 'processing_run', 'run');
  v_expected_state := public.kf_ingestion_text_internal(p_payload -> 'expectedState', 'expectedState');
  SELECT * INTO v_run FROM public.kf_ingestion_runs WHERE run_id = v_run_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'ingestion run was not found';
  END IF;
  IF v_run.state <> v_expected_state THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'ingestion expectedState does not match persisted state';
  END IF;
  IF p_payload ? 'expectedVersion'
    AND v_run.aggregate_version <> public.kf_ingestion_text_internal(p_payload -> 'expectedVersion', 'expectedVersion') THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'ingestion aggregate version does not match command expectation';
  END IF;
  IF p_payload ? 'expectedSequence'
    AND v_run.sequence <> public.kf_ingestion_positive_bigint_internal(p_payload -> 'expectedSequence', 'expectedSequence') THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'ingestion aggregate sequence does not match command expectation';
  END IF;
  RETURN v_run;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_commit_transition_internal(
  p_operation text,
  p_event_type text,
  p_to_state text,
  p_reason_code text,
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb,
  p_run public.kf_ingestion_runs
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_last_event public.kf_ingestion_events%ROWTYPE;
  v_new_version text := gen_random_uuid()::text;
  v_new_sequence bigint := p_run.sequence + 1;
  v_event_id uuid := gen_random_uuid();
  v_actor_id uuid;
  v_actor_role text;
  v_reason text;
  v_occurred_at timestamptz;
  v_correlation_id uuid;
BEGIN
  v_actor_id := public.kf_ingestion_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_actor_role := public.kf_ingestion_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_reason := public.kf_ingestion_text_internal(p_payload -> 'reason', 'reason');
  v_occurred_at := public.kf_ingestion_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  v_correlation_id := public.kf_ingestion_uuid_internal(p_payload -> 'correlationId', 'correlationId');

  SELECT * INTO v_last_event
  FROM public.kf_ingestion_events
  WHERE run_id = p_run.run_id
  ORDER BY sequence DESC LIMIT 1;
  IF NOT FOUND OR v_last_event.sequence <> p_run.sequence
    OR v_last_event.aggregate_version <> p_run.aggregate_version THEN
    RAISE EXCEPTION USING ERRCODE = '23514', MESSAGE = 'ingestion run projection and history are inconsistent';
  END IF;
  IF v_occurred_at < v_last_event.occurred_at THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'ingestion event would regress committed temporal order';
  END IF;

  UPDATE public.kf_ingestion_runs
  SET state = p_to_state,
      aggregate_version = v_new_version,
      sequence = v_new_sequence,
      updated_at = clock_timestamp()
  WHERE run_id = p_run.run_id;

  INSERT INTO public.kf_ingestion_command_receipts(
    command_id, fingerprint, correlation_id, operation, run_id,
    aggregate_version, sequence, previous_state, state, reason_code
  ) VALUES (
    p_command_id, p_fingerprint, v_correlation_id, p_operation, p_run.run_id,
    v_new_version, v_new_sequence, p_run.state, p_to_state, p_reason_code
  );

  INSERT INTO public.kf_ingestion_events(
    event_id, event_type, run_id, aggregate_version, sequence,
    actor_id, actor_role, reason, occurred_at, correlation_id, command_id,
    from_state, to_state, reason_code
  ) VALUES (
    v_event_id, p_event_type, p_run.run_id, v_new_version, v_new_sequence,
    v_actor_id, v_actor_role, v_reason, v_occurred_at, v_correlation_id, p_command_id,
    p_run.state, p_to_state, p_reason_code
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_generic_transition_internal(
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
  v_event_type text;
  v_to_state text;
  v_reason_code text;
BEGIN
  v_run := public.kf_ingestion_lock_run_internal(p_payload);

  IF p_operation = 'begin_staging' THEN
    IF v_run.state <> 'REQUESTED' THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'begin_staging transition is not allowed';
    END IF;
    v_event_type := 'ingestion_staging_started'; v_to_state := 'STAGING';
  ELSIF p_operation = 'fail_ingestion' THEN
    IF v_run.state IN ('APPROVED_FOR_EXTRACTION','REJECTED','FAILED','CANCELLED') THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'terminal ingestion run cannot fail again';
    END IF;
    v_event_type := 'ingestion_failed'; v_to_state := 'FAILED'; v_reason_code := 'technical_failure';
  ELSIF p_operation = 'cancel_ingestion' THEN
    IF v_run.state IN ('APPROVED_FOR_EXTRACTION','REJECTED','FAILED','CANCELLED') THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'terminal ingestion run cannot be cancelled';
    END IF;
    v_event_type := 'ingestion_cancelled'; v_to_state := 'CANCELLED'; v_reason_code := 'operator_cancelled';
  ELSE
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'generic ingestion transition is invalid';
  END IF;

  PERFORM public.kf_ingestion_commit_transition_internal(
    p_operation, v_event_type, v_to_state, v_reason_code,
    p_command_id, p_fingerprint, p_payload, v_run
  );
END;
$function$;

-- ---------------------------------------------------------------------------
-- 6. Request, staging and verification internals
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_ingestion_request_internal(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_request jsonb := p_payload -> 'request';
  v_run_id uuid;
  v_request_id uuid;
  v_source_version_id uuid;
  v_received_file_id uuid;
  v_requested_by_actor_id uuid;
  v_requested_by_actor_role text;
  v_requested_at timestamptz;
  v_actor_id uuid;
  v_actor_role text;
  v_reason text;
  v_occurred_at timestamptz;
  v_correlation_id uuid;
  v_version text := gen_random_uuid()::text;
  v_event_id uuid := gen_random_uuid();
  v_evidence jsonb;
  v_evidence_source_id uuid;
  v_authorization_id uuid;
  v_purpose text;
  v_evaluated_at timestamptz;
  v_has_staging boolean := false;
  v_has_ingestion boolean := false;
BEGIN
  PERFORM public.kf_ingestion_assert_object_internal(
    v_request,
    ARRAY['requestId','sourceVersion','receivedFile','run','requestedBy','requestedAt','authorizationEvidence'],
    ARRAY['requestId','sourceVersion','receivedFile','run','requestedBy','requestedAt','authorizationEvidence'],
    'request'
  );
  v_request_id := public.kf_ingestion_uuid_internal(v_request -> 'requestId', 'request.requestId');
  v_source_version_id := public.kf_ingestion_ref_uuid_internal(v_request -> 'sourceVersion', 'source_version', 'request.sourceVersion');
  v_received_file_id := public.kf_ingestion_ref_uuid_internal(v_request -> 'receivedFile', 'received_file', 'request.receivedFile');
  v_run_id := public.kf_ingestion_ref_uuid_internal(v_request -> 'run', 'processing_run', 'request.run');
  PERFORM public.kf_ingestion_assert_actor_internal(v_request -> 'requestedBy', 'request.requestedBy');
  v_requested_by_actor_id := public.kf_ingestion_uuid_internal(v_request -> 'requestedBy' -> 'actorId', 'request.requestedBy.actorId');
  v_requested_by_actor_role := public.kf_ingestion_text_internal(v_request -> 'requestedBy' -> 'role', 'request.requestedBy.role');
  v_requested_at := public.kf_ingestion_timestamp_internal(v_request -> 'requestedAt', 'request.requestedAt');

  IF jsonb_typeof(v_request -> 'authorizationEvidence') <> 'array' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'request.authorizationEvidence must be an array';
  END IF;
  FOR v_evidence IN SELECT value FROM jsonb_array_elements(v_request -> 'authorizationEvidence') LOOP
    PERFORM public.kf_ingestion_assert_object_internal(
      v_evidence,
      ARRAY['authorizationId','sourceVersion','purpose','evaluatedAt'],
      ARRAY['authorizationId','sourceVersion','purpose','evaluatedAt'],
      'authorizationEvidence item'
    );
    v_authorization_id := public.kf_ingestion_uuid_internal(v_evidence -> 'authorizationId', 'authorizationEvidence.authorizationId');
    v_evidence_source_id := public.kf_ingestion_ref_uuid_internal(v_evidence -> 'sourceVersion', 'source_version', 'authorizationEvidence.sourceVersion');
    IF v_evidence_source_id <> v_source_version_id THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'authorization evidence sourceVersion does not match request';
    END IF;
    v_purpose := public.kf_ingestion_text_internal(v_evidence -> 'purpose', 'authorizationEvidence.purpose');
    IF NOT (v_purpose = ANY(ARRAY['temporary_staging','ingestion','extraction'])) THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'authorization evidence purpose is outside ingestion';
    END IF;
    v_evaluated_at := public.kf_ingestion_timestamp_internal(v_evidence -> 'evaluatedAt', 'authorizationEvidence.evaluatedAt');
    PERFORM public.kf_ingestion_assert_authorization_internal(
      v_authorization_id, v_source_version_id, v_purpose, v_evaluated_at
    );
    v_has_staging := v_has_staging OR v_purpose = 'temporary_staging';
    v_has_ingestion := v_has_ingestion OR v_purpose = 'ingestion';
  END LOOP;
  IF NOT v_has_staging OR NOT v_has_ingestion THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'temporary_staging and ingestion authorization evidence are both required';
  END IF;

  PERFORM public.kf_ingestion_assert_identity_kind_internal(v_source_version_id, 'source_version');
  PERFORM public.kf_ingestion_assert_identity_kind_internal(v_received_file_id, 'received_file');
  PERFORM pg_advisory_xact_lock(hashtextextended('ingestion-run:' || v_run_id::text, 0));
  IF EXISTS (SELECT 1 FROM public.kf_source_identities WHERE id = v_run_id)
    OR EXISTS (SELECT 1 FROM public.kf_ingestion_runs WHERE run_id = v_run_id) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'processing_run identity already exists';
  END IF;
  IF EXISTS (SELECT 1 FROM public.kf_ingestion_runs WHERE request_id = v_request_id) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'ingestion requestId already exists';
  END IF;

  v_actor_id := public.kf_ingestion_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_actor_role := public.kf_ingestion_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_reason := public.kf_ingestion_text_internal(p_payload -> 'reason', 'reason');
  v_occurred_at := public.kf_ingestion_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  v_correlation_id := public.kf_ingestion_uuid_internal(p_payload -> 'correlationId', 'correlationId');

  INSERT INTO public.kf_source_identities(id, kind) VALUES (v_run_id, 'processing_run');
  INSERT INTO public.kf_ingestion_runs(
    run_id, request_id, source_version_id, received_file_id,
    requested_by_actor_id, requested_by_actor_role, requested_at,
    state, aggregate_version, sequence
  ) VALUES (
    v_run_id, v_request_id, v_source_version_id, v_received_file_id,
    v_requested_by_actor_id, v_requested_by_actor_role, v_requested_at,
    'REQUESTED', v_version, 1
  );
  INSERT INTO public.kf_ingestion_command_receipts(
    command_id, fingerprint, correlation_id, operation, run_id,
    aggregate_version, sequence, previous_state, state
  ) VALUES (
    p_command_id, p_fingerprint, v_correlation_id, 'request_ingestion', v_run_id,
    v_version, 1, NULL, 'REQUESTED'
  );
  INSERT INTO public.kf_ingestion_events(
    event_id, event_type, run_id, aggregate_version, sequence,
    actor_id, actor_role, reason, occurred_at, correlation_id, command_id,
    from_state, to_state
  ) VALUES (
    v_event_id, 'ingestion_requested', v_run_id, v_version, 1,
    v_actor_id, v_actor_role, v_reason, v_occurred_at, v_correlation_id, p_command_id,
    NULL, 'REQUESTED'
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_mark_staged_internal(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb,
  p_artifact jsonb
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_run public.kf_ingestion_runs%ROWTYPE;
  v_artifact public.kf_ingestion_staging_artifacts%ROWTYPE;
  v_artifact_id uuid;
  v_locator text;
  v_artifact_run_id uuid;
  v_source_version_id uuid;
  v_received_file_id uuid;
  v_size bigint;
  v_media_type text;
  v_created_at timestamptz;
  v_expires_at timestamptz;
  v_occurred_at timestamptz;
BEGIN
  v_run := public.kf_ingestion_lock_run_internal(p_payload);
  IF v_run.state <> 'STAGING' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'mark_staged transition is not allowed';
  END IF;
  PERFORM public.kf_ingestion_assert_object_internal(
    p_artifact,
    ARRAY['artifact','run','sourceVersion','receivedFile','sizeBytes','mediaType','createdAt','expiresAt'],
    ARRAY['artifact','run','sourceVersion','receivedFile','sizeBytes','mediaType','createdAt','expiresAt'],
    'staged artifact confirmation'
  );
  PERFORM public.kf_ingestion_assert_object_internal(
    p_artifact -> 'artifact', ARRAY['artifactId','opaqueLocator'], ARRAY['artifactId','opaqueLocator'], 'artifact'
  );
  v_artifact_id := public.kf_ingestion_uuid_internal(p_artifact -> 'artifact' -> 'artifactId', 'artifact.artifactId');
  v_locator := public.kf_ingestion_text_internal(p_artifact -> 'artifact' -> 'opaqueLocator', 'artifact.opaqueLocator');
  IF v_artifact_id <> public.kf_ingestion_uuid_internal(p_payload -> 'stagingArtifact' -> 'artifactId', 'stagingArtifact.artifactId')
    OR v_locator <> public.kf_ingestion_text_internal(p_payload -> 'stagingArtifact' -> 'opaqueLocator', 'stagingArtifact.opaqueLocator') THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'mark_staged artifact does not match command';
  END IF;
  v_artifact_run_id := public.kf_ingestion_ref_uuid_internal(p_artifact -> 'run', 'processing_run', 'artifact.run');
  v_source_version_id := public.kf_ingestion_ref_uuid_internal(p_artifact -> 'sourceVersion', 'source_version', 'artifact.sourceVersion');
  v_received_file_id := public.kf_ingestion_ref_uuid_internal(p_artifact -> 'receivedFile', 'received_file', 'artifact.receivedFile');
  v_size := public.kf_ingestion_positive_bigint_internal(p_artifact -> 'sizeBytes', 'artifact.sizeBytes');
  v_media_type := public.kf_ingestion_text_internal(p_artifact -> 'mediaType', 'artifact.mediaType');
  v_created_at := public.kf_ingestion_timestamp_internal(p_artifact -> 'createdAt', 'artifact.createdAt');
  v_expires_at := public.kf_ingestion_timestamp_internal(p_artifact -> 'expiresAt', 'artifact.expiresAt');
  v_occurred_at := public.kf_ingestion_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');

  SELECT * INTO v_artifact FROM public.kf_ingestion_staging_artifacts
  WHERE artifact_id = v_artifact_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'prepared staging artifact was not found';
  END IF;
  IF v_artifact.run_id <> v_run.run_id
    OR v_artifact_run_id <> v_run.run_id
    OR v_artifact.source_version_id <> v_source_version_id
    OR v_artifact.received_file_id <> v_received_file_id
    OR v_source_version_id <> v_run.source_version_id
    OR v_received_file_id <> v_run.received_file_id
    OR v_artifact.size_bytes <> v_size
    OR v_artifact.media_type <> v_media_type
    OR v_artifact.created_at <> v_created_at
    OR v_artifact.expires_at <> v_expires_at THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'staged artifact confirmation conflicts with prepared recovery record';
  END IF;
  IF v_artifact.state <> 'RECEIVING' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'staging artifact is not awaiting physical confirmation';
  END IF;
  IF v_occurred_at >= v_artifact.expires_at THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'expired staging artifact cannot be marked STAGED';
  END IF;
  IF p_payload ? 'technicalMetadata' THEN
    IF p_payload -> 'technicalMetadata' ? 'sizeBytes'
      AND public.kf_ingestion_positive_bigint_internal(p_payload -> 'technicalMetadata' -> 'sizeBytes', 'technicalMetadata.sizeBytes') <> v_size THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'mark_staged byte length conflicts with prepared artifact';
    END IF;
    IF p_payload -> 'technicalMetadata' ? 'declaredMediaType'
      AND public.kf_ingestion_text_internal(p_payload -> 'technicalMetadata' -> 'declaredMediaType', 'technicalMetadata.declaredMediaType') <> v_media_type THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'mark_staged media type conflicts with prepared artifact';
    END IF;
  END IF;

  UPDATE public.kf_ingestion_staging_artifacts
  SET state = 'STAGED', opaque_locator = v_locator, updated_at = clock_timestamp()
  WHERE artifact_id = v_artifact_id;

  PERFORM public.kf_ingestion_commit_transition_internal(
    'mark_staged','ingestion_staged','STAGED',NULL,
    p_command_id,p_fingerprint,p_payload,v_run
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_begin_verification_internal(
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
  v_artifact public.kf_ingestion_staging_artifacts%ROWTYPE;
  v_occurred_at timestamptz;
BEGIN
  v_run := public.kf_ingestion_lock_run_internal(p_payload);
  IF v_run.state <> 'STAGED' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'begin_verification transition is not allowed';
  END IF;
  SELECT * INTO v_artifact
  FROM public.kf_ingestion_staging_artifacts
  WHERE run_id = v_run.run_id
  ORDER BY created_at, artifact_id
  LIMIT 1 FOR UPDATE;
  IF NOT FOUND OR v_artifact.state <> 'STAGED' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'run does not have a recoverable STAGED artifact';
  END IF;
  v_occurred_at := public.kf_ingestion_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  IF v_occurred_at >= v_artifact.expires_at THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'expired staging artifact cannot begin verification';
  END IF;
  PERFORM public.kf_ingestion_commit_transition_internal(
    'begin_verification','ingestion_verification_started','VERIFYING',NULL,
    p_command_id,p_fingerprint,p_payload,v_run
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_duplicate_decision_internal(
  p_artifact_id uuid,
  p_run_id uuid,
  p_source_version_id uuid,
  p_digest_algorithm text,
  p_digest_value text,
  p_evaluated_at timestamptz
)
RETURNS jsonb
LANGUAGE sql
STABLE
SET search_path = pg_catalog, public
AS $function$
  WITH matches AS (
    SELECT jsonb_build_object(
      'relationship', CASE
        WHEN evidence.run_id = p_run_id THEN 'same_run'
        WHEN evidence.source_version_id = p_source_version_id THEN 'same_source_version'
        ELSE 'cross_source_version'
      END,
      'artifactId', evidence.artifact_id,
      'run', jsonb_build_object('kind','processing_run','id',evidence.run_id),
      'sourceVersion', jsonb_build_object('kind','source_version','id',evidence.source_version_id),
      'receivedFile', jsonb_build_object('kind','received_file','id',evidence.received_file_id)
    ) AS item
    FROM public.kf_ingestion_integrity_evidence AS evidence
    WHERE evidence.artifact_id <> p_artifact_id
      AND evidence.digest_algorithm = p_digest_algorithm
      AND evidence.digest_value = p_digest_value
    ORDER BY evidence.artifact_id
  ), aggregated AS (
    SELECT coalesce(jsonb_agg(item), '[]'::jsonb) AS items FROM matches
  )
  SELECT jsonb_build_object(
    'contractVersion','1.0.0',
    'digest',jsonb_build_object('algorithm',p_digest_algorithm,'value',p_digest_value),
    'outcome',CASE WHEN jsonb_array_length(items) = 0 THEN 'unique' ELSE 'duplicate' END,
    'matches',items,
    'evaluatedAt',p_evaluated_at
  ) FROM aggregated
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_confirm_verified_internal(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb,
  p_verification jsonb
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_run public.kf_ingestion_runs%ROWTYPE;
  v_artifact public.kf_ingestion_staging_artifacts%ROWTYPE;
  v_artifact_id uuid;
  v_locator text;
  v_integrity jsonb;
  v_digest_algorithm text;
  v_digest_value text;
  v_byte_length bigint;
  v_verified_at timestamptz;
  v_evidence_correlation uuid;
  v_command_correlation uuid;
  v_occurred_at timestamptz;
  v_duplicate_decision jsonb;
BEGIN
  v_run := public.kf_ingestion_lock_run_internal(p_payload);
  IF v_run.state <> 'VERIFYING' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'confirm_verified transition is not allowed';
  END IF;
  PERFORM public.kf_ingestion_assert_object_internal(
    p_verification,
    ARRAY['artifact','run','sourceVersion','receivedFile','sizeBytes','mediaType','createdAt','expiresAt','integrity'],
    ARRAY['artifact','run','sourceVersion','receivedFile','sizeBytes','mediaType','createdAt','expiresAt','integrity'],
    'verification'
  );
  PERFORM public.kf_ingestion_assert_object_internal(
    p_verification -> 'artifact', ARRAY['artifactId','opaqueLocator'], ARRAY['artifactId','opaqueLocator'], 'verification.artifact'
  );
  v_artifact_id := public.kf_ingestion_uuid_internal(p_verification -> 'artifact' -> 'artifactId', 'verification.artifact.artifactId');
  v_locator := public.kf_ingestion_text_internal(p_verification -> 'artifact' -> 'opaqueLocator', 'verification.artifact.opaqueLocator');
  IF public.kf_ingestion_ref_uuid_internal(p_verification -> 'run', 'processing_run', 'verification.run') <> v_run.run_id
    OR public.kf_ingestion_ref_uuid_internal(p_verification -> 'sourceVersion', 'source_version', 'verification.sourceVersion') <> v_run.source_version_id
    OR public.kf_ingestion_ref_uuid_internal(p_verification -> 'receivedFile', 'received_file', 'verification.receivedFile') <> v_run.received_file_id THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'verification identity binding does not match run';
  END IF;

  SELECT * INTO v_artifact FROM public.kf_ingestion_staging_artifacts
  WHERE artifact_id = v_artifact_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'staged artifact was not found for verification';
  END IF;
  IF v_artifact.run_id <> v_run.run_id
    OR v_artifact.source_version_id <> v_run.source_version_id
    OR v_artifact.received_file_id <> v_run.received_file_id
    OR v_artifact.state <> 'STAGED'
    OR v_artifact.opaque_locator <> v_locator
    OR v_artifact.size_bytes <> public.kf_ingestion_positive_bigint_internal(p_verification -> 'sizeBytes', 'verification.sizeBytes')
    OR v_artifact.media_type <> public.kf_ingestion_text_internal(p_verification -> 'mediaType', 'verification.mediaType')
    OR v_artifact.created_at <> public.kf_ingestion_timestamp_internal(p_verification -> 'createdAt', 'verification.createdAt')
    OR v_artifact.expires_at <> public.kf_ingestion_timestamp_internal(p_verification -> 'expiresAt', 'verification.expiresAt') THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'verification descriptor conflicts with staged artifact';
  END IF;

  v_integrity := p_verification -> 'integrity';
  PERFORM public.kf_ingestion_assert_object_internal(
    v_integrity,
    ARRAY['contractVersion','artifactId','run','sourceVersion','receivedFile','digest','byteLength','verifiedAt','correlationId'],
    ARRAY['contractVersion','artifactId','run','sourceVersion','receivedFile','digest','byteLength','verifiedAt','correlationId'],
    'verification.integrity'
  );
  IF public.kf_ingestion_text_internal(v_integrity -> 'contractVersion', 'integrity.contractVersion') <> '1.0.0'
    OR public.kf_ingestion_uuid_internal(v_integrity -> 'artifactId', 'integrity.artifactId') <> v_artifact_id
    OR public.kf_ingestion_ref_uuid_internal(v_integrity -> 'run', 'processing_run', 'integrity.run') <> v_run.run_id
    OR public.kf_ingestion_ref_uuid_internal(v_integrity -> 'sourceVersion', 'source_version', 'integrity.sourceVersion') <> v_run.source_version_id
    OR public.kf_ingestion_ref_uuid_internal(v_integrity -> 'receivedFile', 'received_file', 'integrity.receivedFile') <> v_run.received_file_id THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'integrity evidence binding is invalid';
  END IF;
  PERFORM public.kf_ingestion_assert_object_internal(
    v_integrity -> 'digest', ARRAY['algorithm','value'], ARRAY['algorithm','value'], 'integrity.digest'
  );
  v_digest_algorithm := public.kf_ingestion_text_internal(v_integrity -> 'digest' -> 'algorithm', 'integrity.digest.algorithm');
  v_digest_value := public.kf_ingestion_text_internal(v_integrity -> 'digest' -> 'value', 'integrity.digest.value');
  IF v_digest_algorithm <> 'sha-256' OR v_digest_value !~ '^[0-9a-f]{64}$' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'integrity digest is not canonical SHA-256';
  END IF;
  v_byte_length := public.kf_ingestion_positive_bigint_internal(v_integrity -> 'byteLength', 'integrity.byteLength');
  IF v_byte_length <> v_artifact.size_bytes THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'integrity byte length conflicts with staged artifact';
  END IF;
  v_verified_at := public.kf_ingestion_timestamp_internal(v_integrity -> 'verifiedAt', 'integrity.verifiedAt');
  v_evidence_correlation := public.kf_ingestion_uuid_internal(v_integrity -> 'correlationId', 'integrity.correlationId');
  v_command_correlation := public.kf_ingestion_uuid_internal(p_payload -> 'correlationId', 'correlationId');
  v_occurred_at := public.kf_ingestion_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  IF v_evidence_correlation <> v_command_correlation
    OR v_verified_at < v_artifact.created_at
    OR v_verified_at > v_occurred_at
    OR v_verified_at >= v_artifact.expires_at
    OR v_occurred_at >= v_artifact.expires_at THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'integrity evidence time/correlation is invalid';
  END IF;
  IF p_payload ? 'technicalMetadata' THEN
    IF p_payload -> 'technicalMetadata' ? 'sizeBytes'
      AND public.kf_ingestion_positive_bigint_internal(p_payload -> 'technicalMetadata' -> 'sizeBytes', 'technicalMetadata.sizeBytes') <> v_byte_length THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'confirm_verified byte length conflicts with integrity evidence';
    END IF;
    IF p_payload -> 'technicalMetadata' ? 'declaredMediaType'
      AND public.kf_ingestion_text_internal(p_payload -> 'technicalMetadata' -> 'declaredMediaType', 'technicalMetadata.declaredMediaType') <> v_artifact.media_type THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'confirm_verified media type conflicts with staged artifact';
    END IF;
  END IF;
  IF EXISTS (SELECT 1 FROM public.kf_ingestion_integrity_evidence WHERE artifact_id = v_artifact_id) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'integrity evidence already exists without command replay';
  END IF;

  v_duplicate_decision := public.kf_ingestion_duplicate_decision_internal(
    v_artifact_id, v_run.run_id, v_run.source_version_id,
    v_digest_algorithm, v_digest_value, clock_timestamp()
  );
  INSERT INTO public.kf_ingestion_integrity_evidence(
    artifact_id, run_id, source_version_id, received_file_id,
    digest_algorithm, digest_value, byte_length, verified_at, correlation_id,
    duplicate_decision
  ) VALUES (
    v_artifact_id, v_run.run_id, v_run.source_version_id, v_run.received_file_id,
    v_digest_algorithm, v_digest_value, v_byte_length, v_verified_at, v_evidence_correlation,
    v_duplicate_decision
  );
  UPDATE public.kf_ingestion_staging_artifacts
  SET state = 'VERIFIED', updated_at = clock_timestamp()
  WHERE artifact_id = v_artifact_id;
  PERFORM public.kf_ingestion_commit_transition_internal(
    'confirm_verified','ingestion_verified','VERIFIED',NULL,
    p_command_id,p_fingerprint,p_payload,v_run
  );
END;
$function$;

-- ---------------------------------------------------------------------------
-- 7. Durable staging reservation, discard and recovery snapshots
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_ingestion_prepare_staging_artifact_internal(p_payload jsonb)
RETURNS jsonb
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_artifact_id uuid;
  v_run_id uuid;
  v_source_version_id uuid;
  v_received_file_id uuid;
  v_size bigint;
  v_media_type text;
  v_created_at timestamptz;
  v_expires_at timestamptz;
  v_digest_algorithm text;
  v_digest_value text;
  v_correlation_id uuid;
  v_run public.kf_ingestion_runs%ROWTYPE;
  v_existing public.kf_ingestion_staging_artifacts%ROWTYPE;
BEGIN
  PERFORM public.kf_ingestion_assert_object_internal(
    p_payload,
    ARRAY['artifactId','run','sourceVersion','receivedFile','sizeBytes','mediaType','createdAt','expiresAt','writeIntentDigest','correlationId'],
    ARRAY['artifactId','run','sourceVersion','receivedFile','sizeBytes','mediaType','createdAt','expiresAt','writeIntentDigest','correlationId'],
    'staging preparation'
  );
  v_artifact_id := public.kf_ingestion_uuid_internal(p_payload -> 'artifactId', 'artifactId');
  v_run_id := public.kf_ingestion_ref_uuid_internal(p_payload -> 'run', 'processing_run', 'run');
  v_source_version_id := public.kf_ingestion_ref_uuid_internal(p_payload -> 'sourceVersion', 'source_version', 'sourceVersion');
  v_received_file_id := public.kf_ingestion_ref_uuid_internal(p_payload -> 'receivedFile', 'received_file', 'receivedFile');
  v_size := public.kf_ingestion_positive_bigint_internal(p_payload -> 'sizeBytes', 'sizeBytes');
  v_media_type := public.kf_ingestion_text_internal(p_payload -> 'mediaType', 'mediaType');
  v_created_at := public.kf_ingestion_timestamp_internal(p_payload -> 'createdAt', 'createdAt');
  v_expires_at := public.kf_ingestion_timestamp_internal(p_payload -> 'expiresAt', 'expiresAt');
  PERFORM public.kf_ingestion_assert_object_internal(
    p_payload -> 'writeIntentDigest', ARRAY['algorithm','value'], ARRAY['algorithm','value'], 'writeIntentDigest'
  );
  v_digest_algorithm := public.kf_ingestion_text_internal(p_payload -> 'writeIntentDigest' -> 'algorithm', 'writeIntentDigest.algorithm');
  v_digest_value := public.kf_ingestion_text_internal(p_payload -> 'writeIntentDigest' -> 'value', 'writeIntentDigest.value');
  v_correlation_id := public.kf_ingestion_uuid_internal(p_payload -> 'correlationId', 'correlationId');
  IF v_digest_algorithm <> 'sha-256' OR v_digest_value !~ '^[0-9a-f]{64}$' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'writeIntentDigest must be canonical SHA-256';
  END IF;
  IF v_expires_at <= v_created_at THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'staging retention window is invalid';
  END IF;
  IF v_size > 50 * 1024 * 1024 THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'staging artifact exceeds C.2.2 hard safety ceiling';
  END IF;

  SELECT * INTO v_run FROM public.kf_ingestion_runs WHERE run_id = v_run_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'ingestion run was not found';
  END IF;
  IF v_run.state <> 'STAGING' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'staging artifact can only be prepared while run is STAGING';
  END IF;
  IF v_run.source_version_id <> v_source_version_id OR v_run.received_file_id <> v_received_file_id THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'staging preparation does not match run bindings';
  END IF;

  SELECT * INTO v_existing
  FROM public.kf_ingestion_staging_artifacts
  WHERE run_id = v_run_id
  ORDER BY created_at, artifact_id
  LIMIT 1 FOR UPDATE;
  IF FOUND THEN
    IF v_existing.artifact_id <> v_artifact_id THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'multi-artifact run aggregation is not defined by the C.2.4 durable boundary';
    END IF;
    IF v_existing.source_version_id <> v_source_version_id
      OR v_existing.received_file_id <> v_received_file_id
      OR v_existing.size_bytes <> v_size
      OR v_existing.media_type <> v_media_type
      OR v_existing.created_at <> v_created_at
      OR v_existing.expires_at <> v_expires_at
      OR v_existing.write_digest_algorithm <> v_digest_algorithm
      OR v_existing.write_digest_value <> v_digest_value
      OR v_existing.correlation_id <> v_correlation_id THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'artifactId was already prepared with different recovery metadata';
    END IF;
    RETURN public.kf_ingestion_artifact_snapshot_json_internal(v_artifact_id);
  END IF;

  INSERT INTO public.kf_ingestion_staging_artifacts(
    artifact_id, run_id, source_version_id, received_file_id, state,
    size_bytes, media_type, created_at, expires_at,
    write_digest_algorithm, write_digest_value, correlation_id
  ) VALUES (
    v_artifact_id, v_run_id, v_source_version_id, v_received_file_id, 'RECEIVING',
    v_size, v_media_type, v_created_at, v_expires_at,
    v_digest_algorithm, v_digest_value, v_correlation_id
  );
  RETURN public.kf_ingestion_artifact_snapshot_json_internal(v_artifact_id);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_prepare_discard_internal(p_payload jsonb)
RETURNS jsonb
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_artifact_id uuid;
  v_run_id uuid;
  v_locator text;
  v_requested_at timestamptz;
  v_reason_code text;
  v_correlation_id uuid;
  v_run public.kf_ingestion_runs%ROWTYPE;
  v_artifact public.kf_ingestion_staging_artifacts%ROWTYPE;
BEGIN
  PERFORM public.kf_ingestion_assert_object_internal(
    p_payload,
    ARRAY['artifact','run','requestedAt','reasonCode','correlationId'],
    ARRAY['artifact','run','requestedAt','reasonCode','correlationId'],
    'discard command'
  );
  PERFORM public.kf_ingestion_assert_object_internal(
    p_payload -> 'artifact', ARRAY['artifactId','opaqueLocator'], ARRAY['artifactId','opaqueLocator'], 'discard artifact'
  );
  v_artifact_id := public.kf_ingestion_uuid_internal(p_payload -> 'artifact' -> 'artifactId', 'artifact.artifactId');
  v_locator := public.kf_ingestion_text_internal(p_payload -> 'artifact' -> 'opaqueLocator', 'artifact.opaqueLocator');
  v_run_id := public.kf_ingestion_ref_uuid_internal(p_payload -> 'run', 'processing_run', 'run');
  v_requested_at := public.kf_ingestion_timestamp_internal(p_payload -> 'requestedAt', 'requestedAt');
  v_reason_code := public.kf_ingestion_text_internal(p_payload -> 'reasonCode', 'reasonCode');
  v_correlation_id := public.kf_ingestion_uuid_internal(p_payload -> 'correlationId', 'correlationId');
  IF NOT (v_reason_code = ANY(ARRAY[
    'success_after_stage','policy_rejected','operator_cancelled','technical_failure','retention_expired','orphan_cleanup'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'discard reasonCode is invalid';
  END IF;

  SELECT * INTO v_run FROM public.kf_ingestion_runs WHERE run_id = v_run_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'ingestion run was not found';
  END IF;
  SELECT * INTO v_artifact FROM public.kf_ingestion_staging_artifacts
  WHERE artifact_id = v_artifact_id FOR UPDATE;
  IF NOT FOUND OR v_artifact.run_id <> v_run_id THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'staging artifact was not found for run';
  END IF;
  IF v_artifact.opaque_locator IS NOT NULL AND v_artifact.opaque_locator <> v_locator THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'discard locator conflicts with persisted artifact';
  END IF;

  IF v_artifact.state IN ('DISCARD_PENDING','DISCARDED') THEN
    IF v_artifact.discard_requested_at <> v_requested_at
      OR v_artifact.discard_reason_code <> v_reason_code
      OR v_artifact.discard_correlation_id <> v_correlation_id THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'artifact already has a different discard request';
    END IF;
    RETURN public.kf_ingestion_artifact_snapshot_json_internal(v_artifact_id);
  END IF;

  IF v_requested_at < v_artifact.expires_at
    AND v_run.state NOT IN ('APPROVED_FOR_EXTRACTION','REJECTED','FAILED','CANCELLED') THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'unexpired artifact cannot be discarded while run remains recoverable';
  END IF;

  UPDATE public.kf_ingestion_staging_artifacts
  SET state = 'DISCARD_PENDING',
      opaque_locator = coalesce(opaque_locator, v_locator),
      discard_requested_at = v_requested_at,
      discard_reason_code = v_reason_code,
      discard_correlation_id = v_correlation_id,
      updated_at = clock_timestamp()
  WHERE artifact_id = v_artifact_id;
  RETURN public.kf_ingestion_artifact_snapshot_json_internal(v_artifact_id);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_confirm_discard_internal(p_receipt jsonb)
RETURNS jsonb
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_artifact_id uuid;
  v_run_id uuid;
  v_requested_at timestamptz;
  v_confirmed_at timestamptz;
  v_reason_code text;
  v_outcome text;
  v_correlation_id uuid;
  v_run public.kf_ingestion_runs%ROWTYPE;
  v_artifact public.kf_ingestion_staging_artifacts%ROWTYPE;
BEGIN
  PERFORM public.kf_ingestion_assert_object_internal(
    p_receipt,
    ARRAY['contractVersion','state','artifactId','run','requestedAt','confirmedAt','outcome','reasonCode','correlationId'],
    ARRAY['contractVersion','state','artifactId','run','requestedAt','confirmedAt','outcome','reasonCode','correlationId'],
    'discard receipt'
  );
  IF public.kf_ingestion_text_internal(p_receipt -> 'contractVersion', 'contractVersion') <> '1.0.0'
    OR public.kf_ingestion_text_internal(p_receipt -> 'state', 'state') <> 'DISCARDED' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'discard receipt contract/state is invalid';
  END IF;
  v_artifact_id := public.kf_ingestion_uuid_internal(p_receipt -> 'artifactId', 'artifactId');
  v_run_id := public.kf_ingestion_ref_uuid_internal(p_receipt -> 'run', 'processing_run', 'run');
  v_requested_at := public.kf_ingestion_timestamp_internal(p_receipt -> 'requestedAt', 'requestedAt');
  v_confirmed_at := public.kf_ingestion_timestamp_internal(p_receipt -> 'confirmedAt', 'confirmedAt');
  v_outcome := public.kf_ingestion_text_internal(p_receipt -> 'outcome', 'outcome');
  v_reason_code := public.kf_ingestion_text_internal(p_receipt -> 'reasonCode', 'reasonCode');
  v_correlation_id := public.kf_ingestion_uuid_internal(p_receipt -> 'correlationId', 'correlationId');
  IF v_outcome NOT IN ('discarded','already_discarded') OR v_confirmed_at < v_requested_at THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'discard receipt outcome/time is invalid';
  END IF;

  SELECT * INTO v_run FROM public.kf_ingestion_runs WHERE run_id = v_run_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'ingestion run was not found';
  END IF;
  SELECT * INTO v_artifact FROM public.kf_ingestion_staging_artifacts
  WHERE artifact_id = v_artifact_id FOR UPDATE;
  IF NOT FOUND OR v_artifact.run_id <> v_run_id THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'staging artifact was not found for run';
  END IF;
  IF v_artifact.discard_requested_at <> v_requested_at
    OR v_artifact.discard_reason_code <> v_reason_code
    OR v_artifact.discard_correlation_id <> v_correlation_id THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'discard receipt does not match prepared discard request';
  END IF;

  -- Lost response recovery: a second physical delete may legitimately return
  -- already_discarded. Once DB confirmation exists, preserve the first receipt.
  IF v_artifact.state = 'DISCARDED' THEN
    RETURN public.kf_ingestion_artifact_snapshot_json_internal(v_artifact_id);
  END IF;
  IF v_artifact.state <> 'DISCARD_PENDING' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'artifact is not awaiting discard confirmation';
  END IF;

  UPDATE public.kf_ingestion_staging_artifacts
  SET state = 'DISCARDED',
      discard_confirmed_at = v_confirmed_at,
      discard_outcome = v_outcome,
      updated_at = clock_timestamp()
  WHERE artifact_id = v_artifact_id;
  RETURN public.kf_ingestion_artifact_snapshot_json_internal(v_artifact_id);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_recovery_snapshot_internal(p_run_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_run jsonb;
  v_artifacts jsonb;
  v_integrity jsonb;
  v_latest_command_id uuid;
  v_latest_receipt jsonb;
BEGIN
  v_run := public.kf_ingestion_run_snapshot_json_internal(p_run_id);
  IF v_run IS NULL THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'ingestion run was not found';
  END IF;
  SELECT coalesce(jsonb_agg(
    public.kf_ingestion_artifact_snapshot_json_internal(a.artifact_id)
    ORDER BY a.created_at, a.artifact_id
  ), '[]'::jsonb)
  INTO v_artifacts
  FROM public.kf_ingestion_staging_artifacts AS a WHERE a.run_id = p_run_id;

  SELECT coalesce(jsonb_agg(
    public.kf_ingestion_integrity_snapshot_json_internal(e.artifact_id)
    ORDER BY e.verified_at, e.artifact_id
  ), '[]'::jsonb)
  INTO v_integrity
  FROM public.kf_ingestion_integrity_evidence AS e WHERE e.run_id = p_run_id;

  SELECT command_id INTO v_latest_command_id
  FROM public.kf_ingestion_command_receipts
  WHERE run_id = p_run_id ORDER BY sequence DESC LIMIT 1;
  IF v_latest_command_id IS NOT NULL THEN
    v_latest_receipt := public.kf_ingestion_receipt_json_internal(v_latest_command_id);
  END IF;

  RETURN jsonb_build_object(
    'contractVersion','1.0.0',
    'run',v_run,
    'artifacts',v_artifacts,
    'integrityEvidence',v_integrity,
    'latestReceipt',v_latest_receipt
  );
END;
$function$;

-- ---------------------------------------------------------------------------
-- 8. Narrow SECURITY DEFINER RPC surface
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_ingestion_request(
  p_command_id uuid, p_fingerprint text, p_payload jsonb
)
RETURNS TABLE(command_id uuid, fingerprint text, correlation_id uuid, operation text, run_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], previous_state text, state text, replayed boolean, committed_at timestamptz, reason_code text)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_ingestion_command_precheck_internal('request_ingestion',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_ingestion_request_internal(p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_begin_staging(
  p_command_id uuid, p_fingerprint text, p_payload jsonb
)
RETURNS TABLE(command_id uuid, fingerprint text, correlation_id uuid, operation text, run_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], previous_state text, state text, replayed boolean, committed_at timestamptz, reason_code text)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_ingestion_command_precheck_internal('begin_staging',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_ingestion_generic_transition_internal('begin_staging',p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_mark_staged(
  p_command_id uuid, p_fingerprint text, p_payload jsonb, p_artifact jsonb
)
RETURNS TABLE(command_id uuid, fingerprint text, correlation_id uuid, operation text, run_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], previous_state text, state text, replayed boolean, committed_at timestamptz, reason_code text)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_ingestion_command_precheck_internal('mark_staged',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_ingestion_mark_staged_internal(p_command_id,p_fingerprint,p_payload,p_artifact);
  RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_begin_verification(
  p_command_id uuid, p_fingerprint text, p_payload jsonb
)
RETURNS TABLE(command_id uuid, fingerprint text, correlation_id uuid, operation text, run_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], previous_state text, state text, replayed boolean, committed_at timestamptz, reason_code text)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_ingestion_command_precheck_internal('begin_verification',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_ingestion_begin_verification_internal(p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_confirm_verified(
  p_command_id uuid, p_fingerprint text, p_payload jsonb, p_verification jsonb
)
RETURNS TABLE(command_id uuid, fingerprint text, correlation_id uuid, operation text, run_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], previous_state text, state text, replayed boolean, committed_at timestamptz, reason_code text)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_artifact_id uuid;
  v_existing public.kf_ingestion_integrity_evidence%ROWTYPE;
  v_integrity jsonb;
BEGIN
  IF public.kf_ingestion_command_precheck_internal('confirm_verified',p_command_id,p_fingerprint,p_payload) THEN
    -- Replayed command must not accept divergent supplemental evidence.
    v_artifact_id := public.kf_ingestion_uuid_internal(p_verification -> 'artifact' -> 'artifactId', 'verification.artifact.artifactId');
    v_integrity := p_verification -> 'integrity';
    SELECT * INTO v_existing FROM public.kf_ingestion_integrity_evidence WHERE artifact_id = v_artifact_id;
    IF NOT FOUND
      OR v_existing.digest_algorithm <> public.kf_ingestion_text_internal(v_integrity -> 'digest' -> 'algorithm', 'integrity.digest.algorithm')
      OR v_existing.digest_value <> public.kf_ingestion_text_internal(v_integrity -> 'digest' -> 'value', 'integrity.digest.value')
      OR v_existing.byte_length <> public.kf_ingestion_positive_bigint_internal(v_integrity -> 'byteLength', 'integrity.byteLength')
      OR v_existing.correlation_id <> public.kf_ingestion_uuid_internal(v_integrity -> 'correlationId', 'integrity.correlationId') THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'replayed confirm_verified supplied divergent integrity evidence';
    END IF;
    RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_ingestion_confirm_verified_internal(p_command_id,p_fingerprint,p_payload,p_verification);
  RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_fail(
  p_command_id uuid, p_fingerprint text, p_payload jsonb
)
RETURNS TABLE(command_id uuid, fingerprint text, correlation_id uuid, operation text, run_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], previous_state text, state text, replayed boolean, committed_at timestamptz, reason_code text)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_ingestion_command_precheck_internal('fail_ingestion',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_ingestion_generic_transition_internal('fail_ingestion',p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_cancel(
  p_command_id uuid, p_fingerprint text, p_payload jsonb
)
RETURNS TABLE(command_id uuid, fingerprint text, correlation_id uuid, operation text, run_id uuid, aggregate_version text, sequence bigint, event_ids uuid[], previous_state text, state text, replayed boolean, committed_at timestamptz, reason_code text)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_ingestion_command_precheck_internal('cancel_ingestion',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_ingestion_generic_transition_internal('cancel_ingestion',p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_ingestion_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_prepare_staging_artifact(p_payload jsonb)
RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_ingestion_prepare_staging_artifact_internal(p_payload);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_prepare_discard(p_payload jsonb)
RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_ingestion_prepare_discard_internal(p_payload);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_confirm_discard(p_receipt jsonb)
RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_ingestion_confirm_discard_internal(p_receipt);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_ingestion_recovery_snapshot(p_run_id uuid)
RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER STABLE SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_ingestion_recovery_snapshot_internal(p_run_id);
END;
$function$;

-- ---------------------------------------------------------------------------
-- 9. Ownership, RLS and least privilege
-- ---------------------------------------------------------------------------
ALTER TABLE public.kf_ingestion_runs OWNER TO postgres;
ALTER TABLE public.kf_ingestion_command_receipts OWNER TO postgres;
ALTER TABLE public.kf_ingestion_events OWNER TO postgres;
ALTER TABLE public.kf_ingestion_staging_artifacts OWNER TO postgres;
ALTER TABLE public.kf_ingestion_integrity_evidence OWNER TO postgres;

ALTER TABLE public.kf_ingestion_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_ingestion_command_receipts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_ingestion_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_ingestion_staging_artifacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_ingestion_integrity_evidence ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE
  public.kf_ingestion_runs,
  public.kf_ingestion_command_receipts,
  public.kf_ingestion_events,
  public.kf_ingestion_staging_artifacts,
  public.kf_ingestion_integrity_evidence
FROM PUBLIC, anon, authenticated, service_role;

-- Internal helpers are never an external capability surface.
REVOKE ALL ON FUNCTION
  public.kf_prevent_ingestion_run_identity_mutation(),
  public.kf_prevent_ingestion_artifact_identity_mutation(),
  public.kf_ingestion_assert_object_internal(jsonb,text[],text[],text),
  public.kf_ingestion_text_internal(jsonb,text),
  public.kf_ingestion_uuid_internal(jsonb,text),
  public.kf_ingestion_timestamp_internal(jsonb,text),
  public.kf_ingestion_positive_bigint_internal(jsonb,text),
  public.kf_ingestion_assert_actor_internal(jsonb,text),
  public.kf_ingestion_ref_uuid_internal(jsonb,text,text),
  public.kf_ingestion_assert_identity_kind_internal(uuid,text),
  public.kf_ingestion_canonical_json_internal(jsonb),
  public.kf_ingestion_command_fingerprint_internal(text,jsonb),
  public.kf_ingestion_validate_technical_metadata_internal(jsonb,text),
  public.kf_ingestion_validate_command_payload_internal(text,jsonb),
  public.kf_ingestion_assert_authorization_internal(uuid,uuid,text,timestamptz),
  public.kf_ingestion_command_precheck_internal(text,uuid,text,jsonb),
  public.kf_ingestion_receipt_result_internal(uuid,boolean),
  public.kf_ingestion_receipt_json_internal(uuid),
  public.kf_ingestion_run_snapshot_json_internal(uuid),
  public.kf_ingestion_artifact_snapshot_json_internal(uuid),
  public.kf_ingestion_integrity_snapshot_json_internal(uuid),
  public.kf_ingestion_lock_run_internal(jsonb),
  public.kf_ingestion_commit_transition_internal(text,text,text,text,uuid,text,jsonb,public.kf_ingestion_runs),
  public.kf_ingestion_generic_transition_internal(text,uuid,text,jsonb),
  public.kf_ingestion_request_internal(uuid,text,jsonb),
  public.kf_ingestion_mark_staged_internal(uuid,text,jsonb,jsonb),
  public.kf_ingestion_begin_verification_internal(uuid,text,jsonb),
  public.kf_ingestion_duplicate_decision_internal(uuid,uuid,uuid,text,text,timestamptz),
  public.kf_ingestion_confirm_verified_internal(uuid,text,jsonb,jsonb),
  public.kf_ingestion_prepare_staging_artifact_internal(jsonb),
  public.kf_ingestion_prepare_discard_internal(jsonb),
  public.kf_ingestion_confirm_discard_internal(jsonb),
  public.kf_ingestion_recovery_snapshot_internal(uuid)
FROM PUBLIC, anon, authenticated, service_role;

REVOKE ALL ON FUNCTION
  public.kf_ingestion_request(uuid,text,jsonb),
  public.kf_ingestion_begin_staging(uuid,text,jsonb),
  public.kf_ingestion_mark_staged(uuid,text,jsonb,jsonb),
  public.kf_ingestion_begin_verification(uuid,text,jsonb),
  public.kf_ingestion_confirm_verified(uuid,text,jsonb,jsonb),
  public.kf_ingestion_fail(uuid,text,jsonb),
  public.kf_ingestion_cancel(uuid,text,jsonb),
  public.kf_ingestion_prepare_staging_artifact(jsonb),
  public.kf_ingestion_prepare_discard(jsonb),
  public.kf_ingestion_confirm_discard(jsonb),
  public.kf_ingestion_recovery_snapshot(uuid)
FROM PUBLIC, anon, authenticated, service_role;

GRANT EXECUTE ON FUNCTION
  public.kf_ingestion_request(uuid,text,jsonb),
  public.kf_ingestion_begin_staging(uuid,text,jsonb),
  public.kf_ingestion_mark_staged(uuid,text,jsonb,jsonb),
  public.kf_ingestion_begin_verification(uuid,text,jsonb),
  public.kf_ingestion_confirm_verified(uuid,text,jsonb,jsonb),
  public.kf_ingestion_fail(uuid,text,jsonb),
  public.kf_ingestion_cancel(uuid,text,jsonb),
  public.kf_ingestion_prepare_staging_artifact(jsonb),
  public.kf_ingestion_prepare_discard(jsonb),
  public.kf_ingestion_confirm_discard(jsonb),
  public.kf_ingestion_recovery_snapshot(uuid)
TO service_role;

-- Defense in depth: service_role reaches C.2 writes only through the narrow RPCs.
REVOKE INSERT, UPDATE, DELETE ON TABLE
  public.kf_source_identities,
  public.kf_ingestion_runs,
  public.kf_ingestion_command_receipts,
  public.kf_ingestion_events,
  public.kf_ingestion_staging_artifacts,
  public.kf_ingestion_integrity_evidence
FROM service_role;

COMMIT;
