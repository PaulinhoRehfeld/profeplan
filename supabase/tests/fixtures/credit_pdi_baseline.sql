-- =============================================================================
-- ProfePlan — Lote 1.3C.4D synthetic PDI baseline
-- TEST ONLY. Never a production migration.
-- =============================================================================

ALTER TABLE public.profiles
  ADD COLUMN school_id text,
  ADD COLUMN role text;

CREATE TABLE public.schools (
  id text PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE public.school_students (
  id uuid PRIMARY KEY,
  school_id text NOT NULL REFERENCES public.schools(id),
  name text NOT NULL
);

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

GRANT SELECT ON public.school_students, public.pdi_documents, public.pdi_records TO authenticated;
GRANT INSERT, UPDATE ON public.pdi_documents, public.pdi_records TO authenticated;

INSERT INTO public.schools (id, name) VALUES
  ('school-a', 'Escola A'),
  ('school-b', 'Escola B');

UPDATE public.profiles
SET school_id = 'school-a', role = 'school_manager'
WHERE id IN (
  '00000000-0000-4000-8000-000000000501',
  '00000000-0000-4000-8000-000000000502',
  '00000000-0000-4000-8000-000000000503',
  '00000000-0000-4000-8000-000000000504',
  '00000000-0000-4000-8000-000000000505'
);

UPDATE public.profiles
SET school_id = 'school-b', role = 'school_manager'
WHERE id = '00000000-0000-4000-8000-000000000506';

INSERT INTO public.school_students (id, school_id, name) VALUES
  ('10000000-0000-4000-8000-000000000501', 'school-a', 'Aluno 501'),
  ('10000000-0000-4000-8000-000000000502', 'school-a', 'Aluno 502'),
  ('10000000-0000-4000-8000-000000000503', 'school-a', 'Aluno 503'),
  ('10000000-0000-4000-8000-000000000504', 'school-a', 'Aluno 504'),
  ('10000000-0000-4000-8000-000000000505', 'school-a', 'Aluno 505'),
  ('10000000-0000-4000-8000-000000000506', 'school-b', 'Aluno 506');

INSERT INTO public.pdi_documents (id, student_id, year) VALUES
  ('20000000-0000-4000-8000-000000000501', '10000000-0000-4000-8000-000000000501', 2026),
  ('20000000-0000-4000-8000-000000000502', '10000000-0000-4000-8000-000000000502', 2026),
  ('20000000-0000-4000-8000-000000000503', '10000000-0000-4000-8000-000000000503', 2026),
  ('20000000-0000-4000-8000-000000000504', '10000000-0000-4000-8000-000000000504', 2026),
  ('20000000-0000-4000-8000-000000000505', '10000000-0000-4000-8000-000000000505', 2026),
  ('20000000-0000-4000-8000-000000000506', '10000000-0000-4000-8000-000000000506', 2026);
