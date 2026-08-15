-- =============================================================================
-- ProfePlan — Lote 1.3C.5 integrated legacy-balance rehearsal
-- Disposable Supabase only.
--
-- This intentionally preserves the historical 1.3C.2 proof unchanged. The
-- integrated schema also contains synthetic users for producer/consumer tests,
-- so every assertion below is scoped to the exact 31-profile legacy cohort.
-- =============================================================================
\set ON_ERROR_STOP on

CREATE OR REPLACE FUNCTION pg_temp.is_legacy_cutover_fixture_user(p_user_id uuid)
RETURNS boolean
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM generate_series(1, 31) AS gs
    WHERE p_user_id = (
      '00000000-0000-0000-0000-' || lpad(gs::text, 12, '0')
    )::uuid
  );
$$;

CREATE OR REPLACE FUNCTION pg_temp.rehearse_integrated_legacy_balance_import(
  p_cutover_at timestamptz
)
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
  v_profile record;
  v_processed integer := 0;
BEGIN
  FOR v_profile IN
    SELECT id, credits
    FROM public.profiles
    WHERE pg_temp.is_legacy_cutover_fixture_user(id)
      AND COALESCE(is_unlimited, false) IS false
      AND COALESCE(credits, 0) > 0
    ORDER BY id
  LOOP
    PERFORM public.credit_grant_command(
      v_profile.id,
      'legacy-balance-cutover-v1:' || v_profile.id::text,
      'GRANT_LEGACY_BALANCE',
      'legacy-balance-cutover-v1:' || v_profile.id::text || ':' || v_profile.credits::text,
      'legacy:' || v_profile.id::text || ':credit-cutover-v1',
      'LEGACY_BALANCE',
      v_profile.credits,
      p_cutover_at,
      NULL,
      'profiles.credits@credit-cutover-v1',
      jsonb_build_object(
        'cutover_version', 'credit-cutover-v1',
        'source', 'profiles.credits',
        'rehearsal', true,
        'integrated_rehearsal', '1.3C.5'
      )
    );

    v_processed := v_processed + 1;
  END LOOP;

  RETURN v_processed;
END;
$$;

-- -----------------------------------------------------------------------------
-- 1. The legacy cohort must still match the audited aggregate even while other
--    synthetic profiles coexist in the same final rehearsal database.
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  v_profiles integer;
  v_finite integer;
  v_finite_sum integer;
  v_gold integer;
  v_gold_sentinel integer;
BEGIN
  SELECT COUNT(*) INTO v_profiles
  FROM public.profiles
  WHERE pg_temp.is_legacy_cutover_fixture_user(id);

  SELECT COUNT(*) INTO v_finite
  FROM public.profiles
  WHERE pg_temp.is_legacy_cutover_fixture_user(id)
    AND COALESCE(is_unlimited, false) IS false;

  SELECT COALESCE(SUM(GREATEST(COALESCE(credits, 0), 0)), 0)::integer
    INTO v_finite_sum
  FROM public.profiles
  WHERE pg_temp.is_legacy_cutover_fixture_user(id)
    AND COALESCE(is_unlimited, false) IS false;

  SELECT COUNT(*), MAX(credits)
    INTO v_gold, v_gold_sentinel
  FROM public.profiles
  WHERE pg_temp.is_legacy_cutover_fixture_user(id)
    AND tier = 'GOLD'
    AND is_unlimited IS true;

  IF v_profiles <> 31 THEN
    RAISE EXCEPTION 'integrated legacy cohort count mismatch: %', v_profiles;
  END IF;
  IF v_finite <> 30 THEN
    RAISE EXCEPTION 'integrated legacy finite count mismatch: %', v_finite;
  END IF;
  IF v_finite_sum <> 292 THEN
    RAISE EXCEPTION 'integrated legacy aggregate mismatch: %', v_finite_sum;
  END IF;
  IF v_gold <> 1 OR v_gold_sentinel <> 9999 THEN
    RAISE EXCEPTION 'integrated legacy GOLD sentinel mismatch: count %, sentinel %',
      v_gold, v_gold_sentinel;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 2. Rollback rehearsal scoped to the legacy cohort.
-- -----------------------------------------------------------------------------
BEGIN;
DO $$
DECLARE
  v_processed integer;
  v_grants integer;
  v_sum integer;
