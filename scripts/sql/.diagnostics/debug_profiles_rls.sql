-- ==============================================================================
-- DIAGNOSTIC: PROFILES RLS & VISIBILITY
-- ==============================================================================

-- 1. List all policies on the public.profiles table
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check 
FROM pg_policies 
WHERE tablename = 'profiles';

-- 2. Verify the data exactly as the query would see it (raw check)
-- This confirms the data exists globally, ignoring RLS for me (superuser)
SELECT id, email, role, school_id 
FROM public.profiles 
WHERE school_id = '23299' AND role = 'teacher';

-- 3. Check specific IDs involved
-- Admin
SELECT id, email, role, is_admin, school_id FROM public.profiles WHERE email LIKE '%prehfeld@hotmail.com%';
-- Teacher (Paulo)
SELECT id, email, role, school_id FROM public.profiles WHERE email LIKE '%paulo.rehfeld@educacao.mg.gov.br%';
