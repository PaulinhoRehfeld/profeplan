-- ==============================================================================
-- ⚠️ OBSOLETO — NÃO RODAR CONTRA PRODUÇÃO ⚠️
-- Arquivado em 2026-07-13. Protótipo abandonado de um modelo "school manager"
-- que nunca foi adotado: usa id UUID + inep_code separado + coluna
-- "municipality", incompatível com o schema real de produção
-- (public.schools.id = TEXT = código INEP de 6 dígitos, coluna "city", não
-- "municipality" — ver infra/supabase/migrations/20260124_ensure_schools_structure.sql
-- e 20260124_import_schools_mg_PROD.sql, que são a fonte de verdade real).
--
-- O DROP TABLE ... CASCADE abaixo apagaria a tabela schools de produção e
-- tudo que referencia ela por FK (teacher_schools, school_students,
-- pdi_records, term_plans). Mantido só para histórico — ver
-- scripts/sql/README_SCHOOLS_SCHEMA.md.
-- ==============================================================================

-- STEP 1: SCHOOL MANAGER DATA MODEL

-- 1. Reset Schools Table (To ensure correct types)
DROP TABLE IF EXISTS public.schools CASCADE;

-- 2. Create the schools table
-- We use UUID for the internal primary key and store the INEP code separately.
CREATE TABLE public.schools (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    inep_code TEXT UNIQUE NOT NULL, -- O código do governo (INEP)
    name TEXT NOT NULL,
    municipality TEXT, -- Adicionado para facilitar filtros futuros (Ex: Capelinha)
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Create the type ENUM for user roles
-- Using a DO block to prevent errors if the type already exists
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN
        CREATE TYPE user_role AS ENUM ('teacher', 'manager');
    END IF;
END $$;

-- 3. Update the profiles table
-- Adding role and school_id. 
-- Note: 'teacher' is the default to maintain legacy compatibility.
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS role user_role DEFAULT 'teacher' NOT NULL,
ADD COLUMN IF NOT EXISTS school_id UUID REFERENCES public.schools(id);

-- 4. Enable RLS and create Manager Access Policy
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Policy: Managers can view profiles (colleagues) from their same school
-- This requires the manager to have the same school_id as the target profile
CREATE POLICY "Managers can view school colleagues" ON public.profiles
FOR SELECT
USING (
  auth.uid() IN (
    SELECT id FROM public.profiles 
    WHERE role = 'manager' AND school_id = public.profiles.school_id
  )
);
