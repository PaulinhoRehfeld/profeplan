-- ==============================================================================
-- DEBUG MODE: DISABLE RLS (ISOLATION TEST)
-- ==============================================================================
-- This script disables Row Level Security on critical tables to isolate the cause.
-- If this fixes the 500/409 errors, we KNOW the problem is the Policies.

BEGIN;

-- 1. DISABLE RLS ON SCHOOLS (Should fix 500 Error)
ALTER TABLE public.schools DISABLE ROW LEVEL SECURITY;

-- 2. DISABLE RLS ON PROFILES (Should fix Recursion/Login Loop)
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;

-- 3. DISABLE RLS ON AUTHORIZED_USERS (Just in case)
ALTER TABLE public.authorized_users DISABLE ROW LEVEL SECURITY;

-- 4. DROP PROBLEM TRIGGERS (Should fix 409 Conflict)
DROP TRIGGER IF EXISTS trigger_match_teacher_on_insert ON public.profiles;
DROP TRIGGER IF EXISTS trigger_match_teacher_on_update ON public.profiles;
DROP TRIGGER IF EXISTS check_manager_email ON public.profiles;
DROP TRIGGER IF EXISTS before_profile_insert_auto_assign ON public.profiles;
DROP TRIGGER IF EXISTS on_auth_user_role_check ON public.profiles;

COMMIT;
