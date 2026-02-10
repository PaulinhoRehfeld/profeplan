-- ==============================================================================
-- FIX: INFINITE RECURSION ON PROFILES TABLE
-- ==============================================================================

BEGIN;

-- 1. Create a helper function to check role WITHOUT triggering RLS (Security Definer)
-- This allows policies to check "Am I an admin?" without querying the table protected by the policy recursively.
CREATE OR REPLACE FUNCTION public.get_my_role()
RETURNS text
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT role FROM profiles WHERE id = auth.uid();
$$;

-- 2. Drop existing problematic policies on 'profiles'
DROP POLICY IF EXISTS "Users can insert their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Admins can update all profiles" ON profiles;
DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON profiles; 
-- (Drop generic ones too just in case they are malformed)

-- 3. Re-create CLEAN policies

-- A) READ: Users can see their own profile
CREATE POLICY "Users can view own profile" ON profiles
FOR SELECT TO authenticated
USING (
  id = auth.uid()
);

-- B) READ: Admins can see ALL profiles (Using the safe function)
CREATE POLICY "Admins can view all profiles" ON profiles
FOR SELECT TO authenticated
USING (
  get_my_role() IN ('admin', 'school_manager') OR (select is_admin from profiles where id = auth.uid()) = true
);

-- C) UPDATE: Users can update their own profile
CREATE POLICY "Users can update own profile" ON profiles
FOR UPDATE TO authenticated
USING (
  id = auth.uid()
);

-- D) UPDATE: Admins can update any profile (Using the safe function)
CREATE POLICY "Admins can update all profiles" ON profiles
FOR UPDATE TO authenticated
USING (
  get_my_role() IN ('admin') OR (select is_admin from profiles where id = auth.uid()) = true
);

-- E) INSERT: Users can insert their own profile (on signup)
CREATE POLICY "Users can insert own profile" ON profiles
FOR INSERT TO authenticated
WITH CHECK (
  id = auth.uid()
);

COMMIT;
