-- =============================================================================
-- ProfePlan credit accounting command boundary — Lote 1.3B.2
-- Date: 2026-08-14
-- Scope: governed grant/read commands + private transactional consume primitive
--
-- IMPORTANT:
-- - additive on top of Lote 1.3B.1;
-- - does NOT migrate profiles.credits;
-- - does NOT integrate current frontend/save flows;
-- - does NOT alter Stripe fulfillment;
-- - does NOT authorize or apply production deployment.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Durable consume receipt shape
-- ---------------------------------------------------------------------------
-- A committed consume decision must remember the concrete lot and the balance
-- observed immediately after the decision. This makes replay deterministic even
-- after later economic operations change the current balance.
ALTER TABLE public.credit_operations
  ADD COLUMN consumed_grant_id uuid,
  ADD COLUMN balance_after integer;

ALTER TABLE public.credit_operations
  ADD CONSTRAINT credit_operations_balance_after_check
    CHECK (balance_after IS NULL OR balance_after >= 0),
  ADD CONSTRAINT credit_operations_consume_amount_one_check
    CHECK (operation_kind <> 'CONSUME' OR requested_amount = 1),
  ADD CONSTRAINT credit_operations_consume_receipt_shape_check
    CHECK (
      operation_kind <> 'CONSUME'
      OR (
        outcome = 'APPLIED'
        AND applied_amount = 1
        AND consumed_grant_id IS NOT NULL
        AND balance_after IS NOT NULL
      )
      OR (
        outcome IN ('NO_CHARGE', 'REJECTED')
        AND applied_amount = 0
        AND consumed_grant_id IS NULL
        AND balance_after IS NOT NULL
      )
    ),
  ADD CONSTRAINT credit_operations_grant_has_no_consumed_lot_check
    CHECK (operation_kind <> 'GRANT' OR consumed_grant_id IS NULL),
  ADD CONSTRAINT credit_operations_consumed_grant_fk
    FOREIGN KEY (user_id, consumed_grant_id)
    REFERENCES public.credit_grants(user_id, id)
    ON DELETE RESTRICT;

-- One semantic save consumes at most one credit from one concrete lot.
CREATE UNIQUE INDEX credit_ledger_entries_single_debit_per_operation_idx
  ON public.credit_ledger_entries (operation_id)
  WHERE entry_type = 'DEBIT';

-- Tighten the 1.3B.1 ledger guard so a DEBIT must point to the exact lot stored
-- in the durable operation receipt.
CREATE OR REPLACE FUNCTION public.credit_validate_ledger_entry_insert()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  v_kind text;
  v_outcome text;
  v_applied_amount integer;
  v_consumed_grant_id uuid;
  v_grant_operation_id text;
  v_granted_amount integer;
BEGIN
  SELECT operation_kind, outcome, applied_amount, consumed_grant_id
    INTO v_kind, v_outcome, v_applied_amount, v_consumed_grant_id
  FROM public.credit_operations
  WHERE user_id = NEW.user_id
    AND operation_id = NEW.operation_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'credit ledger operation not found'
      USING ERRCODE = '23503';
  END IF;

  SELECT operation_id, granted_amount
    INTO v_grant_operation_id, v_granted_amount
  FROM public.credit_grants
  WHERE user_id = NEW.user_id
    AND id = NEW.grant_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'credit ledger grant not found for user'
      USING ERRCODE = '23503';
  END IF;

  IF v_outcome <> 'APPLIED' THEN
    RAISE EXCEPTION 'ledger entries require an APPLIED economic operation'
      USING ERRCODE = '23514';
  END IF;

  IF NEW.entry_type = 'CREDIT' THEN
    IF v_kind <> 'GRANT'
       OR NEW.operation_id <> v_grant_operation_id
       OR NEW.amount <> v_granted_amount
       OR NEW.amount <> v_applied_amount THEN
      RAISE EXCEPTION 'CREDIT entry does not match its grant operation'
        USING ERRCODE = '23514';
    END IF;
  ELSE
    IF v_kind <> 'CONSUME'
       OR NEW.amount <> 1
       OR v_applied_amount <> 1
       OR v_consumed_grant_id IS DISTINCT FROM NEW.grant_id THEN
      RAISE EXCEPTION 'DEBIT entry does not match its APPLIED consumption receipt'
        USING ERRCODE = '23514';
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

