-- ==============================================================================
-- FIX ADMIN RLS POLICIES (VISIBILITY ISSUE)
-- ==============================================================================
-- Description: Unlocks full access to the 'profiles' table for Admin users.
-- Logic: Checks the 'authorized_users' table to verify Admin status, preventing
--        infinite recursion loops on the 'profiles' table itself.
-- ==============================================================================

BEGIN;

-- 1. Enable RLS (just to be safe, should be already on)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 2. Clean up old/conflicting policies (Adjust names if you created different ones manually)
DROP POLICY IF EXISTS "Admins can view all profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admins can update all profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admins Power Access" ON public.profiles;

-- 3. Create the new "SUPER ADMIN" Policy
-- Allows SELECT, INSERT, UPDATE, DELETE for any user who is an ADMIN in authorized_users.
CREATE POLICY "Admins Power Access"
ON public.profiles
FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.authorized_users
    WHERE id = auth.uid()
    AND (role = 'ADMIN' OR role = 'admin')
  )
);

-- 4. Ensure Users can still see their OWN profile (Standard Rule)
-- If this policy doesn't exist, create it. If it does, this might duplicate or error.
-- We use 'IF NOT EXISTS' logic by checking system catalogs or just rely on Supabase typically having one.
-- For safety, let's create a specific one for "Self Access" if the default is missing/broken.
DROP POLICY IF EXISTS "Users can see own profile" ON public.profiles;
CREATE POLICY "Users can see own profile"
ON public.profiles
FOR SELECT
TO authenticated
USING (
  auth.uid() = id
);

COMMIT;

-- Verification
SELECT * FROM public.profiles LIMIT 5;
