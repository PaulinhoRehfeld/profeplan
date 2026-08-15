-- =============================================================================
-- ProfePlan — Lote 1.3C.4A synthetic generated-content baseline
-- TEST ONLY. Never a production migration.
-- =============================================================================

CREATE TABLE public.generated_contents (
  id text PRIMARY KEY DEFAULT gen_random_uuid()::text,
  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  type text NOT NULL,
  folder text NOT NULL,
  title text NOT NULL,
  content text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.generated_contents ENABLE ROW LEVEL SECURITY;

CREATE POLICY generated_contents_select_own
ON public.generated_contents
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY generated_contents_insert_own
ON public.generated_contents
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY generated_contents_update_own
ON public.generated_contents
FOR UPDATE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

GRANT SELECT, INSERT, UPDATE ON public.generated_contents TO authenticated;

INSERT INTO public.profiles (id, tier, credits, is_unlimited)
VALUES
  ('00000000-0000-4000-8000-000000000501', 'SILVER', 0, false),
  ('00000000-0000-4000-8000-000000000502', 'FREE', 0, false),
  ('00000000-0000-4000-8000-000000000503', 'GOLD', 0, true),
  ('00000000-0000-4000-8000-000000000504', 'SILVER', 0, false),
  ('00000000-0000-4000-8000-000000000505', 'SILVER', 0, false),
  ('00000000-0000-4000-8000-000000000506', 'SILVER', 0, false);
