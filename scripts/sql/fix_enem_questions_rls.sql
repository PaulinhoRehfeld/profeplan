-- ==============================================================================
-- FIX: RLS for enem_questions (enable public read access)
-- Purpose: Allow authenticated users to search ENEM questions
-- Date: 2026-02-11
-- ==============================================================================

-- Enable RLS if not already enabled
ALTER TABLE public.enem_questions ENABLE ROW LEVEL SECURITY;

-- Drop any existing restrictive policies
DROP POLICY IF EXISTS "enem_questions_select" ON public.enem_questions;
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON public.enem_questions;
DROP POLICY IF EXISTS "Allow public read" ON public.enem_questions;
DROP POLICY IF EXISTS "Permitir leitura pública" ON public.enem_questions;
DROP POLICY IF EXISTS "enem_questions_select_authenticated" ON public.enem_questions;

-- CREATE: Allow ALL authenticated users to read enem_questions
CREATE POLICY "enem_questions_select_authenticated" ON public.enem_questions
FOR SELECT TO authenticated
USING (true); -- All authenticated users can see all questions

-- Verification
SELECT 
    schemaname, 
    tablename, 
    policyname, 
    permissive,
    cmd,
    SUBSTRING(qual::text, 1, 100) as using_clause
FROM pg_policies 
WHERE tablename = 'enem_questions'
ORDER BY policyname;
