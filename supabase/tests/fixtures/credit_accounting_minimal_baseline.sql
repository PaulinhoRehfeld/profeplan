-- Minimal disposable baseline for Lote 1.3B.1 schema validation.
-- This file is test-only and is never a production migration.

CREATE TABLE public.profiles (
  id uuid PRIMARY KEY,
  tier text NOT NULL DEFAULT 'FREE',
  credits integer NOT NULL DEFAULT 0,
  is_unlimited boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
