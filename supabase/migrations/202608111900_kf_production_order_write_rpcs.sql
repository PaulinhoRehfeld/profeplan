-- =============================================================================
-- ProfePlan Knowledge Factory - Sublote 3B.5.3
-- Transactional writes for production orders and their append-only timeline.
--
-- This migration is additive. It does not wire command adapters and it does not
-- access hosted or production data.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Requester-scoped idempotency receipts
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_production_order_write_receipts (
  command_id uuid PRIMARY KEY,
  requester_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE RESTRICT,
  operation text NOT NULL CHECK (
    operation IN ('create_production_order', 'transition_production_order')
  ),
  payload_fingerprint text NOT NULL CHECK (
    payload_fingerprint ~ '^[0-9a-f]{64}$'
  ),
  opp_id uuid NOT NULL REFERENCES public.kf_production_orders(id) ON DELETE RESTRICT,
  event_id uuid NOT NULL
    REFERENCES public.kf_production_order_events(id) ON DELETE RESTRICT,
  status text NOT NULL CHECK (
    status IN (
      'requested', 'scoped', 'retrieving', 'assembling', 'validating', 'ready',
      'insufficient', 'blocked', 'failed'
    )
  ),
  committed_at timestamptz NOT NULL DEFAULT clock_timestamp()
);

ALTER TABLE public.kf_production_order_write_receipts ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.kf_production_order_write_receipts
FROM PUBLIC, anon, authenticated, service_role;

