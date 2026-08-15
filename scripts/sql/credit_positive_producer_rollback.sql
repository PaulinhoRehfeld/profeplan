-- =============================================================================
-- ProfePlan — Lote 1.3C.6 positive-producer rollback candidate
--
-- VERSIONED ONLY. DO NOT RUN AGAINST HOSTED PRODUCTION WITHOUT EXPLICIT
-- MATERIAL AUTHORIZATION AND A MATCHING READ-ONLY PREFLIGHT SNAPSHOT.
--
-- Purpose:
-- - restore the exact pre-1.3C.3 server-side producer authority observed in the
--   hosted PROFEPLAN database during the 2026-08-15 preflight;
-- - make a Vercel rollback with producer/consumer flags OFF economically
--   coherent again;
-- - keep ledger tables/entries intact but dormant (non-destructive rollback).
--
-- This script intentionally does NOT delete governed ledger history.
-- =============================================================================

BEGIN;

-- Disable the governed FREE_TRIAL producer before restoring legacy profile
-- creation. Existing ledger grants/history remain untouched.
DROP TRIGGER IF EXISTS on_profile_created_credit_free_trial ON public.profiles;

-- Canonical pre-cutover auth.users -> profiles behavior captured from hosted DB:
-- new FREE users receive the legacy integer balance of 10.
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
    10,
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO UPDATE SET
    email        = EXCLUDED.email,
    full_name    = COALESCE(profiles.full_name, EXCLUDED.full_name),
    tier         = CASE WHEN profiles.tier IS NULL THEN 'FREE' ELSE profiles.tier END,
    is_unlimited = CASE WHEN profiles.is_unlimited IS NULL THEN false ELSE profiles.is_unlimited END,
    credits      = CASE WHEN profiles.credits IS NULL THEN 10 ELSE profiles.credits END,
    updated_at   = NOW();

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'handle_new_user failed for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Restore legacy credits=10 for authenticated emergency profile recovery.
-- Rollback changes economic authority but must not restore anonymous access.
CREATE OR REPLACE FUNCTION public.update_my_profile(p_updates jsonb)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog
AS $
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
        10,
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
$;

ALTER FUNCTION public.update_my_profile(jsonb) OWNER TO postgres;
REVOKE ALL ON FUNCTION public.update_my_profile(jsonb)
  FROM PUBLIC, anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.update_my_profile(jsonb) TO authenticated;

-- Restore the pre-ledger Stripe fulfillment functions. Their signatures remain
-- identical to the active stripe-webhook Edge Function contract.
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
      UPDATE public.profiles
      SET credits = COALESCE(credits, 0) + 40,
          tier = CASE
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

    RETURN jsonb_build_object('result', 'processed', 'plan', p_plan);
  EXCEPTION WHEN OTHERS THEN
    UPDATE public.stripe_webhook_events
    SET status = 'failed', last_error = SQLERRM, updated_at = now()
    WHERE stripe_event_id = p_event_id;
    RETURN jsonb_build_object('result', 'failed', 'error', SQLERRM);
  END;
END;
$$;

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
      UPDATE public.profiles
      SET is_unlimited = false,
          tier = CASE WHEN COALESCE(credits, 0) > 0 THEN 'SILVER' ELSE 'FREE' END,
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

-- Restore the pre-ledger administrative positive-credit boundary.
CREATE OR REPLACE FUNCTION public.admin_add_credits(
  p_target_id uuid,
  p_amount integer
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_email text;
  v_current int;
BEGIN
  SELECT email INTO v_email FROM auth.users WHERE id = auth.uid();

  IF NOT public.is_admin_safe() AND NOT public.is_hardcoded_admin(v_email) THEN
    RETURN jsonb_build_object('success', false, 'error', 'Acesso negado: apenas administradores.');
  END IF;

  IF p_amount <= 0 OR p_amount > 1000 THEN
    RETURN jsonb_build_object('success', false, 'error', 'Valor inválido. Deve ser entre 1 e 1000 créditos.');
  END IF;

  SELECT credits INTO v_current
  FROM public.profiles
  WHERE id = p_target_id;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Usuário não encontrado.');
  END IF;

  UPDATE public.profiles SET
    credits = COALESCE(v_current, 0) + p_amount,
    updated_at = NOW()
  WHERE id = p_target_id;

  RETURN jsonb_build_object('success', true, 'new_credits', COALESCE(v_current, 0) + p_amount);
END;
$$;

REVOKE ALL ON FUNCTION public.admin_add_credits(uuid, integer) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_add_credits(uuid, integer) TO authenticated;

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
BEGIN
  SELECT email INTO v_email FROM auth.users WHERE id = auth.uid();

  IF NOT public.is_admin_safe() AND NOT public.is_hardcoded_admin(v_email) THEN
    RETURN jsonb_build_object('success', false, 'error', 'Acesso negado: apenas administradores.');
  END IF;

  UPDATE public.profiles SET
    tier = COALESCE(p_tier, tier),
    credits = COALESCE(p_credits, credits),
    is_unlimited = COALESCE(p_is_unlimited, is_unlimited),
    role = COALESCE(p_role, role),
    is_admin = COALESCE(p_is_admin, is_admin),
    updated_at = NOW()
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

-- Remove producer-only public entry points that have no legacy equivalent.
DROP FUNCTION IF EXISTS public.admin_add_credits(uuid, integer, text);
DROP FUNCTION IF EXISTS public.credit_register_my_phone_bonus(text);
DROP FUNCTION IF EXISTS public.credit_claim_my_referral_bonus();
DROP FUNCTION IF EXISTS public.credit_on_profile_created_free_trial();
DROP FUNCTION IF EXISTS public.credit_grant_profile_free_trial(uuid);

COMMIT;
