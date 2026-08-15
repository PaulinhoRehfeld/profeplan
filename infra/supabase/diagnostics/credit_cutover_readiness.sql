-- =============================================================================
-- ProfePlan — Credit Cutover Readiness Diagnostic
-- Lote 1.3C.1
--
-- READ ONLY by construction.
-- No PII rows are selected. Outputs are aggregate/object metadata only.
-- Intended for preflight/audit, never for applying cutover changes.
-- =============================================================================

BEGIN READ ONLY;

-- -----------------------------------------------------------------------------
-- 1. Governed ledger objects currently present
-- -----------------------------------------------------------------------------
-- Function presence is discovered by namespace/name instead of an exact
-- argument signature. Readiness must tolerate signature evolution while still
-- making absence/presence explicit; later cutover gates inspect exact arguments.
SELECT
  to_regclass('public.credit_operations') IS NOT NULL AS has_credit_operations,
  to_regclass('public.credit_grants') IS NOT NULL AS has_credit_grants,
  to_regclass('public.credit_ledger_entries') IS NOT NULL AS has_credit_ledger_entries,
  EXISTS (
    SELECT 1
    FROM pg_proc AS p
    JOIN pg_namespace AS n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'credit_get_my_balance'
  ) AS has_credit_get_my_balance,
  EXISTS (
    SELECT 1
    FROM pg_proc AS p
    JOIN pg_namespace AS n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'credit_grant_command'
  ) AS has_credit_grant_command;

-- -----------------------------------------------------------------------------
-- 2. Aggregate legacy economic state — no identity columns
-- -----------------------------------------------------------------------------
SELECT
  COUNT(*)::bigint AS profiles_total,
  COUNT(*) FILTER (WHERE tier = 'FREE')::bigint AS free_total,
  COUNT(*) FILTER (WHERE tier = 'SILVER')::bigint AS silver_total,
  COUNT(*) FILTER (WHERE tier = 'GOLD' OR is_unlimited IS TRUE)::bigint AS unlimited_or_gold_total,
  COALESCE(
    SUM(
      CASE
        WHEN COALESCE(is_unlimited, FALSE) IS FALSE
          THEN GREATEST(COALESCE(credits, 0), 0)
        ELSE 0
      END
    ),
    0
  )::bigint AS aggregate_finite_legacy_credits,
  COUNT(*) FILTER (
    WHERE COALESCE(is_unlimited, FALSE) IS FALSE
      AND COALESCE(credits, 0) = 0
  )::bigint AS finite_zero,
  COUNT(*) FILTER (
    WHERE COALESCE(is_unlimited, FALSE) IS FALSE
      AND COALESCE(credits, 0) BETWEEN 1 AND 10
  )::bigint AS finite_1_10,
  COUNT(*) FILTER (
    WHERE COALESCE(is_unlimited, FALSE) IS FALSE
      AND COALESCE(credits, 0) BETWEEN 11 AND 40
  )::bigint AS finite_11_40,
  COUNT(*) FILTER (
    WHERE COALESCE(is_unlimited, FALSE) IS FALSE
      AND COALESCE(credits, 0) > 40
  )::bigint AS finite_over_40
FROM public.profiles;

-- Distribution without user identity.
SELECT
  tier,
  COALESCE(is_unlimited, FALSE) AS is_unlimited,
  credits,
  COUNT(*)::bigint AS users
FROM public.profiles
GROUP BY tier, COALESCE(is_unlimited, FALSE), credits
ORDER BY tier, is_unlimited, credits;

-- -----------------------------------------------------------------------------
-- 3. Positive-producer evidence that can affect provenance
-- -----------------------------------------------------------------------------
SELECT
  (phone IS NOT NULL) AS has_phone,
  tier,
  COALESCE(is_unlimited, FALSE) AS is_unlimited,
  credits,
  COUNT(*)::bigint AS users
FROM public.profiles
GROUP BY (phone IS NOT NULL), tier, COALESCE(is_unlimited, FALSE), credits
ORDER BY has_phone DESC, tier, credits;

