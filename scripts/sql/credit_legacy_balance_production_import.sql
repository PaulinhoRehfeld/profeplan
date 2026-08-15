-- =============================================================================
-- ProfePlan — Lote 1.3C.6 production LEGACY_BALANCE import
--
-- VERSIONED OPERATIONAL SCRIPT. DO NOT RUN AGAINST HOSTED PRODUCTION WITHOUT:
-- - explicit material authorization;
-- - active cutover freeze;
-- - a fresh read-only snapshot from credit_legacy_balance_snapshot.sql;
-- - exact -v parameters matching that frozen snapshot.
--
-- Required psql variables:
--   cutover_id             non-empty version/id for this one cutover
--   cutover_at             timestamptz used consistently for every grant
--   expected_finite_count  integer
--   expected_finite_sum    integer
--   expected_finite_hash   md5 from the frozen snapshot
--   expected_unlimited_count integer
--   expected_unlimited_hash  md5 from the frozen snapshot
--
-- Example form (values deliberately illustrative only):
--   psql "$DB" \
--     -v cutover_id='credit-cutover-v1-YYYYMMDDHHMM' \
--     -v cutover_at='YYYY-MM-DD HH:MM:SS+00' \
--     -v expected_finite_count=30 \
--     -v expected_finite_sum=292 \
--     -v expected_finite_hash='...' \
--     -v expected_unlimited_count=1 \
--     -v expected_unlimited_hash='...' \
--     -f scripts/sql/credit_legacy_balance_production_import.sql
--
-- The whole import is one transaction. Any mismatch aborts and rolls back.
-- Exact replay with the same cutover_id + snapshot is safe; a foreign/different
-- LEGACY_BALANCE cutover fails closed.
-- =============================================================================
\set ON_ERROR_STOP on

BEGIN;

CREATE TEMP TABLE credit_cutover_params (
  cutover_id text NOT NULL CHECK (btrim(cutover_id) <> ''),
  cutover_at timestamptz NOT NULL,
  expected_finite_count integer NOT NULL CHECK (expected_finite_count >= 0),
  expected_finite_sum integer NOT NULL CHECK (expected_finite_sum >= 0),
  expected_finite_hash text NOT NULL CHECK (btrim(expected_finite_hash) <> ''),
  expected_unlimited_count integer NOT NULL CHECK (expected_unlimited_count >= 0),
  expected_unlimited_hash text NOT NULL CHECK (btrim(expected_unlimited_hash) <> '')
) ON COMMIT DROP;

INSERT INTO credit_cutover_params VALUES (
  :'cutover_id',
  :'cutover_at'::timestamptz,
  :expected_finite_count,
  :expected_finite_sum,
  :'expected_finite_hash',
  :expected_unlimited_count,
  :'expected_unlimited_hash'
);

-- Lock the source rows first. The freeze must already prevent application-side
-- economic writes; these row locks additionally make this transaction's source
-- snapshot stable while grants are materialized.
SELECT id
FROM public.profiles
WHERE COALESCE(is_unlimited, false) = false
  AND tier IS DISTINCT FROM 'GOLD'
  AND COALESCE(credits, 0) > 0
ORDER BY id
FOR UPDATE;

SELECT id
FROM public.profiles
WHERE COALESCE(is_unlimited, false) = true
   OR tier = 'GOLD'
ORDER BY id
FOR UPDATE;

DO $$
DECLARE
  v_expected credit_cutover_params%ROWTYPE;
  v_finite_count integer;
  v_finite_sum integer;
  v_finite_hash text;
  v_unlimited_count integer;
  v_unlimited_hash text;
  v_foreign_legacy integer;
