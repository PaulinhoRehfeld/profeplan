-- ==============================================================================
-- FINAL FIX V2: PERMISSIONS, TRIGGERS, AND RLS CLEANUP (JSON SYNTAX FIXED)
-- ==============================================================================

BEGIN;

-- ------------------------------------------------------------------------------
-- 1. FIX SCHOOLS (Erro 500 ao carregar)
-- ------------------------------------------------------------------------------
-- Reset RLS entirely for schools
ALTER TABLE public.schools DISABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Schools viewable by all" ON public.schools;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.schools;
DROP POLICY IF EXISTS "Public Schools Access" ON public.schools;

-- Re-enable and add simple public access
ALTER TABLE public.schools ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public Schools Access" ON public.schools FOR SELECT TO authenticated, anon USING (true);


-- ------------------------------------------------------------------------------
-- 2. KILL TRIGGERS (Erro 409/500 ao criar usuário)
-- ------------------------------------------------------------------------------
-- These triggers are causing conflicts between App Logic and DB Logic.
DROP TRIGGER IF EXISTS trigger_match_teacher_on_insert ON public.profiles;
DROP TRIGGER IF EXISTS trigger_match_teacher_on_update ON public.profiles;
DROP TRIGGER IF EXISTS check_manager_email ON public.profiles;
DROP TRIGGER IF EXISTS before_profile_insert_auto_assign ON public.profiles;
DROP TRIGGER IF EXISTS on_auth_user_role_check ON public.profiles;


-- ------------------------------------------------------------------------------
-- 3. FIX PROFILES RLS (Infinite Recursion / Login Loop)
-- ------------------------------------------------------------------------------
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Admins Power Access" ON public.profiles;
DROP POLICY IF EXISTS "Admin Full Access" ON public.profiles;
DROP POLICY IF EXISTS "Users can see own profile" ON public.profiles;
DROP POLICY IF EXISTS "Self View" ON public.profiles;

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- A. Users verify themselves (ID match OR Email match for recovery)
CREATE POLICY "Self View" ON public.profiles 
FOR SELECT 
TO authenticated 
USING (
    id = auth.uid() 
    OR 
    email = (auth.jwt() ->> 'email')
);

-- B. User can update own profile
CREATE POLICY "Self Update" ON public.profiles 
FOR UPDATE
TO authenticated 
USING ( id = auth.uid() );

-- C. ADMIN ACCESS (Non-Recursive)
-- Fixed JSON Syntax: Use -> for object extraction, ->> for final text
CREATE POLICY "Admin Full Access" ON public.profiles
FOR ALL 
TO authenticated
USING (
    (auth.jwt() ->> 'email') IN ('prehfeld@hotmail.com', 'paulo.rehfeld@educacao.mg.gov.br')
    OR 
    ((auth.jwt() -> 'user_metadata') ->> 'role') = 'admin'
);

-- ------------------------------------------------------------------------------
-- 4. GRANT PERMISSIONS (Just in case)
-- ------------------------------------------------------------------------------
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon;

COMMIT;
