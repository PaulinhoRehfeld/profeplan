-- ==============================================================================
-- FIX RLS RECURSION (FINAL)
-- ==============================================================================
-- Problem: "Infinite recursion detected"
-- Cause: The 'profiles' policy queries a table (likely 'authorized_users' or itself)
--        which triggers another policy check loop.
-- Solution: Use JWT Claims (auth.jwt()) which are static and do not trigger DB queries.
--           We trust 'authorized_users' lookup only if it has no complex RLS.
--           Plan B: Trust the specific Admin Emails hardcoded or via simple lookup.
-- ==============================================================================

BEGIN;

-- 1. Drop the problematic policies
DROP POLICY IF EXISTS "Admins Power Access" ON public.profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admins can update all profiles" ON public.profiles;

-- 2. Create Non-Recursive Admin Policy
-- We use a direct lookup to authorized_users, assuming authorized_users has NO RLS or simple RLS.
-- To be 100% safe against recursion, we can use a SECURITY DEFINER function wrapped in the policy?
-- Postgres RLS is tricky with functions.
-- Safest bet: Check email directly from JWT.

CREATE POLICY "Admins Power Access"
ON public.profiles
FOR ALL
TO authenticated
USING (
  -- Check if the user's email (from Token) is in the authorized_users list as ADMIN.
  -- This subquery must NOT trigger RLS on authorized_users if possible, or authorized_users must be clean.
  (SELECT role FROM public.authorized_users WHERE email = lower(auth.jwt() ->> 'email') LIMIT 1) IN ('ADMIN', 'admin')
  OR
  -- Fallback for hardcoded owner
  lower(auth.jwt() ->> 'email') IN ('prehfeld@hotmail.com', 'paulo.rehfeld@educacao.mg.gov.br')
);

-- 3. Ensure Self-Access (Standard)
DROP POLICY IF EXISTS "Users can see own profile" ON public.profiles;
CREATE POLICY "Users can see own profile"
ON public.profiles
FOR SELECT
TO authenticated
USING (
  auth.uid() = id
  OR lower(email) = lower(auth.jwt() ->> 'email') -- Trust email match too
);

COMMIT;

-- Verify
SELECT * FROM public.profiles LIMIT 1;