BEGIN
  SELECT * INTO v_expected FROM credit_cutover_params;

  SELECT
    COUNT(*)::integer,
    COALESCE(SUM(credits), 0)::integer,
    md5(COALESCE(string_agg(id::text || ':' || credits::text, '|' ORDER BY id), ''))
  INTO v_finite_count, v_finite_sum, v_finite_hash
  FROM public.profiles
  WHERE COALESCE(is_unlimited, false) = false
    AND tier IS DISTINCT FROM 'GOLD'
    AND COALESCE(credits, 0) > 0;

  SELECT
    COUNT(*)::integer,
    md5(COALESCE(string_agg(id::text || ':' || credits::text, '|' ORDER BY id), ''))
  INTO v_unlimited_count, v_unlimited_hash
  FROM public.profiles
  WHERE COALESCE(is_unlimited, false) = true
     OR tier = 'GOLD';

  IF v_finite_count IS DISTINCT FROM v_expected.expected_finite_count
     OR v_finite_sum IS DISTINCT FROM v_expected.expected_finite_sum
     OR v_finite_hash IS DISTINCT FROM v_expected.expected_finite_hash
     OR v_unlimited_count IS DISTINCT FROM v_expected.expected_unlimited_count
     OR v_unlimited_hash IS DISTINCT FROM v_expected.expected_unlimited_hash THEN
    RAISE EXCEPTION
      'frozen legacy snapshot mismatch: finite count/sum/hash %/%/%, unlimited count/hash %/%',
      v_finite_count, v_finite_sum, v_finite_hash,
      v_unlimited_count, v_unlimited_hash
      USING ERRCODE = '22023';
  END IF;

  SELECT COUNT(*)::integer INTO v_foreign_legacy
  FROM public.credit_grants AS g
  WHERE g.origin = 'LEGACY_BALANCE'
    AND COALESCE(g.metadata->>'cutover_id', '') <> v_expected.cutover_id;

  IF v_foreign_legacy <> 0 THEN
    RAISE EXCEPTION 'foreign LEGACY_BALANCE cutover already exists: % grants', v_foreign_legacy
      USING ERRCODE = '22023';
  END IF;
END;
$$;

DO $$
DECLARE
  v_params credit_cutover_params%ROWTYPE;
  v_profile record;
BEGIN
  SELECT * INTO v_params FROM credit_cutover_params;

  FOR v_profile IN
    SELECT id, credits
    FROM public.profiles
    WHERE COALESCE(is_unlimited, false) = false
      AND tier IS DISTINCT FROM 'GOLD'
      AND COALESCE(credits, 0) > 0
    ORDER BY id
  LOOP
    PERFORM public.credit_grant_command(
      v_profile.id,
      'legacy-balance-cutover-v1:' || v_params.cutover_id || ':' || v_profile.id::text,
      'GRANT_LEGACY_BALANCE',
      'legacy-balance-cutover-v1:' || v_params.cutover_id || ':' || v_profile.id::text || ':' || v_profile.credits::text,
      'legacy:' || v_params.cutover_id || ':' || v_profile.id::text,
      'LEGACY_BALANCE',
      v_profile.credits,
      v_params.cutover_at,
      NULL,
      'profiles.credits@' || v_params.cutover_id,
      jsonb_build_object(
        'cutover_id', v_params.cutover_id,
        'cutover_version', '1.3C.6-v1',
        'source', 'profiles.credits',
        'source_finite_hash', v_params.expected_finite_hash,
        'source_unlimited_hash', v_params.expected_unlimited_hash
      )
    );
  END LOOP;
END;
$$;

-- Post-import reconciliation. It validates cardinality/aggregate, one exact lot
-- per finite source profile, no Gold/unlimited import, and source immutability.
DO $$
DECLARE
  v_expected credit_cutover_params%ROWTYPE;
  v_grant_count integer;
  v_grant_sum integer;
  v_entry_count integer;
  v_entry_sum integer;
  v_bad_per_user integer;
  v_unlimited_grants integer;
  v_finite_count integer;
  v_finite_sum integer;
  v_finite_hash text;
  v_unlimited_count integer;
  v_unlimited_hash text;
