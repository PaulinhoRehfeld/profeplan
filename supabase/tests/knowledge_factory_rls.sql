-- =============================================================================
-- Knowledge Factory Lote 3A - RLS/isolation tests
-- NON-PRODUCTION ONLY. Run as a privileged migration/test role in a disposable
-- Supabase/PostgreSQL environment after the Lote 3A migration is applied.
-- All auth/profile/domain fixtures are synthetic and rolled back.
-- =============================================================================

BEGIN;

-- Synthetic users. The auth.users shape below matches standard Supabase Auth.
INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at
) VALUES
(
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'kf-teacher-a@example.invalid', '', now(),
  '{}'::jsonb, '{}'::jsonb, now(), now()
),
(
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb2',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'kf-teacher-b@example.invalid', '', now(),
  '{}'::jsonb, '{}'::jsonb, now(), now()
),
(
  'cccccccc-cccc-4ccc-8ccc-ccccccccccc3',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'kf-admin@example.invalid', '', now(),
  '{}'::jsonb, '{}'::jsonb, now(), now()
)
ON CONFLICT (id) DO NOTHING;

-- Upsert only the columns required by the Knowledge Factory admin helper.
INSERT INTO public.profiles (id, email, full_name, role, is_admin)
VALUES
(
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1',
  'kf-teacher-a@example.invalid', 'KF Synthetic Teacher A', 'teacher', false
),
(
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb2',
  'kf-teacher-b@example.invalid', 'KF Synthetic School Admin B', 'school_admin', false
),
(
  'cccccccc-cccc-4ccc-8ccc-ccccccccccc3',
  'kf-admin@example.invalid', 'KF Synthetic Platform Admin', 'admin', true
)
ON CONFLICT (id) DO UPDATE
SET email = EXCLUDED.email,
    full_name = EXCLUDED.full_name,
    role = EXCLUDED.role,
    is_admin = EXCLUDED.is_admin;

-- Global corpus fixtures inserted by privileged test executor.
INSERT INTO public.kf_sources (
  id, version, title, source_type, status, license_category, allowed_uses
) VALUES (
  '11111111-1111-4111-8111-111111111111',
  '1.0.0', 'WRTECH-SYNTHETIC-SOURCE-RLS', 'wrtech_owned', 'approved', 'owned',
  ARRAY['retrieval']
);

INSERT INTO public.kf_curriculum_packages (
  id, version, state, stage, status, title, effective_from
) VALUES (
  '33333333-3333-4333-8333-333333333331',
  '1.0.0', 'MG', 'ensino_medio', 'active', 'SYN-MG-EM-RLS', now()
);

INSERT INTO public.kf_audit_events (
  id, event_type, aggregate_type, aggregate_id, occurred_at, metadata
) VALUES (
  '44444444-4444-4444-8444-444444444441',
  'synthetic_rls_test', 'source', '11111111-1111-4111-8111-111111111111', now(),
  '{"synthetic":true}'::jsonb
);

-- OPP fixtures owned by A and B; inserted as privileged executor so we can test reads.
INSERT INTO public.kf_production_orders (
  id, version, requester_id, agent_profile_id, curriculum_package_id, product_type,
  theme, status
) VALUES
(
  '55555555-5555-4555-8555-555555555551', '1.0.0',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1',
  '66666666-6666-4666-8666-666666666661',
  '33333333-3333-4333-8333-333333333331',
  'lesson_plan', 'Tema sintético A', 'requested'
),
(
  '55555555-5555-4555-8555-555555555552', '1.0.0',
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb2',
  '66666666-6666-4666-8666-666666666661',
  '33333333-3333-4333-8333-333333333331',
  'lesson_plan', 'Tema sintético B', 'requested'
);

INSERT INTO public.kf_production_order_events (
  id, version, opp_id, event_type, to_status, occurred_at
) VALUES
(
  '77777777-7777-4777-8777-777777777771', '1.0.0',
  '55555555-5555-4555-8555-555555555551', 'created', 'requested', now()
),
(
  '77777777-7777-4777-8777-777777777772', '1.0.0',
  '55555555-5555-4555-8555-555555555552', 'created', 'requested', now()
);

