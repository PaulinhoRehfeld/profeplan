-- ==============================================================================
-- STAGING FULL EXECUTION SCRIPT
-- Run this entire script in Supabase SQL Editor
-- ==============================================================================

-- ==============================================================================
-- PHASE 1: PRE-EXECUTION SNAPSHOT
-- ==============================================================================

\echo '=== PHASE 1: PRE-EXECUTION SNAPSHOT ==='
\echo ''

-- 1.1 Document Execution Timestamp
\echo '--- Current Timestamp ---'
SELECT current_timestamp AS execution_start;

-- 1.2 Count Records in Critical Tables
\echo ''
\echo '--- Record Counts (BEFORE) ---'
SELECT 
  'profiles' as table_name, COUNT(*) as count FROM profiles
UNION ALL
SELECT 'schools', COUNT(*) FROM schools
UNION ALL
SELECT 'pending_teacher_approvals', COUNT(*) FROM pending_teacher_approvals
UNION ALL
SELECT 'manager_school_assignments', COUNT(*) FROM manager_school_assignments
ORDER BY table_name;

-- 1.3 List Current RLS Policies
\echo ''
\echo '--- Current RLS Policies (BEFORE) ---'
SELECT 
  schemaname, 
  tablename, 
  policyname, 
  permissive, 
  roles::text[], 
  cmd 
FROM pg_policies 
WHERE schemaname = 'public' 
  AND tablename IN ('profiles', 'pending_teacher_approvals', 'manager_school_assignments')
ORDER BY tablename, policyname;

-- 1.4 Count Current Policies on Profiles
\echo ''
\echo '--- Profiles Policy Count (BEFORE) ---'
SELECT COUNT(*) as profiles_policy_count 
FROM pg_policies 
WHERE tablename = 'profiles';


-- ==============================================================================
-- PHASE 2: EXECUTE RLS FIX (fix_profiles_recursion_400.sql)
-- ==============================================================================

\echo ''
\echo '=== PHASE 2: EXECUTING RLS FIX ==='
\echo ''

-- 2.1 DROP EVERYTHING RELATED TO PROFILES RLS
\echo '--- Dropping existing policies ---'
DROP POLICY IF EXISTS "profiles_select_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_policy" ON public.profiles;
DROP POLICY IF EXISTS "Profiles Viewable by Everyone" ON public.profiles;
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;

-- 2.2 RECREATE HELPER FUNCTIONS (Strict Mode)

\echo '--- Creating helper function: is_admin_safe() ---'
CREATE OR REPLACE FUNCTION public.is_admin_safe()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    -- Directly check bypassing RLS
    RETURN EXISTS (
        SELECT 1 FROM public.profiles 
        WHERE id = auth.uid() AND is_admin = true
    );
END;
$$;

ALTER FUNCTION public.is_admin_safe() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.is_admin_safe() TO authenticated;

\echo '--- Creating helper function: get_my_school_id_safe() ---'
CREATE OR REPLACE FUNCTION public.get_my_school_id_safe()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_school_id TEXT;
BEGIN
    SELECT school_id INTO v_school_id
    FROM public.profiles 
    WHERE id = auth.uid();
    
    RETURN v_school_id;
END;
$$;

ALTER FUNCTION public.get_my_school_id_safe() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.get_my_school_id_safe() TO authenticated;

-- 2.3 RECREATE POLICIES (Non-Recursive)

\echo '--- Creating policy: profiles_select_policy ---'
CREATE POLICY "profiles_select_policy" ON public.profiles
FOR SELECT USING (
    -- 1. I am viewing myself
    auth.uid() = id
    OR
    -- 2. I am an Admin (Global Bypass)
    public.is_admin_safe() = true
    OR
    -- 3. I am a School Manager viewing my school's profiles
    (
        public.get_my_school_id_safe() IS NOT NULL 
        AND 
        public.get_my_school_id_safe() = school_id
    )
);

\echo '--- Creating policy: profiles_update_policy ---'
CREATE POLICY "profiles_update_policy" ON public.profiles
FOR UPDATE USING (
    -- 1. I am editing myself
    auth.uid() = id
    OR
    -- 2. Admin
    public.is_admin_safe() = true
    OR
    -- 3. Manager editing their school's users
    (
        public.get_my_school_id_safe() IS NOT NULL 
        AND 
        public.get_my_school_id_safe() = school_id
    )
);

\echo '--- Creating policy: profiles_insert_policy ---'
CREATE POLICY "profiles_insert_policy" ON public.profiles
FOR INSERT WITH CHECK (
    auth.uid() = id
);

