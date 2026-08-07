-- =============================================================================
-- ProfePlan Knowledge Factory - minimal disposable baseline for Lote 3A CI
-- NON-PRODUCTION ONLY.
--
-- Purpose:
--   Reproduce only the legacy dependency that the Lote 3A migration is allowed
--   to read: public.profiles, backed by Supabase auth.users.
--
-- This is NOT a production migration and MUST NOT be copied into the canonical
-- supabase/migrations directory. It contains no real data.
-- =============================================================================

CREATE TABLE public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  school_id text,
  full_name text,
  email text,
  role text NOT NULL DEFAULT 'teacher' CHECK (
    role IN ('teacher', 'manager', 'school_manager', 'school_admin', 'admin')
  ),
  tier text NOT NULL DEFAULT 'FREE',
  credits integer NOT NULL DEFAULT 0,
  is_unlimited boolean NOT NULL DEFAULT false,
  is_admin boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- The Knowledge Factory helper is SECURITY DEFINER and reads profiles only to
-- distinguish platform role=admin from school-scoped roles. No broad profile
-- policy is needed in this isolated harness.

REVOKE ALL ON TABLE public.profiles FROM PUBLIC, anon, authenticated;