-- ---------------------------------------------------------------------------
-- 2. Private balance projection
-- ---------------------------------------------------------------------------
-- Current availability is derived from funded ledger entries minus debits.
-- Expired lots and future-dated grants are excluded from availability; their
-- immutable history remains intact.
CREATE OR REPLACE FUNCTION public.credit_balance_snapshot_internal(
  p_user_id uuid,
  p_at timestamptz
)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
DECLARE
  v_tier text;
  v_is_unlimited boolean;
  v_total integer := 0;
  v_free integer := 0;
  v_purchased integer := 0;
  v_bonus integer := 0;
  v_admin integer := 0;
  v_legacy integer := 0;
  v_next_expiry timestamptz;
BEGIN
  SELECT p.tier, p.is_unlimited
    INTO v_tier, v_is_unlimited
  FROM public.profiles AS p
  WHERE p.id = p_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'credit profile not found'
      USING ERRCODE = 'P0002';
  END IF;

  WITH lot_balances AS (
    SELECT
      g.id,
      g.origin,
      g.expires_at,
      COALESCE(
        SUM(
          CASE le.entry_type
            WHEN 'CREDIT' THEN le.amount
            WHEN 'DEBIT' THEN -le.amount
          END
        ),
        0
      )::integer AS remaining
    FROM public.credit_grants AS g
    LEFT JOIN public.credit_ledger_entries AS le
      ON le.user_id = g.user_id
     AND le.grant_id = g.id
    WHERE g.user_id = p_user_id
      AND g.granted_at <= p_at
      AND (g.expires_at IS NULL OR g.expires_at > p_at)
    GROUP BY g.id, g.origin, g.expires_at
  ), eligible AS (
    SELECT *
    FROM lot_balances
    WHERE remaining > 0
  )
  SELECT
    COALESCE(SUM(remaining), 0)::integer,
    COALESCE(SUM(remaining) FILTER (WHERE origin = 'FREE_TRIAL'), 0)::integer,
    COALESCE(SUM(remaining) FILTER (WHERE origin = 'PURCHASED'), 0)::integer,
    COALESCE(SUM(remaining) FILTER (WHERE origin = 'PROMOTIONAL_BONUS'), 0)::integer,
    COALESCE(SUM(remaining) FILTER (WHERE origin = 'ADMIN_ADJUSTMENT'), 0)::integer,
    COALESCE(SUM(remaining) FILTER (WHERE origin = 'LEGACY_BALANCE'), 0)::integer,
    MIN(expires_at) FILTER (WHERE expires_at IS NOT NULL)
  INTO
    v_total,
    v_free,
    v_purchased,
    v_bonus,
    v_admin,
    v_legacy,
    v_next_expiry
  FROM eligible;

  RETURN jsonb_build_object(
    'user_id', p_user_id,
    'tier', v_tier,
    'unlimited', COALESCE(v_is_unlimited, false) OR v_tier = 'GOLD',
    'total', v_total,
    'free_trial', v_free,
    'purchased', v_purchased,
    'promotional_bonus', v_bonus,
    'admin_adjustment', v_admin,
    'legacy_balance', v_legacy,
    'next_expiry', v_next_expiry,
    'as_of', p_at
  );
END;
$$;

-- Authenticated users may read only their own derived balance. No direct table
-- SELECT is granted to the authenticated role.
CREATE OR REPLACE FUNCTION public.credit_get_my_balance()
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
DECLARE
  v_user_id uuid;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authenticated user required'
      USING ERRCODE = '42501';
  END IF;

  RETURN public.credit_balance_snapshot_internal(v_user_id, now());
END;
$$;

-- Service-side integrations may inspect a concrete user's derived balance.
CREATE OR REPLACE FUNCTION public.credit_get_balance_for_user(p_user_id uuid)
RETURNS jsonb
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
  SELECT public.credit_balance_snapshot_internal(p_user_id, now());
$$;

