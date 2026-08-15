-- =============================================================================
-- ProfePlan — Lote 1.3C.3 governed positive producer validation
-- Disposable Supabase only.
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

-- -----------------------------------------------------------------------------
-- 1. Surface permissions
-- -----------------------------------------------------------------------------
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
$;

-- Defense in depth: even the function owner cannot use the RPC without an
-- authenticated JWT identity. No profile or grant may be materialized.
DO $
DECLARE
  v_profiles_before integer;
  v_profiles_after integer;
  v_grants_before integer;
  v_grants_after integer;
BEGIN
  SELECT COUNT(*) INTO v_profiles_before FROM public.profiles;
  SELECT COUNT(*) INTO v_grants_before FROM public.credit_grants;

  PERFORM set_config('request.jwt.claim.sub', '', true);
  PERFORM set_config('request.jwt.claims', '{}'::jsonb::text, true);

  BEGIN
    PERFORM public.update_my_profile(
      '{"email":"anonymous-profile-recovery@example.invalid","full_name":"Anonymous Recovery"}'::jsonb
    );
    RAISE EXCEPTION 'identity-null profile recovery was accepted';
  EXCEPTION
    WHEN insufficient_privilege THEN
      NULL;
  END;

  SELECT COUNT(*) INTO v_profiles_after FROM public.profiles;
  SELECT COUNT(*) INTO v_grants_after FROM public.credit_grants;

  IF v_profiles_after <> v_profiles_before OR v_grants_after <> v_grants_before THEN
    RAISE EXCEPTION 'identity-null recovery changed profiles or grants';
  END IF;
END;
$;

-- -----------------------------------------------------------------------------
-- 2. New auth user -> FREE profile with legacy integer 0 + governed 10/7d lot.
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
  v_grant_amount integer;
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
    INTO v_grant_amount, v_origin, v_granted_at, v_expires_at
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000420';

  IF v_credits <> 0 OR v_tier <> 'FREE' OR v_unlimited IS true THEN
    RAISE EXCEPTION 'new FREE legacy fields are not cutover-safe: credits %, tier %, unlimited %',
      v_credits, v_tier, v_unlimited;
  END IF;
  IF v_grant_amount <> 10 OR v_origin <> 'FREE_TRIAL' THEN
    RAISE EXCEPTION 'new FREE governed grant mismatch: amount %, origin %',
      v_grant_amount, v_origin;
  END IF;
  IF v_granted_at IS DISTINCT FROM v_created_at
     OR v_expires_at IS DISTINCT FROM v_created_at + interval '7 days' THEN
    RAISE EXCEPTION 'FREE_TRIAL window mismatch';
  END IF;

  PERFORM public.credit_grant_profile_free_trial(
    '00000000-0000-4000-8000-000000000420'
  );
  SELECT COUNT(*) INTO v_count
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000420';
  IF v_count <> 1 THEN
    RAISE EXCEPTION 'FREE_TRIAL helper replay duplicated grant: %', v_count;
  END IF;
END;
$$;

-- Emergency profile creation uses the same AFTER INSERT producer.
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000409'
);
SELECT public.update_my_profile('{"full_name":"Emergency C3"}'::jsonb);
COMMIT;

DO $$
DECLARE
  v_credits integer;
  v_count integer;
  v_total integer;
BEGIN
  SELECT credits INTO v_credits
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000409';
  SELECT COUNT(*), COALESCE(SUM(granted_amount), 0)::integer
    INTO v_count, v_total
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000409'
    AND origin = 'FREE_TRIAL';

  IF v_credits <> 0 OR v_count <> 1 OR v_total <> 10 THEN
    RAISE EXCEPTION 'emergency FREE producer mismatch: credits %, grants %, total %',
      v_credits, v_count, v_total;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 3. Phone bonus — atomic grant, replay-safe by phone state, rollback-safe.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000411'
);
SELECT public.credit_register_my_phone_bonus('+550000000411');
ROLLBACK;

DO $$
DECLARE
  v_phone text;
  v_count integer;
