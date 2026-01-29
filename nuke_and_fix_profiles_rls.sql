-- ==============================================================================
-- FINAL FIX: NUKE ALL POLICIES ON PROFILES AND REBUILD
-- ==============================================================================

BEGIN;

-- 1. Helper function to bypass RLS (Security Definer)
CREATE OR REPLACE FUNCTION public.get_my_role_v2()
RETURNS text
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT role FROM profiles WHERE id = auth.uid();
$$;

-- 2. DYNAMICALLY DROP ALL POLICIES ON 'profiles'
-- This avoids "policy does not exist" or "policy key already exists" errors by finding what actually exists.
DO $$
DECLARE
    pol record;
BEGIN
    FOR pol IN
        SELECT policyname
        FROM pg_policies
        WHERE tablename = 'profiles' AND schemaname = 'public'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.profiles', pol.policyname);
    END LOOP;
END $$;

-- 3. ENABLE RLS (Just in case)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 4. RECREATE CLEAN POLICIES

-- A) READ: Users can view their own profile
CREATE POLICY "v2_users_view_own_profile" ON profiles
FOR SELECT TO authenticated
USING (
  id = auth.uid()
);

-- B) READ: Admins/Managers (Safe Mode)
-- Uses the SECURITY DEFINER function to avoid recursion
CREATE POLICY "v2_admins_view_all_profiles" ON profiles
FOR SELECT TO authenticated
USING (
  get_my_role_v2() IN ('admin', 'school_manager') 
  OR 
  (auth.jwt() ->> 'role') = 'service_role'
);

-- C) UPDATE: Users can update their own profile
CREATE POLICY "v2_users_update_own_profile" ON profiles
FOR UPDATE TO authenticated
USING (
  id = auth.uid()
);

-- D) UPDATE: Admins (Safe Mode)
CREATE POLICY "v2_admins_update_all_profiles" ON profiles
FOR UPDATE TO authenticated
USING (
  get_my_role_v2() IN ('admin')
);

-- E) INSERT: Self-signup
CREATE POLICY "v2_users_insert_own_profile" ON profiles
FOR INSERT TO authenticated
WITH CHECK (
  id = auth.uid()
);

-- 5. Fix Permission Grants
GRANT ALL ON profiles TO authenticated;
-- GRANT USAGE, SELECT ON SEQUENCE profiles_id_seq TO authenticated; -- Removed: UUIDs used, no sequence

COMMIT;
