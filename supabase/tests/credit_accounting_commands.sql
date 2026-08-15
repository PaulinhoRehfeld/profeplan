-- =============================================================================
-- Disposable proof matrix — ProfePlan Credit Accounting Lote 1.3B.2
-- =============================================================================
\set ON_ERROR_STOP on

CREATE TEMP TABLE credit_test_clock (t timestamptz NOT NULL);
INSERT INTO credit_test_clock VALUES (clock_timestamp());
GRANT SELECT ON credit_test_clock TO service_role;

INSERT INTO public.profiles (id, tier, credits, is_unlimited) VALUES
  ('00000000-0000-0000-0000-000000000101', 'FREE', 999, false),
  ('00000000-0000-0000-0000-000000000102', 'GOLD', 0, true),
  ('00000000-0000-0000-0000-000000000103', 'FREE', 0, false),
  ('00000000-0000-0000-0000-000000000104', 'FREE', 0, false),
  ('00000000-0000-0000-0000-000000000105', 'FREE', 0, false),
  ('00000000-0000-0000-0000-000000000106', 'FREE', 0, false),
  ('00000000-0000-0000-0000-000000000107', 'FREE', 0, false);

-- ---------------------------------------------------------------------------
-- 1. Permission boundary
-- ---------------------------------------------------------------------------
DO $$
BEGIN
  IF has_table_privilege('service_role', 'public.credit_operations', 'INSERT')
     OR has_table_privilege('service_role', 'public.credit_grants', 'INSERT')
     OR has_table_privilege('service_role', 'public.credit_ledger_entries', 'INSERT') THEN
    RAISE EXCEPTION 'service_role retained forbidden direct INSERT privilege';
  END IF;

  IF has_function_privilege(
       'service_role',
       'public.credit_consume_internal(uuid,text,text,text,text,text,jsonb)',
       'EXECUTE'
     ) THEN
    RAISE EXCEPTION 'service_role can execute private consume primitive';
  END IF;

  IF NOT has_function_privilege(
       'service_role',
       'public.credit_grant_command(uuid,text,text,text,text,text,integer,timestamptz,timestamptz,text,jsonb)',
       'EXECUTE'
     ) THEN
    RAISE EXCEPTION 'service_role cannot execute governed grant command';
  END IF;

  IF NOT has_function_privilege(
       'authenticated',
       'public.credit_get_my_balance()',
       'EXECUTE'
     ) THEN
    RAISE EXCEPTION 'authenticated cannot read own governed balance';
  END IF;

  IF has_function_privilege(
       'anon',
       'public.credit_get_my_balance()',
       'EXECUTE'
     ) THEN
    RAISE EXCEPTION 'anon can execute authenticated balance RPC';
  END IF;
END;
$$;

-- ---------------------------------------------------------------------------
-- 2. Service-side grants: FREE 10/7d + PURCHASED, idempotent replay
-- ---------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE service_role;
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000101',
  'grant-free-101',
  'GRANT_FREE_TRIAL',
  'fp-grant-free-101',
  'free-trial:101',
  'FREE_TRIAL',
  10,
  (SELECT t FROM credit_test_clock),
  (SELECT t + interval '7 days' FROM credit_test_clock),
  'signup:101',
  '{"test":"free"}'::jsonb
);
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000101',
  'grant-purchased-101',
  'GRANT_PURCHASE',
  'fp-grant-purchased-101',
  'purchase:101:1',
  'PURCHASED',
  2,
  (SELECT t FROM credit_test_clock),
  NULL,
  'stripe:test:101',
  '{"test":"purchase"}'::jsonb
);
COMMIT;

DO $$
DECLARE
  v_result jsonb;
  v_grants integer;
  v_credits integer;
BEGIN
  SELECT public.credit_grant_command(
    '00000000-0000-0000-0000-000000000101',
    'grant-free-101',
    'GRANT_FREE_TRIAL',
    'fp-grant-free-101',
    'free-trial:101',
    'FREE_TRIAL',
    10,
    (SELECT t FROM credit_test_clock),
    (SELECT t + interval '7 days' FROM credit_test_clock),
    'signup:101',
    '{"test":"free"}'::jsonb
  ) INTO v_result;

  IF COALESCE((v_result ->> 'replay')::boolean, false) IS DISTINCT FROM true
     OR v_result ->> 'reason' <> 'REPLAY' THEN
    RAISE EXCEPTION 'grant replay was not deterministic: %', v_result;
  END IF;

  SELECT COUNT(*) INTO v_grants
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-0000-0000-000000000101';

  SELECT COUNT(*) INTO v_credits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-0000-0000-000000000101'
    AND entry_type = 'CREDIT';

  IF v_grants <> 2 OR v_credits <> 2 THEN
    RAISE EXCEPTION 'grant replay duplicated accounting rows';
  END IF;

  BEGIN
    PERFORM public.credit_grant_command(
      '00000000-0000-0000-0000-000000000101',
      'grant-free-101',
      'GRANT_FREE_TRIAL',
      'DIFFERENT-FINGERPRINT',
      'free-trial:101',
      'FREE_TRIAL',
      10,
      (SELECT t FROM credit_test_clock),
      (SELECT t + interval '7 days' FROM credit_test_clock),
      'signup:101',
      '{}'::jsonb
    );
    RAISE EXCEPTION 'grant replay fingerprint mismatch was accepted';
  EXCEPTION
    WHEN SQLSTATE '22023' THEN NULL;
  END;
