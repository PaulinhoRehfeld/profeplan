-- =============================================================================
-- Knowledge Factory Sublote 3B.5.3 - transactional OPP write validation
-- NON-PRODUCTION ONLY. All fixtures are synthetic and rolled back.
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION pg_temp.kf_assert(p_condition boolean, p_message text)
RETURNS void
LANGUAGE plpgsql
AS $function$
BEGIN
  IF p_condition IS NOT TRUE THEN
    RAISE EXCEPTION 'ASSERTION FAILED: %', p_message;
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION pg_temp.kf_expect_error(
  p_sql text,
  p_allowed_states text[],
  p_message text
)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
  v_state text;
BEGIN
  BEGIN
    EXECUTE p_sql;
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_state = RETURNED_SQLSTATE;
    IF v_state = ANY(p_allowed_states) THEN
      RETURN;
    END IF;

    RAISE EXCEPTION
      'ASSERTION FAILED: %; unexpected SQLSTATE %, error: %',
      p_message,
      v_state,
      SQLERRM;
  END;

  RAISE EXCEPTION 'ASSERTION FAILED: %; statement unexpectedly succeeded', p_message;
END;
$function$;

CREATE OR REPLACE FUNCTION pg_temp.kf_set_identity(p_role text, p_user_id uuid)
RETURNS void
LANGUAGE plpgsql
AS $function$
BEGIN
  PERFORM set_config('request.jwt.claim.sub', p_user_id::text, true);
  PERFORM set_config(
    'request.jwt.claims',
    jsonb_build_object('sub', p_user_id::text, 'role', p_role)::text,
    true
  );
END;
$function$;

