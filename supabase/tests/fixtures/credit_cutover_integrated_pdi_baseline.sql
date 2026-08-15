-- =============================================================================
-- ProfePlan — Lote 1.3C.5 integrated cutover PDI baseline
-- TEST ONLY. Never a production migration.
--
-- Loaded after the existing accounting / producer / term-plan / generated-content
-- synthetic baselines. It deliberately avoids redefining profile columns already
-- supplied by the 1.3C.3 baseline.
-- =============================================================================

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS school_id text;

CREATE TABLE public.schools (
  id text PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE public.school_students (
  id uuid PRIMARY KEY,
  school_id text NOT NULL REFERENCES public.schools(id)
);

ALTER TABLE public.school_students
  ADD COLUMN name text NOT NULL DEFAULT 'Synthetic student';

CREATE TABLE public.pdi_documents (
  id uuid PRIMARY KEY,
  student_id uuid NOT NULL REFERENCES public.school_students(id),
  year integer NOT NULL,
  status text NOT NULL DEFAULT 'em_andamento',
  content_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  block_9_content jsonb NOT NULL DEFAULT '[]'::jsonb,
  final_report text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (student_id, year)
);

CREATE TABLE public.pdi_records (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL REFERENCES public.school_students(id),
  school_id text NOT NULL REFERENCES public.schools(id),
  teacher_id uuid NOT NULL REFERENCES public.profiles(id),
  type text NOT NULL,
  pdi_block text,
  title text NOT NULL,
  content jsonb NOT NULL DEFAULT '{}'::jsonb,
  date date NOT NULL DEFAULT current_date,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.school_students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pdi_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pdi_records ENABLE ROW LEVEL SECURITY;

GRANT SELECT ON public.school_students, public.pdi_documents, public.pdi_records
  TO authenticated;
GRANT INSERT, UPDATE ON public.pdi_documents, public.pdi_records
  TO authenticated;

-- Reproduce the legacy direct-write surface observed by the readiness audit so
-- the 1.3C.5 rehearsal can prove that enforcement actually removes a real
-- bypass and that rollback restores it before user traffic is released.
GRANT SELECT, INSERT, UPDATE, DELETE ON public.term_plans TO authenticated;