END;
$$;

-- profiles.credits is intentionally unrelated to the ledger authority.
DO $$
DECLARE
  v_snapshot jsonb;
BEGIN
  SELECT public.credit_get_balance_for_user(
    '00000000-0000-0000-0000-000000000101'
  ) INTO v_snapshot;

  IF (v_snapshot ->> 'total')::integer <> 12
     OR (v_snapshot ->> 'free_trial')::integer <> 10
     OR (v_snapshot ->> 'purchased')::integer <> 2 THEN
    RAISE EXCEPTION 'derived balance ignored ledger or leaked profiles.credits: %', v_snapshot;
  END IF;
END;
$$;

-- ---------------------------------------------------------------------------
-- 3. FREE first, stable replay, then PURCHASED, then controlled rejection
-- ---------------------------------------------------------------------------
DO $$
DECLARE
  v_result jsonb;
  i integer;
  v_free_debits integer;
  v_purchased_debits integer;
  v_total_debits integer;
BEGIN
  SELECT public.credit_consume_internal(
    '00000000-0000-0000-0000-000000000101',
    'consume-101-1',
    'SAVE_TERM_PLAN',
    'fp-consume-101-1',
    'term_plan',
    'artifact-101-1',
    '{}'::jsonb
  ) INTO v_result;

  IF v_result ->> 'reason' <> 'CHARGED'
     OR (v_result ->> 'balance_after')::integer <> 11 THEN
    RAISE EXCEPTION 'first consume failed: %', v_result;
  END IF;

  SELECT public.credit_consume_internal(
    '00000000-0000-0000-0000-000000000101',
    'consume-101-1',
    'SAVE_TERM_PLAN',
    'fp-consume-101-1',
    'term_plan',
    'artifact-101-1',
    '{}'::jsonb
  ) INTO v_result;

  IF v_result ->> 'reason' <> 'REPLAY'
     OR v_result ->> 'original_reason' <> 'CHARGED'
     OR (v_result ->> 'balance_after')::integer <> 11 THEN
    RAISE EXCEPTION 'consume replay was not stable: %', v_result;
  END IF;

  BEGIN
    PERFORM public.credit_consume_internal(
      '00000000-0000-0000-0000-000000000101',
      'consume-101-1',
      'SAVE_TERM_PLAN',
      'DIFFERENT-FINGERPRINT',
      'term_plan',
      'artifact-101-1',
      '{}'::jsonb
    );
    RAISE EXCEPTION 'consume replay fingerprint mismatch was accepted';
  EXCEPTION
    WHEN SQLSTATE '22023' THEN NULL;
  END;

  FOR i IN 2..12 LOOP
    PERFORM public.credit_consume_internal(
      '00000000-0000-0000-0000-000000000101',
      format('consume-101-%s', i),
      'SAVE_TERM_PLAN',
      format('fp-consume-101-%s', i),
      'term_plan',
      format('artifact-101-%s', i),
      '{}'::jsonb
    );
  END LOOP;

  SELECT COUNT(*) INTO v_free_debits
  FROM public.credit_ledger_entries AS le
  JOIN public.credit_grants AS g ON g.id = le.grant_id
  WHERE le.user_id = '00000000-0000-0000-0000-000000000101'
    AND le.entry_type = 'DEBIT'
    AND g.origin = 'FREE_TRIAL';

  SELECT COUNT(*) INTO v_purchased_debits
  FROM public.credit_ledger_entries AS le
  JOIN public.credit_grants AS g ON g.id = le.grant_id
  WHERE le.user_id = '00000000-0000-0000-0000-000000000101'
    AND le.entry_type = 'DEBIT'
    AND g.origin = 'PURCHASED';

  SELECT COUNT(*) INTO v_total_debits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-0000-0000-000000000101'
    AND entry_type = 'DEBIT';

  IF v_free_debits <> 10 OR v_purchased_debits <> 2 OR v_total_debits <> 12 THEN
    RAISE EXCEPTION 'lot ordering/debit cardinality failed free=% purchased=% total=%',
      v_free_debits, v_purchased_debits, v_total_debits;
  END IF;

  SELECT public.credit_consume_internal(
    '00000000-0000-0000-0000-000000000101',
    'consume-101-13',
    'SAVE_TERM_PLAN',
    'fp-consume-101-13',
    'term_plan',
    'artifact-101-13',
    '{}'::jsonb
  ) INTO v_result;

  IF v_result ->> 'reason' <> 'INSUFFICIENT_CREDITS'
     OR v_result ->> 'outcome' <> 'REJECTED'
     OR (v_result ->> 'balance_after')::integer <> 0 THEN
    RAISE EXCEPTION 'insufficient credit decision failed: %', v_result;
  END IF;

  IF (
    SELECT COUNT(*)
    FROM public.credit_ledger_entries
    WHERE user_id = '00000000-0000-0000-0000-000000000101'
      AND entry_type = 'DEBIT'
  ) <> 12 THEN
    RAISE EXCEPTION 'rejected consume created a debit';
  END IF;
