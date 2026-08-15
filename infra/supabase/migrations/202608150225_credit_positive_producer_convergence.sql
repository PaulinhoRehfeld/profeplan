-- =============================================================================
-- ProfePlan — positive credit producer convergence
-- Lote 1.3C.3
--
-- IMPORTANT:
-- - depends on 1.3B.1 + 1.3B.2 credit accounting foundations;
-- - versioned only in this sublot; NOT authorized for hosted deployment;
-- - intentionally removes profiles.credits as a positive-grant authority once
--   this migration is eventually applied during a coordinated cutover;
-- - consumer convergence remains a later gate (1.3C.4).
-- =============================================================================

BEGIN;

DO $$
BEGIN
  IF to_regclass('public.credit_operations') IS NULL
     OR to_regclass('public.credit_grants') IS NULL
     OR to_regclass('public.credit_ledger_entries') IS NULL
     OR NOT EXISTS (
       SELECT 1
       FROM pg_proc AS p
       JOIN pg_namespace AS n ON n.oid = p.pronamespace
       WHERE n.nspname = 'public'
         AND p.proname = 'credit_grant_command'
     ) THEN
    RAISE EXCEPTION '1.3C.3 requires the governed 1.3B credit foundation';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 1. FREE onboarding: new FREE profiles start with no spendable legacy integer.
