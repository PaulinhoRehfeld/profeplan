-- =============================================================================
-- ProfePlan Knowledge Factory - Sublote C.3.2
-- Durable extraction control plane, temporal authorization, CAS and least privilege.
--
-- SECURITY / SCOPE:
-- - additive only;
-- - C.3 owns extraction lifecycle facts; C.2 remains the immutable handoff authority;
-- - no text, PDF bytes, parser output, OCR, embeddings, chunks or real content;
-- - current extraction authorization is re-evaluated at claim time;
-- - service_role is a technical channel only and receives no direct table DML;
-- - intended for disposable/non-production validation until a later material boundary.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Durable C.3 control-plane tables
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_extraction_runs (
  run_id uuid PRIMARY KEY,
  request_id uuid NOT NULL UNIQUE,
  source_version_id uuid NOT NULL
    REFERENCES public.kf_source_identities(id) ON DELETE RESTRICT,
  ingestion_run_id uuid NOT NULL
    REFERENCES public.kf_ingestion_runs(run_id) ON DELETE RESTRICT,
  ingestion_handoff_event_id uuid NOT NULL
    REFERENCES public.kf_ingestion_events(event_id) ON DELETE RESTRICT,
  reviewed_artifact_id uuid NOT NULL
    REFERENCES public.kf_ingestion_staging_artifacts(artifact_id) ON DELETE RESTRICT,
  artifact_sha256 text NOT NULL CHECK (artifact_sha256 ~ '^[0-9a-f]{64}$'),
  artifact_size_bytes bigint NOT NULL CHECK (artifact_size_bytes > 0),
  method_kind text NOT NULL CHECK (method_kind = 'native_text'),
  method_name text NOT NULL CHECK (btrim(method_name) <> ''),
  method_version text NOT NULL CHECK (btrim(method_version) <> ''),
  requested_by_actor_id uuid NOT NULL,
  requested_by_actor_role text NOT NULL CHECK (
    requested_by_actor_role IN (
      'curator', 'legal_editorial_reviewer', 'system_worker', 'auditor', 'technical_admin'
    )
  ),
  requested_at timestamptz NOT NULL,
  state text NOT NULL CHECK (
    state IN (
      'REQUESTED', 'READY', 'EXTRACTING', 'VALIDATING', 'PENDING_REVIEW',
      'VALIDATED_FOR_SEGMENTATION', 'REQUIRES_ALTERNATE_EXTRACTION',
      'BLOCKED_AUTHORIZATION', 'REJECTED', 'FAILED', 'CANCELLED'
    )
  ),
  aggregate_version text NOT NULL CHECK (btrim(aggregate_version) <> ''),
  sequence bigint NOT NULL CHECK (sequence > 0),
  created_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  updated_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_extraction_runs_time_check CHECK (updated_at >= created_at),
  CONSTRAINT kf_extraction_runs_handoff_binding_key UNIQUE (
    run_id, source_version_id, ingestion_run_id, ingestion_handoff_event_id, reviewed_artifact_id
  )
);

CREATE INDEX kf_extraction_runs_source_version_idx
  ON public.kf_extraction_runs(source_version_id, state);
CREATE INDEX kf_extraction_runs_ingestion_handoff_idx
  ON public.kf_extraction_runs(ingestion_run_id, ingestion_handoff_event_id);

CREATE TABLE public.kf_extraction_command_receipts (
  command_id uuid PRIMARY KEY,
  fingerprint text NOT NULL CHECK (fingerprint ~ '^[0-9a-f]{64}$'),
  correlation_id uuid NOT NULL,
  operation text NOT NULL CHECK (
    operation IN (
      'request_extraction', 'mark_ready', 'begin_extraction',
      'block_authorization', 'fail_extraction', 'cancel_extraction'
    )
  ),
  run_id uuid NOT NULL REFERENCES public.kf_extraction_runs(run_id) ON DELETE RESTRICT,
  aggregate_version text NOT NULL CHECK (btrim(aggregate_version) <> ''),
  sequence bigint NOT NULL CHECK (sequence > 0),
  previous_state text CHECK (
    previous_state IS NULL OR previous_state IN (
      'REQUESTED', 'READY', 'EXTRACTING', 'VALIDATING', 'PENDING_REVIEW',
      'VALIDATED_FOR_SEGMENTATION', 'REQUIRES_ALTERNATE_EXTRACTION',
      'BLOCKED_AUTHORIZATION', 'REJECTED', 'FAILED', 'CANCELLED'
    )
  ),
  state text NOT NULL CHECK (
    state IN (
      'REQUESTED', 'READY', 'EXTRACTING', 'VALIDATING', 'PENDING_REVIEW',
      'VALIDATED_FOR_SEGMENTATION', 'REQUIRES_ALTERNATE_EXTRACTION',
      'BLOCKED_AUTHORIZATION', 'REJECTED', 'FAILED', 'CANCELLED'
    )
  ),
  reason_code text CHECK (
    reason_code IS NULL OR reason_code IN (
      'authorization_invalid', 'technical_failure', 'operator_cancelled'
    )
  ),
  committed_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_extraction_command_receipts_run_sequence_key UNIQUE(run_id, sequence),
  CONSTRAINT kf_extraction_command_receipts_reason_shape_check CHECK (
    (operation = 'block_authorization' AND reason_code = 'authorization_invalid')
    OR (operation = 'fail_extraction' AND reason_code = 'technical_failure')
    OR (operation = 'cancel_extraction' AND reason_code = 'operator_cancelled')
    OR (
      operation NOT IN ('block_authorization', 'fail_extraction', 'cancel_extraction')
      AND reason_code IS NULL
    )
  )
);

CREATE INDEX kf_extraction_command_receipts_run_idx
  ON public.kf_extraction_command_receipts(run_id, sequence DESC);

