-- =============================================================================
-- ProfePlan — Lote 1.3C.5 integrated positive-producer smoke
-- Disposable Supabase only.
--
-- Historical 1.3C.3 remains unchanged and continues to prove the producer
-- boundary in isolation. This file proves that representative producer paths
-- still converge correctly after the 31-profile legacy cohort has already been
-- imported into the same final rehearsal database.
-- =============================================================================
\set ON_ERROR_STOP on

CREATE OR REPLACE FUNCTION pg_temp.credit_set_identity(p_role text, p_user_id uuid)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  PERFORM set_config('request.jwt.claim.sub', p_user_id::text, true);
  PERFORM set_config(
    'request.jwt.claims',
    jsonb_build_object('sub', p_user_id::text, 'role', p_role)::text,
    true
  );
END;
$$;

CREATE OR REPLACE FUNCTION pg_temp.is_legacy_cutover_fixture_user(p_user_id uuid)
RETURNS boolean
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM generate_series(1, 31) AS gs
    WHERE p_user_id = (
      '00000000-0000-0000-0000-' || lpad(gs::text, 12, '0')
    )::uuid
  );
$$;

-- -----------------------------------------------------------------------------
-- 1. Entry invariant: the legacy cohort is already governed without losing its
--    frozen source integer. Producer testing must not reinterpret these rows.
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  v_grants integer;
  v_total integer;
  v_source_total integer;
  v_gold_grants integer;
BEGIN
  SELECT COUNT(*), COALESCE(SUM(granted_amount), 0)::integer
    INTO v_grants, v_total
  FROM public.credit_grants
  WHERE origin = 'LEGACY_BALANCE'
    AND pg_temp.is_legacy_cutover_fixture_user(user_id);

  SELECT COALESCE(SUM(credits), 0)::integer
    INTO v_source_total
  FROM public.profiles
  WHERE pg_temp.is_legacy_cutover_fixture_user(id)
    AND COALESCE(is_unlimited, false) IS false;

  SELECT COUNT(*) INTO v_gold_grants
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-0000-0000-000000000031';

  IF v_grants <> 30 OR v_total <> 292 OR v_source_total <> 292 OR v_gold_grants <> 0 THEN
    RAISE EXCEPTION
      'producer smoke entered with invalid legacy state: grants %, total %, source %, gold grants %',
      v_grants, v_total, v_source_total, v_gold_grants;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 2. Surface permissions remain least-privilege in the integrated database.
-- -----------------------------------------------------------------------------
DO $$
BEGIN
  IF has_function_privilege('anon', 'public.credit_register_my_phone_bonus(text)', 'EXECUTE') THEN
    RAISE EXCEPTION 'anon must not execute governed phone bonus';
  END IF;
  IF NOT has_function_privilege('authenticated', 'public.credit_register_my_phone_bonus(text)', 'EXECUTE') THEN
    RAISE EXCEPTION 'authenticated must execute governed phone bonus';
  END IF;
  IF has_function_privilege('anon', 'public.credit_claim_my_referral_bonus()', 'EXECUTE') THEN
    RAISE EXCEPTION 'anon must not execute governed referral claim';
  END IF;
  IF NOT has_function_privilege('authenticated', 'public.credit_claim_my_referral_bonus()', 'EXECUTE') THEN
    RAISE EXCEPTION 'authenticated must execute governed referral claim';
  END IF;
  IF has_function_privilege(
    'authenticated',
    'public.process_stripe_checkout_event(text,text,uuid,text,text,text,text,text,timestamptz)',
    'EXECUTE'
  ) THEN
    RAISE EXCEPTION 'authenticated must not execute Stripe fulfillment';
  END IF;
  IF NOT has_function_privilege(
    'service_role',
    'public.process_stripe_checkout_event(text,text,uuid,text,text,text,text,text,timestamptz)',
    'EXECUTE'
  ) THEN
    RAISE EXCEPTION 'service_role must execute Stripe fulfillment';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 3. New FREE auth identity receives exactly one governed 10-credit / 7-day lot
--    while its legacy integer remains zero.
-- -----------------------------------------------------------------------------
INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at
) VALUES (
  '00000000-0000-4000-8000-000000000420',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'new-free-c3@example.invalid', '', now(),
  '{}'::jsonb, '{"full_name":"New Free C3"}'::jsonb, now(), now()
);

DO $$
DECLARE
  v_credits integer;
  v_tier text;
  v_unlimited boolean;
  v_created_at timestamptz;
  v_amount integer;
  v_origin text;
  v_granted_at timestamptz;
  v_expires_at timestamptz;
  v_count integer;