-- Helper used only inside this transaction to emulate Supabase JWT identity.
CREATE OR REPLACE FUNCTION pg_temp.kf_set_test_identity(p_role text, p_user_id uuid)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  PERFORM set_config('request.jwt.claim.sub', p_user_id::text, true);
  PERFORM set_config(
    'request.jwt.claims',
    json_build_object('sub', p_user_id::text, 'role', p_role)::text,
    true
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- anon: no direct access
-- ---------------------------------------------------------------------------
SET LOCAL ROLE anon;
SELECT pg_temp.kf_set_test_identity('anon', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1');

DO $$
BEGIN
  BEGIN
    PERFORM 1 FROM public.kf_sources LIMIT 1;
    RAISE EXCEPTION 'anon unexpectedly read kf_sources';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END;
$$;

RESET ROLE;

-- ---------------------------------------------------------------------------
-- teacher A: corpus hidden, own OPP visible, B OPP hidden
-- ---------------------------------------------------------------------------
SET LOCAL ROLE authenticated;
SELECT pg_temp.kf_set_test_identity('authenticated', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1');

DO $$
DECLARE
  n integer;
BEGIN
  SELECT count(*) INTO n FROM public.kf_sources;
  IF n <> 0 THEN
    RAISE EXCEPTION 'teacher A unexpectedly read global corpus';
  END IF;

  SELECT count(*) INTO n FROM public.kf_source_segments;
  IF n <> 0 THEN
    RAISE EXCEPTION 'teacher A unexpectedly read raw segments';
  END IF;

  SELECT count(*) INTO n FROM public.kf_audit_events;
  IF n <> 0 THEN
    RAISE EXCEPTION 'teacher A unexpectedly read audit events';
  END IF;

  SELECT count(*) INTO n
  FROM public.kf_production_orders
  WHERE id = '55555555-5555-4555-8555-555555555551';
  IF n <> 1 THEN
    RAISE EXCEPTION 'teacher A cannot read own OPP';
  END IF;

  SELECT count(*) INTO n
  FROM public.kf_production_orders
  WHERE id = '55555555-5555-4555-8555-555555555552';
  IF n <> 0 THEN
    RAISE EXCEPTION 'teacher A unexpectedly read teacher B OPP';
  END IF;

  SELECT count(*) INTO n
  FROM public.kf_production_order_events
  WHERE opp_id = '55555555-5555-4555-8555-555555555551';
  IF n <> 1 THEN
    RAISE EXCEPTION 'teacher A cannot read own OPP events';
  END IF;

  SELECT count(*) INTO n
  FROM public.kf_production_order_events
  WHERE opp_id = '55555555-5555-4555-8555-555555555552';
  IF n <> 0 THEN
    RAISE EXCEPTION 'teacher A unexpectedly read teacher B OPP events';
  END IF;
END;
$$;

-- Own OPP creation must cross the REQUESTER RPC and derive requester/status.
SELECT * FROM public.kf_create_production_order(
  '88888888-8888-4888-8888-888888888881',
  jsonb_build_object(
    'order', jsonb_build_object(
      'id', '55555555-5555-4555-8555-555555555553',
      'version', '1.0.0',
      'agentProfileId', '66666666-6666-4666-8666-666666666661',
      'curriculumPackageId', '33333333-3333-4333-8333-333333333331',
      'productType', 'didactic_text',
      'theme', 'Tema sintético criado por A'
    ),
    'eventId', '77777777-7777-4777-8777-777777777773',
    'eventVersion', '1.0.0',
    'occurredAt', '2026-08-11T21:00:00.000Z'
  )
);

DO $$
BEGIN
  BEGIN
    INSERT INTO public.kf_production_orders (
      id, version, requester_id, agent_profile_id, curriculum_package_id, product_type,
      theme, status
    ) VALUES (
      '55555555-5555-4555-8555-555555555559', '1.0.0',
      'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1',
      '66666666-6666-4666-8666-666666666661',
      '33333333-3333-4333-8333-333333333331',
      'didactic_text', 'DML direto proibido', 'requested'
    );
    RAISE EXCEPTION 'teacher A unexpectedly inserted OPP directly';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    INSERT INTO public.kf_production_orders (
      id, version, requester_id, agent_profile_id, curriculum_package_id, product_type,
      theme, status
    ) VALUES (
      '55555555-5555-4555-8555-555555555554', '1.0.0',
      'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb2',
      '66666666-6666-4666-8666-666666666661',
      '33333333-3333-4333-8333-333333333331',
      'lesson_plan', 'Requester adulterado', 'requested'
    );
    RAISE EXCEPTION 'teacher A unexpectedly spoofed requester_id';
  EXCEPTION
    WHEN insufficient_privilege OR check_violation THEN
      NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    UPDATE public.kf_production_orders
    SET status = 'ready'
    WHERE id = '55555555-5555-4555-8555-555555555551';
    RAISE EXCEPTION 'teacher A unexpectedly updated OPP directly';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    INSERT INTO public.kf_production_order_events (
      version, opp_id, event_type, to_status, occurred_at
    ) VALUES (
      '1.0.0', '55555555-5555-4555-8555-555555555551',
      'approved', 'ready', now()
    );
    RAISE EXCEPTION 'teacher A unexpectedly inserted OPP event directly';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    INSERT INTO public.kf_source_permission_events (
      version, source_id, action, use_type, reason, occurred_at
    ) VALUES (
      '1.0.0', '11111111-1111-4111-8111-111111111111',
      'grant', 'retrieval', 'teacher should not write this', now()
    );
    RAISE EXCEPTION 'teacher A unexpectedly inserted source permission event';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END;
$$;

RESET ROLE;

-- ---------------------------------------------------------------------------
-- school_admin role in profile must NOT become platform admin
-- ---------------------------------------------------------------------------
SET LOCAL ROLE authenticated;
SELECT pg_temp.kf_set_test_identity('authenticated', 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb2');

DO $$
DECLARE
  n integer;
BEGIN
  IF public.kf_is_platform_admin() THEN
    RAISE EXCEPTION 'school_admin unexpectedly became platform admin';
  END IF;

  SELECT count(*) INTO n FROM public.kf_sources;
  IF n <> 0 THEN
    RAISE EXCEPTION 'school_admin unexpectedly read global corpus';
  END IF;
END;
$$;

RESET ROLE;

-- ---------------------------------------------------------------------------
-- platform admin: administrative read only
-- ---------------------------------------------------------------------------
SET LOCAL ROLE authenticated;
SELECT pg_temp.kf_set_test_identity('authenticated', 'cccccccc-cccc-4ccc-8ccc-ccccccccccc3');

DO $$
DECLARE
  n integer;
BEGIN
  IF NOT public.kf_is_platform_admin() THEN
    RAISE EXCEPTION 'synthetic platform admin was not recognized';
  END IF;

  SELECT count(*) INTO n FROM public.kf_sources;
  IF n < 1 THEN
    RAISE EXCEPTION 'platform admin cannot read corpus';
  END IF;

  SELECT count(*) INTO n FROM public.kf_audit_events;
  IF n < 1 THEN
    RAISE EXCEPTION 'platform admin cannot read audit';
  END IF;
END;
$$;

-- Admin also has no direct corpus write grant in Lote 3A.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.kf_sources (
      version, title, source_type, status, license_category, allowed_uses
    ) VALUES (
      '1.0.0', 'Admin direct write forbidden', 'wrtech_owned', 'draft', 'owned', ARRAY[]::text[]
    );
    RAISE EXCEPTION 'admin unexpectedly wrote corpus directly';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END;
$$;

RESET ROLE;

-- ---------------------------------------------------------------------------
-- Privileged executor: append-only must still block OPP-event mutation
-- ---------------------------------------------------------------------------
DO $$
BEGIN
  BEGIN
    UPDATE public.kf_production_order_events
    SET reason = 'mutated by privileged executor'
    WHERE id = '77777777-7777-4777-8777-777777777771';
    RAISE EXCEPTION 'Expected privileged OPP-event UPDATE to fail';
  EXCEPTION WHEN sqlstate '55000' THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    DELETE FROM public.kf_production_order_events
    WHERE id = '77777777-7777-4777-8777-777777777771';
    RAISE EXCEPTION 'Expected privileged OPP-event DELETE to fail';
  EXCEPTION WHEN sqlstate '55000' THEN
    NULL;
  END;
END;
$$;

ROLLBACK;
