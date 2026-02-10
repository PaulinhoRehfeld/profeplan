-- RESTORE SECURITY STEP 2: PROFILES
-- Re-enabling RLS on Profiles with NON-RECURSIVE policies.

BEGIN;

-- 1. Enable RLS on Profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 2. Drop any potentially broken policies (Clean Slate)
DROP POLICY IF EXISTS "Admins Power Access" ON public.profiles;
DROP POLICY IF EXISTS "Admin Full Access" ON public.profiles;
DROP POLICY IF EXISTS "Users can see own profile" ON public.profiles;
DROP POLICY IF EXISTS "Self View" ON public.profiles;
DROP POLICY IF EXISTS "Self Update" ON public.profiles;

-- 3. Create SIMPLE, ROBUST Policies

-- A. "Self View": User can see their own row.
-- Uses ID check (fast) OR Email check (recovery).
CREATE POLICY "Self View" 
ON public.profiles 
FOR SELECT 
TO authenticated 
USING (
    id = auth.uid() 
    OR 
    email = (auth.jwt() ->> 'email')
);

-- B. "Self Update": User can update their own row.
CREATE POLICY "Self Update" 
ON public.profiles 
FOR UPDATE 
TO authenticated 
USING ( id = auth.uid() );

-- C. "Self Insert": Needed for Sign Up if not skipped
CREATE POLICY "Self Insert" 
ON public.profiles 
FOR INSERT 
TO authenticated 
WITH CHECK (
    id = auth.uid()
    OR
    email = (auth.jwt() ->> 'email')
);

-- D. "Admin Access": HARDCODED BACKDOOR + JWT Check
-- DO NOT check 'public.authorized_users' here to avoid ANY chance of recursion.
-- We rely on the JWT claiming they are admin, OR the hardcoded email.
CREATE POLICY "Admin Full Access" 
ON public.profiles 
FOR ALL 
TO authenticated 
USING (
    -- 1. Hardcoded Super Admins (Always works even if DB is broken)
    (auth.jwt() ->> 'email') IN ('prehfeld@hotmail.com', 'paulo.rehfeld@educacao.mg.gov.br')
    OR 
    -- 2. JWT Role (Set by Supabase Auth or Custom Claims)
    ((auth.jwt() -> 'user_metadata') ->> 'role') = 'admin'
);

COMMIT;
