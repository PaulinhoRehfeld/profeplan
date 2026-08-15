-- =============================================================================
-- ProfePlan — Lote 1.3C.2 legacy balance cutover rehearsal
-- Disposable Supabase only.
--
-- Proves the conservative policy accepted by 1.3C.1:
--   - finite positive profiles become one non-expiring LEGACY_BALANCE grant each;
--   - legacy profiles.credits is not mutated by the import;
--   - unlimited/GOLD sentinel 9999 is not materialized as a grant;
--   - aggregate finite balance is preserved exactly;
--   - one transaction can roll back the whole import;
--   - exact rerun is idempotent/replay-safe;
--   - source drift after a committed cutover fails closed instead of silently
--     changing the already established economic operation.
-- =============================================================================

\set ON_ERROR_STOP on

-- Test-session helper only. pg_temp disappears with this psql session and is
-- never a production object.
CREATE OR REPLACE FUNCTION pg_temp.rehearse_legacy_balance_import(
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
    WHERE COALESCE(is_unlimited, false) IS false
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
        'rehearsal', true
      )
    );

    v_processed := v_processed + 1;
  END LOOP;

  RETURN v_processed;
END;
$$;

-- -----------------------------------------------------------------------------
-- 1. Prove the synthetic fixture actually matches the audited aggregate shape.
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  v_profiles integer;
  v_finite integer;
  v_finite_sum integer;
  v_gold integer;
  v_gold_sentinel integer;
BEGIN
  SELECT COUNT(*) INTO v_profiles FROM public.profiles;
  SELECT COUNT(*) INTO v_finite
  FROM public.profiles
  WHERE COALESCE(is_unlimited, false) IS false;
  SELECT COALESCE(SUM(GREATEST(COALESCE(credits, 0), 0)), 0)::integer
    INTO v_finite_sum
  FROM public.profiles
  WHERE COALESCE(is_unlimited, false) IS false;
  SELECT COUNT(*), MAX(credits)
    INTO v_gold, v_gold_sentinel
  FROM public.profiles
  WHERE tier = 'GOLD' AND is_unlimited IS true;

  IF v_profiles <> 31 THEN
    RAISE EXCEPTION 'fixture profile count mismatch: %', v_profiles;
  END IF;
  IF v_finite <> 30 THEN
    RAISE EXCEPTION 'fixture finite profile count mismatch: %', v_finite;
  END IF;
  IF v_finite_sum <> 292 THEN
    RAISE EXCEPTION 'fixture finite aggregate mismatch: %', v_finite_sum;
  END IF;
  IF v_gold <> 1 OR v_gold_sentinel <> 9999 THEN
    RAISE EXCEPTION 'fixture GOLD sentinel mismatch: count %, sentinel %', v_gold, v_gold_sentinel;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 2. Rollback rehearsal: all 30 grants exist inside the transaction, then none
--    survive ROLLBACK. profiles.credits remains the source snapshot.
-- -----------------------------------------------------------------------------
BEGIN;

DO $$
DECLARE
  v_processed integer;
  v_grants integer;
  v_sum integer;
BEGIN
  SELECT pg_temp.rehearse_legacy_balance_import('2026-08-15 00:00:00+00')
    INTO v_processed;

  SELECT COUNT(*), COALESCE(SUM(granted_amount), 0)::integer
    INTO v_grants, v_sum
  FROM public.credit_grants
  WHERE origin = 'LEGACY_BALANCE';

  IF v_processed <> 30 OR v_grants <> 30 OR v_sum <> 292 THEN
    RAISE EXCEPTION
      'rollback rehearsal did not materialize expected in-transaction state: processed %, grants %, sum %',
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
  SELECT COUNT(*) INTO v_operations FROM public.credit_operations;
  SELECT COUNT(*) INTO v_grants FROM public.credit_grants;
  SELECT COUNT(*) INTO v_entries FROM public.credit_ledger_entries;
  SELECT COALESCE(SUM(credits), 0)::integer INTO v_profile_sum
  FROM public.profiles
  WHERE COALESCE(is_unlimited, false) IS false;

  IF v_operations <> 0 OR v_grants <> 0 OR v_entries <> 0 THEN
    RAISE EXCEPTION
      'rollback leaked governed state: operations %, grants %, entries %',
      v_operations, v_grants, v_entries;
  END IF;

  IF v_profile_sum <> 292 THEN
    RAISE EXCEPTION 'rollback mutated legacy profile balances: %', v_profile_sum;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 3. Commit the exact same import and prove one grant/CREDIT per finite profile.
