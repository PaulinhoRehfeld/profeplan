-- ==============================================================================
-- 🚑 RESTORE PROFILE ACCESS & FIX ROLE CONSTRAINT
-- ==============================================================================
-- The "Button does nothing" issue is caused by MISSING RLS POLICIES for "UPDATE".
-- When RLS blocks an update, Supabase returns "Success" but updates 0 rows.
-- This script restores the basic rights for users to edit their own profiles.

BEGIN;

-- 1. Unblock the 'manager' role (Constraint Fix)
-- We drop the old check and add a comprehensive one.
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_role_check;
ALTER TABLE public.profiles ADD CONSTRAINT profiles_role_check 
CHECK (role IN ('teacher', 'manager', 'school_admin', 'admin', 'school_manager'));

-- 2. Restore Basic User Policies (Critical for Update/Select)
-- First, clean up to avoid duplicates
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users insert own profile" ON public.profiles;

-- Recreate them
CREATE POLICY "Users can view own profile" ON public.profiles 
FOR SELECT TO authenticated 
USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles 
FOR UPDATE TO authenticated 
USING (auth.uid() = id);

CREATE POLICY "Users insert own profile" ON public.profiles 
FOR INSERT TO authenticated 
WITH CHECK (auth.uid() = id);

-- 3. Ensure Manager Policy exists (from previous script)
DROP POLICY IF EXISTS "Managers can view school colleagues" ON public.profiles;
CREATE POLICY "Managers can view school colleagues" ON public.profiles 
FOR SELECT TO authenticated
USING (
    auth.uid() IN (
        SELECT id FROM public.profiles 
        WHERE role IN ('manager', 'school_manager') 
        AND school_id = public.profiles.school_id
    )
);

COMMIT;