BEGIN
  SELECT phone INTO v_phone
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000411';
  SELECT COUNT(*) INTO v_count
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000411';
  IF v_phone IS NOT NULL OR v_count <> 0 THEN
    RAISE EXCEPTION 'phone rollback leaked state: phone %, grants %', v_phone, v_count;
  END IF;
END;
$$;

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
  v_phone text;
  v_legacy integer;
  v_count integer;
  v_total integer;
BEGIN
  SELECT phone, credits INTO v_phone, v_legacy
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000402';
  SELECT COUNT(*), COALESCE(SUM(granted_amount), 0)::integer
    INTO v_count, v_total
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000402'
    AND origin = 'PROMOTIONAL_BONUS';

  IF v_phone <> '+550000000402' OR v_legacy <> 0 OR v_count <> 1 OR v_total <> 10 THEN
    RAISE EXCEPTION 'phone governed producer mismatch: phone %, legacy %, grants %, total %',
      v_phone, v_legacy, v_count, v_total;
  END IF;
END;
$$;

-- A phone registered before convergence is not rewarded retroactively.
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000403'
);
SELECT public.credit_register_my_phone_bonus('+550000000403');
COMMIT;

DO $$
DECLARE
  v_count integer;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000403';
  IF v_count <> 0 THEN
    RAISE EXCEPTION 'legacy registered phone received retroactive bonus';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 4. Referral claim — authenticated email, atomic completion + referrer grant.
-- -----------------------------------------------------------------------------
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
    RAISE EXCEPTION 'referral governed producer mismatch: status %, legacy %, grants %, total %',
      v_status, v_legacy, v_count, v_total;
  END IF;
END;
$$;

-- Multiple pending referrals for one authenticated email fail closed.
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000412'
);
DO $$
DECLARE
  v_caught boolean := false;
BEGIN
  BEGIN
    PERFORM public.credit_claim_my_referral_bonus();
  EXCEPTION
    WHEN SQLSTATE '23514' THEN
      v_caught := true;
  END;
  IF NOT v_caught THEN
    RAISE EXCEPTION 'ambiguous referral set did not fail closed';
  END IF;
END;
$$;
ROLLBACK;

DO $$
DECLARE
  v_pending integer;
BEGIN
  SELECT COUNT(*) INTO v_pending
  FROM public.referrals
  WHERE referee_email = 'ambiguous-c3@example.invalid'
    AND status = 'pending';
  IF v_pending <> 2 THEN
    RAISE EXCEPTION 'ambiguous referral failure mutated source rows: %', v_pending;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 5. Stripe Silver — PURCHASED lot, no profiles.credits mutation, replay-safe.
