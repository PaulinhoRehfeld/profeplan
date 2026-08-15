-- =============================================================================
-- ProfePlan — synthetic hosted-shape snapshot for Lote 1.3C.2
-- TEST ONLY. Never a production migration.
--
-- Shape mirrors the aggregate read-only audit captured by 1.3C.1:
--   29 finite FREE users with 10 credits
--    1 finite FREE user with 2 credits
--    1 GOLD/unlimited user with legacy sentinel 9999
--
-- No real user identifiers or PII are present.
-- =============================================================================

INSERT INTO public.profiles (
  id,
  tier,
  credits,
  is_unlimited,
  created_at,
  updated_at
)
SELECT
  ('00000000-0000-0000-0000-' || lpad(gs::text, 12, '0'))::uuid,
  'FREE',
  10,
  false,
  '2026-07-13 00:00:00+00'::timestamptz,
  '2026-08-15 00:00:00+00'::timestamptz
FROM generate_series(1, 29) AS gs;

INSERT INTO public.profiles (
  id,
  tier,
  credits,
  is_unlimited,
  created_at,
  updated_at
) VALUES
  (
    '00000000-0000-0000-0000-000000000030',
    'FREE',
    2,
    false,
    '2026-07-13 00:00:00+00',
    '2026-08-15 00:00:00+00'
  ),
  (
    '00000000-0000-0000-0000-000000000031',
    'GOLD',
    9999,
    true,
    '2026-07-13 00:00:00+00',
    '2026-08-15 00:00:00+00'
  );
