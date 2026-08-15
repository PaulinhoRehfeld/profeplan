-- =============================================================================
-- ProfePlan — Lote 1.3C.6 positive-producer rollback rehearsal
-- DISPOSABLE SUPABASE ONLY.
-- Run after scripts/sql/credit_positive_producer_rollback.sql on a schema where
-- 1.3C.3 had previously been applied.
-- =============================================================================
\set ON_ERROR_STOP on

-- Hosted dependency required by the legacy two-argument admin RPC. Production
-- already has this helper; the disposable rehearsal creates the same definition
-- only after the local stack is healthy so bootstrap failures stay diagnosable.
CREATE OR REPLACE FUNCTION public.is_admin_safe()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE id = auth.uid()
      AND (role = 'admin' OR is_admin = true)
  );
$$;
ALTER FUNCTION public.is_admin_safe() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.is_admin_safe() TO authenticated;

-- Governed producer-only entry points and trigger must be gone.
DO $$
BEGIN
  IF has_function_privilege('anon', 'public.update_my_profile(jsonb)', 'EXECUTE') THEN
    RAISE EXCEPTION 'anon must not execute authenticated profile recovery';
  END IF;
  IF has_function_privilege('service_role', 'public.update_my_profile(jsonb)', 'EXECUTE') THEN
    RAISE EXCEPTION 'service_role must not execute user profile recovery';
  END IF;
  IF NOT has_function_privilege('authenticated', 'public.update_my_profile(jsonb)', 'EXECUTE') THEN
    RAISE EXCEPTION 'authenticated must execute profile recovery';
  END IF;
  IF EXISTS (
    SELECT 1 FROM pg_trigger
    WHERE tgname = 'on_profile_created_credit_free_trial'
      AND NOT tgisinternal
  ) THEN
    RAISE EXCEPTION 'producer rollback left FREE_TRIAL profile trigger active';
  END IF;

  IF to_regprocedure('public.credit_register_my_phone_bonus(text)') IS NOT NULL
     OR to_regprocedure('public.credit_claim_my_referral_bonus()') IS NOT NULL
     OR to_regprocedure('public.admin_add_credits(uuid,integer,text)') IS NOT NULL THEN
    RAISE EXCEPTION 'producer rollback left governed producer entry point active';
  END IF;

  IF to_regprocedure('public.admin_add_credits(uuid,integer)') IS NULL THEN
    RAISE EXCEPTION 'producer rollback did not restore legacy admin_add_credits';
  END IF;
END;
$$;

-- Rollback restores legacy credits but never restores the anonymous RPC surface.
DO $$
DECLARE
  v_profiles_before integer;
  v_profiles_after integer;
BEGIN
  SELECT COUNT(*) INTO v_profiles_before FROM public.profiles;

  PERFORM set_config('request.jwt.claim.sub', '', true);
  PERFORM set_config('request.jwt.claims', '{}'::jsonb::text, true);

  BEGIN
    PERFORM public.update_my_profile(
      '{"email":"anonymous-rollback-recovery@example.invalid","full_name":"Anonymous Rollback"}'::jsonb
    );
    RAISE EXCEPTION 'rollback accepted identity-null profile recovery';
  EXCEPTION
    WHEN insufficient_privilege THEN
      NULL;
  END;

  SELECT COUNT(*) INTO v_profiles_after FROM public.profiles;
  IF v_profiles_after <> v_profiles_before THEN
    RAISE EXCEPTION 'rollback identity-null recovery changed profiles';
  END IF;
END;
$$;

-- 1. Normal signup returns to legacy credits=10 and creates no new governed lot.
INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at
) VALUES (
  'a1000000-0000-4000-8000-000000000001',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'rollback-signup@example.invalid', '', now(),
  '{}'::jsonb, '{"full_name":"Rollback Signup"}'::jsonb, now(), now()
);

DO $$
DECLARE
  v_credits integer;
  v_grants integer;
BEGIN
  SELECT credits INTO v_credits
  FROM public.profiles
  WHERE id = 'a1000000-0000-4000-8000-000000000001';

  SELECT COUNT(*) INTO v_grants
  FROM public.credit_grants
  WHERE user_id = 'a1000000-0000-4000-8000-000000000001';

  IF v_credits <> 10 OR v_grants <> 0 THEN
    RAISE EXCEPTION 'legacy signup rollback mismatch: credits %, grants %', v_credits, v_grants;
  END IF;
END;
$$;

