-- =============================================================================
-- ProfePlan — Lote 1.3C.6 read-only legacy balance snapshot
--
-- READ ONLY. Produces aggregate/fingerprint evidence without exposing profile
-- identities. Run immediately before freeze and again after freeze begins.
-- =============================================================================
\set ON_ERROR_STOP on

WITH finite AS (
  SELECT id, credits
  FROM public.profiles
  WHERE COALESCE(is_unlimited, false) = false
    AND tier IS DISTINCT FROM 'GOLD'
    AND COALESCE(credits, 0) > 0
), unlimited AS (
  SELECT id, credits
  FROM public.profiles
  WHERE COALESCE(is_unlimited, false) = true
     OR tier = 'GOLD'
)
SELECT
  COUNT(*)::integer AS finite_count,
  COALESCE(SUM(credits), 0)::integer AS finite_sum,
  md5(COALESCE(string_agg(id::text || ':' || credits::text, '|' ORDER BY id), '')) AS finite_hash,
  (SELECT COUNT(*)::integer FROM unlimited) AS unlimited_count,
  (SELECT md5(COALESCE(string_agg(id::text || ':' || credits::text, '|' ORDER BY id), '')) FROM unlimited) AS unlimited_hash
FROM finite;
