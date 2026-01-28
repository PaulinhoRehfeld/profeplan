-- ==============================================================================
-- FIX: SCHOOLS RLS (500 Error) & PROFILE CONFLICTS (409/Recursion)
-- ==============================================================================

BEGIN;

-- 1. FIX SCHOOLS ACCESS (Fixes "Erro ao carregar lista de escolas")
-- Allow everyone to read schools (Safe Public Data)
DROP POLICY IF EXISTS "Schools viewable by all" ON public.schools;
DROP POLICY IF EXISTS "Enable read access for all users" ON public.schools;
ALTER TABLE public.schools ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Schools viewable by all" 
ON public.schools FOR SELECT 
TO authenticated, anon 
USING (true);

-- 2. REMOVE CONFLICTING TRIGGERS (Fixes 409 Conflict / Recursion)
-- These triggers likely try to do "magic" that conflicts with the App's logic.
DROP TRIGGER IF EXISTS on_auth_user_role_check ON public.profiles;
DROP TRIGGER IF EXISTS check_manager_email ON public.profiles;
DROP TRIGGER IF EXISTS before_profile_insert_auto_assign ON public.profiles;

-- 3. FIX PROFILES RLS RECURSION (Double Check)
-- Ensure Admins can CRUD without triggering recursive checks
DROP POLICY IF EXISTS "Admins Power Access" ON public.profiles;

CREATE POLICY "Admins Power Access"
ON public.profiles
FOR ALL
TO authenticated
USING (
  -- Simple, non-recursive Admin Check using JWT
  (auth.jwt() ->> 'email') IN (SELECT email FROM public.authorized_users WHERE role IN ('ADMIN', 'admin'))
  OR
  (auth.jwt() ->> 'email') IN ('prehfeld@hotmail.com', 'paulo.rehfeld@educacao.mg.gov.br')
  OR
  is_admin = true -- Be careful with this one, can be recursive if not careful.
);

-- Simplify "Users can see own profile" to be dead simple
DROP POLICY IF EXISTS "Users can see own profile" ON public.profiles;
CREATE POLICY "Users can see own profile"
ON public.profiles FOR SELECT
TO authenticated
USING (
  id = auth.uid() OR email = (auth.jwt() ->> 'email')
);

COMMIT;