BEGIN
  SELECT credits, tier, is_unlimited, created_at
    INTO v_credits, v_tier, v_unlimited, v_created_at
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000420';

  SELECT granted_amount, origin, granted_at, expires_at
    INTO v_amount, v_origin, v_granted_at, v_expires_at
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000420';

  IF v_credits <> 0 OR v_tier <> 'FREE' OR v_unlimited IS true THEN
    RAISE EXCEPTION 'integrated FREE onboarding mutated legacy authority';
  END IF;
  IF v_amount <> 10 OR v_origin <> 'FREE_TRIAL'
     OR v_granted_at IS DISTINCT FROM v_created_at
     OR v_expires_at IS DISTINCT FROM v_created_at + interval '7 days' THEN
    RAISE EXCEPTION 'integrated FREE trial contract mismatch';
  END IF;

  PERFORM public.credit_grant_profile_free_trial(
    '00000000-0000-4000-8000-000000000420'
  );
  SELECT COUNT(*) INTO v_count
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000420';
  IF v_count <> 1 THEN
    RAISE EXCEPTION 'integrated FREE trial replay duplicated grant: %', v_count;
  END IF;
END;
$$;

-- Emergency profile provisioning must converge to the same producer.
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000409'
);
SELECT public.update_my_profile('{"full_name":"Emergency C3 Integrated"}'::jsonb);
COMMIT;

DO $$
DECLARE
  v_legacy integer;
  v_count integer;
  v_total integer;
BEGIN
  SELECT credits INTO v_legacy
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000409';
  SELECT COUNT(*), COALESCE(SUM(granted_amount), 0)::integer
    INTO v_count, v_total
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000409'
    AND origin = 'FREE_TRIAL';

  IF v_legacy <> 0 OR v_count <> 1 OR v_total <> 10 THEN
    RAISE EXCEPTION 'integrated emergency FREE producer mismatch';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 4. Phone bonus and referral bonus are replay-safe and never write credits.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000402'
);
SELECT public.credit_register_my_phone_bonus('+550000000402');
SELECT public.credit_register_my_phone_bonus('+550000000402');
COMMIT;

DO $$
DECLARE
  v_legacy integer;
  v_count integer;
  v_total integer;
BEGIN
  SELECT credits INTO v_legacy
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000402';
  SELECT COUNT(*), COALESCE(SUM(granted_amount), 0)::integer
    INTO v_count, v_total
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000402'
    AND origin = 'PROMOTIONAL_BONUS';

  IF v_legacy <> 0 OR v_count <> 1 OR v_total <> 10 THEN
    RAISE EXCEPTION 'integrated phone producer mismatch';
  END IF;
END;
$$;

BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000405'
);
SELECT public.credit_claim_my_referral_bonus();
SELECT public.credit_claim_my_referral_bonus();
COMMIT;

DO $$
DECLARE
  v_status text;
  v_legacy integer;
  v_count integer;
  v_total integer;
BEGIN
  SELECT status INTO v_status
  FROM public.referrals
  WHERE id = '00000000-0000-4000-8000-000000000451';
  SELECT credits INTO v_legacy
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000404';
  SELECT COUNT(*), COALESCE(SUM(granted_amount), 0)::integer
    INTO v_count, v_total
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000404'
    AND origin = 'PROMOTIONAL_BONUS';

  IF v_status <> 'completed' OR v_legacy <> 0 OR v_count <> 1 OR v_total <> 10 THEN
    RAISE EXCEPTION 'integrated referral producer mismatch';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 5. Stripe Silver creates one PURCHASED lot and exact replay is idempotent.
-- -----------------------------------------------------------------------------
SELECT public.process_stripe_checkout_event(
  'evt-c35-silver-406',
  'checkout.session.completed',
  '00000000-0000-4000-8000-000000000406',
  'SILVER',
  'prod-c35-silver',
  NULL,
  'cus-c35-406',
  'silver-c3@example.invalid',
  '2026-08-15 01:00:00+00'
);
SELECT public.process_stripe_checkout_event(
  'evt-c35-silver-406',
  'checkout.session.completed',
  '00000000-0000-4000-8000-000000000406',
  'SILVER',
  'prod-c35-silver',
  NULL,
  'cus-c35-406',
  'silver-c3@example.invalid',
  '2026-08-15 01:00:00+00'
);

DO $$
DECLARE
  v_tier text;
  v_legacy integer;
  v_count integer;
  v_total integer;
