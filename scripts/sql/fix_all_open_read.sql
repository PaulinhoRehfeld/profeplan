-- ==============================================================================
-- UNBLOCK ALL: OPEN READ ACCESS
-- ==============================================================================
-- Strategy:
-- 1. Schools: Public Read.
-- 2. Profiles: Public Read (Solves Recursion).
-- 3. Profiles: Secure Write (Owner Only).

BEGIN;

-- 1. SCHOOLS
ALTER TABLE public.schools ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public Schools Access" ON public.schools;
DROP POLICY IF EXISTS "Schools viewable by all" ON public.schools;

CREATE POLICY "Public Schools Read" ON public.schools FOR SELECT TO public USING (true);

-- 2. PROFILES
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
-- Drop all existing complex policies
DROP POLICY IF EXISTS "Admins Power Access" ON public.profiles;
DROP POLICY IF EXISTS "Admin Full Access" ON public.profiles;
DROP POLICY IF EXISTS "Users can see own profile" ON public.profiles;
DROP POLICY IF EXISTS "Self View" ON public.profiles;
DROP POLICY IF EXISTS "Self Update" ON public.profiles;
DROP POLICY IF EXISTS "Self Insert" ON public.profiles;

-- READ: Public (To prevent Recursion loops)
-- Everyone can read profiles. This is acceptable for this stage to unblock Admin/Login.
CREATE POLICY "Public Profile Read" 
ON public.profiles FOR SELECT 
TO authenticated, anon 
USING (true);

-- INSERT: Authenticated users can insert their own ID
CREATE POLICY "Self Profile Insert" 
ON public.profiles FOR INSERT 
TO authenticated 
WITH CHECK ( id = auth.uid() );

-- UPDATE: Users update own, Admins (Hardcoded) update all
CREATE POLICY "Self Profile Update" 
ON public.profiles FOR UPDATE 
TO authenticated 
USING (
   id = auth.uid() 
   OR 
   (auth.jwt() ->> 'email') IN ('prehfeld@hotmail.com', 'paulo.rehfeld@educacao.mg.gov.br')
);

-- DELETE: Admins Only
CREATE POLICY "Admin Profile Delete" 
ON public.profiles FOR DELETE 
TO authenticated 
USING (
   (auth.jwt() ->> 'email') IN ('prehfeld@hotmail.com', 'paulo.rehfeld@educacao.mg.gov.br')
);

-- 3. CLEANUP TRIGGERS (Ensure they are dead)
DROP TRIGGER IF EXISTS trigger_match_teacher_on_insert ON public.profiles;
DROP TRIGGER IF EXISTS trigger_match_teacher_on_update ON public.profiles;
DROP TRIGGER IF EXISTS check_manager_email ON public.profiles;
DROP TRIGGER IF EXISTS before_profile_insert_auto_assign ON public.profiles;
DROP TRIGGER IF EXISTS on_auth_user_role_check ON public.profiles;

COMMIT;