BEGIN
  SELECT pg_temp.rehearse_integrated_legacy_balance_import(
    '2026-08-15 00:00:00+00'
  ) INTO v_processed;

  SELECT COUNT(*), COALESCE(SUM(granted_amount), 0)::integer
    INTO v_grants, v_sum
  FROM public.credit_grants
  WHERE origin = 'LEGACY_BALANCE'
    AND pg_temp.is_legacy_cutover_fixture_user(user_id);

  IF v_processed <> 30 OR v_grants <> 30 OR v_sum <> 292 THEN
    RAISE EXCEPTION
      'integrated rollback state mismatch: processed %, grants %, sum %',
      v_processed, v_grants, v_sum;
  END IF;
END;
$$;
ROLLBACK;

DO $$
DECLARE
  v_operations integer;
  v_grants integer;
  v_entries integer;
  v_profile_sum integer;
BEGIN
  SELECT COUNT(*) INTO v_operations
  FROM public.credit_operations
  WHERE pg_temp.is_legacy_cutover_fixture_user(user_id);

  SELECT COUNT(*) INTO v_grants
  FROM public.credit_grants
  WHERE pg_temp.is_legacy_cutover_fixture_user(user_id);

  SELECT COUNT(*) INTO v_entries
  FROM public.credit_ledger_entries
  WHERE pg_temp.is_legacy_cutover_fixture_user(user_id);

  SELECT COALESCE(SUM(credits), 0)::integer INTO v_profile_sum
  FROM public.profiles
  WHERE pg_temp.is_legacy_cutover_fixture_user(id)
    AND COALESCE(is_unlimited, false) IS false;

  IF v_operations <> 0 OR v_grants <> 0 OR v_entries <> 0 THEN
    RAISE EXCEPTION
      'integrated rollback leaked governed legacy state: operations %, grants %, entries %',
      v_operations, v_grants, v_entries;
  END IF;

  IF v_profile_sum <> 292 THEN
    RAISE EXCEPTION 'integrated rollback mutated legacy source aggregate: %', v_profile_sum;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 3. Commit and reconcile exactly the 30 finite legacy profiles.
-- -----------------------------------------------------------------------------
BEGIN;
SELECT pg_temp.rehearse_integrated_legacy_balance_import('2026-08-15 00:00:00+00');
COMMIT;

DO $$
DECLARE
  v_operations integer;
  v_grants integer;
  v_entries integer;
  v_grant_sum integer;
  v_credit_sum integer;
  v_expiring integer;
  v_non_legacy integer;
  v_gold_grants integer;
  v_bad_balance integer;
  v_profile_sum integer;
  v_gold_snapshot jsonb;
BEGIN
  SELECT COUNT(*) INTO v_operations
  FROM public.credit_operations
  WHERE operation_kind = 'GRANT'
    AND pg_temp.is_legacy_cutover_fixture_user(user_id);

  SELECT
    COUNT(*),
    COALESCE(SUM(granted_amount), 0)::integer,
    COUNT(*) FILTER (WHERE expires_at IS NOT NULL),
    COUNT(*) FILTER (WHERE origin <> 'LEGACY_BALANCE')
  INTO v_grants, v_grant_sum, v_expiring, v_non_legacy
  FROM public.credit_grants
  WHERE pg_temp.is_legacy_cutover_fixture_user(user_id);

  SELECT COUNT(*), COALESCE(SUM(amount), 0)::integer
    INTO v_entries, v_credit_sum
  FROM public.credit_ledger_entries
  WHERE entry_type = 'CREDIT'
    AND pg_temp.is_legacy_cutover_fixture_user(user_id);

  SELECT COUNT(*) INTO v_gold_grants
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-0000-0000-000000000031';

  SELECT COUNT(*) INTO v_bad_balance
  FROM public.profiles AS p
  WHERE pg_temp.is_legacy_cutover_fixture_user(p.id)
    AND COALESCE(p.is_unlimited, false) IS false
    AND COALESCE(p.credits, 0) > 0
    AND (
      public.credit_balance_snapshot_internal(
        p.id,
        '2026-08-15 00:00:00+00'::timestamptz
      )->>'total'
    )::integer <> p.credits;

  SELECT COALESCE(SUM(credits), 0)::integer INTO v_profile_sum
  FROM public.profiles
  WHERE pg_temp.is_legacy_cutover_fixture_user(id)
    AND COALESCE(is_unlimited, false) IS false;

  SELECT public.credit_balance_snapshot_internal(
    '00000000-0000-0000-0000-000000000031',
    '2026-08-15 00:00:00+00'::timestamptz
  ) INTO v_gold_snapshot;

  IF v_operations <> 30 OR v_grants <> 30 OR v_entries <> 30 THEN
    RAISE EXCEPTION
      'integrated committed import cardinality mismatch: operations %, grants %, entries %',
      v_operations, v_grants, v_entries;
  END IF;

  IF v_grant_sum <> 292 OR v_credit_sum <> 292 THEN
    RAISE EXCEPTION
      'integrated committed aggregate mismatch: grants %, ledger %',
      v_grant_sum, v_credit_sum;
  END IF;

  IF v_expiring <> 0 OR v_non_legacy <> 0 THEN
    RAISE EXCEPTION
      'integrated legacy grants shape mismatch: expiring %, non_legacy %',
      v_expiring, v_non_legacy;
  END IF;

  IF v_gold_grants <> 0 THEN
    RAISE EXCEPTION 'integrated rehearsal imported GOLD sentinel as grant';
  END IF;

  IF v_bad_balance <> 0 THEN
    RAISE EXCEPTION 'integrated finite balances do not reconcile with frozen source';
  END IF;

  IF v_profile_sum <> 292 THEN
    RAISE EXCEPTION 'integrated import mutated legacy source aggregate: %', v_profile_sum;
  END IF;

  IF (v_gold_snapshot->>'unlimited')::boolean IS NOT true
     OR (v_gold_snapshot->>'total')::integer <> 0 THEN
    RAISE EXCEPTION 'integrated GOLD snapshot mismatch: %', v_gold_snapshot;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 4. Exact replay remains idempotent even with unrelated governed users present.
