-- =============================================================================
-- ProfePlan credit accounting foundation — Lote 1.3B.1
-- Date: 2026-08-14
-- Scope: append-only accounting schema + constraints + least-privilege grants
--
-- IMPORTANT:
-- - additive only;
-- - does NOT migrate profiles.credits;
-- - does NOT create consumption/grant RPCs;
-- - does NOT alter Stripe fulfillment;
-- - does NOT authorize or apply production deployment.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Economic command envelope
-- ---------------------------------------------------------------------------
-- One semantic command is identified by operation_id. Replays reuse the same
-- operation_id; 1.3B.2 will own the transactional decision/replay behavior.
CREATE TABLE public.credit_operations (
  operation_id text PRIMARY KEY CHECK (btrim(operation_id) <> ''),
  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  operation_kind text NOT NULL CHECK (operation_kind IN ('GRANT', 'CONSUME')),
  action_key text NOT NULL CHECK (btrim(action_key) <> ''),
  request_fingerprint text NOT NULL CHECK (btrim(request_fingerprint) <> ''),
  outcome text NOT NULL CHECK (outcome IN ('APPLIED', 'NO_CHARGE', 'REJECTED')),
  requested_amount integer NOT NULL CHECK (requested_amount > 0),
  applied_amount integer NOT NULL CHECK (applied_amount >= 0),
  reason_code text CHECK (reason_code IS NULL OR btrim(reason_code) <> ''),
  artifact_type text CHECK (artifact_type IS NULL OR btrim(artifact_type) <> ''),
  artifact_id text CHECK (artifact_id IS NULL OR btrim(artifact_id) <> ''),
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(metadata) = 'object'),
  occurred_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT credit_operations_user_operation_key UNIQUE (user_id, operation_id),
  CONSTRAINT credit_operations_amount_check CHECK (applied_amount <= requested_amount),
  CONSTRAINT credit_operations_outcome_amount_check CHECK (
    (outcome = 'APPLIED' AND applied_amount = requested_amount)
    OR (outcome IN ('NO_CHARGE', 'REJECTED') AND applied_amount = 0)
  ),
  CONSTRAINT credit_operations_grant_outcome_check CHECK (
    operation_kind <> 'GRANT'
    OR (outcome = 'APPLIED' AND applied_amount = requested_amount)
  )
);

CREATE INDEX credit_operations_user_occurred_idx
  ON public.credit_operations (user_id, occurred_at DESC);
CREATE INDEX credit_operations_action_idx
  ON public.credit_operations (action_key, occurred_at DESC);

-- ---------------------------------------------------------------------------
-- 2. Credit grants / lots
-- ---------------------------------------------------------------------------
-- granted_amount is immutable lot capacity. Availability is derived from
-- CREDIT/DEBIT ledger entries and expiry, never from a mutable remaining field.
CREATE TABLE public.credit_grants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  operation_id text NOT NULL,
  grant_key text NOT NULL UNIQUE CHECK (btrim(grant_key) <> ''),
  origin text NOT NULL CHECK (
    origin IN (
      'FREE_TRIAL',
      'PURCHASED',
      'PROMOTIONAL_BONUS',
      'ADMIN_ADJUSTMENT',
      'LEGACY_BALANCE'
    )
  ),
  granted_amount integer NOT NULL CHECK (granted_amount > 0),
  granted_at timestamptz NOT NULL DEFAULT now(),
  expires_at timestamptz,
  source_reference text CHECK (source_reference IS NULL OR btrim(source_reference) <> ''),
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(metadata) = 'object'),
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT credit_grants_user_id_id_key UNIQUE (user_id, id),
  CONSTRAINT credit_grants_operation_fk
    FOREIGN KEY (user_id, operation_id)
    REFERENCES public.credit_operations(user_id, operation_id)
    ON DELETE CASCADE,
  CONSTRAINT credit_grants_expiry_window_check CHECK (
    expires_at IS NULL OR expires_at > granted_at
  ),
  CONSTRAINT credit_grants_free_trial_expiry_check CHECK (
    origin <> 'FREE_TRIAL' OR expires_at IS NOT NULL
  ),
  CONSTRAINT credit_grants_nonexpiring_origin_check CHECK (
    origin NOT IN ('PURCHASED', 'LEGACY_BALANCE') OR expires_at IS NULL
  )
);