CREATE OR REPLACE FUNCTION pg_temp.kf_create_opp_payload(
  p_opp_id uuid,
  p_event_id uuid,
  p_package_id uuid,
  p_theme text,
  p_occurred_at timestamptz,
  p_duration_minutes integer DEFAULT NULL
)
RETURNS jsonb
LANGUAGE sql
IMMUTABLE
AS $function$
  SELECT jsonb_build_object(
    'order', jsonb_strip_nulls(jsonb_build_object(
      'id', p_opp_id::text,
      'version', '1.0.0',
      'agentProfileId', 'a1000000-0000-4000-8000-000000000001',
      'curriculumPackageId', p_package_id::text,
      'productType', 'lesson_plan',
      'theme', p_theme,
      'durationMinutes', p_duration_minutes
    )),
    'eventId', p_event_id::text,
    'eventVersion', '1.0.0',
    'occurredAt', to_char(p_occurred_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"')
  )
$function$;

CREATE OR REPLACE FUNCTION pg_temp.kf_transition_opp_payload(
  p_requester_id uuid,
  p_opp_id uuid,
  p_expected_status text,
  p_expected_updated_at timestamptz,
  p_to_status text,
  p_event_id uuid,
  p_occurred_at timestamptz,
  p_reason text DEFAULT NULL
)
RETURNS jsonb
LANGUAGE sql
IMMUTABLE
AS $function$
  SELECT jsonb_strip_nulls(jsonb_build_object(
    'requesterId', p_requester_id::text,
    'oppId', p_opp_id::text,
    'expectedStatus', p_expected_status,
    'expectedUpdatedAt',
      to_char(p_expected_updated_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'),
    'toStatus', p_to_status,
    'eventId', p_event_id::text,
    'eventVersion', '1.0.0',
    'reason', p_reason,
    'occurredAt', to_char(p_occurred_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"')
  ))
$function$;

CREATE OR REPLACE FUNCTION public.kf_test_fail_selected_opp_receipt()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
  IF NEW.command_id IN (
    'c5000000-0000-4000-8000-000000000091'::uuid,
    'c5000000-0000-4000-8000-000000000092'::uuid
  ) THEN
    RAISE EXCEPTION 'synthetic receipt failure';
  END IF;
  RETURN NEW;
END;
$function$;

CREATE TRIGGER kf_test_fail_selected_opp_receipt
BEFORE INSERT ON public.kf_production_order_write_receipts
FOR EACH ROW EXECUTE FUNCTION public.kf_test_fail_selected_opp_receipt();

-- Synthetic identities and one draft package avoid the active-package unique index.
INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, created_at, updated_at
) VALUES
(
  '00000000-0000-0000-0000-000000000000',
  'a5000000-0000-4000-8000-000000000001',
  'authenticated', 'authenticated', 'opp-a@example.invalid', '', now(), now(), now()
),
(
  '00000000-0000-0000-0000-000000000000',
  'a5000000-0000-4000-8000-000000000002',
  'authenticated', 'authenticated', 'opp-b@example.invalid', '', now(), now(), now()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.kf_curriculum_packages (
  id, version, state, stage, status, title, effective_from
) VALUES (
  'b5000000-0000-4000-8000-000000000001',
  '1.0.0', 'MG', 'ensino_medio', 'draft', 'Synthetic OPP transaction package',
  '2026-08-11T19:00:00.000Z'
);

SELECT pg_temp.kf_assert(
  to_regclass('public.kf_production_order_write_receipts') IS NOT NULL,
  'the OPP idempotency receipt table must exist'
);
SELECT pg_temp.kf_assert(
  has_function_privilege('authenticated', 'public.kf_create_production_order(uuid,jsonb)', 'EXECUTE'),
  'authenticated must execute only the OPP creation command'
);
SELECT pg_temp.kf_assert(
  NOT has_function_privilege('anon', 'public.kf_create_production_order(uuid,jsonb)', 'EXECUTE')
    AND NOT has_function_privilege(
      'anon', 'public.kf_transition_production_order(uuid,jsonb)', 'EXECUTE'
    ),
  'anon must execute neither OPP command'
);
SELECT pg_temp.kf_assert(
  NOT has_function_privilege(
    'authenticated', 'public.kf_transition_production_order(uuid,jsonb)', 'EXECUTE'
  ),
  'authenticated must not execute the OPP transition command'
);
SELECT pg_temp.kf_assert(
  has_function_privilege(
    'service_role', 'public.kf_transition_production_order(uuid,jsonb)', 'EXECUTE'
  ),
  'service_role must execute the OPP transition command'
);
SELECT pg_temp.kf_assert(
  NOT has_function_privilege('service_role', 'public.kf_create_production_order(uuid,jsonb)', 'EXECUTE'),
  'service_role must not replace REQUESTER creation'
);
SELECT pg_temp.kf_assert(
  NOT has_table_privilege('authenticated', 'public.kf_production_orders', 'INSERT')
    AND NOT has_table_privilege('service_role', 'public.kf_production_orders', 'INSERT')
    AND NOT has_table_privilege('service_role', 'public.kf_production_orders', 'UPDATE')
    AND NOT has_table_privilege('service_role', 'public.kf_production_order_events', 'INSERT'),
  'direct OPP/event DML must be revoked'
);
SELECT pg_temp.kf_assert(
  NOT has_table_privilege(
    'authenticated', 'public.kf_production_order_write_receipts', 'SELECT'
  ) AND NOT has_table_privilege(
    'service_role', 'public.kf_production_order_write_receipts', 'SELECT'
  ),
  'API roles must not read OPP receipts directly'
);
SELECT pg_temp.kf_assert(
  NOT has_function_privilege(
    'authenticated', 'public.kf_opp_transition_allowed_internal(text,text)', 'EXECUTE'
  ) AND NOT has_function_privilege(
    'service_role', 'public.kf_opp_event_type_internal(text)', 'EXECUTE'
  ),
  'API roles must not execute OPP validation helpers'
);

WITH statuses(value) AS (
  VALUES
    ('requested'), ('scoped'), ('retrieving'), ('assembling'), ('validating'),
    ('ready'), ('insufficient'), ('blocked'), ('failed')
), expected(from_status, to_status) AS (
  VALUES
    ('requested', 'scoped'), ('requested', 'blocked'), ('requested', 'failed'),
    ('scoped', 'retrieving'), ('scoped', 'blocked'), ('scoped', 'failed'),
    ('retrieving', 'assembling'), ('retrieving', 'insufficient'),
    ('retrieving', 'blocked'), ('retrieving', 'failed'),
    ('assembling', 'validating'), ('assembling', 'insufficient'), ('assembling', 'failed'),
    ('validating', 'ready'), ('validating', 'insufficient'),
    ('validating', 'blocked'), ('validating', 'failed')
)
SELECT pg_temp.kf_assert(
  NOT EXISTS (
    SELECT 1
    FROM statuses AS source
    CROSS JOIN statuses AS target
    WHERE public.kf_opp_transition_allowed_internal(source.value, target.value)
      IS DISTINCT FROM (EXISTS (
        SELECT 1
        FROM expected
        WHERE expected.from_status = source.value
          AND expected.to_status = target.value
      ))
  ),
  'SQL OPP transition matrix must match the TypeScript contract'
);

-- ---------------------------------------------------------------------------
-- REQUESTER creation: closed payload, derived ownership/status/timestamps and
-- one atomic created event.
-- ---------------------------------------------------------------------------
SET LOCAL ROLE authenticated;
SELECT pg_temp.kf_set_identity(
  'authenticated', 'a5000000-0000-4000-8000-000000000001'
);

SELECT * FROM public.kf_create_production_order(
  'c5000000-0000-4000-8000-000000000001',
  pg_temp.kf_create_opp_payload(
    'd5000000-0000-4000-8000-000000000001',
    'e5000000-0000-4000-8000-000000000001',
    'b5000000-0000-4000-8000-000000000001',
    'Synthetic atomic OPP',
    '2026-08-11T19:01:00.000Z',
    50
  )
);

SELECT pg_temp.kf_expect_error(
  $sql$
    INSERT INTO public.kf_production_orders (
      version, requester_id, agent_profile_id, curriculum_package_id,
      product_type, theme, status
    ) VALUES (
      '1.0.0', 'a5000000-0000-4000-8000-000000000001',
      'a1000000-0000-4000-8000-000000000001',
      'b5000000-0000-4000-8000-000000000001',
      'lesson_plan', 'Direct DML must fail', 'requested'
    )
  $sql$,
  ARRAY['42501'],
  'authenticated direct OPP INSERT must fail'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_transition_production_order(
      'c5000000-0000-4000-8000-000000000010',
      pg_temp.kf_transition_opp_payload(
        'a5000000-0000-4000-8000-000000000001',
        'd5000000-0000-4000-8000-000000000001',
        'requested', '2026-08-11T19:01:00.000Z', 'scoped',
        'e5000000-0000-4000-8000-000000000010',
        '2026-08-11T19:02:00.000Z'
      )
    )
  $sql$,
  ARRAY['42501'],
  'authenticated must not execute the server-only transition RPC'
);

RESET ROLE;

SELECT pg_temp.kf_assert(
  (
    SELECT requester_id = 'a5000000-0000-4000-8000-000000000001'
      AND status = 'requested'
      AND created_at = '2026-08-11T19:01:00.000Z'
      AND updated_at = '2026-08-11T19:01:00.000Z'
      AND duration_minutes = 50
    FROM public.kf_production_orders
    WHERE id = 'd5000000-0000-4000-8000-000000000001'
  ),
  'creation must derive requester, requested status and order timestamps'
);
SELECT pg_temp.kf_assert(
  (
    SELECT count(*) = 1
      AND bool_and(event_type = 'created')
      AND bool_and(from_status IS NULL)
      AND bool_and(to_status = 'requested')
    FROM public.kf_production_order_events
    WHERE opp_id = 'd5000000-0000-4000-8000-000000000001'
  ),
  'creation must append exactly one derived created event'
);
SELECT pg_temp.kf_assert(
  (
    SELECT count(*) = 1
      AND bool_and(operation = 'create_production_order')
      AND bool_and(status = 'requested')
    FROM public.kf_production_order_write_receipts
    WHERE command_id = 'c5000000-0000-4000-8000-000000000001'
  ),
  'creation must commit exactly one minimal receipt'
);

-- Exact replay returns the receipt and never duplicates rows.
SET LOCAL ROLE authenticated;
SELECT pg_temp.kf_set_identity(
  'authenticated', 'a5000000-0000-4000-8000-000000000001'
);
SELECT pg_temp.kf_assert(
  (
    SELECT replayed
    FROM public.kf_create_production_order(
      'c5000000-0000-4000-8000-000000000001',
      pg_temp.kf_create_opp_payload(
        'd5000000-0000-4000-8000-000000000001',
        'e5000000-0000-4000-8000-000000000001',
        'b5000000-0000-4000-8000-000000000001',
        'Synthetic atomic OPP',
        '2026-08-11T19:01:00.000Z',
        50
      )
    )
  ),
  'identical create command must replay'
);
SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_create_production_order(
      'c5000000-0000-4000-8000-000000000001',
      pg_temp.kf_create_opp_payload(
        'd5000000-0000-4000-8000-000000000001',
        'e5000000-0000-4000-8000-000000000001',
        'b5000000-0000-4000-8000-000000000001',
        'Different fingerprint', '2026-08-11T19:01:00.000Z', 50
      )
    )
  $sql$,
  ARRAY['PT409'],
  'same create commandId with a different fingerprint must conflict'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_create_production_order(
      'c5000000-0000-4000-8000-000000000020',
      pg_temp.kf_create_opp_payload(
        'd5000000-0000-4000-8000-000000000020',
        'e5000000-0000-4000-8000-000000000020',
        'b5000000-0000-4000-8000-000000000001',
        'Closed payload', '2026-08-11T19:01:00.000Z'
      ) || jsonb_build_object('requesterId', 'a5000000-0000-4000-8000-000000000002')
    )
  $sql$,
  ARRAY['22023'],
  'create payload must not choose requester'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_create_production_order(
      'c5000000-0000-4000-8000-000000000021',
      jsonb_set(
        pg_temp.kf_create_opp_payload(
          'd5000000-0000-4000-8000-000000000021',
          'e5000000-0000-4000-8000-000000000021',
          'b5000000-0000-4000-8000-000000000001',
          'Fractional duration', '2026-08-11T19:01:00.000Z'
        ),
        '{order,durationMinutes}',
        '1.5'::jsonb
      )
    )
  $sql$,
  ARRAY['22023'],
  'durationMinutes must reject fractional JSON numbers'
);
RESET ROLE;

-- Reusing a create commandId under another requester conflicts rather than
-- replaying another user's receipt.
SET LOCAL ROLE authenticated;
SELECT pg_temp.kf_set_identity(
  'authenticated', 'a5000000-0000-4000-8000-000000000002'
);
SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_create_production_order(
      'c5000000-0000-4000-8000-000000000001',
      pg_temp.kf_create_opp_payload(
        'd5000000-0000-4000-8000-000000000001',
        'e5000000-0000-4000-8000-000000000001',
        'b5000000-0000-4000-8000-000000000001',
        'Synthetic atomic OPP', '2026-08-11T19:01:00.000Z', 50
      )
    )
  $sql$,
  ARRAY['PT409'],
  'create commandId must be requester-scoped'
);
RESET ROLE;

-- Failure at the third mutation proves order + event + receipt rollback.
SET LOCAL ROLE authenticated;
SELECT pg_temp.kf_set_identity(
  'authenticated', 'a5000000-0000-4000-8000-000000000001'
);
SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_create_production_order(
      'c5000000-0000-4000-8000-000000000091',
      pg_temp.kf_create_opp_payload(
        'd5000000-0000-4000-8000-000000000091',
        'e5000000-0000-4000-8000-000000000091',
        'b5000000-0000-4000-8000-000000000001',
        'Synthetic rollback create', '2026-08-11T19:01:30.000Z'
      )
    )
  $sql$,
  ARRAY['P0001'],
  'receipt failure must roll back create order and event'
);
RESET ROLE;
SELECT pg_temp.kf_assert(
  NOT EXISTS (
    SELECT 1 FROM public.kf_production_orders
    WHERE id = 'd5000000-0000-4000-8000-000000000091'
  ) AND NOT EXISTS (
    SELECT 1 FROM public.kf_production_order_events
    WHERE id = 'e5000000-0000-4000-8000-000000000091'
  ) AND NOT EXISTS (
    SELECT 1 FROM public.kf_production_order_write_receipts
    WHERE command_id = 'c5000000-0000-4000-8000-000000000091'
  ),
  'failed creation must leave no partial mutation'
);

