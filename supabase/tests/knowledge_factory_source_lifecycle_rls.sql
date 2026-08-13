-- =============================================================================
-- Knowledge Factory C.1.2 - RLS and grants matrix
-- NON-PRODUCTION ONLY. All fixtures are synthetic and rolled back.
-- =============================================================================

BEGIN;

INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at
) VALUES
  (
    '74000000-0000-4000-8000-000000000001',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'c12-teacher@example.invalid', '', now(),
    '{}'::jsonb, '{}'::jsonb, now(), now()
  ),
  (
    '74000000-0000-4000-8000-000000000002',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'c12-school-admin@example.invalid', '', now(),
    '{}'::jsonb, '{}'::jsonb, now(), now()
  ),
  (
    '74000000-0000-4000-8000-000000000003',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'c12-platform-admin@example.invalid', '', now(),
    '{}'::jsonb, '{}'::jsonb, now(), now()
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, email, full_name, role, is_admin)
VALUES
  (
    '74000000-0000-4000-8000-000000000001',
    'c12-teacher@example.invalid', 'C12 Synthetic Teacher', 'teacher', false
  ),
  (
    '74000000-0000-4000-8000-000000000002',
    'c12-school-admin@example.invalid', 'C12 Synthetic School Admin', 'school_admin', false
  ),
  (
    '74000000-0000-4000-8000-000000000003',
    'c12-platform-admin@example.invalid', 'C12 Synthetic Platform Admin', 'admin', true
  )
ON CONFLICT (id) DO UPDATE
SET email = EXCLUDED.email,
    full_name = EXCLUDED.full_name,
    role = EXCLUDED.role,
    is_admin = EXCLUDED.is_admin;

INSERT INTO public.kf_source_identities (id, kind)
VALUES ('74100000-0000-4000-8000-000000000001', 'source_version');

INSERT INTO public.kf_source_registration_projections (
  subject_identity_id, projected_state, aggregate_version, sequence
) VALUES (
  '74100000-0000-4000-8000-000000000001', 'VALIDATED', '1.0.0', 1
);

CREATE OR REPLACE FUNCTION pg_temp.set_identity(p_user_id uuid)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  PERFORM set_config('request.jwt.claim.sub', p_user_id::text, true);
  PERFORM set_config(
    'request.jwt.claims',
    json_build_object('sub', p_user_id::text, 'role', 'authenticated')::text,
    true
  );
END;
$$;

-- anon has no table privilege.
SET LOCAL ROLE anon;
DO $$
BEGIN
  BEGIN
    PERFORM 1 FROM public.kf_source_identities LIMIT 1;
    RAISE EXCEPTION 'anon unexpectedly read lifecycle identities';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END;
$$;
RESET ROLE;

-- A normal teacher receives no lifecycle rows and no write capability.
SET LOCAL ROLE authenticated;
SELECT pg_temp.set_identity('74000000-0000-4000-8000-000000000001');
DO $$
DECLARE
  n integer;
BEGIN
  SELECT count(*) INTO n FROM public.kf_source_identities;
  IF n <> 0 THEN
    RAISE EXCEPTION 'teacher unexpectedly read lifecycle identities';
  END IF;

  SELECT count(*) INTO n FROM public.kf_source_registration_projections;
  IF n <> 0 THEN
    RAISE EXCEPTION 'teacher unexpectedly read lifecycle projections';
  END IF;

  BEGIN
    INSERT INTO public.kf_source_identities (kind) VALUES ('work');
    RAISE EXCEPTION 'teacher unexpectedly wrote lifecycle identity';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END;
$$;
RESET ROLE;

-- A school-scoped admin is not a Knowledge Factory platform admin.
SET LOCAL ROLE authenticated;
SELECT pg_temp.set_identity('74000000-0000-4000-8000-000000000002');
DO $$
DECLARE
  n integer;
BEGIN
  IF public.kf_is_platform_admin() THEN
    RAISE EXCEPTION 'school_admin unexpectedly became platform admin';
  END IF;
  SELECT count(*) INTO n FROM public.kf_source_identities;
  IF n <> 0 THEN
    RAISE EXCEPTION 'school_admin unexpectedly read lifecycle identities';
  END IF;
END;
$$;
RESET ROLE;

-- Technical platform admin has minimized administrative read, never write.
SET LOCAL ROLE authenticated;
SELECT pg_temp.set_identity('74000000-0000-4000-8000-000000000003');
DO $$
DECLARE
  n integer;
BEGIN
  IF NOT public.kf_is_platform_admin() THEN
    RAISE EXCEPTION 'platform admin was not recognized';
  END IF;
  SELECT count(*) INTO n FROM public.kf_source_identities;
  IF n <> 1 THEN
    RAISE EXCEPTION 'platform admin cannot read lifecycle identities';
  END IF;

  BEGIN
    UPDATE public.kf_source_registration_projections
    SET projected_state = 'BLOCKED'
    WHERE subject_identity_id = '74100000-0000-4000-8000-000000000001';
    RAISE EXCEPTION 'technical admin unexpectedly wrote lifecycle projection';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END;
$$;
RESET ROLE;

-- service_role bypasses RLS in Supabase, therefore direct table grants are
-- explicitly absent. Technical identity is not business authorization.
SET LOCAL ROLE service_role;
DO $$
BEGIN
  BEGIN
    PERFORM 1 FROM public.kf_source_identities LIMIT 1;
    RAISE EXCEPTION 'service_role unexpectedly read lifecycle table directly';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;

  BEGIN
    INSERT INTO public.kf_source_identities (kind) VALUES ('work');
    RAISE EXCEPTION 'service_role unexpectedly wrote lifecycle table directly';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END;
$$;
RESET ROLE;

-- Every new table has RLS enabled and no mutation policy.
DO $$
DECLARE
  v_rls_count integer;
  v_write_policy_count integer;
BEGIN
  SELECT count(*) INTO v_rls_count
  FROM pg_class c
  JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE n.nspname = 'public'
    AND c.relname = ANY(ARRAY[
      'kf_source_identities',
      'kf_source_authorization_bases',
      'kf_source_registration_projections',
      'kf_source_authorizations',
      'kf_source_command_receipts',
      'kf_source_governance_events',
      'kf_source_command_receipt_events'
    ])
    AND c.relrowsecurity;

  IF v_rls_count <> 7 THEN
    RAISE EXCEPTION 'not all C.1.2 tables have RLS enabled';
  END IF;

  SELECT count(*) INTO v_write_policy_count
  FROM pg_policies
  WHERE schemaname = 'public'
    AND tablename = ANY(ARRAY[
      'kf_source_identities',
      'kf_source_authorization_bases',
      'kf_source_registration_projections',
      'kf_source_authorizations',
      'kf_source_command_receipts',
      'kf_source_governance_events',
      'kf_source_command_receipt_events'
    ])
    AND cmd IN ('INSERT', 'UPDATE', 'DELETE', 'ALL');

  IF v_write_policy_count <> 0 THEN
    RAISE EXCEPTION 'C.1.2 unexpectedly exposes a direct write policy';
  END IF;
END;
$$;

ROLLBACK;