BEGIN
  SELECT * INTO v_expected FROM credit_cutover_params;

  SELECT COUNT(*)::integer, COALESCE(SUM(granted_amount), 0)::integer
    INTO v_grant_count, v_grant_sum
  FROM public.credit_grants
  WHERE origin = 'LEGACY_BALANCE'
    AND metadata->>'cutover_id' = v_expected.cutover_id;

  SELECT COUNT(*)::integer, COALESCE(SUM(le.amount), 0)::integer
    INTO v_entry_count, v_entry_sum
  FROM public.credit_ledger_entries AS le
  JOIN public.credit_grants AS g
    ON g.user_id = le.user_id AND g.id = le.grant_id
  WHERE g.origin = 'LEGACY_BALANCE'
    AND g.metadata->>'cutover_id' = v_expected.cutover_id
    AND le.entry_type = 'CREDIT';

  SELECT COUNT(*)::integer INTO v_bad_per_user
  FROM public.profiles AS p
  LEFT JOIN public.credit_grants AS g
    ON g.user_id = p.id
   AND g.origin = 'LEGACY_BALANCE'
   AND g.metadata->>'cutover_id' = v_expected.cutover_id
  WHERE COALESCE(p.is_unlimited, false) = false
    AND p.tier IS DISTINCT FROM 'GOLD'
    AND COALESCE(p.credits, 0) > 0
    AND (
      g.id IS NULL
      OR g.granted_amount IS DISTINCT FROM p.credits
      OR g.expires_at IS NOT NULL
    );

  SELECT COUNT(*)::integer INTO v_unlimited_grants
  FROM public.credit_grants AS g
  JOIN public.profiles AS p ON p.id = g.user_id
  WHERE g.origin = 'LEGACY_BALANCE'
    AND g.metadata->>'cutover_id' = v_expected.cutover_id
    AND (COALESCE(p.is_unlimited, false) = true OR p.tier = 'GOLD');

  SELECT
    COUNT(*)::integer,
    COALESCE(SUM(credits), 0)::integer,
    md5(COALESCE(string_agg(id::text || ':' || credits::text, '|' ORDER BY id), ''))
  INTO v_finite_count, v_finite_sum, v_finite_hash
  FROM public.profiles
  WHERE COALESCE(is_unlimited, false) = false
    AND tier IS DISTINCT FROM 'GOLD'
    AND COALESCE(credits, 0) > 0;

  SELECT
    COUNT(*)::integer,
    md5(COALESCE(string_agg(id::text || ':' || credits::text, '|' ORDER BY id), ''))
  INTO v_unlimited_count, v_unlimited_hash
  FROM public.profiles
  WHERE COALESCE(is_unlimited, false) = true
     OR tier = 'GOLD';

  IF v_grant_count <> v_expected.expected_finite_count
     OR v_grant_sum <> v_expected.expected_finite_sum
     OR v_entry_count <> v_expected.expected_finite_count
     OR v_entry_sum <> v_expected.expected_finite_sum
     OR v_bad_per_user <> 0
     OR v_unlimited_grants <> 0 THEN
    RAISE EXCEPTION
      'LEGACY_BALANCE reconciliation failed: grants %/%, credits %/%, bad users %, unlimited grants %',
      v_grant_count, v_grant_sum, v_entry_count, v_entry_sum,
      v_bad_per_user, v_unlimited_grants
      USING ERRCODE = '23514';
  END IF;

  IF v_finite_count IS DISTINCT FROM v_expected.expected_finite_count
     OR v_finite_sum IS DISTINCT FROM v_expected.expected_finite_sum
     OR v_finite_hash IS DISTINCT FROM v_expected.expected_finite_hash
     OR v_unlimited_count IS DISTINCT FROM v_expected.expected_unlimited_count
     OR v_unlimited_hash IS DISTINCT FROM v_expected.expected_unlimited_hash THEN
    RAISE EXCEPTION 'profiles.credits snapshot changed during import'
      USING ERRCODE = '40001';
  END IF;
END;
$$;

COMMIT;

SELECT 'OK:credit_legacy_balance_production_import_1_3C_6' AS result;
