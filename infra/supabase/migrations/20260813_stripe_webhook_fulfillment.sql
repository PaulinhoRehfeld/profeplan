-- =============================================================================
-- ProfePlan Stripe fulfillment: idempotent checkout + Gold lifecycle
-- Date: 2026-08-13
--
-- This migration is intentionally NOT auto-deployed by repository CI.
-- It must be reviewed/applied before the canonical webhook is activated.
-- =============================================================================

BEGIN;

CREATE TABLE IF NOT EXISTS public.stripe_webhook_events (
  stripe_event_id text PRIMARY KEY,
  event_type text NOT NULL,
  status text NOT NULL DEFAULT 'processing'
    CHECK (status IN ('processing', 'processed', 'ignored', 'pending_identity', 'failed')),
  user_id uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  plan text CHECK (plan IS NULL OR plan IN ('SILVER', 'GOLD')),
  product_id text,
  subscription_id text,
  customer_id text,
  customer_email text,
  stripe_created_at timestamptz,
  processed_at timestamptz,
  last_error text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_stripe_webhook_events_status
  ON public.stripe_webhook_events(status);
CREATE INDEX IF NOT EXISTS idx_stripe_webhook_events_customer_email
  ON public.stripe_webhook_events(lower(customer_email))
  WHERE customer_email IS NOT NULL;

CREATE TABLE IF NOT EXISTS public.stripe_subscriptions (
  subscription_id text PRIMARY KEY,
  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  customer_id text,
  status text NOT NULL DEFAULT 'checkout_completed',
  cancel_at_period_end boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_stripe_subscriptions_user_id
  ON public.stripe_subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_stripe_subscriptions_customer_id
  ON public.stripe_subscriptions(customer_id)
  WHERE customer_id IS NOT NULL;

ALTER TABLE public.stripe_webhook_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stripe_subscriptions ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.stripe_webhook_events FROM anon, authenticated;
REVOKE ALL ON TABLE public.stripe_subscriptions FROM anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.stripe_webhook_events TO service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.stripe_subscriptions TO service_role;

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

REVOKE ALL ON FUNCTION public.process_stripe_checkout_event(text, text, uuid, text, text, text, text, text, timestamptz) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.process_stripe_subscription_event(text, text, text, text, text, boolean, timestamptz) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.process_stripe_checkout_event(text, text, uuid, text, text, text, text, text, timestamptz) TO service_role;
GRANT EXECUTE ON FUNCTION public.process_stripe_subscription_event(text, text, text, text, text, boolean, timestamptz) TO service_role;

COMMENT ON TABLE public.stripe_webhook_events IS
  'Idempotency ledger for Stripe webhook events. No direct anon/authenticated access.';
COMMENT ON TABLE public.stripe_subscriptions IS
  'Maps Stripe Gold subscriptions to ProfePlan profiles for lifecycle events.';

COMMIT;