-- ---------------------------------------------------------------------------
-- SYSTEM transition: ownership + compare-and-set + structural matrix +
-- derived event + one atomic receipt.
-- ---------------------------------------------------------------------------
SET LOCAL ROLE service_role;

SELECT * FROM public.kf_transition_production_order(
  'c5000000-0000-4000-8000-000000000002',
  pg_temp.kf_transition_opp_payload(
    'a5000000-0000-4000-8000-000000000001',
    'd5000000-0000-4000-8000-000000000001',
    'requested', '2026-08-11T19:01:00.000Z', 'scoped',
    'e5000000-0000-4000-8000-000000000002',
    '2026-08-11T19:02:00.000Z',
    'Synthetic scope accepted by application policy'
  )
);

SELECT pg_temp.kf_assert(
  (
    SELECT replayed
    FROM public.kf_transition_production_order(
      'c5000000-0000-4000-8000-000000000002',
      pg_temp.kf_transition_opp_payload(
        'a5000000-0000-4000-8000-000000000001',
        'd5000000-0000-4000-8000-000000000001',
        'requested', '2026-08-11T19:01:00.000Z', 'scoped',
        'e5000000-0000-4000-8000-000000000002',
        '2026-08-11T19:02:00.000Z',
        'Synthetic scope accepted by application policy'
      )
    )
  ),
  'identical transition command must replay after state advances'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_transition_production_order(
      'c5000000-0000-4000-8000-000000000002',
      pg_temp.kf_transition_opp_payload(
        'a5000000-0000-4000-8000-000000000001',
        'd5000000-0000-4000-8000-000000000001',
        'requested', '2026-08-11T19:01:00.000Z', 'scoped',
        'e5000000-0000-4000-8000-000000000002',
        '2026-08-11T19:02:00.000Z',
        'Different transition fingerprint'
      )
    )
  $sql$,
  ARRAY['PT409'],
  'same transition commandId with a different fingerprint must conflict'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_transition_production_order(
      'c5000000-0000-4000-8000-000000000003',
      pg_temp.kf_transition_opp_payload(
        'a5000000-0000-4000-8000-000000000002',
        'd5000000-0000-4000-8000-000000000001',
        'scoped', '2026-08-11T19:02:00.000Z', 'retrieving',
        'e5000000-0000-4000-8000-000000000003',
        '2026-08-11T19:03:00.000Z'
      )
    )
  $sql$,
  ARRAY['P0002'],
  'requester mismatch must remain indistinguishable from missing'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_transition_production_order(
      'c5000000-0000-4000-8000-000000000004',
      pg_temp.kf_transition_opp_payload(
        'a5000000-0000-4000-8000-000000000001',
        'd5000000-0000-4000-8000-000000000001',
        'requested', '2026-08-11T19:02:00.000Z', 'scoped',
        'e5000000-0000-4000-8000-000000000004',
        '2026-08-11T19:03:00.000Z'
      )
    )
  $sql$,
  ARRAY['PT409'],
  'stale expectedStatus must conflict'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_transition_production_order(
      'c5000000-0000-4000-8000-000000000005',
      pg_temp.kf_transition_opp_payload(
        'a5000000-0000-4000-8000-000000000001',
        'd5000000-0000-4000-8000-000000000001',
        'scoped', '2026-08-11T19:01:59.000Z', 'retrieving',
        'e5000000-0000-4000-8000-000000000005',
        '2026-08-11T19:03:00.000Z'
      )
    )
  $sql$,
  ARRAY['PT409'],
  'stale expectedUpdatedAt must conflict'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_transition_production_order(
      'c5000000-0000-4000-8000-000000000006',
      pg_temp.kf_transition_opp_payload(
        'a5000000-0000-4000-8000-000000000001',
        'd5000000-0000-4000-8000-000000000001',
        'scoped', '2026-08-11T19:02:00.000Z', 'ready',
        'e5000000-0000-4000-8000-000000000006',
        '2026-08-11T19:03:00.000Z'
      )
    )
  $sql$,
  ARRAY['22023'],
  'invalid structural transition must fail'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_transition_production_order(
      'c5000000-0000-4000-8000-000000000007',
      pg_temp.kf_transition_opp_payload(
        'a5000000-0000-4000-8000-000000000001',
        'd5000000-0000-4000-8000-000000000001',
        'scoped', '2026-08-11T19:02:00.000Z', 'retrieving',
        'e5000000-0000-4000-8000-000000000007',
        '2026-08-11T19:01:59.000Z'
      )
    )
  $sql$,
  ARRAY['22023'],
  'out-of-order transition event must fail'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_transition_production_order(
      'c5000000-0000-4000-8000-000000000008',
      pg_temp.kf_transition_opp_payload(
        'a5000000-0000-4000-8000-000000000001',
        'd5000000-0000-4000-8000-000000000001',
        'scoped', '2026-08-11T19:02:00.000Z', 'retrieving',
        'e5000000-0000-4000-8000-000000000001',
        '2026-08-11T19:03:00.000Z'
      )
    )
  $sql$,
  ARRAY['PT409'],
  'transition event identity must be unique'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    UPDATE public.kf_production_orders
    SET status = 'retrieving'
    WHERE id = 'd5000000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['42501'],
  'service_role direct OPP UPDATE must fail'
);
SELECT pg_temp.kf_expect_error(
  $sql$
    INSERT INTO public.kf_production_order_events (
      version, opp_id, event_type, from_status, to_status, occurred_at
    ) VALUES (
      '1.0.0', 'd5000000-0000-4000-8000-000000000001',
      'retrieval_started', 'scoped', 'retrieving', '2026-08-11T19:03:00.000Z'
    )
  $sql$,
  ARRAY['42501'],
  'service_role direct OPP event INSERT must fail'
);

