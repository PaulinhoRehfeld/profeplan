-- Read-only verification for the ProfePlan Stripe fulfillment migrations.
-- Safe to run after applying the fulfillment + RPC grant migrations.

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
  has_table_privilege('anon','public.stripe_webhook_events','SELECT') AS anon_events_select,
  has_table_privilege('authenticated','public.stripe_webhook_events','SELECT') AS authenticated_events_select,
  has_table_privilege('service_role','public.stripe_webhook_events','SELECT') AS service_events_select,
  has_table_privilege('anon','public.stripe_subscriptions','SELECT') AS anon_subscriptions_select,
  has_table_privilege('authenticated','public.stripe_subscriptions','SELECT') AS authenticated_subscriptions_select,
  has_table_privilege('service_role','public.stripe_subscriptions','SELECT') AS service_subscriptions_select;

SELECT
  has_function_privilege(
    'anon',
    'public.process_stripe_checkout_event(text,text,uuid,text,text,text,text,text,timestamptz)',
    'EXECUTE'
  ) AS anon_checkout_execute,
  has_function_privilege(
    'authenticated',
    'public.process_stripe_checkout_event(text,text,uuid,text,text,text,text,text,timestamptz)',
    'EXECUTE'
  ) AS authenticated_checkout_execute,
  has_function_privilege(
    'service_role',
    'public.process_stripe_checkout_event(text,text,uuid,text,text,text,text,text,timestamptz)',
    'EXECUTE'
  ) AS service_checkout_execute,
  has_function_privilege(
    'anon',
    'public.process_stripe_subscription_event(text,text,text,text,text,boolean,timestamptz)',
    'EXECUTE'
  ) AS anon_subscription_execute,
  has_function_privilege(
    'authenticated',
    'public.process_stripe_subscription_event(text,text,text,text,text,boolean,timestamptz)',
    'EXECUTE'
  ) AS authenticated_subscription_execute,
  has_function_privilege(
    'service_role',
    'public.process_stripe_subscription_event(text,text,text,text,text,boolean,timestamptz)',
    'EXECUTE'
  ) AS service_subscription_execute;

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