-- -----------------------------------------------------------------------------
SELECT public.process_stripe_checkout_event(
  'evt-c3-silver-406',
  'checkout.session.completed',
  '00000000-0000-4000-8000-000000000406',
  'SILVER',
  'prod-c3-silver',
  NULL,
  'cus-c3-406',
  'silver-c3@example.invalid',
  '2026-08-15 01:00:00+00'
);
SELECT public.process_stripe_checkout_event(
  'evt-c3-silver-406',
  'checkout.session.completed',
  '00000000-0000-4000-8000-000000000406',
  'SILVER',
  'prod-c3-silver',
  NULL,
  'cus-c3-406',
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
    RAISE EXCEPTION 'Stripe Silver governed producer mismatch: tier %, legacy %, grants %, total %',
      v_tier, v_legacy, v_count, v_total;
  END IF;
END;
$$;

-- Force a failure after the governed grant call but before successful profile
-- fulfillment. The inner Stripe subtransaction must roll the grant back.
CREATE OR REPLACE FUNCTION pg_temp.fail_c3_silver_profile_update()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.id = '00000000-0000-4000-8000-000000000413'
     AND NEW.tier = 'SILVER' THEN
    RAISE EXCEPTION 'forced c3 silver profile failure';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER fail_c3_silver_profile_update
BEFORE UPDATE OF tier ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION pg_temp.fail_c3_silver_profile_update();

SELECT public.process_stripe_checkout_event(
  'evt-c3-silver-rollback-413',
  'checkout.session.completed',
  '00000000-0000-4000-8000-000000000413',
  'SILVER',
  'prod-c3-silver',
  NULL,
  'cus-c3-413',
  'stripe-rollback-c3@example.invalid',
  '2026-08-15 01:01:00+00'
);

DROP TRIGGER fail_c3_silver_profile_update ON public.profiles;

DO $$
DECLARE
  v_status text;
  v_tier text;
  v_grants integer;
BEGIN
  SELECT status INTO v_status
  FROM public.stripe_webhook_events
  WHERE stripe_event_id = 'evt-c3-silver-rollback-413';
  SELECT tier INTO v_tier
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000413';
  SELECT COUNT(*) INTO v_grants
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000413';

  IF v_status <> 'failed' OR v_tier <> 'FREE' OR v_grants <> 0 THEN
    RAISE EXCEPTION 'Stripe rollback mismatch: status %, tier %, grants %',
      v_status, v_tier, v_grants;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 6. Gold lifecycle downgrade uses governed finite balance, not legacy integer.
-- -----------------------------------------------------------------------------
-- Give the already-Gold profile a purchased lot. Tier must remain GOLD.
SELECT public.process_stripe_checkout_event(
  'evt-c3-silver-while-gold-407',
  'checkout.session.completed',
  '00000000-0000-4000-8000-000000000407',
  'SILVER',
  'prod-c3-silver',
  NULL,
  'cus-c3-407',
  'gold-with-balance-c3@example.invalid',
  '2026-08-15 01:02:00+00'
);

SELECT public.process_stripe_checkout_event(
  'evt-c3-gold-407',
  'checkout.session.completed',
  '00000000-0000-4000-8000-000000000407',
  'GOLD',
  'prod-c3-gold',
  'sub-c3-gold-407',
  'cus-c3-407',
  'gold-with-balance-c3@example.invalid',
  '2026-08-15 01:03:00+00'
);

SELECT public.process_stripe_subscription_event(
  'evt-c3-gold-delete-407',
  'customer.subscription.deleted',
  'sub-c3-gold-407',
  'cus-c3-407',
  'canceled',
  false,
  '2026-08-15 01:04:00+00'
);

DO $$
DECLARE
  v_tier text;
  v_unlimited boolean;
  v_legacy integer;
  v_purchased integer;
BEGIN
  SELECT tier, is_unlimited, credits INTO v_tier, v_unlimited, v_legacy
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000407';
  SELECT COALESCE(SUM(granted_amount), 0)::integer INTO v_purchased
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000407'
    AND origin = 'PURCHASED';

  IF v_tier <> 'SILVER' OR v_unlimited IS true OR v_legacy <> 0 OR v_purchased <> 40 THEN
    RAISE EXCEPTION 'Gold downgrade with governed balance mismatch: tier %, unlimited %, legacy %, purchased %',
      v_tier, v_unlimited, v_legacy, v_purchased;
  END IF;
END;
$$;

-- Gold with no finite governed balance downgrades to FREE.
SELECT public.process_stripe_checkout_event(
  'evt-c3-gold-414',
  'checkout.session.completed',
  '00000000-0000-4000-8000-000000000414',
  'GOLD',
  'prod-c3-gold',
  'sub-c3-gold-414',
  'cus-c3-414',
  'gold-empty-c3@example.invalid',
  '2026-08-15 01:05:00+00'
);
SELECT public.process_stripe_subscription_event(
  'evt-c3-gold-delete-414',
  'customer.subscription.deleted',
  'sub-c3-gold-414',
  'cus-c3-414',
  'canceled',
  false,
  '2026-08-15 01:06:00+00'
);

DO $$
DECLARE
  v_tier text;
  v_unlimited boolean;
  v_grants integer;
BEGIN
  SELECT tier, is_unlimited INTO v_tier, v_unlimited
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000414';
  SELECT COUNT(*) INTO v_grants
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000414';
  IF v_tier <> 'FREE' OR v_unlimited IS true OR v_grants <> 0 THEN
    RAISE EXCEPTION 'Gold empty downgrade mismatch: tier %, unlimited %, grants %',
      v_tier, v_unlimited, v_grants;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 7. Admin adjustment — mandatory operation id, replay safe, no direct balance.
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
  'admin-adjustment-c3-408-001'
);
SELECT public.admin_add_credits(
  '00000000-0000-4000-8000-000000000408',
  25,
  'admin-adjustment-c3-408-001'
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
    RAISE EXCEPTION 'admin governed adjustment mismatch: legacy %, grants %, total %',
      v_legacy, v_count, v_total;
  END IF;
END;
$$;

-- Old two-argument API and direct p_credits replacement fail closed.
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000401'
);
DO $$
DECLARE
  v_result jsonb;