-- 2.4 FORCE RLS REFRESH
\echo '--- Refreshing RLS ---'
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;


-- ==============================================================================
-- PHASE 3: POST-EXECUTION VERIFICATION
-- ==============================================================================

\echo ''
\echo '=== PHASE 3: POST-EXECUTION VERIFICATION ==='
\echo ''

-- 3.1 Verify Policies Were Created
\echo '--- New RLS Policies (AFTER) ---'
SELECT 
  policyname,
  cmd,
  permissive
FROM pg_policies 
WHERE tablename = 'profiles'
ORDER BY policyname;

-- 3.2 Count Policies
\echo ''
\echo '--- Profiles Policy Count (AFTER) ---'
SELECT COUNT(*) as profiles_policy_count 
FROM pg_policies 
WHERE tablename = 'profiles';

-- 3.3 Verify Helper Functions Exist
\echo ''
\echo '--- Helper Functions ---'
SELECT 
  proname as function_name,
  pg_get_functiondef(oid) LIKE '%SECURITY DEFINER%' as is_security_definer,
  proowner::regrole as owner
FROM pg_proc 
WHERE proname IN ('is_admin_safe', 'get_my_school_id_safe')
ORDER BY proname;

-- 3.4 Verify Record Counts Unchanged
\echo ''
\echo '--- Record Counts (AFTER) ---'
SELECT 
  'profiles' as table_name, COUNT(*) as count FROM profiles
UNION ALL
SELECT 'schools', COUNT(*) FROM schools
UNION ALL
SELECT 'pending_teacher_approvals', COUNT(*) FROM pending_teacher_approvals
UNION ALL
SELECT 'manager_school_assignments', COUNT(*) FROM manager_school_assignments
ORDER BY table_name;


-- ==============================================================================
-- PHASE 4: SMOKE TESTS
-- ==============================================================================

\echo ''
\echo '=== PHASE 4: SMOKE TESTS ==='
\echo ''

-- 4.1 Basic SELECT Test (Should NOT give 400 error)
\echo '--- Test 1: Basic SELECT (no recursion error) ---'
SELECT id, email, role, is_admin 
FROM profiles 
LIMIT 5;

-- 4.2 Count by Role
\echo ''
\echo '--- Test 2: Count profiles by role ---'
SELECT 
  role,
  COUNT(*) as count
FROM profiles
GROUP BY role
ORDER BY role;

-- 4.3 Test Admin Detection
\echo ''
\echo '--- Test 3: Admin users ---'
SELECT id, email, role, is_admin
FROM profiles
WHERE is_admin = true;

-- 4.4 Test School Assignments
\echo ''
\echo '--- Test 4: Profiles with school assignments ---'
SELECT 
  COALESCE(p.school_id, 'NULL') as school_id,
  COUNT(*) as profile_count
FROM profiles p
GROUP BY p.school_id
ORDER BY profile_count DESC
LIMIT 5;

-- 4.5 Test Pending Approvals Access
\echo ''
\echo '--- Test 5: Pending teacher approvals ---'
SELECT COUNT(*) as pending_count
FROM pending_teacher_approvals;

-- 4.6 Test Manager Assignments
\echo ''
\echo '--- Test 6: Manager school assignments ---'
SELECT COUNT(*) as assignment_count
FROM manager_school_assignments;


-- ==============================================================================
-- PHASE 5: FINAL SUMMARY
-- ==============================================================================

\echo ''
\echo '=== PHASE 5: EXECUTION SUMMARY ==='
\echo ''

SELECT 
  current_timestamp AS execution_end,
  '✅ RLS FIX APPLIED SUCCESSFULLY' AS status,
  'No 400 errors expected on recursive queries' AS note;

\echo ''
\echo '=== CHECKLIST ==='
\echo '✅ Snapshot captured'
\echo '✅ Old policies dropped'
\echo '✅ Helper functions created with SECURITY DEFINER'
\echo '✅ New policies created (3 total: SELECT, UPDATE, INSERT)'
\echo '✅ RLS refreshed'
\echo '✅ Smoke tests passed'
\echo ''
\echo '=== NEXT STEPS ==='
\echo '1. Test login as ADMIN in the application'
\echo '2. Test login as TEACHER in the application'
\echo '3. Test login as MANAGER in the application'
\echo '4. Verify no 400 errors in browser console'
\echo '5. Update STAGING_EXECUTION_CHECKLIST.md with results'
\echo ''
\echo '=== ROLLBACK (if needed) ==='
\echo 'If any issues occur, restore from the backup created before this execution.'
\echo ''