CREATE INDEX credit_grants_user_expiry_idx
  ON public.credit_grants (user_id, expires_at, granted_at, id);
CREATE INDEX credit_grants_user_origin_idx
  ON public.credit_grants (user_id, origin, granted_at DESC);
CREATE UNIQUE INDEX credit_grants_single_free_trial_per_user_idx
  ON public.credit_grants (user_id)
  WHERE origin = 'FREE_TRIAL';

-- ---------------------------------------------------------------------------
-- 3. Append-only ledger entries
-- ---------------------------------------------------------------------------
-- A CREDIT entry establishes a grant's funded amount. DEBIT entries allocate
-- a semantic consumption operation against a concrete grant/lot.
CREATE TABLE public.credit_ledger_entries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  operation_id text NOT NULL,
  grant_id uuid NOT NULL,
  entry_type text NOT NULL CHECK (entry_type IN ('CREDIT', 'DEBIT')),
  amount integer NOT NULL CHECK (amount > 0),
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(metadata) = 'object'),
  occurred_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT credit_ledger_entries_operation_fk
    FOREIGN KEY (user_id, operation_id)
    REFERENCES public.credit_operations(user_id, operation_id)
    ON DELETE CASCADE,
  CONSTRAINT credit_ledger_entries_grant_fk
    FOREIGN KEY (user_id, grant_id)
    REFERENCES public.credit_grants(user_id, id)
    ON DELETE CASCADE,
  CONSTRAINT credit_ledger_entries_operation_grant_type_key
    UNIQUE (operation_id, grant_id, entry_type)
);

CREATE INDEX credit_ledger_entries_user_occurred_idx
  ON public.credit_ledger_entries (user_id, occurred_at DESC);
CREATE INDEX credit_ledger_entries_grant_idx
  ON public.credit_ledger_entries (grant_id, occurred_at, id);
CREATE UNIQUE INDEX credit_ledger_entries_single_credit_per_grant_idx
  ON public.credit_ledger_entries (grant_id)
  WHERE entry_type = 'CREDIT';

-- ---------------------------------------------------------------------------
-- 4. RLS + least privilege
-- ---------------------------------------------------------------------------
-- No direct authenticated/anon policy exists in 1.3B.1. User-facing balance
-- and command access will be introduced through governed RPCs in 1.3B.2.
ALTER TABLE public.credit_operations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.credit_grants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.credit_ledger_entries ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE
  public.credit_operations,
  public.credit_grants,
  public.credit_ledger_entries
FROM PUBLIC, anon, authenticated;

-- Application accounting is append-only at the service role boundary.
-- No UPDATE or DELETE is granted.
GRANT SELECT, INSERT ON TABLE
  public.credit_operations,
  public.credit_grants,
  public.credit_ledger_entries
TO service_role;

COMMENT ON TABLE public.credit_operations IS
  'Idempotent economic command receipts for ProfePlan credits. Append-only to application roles.';
COMMENT ON TABLE public.credit_grants IS
  'Credit lots with explicit provenance and expiry policy. No mutable remaining balance.';
COMMENT ON TABLE public.credit_ledger_entries IS
  'Append-only credit/debit allocations linking economic operations to concrete credit grants.';
COMMENT ON COLUMN public.credit_grants.grant_key IS
  'Stable producer idempotency key, e.g. free-trial:<user>, stripe:<event>, referral:<id>.';
COMMENT ON COLUMN public.credit_operations.request_fingerprint IS
  'Deterministic fingerprint used by 1.3B.2 to reject operation_id reuse with altered payload.';

COMMIT;