-- Failure on receipt insertion must roll back the status update and event.
SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_transition_production_order(
      'c5000000-0000-4000-8000-000000000092',
      pg_temp.kf_transition_opp_payload(
        'a5000000-0000-4000-8000-000000000001',
        'd5000000-0000-4000-8000-000000000001',
        'scoped', '2026-08-11T19:02:00.000Z', 'retrieving',
        'e5000000-0000-4000-8000-000000000092',
        '2026-08-11T19:03:00.000Z'
      )
    )
  $sql$,
  ARRAY['P0001'],
  'receipt failure must roll back transition update and event'
);
RESET ROLE;

SELECT pg_temp.kf_assert(
  (
    SELECT status = 'scoped' AND updated_at = '2026-08-11T19:02:00.000Z'
    FROM public.kf_production_orders
    WHERE id = 'd5000000-0000-4000-8000-000000000001'
  ) AND NOT EXISTS (
    SELECT 1 FROM public.kf_production_order_events
    WHERE id = 'e5000000-0000-4000-8000-000000000092'
  ) AND NOT EXISTS (
    SELECT 1 FROM public.kf_production_order_write_receipts
    WHERE command_id = 'c5000000-0000-4000-8000-000000000092'
  ),
  'failed transition must leave status, timeline and receipts unchanged'
);

