-- VERIFY AND FIX SCRIPT (SIMPLIFIED)
-- Run this to fix 500 Errors and 409 Conflicts

BEGIN;

-- 1. FIX SCHOOLS (Public Access)
ALTER TABLE public.schools DISABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Schools viewable by all" ON public.schools;
DROP POLICY IF EXISTS "Public Schools Access" ON public.schools;
ALTER TABLE public.schools ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public Schools Access" ON public.schools FOR SELECT TO authenticated, anon USING (true);

-- 2. DROP CONFLICTING TRIGGERS (To fix Create User error)
DROP TRIGGER IF EXISTS trigger_match_teacher_on_insert ON public.profiles;
DROP TRIGGER IF EXISTS trigger_match_teacher_on_update ON public.profiles;
DROP TRIGGER IF EXISTS check_manager_email ON public.profiles;
DROP TRIGGER IF EXISTS before_profile_insert_auto_assign ON public.profiles;
DROP TRIGGER IF EXISTS on_auth_user_role_check ON public.profiles;

-- 3. FIX PROFILES RLS (Fix Login Loop)
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Admins Power Access" ON public.profiles;
DROP POLICY IF EXISTS "Admin Full Access" ON public.profiles;
DROP POLICY IF EXISTS "Self View" ON public.profiles;
DROP POLICY IF EXISTS "Self Update" ON public.profiles;

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Simple Self View
CREATE POLICY "Self View" ON public.profiles FOR SELECT TO authenticated 
USING ( id = auth.uid() OR email = (auth.jwt() ->> 'email') );

-- Simple Self Update
CREATE POLICY "Self Update" ON public.profiles FOR UPDATE TO authenticated 
USING ( id = auth.uid() );

-- Admin View (Hardcoded for safety)
CREATE POLICY "Admin View" ON public.profiles FOR ALL TO authenticated 
USING ( (auth.jwt() ->> 'email') IN ('prehfeld@hotmail.com', 'paulo.rehfeld@educacao.mg.gov.br') );

COMMIT;