-- ---------------------------------------------------------------------------
-- 3. Governed positive grant command
-- ---------------------------------------------------------------------------
-- Positive producers (FREE onboarding, Stripe, bonus, admin) converge here in
-- later integration sublots. Direct service_role INSERTs are revoked below.
CREATE OR REPLACE FUNCTION public.credit_grant_command(
  p_user_id uuid,
  p_operation_id text,
  p_action_key text,
  p_request_fingerprint text,
  p_grant_key text,
  p_origin text,
  p_amount integer,
  p_granted_at timestamptz,
  p_expires_at timestamptz,
  p_source_reference text,
  p_metadata jsonb DEFAULT '{}'::jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
DECLARE
  v_existing public.credit_operations%ROWTYPE;
  v_existing_grant public.credit_grants%ROWTYPE;
  v_grant_id uuid;
BEGIN
  IF p_user_id IS NULL
     OR p_operation_id IS NULL OR btrim(p_operation_id) = ''
     OR p_action_key IS NULL OR btrim(p_action_key) = ''
     OR p_action_key NOT LIKE 'GRANT\_%' ESCAPE '\'
     OR p_request_fingerprint IS NULL OR btrim(p_request_fingerprint) = ''
     OR p_grant_key IS NULL OR btrim(p_grant_key) = ''
     OR p_amount IS NULL OR p_amount <= 0
     OR p_granted_at IS NULL
     OR p_metadata IS NULL OR jsonb_typeof(p_metadata) <> 'object' THEN
    RAISE EXCEPTION 'invalid credit grant command'
      USING ERRCODE = '22023';
  END IF;

  IF p_origin NOT IN (
    'FREE_TRIAL',
    'PURCHASED',
    'PROMOTIONAL_BONUS',
    'ADMIN_ADJUSTMENT',
    'LEGACY_BALANCE'
  ) THEN
    RAISE EXCEPTION 'invalid credit grant origin'
      USING ERRCODE = '22023';
  END IF;

  -- Per-user serialization gives grants and consumes one economic ordering.
  PERFORM 1
  FROM public.profiles AS p
  WHERE p.id = p_user_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'credit profile not found'
      USING ERRCODE = 'P0002';
  END IF;

  SELECT *
    INTO v_existing
  FROM public.credit_operations
  WHERE operation_id = p_operation_id;

  IF FOUND THEN
    IF v_existing.user_id IS DISTINCT FROM p_user_id
       OR v_existing.operation_kind <> 'GRANT'
       OR v_existing.action_key IS DISTINCT FROM p_action_key
       OR v_existing.request_fingerprint IS DISTINCT FROM p_request_fingerprint
       OR v_existing.requested_amount IS DISTINCT FROM p_amount THEN
      RAISE EXCEPTION 'operation_id replay payload mismatch'
        USING ERRCODE = '22023';
    END IF;

    SELECT *
      INTO v_existing_grant
    FROM public.credit_grants
    WHERE user_id = p_user_id
      AND operation_id = p_operation_id;

    IF NOT FOUND
       OR v_existing_grant.grant_key IS DISTINCT FROM p_grant_key
       OR v_existing_grant.origin IS DISTINCT FROM p_origin
       OR v_existing_grant.granted_amount IS DISTINCT FROM p_amount
       OR v_existing_grant.granted_at IS DISTINCT FROM p_granted_at
       OR v_existing_grant.expires_at IS DISTINCT FROM p_expires_at
       OR v_existing_grant.source_reference IS DISTINCT FROM p_source_reference THEN
      RAISE EXCEPTION 'grant replay payload mismatch'
        USING ERRCODE = '22023';
    END IF;

    RETURN jsonb_build_object(
      'operation_id', p_operation_id,
      'outcome', v_existing.outcome,
      'reason', 'REPLAY',
      'original_reason', v_existing.reason_code,
      'replay', true,
      'grant_id', v_existing_grant.id,
      'origin', v_existing_grant.origin,
      'amount', v_existing_grant.granted_amount,
      'expires_at', v_existing_grant.expires_at
    );
  END IF;

  SELECT *
    INTO v_existing_grant
  FROM public.credit_grants
  WHERE grant_key = p_grant_key;

  IF FOUND THEN
    RAISE EXCEPTION 'grant_key already belongs to another operation'
      USING ERRCODE = '23505';
  END IF;

  INSERT INTO public.credit_operations (
    operation_id,
    user_id,
    operation_kind,
    action_key,
    request_fingerprint,
    outcome,
    requested_amount,
    applied_amount,
    reason_code,
    metadata,
    occurred_at
  ) VALUES (
    p_operation_id,
    p_user_id,
    'GRANT',
    p_action_key,
    p_request_fingerprint,
    'APPLIED',
    p_amount,
    p_amount,
    'GRANTED',
    p_metadata || jsonb_build_object('command_version', '1.3B.2'),
    p_granted_at
  );

  INSERT INTO public.credit_grants (
    user_id,
    operation_id,
    grant_key,
    origin,
    granted_amount,
    granted_at,
    expires_at,
    source_reference,
    metadata
  ) VALUES (
    p_user_id,
    p_operation_id,
    p_grant_key,
    p_origin,
    p_amount,
    p_granted_at,
    p_expires_at,
    p_source_reference,
    p_metadata || jsonb_build_object('command_version', '1.3B.2')
  )
  RETURNING id INTO v_grant_id;

  INSERT INTO public.credit_ledger_entries (
    user_id,
    operation_id,
    grant_id,
    entry_type,
    amount,
    metadata,
    occurred_at
  ) VALUES (
    p_user_id,
    p_operation_id,
    v_grant_id,
    'CREDIT',
    p_amount,
    jsonb_build_object('command_version', '1.3B.2'),
    p_granted_at
  );

  RETURN jsonb_build_object(
    'operation_id', p_operation_id,
    'outcome', 'APPLIED',
    'reason', 'GRANTED',
    'replay', false,
    'grant_id', v_grant_id,
    'origin', p_origin,
    'amount', p_amount,
    'expires_at', p_expires_at
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- 4. PRIVATE consume primitive for future business-save RPCs
-- ---------------------------------------------------------------------------
-- Deliberately NOT granted to authenticated, anon OR service_role.
-- A future SECURITY DEFINER business-save command will:
--   1) preallocate artifact id + deterministic operation_id/fingerprint;
--   2) call this primitive inside the same DB transaction;
--   3) on REJECTED, persist no artifact;
--   4) on APPLIED/NO_CHARGE, persist the canonical artifact;
--   5) if artifact persistence fails, the transaction rolls back this receipt
--      and its DEBIT too.
-- This is how the schema enforces "saved = charged" without a standalone debit
-- endpoint that a client could invoke independently.
CREATE OR REPLACE FUNCTION public.credit_consume_internal(
  p_user_id uuid,
  p_operation_id text,
  p_action_key text,
  p_request_fingerprint text,
  p_artifact_type text,
  p_artifact_id text,
  p_metadata jsonb DEFAULT '{}'::jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
DECLARE
  v_existing public.credit_operations%ROWTYPE;
  v_tier text;
  v_is_unlimited boolean;
  v_now timestamptz := now();
  v_snapshot jsonb;
  v_balance_before integer;
  v_balance_after integer;
  v_grant_id uuid;
  v_reason text;
BEGIN
  IF p_user_id IS NULL
     OR p_operation_id IS NULL OR btrim(p_operation_id) = ''
     OR p_action_key IS NULL OR btrim(p_action_key) = ''
     OR p_action_key NOT LIKE 'SAVE\_%' ESCAPE '\'
     OR p_request_fingerprint IS NULL OR btrim(p_request_fingerprint) = ''
     OR p_artifact_type IS NULL OR btrim(p_artifact_type) = ''
     OR p_artifact_id IS NULL OR btrim(p_artifact_id) = ''
     OR p_metadata IS NULL OR jsonb_typeof(p_metadata) <> 'object' THEN
    RAISE EXCEPTION 'invalid credit consume command'
      USING ERRCODE = '22023';
  END IF;

  -- This profile lock is the serialization boundary for ALL credit commands of
  -- one user. Parallel consumes cannot observe the same final eligible credit.
  SELECT p.tier, p.is_unlimited
    INTO v_tier, v_is_unlimited
  FROM public.profiles AS p
  WHERE p.id = p_user_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'credit profile not found'
      USING ERRCODE = 'P0002';
  END IF;

  SELECT *
    INTO v_existing
  FROM public.credit_operations
  WHERE operation_id = p_operation_id;

  IF FOUND THEN
    IF v_existing.user_id IS DISTINCT FROM p_user_id
       OR v_existing.operation_kind <> 'CONSUME'
       OR v_existing.action_key IS DISTINCT FROM p_action_key
       OR v_existing.request_fingerprint IS DISTINCT FROM p_request_fingerprint
       OR v_existing.requested_amount <> 1
       OR v_existing.artifact_type IS DISTINCT FROM p_artifact_type
       OR v_existing.artifact_id IS DISTINCT FROM p_artifact_id THEN
      RAISE EXCEPTION 'operation_id replay payload mismatch'
        USING ERRCODE = '22023';
    END IF;

    RETURN jsonb_build_object(
      'operation_id', p_operation_id,
      'outcome', v_existing.outcome,
      'charged', v_existing.outcome = 'APPLIED',
      'amount', v_existing.applied_amount,
      'reason', 'REPLAY',
      'original_reason', v_existing.reason_code,
      'grant_id_consumed', v_existing.consumed_grant_id,
      'balance_after', v_existing.balance_after,
      'replay', true,
      'artifact_type', v_existing.artifact_type,
      'artifact_id', v_existing.artifact_id
    );
  END IF;

  v_snapshot := public.credit_balance_snapshot_internal(p_user_id, v_now);
  v_balance_before := COALESCE((v_snapshot ->> 'total')::integer, 0);

  IF COALESCE(v_is_unlimited, false) OR v_tier = 'GOLD' THEN
    INSERT INTO public.credit_operations (
      operation_id,
      user_id,
      operation_kind,
      action_key,
      request_fingerprint,
      outcome,
      requested_amount,
      applied_amount,
      reason_code,
      artifact_type,
      artifact_id,
      balance_after,
      metadata,
      occurred_at
    ) VALUES (
      p_operation_id,
      p_user_id,
      'CONSUME',
      p_action_key,
      p_request_fingerprint,
      'NO_CHARGE',
      1,
      0,
      'GOLD_UNLIMITED',
      p_artifact_type,
      p_artifact_id,
      v_balance_before,
      p_metadata || jsonb_build_object('command_version', '1.3B.2'),
      v_now
    );

    RETURN jsonb_build_object(
      'operation_id', p_operation_id,
      'outcome', 'NO_CHARGE',
      'charged', false,
      'amount', 0,
      'reason', 'GOLD_UNLIMITED',
      'grant_id_consumed', NULL,
      'balance_after', v_balance_before,
      'replay', false,
      'artifact_type', p_artifact_type,
      'artifact_id', p_artifact_id
    );
  END IF;

  -- Deterministic lot policy:
  -- 1) valid FREE_TRIAL with nearest expiry;
  -- 2) non-purchased grants (bonus, admin, conservative legacy);
  -- 3) known PURCHASED balance last, preserving bought credits where possible.
  WITH lot_balances AS (
    SELECT
      g.id,
      g.origin,
      g.expires_at,
      g.granted_at,
      COALESCE(
        SUM(
          CASE le.entry_type
            WHEN 'CREDIT' THEN le.amount
            WHEN 'DEBIT' THEN -le.amount
          END
        ),
        0
      )::integer AS remaining
    FROM public.credit_grants AS g
    LEFT JOIN public.credit_ledger_entries AS le
      ON le.user_id = g.user_id
     AND le.grant_id = g.id
    WHERE g.user_id = p_user_id
      AND g.granted_at <= v_now
      AND (g.expires_at IS NULL OR g.expires_at > v_now)
    GROUP BY g.id, g.origin, g.expires_at, g.granted_at
  )
  SELECT lb.id
    INTO v_grant_id
  FROM lot_balances AS lb
  WHERE lb.remaining > 0
  ORDER BY
    CASE lb.origin
      WHEN 'FREE_TRIAL' THEN 0
      WHEN 'PROMOTIONAL_BONUS' THEN 1
      WHEN 'ADMIN_ADJUSTMENT' THEN 2
      WHEN 'LEGACY_BALANCE' THEN 3
      WHEN 'PURCHASED' THEN 4
      ELSE 5
    END,
    CASE WHEN lb.origin = 'FREE_TRIAL' THEN lb.expires_at END ASC NULLS LAST,
    lb.granted_at ASC,
    lb.id ASC
  LIMIT 1;

  IF v_grant_id IS NULL THEN
    INSERT INTO public.credit_operations (
      operation_id,
      user_id,
      operation_kind,
      action_key,
      request_fingerprint,
      outcome,
      requested_amount,
      applied_amount,
      reason_code,
      artifact_type,
      artifact_id,
      balance_after,
      metadata,
      occurred_at
    ) VALUES (
      p_operation_id,
      p_user_id,
      'CONSUME',
      p_action_key,
      p_request_fingerprint,
      'REJECTED',
      1,
      0,
      'INSUFFICIENT_CREDITS',
      p_artifact_type,
      p_artifact_id,
      0,
      p_metadata || jsonb_build_object('command_version', '1.3B.2'),
      v_now
    );

    RETURN jsonb_build_object(
      'operation_id', p_operation_id,
      'outcome', 'REJECTED',
      'charged', false,
      'amount', 0,
      'reason', 'INSUFFICIENT_CREDITS',
      'grant_id_consumed', NULL,
      'balance_after', 0,
      'replay', false,
      'artifact_type', p_artifact_type,
      'artifact_id', p_artifact_id
    );
  END IF;

  v_balance_after := v_balance_before - 1;
  IF v_balance_after < 0 THEN
    RAISE EXCEPTION 'credit anti-overdraft invariant violated'
      USING ERRCODE = '23514';
  END IF;

  INSERT INTO public.credit_operations (
    operation_id,
    user_id,
    operation_kind,
    action_key,
    request_fingerprint,
    outcome,
    requested_amount,
    applied_amount,
    reason_code,
    artifact_type,
    artifact_id,
    consumed_grant_id,
    balance_after,
    metadata,
    occurred_at
  ) VALUES (
    p_operation_id,
    p_user_id,
    'CONSUME',
    p_action_key,
    p_request_fingerprint,
    'APPLIED',
    1,
    1,
    'CHARGED',
    p_artifact_type,
    p_artifact_id,
    v_grant_id,
    v_balance_after,
    p_metadata || jsonb_build_object('command_version', '1.3B.2'),
    v_now
  );

  INSERT INTO public.credit_ledger_entries (
    user_id,
    operation_id,
    grant_id,
    entry_type,
    amount,
    metadata,
    occurred_at
  ) VALUES (
    p_user_id,
    p_operation_id,
    v_grant_id,
    'DEBIT',
    1,
    jsonb_build_object('command_version', '1.3B.2'),
    v_now
  );

  v_reason := 'CHARGED';
  RETURN jsonb_build_object(
    'operation_id', p_operation_id,
    'outcome', 'APPLIED',
    'charged', true,
    'amount', 1,
    'reason', v_reason,
    'grant_id_consumed', v_grant_id,
    'balance_after', v_balance_after,
    'replay', false,
    'artifact_type', p_artifact_type,
    'artifact_id', p_artifact_id
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- 5. Command-boundary permissions
-- ---------------------------------------------------------------------------
-- service_role may inspect accounting tables but can no longer manufacture
-- operations/grants/ledger rows directly. Positive grants use the governed RPC;
-- consumption is private to future transactional business-save functions.
REVOKE INSERT ON TABLE
  public.credit_operations,
  public.credit_grants,
  public.credit_ledger_entries
FROM service_role;

REVOKE ALL ON FUNCTION public.credit_balance_snapshot_internal(uuid, timestamptz)
FROM PUBLIC, anon, authenticated, service_role;
REVOKE ALL ON FUNCTION public.credit_consume_internal(uuid, text, text, text, text, text, jsonb)
FROM PUBLIC, anon, authenticated, service_role;
REVOKE ALL ON FUNCTION public.credit_grant_command(
  uuid, text, text, text, text, text, integer, timestamptz, timestamptz, text, jsonb
)
FROM PUBLIC, anon, authenticated, service_role;
REVOKE ALL ON FUNCTION public.credit_get_my_balance()
FROM PUBLIC, anon, authenticated, service_role;
REVOKE ALL ON FUNCTION public.credit_get_balance_for_user(uuid)
FROM PUBLIC, anon, authenticated, service_role;

GRANT EXECUTE ON FUNCTION public.credit_grant_command(
  uuid, text, text, text, text, text, integer, timestamptz, timestamptz, text, jsonb
) TO service_role;
GRANT EXECUTE ON FUNCTION public.credit_get_balance_for_user(uuid)
TO service_role;
GRANT EXECUTE ON FUNCTION public.credit_get_my_balance()
TO authenticated;

COMMENT ON FUNCTION public.credit_consume_internal(uuid, text, text, text, text, text, jsonb) IS
  'Private 1.3B.2 primitive. Must be called only inside a canonical business-save transaction; never exposed as a standalone client debit RPC.';
COMMENT ON FUNCTION public.credit_grant_command(uuid, text, text, text, text, text, integer, timestamptz, timestamptz, text, jsonb) IS
  'Idempotent service-side positive credit grant command for future FREE/Stripe/bonus/admin integration.';
COMMENT ON FUNCTION public.credit_get_my_balance() IS
  'Authenticated read-only projection of the caller own eligible credit balance.';

COMMIT;