BEGIN
  v_result := public.admin_add_credits(
    '00000000-0000-4000-8000-000000000408', 5
  );
  IF COALESCE((v_result->>'success')::boolean, false) IS true THEN
    RAISE EXCEPTION 'legacy two-argument admin grant remained active';
  END IF;

  v_result := public.admin_update_profile(
    '00000000-0000-4000-8000-000000000408',
    NULL,
    999,
    NULL,
    NULL,
    NULL
  );
  IF COALESCE((v_result->>'success')::boolean, false) IS true THEN
    RAISE EXCEPTION 'admin_update_profile still accepts direct credits';
  END IF;

  v_result := public.admin_update_profile(
    '00000000-0000-4000-8000-000000000408',
    'SILVER',
    NULL,
    false,
    NULL,
    NULL
  );
  IF COALESCE((v_result->>'success')::boolean, false) IS false THEN
    RAISE EXCEPTION 'non-economic admin profile update was incorrectly rejected';
  END IF;
END;
$$;
COMMIT;

DO $$
DECLARE
  v_credits integer;
  v_tier text;
BEGIN
  SELECT credits, tier INTO v_credits, v_tier
  FROM public.profiles
  WHERE id = '00000000-0000-4000-8000-000000000408';
  IF v_credits <> 0 OR v_tier <> 'SILVER' THEN
    RAISE EXCEPTION 'admin direct-balance guard changed wrong fields: credits %, tier %',
      v_credits, v_tier;
  END IF;
END;
$$;

-- Non-admin cannot grant.
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000410'
);
DO $$
DECLARE
  v_result jsonb;
BEGIN
  v_result := public.admin_add_credits(
    '00000000-0000-4000-8000-000000000408',
    10,
    'teacher-forbidden-c3-001'
  );
  IF COALESCE((v_result->>'success')::boolean, false) IS true THEN
    RAISE EXCEPTION 'non-admin governed grant was accepted';
  END IF;
END;
$$;
COMMIT;

DO $$
DECLARE
  v_count integer;
  v_total integer;
BEGIN
  SELECT COUNT(*), COALESCE(SUM(granted_amount), 0)::integer
    INTO v_count, v_total
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-4000-8000-000000000408'
    AND origin = 'ADMIN_ADJUSTMENT';
  IF v_count <> 1 OR v_total <> 25 THEN
    RAISE EXCEPTION 'non-admin path changed admin adjustment state';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 8. Final invariant: positive producers never increased profiles.credits.
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  v_positive_legacy integer;
  v_negative_legacy integer;
BEGIN
  SELECT COUNT(*) FILTER (WHERE credits > 0), COUNT(*) FILTER (WHERE credits < 0)
    INTO v_positive_legacy, v_negative_legacy
  FROM public.profiles;

  IF v_positive_legacy <> 0 OR v_negative_legacy <> 0 THEN
    RAISE EXCEPTION 'positive producer convergence mutated legacy credits: positive %, negative %',
      v_positive_legacy, v_negative_legacy;
  END IF;
END;
$$;

SELECT 'OK:credit_positive_producer_convergence_1_3C_3' AS result;