--    Their 10-credit, 7-day lot is created by the governed ledger instead.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.credit_grant_profile_free_trial(
  p_user_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
DECLARE
  v_created_at timestamptz;
  v_tier text;
  v_is_unlimited boolean;
  v_grant_key text;
  v_operation_id text;
  v_fingerprint text;
BEGIN
  SELECT p.created_at, p.tier, p.is_unlimited
    INTO v_created_at, v_tier, v_is_unlimited
  FROM public.profiles AS p
  WHERE p.id = p_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'credit profile not found'
      USING ERRCODE = 'P0002';
  END IF;

  IF v_tier IS DISTINCT FROM 'FREE' OR COALESCE(v_is_unlimited, false) IS true THEN
    RETURN jsonb_build_object(
      'result', 'not_eligible',
      'user_id', p_user_id
    );
  END IF;

  v_operation_id := 'free-trial-v1:' || p_user_id::text;
  v_grant_key := 'free-trial:' || p_user_id::text || ':v1';
  v_fingerprint := concat_ws(
    ':',
    'free-trial-v1',
    p_user_id::text,
    '10',
    to_char(v_created_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"')
  );

  RETURN public.credit_grant_command(
    p_user_id,
    v_operation_id,
    'GRANT_FREE_TRIAL',
    v_fingerprint,
    v_grant_key,
    'FREE_TRIAL',
    10,
    v_created_at,
    v_created_at + interval '7 days',
    'profile-created:' || p_user_id::text,
    jsonb_build_object(
      'producer', 'profile_created',
      'producer_version', '1.3C.3'
    )
  );
END;
$$;

REVOKE ALL ON FUNCTION public.credit_grant_profile_free_trial(uuid)
  FROM PUBLIC, anon, authenticated, service_role;

CREATE OR REPLACE FUNCTION public.credit_on_profile_created_free_trial()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
BEGIN
  IF NEW.tier = 'FREE' AND COALESCE(NEW.is_unlimited, false) IS false THEN
    PERFORM public.credit_grant_profile_free_trial(NEW.id);
  END IF;
  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public.credit_on_profile_created_free_trial()
  FROM PUBLIC, anon, authenticated, service_role;

DROP TRIGGER IF EXISTS on_profile_created_credit_free_trial ON public.profiles;
CREATE TRIGGER on_profile_created_credit_free_trial
  AFTER INSERT ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.credit_on_profile_created_free_trial();

-- Canonical auth.users -> profiles path. No positive legacy integer is created.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (
    id,
    full_name,
    email,
    role,
    tier,
    is_unlimited,
    credits,
    created_at,
    updated_at
  )
  VALUES (
    NEW.id,
    COALESCE(
      NEW.raw_user_meta_data->>'full_name',
      NEW.raw_user_meta_data->>'name',
      split_part(NEW.email, '@', 1)
    ),
    NEW.email,
    'teacher',
    'FREE',
    false,
    0,
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO UPDATE SET
    email        = EXCLUDED.email,
    full_name    = COALESCE(profiles.full_name, EXCLUDED.full_name),
    tier         = CASE WHEN profiles.tier IS NULL THEN 'FREE' ELSE profiles.tier END,
    is_unlimited = CASE WHEN profiles.is_unlimited IS NULL THEN false ELSE profiles.is_unlimited END,
    credits      = CASE WHEN profiles.credits IS NULL THEN 0 ELSE profiles.credits END,
    updated_at   = NOW();

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Preserve the established signup policy: profile creation must not abort
    -- auth.users insertion. The emergency update_my_profile path can recover.
    RAISE WARNING 'handle_new_user failed for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Authenticated emergency profile-recovery path. The AFTER INSERT profiles
-- trigger above remains the single producer of the FREE_TRIAL grant, while this
-- RPC rejects anonymous callers before resolving or creating any profile.
CREATE OR REPLACE FUNCTION public.update_my_profile(p_updates jsonb)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog
AS $$
DECLARE
  v_uid uuid := auth.uid();
  v_email text;
  v_target_id uuid;
  v_result public.profiles;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'authenticated user required'
      USING ERRCODE = '42501';
  END IF;

  SELECT email INTO v_email
  FROM auth.users
  WHERE id = v_uid;

  SELECT id INTO v_target_id
  FROM public.profiles
  WHERE id = v_uid;

  IF v_target_id IS NULL AND v_email IS NOT NULL THEN
    SELECT id INTO v_target_id
    FROM public.profiles
    WHERE lower(email) = lower(v_email)
    ORDER BY created_at DESC
    LIMIT 1;
  END IF;

  IF v_target_id IS NULL THEN
    BEGIN
      INSERT INTO public.profiles (
        id, email, role, tier, credits, is_unlimited, created_at, updated_at
      ) VALUES (
        v_uid,
        v_email,
        'teacher',
        'FREE',
        0,
        false,
        NOW(),
        NOW()
      )
      RETURNING id INTO v_target_id;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE EXCEPTION 'Falha ao criar perfil: % (id=%, email=%)', SQLERRM, v_uid, v_email;
    END;
  END IF;

  BEGIN
    UPDATE public.profiles SET
      full_name            = COALESCE(NULLIF(p_updates->>'full_name', ''), full_name),
      email                = COALESCE(NULLIF(p_updates->>'email', ''), email),
      masp                 = COALESCE(NULLIF(p_updates->>'masp', ''), masp),
      city                 = COALESCE(NULLIF(p_updates->>'city', ''), city),
      favorite_methodology = COALESCE(NULLIF(p_updates->>'favorite_methodology', ''), favorite_methodology),
      teaching_style       = COALESCE(NULLIF(p_updates->>'teaching_style', ''), teaching_style),
      assessment_focus     = COALESCE(NULLIF(p_updates->>'assessment_focus', ''), assessment_focus),
      tone_of_voice        = COALESCE(NULLIF(p_updates->>'tone_of_voice', ''), tone_of_voice),
      header_text          = COALESCE(NULLIF(p_updates->>'header_text', ''), header_text),
      footer_text          = COALESCE(NULLIF(p_updates->>'footer_text', ''), footer_text),
      logo_base64          = COALESCE(NULLIF(p_updates->>'logo_base64', ''), logo_base64),
      updated_at           = NOW()
    WHERE id = v_target_id
    RETURNING * INTO v_result;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE EXCEPTION 'Falha ao atualizar perfil (id=%): %', v_target_id, SQLERRM;
  END;

  RETURN v_result;
END;
$$;

ALTER FUNCTION public.update_my_profile(jsonb) OWNER TO postgres;
REVOKE ALL ON FUNCTION public.update_my_profile(jsonb)
  FROM PUBLIC, anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.update_my_profile(jsonb) TO authenticated;

-- -----------------------------------------------------------------------------
-- 2. Phone bonus: atomic phone registration + governed PROMOTIONAL_BONUS.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.credit_register_my_phone_bonus(
  p_phone text
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_existing_phone text;
  v_granted_at timestamptz := now();
  v_grant jsonb;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authenticated user required'
      USING ERRCODE = '42501';
  END IF;

  IF p_phone IS NULL OR btrim(p_phone) = '' OR length(btrim(p_phone)) > 64 THEN
    RAISE EXCEPTION 'invalid phone value'
      USING ERRCODE = '22023';
  END IF;

  SELECT p.phone
    INTO v_existing_phone
  FROM public.profiles AS p
  WHERE p.id = v_user_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'credit profile not found'
      USING ERRCODE = 'P0002';
  END IF;

  IF v_existing_phone IS NOT NULL THEN
    RETURN jsonb_build_object(
      'success', true,
      'result', 'already_registered',
      'credited', false
    );
  END IF;

  UPDATE public.profiles
  SET phone = btrim(p_phone),
      updated_at = now()
  WHERE id = v_user_id;

  v_grant := public.credit_grant_command(
    v_user_id,
    'phone-bonus-v1:' || v_user_id::text,
    'GRANT_PHONE_BONUS',
    'phone-bonus-v1:' || v_user_id::text || ':10',
    'phone:' || v_user_id::text || ':bonus-v1',
    'PROMOTIONAL_BONUS',
    10,
    v_granted_at,
    NULL,
    'phone-registration:' || v_user_id::text,
    jsonb_build_object(
      'producer', 'phone_registration',
      'producer_version', '1.3C.3'
    )
  );

  RETURN jsonb_build_object(
    'success', true,
    'result', 'registered',
    'credited', true,
    'grant', v_grant
  );
END;
$$;

REVOKE ALL ON FUNCTION public.credit_register_my_phone_bonus(text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.credit_register_my_phone_bonus(text) TO authenticated;

-- -----------------------------------------------------------------------------
-- 3. Referral bonus: the authenticated referee claims by auth.users email.
--    Referral completion and referrer grant share one transaction.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.credit_claim_my_referral_bonus()
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, auth
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_email text;
  v_pending_count integer;
  v_referral_id uuid;
  v_referrer_id uuid;
  v_granted_at timestamptz := now();
  v_grant jsonb;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authenticated user required'
      USING ERRCODE = '42501';
  END IF;

  SELECT u.email INTO v_email
  FROM auth.users AS u
  WHERE u.id = v_user_id;

  IF v_email IS NULL OR btrim(v_email) = '' THEN
    RETURN jsonb_build_object('result', 'no_authenticated_email', 'credited', false);
  END IF;

  SELECT COUNT(*)::integer
    INTO v_pending_count
  FROM public.referrals AS r
  WHERE lower(r.referee_email) = lower(v_email)
    AND r.status = 'pending';

  IF v_pending_count = 0 THEN
    RETURN jsonb_build_object('result', 'no_pending_referral', 'credited', false);
  END IF;

  IF v_pending_count > 1 THEN
    RAISE EXCEPTION 'ambiguous pending referrals for authenticated email'
      USING ERRCODE = '23514';
  END IF;

  SELECT r.id, r.referrer_id
    INTO v_referral_id, v_referrer_id
  FROM public.referrals AS r
  WHERE lower(r.referee_email) = lower(v_email)
    AND r.status = 'pending'
  FOR UPDATE;

  UPDATE public.referrals
  SET status = 'completed'
  WHERE id = v_referral_id
    AND status = 'pending';

  IF NOT FOUND THEN
    RAISE EXCEPTION 'referral state changed during claim'
      USING ERRCODE = '40001';
  END IF;

  v_grant := public.credit_grant_command(
    v_referrer_id,
    'referral-bonus-v1:' || v_referral_id::text,
    'GRANT_REFERRAL_BONUS',
    'referral-bonus-v1:' || v_referral_id::text || ':' || v_referrer_id::text || ':10',
    'referral:' || v_referral_id::text || ':bonus-v1',
    'PROMOTIONAL_BONUS',
    10,
    v_granted_at,
    NULL,
    'referral:' || v_referral_id::text,
    jsonb_build_object(
      'producer', 'referral',
      'producer_version', '1.3C.3',
      'referee_user_id', v_user_id
    )
  );

  RETURN jsonb_build_object(
    'result', 'completed',
    'credited', true,
    'referral_id', v_referral_id,
    'grant', v_grant
  );
END;
$$;

REVOKE ALL ON FUNCTION public.credit_claim_my_referral_bonus() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.credit_claim_my_referral_bonus() TO authenticated;

-- -----------------------------------------------------------------------------
-- 4. Stripe Silver: PURCHASED grant replaces profiles.credits += 40.
--    Gold remains unlimited/NO_CHARGE and does not fabricate a purchased lot.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.process_stripe_checkout_event(
  p_event_id text,
  p_event_type text,
  p_user_id uuid,
  p_plan text,
  p_product_id text DEFAULT NULL,
  p_subscription_id text DEFAULT NULL,
  p_customer_id text DEFAULT NULL,
  p_customer_email text DEFAULT NULL,
  p_event_created_at timestamptz DEFAULT now()
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_status text;
  v_profile_exists boolean;
  v_grant jsonb;
BEGIN
  IF p_event_id IS NULL OR p_event_id = '' THEN
    RETURN jsonb_build_object('result', 'failed', 'error', 'missing_event_id');
  END IF;

  INSERT INTO public.stripe_webhook_events (
    stripe_event_id, event_type, status, user_id, plan, product_id,
    subscription_id, customer_id, customer_email, stripe_created_at
  ) VALUES (
    p_event_id, p_event_type, 'processing', p_user_id, p_plan, p_product_id,
    p_subscription_id, p_customer_id, lower(p_customer_email), p_event_created_at
  ) ON CONFLICT (stripe_event_id) DO NOTHING;

  SELECT status INTO v_status
  FROM public.stripe_webhook_events
  WHERE stripe_event_id = p_event_id
  FOR UPDATE;

  IF v_status IN ('processed', 'ignored') THEN
    RETURN jsonb_build_object('result', 'duplicate', 'status', v_status);
  END IF;

  IF v_status = 'pending_identity' AND p_user_id IS NULL THEN
    RETURN jsonb_build_object('result', 'pending_identity');
  END IF;

  UPDATE public.stripe_webhook_events
  SET status = 'processing',
      user_id = COALESCE(p_user_id, user_id),
      plan = COALESCE(p_plan, plan),
      product_id = COALESCE(p_product_id, product_id),
      subscription_id = COALESCE(p_subscription_id, subscription_id),
      customer_id = COALESCE(p_customer_id, customer_id),
      customer_email = COALESCE(lower(p_customer_email), customer_email),
      last_error = NULL,
      updated_at = now()
  WHERE stripe_event_id = p_event_id;

  IF p_plan IS NULL OR p_plan NOT IN ('SILVER', 'GOLD') THEN
    UPDATE public.stripe_webhook_events
    SET status = 'ignored', processed_at = now(), updated_at = now()
    WHERE stripe_event_id = p_event_id;
    RETURN jsonb_build_object('result', 'ignored', 'reason', 'unknown_plan');
  END IF;

  IF p_user_id IS NULL THEN
    UPDATE public.stripe_webhook_events
    SET status = 'pending_identity', updated_at = now()
    WHERE stripe_event_id = p_event_id;
    RETURN jsonb_build_object('result', 'pending_identity');
  END IF;

  SELECT EXISTS(SELECT 1 FROM public.profiles WHERE id = p_user_id)
    INTO v_profile_exists;
  IF NOT v_profile_exists THEN
    UPDATE public.stripe_webhook_events
    SET status = 'pending_identity', updated_at = now()
    WHERE stripe_event_id = p_event_id;
    RETURN jsonb_build_object('result', 'pending_identity');
  END IF;

  BEGIN
    IF p_plan = 'SILVER' THEN
      v_grant := public.credit_grant_command(
        p_user_id,
        'stripe-silver-v1:' || p_event_id,
        'GRANT_STRIPE_SILVER',
        'stripe-silver-v1:' || p_event_id || ':' || p_user_id::text || ':40',
        'stripe:' || p_event_id || ':silver-credit-v1',
        'PURCHASED',
        40,
        p_event_created_at,
        NULL,
        'stripe:event:' || p_event_id,
        jsonb_build_object(
          'producer', 'stripe_checkout',
          'producer_version', '1.3C.3',
          'stripe_event_id', p_event_id,
          'product_id', p_product_id,
          'subscription_id', p_subscription_id,
          'customer_id', p_customer_id
        )
      );

      UPDATE public.profiles
      SET tier = CASE
            WHEN tier = 'GOLD' OR is_unlimited IS TRUE THEN 'GOLD'
            ELSE 'SILVER'
          END,
          is_unlimited = CASE
            WHEN tier = 'GOLD' OR is_unlimited IS TRUE THEN true
            ELSE false
          END,
          updated_at = now()
      WHERE id = p_user_id;
    ELSE
      IF p_subscription_id IS NULL OR p_subscription_id = '' THEN
        RAISE EXCEPTION 'Gold checkout missing subscription id';
      END IF;

      UPDATE public.profiles
      SET tier = 'GOLD', is_unlimited = true, updated_at = now()
      WHERE id = p_user_id;

      INSERT INTO public.stripe_subscriptions (
        subscription_id, user_id, customer_id, status, cancel_at_period_end
      ) VALUES (
        p_subscription_id, p_user_id, p_customer_id, 'checkout_completed', false
      )
      ON CONFLICT (subscription_id) DO UPDATE SET
        user_id = EXCLUDED.user_id,
        customer_id = COALESCE(EXCLUDED.customer_id, stripe_subscriptions.customer_id),
        status = 'checkout_completed',
        updated_at = now();
    END IF;

    UPDATE public.stripe_webhook_events
    SET status = 'processed', processed_at = now(), updated_at = now()
    WHERE stripe_event_id = p_event_id;

    RETURN jsonb_build_object(
      'result', 'processed',
      'plan', p_plan,
      'grant', v_grant
    );
  EXCEPTION WHEN OTHERS THEN
    UPDATE public.stripe_webhook_events
    SET status = 'failed', last_error = SQLERRM, updated_at = now()
    WHERE stripe_event_id = p_event_id;
    RETURN jsonb_build_object('result', 'failed', 'error', SQLERRM);
  END;
END;
$$;

-- Gold cancellation/downgrade now consults the governed finite balance, not the
-- legacy integer. Purchased/promotional/admin/legacy lots remain available after
-- unlimited access ends.
CREATE OR REPLACE FUNCTION public.process_stripe_subscription_event(
  p_event_id text,
  p_event_type text,
  p_subscription_id text,
  p_customer_id text DEFAULT NULL,
  p_status text DEFAULT NULL,
  p_cancel_at_period_end boolean DEFAULT false,
  p_event_created_at timestamptz DEFAULT now()
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_status text;
  v_user_id uuid;
  v_balance integer;
BEGIN
  IF p_event_id IS NULL OR p_event_id = '' OR p_subscription_id IS NULL OR p_subscription_id = '' THEN
    RETURN jsonb_build_object('result', 'failed', 'error', 'missing_event_or_subscription_id');
  END IF;

  INSERT INTO public.stripe_webhook_events (
    stripe_event_id, event_type, status, subscription_id, customer_id, stripe_created_at
  ) VALUES (
    p_event_id, p_event_type, 'processing', p_subscription_id, p_customer_id, p_event_created_at
  ) ON CONFLICT (stripe_event_id) DO NOTHING;

  SELECT status INTO v_status
  FROM public.stripe_webhook_events
  WHERE stripe_event_id = p_event_id
  FOR UPDATE;

  IF v_status IN ('processed', 'ignored') THEN
    RETURN jsonb_build_object('result', 'duplicate', 'status', v_status);
  END IF;

  SELECT user_id INTO v_user_id
  FROM public.stripe_subscriptions
  WHERE subscription_id = p_subscription_id;

  IF v_user_id IS NULL THEN
    UPDATE public.stripe_webhook_events
    SET status = 'pending_identity', updated_at = now()
    WHERE stripe_event_id = p_event_id;
    RETURN jsonb_build_object('result', 'pending_identity');
  END IF;

  UPDATE public.stripe_webhook_events
  SET status = 'processing', user_id = v_user_id,
      customer_id = COALESCE(p_customer_id, customer_id),
      last_error = NULL, updated_at = now()
  WHERE stripe_event_id = p_event_id;

  BEGIN
    UPDATE public.stripe_subscriptions
    SET customer_id = COALESCE(p_customer_id, customer_id),
        status = COALESCE(p_status, status),
        cancel_at_period_end = COALESCE(p_cancel_at_period_end, false),
        updated_at = now()
    WHERE subscription_id = p_subscription_id;

    IF p_event_type = 'customer.subscription.deleted' THEN
      v_balance := (
        public.credit_balance_snapshot_internal(v_user_id, now())->>'total'
      )::integer;

      UPDATE public.profiles
      SET is_unlimited = false,
          tier = CASE WHEN v_balance > 0 THEN 'SILVER' ELSE 'FREE' END,
          updated_at = now()
      WHERE id = v_user_id
        AND (tier = 'GOLD' OR is_unlimited IS TRUE);
    ELSIF p_status IN ('active', 'trialing') THEN
      UPDATE public.profiles
      SET tier = 'GOLD', is_unlimited = true, updated_at = now()
      WHERE id = v_user_id;
    END IF;

    UPDATE public.stripe_webhook_events
    SET status = 'processed', processed_at = now(), updated_at = now()
    WHERE stripe_event_id = p_event_id;

    RETURN jsonb_build_object('result', 'processed', 'user_id', v_user_id);
  EXCEPTION WHEN OTHERS THEN
    UPDATE public.stripe_webhook_events
    SET status = 'failed', last_error = SQLERRM, updated_at = now()
    WHERE stripe_event_id = p_event_id;
    RETURN jsonb_build_object('result', 'failed', 'error', SQLERRM);
  END;
END;
$$;

REVOKE ALL ON FUNCTION public.process_stripe_checkout_event(
  text, text, uuid, text, text, text, text, text, timestamptz
) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.process_stripe_subscription_event(
  text, text, text, text, text, boolean, timestamptz
) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.process_stripe_checkout_event(
  text, text, uuid, text, text, text, text, text, timestamptz
) TO service_role;
GRANT EXECUTE ON FUNCTION public.process_stripe_subscription_event(
  text, text, text, text, text, boolean, timestamptz
) TO service_role;

-- -----------------------------------------------------------------------------
-- 5. Admin positive adjustment: explicit idempotency key is mandatory.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.admin_add_credits(
  p_target_id uuid,
  p_amount integer,
  p_operation_id text
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_email text;
  v_is_admin boolean;
  v_granted_at timestamptz;
  v_grant jsonb;
BEGIN
  SELECT email INTO v_email FROM auth.users WHERE id = auth.uid();

  SELECT (role = 'admin' OR is_admin = true) INTO v_is_admin
  FROM public.profiles
  WHERE id = auth.uid();

  IF v_is_admin IS NOT true AND NOT public.is_hardcoded_admin(v_email) THEN
    RETURN jsonb_build_object('success', false, 'error', 'Acesso negado: apenas administradores.');
  END IF;

  IF p_amount IS NULL OR p_amount <= 0 OR p_amount > 1000 THEN
    RETURN jsonb_build_object('success', false, 'error', 'Valor inválido. Deve ser entre 1 e 1000 créditos.');
  END IF;

  IF p_operation_id IS NULL OR btrim(p_operation_id) = '' THEN
    RETURN jsonb_build_object('success', false, 'error', 'Identificador idempotente obrigatório.');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.profiles WHERE id = p_target_id) THEN
    RETURN jsonb_build_object('success', false, 'error', 'Usuário não encontrado.');
  END IF;

  SELECT g.granted_at
    INTO v_granted_at
  FROM public.credit_grants AS g
  WHERE g.user_id = p_target_id
    AND g.operation_id = p_operation_id;

  v_granted_at := COALESCE(v_granted_at, now());

  v_grant := public.credit_grant_command(
    p_target_id,
    p_operation_id,
    'GRANT_ADMIN_ADJUSTMENT',
    'admin-adjustment-v1:' || auth.uid()::text || ':' || p_target_id::text || ':' || p_amount::text,
    'admin:' || p_target_id::text || ':' || p_operation_id,
    'ADMIN_ADJUSTMENT',
    p_amount,
    v_granted_at,
    NULL,
    'admin:' || auth.uid()::text,
    jsonb_build_object(
      'producer', 'admin_adjustment',
      'producer_version', '1.3C.3',
      'admin_user_id', auth.uid()
    )
  );

  RETURN jsonb_build_object(
    'success', true,
    'grant', v_grant,
    'balance', public.credit_balance_snapshot_internal(p_target_id, now())
  );
END;
$$;

REVOKE ALL ON FUNCTION public.admin_add_credits(uuid, integer, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_add_credits(uuid, integer, text) TO authenticated;

-- Old two-argument entry point must fail closed once the governed producer
-- migration is activated. Keeping the signature gives legacy clients an explicit
-- error instead of silently creating an unaudited second balance.
CREATE OR REPLACE FUNCTION public.admin_add_credits(
  p_target_id uuid,
  p_amount integer
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN jsonb_build_object(
    'success', false,
    'error', 'Créditos são governados; identificador idempotente obrigatório.'
  );
END;
$$;

REVOKE ALL ON FUNCTION public.admin_add_credits(uuid, integer) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_add_credits(uuid, integer) TO authenticated;

-- Direct balance replacement through generic profile editing is no longer an
-- economic authority. Tier/role/admin fields remain independently manageable.
CREATE OR REPLACE FUNCTION public.admin_update_profile(
  p_target_id uuid,
  p_tier text DEFAULT NULL,
  p_credits integer DEFAULT NULL,
  p_is_unlimited boolean DEFAULT NULL,
  p_role text DEFAULT NULL,
  p_is_admin boolean DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_email text;
  v_is_admin boolean;
BEGIN
  SELECT email INTO v_email FROM auth.users WHERE id = auth.uid();

  SELECT (role = 'admin' OR is_admin = true) INTO v_is_admin
  FROM public.profiles
  WHERE id = auth.uid();

  IF v_is_admin IS not true AND NOT public.is_hardcoded_admin(v_email) THEN
    RETURN jsonb_build_object('success', false, 'error', 'Acesso negado: apenas administradores.');
  END IF;

  IF p_credits IS NOT NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Saldo governado não pode ser definido diretamente. Use ajuste administrativo.'
    );
  END IF;

  UPDATE public.profiles SET
    tier = COALESCE(p_tier, tier),
    is_unlimited = COALESCE(p_is_unlimited, is_unlimited),
    role = COALESCE(p_role, role),
    is_admin = COALESCE(p_is_admin, is_admin),
    updated_at = now()
  WHERE id = p_target_id;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Usuário não encontrado.');
  END IF;

  RETURN jsonb_build_object('success', true);
END;
$$;

REVOKE ALL ON FUNCTION public.admin_update_profile(
  uuid, text, integer, boolean, text, boolean
) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_update_profile(
  uuid, text, integer, boolean, text, boolean
) TO authenticated;

COMMIT;