SELECT pg_temp.kf_assert(
  (
    SELECT status = 'scoped' AND updated_at = '2026-08-11T19:02:00.000Z'
    FROM public.kf_production_orders
    WHERE id = 'd5000000-0000-4000-8000-000000000001'
  ),
  'successful transition must update status and timestamp atomically'
);
SELECT pg_temp.kf_assert(
  (
    SELECT count(*) = 1
      AND bool_and(event_type = 'scope_resolved')
      AND bool_and(from_status = 'requested')
      AND bool_and(to_status = 'scoped')
    FROM public.kf_production_order_events
    WHERE id = 'e5000000-0000-4000-8000-000000000002'
  ),
  'transition must derive the event type and states'
);

-- Append-only remains effective even for the privileged owner.
SELECT pg_temp.kf_expect_error(
  $sql$
    UPDATE public.kf_production_order_events
    SET reason = 'mutated'
    WHERE id = 'e5000000-0000-4000-8000-000000000002'
  $sql$,
  ARRAY['55000'],
  'OPP events must remain append-only after 3B.5.3'
);

DROP TRIGGER kf_test_fail_selected_opp_receipt
ON public.kf_production_order_write_receipts;
DROP FUNCTION public.kf_test_fail_selected_opp_receipt();

ROLLBACK;