END;
$$;

-- ---------------------------------------------------------------------------
-- 4. Expired FREE is ignored; PURCHASED never expires
-- ---------------------------------------------------------------------------
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000103',
  'grant-free-expired-103',
  'GRANT_FREE_TRIAL',
  'fp-free-expired-103',
  'free-trial:103',
  'FREE_TRIAL',
  10,
  (SELECT t - interval '8 days' FROM credit_test_clock),
  (SELECT t - interval '1 day' FROM credit_test_clock),
  'signup:103',
  '{}'::jsonb
);
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000103',
  'grant-purchased-103',
  'GRANT_PURCHASE',
  'fp-purchased-103',
  'purchase:103:1',
  'PURCHASED',
  1,
  (SELECT t FROM credit_test_clock),
  NULL,
  'stripe:test:103',
  '{}'::jsonb
);

DO $$
DECLARE
  v_result jsonb;
  v_origin text;
BEGIN
  SELECT public.credit_consume_internal(
    '00000000-0000-0000-0000-000000000103',
    'consume-103-1',
    'SAVE_ASSESSMENT',
    'fp-consume-103-1',
    'assessment',
    'artifact-103-1',
    '{}'::jsonb
  ) INTO v_result;

  SELECT g.origin INTO v_origin
  FROM public.credit_grants AS g
  WHERE g.id = (v_result ->> 'grant_id_consumed')::uuid;

  IF v_origin <> 'PURCHASED' OR (v_result ->> 'balance_after')::integer <> 0 THEN
    RAISE EXCEPTION 'expired FREE was consumed or purchased availability failed: %', v_result;
  END IF;
END;
$$;

-- ---------------------------------------------------------------------------
-- 5. GOLD records usage without debit
-- ---------------------------------------------------------------------------
DO $$
DECLARE
  v_result jsonb;
BEGIN
  SELECT public.credit_consume_internal(
    '00000000-0000-0000-0000-000000000102',
    'consume-gold-102-1',
    'SAVE_PRESENTATION',
    'fp-gold-102-1',
    'presentation',
    'artifact-gold-102-1',
    '{}'::jsonb
  ) INTO v_result;

  IF v_result ->> 'outcome' <> 'NO_CHARGE'
     OR v_result ->> 'reason' <> 'GOLD_UNLIMITED'
     OR COALESCE((v_result ->> 'charged')::boolean, true) THEN
    RAISE EXCEPTION 'Gold decision failed: %', v_result;
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.credit_ledger_entries
    WHERE operation_id = 'consume-gold-102-1'
  ) THEN
    RAISE EXCEPTION 'Gold created a ledger debit';
  END IF;
END;
$$;

-- ---------------------------------------------------------------------------
-- 6. Non-purchased deterministic policy preserves known PURCHASED last
-- ---------------------------------------------------------------------------
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000106',
  'grant-bonus-106', 'GRANT_BONUS', 'fp-bonus-106', 'bonus:106',
  'PROMOTIONAL_BONUS', 1, (SELECT t FROM credit_test_clock), NULL, 'bonus:test:106', '{}'
);
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000106',
  'grant-admin-106', 'GRANT_ADMIN', 'fp-admin-106', 'admin:106',
  'ADMIN_ADJUSTMENT', 1, (SELECT t FROM credit_test_clock), NULL, 'admin:test:106', '{}'
);
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000106',
  'grant-legacy-106', 'GRANT_LEGACY', 'fp-legacy-106', 'legacy:106',
  'LEGACY_BALANCE', 1, (SELECT t FROM credit_test_clock), NULL, 'legacy:test:106', '{}'
);
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000106',
  'grant-purchased-106', 'GRANT_PURCHASE', 'fp-purchased-106', 'purchase:106',
  'PURCHASED', 1, (SELECT t FROM credit_test_clock), NULL, 'stripe:test:106', '{}'
);

