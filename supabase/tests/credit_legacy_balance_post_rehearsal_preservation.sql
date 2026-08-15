-- =============================================================================
-- ProfePlan — Lote 1.3C.6 LEGACY_BALANCE post-rehearsal preservation
-- DISPOSABLE SUPABASE ONLY.
--
-- Reconstructs the original finite frozen cohort from immutable LEGACY_BALANCE
-- grants instead of re-reading public.profiles, because rollback rehearsals
-- deliberately create additional synthetic profiles after the cutover import.
-- =============================================================================
\set ON_ERROR_STOP on

CREATE TEMP TABLE credit_cutover_preservation_params (
  cutover_id text NOT NULL CHECK (btrim(cutover_id) <> ''),
  expected_finite_count integer NOT NULL CHECK (expected_finite_count >= 0),
  expected_finite_sum integer NOT NULL CHECK (expected_finite_sum >= 0),
  expected_finite_hash text NOT NULL CHECK (btrim(expected_finite_hash) <> ''),
  expected_unlimited_count integer NOT NULL CHECK (expected_unlimited_count >= 0),
  expected_unlimited_hash text NOT NULL CHECK (btrim(expected_unlimited_hash) <> '')
) ON COMMIT DROP;

BEGIN;

INSERT INTO credit_cutover_preservation_params VALUES (
  :'cutover_id',
  :expected_finite_count,
  :expected_finite_sum,
  :'expected_finite_hash',
  :expected_unlimited_count,
  :'expected_unlimited_hash'
);

DO $$
DECLARE
  v_expected credit_cutover_preservation_params%ROWTYPE;
  v_grant_count integer;
  v_distinct_users integer;
  v_grant_sum integer;
  v_reconstructed_hash text;
  v_ledger_count integer;
  v_ledger_sum integer;
  v_bad_metadata integer;
  v_bad_expiry integer;
  v_foreign_legacy integer;
  v_unlimited_grants integer;
BEGIN
  SELECT * INTO v_expected FROM credit_cutover_preservation_params;

  SELECT
    COUNT(*)::integer,
    COUNT(DISTINCT g.user_id)::integer,
    COALESCE(SUM(g.granted_amount), 0)::integer,
    md5(COALESCE(
      string_agg(g.user_id::text || ':' || g.granted_amount::text, '|' ORDER BY g.user_id),
      ''
    ))
  INTO v_grant_count, v_distinct_users, v_grant_sum, v_reconstructed_hash
  FROM public.credit_grants AS g
  WHERE g.origin = 'LEGACY_BALANCE'
    AND g.metadata->>'cutover_id' = v_expected.cutover_id;

  SELECT
    COUNT(*)::integer,
    COALESCE(SUM(le.amount), 0)::integer
  INTO v_ledger_count, v_ledger_sum
  FROM public.credit_ledger_entries AS le
  JOIN public.credit_grants AS g
    ON g.id = le.grant_id
   AND g.user_id = le.user_id
  WHERE g.origin = 'LEGACY_BALANCE'
    AND g.metadata->>'cutover_id' = v_expected.cutover_id
    AND le.entry_type = 'CREDIT';

  SELECT COUNT(*)::integer INTO v_bad_metadata
  FROM public.credit_grants AS g
  WHERE g.origin = 'LEGACY_BALANCE'
    AND g.metadata->>'cutover_id' = v_expected.cutover_id
    AND (
      g.metadata->>'cutover_version' IS DISTINCT FROM '1.3C.6-v1'
      OR g.metadata->>'source' IS DISTINCT FROM 'profiles.credits'
      OR g.metadata->>'source_finite_hash' IS DISTINCT FROM v_expected.expected_finite_hash
      OR g.metadata->>'source_unlimited_hash' IS DISTINCT FROM v_expected.expected_unlimited_hash
    );

  SELECT COUNT(*)::integer INTO v_bad_expiry
  FROM public.credit_grants AS g
  WHERE g.origin = 'LEGACY_BALANCE'
    AND g.metadata->>'cutover_id' = v_expected.cutover_id
    AND g.expires_at IS NOT NULL;

  SELECT COUNT(*)::integer INTO v_foreign_legacy
  FROM public.credit_grants AS g
  WHERE g.origin = 'LEGACY_BALANCE'
    AND COALESCE(g.metadata->>'cutover_id', '') <> v_expected.cutover_id;

  SELECT COUNT(*)::integer INTO v_unlimited_grants
  FROM public.credit_grants AS g
  JOIN public.profiles AS p ON p.id = g.user_id
  WHERE g.origin = 'LEGACY_BALANCE'
    AND g.metadata->>'cutover_id' = v_expected.cutover_id
    AND (COALESCE(p.is_unlimited, false) = true OR p.tier = 'GOLD');

  IF v_grant_count <> v_expected.expected_finite_count
     OR v_distinct_users <> v_expected.expected_finite_count
     OR v_grant_sum <> v_expected.expected_finite_sum
     OR v_reconstructed_hash IS DISTINCT FROM v_expected.expected_finite_hash
     OR v_ledger_count <> v_expected.expected_finite_count
     OR v_ledger_sum <> v_expected.expected_finite_sum
     OR v_bad_metadata <> 0
     OR v_bad_expiry <> 0
     OR v_foreign_legacy <> 0
     OR v_unlimited_grants <> 0 THEN
    RAISE EXCEPTION
      'LEGACY_BALANCE preservation failed: grants %, users %, sum %, hash %, ledger %/%, bad metadata %, bad expiry %, foreign %, unlimited grants %',
      v_grant_count,
      v_distinct_users,
      v_grant_sum,
      v_reconstructed_hash,
      v_ledger_count,
      v_ledger_sum,
      v_bad_metadata,
      v_bad_expiry,
      v_foreign_legacy,
      v_unlimited_grants
      USING ERRCODE = '23514';
  END IF;
END;
$$;

COMMIT;

SELECT 'OK:credit_legacy_balance_post_rehearsal_preservation_1_3C_6' AS result;
