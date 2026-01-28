-- RESTORE SECURITY STEP 1: SCHOOLS
-- We are re-enabling security ONLY for the Schools table first.

BEGIN;

-- 1. Enable RLS on Schools
ALTER TABLE public.schools ENABLE ROW LEVEL SECURITY;

-- 2. Create Simple Public Policy
-- This allows ANYONE (logged in or not) to read the list of schools.
-- Since it helps sign-up, it needs to be public-ish or at least for authenticated/anon.
DROP POLICY IF EXISTS "Public Schools Access" ON public.schools;

CREATE POLICY "Public Schools Access" 
ON public.schools 
FOR SELECT 
TO public -- 'public' role includes anon and authenticated
USING (true);

COMMIT;