DO $$
DECLARE
  i integer;
  v_expected text[] := ARRAY['PROMOTIONAL_BONUS','ADMIN_ADJUSTMENT','LEGACY_BALANCE','PURCHASED'];
  v_result jsonb;
  v_origin text;
BEGIN
  FOR i IN 1..4 LOOP
    SELECT public.credit_consume_internal(
      '00000000-0000-0000-0000-000000000106',
      format('consume-106-%s', i),
      'SAVE_PDI_REPORT',
      format('fp-consume-106-%s', i),
      'pdi_report',
      format('artifact-106-%s', i),
      '{}'
    ) INTO v_result;

    SELECT origin INTO v_origin
    FROM public.credit_grants
    WHERE id = (v_result ->> 'grant_id_consumed')::uuid;

    IF v_origin <> v_expected[i] THEN
      RAISE EXCEPTION 'deterministic non-purchased order failed at %: got %, expected %',
        i, v_origin, v_expected[i];
    END IF;
  END LOOP;
END;
$$;

-- ---------------------------------------------------------------------------
-- 7. Authenticated self-balance RPC uses auth.uid() and no user-id parameter
-- ---------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT set_config(
  'request.jwt.claim.sub',
  '00000000-0000-0000-0000-000000000106',
  true
);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-000000000106","role":"authenticated"}',
  true
);
SELECT (
  (public.credit_get_my_balance() ->> 'user_id')::uuid =
    '00000000-0000-0000-0000-000000000106'::uuid
  AND (public.credit_get_my_balance() ->> 'total')::integer = 0
) AS authenticated_balance_guard
\gset
\if :authenticated_balance_guard
  \echo 'authenticated self-balance guard passed'
\else
  \echo 'authenticated self-balance guard failed'
  \quit 3
\endif
ROLLBACK;

-- ---------------------------------------------------------------------------
-- 8. Rollback proof: decision + debit disappear if the surrounding business
--    transaction rolls back before canonical artifact commit.
-- ---------------------------------------------------------------------------
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000105',
  'grant-purchased-105', 'GRANT_PURCHASE', 'fp-purchased-105', 'purchase:105',
  'PURCHASED', 1, (SELECT t FROM credit_test_clock), NULL, 'stripe:test:105', '{}'
);

BEGIN;
SELECT public.credit_consume_internal(
  '00000000-0000-0000-0000-000000000105',
  'consume-rollback-105',
  'SAVE_SIMULATION',
  'fp-rollback-105',
  'simulation',
  'artifact-rollback-105',
  '{}'
);
ROLLBACK;

DO $$
DECLARE
  v_snapshot jsonb;
BEGIN
  IF EXISTS (
    SELECT 1 FROM public.credit_operations
    WHERE operation_id = 'consume-rollback-105'
  ) OR EXISTS (
    SELECT 1 FROM public.credit_ledger_entries
    WHERE operation_id = 'consume-rollback-105'
  ) THEN
    RAISE EXCEPTION 'rollback left economic residue';
  END IF;

  SELECT public.credit_get_balance_for_user(
    '00000000-0000-0000-0000-000000000105'
  ) INTO v_snapshot;

  IF (v_snapshot ->> 'total')::integer <> 1 THEN
    RAISE EXCEPTION 'rollback consumed balance: %', v_snapshot;
  END IF;
END;
$$;

-- ---------------------------------------------------------------------------
-- 9. Prepare a single-credit user for the parallel-session workflow proof.
-- ---------------------------------------------------------------------------
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000104',
  'grant-concurrency-104', 'GRANT_PURCHASE', 'fp-concurrency-104', 'purchase:104',
  'PURCHASED', 1, (SELECT t FROM credit_test_clock), NULL, 'stripe:test:104', '{}'
);

-- A future-dated grant is not spendable before granted_at.
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000107',
  'grant-future-107', 'GRANT_PURCHASE', 'fp-future-107', 'purchase:107:future',
  'PURCHASED', 1, (SELECT t + interval '1 day' FROM credit_test_clock), NULL,
  'stripe:test:107', '{}'
);

DO $$
DECLARE
  v_snapshot jsonb;
BEGIN
  SELECT public.credit_get_balance_for_user(
    '00000000-0000-0000-0000-000000000107'
  ) INTO v_snapshot;

  IF (v_snapshot ->> 'total')::integer <> 0 THEN
    RAISE EXCEPTION 'future-dated grant became spendable early: %', v_snapshot;
  END IF;
END;
$$;

SELECT 'OK:credit_accounting_commands_1_3B_2' AS result;