CREATE TABLE public.kf_extraction_events (
  event_id uuid PRIMARY KEY,
  event_type text NOT NULL CHECK (
    event_type IN (
      'extraction_requested', 'extraction_ready', 'extraction_started',
      'extraction_authorization_blocked', 'extraction_failed', 'extraction_cancelled'
    )
  ),
  run_id uuid NOT NULL REFERENCES public.kf_extraction_runs(run_id) ON DELETE RESTRICT,
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
    REFERENCES public.kf_extraction_command_receipts(command_id)
    ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED,
  from_state text CHECK (
    from_state IS NULL OR from_state IN (
      'REQUESTED', 'READY', 'EXTRACTING', 'VALIDATING', 'PENDING_REVIEW',
      'VALIDATED_FOR_SEGMENTATION', 'REQUIRES_ALTERNATE_EXTRACTION',
      'BLOCKED_AUTHORIZATION', 'REJECTED', 'FAILED', 'CANCELLED'
    )
  ),
  to_state text NOT NULL CHECK (
    to_state IN (
      'REQUESTED', 'READY', 'EXTRACTING', 'VALIDATING', 'PENDING_REVIEW',
      'VALIDATED_FOR_SEGMENTATION', 'REQUIRES_ALTERNATE_EXTRACTION',
      'BLOCKED_AUTHORIZATION', 'REJECTED', 'FAILED', 'CANCELLED'
    )
  ),
  reason_code text CHECK (
    reason_code IS NULL OR reason_code IN (
      'authorization_invalid', 'technical_failure', 'operator_cancelled'
    )
  ),
  authorization_id uuid REFERENCES public.kf_source_authorizations(id) ON DELETE RESTRICT,
  authorization_checkpoint text CHECK (
    authorization_checkpoint IS NULL
    OR authorization_checkpoint IN ('claim', 'artifact_read', 'finalization')
  ),
  authorization_evaluated_at timestamptz,
  recorded_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_extraction_events_run_sequence_key UNIQUE(run_id, sequence),
  CONSTRAINT kf_extraction_events_command_event_key UNIQUE(command_id, event_id),
  CONSTRAINT kf_extraction_events_authorization_shape_check CHECK (
    (
      event_type = 'extraction_started'
      AND authorization_id IS NOT NULL
      AND authorization_checkpoint = 'claim'
      AND authorization_evaluated_at IS NOT NULL
      AND reason_code IS NULL
    )
    OR (
      event_type = 'extraction_authorization_blocked'
      AND reason_code = 'authorization_invalid'
      AND authorization_checkpoint IS NULL
      AND authorization_evaluated_at IS NULL
    )
    OR (
      event_type NOT IN ('extraction_started', 'extraction_authorization_blocked')
      AND authorization_id IS NULL
      AND authorization_checkpoint IS NULL
      AND authorization_evaluated_at IS NULL
    )
  )
);

CREATE INDEX kf_extraction_events_command_idx
  ON public.kf_extraction_events(command_id);

-- ---------------------------------------------------------------------------
-- 2. Immutability and append-only history
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_prevent_extraction_run_identity_mutation()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF NEW.run_id IS DISTINCT FROM OLD.run_id
    OR NEW.request_id IS DISTINCT FROM OLD.request_id
    OR NEW.source_version_id IS DISTINCT FROM OLD.source_version_id
    OR NEW.ingestion_run_id IS DISTINCT FROM OLD.ingestion_run_id
    OR NEW.ingestion_handoff_event_id IS DISTINCT FROM OLD.ingestion_handoff_event_id
    OR NEW.reviewed_artifact_id IS DISTINCT FROM OLD.reviewed_artifact_id
    OR NEW.artifact_sha256 IS DISTINCT FROM OLD.artifact_sha256
    OR NEW.artifact_size_bytes IS DISTINCT FROM OLD.artifact_size_bytes
    OR NEW.method_kind IS DISTINCT FROM OLD.method_kind
    OR NEW.method_name IS DISTINCT FROM OLD.method_name
    OR NEW.method_version IS DISTINCT FROM OLD.method_version
    OR NEW.requested_by_actor_id IS DISTINCT FROM OLD.requested_by_actor_id
    OR NEW.requested_by_actor_role IS DISTINCT FROM OLD.requested_by_actor_role
    OR NEW.requested_at IS DISTINCT FROM OLD.requested_at THEN
    RAISE EXCEPTION USING ERRCODE = '23514', MESSAGE = 'extraction run identity is immutable';
  END IF;
  RETURN NEW;
END;
$function$;

CREATE TRIGGER kf_extraction_runs_immutable_identity
BEFORE UPDATE ON public.kf_extraction_runs
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_extraction_run_identity_mutation();

CREATE TRIGGER kf_extraction_command_receipts_append_only
BEFORE UPDATE OR DELETE ON public.kf_extraction_command_receipts
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE TRIGGER kf_extraction_events_append_only
BEFORE UPDATE OR DELETE ON public.kf_extraction_events
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