-- ---------------------------------------------------------------------------
-- 2. Closed-schema validation helpers
--
-- Helpers are private to the SECURITY DEFINER commands. API roles cannot call
-- them directly.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_opp_write_assert_object_internal(
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

CREATE OR REPLACE FUNCTION public.kf_opp_write_text_internal(
  p_value jsonb,
  p_context text,
  p_allow_empty boolean DEFAULT false
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
  IF NOT p_allow_empty AND btrim(v_result) = '' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must not be blank';
  END IF;

  RETURN v_result;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_opp_write_uuid_internal(
  p_value jsonb,
  p_context text
)
RETURNS uuid
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_opp_write_text_internal(p_value, p_context)::uuid;
EXCEPTION
  WHEN invalid_text_representation THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must be a UUID';
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_opp_write_timestamp_internal(
  p_value jsonb,
  p_context text
)
RETURNS timestamptz
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_opp_write_text_internal(p_value, p_context)::timestamptz;
EXCEPTION
  WHEN invalid_datetime_format OR datetime_field_overflow THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must be a valid timestamp with time zone';
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_opp_write_positive_integer_internal(
  p_value jsonb,
  p_context text
)
RETURNS integer
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_numeric numeric;
  v_result integer;
BEGIN
  IF p_value IS NULL OR jsonb_typeof(p_value) <> 'number' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must be a positive integer';
  END IF;

  BEGIN
    v_numeric := (p_value #>> '{}')::numeric;
  EXCEPTION
    WHEN invalid_text_representation OR numeric_value_out_of_range THEN
      RAISE EXCEPTION USING
        ERRCODE = '22023',
        MESSAGE = p_context || ' must be a positive integer';
  END;

  IF v_numeric <= 0
    OR trunc(v_numeric) <> v_numeric
    OR v_numeric > 2147483647 THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must be a positive integer';
  END IF;

  v_result := v_numeric::integer;
  RETURN v_result;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_opp_write_fingerprint_internal(
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
        jsonb_build_object('operation', p_operation, 'payload', p_payload)::text,
        'UTF8'
      )
    ),
    'hex'
  )
$function$;

CREATE OR REPLACE FUNCTION public.kf_opp_transition_allowed_internal(
  p_from_status text,
  p_to_status text
)
RETURNS boolean
LANGUAGE sql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT CASE p_from_status
    WHEN 'requested' THEN p_to_status = ANY(ARRAY['scoped', 'blocked', 'failed'])
    WHEN 'scoped' THEN p_to_status = ANY(ARRAY['retrieving', 'blocked', 'failed'])
    WHEN 'retrieving' THEN p_to_status = ANY(ARRAY[
      'assembling', 'insufficient', 'blocked', 'failed'
    ])
    WHEN 'assembling' THEN p_to_status = ANY(ARRAY['validating', 'insufficient', 'failed'])
    WHEN 'validating' THEN p_to_status = ANY(ARRAY[
      'ready', 'insufficient', 'blocked', 'failed'
    ])
    ELSE false
  END
$function$;

CREATE OR REPLACE FUNCTION public.kf_opp_event_type_internal(p_to_status text)
RETURNS text
LANGUAGE sql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT CASE p_to_status
    WHEN 'requested' THEN 'created'
    WHEN 'scoped' THEN 'scope_resolved'
    WHEN 'retrieving' THEN 'retrieval_started'
    WHEN 'assembling' THEN 'context_assembled'
    WHEN 'validating' THEN 'validation_started'
    WHEN 'ready' THEN 'approved'
    WHEN 'insufficient' THEN 'insufficiency_detected'
    WHEN 'blocked' THEN 'blocked'
    WHEN 'failed' THEN 'failed'
    ELSE NULL
  END
$function$;

REVOKE ALL ON FUNCTION
  public.kf_opp_write_assert_object_internal(jsonb, text[], text[], text),
  public.kf_opp_write_text_internal(jsonb, text, boolean),
  public.kf_opp_write_uuid_internal(jsonb, text),
  public.kf_opp_write_timestamp_internal(jsonb, text),
  public.kf_opp_write_positive_integer_internal(jsonb, text),
  public.kf_opp_write_fingerprint_internal(text, jsonb),
  public.kf_opp_transition_allowed_internal(text, text),
  public.kf_opp_event_type_internal(text)
FROM PUBLIC, anon, authenticated, service_role;

-- ---------------------------------------------------------------------------
-- 3. REQUESTER command: create OPP + created event + receipt
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_create_production_order(
  p_command_id uuid,
  p_payload jsonb
)
RETURNS TABLE (
  command_id uuid,
  operation text,
  opp_id uuid,
  event_id uuid,
  status text,
  replayed boolean,
  committed_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_operation CONSTANT text := 'create_production_order';
  v_order jsonb;
  v_requester_id uuid;
  v_opp_id uuid;
  v_event_id uuid;
  v_agent_profile_id uuid;
  v_curriculum_package_id uuid;
  v_product_type text;
  v_occurred_at timestamptz;
  v_duration_minutes integer;
  v_fingerprint text;
  v_receipt public.kf_production_order_write_receipts%ROWTYPE;
  v_committed_at timestamptz;
BEGIN
  IF p_command_id IS NULL THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'commandId is required';
  END IF;

  v_requester_id := auth.uid();
  IF v_requester_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'an authenticated requester is required';
  END IF;

  PERFORM public.kf_opp_write_assert_object_internal(
    p_payload,
    ARRAY['eventId', 'eventVersion', 'occurredAt', 'order'],
    ARRAY['eventId', 'eventVersion', 'occurredAt', 'order'],
    'createProductionOrder payload'
  );

  v_order := p_payload -> 'order';
  PERFORM public.kf_opp_write_assert_object_internal(
    v_order,
    ARRAY[
      'agentProfileId', 'curriculumPackageId', 'id', 'productType', 'theme', 'version'
    ],
    ARRAY[
      'agentProfileId', 'curriculumPackageId', 'durationMinutes', 'id', 'productType',
      'theme', 'version'
    ],
    'order'
  );

  v_opp_id := public.kf_opp_write_uuid_internal(v_order -> 'id', 'order.id');
  v_event_id := public.kf_opp_write_uuid_internal(p_payload -> 'eventId', 'eventId');
  v_agent_profile_id := public.kf_opp_write_uuid_internal(
    v_order -> 'agentProfileId', 'order.agentProfileId'
  );
  v_curriculum_package_id := public.kf_opp_write_uuid_internal(
    v_order -> 'curriculumPackageId', 'order.curriculumPackageId'
  );
  v_product_type := public.kf_opp_write_text_internal(
    v_order -> 'productType', 'order.productType'
  );
  v_occurred_at := public.kf_opp_write_timestamp_internal(
    p_payload -> 'occurredAt', 'occurredAt'
  );

  PERFORM public.kf_opp_write_text_internal(v_order -> 'version', 'order.version');
  PERFORM public.kf_opp_write_text_internal(v_order -> 'theme', 'order.theme');
  PERFORM public.kf_opp_write_text_internal(p_payload -> 'eventVersion', 'eventVersion');

  IF NOT (v_product_type = ANY(ARRAY[
    'lesson_plan', 'didactic_text', 'reflective_activity', 'formative_assessment'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'order.productType is unsupported';
  END IF;

  IF v_order ? 'durationMinutes' THEN
    v_duration_minutes := public.kf_opp_write_positive_integer_internal(
      v_order -> 'durationMinutes', 'order.durationMinutes'
    );
  END IF;

  v_fingerprint := public.kf_opp_write_fingerprint_internal(v_operation, p_payload);
  PERFORM pg_advisory_xact_lock(hashtextextended(p_command_id::text, 0));

  SELECT * INTO v_receipt
  FROM public.kf_production_order_write_receipts AS receipts
  WHERE receipts.command_id = p_command_id;

  IF FOUND THEN
    IF v_receipt.requester_id <> v_requester_id
      OR v_receipt.operation <> v_operation
      OR v_receipt.payload_fingerprint <> v_fingerprint THEN
      RAISE EXCEPTION USING
        ERRCODE = 'PT409',
        MESSAGE = 'commandId was already used with different requester, operation, or payload';
    END IF;

    RETURN QUERY SELECT
      v_receipt.command_id,
      v_receipt.operation,
      v_receipt.opp_id,
      v_receipt.event_id,
      v_receipt.status,
      true,
      v_receipt.committed_at;
    RETURN;
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM public.kf_curriculum_packages AS packages
    WHERE packages.id = v_curriculum_package_id
  ) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'curriculum package was not found';
  END IF;

  IF EXISTS (SELECT 1 FROM public.kf_production_orders WHERE id = v_opp_id) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'production order id already exists';
  END IF;

  IF EXISTS (SELECT 1 FROM public.kf_production_order_events WHERE id = v_event_id) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'production order event id already exists';
  END IF;

  BEGIN
    INSERT INTO public.kf_production_orders (
      id, version, requester_id, agent_profile_id, curriculum_package_id, product_type,
      theme, duration_minutes, status, created_at, updated_at
    ) VALUES (
      v_opp_id,
      v_order ->> 'version',
      v_requester_id,
      v_agent_profile_id,
      v_curriculum_package_id,
      v_product_type,
      v_order ->> 'theme',
      v_duration_minutes,
      'requested',
      v_occurred_at,
      v_occurred_at
    );

    INSERT INTO public.kf_production_order_events (
      id, version, opp_id, event_type, from_status, to_status, reason, occurred_at
    ) VALUES (
      v_event_id,
      p_payload ->> 'eventVersion',
      v_opp_id,
      'created',
      NULL,
      'requested',
      NULL,
      v_occurred_at
    );

    INSERT INTO public.kf_production_order_write_receipts (
      command_id, requester_id, operation, payload_fingerprint, opp_id, event_id, status
    ) VALUES (
      p_command_id, v_requester_id, v_operation, v_fingerprint, v_opp_id, v_event_id, 'requested'
    )
    RETURNING kf_production_order_write_receipts.committed_at INTO v_committed_at;
  EXCEPTION
    WHEN unique_violation THEN
      RAISE EXCEPTION USING
        ERRCODE = 'PT409',
        MESSAGE = 'production order command conflicts with an existing identity';
  END;

  RETURN QUERY SELECT
    p_command_id, v_operation, v_opp_id, v_event_id, 'requested'::text, false, v_committed_at;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 4. SYSTEM command: transition OPP + derived event + receipt
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_transition_production_order(
  p_command_id uuid,
  p_payload jsonb
)
RETURNS TABLE (
  command_id uuid,
  operation text,
  opp_id uuid,
  event_id uuid,
  status text,
  replayed boolean,
  committed_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_operation CONSTANT text := 'transition_production_order';
  v_requester_id uuid;
  v_opp_id uuid;
  v_event_id uuid;
  v_expected_status text;
  v_expected_updated_at timestamptz;
  v_to_status text;
  v_event_type text;
  v_event_version text;
  v_reason text;
  v_occurred_at timestamptz;
  v_current_requester_id uuid;
  v_current_status text;
  v_current_updated_at timestamptz;
  v_fingerprint text;
  v_receipt public.kf_production_order_write_receipts%ROWTYPE;
  v_committed_at timestamptz;
BEGIN
  IF p_command_id IS NULL THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'commandId is required';
  END IF;

  PERFORM public.kf_opp_write_assert_object_internal(
    p_payload,
    ARRAY[
      'eventId', 'eventVersion', 'expectedStatus', 'expectedUpdatedAt', 'occurredAt',
      'oppId', 'requesterId', 'toStatus'
    ],
    ARRAY[
      'eventId', 'eventVersion', 'expectedStatus', 'expectedUpdatedAt', 'occurredAt',
      'oppId', 'reason', 'requesterId', 'toStatus'
    ],
    'transitionProductionOrder payload'
  );

  v_requester_id := public.kf_opp_write_uuid_internal(
    p_payload -> 'requesterId', 'requesterId'
  );
  v_opp_id := public.kf_opp_write_uuid_internal(p_payload -> 'oppId', 'oppId');
  v_event_id := public.kf_opp_write_uuid_internal(p_payload -> 'eventId', 'eventId');
  v_expected_status := public.kf_opp_write_text_internal(
    p_payload -> 'expectedStatus', 'expectedStatus'
  );
  v_expected_updated_at := public.kf_opp_write_timestamp_internal(
    p_payload -> 'expectedUpdatedAt', 'expectedUpdatedAt'
  );
  v_to_status := public.kf_opp_write_text_internal(p_payload -> 'toStatus', 'toStatus');
  v_event_version := public.kf_opp_write_text_internal(
    p_payload -> 'eventVersion', 'eventVersion'
  );
  v_occurred_at := public.kf_opp_write_timestamp_internal(
    p_payload -> 'occurredAt', 'occurredAt'
  );

  IF p_payload ? 'reason' THEN
    v_reason := public.kf_opp_write_text_internal(p_payload -> 'reason', 'reason');
  END IF;

  IF NOT (v_expected_status = ANY(ARRAY[
    'requested', 'scoped', 'retrieving', 'assembling', 'validating', 'ready',
    'insufficient', 'blocked', 'failed'
  ])) OR NOT (v_to_status = ANY(ARRAY[
    'requested', 'scoped', 'retrieving', 'assembling', 'validating', 'ready',
    'insufficient', 'blocked', 'failed'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'production order status is unsupported';
  END IF;

  IF NOT public.kf_opp_transition_allowed_internal(v_expected_status, v_to_status) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'production order status transition is invalid';
  END IF;

  v_event_type := public.kf_opp_event_type_internal(v_to_status);
  IF v_event_type IS NULL OR v_event_type = 'created' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'transition event type could not be derived';
  END IF;

  v_fingerprint := public.kf_opp_write_fingerprint_internal(v_operation, p_payload);
  PERFORM pg_advisory_xact_lock(hashtextextended(p_command_id::text, 0));

  SELECT * INTO v_receipt
  FROM public.kf_production_order_write_receipts AS receipts
  WHERE receipts.command_id = p_command_id;

  IF FOUND THEN
    IF v_receipt.requester_id <> v_requester_id
      OR v_receipt.operation <> v_operation
      OR v_receipt.payload_fingerprint <> v_fingerprint THEN
      RAISE EXCEPTION USING
        ERRCODE = 'PT409',
        MESSAGE = 'commandId was already used with different requester, operation, or payload';
    END IF;

    RETURN QUERY SELECT
      v_receipt.command_id,
      v_receipt.operation,
      v_receipt.opp_id,
      v_receipt.event_id,
      v_receipt.status,
      true,
      v_receipt.committed_at;
    RETURN;
  END IF;

  SELECT orders.requester_id, orders.status, orders.updated_at
  INTO v_current_requester_id, v_current_status, v_current_updated_at
  FROM public.kf_production_orders AS orders
  WHERE orders.id = v_opp_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'production order was not found';
  END IF;

  IF v_current_requester_id <> v_requester_id THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'production order was not found';
  END IF;

  IF v_current_status <> v_expected_status
    OR v_current_updated_at IS DISTINCT FROM v_expected_updated_at THEN
    RAISE EXCEPTION USING
      ERRCODE = 'PT409',
      MESSAGE = 'production order does not match the expected state';
  END IF;

  IF v_occurred_at < v_current_updated_at THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'occurredAt must not precede the current production order timestamp';
  END IF;

  IF NOT public.kf_opp_transition_allowed_internal(v_current_status, v_to_status) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'production order status transition is invalid';
  END IF;

  IF EXISTS (SELECT 1 FROM public.kf_production_order_events WHERE id = v_event_id) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'production order event id already exists';
  END IF;

  BEGIN
    UPDATE public.kf_production_orders
    SET status = v_to_status, updated_at = v_occurred_at
    WHERE id = v_opp_id;

    INSERT INTO public.kf_production_order_events (
      id, version, opp_id, event_type, from_status, to_status, reason, occurred_at
    ) VALUES (
      v_event_id,
      v_event_version,
      v_opp_id,
      v_event_type,
      v_current_status,
      v_to_status,
      v_reason,
      v_occurred_at
    );

    INSERT INTO public.kf_production_order_write_receipts (
      command_id, requester_id, operation, payload_fingerprint, opp_id, event_id, status
    ) VALUES (
      p_command_id,
      v_requester_id,
      v_operation,
      v_fingerprint,
      v_opp_id,
      v_event_id,
      v_to_status
    )
    RETURNING kf_production_order_write_receipts.committed_at INTO v_committed_at;
  EXCEPTION
    WHEN unique_violation THEN
      RAISE EXCEPTION USING
        ERRCODE = 'PT409',
        MESSAGE = 'production order command conflicts with an existing identity';
  END;

  RETURN QUERY SELECT
    p_command_id, v_operation, v_opp_id, v_event_id, v_to_status, false, v_committed_at;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 5. Ownership and least privilege
-- ---------------------------------------------------------------------------
ALTER TABLE public.kf_production_order_write_receipts OWNER TO postgres;

ALTER FUNCTION public.kf_opp_write_assert_object_internal(jsonb, text[], text[], text)
  OWNER TO postgres;
ALTER FUNCTION public.kf_opp_write_text_internal(jsonb, text, boolean)
  OWNER TO postgres;
ALTER FUNCTION public.kf_opp_write_uuid_internal(jsonb, text)
  OWNER TO postgres;
ALTER FUNCTION public.kf_opp_write_timestamp_internal(jsonb, text)
  OWNER TO postgres;
ALTER FUNCTION public.kf_opp_write_positive_integer_internal(jsonb, text)
  OWNER TO postgres;
ALTER FUNCTION public.kf_opp_write_fingerprint_internal(text, jsonb)
  OWNER TO postgres;
ALTER FUNCTION public.kf_opp_transition_allowed_internal(text, text)
  OWNER TO postgres;
ALTER FUNCTION public.kf_opp_event_type_internal(text)
  OWNER TO postgres;

ALTER FUNCTION public.kf_create_production_order(uuid, jsonb) OWNER TO postgres;
ALTER FUNCTION public.kf_transition_production_order(uuid, jsonb) OWNER TO postgres;

REVOKE ALL ON FUNCTION
  public.kf_create_production_order(uuid, jsonb),
  public.kf_transition_production_order(uuid, jsonb)
FROM PUBLIC, anon, authenticated, service_role;

GRANT EXECUTE ON FUNCTION public.kf_create_production_order(uuid, jsonb)
TO authenticated;

GRANT EXECUTE ON FUNCTION public.kf_transition_production_order(uuid, jsonb)
TO service_role;

-- Reads remain unchanged. Every OPP/event write must now cross one of the two
-- command functions; service_role is not a direct-DML escape hatch.
REVOKE INSERT ON TABLE public.kf_production_orders FROM authenticated;
REVOKE INSERT, UPDATE ON TABLE public.kf_production_orders FROM service_role;
REVOKE INSERT ON TABLE public.kf_production_order_events FROM service_role;

COMMIT;
