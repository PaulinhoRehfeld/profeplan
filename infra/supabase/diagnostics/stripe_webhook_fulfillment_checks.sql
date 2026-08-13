-- Read-only verification for the ProfePlan Stripe fulfillment migration.
-- Safe to run after applying 20260813_stripe_webhook_fulfillment.sql.

SELECT
  to_regclass('public.stripe_webhook_events') AS stripe_webhook_events,
  to_regclass('public.stripe_subscriptions') AS stripe_subscriptions;

SELECT
  p.proname,
  pg_get_function_identity_arguments(p.oid) AS arguments,
  p.prosecdef AS security_definer
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public'
  AND p.proname IN ('process_stripe_checkout_event', 'process_stripe_subscription_event')
ORDER BY p.proname;

SELECT
  c.relname,
  c.relrowsecurity AS rls_enabled
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
  AND c.relname IN ('stripe_webhook_events', 'stripe_subscriptions')
ORDER BY c.relname;

SELECT
  status,
  count(*) AS events
FROM public.stripe_webhook_events
GROUP BY status
ORDER BY status;

SELECT
  subscription_id,
  user_id,
  customer_id,
  status,
  cancel_at_period_end,
  updated_at
FROM public.stripe_subscriptions
ORDER BY updated_at DESC
LIMIT 20;