-- ---------------------------------------------------------------------------
-- 3. Closed-schema parsing and deterministic fingerprint v1
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_extraction_assert_object_internal(
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

CREATE OR REPLACE FUNCTION public.kf_extraction_text_internal(p_value jsonb, p_context text)
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

CREATE OR REPLACE FUNCTION public.kf_extraction_uuid_internal(p_value jsonb, p_context text)
RETURNS uuid
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_extraction_text_internal(p_value, p_context)::uuid;
EXCEPTION WHEN invalid_text_representation THEN
  RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must be a UUID';
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_timestamp_internal(p_value jsonb, p_context text)
RETURNS timestamptz
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_extraction_text_internal(p_value, p_context)::timestamptz;
EXCEPTION WHEN invalid_datetime_format OR datetime_field_overflow THEN
  RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || ' must be a valid timestamp';
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_positive_bigint_internal(
  p_value jsonb,
  p_context text
)
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

CREATE OR REPLACE FUNCTION public.kf_extraction_assert_actor_internal(
  p_value jsonb,
  p_context text
)
RETURNS void
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE v_role text;
BEGIN
  PERFORM public.kf_extraction_assert_object_internal(
    p_value, ARRAY['actorId','role'], ARRAY['actorId','role'], p_context
  );
  PERFORM public.kf_extraction_uuid_internal(p_value -> 'actorId', p_context || '.actorId');
  v_role := public.kf_extraction_text_internal(p_value -> 'role', p_context || '.role');
  IF NOT (v_role = ANY(ARRAY[
    'curator','legal_editorial_reviewer','system_worker','auditor','technical_admin'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || '.role is invalid';
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_ref_uuid_internal(
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
  PERFORM public.kf_extraction_assert_object_internal(
    p_value, ARRAY['kind','id'], ARRAY['kind','id'], p_context
  );
  v_kind := public.kf_extraction_text_internal(p_value -> 'kind', p_context || '.kind');
  IF v_kind <> p_expected_kind THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = p_context || '.kind is invalid';
  END IF;
  RETURN public.kf_extraction_uuid_internal(p_value -> 'id', p_context || '.id');
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_canonical_json_internal(p_value jsonb)
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
          to_jsonb(entry.key)::text || ':' || public.kf_extraction_canonical_json_internal(entry.value),
          ',' ORDER BY entry.key COLLATE "C"
        ), ''
      ) || '}'
      INTO v_result
      FROM jsonb_each(p_value) AS entry(key, value);
      RETURN v_result;
    WHEN 'array' THEN
      SELECT '[' || coalesce(
        string_agg(
          public.kf_extraction_canonical_json_internal(item.value),
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

CREATE OR REPLACE FUNCTION public.kf_extraction_command_fingerprint_internal(
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
        public.kf_extraction_canonical_json_internal(
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

-- ---------------------------------------------------------------------------
-- 4. C.1 competence/current authorization and C.2 handoff assertions
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_extraction_assert_assignment_internal(
  p_actor_id uuid,
  p_role text,
  p_at timestamptz
)
RETURNS void
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE v_count bigint;
BEGIN
  SELECT count(*) INTO v_count
  FROM public.kf_source_actor_assignments AS assignments
  WHERE assignments.actor_id = p_actor_id
    AND assignments.actor_role = p_role
    AND p_at >= assignments.effective_from
    AND (assignments.effective_until IS NULL OR p_at <= assignments.effective_until);
  IF v_count = 0 THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'actor is not competent for extraction operation time';
  END IF;
  IF v_count <> 1 THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'actor competence is ambiguous for extraction operation time';
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_assert_current_authorization_internal(
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
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'extraction authorization is not valid at checkpoint time';
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_assert_handoff_internal(
  p_request jsonb,
  p_requested_at timestamptz
)
RETURNS void
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_source_version_id uuid;
  v_ingestion_run_id uuid;
  v_approval_event_id uuid;
  v_reviewed_artifact_id uuid;
  v_artifact_id uuid;
  v_handoff_version text;
  v_handoff_sequence bigint;
  v_handoff_committed_at timestamptz;
  v_digest text;
  v_size bigint;
  v_method_kind text;
  v_ingestion public.kf_ingestion_runs%ROWTYPE;
  v_event public.kf_ingestion_events%ROWTYPE;
  v_artifact public.kf_ingestion_staging_artifacts%ROWTYPE;
  v_integrity public.kf_ingestion_integrity_evidence%ROWTYPE;
  v_receipt public.kf_ingestion_command_receipts%ROWTYPE;
BEGIN
  PERFORM public.kf_extraction_assert_object_internal(
    p_request,
    ARRAY[
      'requestId','run','sourceVersion','ingestionHandoff','artifact',
      'method','requestedBy','requestedAt'
    ],
    ARRAY[
      'requestId','run','sourceVersion','ingestionHandoff','artifact',
      'method','requestedBy','requestedAt'
    ],
    'request'
  );
  PERFORM public.kf_extraction_uuid_internal(p_request -> 'requestId', 'request.requestId');
  PERFORM public.kf_extraction_ref_uuid_internal(p_request -> 'run', 'extraction_run', 'request.run');
  v_source_version_id := public.kf_extraction_ref_uuid_internal(
    p_request -> 'sourceVersion', 'source_version', 'request.sourceVersion'
  );
  IF NOT EXISTS (
    SELECT 1 FROM public.kf_source_identities
    WHERE id = v_source_version_id AND kind = 'source_version'
  ) THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'source version identity was not found';
  END IF;

  PERFORM public.kf_extraction_assert_object_internal(
    p_request -> 'ingestionHandoff',
    ARRAY[
      'contractVersion','ingestionRun','aggregateVersion','sequence',
      'reviewedArtifactId','approvalEventId','committedAt'
    ],
    ARRAY[
      'contractVersion','ingestionRun','aggregateVersion','sequence',
      'reviewedArtifactId','approvalEventId','committedAt'
    ],
    'request.ingestionHandoff'
  );
  IF public.kf_extraction_text_internal(
    p_request -> 'ingestionHandoff' -> 'contractVersion',
    'request.ingestionHandoff.contractVersion'
  ) <> '1.0.0' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'unsupported ingestion handoff contract version';
  END IF;
  v_ingestion_run_id := public.kf_extraction_ref_uuid_internal(
    p_request -> 'ingestionHandoff' -> 'ingestionRun',
    'processing_run',
    'request.ingestionHandoff.ingestionRun'
  );
  v_handoff_version := public.kf_extraction_text_internal(
    p_request -> 'ingestionHandoff' -> 'aggregateVersion',
    'request.ingestionHandoff.aggregateVersion'
  );
  v_handoff_sequence := public.kf_extraction_positive_bigint_internal(
    p_request -> 'ingestionHandoff' -> 'sequence',
    'request.ingestionHandoff.sequence'
  );
  v_reviewed_artifact_id := public.kf_extraction_uuid_internal(
    p_request -> 'ingestionHandoff' -> 'reviewedArtifactId',
    'request.ingestionHandoff.reviewedArtifactId'
  );
  v_approval_event_id := public.kf_extraction_uuid_internal(
    p_request -> 'ingestionHandoff' -> 'approvalEventId',
    'request.ingestionHandoff.approvalEventId'
  );
  v_handoff_committed_at := public.kf_extraction_timestamp_internal(
    p_request -> 'ingestionHandoff' -> 'committedAt',
    'request.ingestionHandoff.committedAt'
  );

  PERFORM public.kf_extraction_assert_object_internal(
    p_request -> 'artifact',
    ARRAY['artifactId','sha256','sizeBytes'],
    ARRAY['artifactId','sha256','sizeBytes'],
    'request.artifact'
  );
  v_artifact_id := public.kf_extraction_uuid_internal(
    p_request -> 'artifact' -> 'artifactId', 'request.artifact.artifactId'
  );
  v_digest := public.kf_extraction_text_internal(
    p_request -> 'artifact' -> 'sha256', 'request.artifact.sha256'
  );
  IF v_digest !~ '^[0-9a-f]{64}$' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'request.artifact.sha256 must be lowercase SHA-256 hex';
  END IF;
  v_size := public.kf_extraction_positive_bigint_internal(
    p_request -> 'artifact' -> 'sizeBytes', 'request.artifact.sizeBytes'
  );
  IF v_artifact_id <> v_reviewed_artifact_id THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'request artifact does not match reviewed C.2 artifact';
  END IF;

  PERFORM public.kf_extraction_assert_object_internal(
    p_request -> 'method',
    ARRAY['kind','name','version'], ARRAY['kind','name','version'], 'request.method'
  );
  v_method_kind := public.kf_extraction_text_internal(
    p_request -> 'method' -> 'kind', 'request.method.kind'
  );
  IF v_method_kind <> 'native_text' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'alternate extraction is not authorized in C.3.2';
  END IF;
  PERFORM public.kf_extraction_text_internal(p_request -> 'method' -> 'name', 'request.method.name');
  PERFORM public.kf_extraction_text_internal(p_request -> 'method' -> 'version', 'request.method.version');
  PERFORM public.kf_extraction_assert_actor_internal(p_request -> 'requestedBy', 'request.requestedBy');
  IF public.kf_extraction_timestamp_internal(
    p_request -> 'requestedAt', 'request.requestedAt'
  ) <> p_requested_at THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'request.requestedAt must equal command occurredAt';
  END IF;

  SELECT * INTO v_ingestion
  FROM public.kf_ingestion_runs
  WHERE run_id = v_ingestion_run_id;
  IF NOT FOUND
    OR v_ingestion.source_version_id <> v_source_version_id
    OR v_ingestion.state <> 'APPROVED_FOR_EXTRACTION'
    OR v_ingestion.aggregate_version <> v_handoff_version
    OR v_ingestion.sequence <> v_handoff_sequence THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'ingestion handoff no longer matches the authoritative C.2 run';
  END IF;

  SELECT * INTO v_event
  FROM public.kf_ingestion_events
  WHERE event_id = v_approval_event_id;
  IF NOT FOUND
    OR v_event.event_type <> 'ingestion_approved_for_extraction'
    OR v_event.run_id <> v_ingestion_run_id
    OR v_event.aggregate_version <> v_handoff_version
    OR v_event.sequence <> v_handoff_sequence
    OR v_event.to_state <> 'APPROVED_FOR_EXTRACTION'
    OR v_event.reviewed_artifact_id <> v_reviewed_artifact_id THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'ingestion handoff approval event is inconsistent';
  END IF;

  SELECT * INTO v_receipt
  FROM public.kf_ingestion_command_receipts
  WHERE command_id = v_event.command_id;
  IF NOT FOUND OR v_receipt.committed_at <> v_handoff_committed_at THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'ingestion handoff commit evidence is inconsistent';
  END IF;

  SELECT * INTO v_artifact
  FROM public.kf_ingestion_staging_artifacts
  WHERE artifact_id = v_reviewed_artifact_id;
  IF NOT FOUND
    OR v_artifact.run_id <> v_ingestion_run_id
    OR v_artifact.source_version_id <> v_source_version_id
    OR v_artifact.state <> 'VERIFIED'
    OR p_requested_at >= v_artifact.expires_at THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'reviewed staging artifact is unavailable for extraction request';
  END IF;

  SELECT * INTO v_integrity
  FROM public.kf_ingestion_integrity_evidence
  WHERE artifact_id = v_reviewed_artifact_id;
  IF NOT FOUND
    OR v_integrity.run_id <> v_ingestion_run_id
    OR v_integrity.source_version_id <> v_source_version_id
    OR v_integrity.digest_algorithm <> 'sha-256'
    OR v_integrity.digest_value <> v_digest
    OR v_integrity.byte_length <> v_size THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'artifact integrity evidence does not match extraction request';
  END IF;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 5. Command validation, replay and CAS
-- ---------------------------------------------------------------------------
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
  v_allowed text[];
  v_expected_state text;
  v_reason_code text;
  v_evidence jsonb;
BEGIN
  IF NOT (p_operation = ANY(ARRAY[
    'request_extraction','mark_ready','begin_extraction',
    'block_authorization','fail_extraction','cancel_extraction'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'extraction operation is outside C.3.2';
  END IF;

  IF p_operation = 'request_extraction' THEN
    v_required := ARRAY['commandType','actor','occurredAt','correlationId','reason','request'];
    v_allowed := ARRAY[
      'commandType','actor','occurredAt','correlationId','reason',
      'expectedVersion','expectedSequence','request'
    ];
  ELSIF p_operation = 'begin_extraction' THEN
    v_required := ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','run',
      'expectedState','expectedVersion','expectedSequence','authorizationEvidence'
    ];
    v_allowed := v_required;
  ELSIF p_operation IN ('block_authorization','fail_extraction','cancel_extraction') THEN
    v_required := ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','run',
      'expectedState','expectedVersion','expectedSequence','reasonCode'
    ];
    v_allowed := v_required;
  ELSE
    v_required := ARRAY[
      'commandType','actor','occurredAt','correlationId','reason','run',
      'expectedState','expectedVersion','expectedSequence'
    ];
    v_allowed := v_required;
  END IF;

  PERFORM public.kf_extraction_assert_object_internal(
    p_payload, v_required, v_allowed, 'C.3.2 extraction command payload'
  );
  IF public.kf_extraction_text_internal(p_payload -> 'commandType', 'commandType') <> p_operation THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'commandType does not match RPC operation';
  END IF;
  PERFORM public.kf_extraction_assert_actor_internal(p_payload -> 'actor', 'actor');
  PERFORM public.kf_extraction_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  PERFORM public.kf_extraction_uuid_internal(p_payload -> 'correlationId', 'correlationId');
  PERFORM public.kf_extraction_text_internal(p_payload -> 'reason', 'reason');

  IF p_operation = 'request_extraction' THEN
    PERFORM public.kf_extraction_assert_handoff_internal(
      p_payload -> 'request',
      public.kf_extraction_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt')
    );
    RETURN;
  END IF;

  PERFORM public.kf_extraction_ref_uuid_internal(p_payload -> 'run', 'extraction_run', 'run');
  PERFORM public.kf_extraction_text_internal(p_payload -> 'expectedVersion', 'expectedVersion');
  PERFORM public.kf_extraction_positive_bigint_internal(
    p_payload -> 'expectedSequence', 'expectedSequence'
  );
  v_expected_state := public.kf_extraction_text_internal(
    p_payload -> 'expectedState', 'expectedState'
  );

  IF p_operation = 'mark_ready' AND v_expected_state <> 'REQUESTED' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'mark_ready requires expectedState REQUESTED';
  END IF;
  IF p_operation = 'begin_extraction' AND v_expected_state <> 'READY' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'begin_extraction requires expectedState READY';
  END IF;

  IF p_operation = 'begin_extraction' THEN
    v_evidence := p_payload -> 'authorizationEvidence';
    PERFORM public.kf_extraction_assert_object_internal(
      v_evidence,
      ARRAY['authorizationId','sourceVersion','purpose','checkpoint','evaluatedAt'],
      ARRAY['authorizationId','sourceVersion','purpose','checkpoint','evaluatedAt'],
      'authorizationEvidence'
    );
    PERFORM public.kf_extraction_uuid_internal(
      v_evidence -> 'authorizationId', 'authorizationEvidence.authorizationId'
    );
    PERFORM public.kf_extraction_ref_uuid_internal(
      v_evidence -> 'sourceVersion', 'source_version', 'authorizationEvidence.sourceVersion'
    );
    IF public.kf_extraction_text_internal(
      v_evidence -> 'purpose', 'authorizationEvidence.purpose'
    ) <> 'extraction' THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'authorization evidence purpose must be extraction';
    END IF;
    IF public.kf_extraction_text_internal(
      v_evidence -> 'checkpoint', 'authorizationEvidence.checkpoint'
    ) <> 'claim' THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'begin_extraction requires claim authorization checkpoint';
    END IF;
    IF public.kf_extraction_timestamp_internal(
      v_evidence -> 'evaluatedAt', 'authorizationEvidence.evaluatedAt'
    ) <> public.kf_extraction_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt') THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'claim authorization must be evaluated at command time';
    END IF;
  ELSIF p_operation IN ('block_authorization','fail_extraction','cancel_extraction') THEN
    v_reason_code := public.kf_extraction_text_internal(p_payload -> 'reasonCode', 'reasonCode');
    IF p_operation = 'block_authorization' AND v_reason_code <> 'authorization_invalid' THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'block_authorization requires authorization_invalid';
    END IF;
    IF p_operation = 'fail_extraction' AND v_reason_code <> 'technical_failure' THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'fail_extraction requires technical_failure';
    END IF;
    IF p_operation = 'cancel_extraction' AND v_reason_code <> 'operator_cancelled' THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'cancel_extraction requires operator_cancelled';
    END IF;
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
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'commandId is required';
  END IF;
  IF p_fingerprint IS NULL OR p_fingerprint !~ '^[0-9a-f]{64}$' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'fingerprint must be lowercase SHA-256 hex';
  END IF;
  PERFORM public.kf_extraction_validate_payload_internal(p_operation, p_payload);
  v_calculated := public.kf_extraction_command_fingerprint_internal(p_operation, p_payload);
  IF v_calculated <> p_fingerprint THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'fingerprint does not match canonical extraction payload';
  END IF;

  PERFORM pg_advisory_xact_lock(hashtextextended('extraction-command:' || p_command_id::text, 0));
  SELECT receipt.operation, receipt.fingerprint
  INTO v_existing_operation, v_existing_fingerprint
  FROM public.kf_extraction_command_receipts AS receipt
  WHERE receipt.command_id = p_command_id;
  IF FOUND THEN
    IF v_existing_operation <> p_operation OR v_existing_fingerprint <> v_calculated THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'commandId was already used with a different extraction command';
    END IF;
    RETURN true;
  END IF;
  RETURN false;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_lock_run_internal(p_payload jsonb)
RETURNS public.kf_extraction_runs
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_run_id uuid;
  v_run public.kf_extraction_runs%ROWTYPE;
  v_expected_state text;
  v_expected_version text;
  v_expected_sequence bigint;
BEGIN
  v_run_id := public.kf_extraction_ref_uuid_internal(p_payload -> 'run', 'extraction_run', 'run');
  v_expected_state := public.kf_extraction_text_internal(p_payload -> 'expectedState', 'expectedState');
  v_expected_version := public.kf_extraction_text_internal(p_payload -> 'expectedVersion', 'expectedVersion');
  v_expected_sequence := public.kf_extraction_positive_bigint_internal(
    p_payload -> 'expectedSequence', 'expectedSequence'
  );

  SELECT * INTO v_run
  FROM public.kf_extraction_runs
  WHERE run_id = v_run_id
  FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'extraction run was not found';
  END IF;
  IF v_run.state <> v_expected_state
    OR v_run.aggregate_version <> v_expected_version
    OR v_run.sequence <> v_expected_sequence THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'stale extraction state/version/sequence';
  END IF;
  RETURN v_run;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_receipt_result_internal(
  p_command_id uuid,
  p_replayed boolean
)
RETURNS TABLE(
  contract_version text,
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
  committed_at timestamptz
)
LANGUAGE sql
STABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT
    '1.0.0'::text,
    receipt.command_id,
    receipt.fingerprint,
    receipt.correlation_id,
    receipt.operation,
    receipt.run_id,
    receipt.aggregate_version,
    receipt.sequence,
    ARRAY(
      SELECT event.event_id
      FROM public.kf_extraction_events AS event
      WHERE event.command_id = receipt.command_id
      ORDER BY event.sequence
    ),
    receipt.previous_state,
    receipt.state,
    p_replayed,
    receipt.committed_at
  FROM public.kf_extraction_command_receipts AS receipt
  WHERE receipt.command_id = p_command_id
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_commit_transition_internal(
  p_operation text,
  p_event_type text,
  p_to_state text,
  p_reason_code text,
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb,
  p_run public.kf_extraction_runs,
  p_authorization_id uuid DEFAULT NULL,
  p_authorization_checkpoint text DEFAULT NULL,
  p_authorization_evaluated_at timestamptz DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_new_version text := gen_random_uuid()::text;
  v_new_sequence bigint := p_run.sequence + 1;
  v_event_id uuid := gen_random_uuid();
  v_actor_id uuid;
  v_actor_role text;
  v_occurred_at timestamptz;
  v_correlation_id uuid;
  v_reason text;
BEGIN
  v_actor_id := public.kf_extraction_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_actor_role := public.kf_extraction_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_occurred_at := public.kf_extraction_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  v_correlation_id := public.kf_extraction_uuid_internal(p_payload -> 'correlationId', 'correlationId');
  v_reason := public.kf_extraction_text_internal(p_payload -> 'reason', 'reason');

  IF v_occurred_at < p_run.updated_at THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'extraction transition would regress committed temporal order';
  END IF;

  UPDATE public.kf_extraction_runs
  SET state = p_to_state,
      aggregate_version = v_new_version,
      sequence = v_new_sequence,
      updated_at = v_occurred_at
  WHERE run_id = p_run.run_id
    AND state = p_run.state
    AND aggregate_version = p_run.aggregate_version
    AND sequence = p_run.sequence;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'extraction CAS lost concurrent transition';
  END IF;

  INSERT INTO public.kf_extraction_command_receipts(
    command_id,fingerprint,correlation_id,operation,run_id,
    aggregate_version,sequence,previous_state,state,reason_code
  ) VALUES (
    p_command_id,p_fingerprint,v_correlation_id,p_operation,p_run.run_id,
    v_new_version,v_new_sequence,p_run.state,p_to_state,p_reason_code
  );

  INSERT INTO public.kf_extraction_events(
    event_id,event_type,run_id,aggregate_version,sequence,
    actor_id,actor_role,reason,occurred_at,correlation_id,command_id,
    from_state,to_state,reason_code,
    authorization_id,authorization_checkpoint,authorization_evaluated_at
  ) VALUES (
    v_event_id,p_event_type,p_run.run_id,v_new_version,v_new_sequence,
    v_actor_id,v_actor_role,v_reason,v_occurred_at,v_correlation_id,p_command_id,
    p_run.state,p_to_state,p_reason_code,
    p_authorization_id,p_authorization_checkpoint,p_authorization_evaluated_at
  );
END;
$function$;

-- ---------------------------------------------------------------------------
-- 6. Request + C.3.2 transitions
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_extraction_request_internal(
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
  v_ingestion_run_id uuid;
  v_handoff_event_id uuid;
  v_reviewed_artifact_id uuid;
  v_digest text;
  v_size bigint;
  v_method_name text;
  v_method_version text;
  v_actor_id uuid;
  v_actor_role text;
  v_requested_by_id uuid;
  v_requested_by_role text;
  v_requested_at timestamptz;
  v_occurred_at timestamptz;
  v_correlation_id uuid;
  v_reason text;
  v_version text := gen_random_uuid()::text;
  v_event_id uuid := gen_random_uuid();
BEGIN
  v_run_id := public.kf_extraction_ref_uuid_internal(v_request -> 'run', 'extraction_run', 'request.run');
  v_request_id := public.kf_extraction_uuid_internal(v_request -> 'requestId', 'request.requestId');
  v_source_version_id := public.kf_extraction_ref_uuid_internal(
    v_request -> 'sourceVersion', 'source_version', 'request.sourceVersion'
  );
  v_ingestion_run_id := public.kf_extraction_ref_uuid_internal(
    v_request -> 'ingestionHandoff' -> 'ingestionRun',
    'processing_run',
    'request.ingestionHandoff.ingestionRun'
  );
  v_handoff_event_id := public.kf_extraction_uuid_internal(
    v_request -> 'ingestionHandoff' -> 'approvalEventId',
    'request.ingestionHandoff.approvalEventId'
  );
  v_reviewed_artifact_id := public.kf_extraction_uuid_internal(
    v_request -> 'ingestionHandoff' -> 'reviewedArtifactId',
    'request.ingestionHandoff.reviewedArtifactId'
  );
  v_digest := public.kf_extraction_text_internal(v_request -> 'artifact' -> 'sha256', 'request.artifact.sha256');
  v_size := public.kf_extraction_positive_bigint_internal(v_request -> 'artifact' -> 'sizeBytes', 'request.artifact.sizeBytes');
  v_method_name := public.kf_extraction_text_internal(v_request -> 'method' -> 'name', 'request.method.name');
  v_method_version := public.kf_extraction_text_internal(v_request -> 'method' -> 'version', 'request.method.version');
  v_actor_id := public.kf_extraction_uuid_internal(p_payload -> 'actor' -> 'actorId', 'actor.actorId');
  v_actor_role := public.kf_extraction_text_internal(p_payload -> 'actor' -> 'role', 'actor.role');
  v_requested_by_id := public.kf_extraction_uuid_internal(v_request -> 'requestedBy' -> 'actorId', 'request.requestedBy.actorId');
  v_requested_by_role := public.kf_extraction_text_internal(v_request -> 'requestedBy' -> 'role', 'request.requestedBy.role');
  v_requested_at := public.kf_extraction_timestamp_internal(v_request -> 'requestedAt', 'request.requestedAt');
  v_occurred_at := public.kf_extraction_timestamp_internal(p_payload -> 'occurredAt', 'occurredAt');
  v_correlation_id := public.kf_extraction_uuid_internal(p_payload -> 'correlationId', 'correlationId');
  v_reason := public.kf_extraction_text_internal(p_payload -> 'reason', 'reason');

  IF v_actor_id <> v_requested_by_id OR v_actor_role <> v_requested_by_role THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'command actor must match extraction requester';
  END IF;
  IF v_actor_role <> 'system_worker' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT403', MESSAGE = 'request_extraction requires system_worker operational competence';
  END IF;
  PERFORM public.kf_extraction_assert_assignment_internal(v_actor_id, v_actor_role, v_occurred_at);

  IF EXISTS (SELECT 1 FROM public.kf_extraction_runs WHERE run_id = v_run_id) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'extraction run already exists under another command';
  END IF;

  INSERT INTO public.kf_extraction_runs(
    run_id,request_id,source_version_id,ingestion_run_id,ingestion_handoff_event_id,
    reviewed_artifact_id,artifact_sha256,artifact_size_bytes,
    method_kind,method_name,method_version,
    requested_by_actor_id,requested_by_actor_role,requested_at,
    state,aggregate_version,sequence,created_at,updated_at
  ) VALUES (
    v_run_id,v_request_id,v_source_version_id,v_ingestion_run_id,v_handoff_event_id,
    v_reviewed_artifact_id,v_digest,v_size,
    'native_text',v_method_name,v_method_version,
    v_actor_id,v_actor_role,v_requested_at,
    'REQUESTED',v_version,1,v_requested_at,v_requested_at
  );

  INSERT INTO public.kf_extraction_command_receipts(
    command_id,fingerprint,correlation_id,operation,run_id,
    aggregate_version,sequence,previous_state,state,reason_code
  ) VALUES (
    p_command_id,p_fingerprint,v_correlation_id,'request_extraction',v_run_id,
    v_version,1,NULL,'REQUESTED',NULL
  );

  INSERT INTO public.kf_extraction_events(
    event_id,event_type,run_id,aggregate_version,sequence,
    actor_id,actor_role,reason,occurred_at,correlation_id,command_id,
    from_state,to_state,reason_code
  ) VALUES (
    v_event_id,'extraction_requested',v_run_id,v_version,1,
    v_actor_id,v_actor_role,v_reason,v_occurred_at,v_correlation_id,p_command_id,
    NULL,'REQUESTED',NULL
  );
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
    p_operation,p_event_type,v_to_state,v_reason_code,
    p_command_id,p_fingerprint,p_payload,v_run,
    v_authorization_id,
    CASE WHEN p_operation = 'begin_extraction' THEN 'claim' ELSE NULL END,
    v_authorization_evaluated_at
  );
END;
$function$;

-- ---------------------------------------------------------------------------
-- 7. Narrow public RPC boundary
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_extraction_request(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS TABLE(
  contract_version text, command_id uuid, fingerprint text, correlation_id uuid,
  operation text, run_id uuid, aggregate_version text, sequence bigint,
  event_ids uuid[], previous_state text, state text, replayed boolean,
  committed_at timestamptz
)
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_extraction_precheck_internal('request_extraction',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,true);
    RETURN;
  END IF;
  PERFORM public.kf_extraction_request_internal(p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_mark_ready(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS TABLE(
  contract_version text, command_id uuid, fingerprint text, correlation_id uuid,
  operation text, run_id uuid, aggregate_version text, sequence bigint,
  event_ids uuid[], previous_state text, state text, replayed boolean,
  committed_at timestamptz
)
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_extraction_precheck_internal('mark_ready',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_extraction_transition_internal('mark_ready',p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_begin(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS TABLE(
  contract_version text, command_id uuid, fingerprint text, correlation_id uuid,
  operation text, run_id uuid, aggregate_version text, sequence bigint,
  event_ids uuid[], previous_state text, state text, replayed boolean,
  committed_at timestamptz
)
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_extraction_precheck_internal('begin_extraction',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_extraction_transition_internal('begin_extraction',p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_block_authorization(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS TABLE(
  contract_version text, command_id uuid, fingerprint text, correlation_id uuid,
  operation text, run_id uuid, aggregate_version text, sequence bigint,
  event_ids uuid[], previous_state text, state text, replayed boolean,
  committed_at timestamptz
)
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_extraction_precheck_internal('block_authorization',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_extraction_transition_internal('block_authorization',p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_fail(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS TABLE(
  contract_version text, command_id uuid, fingerprint text, correlation_id uuid,
  operation text, run_id uuid, aggregate_version text, sequence bigint,
  event_ids uuid[], previous_state text, state text, replayed boolean,
  committed_at timestamptz
)
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_extraction_precheck_internal('fail_extraction',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_extraction_transition_internal('fail_extraction',p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_cancel(
  p_command_id uuid,
  p_fingerprint text,
  p_payload jsonb
)
RETURNS TABLE(
  contract_version text, command_id uuid, fingerprint text, correlation_id uuid,
  operation text, run_id uuid, aggregate_version text, sequence bigint,
  event_ids uuid[], previous_state text, state text, replayed boolean,
  committed_at timestamptz
)
LANGUAGE plpgsql SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF public.kf_extraction_precheck_internal('cancel_extraction',p_command_id,p_fingerprint,p_payload) THEN
    RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,true); RETURN;
  END IF;
  PERFORM public.kf_extraction_transition_internal('cancel_extraction',p_command_id,p_fingerprint,p_payload);
  RETURN QUERY SELECT * FROM public.kf_extraction_receipt_result_internal(p_command_id,false);
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_snapshot(p_run_id uuid)
RETURNS jsonb
LANGUAGE sql SECURITY DEFINER STABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT jsonb_build_object(
    'contractVersion','1.0.0',
    'run',jsonb_build_object('kind','extraction_run','id',run.run_id),
    'sourceVersion',jsonb_build_object('kind','source_version','id',run.source_version_id),
    'ingestionRun',jsonb_build_object('kind','processing_run','id',run.ingestion_run_id),
    'ingestionHandoffEventId',run.ingestion_handoff_event_id,
    'reviewedArtifactId',run.reviewed_artifact_id,
    'artifactSha256',run.artifact_sha256,
    'artifactSizeBytes',run.artifact_size_bytes,
    'state',run.state,
    'aggregateVersion',run.aggregate_version,
    'sequence',run.sequence,
    'method',jsonb_build_object(
      'kind',run.method_kind,'name',run.method_name,'version',run.method_version
    ),
    'updatedAt',run.updated_at
  )
  FROM public.kf_extraction_runs AS run
  WHERE run.run_id = p_run_id
$function$;

-- ---------------------------------------------------------------------------
-- 8. Ownership, RLS and least privilege
-- ---------------------------------------------------------------------------
ALTER TABLE public.kf_extraction_runs OWNER TO postgres;
ALTER TABLE public.kf_extraction_command_receipts OWNER TO postgres;
ALTER TABLE public.kf_extraction_events OWNER TO postgres;

ALTER TABLE public.kf_extraction_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_extraction_command_receipts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_extraction_events ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE
  public.kf_extraction_runs,
  public.kf_extraction_command_receipts,
  public.kf_extraction_events
FROM PUBLIC, anon, authenticated, service_role;

REVOKE ALL ON FUNCTION
  public.kf_prevent_extraction_run_identity_mutation(),
  public.kf_extraction_assert_object_internal(jsonb,text[],text[],text),
  public.kf_extraction_text_internal(jsonb,text),
  public.kf_extraction_uuid_internal(jsonb,text),
  public.kf_extraction_timestamp_internal(jsonb,text),
  public.kf_extraction_positive_bigint_internal(jsonb,text),
  public.kf_extraction_assert_actor_internal(jsonb,text),
  public.kf_extraction_ref_uuid_internal(jsonb,text,text),
  public.kf_extraction_canonical_json_internal(jsonb),
  public.kf_extraction_command_fingerprint_internal(text,jsonb),
  public.kf_extraction_assert_assignment_internal(uuid,text,timestamptz),
  public.kf_extraction_assert_current_authorization_internal(uuid,uuid,timestamptz),
  public.kf_extraction_assert_handoff_internal(jsonb,timestamptz),
  public.kf_extraction_validate_payload_internal(text,jsonb),
  public.kf_extraction_precheck_internal(text,uuid,text,jsonb),
  public.kf_extraction_lock_run_internal(jsonb),
  public.kf_extraction_receipt_result_internal(uuid,boolean),
  public.kf_extraction_commit_transition_internal(text,text,text,text,uuid,text,jsonb,public.kf_extraction_runs,uuid,text,timestamptz),
  public.kf_extraction_request_internal(uuid,text,jsonb),
  public.kf_extraction_transition_internal(text,uuid,text,jsonb)
FROM PUBLIC, anon, authenticated, service_role;

REVOKE ALL ON FUNCTION
  public.kf_extraction_request(uuid,text,jsonb),
  public.kf_extraction_mark_ready(uuid,text,jsonb),
  public.kf_extraction_begin(uuid,text,jsonb),
  public.kf_extraction_block_authorization(uuid,text,jsonb),
  public.kf_extraction_fail(uuid,text,jsonb),
  public.kf_extraction_cancel(uuid,text,jsonb),
  public.kf_extraction_snapshot(uuid)
FROM PUBLIC, anon, authenticated, service_role;

GRANT EXECUTE ON FUNCTION
  public.kf_extraction_request(uuid,text,jsonb),
  public.kf_extraction_mark_ready(uuid,text,jsonb),
  public.kf_extraction_begin(uuid,text,jsonb),
  public.kf_extraction_block_authorization(uuid,text,jsonb),
  public.kf_extraction_fail(uuid,text,jsonb),
  public.kf_extraction_cancel(uuid,text,jsonb),
  public.kf_extraction_snapshot(uuid)
TO service_role;

REVOKE INSERT, UPDATE, DELETE ON TABLE
  public.kf_extraction_runs,
  public.kf_extraction_command_receipts,
  public.kf_extraction_events
FROM service_role;

COMMIT;
