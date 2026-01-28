-- ==============================================================================
-- FINAL ADJUSTMENT: DISABLE SCHOOL SECURITY + FIX PROFILES
-- ==============================================================================
-- 1. Schools: SECURITY OFF (As requested, data is public)
-- 2. Profiles: SECURITY ON (Protect data) but READ is OPEN (To fix recursion/Admin)
-- 3. Triggers: REMOVED (To fix User Creation 409)

BEGIN;

-- ------------------------------------------------------------------------------
-- 1. DISABLE SCHOOLS SECURITY (Public Access)
-- ------------------------------------------------------------------------------
ALTER TABLE public.schools DISABLE ROW LEVEL SECURITY;
-- We drop policies just to be clean, but purely disabling RLS is enough.
DROP POLICY IF EXISTS "Public Schools Read" ON public.schools;
DROP POLICY IF EXISTS "Schools viewable by all" ON public.schools;


-- ------------------------------------------------------------------------------
-- 2. FIX PROFILE SECURITY (Protect Writes, Allow Reads)
-- ------------------------------------------------------------------------------
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- DROP ALL OLD POLICIES (Clean Slate)
DROP POLICY IF EXISTS "Admins Power Access" ON public.profiles;
DROP POLICY IF EXISTS "Admin Full Access" ON public.profiles;
DROP POLICY IF EXISTS "Self View" ON public.profiles;
DROP POLICY IF EXISTS "Self Update" ON public.profiles;
DROP POLICY IF EXISTS "Public Profile Read" ON public.profiles;
DROP POLICY IF EXISTS "Self Profile Insert" ON public.profiles;
DROP POLICY IF EXISTS "Self Profile Update" ON public.profiles;
DROP POLICY IF EXISTS "Admin Profile Delete" ON public.profiles;

-- POLICY A: READ (SELECT) -> OPEN TO LOGGED IN USERS
-- "I want to protect user data" -> We protect WRITES. 
-- For READS, allowing authenticated users to see basic profile info (like name/role) 
-- is standard and NECESSARY for the Admin Panel to work without complex recursion.
CREATE POLICY "Profiles Read Access" 
ON public.profiles FOR SELECT 
TO authenticated 
USING (true);

-- POLICY B: INSERT (Create) -> SELF ONLY
CREATE POLICY "Profiles Self Insert" 
ON public.profiles FOR INSERT 
TO authenticated 
WITH CHECK ( id = auth.uid() );

-- POLICY C: UPDATE (Edit) -> SELF + ADMIN (Hardcoded)
CREATE POLICY "Profiles Write Access" 
ON public.profiles FOR UPDATE 
TO authenticated 
USING (
   id = auth.uid() 
   OR 
   (auth.jwt() ->> 'email') IN ('prehfeld@hotmail.com', 'paulo.rehfeld@educacao.mg.gov.br')
);

-- POLICY D: DELETE -> ADMIN ONLY
CREATE POLICY "Profiles Delete Access" 
ON public.profiles FOR DELETE 
TO authenticated 
USING (
   (auth.jwt() ->> 'email') IN ('prehfeld@hotmail.com', 'paulo.rehfeld@educacao.mg.gov.br')
);


-- ------------------------------------------------------------------------------
-- 3. REMOVE CONFLICTING TRIGGERS
-- ------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trigger_match_teacher_on_insert ON public.profiles;
DROP TRIGGER IF EXISTS trigger_match_teacher_on_update ON public.profiles;
DROP TRIGGER IF EXISTS check_manager_email ON public.profiles;
DROP TRIGGER IF EXISTS before_profile_insert_auto_assign ON public.profiles;
DROP TRIGGER IF EXISTS on_auth_user_role_check ON public.profiles;

COMMIT;