-- 2. Emergency profile recovery also returns to credits=10 with no grant.
INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at
) VALUES (
  'a1000000-0000-4000-8000-000000000002',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'rollback-emergency@example.invalid', '', now(),
  '{}'::jsonb, '{}'::jsonb, now(), now()
);

DELETE FROM public.profiles
WHERE id = 'a1000000-0000-4000-8000-000000000002';

BEGIN;
SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', 'a1000000-0000-4000-8000-000000000002', true);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"a1000000-0000-4000-8000-000000000002","role":"authenticated"}',
  true
);
SELECT public.update_my_profile('{"full_name":"Recovered Rollback"}'::jsonb);
COMMIT;

DO $$
DECLARE
  v_credits integer;
  v_grants integer;
BEGIN
  SELECT credits INTO v_credits
  FROM public.profiles
  WHERE id = 'a1000000-0000-4000-8000-000000000002';

  SELECT COUNT(*) INTO v_grants
  FROM public.credit_grants
  WHERE user_id = 'a1000000-0000-4000-8000-000000000002';

  IF v_credits <> 10 OR v_grants <> 0 THEN
    RAISE EXCEPTION 'legacy emergency rollback mismatch: credits %, grants %', v_credits, v_grants;
  END IF;
END;
$$;

-- 3. Stripe Silver returns to legacy +40 and does not create PURCHASED grant.
INSERT INTO public.profiles (
  id, email, role, is_admin, tier, is_unlimited, credits
) VALUES (
  'a1000000-0000-4000-8000-000000000003',
  'rollback-silver@example.invalid', 'teacher', false, 'FREE', false, 5
);

SELECT public.process_stripe_checkout_event(
  'evt-rollback-silver-a1003',
  'checkout.session.completed',
  'a1000000-0000-4000-8000-000000000003',
  'SILVER',
  'prod-rollback-silver',
  NULL,
  'cus-rollback-a1003',
  'rollback-silver@example.invalid',
  '2026-08-15 18:30:00+00'
);

DO $$
DECLARE
  v_credits integer;
  v_tier text;
  v_grants integer;
BEGIN
  SELECT credits, tier INTO v_credits, v_tier
  FROM public.profiles
  WHERE id = 'a1000000-0000-4000-8000-000000000003';

  SELECT COUNT(*) INTO v_grants
  FROM public.credit_grants
  WHERE user_id = 'a1000000-0000-4000-8000-000000000003';

  IF v_credits <> 45 OR v_tier <> 'SILVER' OR v_grants <> 0 THEN
    RAISE EXCEPTION 'legacy Stripe rollback mismatch: credits %, tier %, grants %',
      v_credits, v_tier, v_grants;
  END IF;
END;
$$;

-- 4. Two-argument admin adjustment again changes only the legacy integer.
INSERT INTO public.profiles (
  id, email, role, is_admin, tier, is_unlimited, credits
) VALUES (
  'a1000000-0000-4000-8000-000000000004',
  'rollback-admin-target@example.invalid', 'teacher', false, 'FREE', false, 2
);

BEGIN;
SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000000401', true);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"00000000-0000-4000-8000-000000000401","role":"authenticated"}',
  true
);
SELECT public.admin_add_credits(
  'a1000000-0000-4000-8000-000000000004',
  7
);
SELECT public.admin_update_profile(
  'a1000000-0000-4000-8000-000000000004',
  NULL,
  13,
  NULL,
  NULL,
  NULL
);
COMMIT;

DO $$
DECLARE
  v_credits integer;
  v_grants integer;
BEGIN
  SELECT credits INTO v_credits
  FROM public.profiles
  WHERE id = 'a1000000-0000-4000-8000-000000000004';

  SELECT COUNT(*) INTO v_grants
  FROM public.credit_grants
  WHERE user_id = 'a1000000-0000-4000-8000-000000000004';

  IF v_credits <> 13 OR v_grants <> 0 THEN
    RAISE EXCEPTION 'legacy admin rollback mismatch: credits %, grants %', v_credits, v_grants;
  END IF;
END;
$$;

-- Ledger history from before rollback is intentionally preserved; rollback is
-- authority switching, not destructive accounting deletion.
DO $$
BEGIN
  IF to_regclass('public.credit_operations') IS NULL
     OR to_regclass('public.credit_grants') IS NULL
     OR to_regclass('public.credit_ledger_entries') IS NULL THEN
    RAISE EXCEPTION 'producer rollback destructively removed ledger foundation';
  END IF;
END;
$$;

SELECT 'OK:credit_positive_producer_rollback_1_3C_6' AS result;
