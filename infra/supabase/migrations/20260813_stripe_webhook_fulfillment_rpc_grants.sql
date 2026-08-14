BEGIN;

REVOKE EXECUTE ON FUNCTION public.process_stripe_checkout_event(
  text, text, uuid, text, text, text, text, text, timestamptz
) FROM PUBLIC, anon, authenticated;

REVOKE EXECUTE ON FUNCTION public.process_stripe_subscription_event(
  text, text, text, text, text, boolean, timestamptz
) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public.process_stripe_checkout_event(
  text, text, uuid, text, text, text, text, text, timestamptz
) TO service_role;

GRANT EXECUTE ON FUNCTION public.process_stripe_subscription_event(
  text, text, text, text, text, boolean, timestamptz
) TO service_role;

COMMIT;
