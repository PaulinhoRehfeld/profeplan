BEGIN;

CREATE TABLE IF NOT EXISTS public.stripe_webhook_events (
  stripe_event_id text PRIMARY KEY,
  event_type text NOT NULL,
  status text NOT NULL DEFAULT 'processing'
    CHECK (status IN ('processing', 'processed', 'ignored', 'pending_identity', 'failed')),
  user_id uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  payment_link_id text,
  subscription_id text,
  customer_id text,
  customer_email text,
  stripe_created_at timestamptz,
  processed_at timestamptz,
  last_error text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.stripe_subscriptions (
  subscription_id text PRIMARY KEY,
  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  customer_id text,
  status text NOT NULL DEFAULT 'checkout_completed',
  cancel_at_period_end boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.stripe_webhook_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stripe_subscriptions ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.stripe_webhook_events FROM anon, authenticated;
REVOKE ALL ON TABLE public.stripe_subscriptions FROM anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.stripe_webhook_events TO service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.stripe_subscriptions TO service_role;

COMMIT;