BEGIN
  SELECT tier, credits INTO v_tier, v_legacy
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000406';
  SELECT COUNT(*), COALESCE(SUM(granted_amount), 0)::integer
    INTO v_count, v_total
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000406'
    AND origin = 'PURCHASED';

  IF v_tier <> 'SILVER' OR v_legacy <> 0 OR v_count <> 1 OR v_total <> 40 THEN
    RAISE EXCEPTION 'integrated Stripe Silver producer mismatch';
  END IF;
END;
$$;

-- Gold itself remains non-metered and creates no artificial credit lot.
SELECT public.process_stripe_checkout_event(
  'evt-c35-gold-414',
  'checkout.session.completed',
  '00000000-0000-4000-8000-000000000414',
  'GOLD',
  'prod-c35-gold',
  'sub-c35-gold-414',
  'cus-c35-414',
  'gold-empty-c3@example.invalid',
  '2026-08-15 01:05:00+00'
);

DO $$
DECLARE
  v_tier text;
  v_unlimited boolean;
  v_legacy integer;
  v_grants integer;
BEGIN
  SELECT tier, is_unlimited, credits INTO v_tier, v_unlimited, v_legacy
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000414';
  SELECT COUNT(*) INTO v_grants
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000414';

  IF v_tier <> 'GOLD' OR v_unlimited IS NOT true OR v_legacy <> 0 OR v_grants <> 0 THEN
    RAISE EXCEPTION 'integrated Gold producer mismatch';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 6. Admin adjustment converges to ADMIN_ADJUSTMENT and exact replay does not
--    duplicate the positive economic event.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000401'
);
SELECT public.admin_add_credits(
  '00000000-0000-4000-8000-000000000408',
  25,
  'admin-adjustment-c35-408-001'
);
SELECT public.admin_add_credits(
  '00000000-0000-4000-8000-000000000408',
  25,
  'admin-adjustment-c35-408-001'
);
COMMIT;

DO $$
DECLARE
  v_legacy integer;
  v_count integer;
  v_total integer;
BEGIN
  SELECT credits INTO v_legacy
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000408';
  SELECT COUNT(*), COALESCE(SUM(granted_amount), 0)::integer
    INTO v_count, v_total
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000408'
    AND origin = 'ADMIN_ADJUSTMENT';

  IF v_legacy <> 0 OR v_count <> 1 OR v_total <> 25 THEN
    RAISE EXCEPTION 'integrated admin producer mismatch';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 7. Final composition invariants.
--    Producer cohort remains zero in profiles.credits while the imported legacy
--    cohort remains frozen and governed exactly as it entered this test.
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  v_positive_c3 integer;
  v_negative_c3 integer;
  v_legacy_source_total integer;
  v_legacy_grants integer;
  v_legacy_total integer;
  v_non_legacy_for_legacy integer;
BEGIN
  SELECT
    COUNT(*) FILTER (WHERE credits > 0),
    COUNT(*) FILTER (WHERE credits < 0)
  INTO v_positive_c3, v_negative_c3
  FROM public.profiles
  WHERE email LIKE '%-c3@example.invalid';

  SELECT COALESCE(SUM(credits), 0)::integer
    INTO v_legacy_source_total
  FROM public.profiles
  WHERE pg_temp.is_legacy_cutover_fixture_user(id)
    AND COALESCE(is_unlimited, false) IS false;

  SELECT COUNT(*), COALESCE(SUM(granted_amount), 0)::integer
    INTO v_legacy_grants, v_legacy_total
  FROM public.credit_grants
  WHERE pg_temp.is_legacy_cutover_fixture_user(user_id)
    AND origin = 'LEGACY_BALANCE';

  SELECT COUNT(*) INTO v_non_legacy_for_legacy
  FROM public.credit_grants
  WHERE pg_temp.is_legacy_cutover_fixture_user(user_id)
    AND origin <> 'LEGACY_BALANCE';

  IF v_positive_c3 <> 0 OR v_negative_c3 <> 0 THEN
    RAISE EXCEPTION
      'integrated producer cohort mutated profiles.credits: positive %, negative %',
      v_positive_c3, v_negative_c3;
  END IF;

  IF v_legacy_source_total <> 292
     OR v_legacy_grants <> 30
     OR v_legacy_total <> 292
     OR v_non_legacy_for_legacy <> 0 THEN
    RAISE EXCEPTION
      'integrated producers disturbed legacy cohort: source %, grants %, total %, nonlegacy %',
      v_legacy_source_total, v_legacy_grants, v_legacy_total, v_non_legacy_for_legacy;
  END IF;
END;
$$;

SELECT 'OK:credit_positive_producer_integrated_smoke_1_3C_5' AS result;