-- -----------------------------------------------------------------------------
BEGIN;
SELECT pg_temp.rehearse_legacy_balance_import('2026-08-15 00:00:00+00');
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
  WHERE operation_kind = 'GRANT';

  SELECT
    COUNT(*),
    COALESCE(SUM(granted_amount), 0)::integer,
    COUNT(*) FILTER (WHERE expires_at IS NOT NULL),
    COUNT(*) FILTER (WHERE origin <> 'LEGACY_BALANCE')
  INTO v_grants, v_grant_sum, v_expiring, v_non_legacy
  FROM public.credit_grants;

  SELECT COUNT(*), COALESCE(SUM(amount), 0)::integer
    INTO v_entries, v_credit_sum
  FROM public.credit_ledger_entries
  WHERE entry_type = 'CREDIT';

  SELECT COUNT(*) INTO v_gold_grants
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-0000-0000-000000000031';

  SELECT COUNT(*) INTO v_bad_balance
  FROM public.profiles AS p
  WHERE COALESCE(p.is_unlimited, false) IS false
    AND COALESCE(p.credits, 0) > 0
    AND (
      public.credit_balance_snapshot_internal(
        p.id,
        '2026-08-15 00:00:00+00'::timestamptz
      )->>'total'
    )::integer <> p.credits;

  SELECT COALESCE(SUM(credits), 0)::integer INTO v_profile_sum
  FROM public.profiles
  WHERE COALESCE(is_unlimited, false) IS false;

  SELECT public.credit_balance_snapshot_internal(
    '00000000-0000-0000-0000-000000000031',
    '2026-08-15 00:00:00+00'::timestamptz
  ) INTO v_gold_snapshot;

  IF v_operations <> 30 OR v_grants <> 30 OR v_entries <> 30 THEN
    RAISE EXCEPTION
      'committed import cardinality mismatch: operations %, grants %, entries %',
      v_operations, v_grants, v_entries;
  END IF;

  IF v_grant_sum <> 292 OR v_credit_sum <> 292 THEN
    RAISE EXCEPTION
      'committed import aggregate mismatch: grants %, ledger %',
      v_grant_sum, v_credit_sum;
  END IF;

  IF v_expiring <> 0 OR v_non_legacy <> 0 THEN
    RAISE EXCEPTION
      'legacy grants must be non-expiring LEGACY_BALANCE: expiring %, non_legacy %',
      v_expiring, v_non_legacy;
  END IF;

  IF v_gold_grants <> 0 THEN
    RAISE EXCEPTION 'GOLD sentinel was incorrectly imported as a grant';
  END IF;

  IF v_bad_balance <> 0 THEN
    RAISE EXCEPTION 'one or more finite governed balances differ from profiles.credits';
  END IF;

  IF v_profile_sum <> 292 THEN
    RAISE EXCEPTION 'import mutated profiles.credits aggregate: %', v_profile_sum;
  END IF;

  IF (v_gold_snapshot->>'unlimited')::boolean IS NOT true
     OR (v_gold_snapshot->>'total')::integer <> 0 THEN
    RAISE EXCEPTION 'GOLD snapshot must remain unlimited with zero imported sentinel balance: %',
      v_gold_snapshot;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 4. Exact rerun with the same snapshot timestamp is replay-safe.
-- -----------------------------------------------------------------------------
BEGIN;
SELECT pg_temp.rehearse_legacy_balance_import('2026-08-15 00:00:00+00');
COMMIT;

DO $$
DECLARE
  v_operations integer;
  v_grants integer;
  v_entries integer;
  v_sum integer;
BEGIN
  SELECT COUNT(*) INTO v_operations FROM public.credit_operations;
  SELECT COUNT(*) INTO v_grants FROM public.credit_grants;
  SELECT COUNT(*), COALESCE(SUM(amount), 0)::integer
    INTO v_entries, v_sum
  FROM public.credit_ledger_entries;

  IF v_operations <> 30 OR v_grants <> 30 OR v_entries <> 30 OR v_sum <> 292 THEN
    RAISE EXCEPTION
      'exact replay duplicated governed state: operations %, grants %, entries %, sum %',
      v_operations, v_grants, v_entries, v_sum;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 5. Source drift after committed cutover fails closed.
--    Same deterministic operation_id cannot be silently reused with amount 3.
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
    PERFORM pg_temp.rehearse_legacy_balance_import('2026-08-15 00:00:00+00');
  EXCEPTION
    WHEN SQLSTATE '22023' THEN
      v_caught := true;
  END;

  IF NOT v_caught THEN
    RAISE EXCEPTION 'drifted legacy balance did not fail closed';
  END IF;
END;
$$;

ROLLBACK;

DO $$
DECLARE
  v_legacy_credit integer;
  v_grant_amount integer;
BEGIN
  SELECT credits INTO v_legacy_credit
  FROM public.profiles
  WHERE id = '00000000-0000-0000-0000-000000000030';

  SELECT granted_amount INTO v_grant_amount
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-0000-0000-000000000030'
    AND origin = 'LEGACY_BALANCE';

  IF v_legacy_credit <> 2 OR v_grant_amount <> 2 THEN
    RAISE EXCEPTION
      'drift rollback changed canonical rehearsal state: profile %, grant %',
      v_legacy_credit, v_grant_amount;
  END IF;
END;
$$;

SELECT 'OK:credit_legacy_balance_cutover_rehearsal_1_3C_2' AS result;
