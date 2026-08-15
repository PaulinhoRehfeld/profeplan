-- =============================================================================
-- ProfePlan — Lote 1.3C.6 governed producer reapply verification
-- DISPOSABLE SUPABASE ONLY.
-- Run after the legacy producer rollback has been tested and 1.3C.3 is applied
-- again. Proves the cutover can return to governed producer authority.
-- =============================================================================
\set ON_ERROR_STOP on

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger
    WHERE tgname = 'on_profile_created_credit_free_trial'
      AND NOT tgisinternal
  ) THEN
    RAISE EXCEPTION 'governed producer reapply did not restore FREE_TRIAL trigger';
  END IF;

  IF to_regprocedure('public.credit_register_my_phone_bonus(text)') IS NULL
     OR to_regprocedure('public.credit_claim_my_referral_bonus()') IS NULL
     OR to_regprocedure('public.admin_add_credits(uuid,integer,text)') IS NULL THEN
    RAISE EXCEPTION 'governed producer reapply is missing entry points';
  END IF;
END;
$$;

-- Fresh signup after reapply must be ledger-governed again.
INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at
) VALUES (
  'a2000000-0000-4000-8000-000000000001',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'reapply-signup@example.invalid', '', now(),
  '{}'::jsonb, '{"full_name":"Reapply Signup"}'::jsonb, now(), now()
);

DO $$
DECLARE
  v_credits integer;
  v_free_grants integer;
  v_free_total integer;
BEGIN
  SELECT credits INTO v_credits
  FROM public.profiles
  WHERE id = 'a2000000-0000-4000-8000-000000000001';

  SELECT COUNT(*)::integer, COALESCE(SUM(granted_amount),0)::integer
    INTO v_free_grants, v_free_total
  FROM public.credit_grants
  WHERE user_id = 'a2000000-0000-4000-8000-000000000001'
    AND origin = 'FREE_TRIAL';

  IF v_credits <> 0 OR v_free_grants <> 1 OR v_free_total <> 10 THEN
    RAISE EXCEPTION 'governed signup reapply mismatch: credits %, grants %, total %',
      v_credits, v_free_grants, v_free_total;
  END IF;
END;
$$;

-- Fresh Silver fulfillment must create PURCHASED=40 without changing legacy 5.
INSERT INTO public.profiles (
  id, email, role, is_admin, tier, is_unlimited, credits
) VALUES (
  'a2000000-0000-4000-8000-000000000002',
  'reapply-silver@example.invalid', 'teacher', false, 'FREE', false, 5
);

SELECT public.process_stripe_checkout_event(
  'evt-reapply-silver-a2002',
  'checkout.session.completed',
  'a2000000-0000-4000-8000-000000000002',
  'SILVER',
  'prod-reapply-silver',
  NULL,
  'cus-reapply-a2002',
  'reapply-silver@example.invalid',
  '2026-08-15 18:45:00+00'
);

DO $$
DECLARE
  v_credits integer;
  v_tier text;
  v_purchased integer;
  v_purchased_total integer;
BEGIN
  SELECT credits, tier INTO v_credits, v_tier
  FROM public.profiles
  WHERE id = 'a2000000-0000-4000-8000-000000000002';

  SELECT COUNT(*)::integer, COALESCE(SUM(granted_amount),0)::integer
    INTO v_purchased, v_purchased_total
  FROM public.credit_grants
  WHERE user_id = 'a2000000-0000-4000-8000-000000000002'
    AND origin = 'PURCHASED';

  IF v_credits <> 5 OR v_tier <> 'SILVER' OR v_purchased <> 1 OR v_purchased_total <> 40 THEN
    RAISE EXCEPTION 'governed Stripe reapply mismatch: legacy %, tier %, grants %, total %',
      v_credits, v_tier, v_purchased, v_purchased_total;
  END IF;
END;
$$;

-- Legacy two-argument admin entry point must be fail-closed again.
BEGIN;
SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000000401', true);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"00000000-0000-4000-8000-000000000401","role":"authenticated"}',
  true
);
DO $$
DECLARE
  v_result jsonb;
BEGIN
  v_result := public.admin_add_credits(
    'a2000000-0000-4000-8000-000000000002',
    5
  );
  IF COALESCE((v_result->>'success')::boolean, false) IS true THEN
    RAISE EXCEPTION 'legacy admin_add_credits stayed active after governed reapply';
  END IF;
END;
$$;
ROLLBACK;

SELECT 'OK:credit_positive_producer_reapply_1_3C_6' AS result;
