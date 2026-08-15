-- Disposable supplemental baseline for Lote 1.3B.3 only.
-- Loaded after credit_accounting_minimal_baseline.sql; never a production migration.

CREATE TABLE public.term_plans (
  id text PRIMARY KEY,
  user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
  title text,
  period integer,
  regime text,
  subject text,
  grade text,
  level text,
  workload_weekly integer,
  reserves jsonb,
  total_classes integer,
  grading_grid jsonb,
  state_base text,
  education_sphere text,
  generated_text text,
  lessons jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.term_plans ENABLE ROW LEVEL SECURITY;

CREATE POLICY term_plans_select_own
ON public.term_plans
FOR SELECT
TO authenticated
USING (user_id = auth.uid());

CREATE POLICY term_plans_insert_own
ON public.term_plans
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

CREATE POLICY term_plans_update_own
ON public.term_plans
FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY term_plans_delete_own
ON public.term_plans
FOR DELETE
TO authenticated
USING (user_id = auth.uid());