-- -----------------------------------------------------------------------------
BEGIN;
SELECT pg_temp.rehearse_integrated_legacy_balance_import('2026-08-15 00:00:00+00');
COMMIT;

DO $$
DECLARE
  v_operations integer;
  v_grants integer;
  v_entries integer;
  v_sum integer;
BEGIN
  SELECT COUNT(*) INTO v_operations
  FROM public.credit_operations
  WHERE pg_temp.is_legacy_cutover_fixture_user(user_id);

  SELECT COUNT(*) INTO v_grants
  FROM public.credit_grants
  WHERE pg_temp.is_legacy_cutover_fixture_user(user_id);

  SELECT COUNT(*), COALESCE(SUM(amount), 0)::integer
    INTO v_entries, v_sum
  FROM public.credit_ledger_entries
  WHERE pg_temp.is_legacy_cutover_fixture_user(user_id);

  IF v_operations <> 30 OR v_grants <> 30 OR v_entries <> 30 OR v_sum <> 292 THEN
    RAISE EXCEPTION
      'integrated exact replay duplicated legacy state: operations %, grants %, entries %, sum %',
      v_operations, v_grants, v_entries, v_sum;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 5. Drift of one already-imported legacy source row must fail closed and roll
--    back without disturbing its committed grant.
-- -----------------------------------------------------------------------------
BEGIN;
UPDATE public.profiles
SET credits = 3
WHERE id = '00000000-0000-0000-0000-000000000030';

DO $$
DECLARE
  v_caught boolean := false;
BEGIN
  BEGIN
    PERFORM pg_temp.rehearse_integrated_legacy_balance_import(
      '2026-08-15 00:00:00+00'
    );
  EXCEPTION
    WHEN SQLSTATE '22023' THEN
      v_caught := true;
  END;

  IF NOT v_caught THEN
    RAISE EXCEPTION 'integrated drifted legacy balance did not fail closed';
  END IF;
END;
$$;
ROLLBACK;

DO $$
DECLARE
  v_source integer;
  v_grant integer;
BEGIN
  SELECT credits INTO v_source
  FROM public.profiles
  WHERE id = '00000000-0000-0000-0000-000000000030';

  SELECT granted_amount INTO v_grant
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-0000-0000-000000000030'
    AND origin = 'LEGACY_BALANCE';

  IF v_source <> 2 OR v_grant <> 2 THEN
    RAISE EXCEPTION
      'integrated drift rollback changed canonical state: source %, grant %',
      v_source, v_grant;
  END IF;
END;
$$;

SELECT 'OK:credit_legacy_balance_integrated_rehearsal_1_3C_5' AS result;
