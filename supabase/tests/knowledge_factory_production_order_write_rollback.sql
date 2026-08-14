-- =============================================================================
-- Knowledge Factory Sublote 3B.5.3 - guarded rollback rehearsal
-- NON-PRODUCTION / DISPOSABLE ENVIRONMENTS ONLY.
--
-- The rollback refuses to discard idempotency receipts. OPP data created by
-- already-committed RPCs is intentionally never deleted by this script.
-- =============================================================================

BEGIN;

DO $guard$
DECLARE
  v_receipt_count bigint;
BEGIN
  IF to_regclass('public.kf_production_order_write_receipts') IS NOT NULL THEN
    SELECT count(*) INTO v_receipt_count
    FROM public.kf_production_order_write_receipts;

    IF v_receipt_count <> 0 THEN
      RAISE EXCEPTION
        'Refusing Sublote 3B.5.3 rollback: kf_production_order_write_receipts contains % row(s)',
        v_receipt_count;
    END IF;
  END IF;
END;
$guard$;

REVOKE ALL ON FUNCTION
  public.kf_create_production_order(uuid, jsonb),
  public.kf_transition_production_order(uuid, jsonb)
FROM PUBLIC, anon, authenticated, service_role;

DROP FUNCTION public.kf_create_production_order(uuid, jsonb);
DROP FUNCTION public.kf_transition_production_order(uuid, jsonb);

DROP FUNCTION public.kf_opp_event_type_internal(text);
DROP FUNCTION public.kf_opp_transition_allowed_internal(text, text);
DROP FUNCTION public.kf_opp_write_fingerprint_internal(text, jsonb);
DROP FUNCTION public.kf_opp_write_positive_integer_internal(jsonb, text);
DROP FUNCTION public.kf_opp_write_timestamp_internal(jsonb, text);
DROP FUNCTION public.kf_opp_write_uuid_internal(jsonb, text);
DROP FUNCTION public.kf_opp_write_text_internal(jsonb, text, boolean);
DROP FUNCTION public.kf_opp_write_assert_object_internal(jsonb, text[], text[], text);

DROP TABLE public.kf_production_order_write_receipts;

-- Restore only the preparatory grants that existed immediately before 3B.5.3.
GRANT INSERT ON TABLE public.kf_production_orders TO authenticated;
GRANT INSERT, UPDATE ON TABLE public.kf_production_orders TO service_role;
GRANT INSERT ON TABLE public.kf_production_order_events TO service_role;

DO $postconditions$
BEGIN
  IF to_regclass('public.kf_production_orders') IS NULL
    OR to_regclass('public.kf_production_order_events') IS NULL THEN
    RAISE EXCEPTION 'Sublote 3B.5.3 rollback damaged the Lote 3A OPP schema';
  END IF;

  IF to_regclass('public.kf_production_order_write_receipts') IS NOT NULL
    OR to_regprocedure('public.kf_create_production_order(uuid,jsonb)') IS NOT NULL
    OR to_regprocedure('public.kf_transition_production_order(uuid,jsonb)') IS NOT NULL THEN
    RAISE EXCEPTION 'Sublote 3B.5.3 rollback left a write object behind';
  END IF;

  IF NOT has_table_privilege('authenticated', 'public.kf_production_orders', 'INSERT')
    OR NOT has_table_privilege('service_role', 'public.kf_production_orders', 'INSERT')
    OR NOT has_table_privilege('service_role', 'public.kf_production_orders', 'UPDATE')
    OR NOT has_table_privilege('service_role', 'public.kf_production_order_events', 'INSERT') THEN
    RAISE EXCEPTION 'Sublote 3B.5.3 rollback did not restore preparatory OPP grants';
  END IF;
END;
$postconditions$;

COMMIT;