SELECT
  CASE
    WHEN to_regclass('public.referrals') IS NOT NULL
      THEN (SELECT COUNT(*) FROM public.referrals WHERE status = 'completed')
    ELSE 0
  END::bigint AS completed_referrals,
  CASE
    WHEN to_regclass('public.referrals') IS NOT NULL
      THEN (SELECT COUNT(*) FROM public.referrals WHERE status = 'pending')
    ELSE 0
  END::bigint AS pending_referrals;

SELECT
  CASE
    WHEN to_regclass('public.stripe_webhook_events') IS NOT NULL
      THEN (SELECT COUNT(*) FROM public.stripe_webhook_events)
    ELSE 0
  END::bigint AS stripe_events_total,
  CASE
    WHEN to_regclass('public.stripe_webhook_events') IS NOT NULL
      THEN (
        SELECT COUNT(*)
        FROM public.stripe_webhook_events
        WHERE status = 'processed' AND plan = 'SILVER'
      )
    ELSE 0
  END::bigint AS processed_silver_events,
  CASE
    WHEN to_regclass('public.stripe_webhook_events') IS NOT NULL
      THEN (
        SELECT COUNT(*)
        FROM public.stripe_webhook_events
        WHERE status = 'processed' AND plan = 'GOLD'
      )
    ELSE 0
  END::bigint AS processed_gold_events,
  CASE
    WHEN to_regclass('public.stripe_webhook_events') IS NOT NULL
      THEN (
        SELECT COUNT(*)
        FROM public.stripe_webhook_events
        WHERE status = 'pending_identity'
      )
    ELSE 0
  END::bigint AS pending_identity_events,
  CASE
    WHEN to_regclass('public.stripe_webhook_events') IS NOT NULL
      THEN (
        SELECT COUNT(*)
        FROM public.stripe_webhook_events
        WHERE status = 'failed'
      )
    ELSE 0
  END::bigint AS failed_events;

-- -----------------------------------------------------------------------------
-- 4. Planejamento Trimestral — volume and direct-write bypass metadata
-- -----------------------------------------------------------------------------
SELECT
  COUNT(*)::bigint AS term_plans_total,
  COUNT(DISTINCT user_id)::bigint AS term_plan_users,
  MAX(COALESCE(updated_at, created_at)) AS term_plans_last_activity
FROM public.term_plans;

SELECT
  CASE
    WHEN to_regclass('public.generated_contents') IS NOT NULL
      THEN (
        SELECT COUNT(*)
        FROM public.generated_contents
        WHERE type = 'trimestral'
      )
    ELSE 0
  END::bigint AS generated_trimestral_total,
  CASE
    WHEN to_regclass('public.generated_contents') IS NOT NULL
      THEN (
        SELECT MAX(created_at)
        FROM public.generated_contents
        WHERE type = 'trimestral'
      )
    ELSE NULL
  END AS generated_trimestral_last_create;

SELECT
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'term_plans'
ORDER BY policyname;

SELECT
  grantee,
  privilege_type
FROM information_schema.role_table_grants
WHERE table_schema = 'public'
  AND table_name = 'term_plans'
  AND grantee IN ('anon', 'authenticated', 'service_role')
ORDER BY grantee, privilege_type;

-- -----------------------------------------------------------------------------
-- 5. Relevant hosted functions — presence only, no secrets/data
-- -----------------------------------------------------------------------------
SELECT
  EXISTS (
    SELECT 1
    FROM pg_proc AS p
    JOIN pg_namespace AS n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'handle_new_user'
  ) AS has_handle_new_user,
  EXISTS (
    SELECT 1
    FROM pg_proc AS p
    JOIN pg_namespace AS n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'admin_add_credits'
  ) AS has_admin_add_credits,
  EXISTS (
    SELECT 1
    FROM pg_proc AS p
    JOIN pg_namespace AS n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'process_stripe_checkout_event'
  ) AS has_process_stripe_checkout_event;

-- -----------------------------------------------------------------------------
-- 6. Supabase migration registry snapshot.
-- IMPORTANT: this registry may be incomplete relative to actual hosted objects.
-- Always pair this result with the object introspection above.
-- -----------------------------------------------------------------------------
SELECT version, name
FROM supabase_migrations.schema_migrations
ORDER BY version DESC
LIMIT 50;

ROLLBACK;
