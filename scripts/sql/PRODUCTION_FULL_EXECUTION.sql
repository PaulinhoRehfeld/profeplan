-- ==============================================================================
-- PRODUCTION DEPLOYMENT - RLS FIXES
-- ==============================================================================
-- Purpose: Deploy all validated RLS fixes from staging to production
-- Date: 2026-02-11
-- Validated in: Staging environment
-- Fixes Applied:
--   1. Profiles table recursion fix (error 400)
--   2. PDI records and school students RLS policies (errors 403/406)
--   3. ENEM questions read access (17,000 questions)
-- ==============================================================================

-- ==============================================================================
-- IMPORTANT: EXECUTE THIS ENTIRE SCRIPT IN A SINGLE TRANSACTION
-- ==============================================================================

BEGIN;

-- ==============================================================================
-- PHASE 1: PROFILES TABLE FIX (Error 400 - Recursion)
-- ==============================================================================

-- 1.1: Drop existing functions CASCADE (removes dependent policies)

DROP FUNCTION IF EXISTS public.is_admin_safe() CASCADE;
DROP FUNCTION IF EXISTS public.get_my_school_id_safe() CASCADE;

-- 1.2: Create SECURITY DEFINER functions (owned by postgres)

CREATE OR REPLACE FUNCTION public.is_admin_safe()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid()
        AND role = 'admin'
    );
$$;

ALTER FUNCTION public.is_admin_safe() OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_my_school_id_safe()
RETURNS integer
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT school_id FROM public.profiles
    WHERE id = auth.uid()
    LIMIT 1;
$$;

ALTER FUNCTION public.get_my_school_id_safe() OWNER TO postgres;

-- 1.3: Drop old policies

DROP POLICY IF EXISTS "profiles_select_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_policy" ON public.profiles;
DROP POLICY IF EXISTS "Enable read for authenticated users" ON public.profiles;
DROP POLICY IF EXISTS "Enable update for users based on id" ON public.profiles;
DROP POLICY IF EXISTS "Admin full access" ON public.profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "School managers can view their school" ON public.profiles;

-- 1.4: Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 1.5: Create new policies using SECURITY DEFINER functions

-- SELECT: Admins see all, others see their school + self
CREATE POLICY "profiles_select_policy" ON public.profiles
FOR SELECT TO authenticated
USING (
    public.is_admin_safe() = true
    OR
    id = auth.uid()
    OR
    (
        public.get_my_school_id_safe() IS NOT NULL
        AND public.get_my_school_id_safe() = school_id
    )
);

-- UPDATE: Users can update their own profile, admins can update all
CREATE POLICY "profiles_update_policy" ON public.profiles
FOR UPDATE TO authenticated
USING (
    public.is_admin_safe() = true
    OR
    id = auth.uid()
);

-- INSERT: Only admins can create new profiles
CREATE POLICY "profiles_insert_policy" ON public.profiles
FOR INSERT TO authenticated
WITH CHECK (
    public.is_admin_safe() = true
);

-- ==============================================================================
-- PHASE 2: PDI_RECORDS TABLE (Error 403)
-- ==============================================================================

-- Enable RLS if not already enabled
ALTER TABLE public.pdi_records ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "School Members View PDI" ON public.pdi_records;
DROP POLICY IF EXISTS "Teachers Insert PDI" ON public.pdi_records;
DROP POLICY IF EXISTS "pdi_records_select_school" ON public.pdi_records;
DROP POLICY IF EXISTS "School Admin can view all pdi records" ON public.pdi_records;
DROP POLICY IF EXISTS "pdi_records_select_all" ON public.pdi_records;
DROP POLICY IF EXISTS "pdi_records_insert" ON public.pdi_records;
DROP POLICY IF EXISTS "pdi_records_update" ON public.pdi_records;
DROP POLICY IF EXISTS "pdi_records_delete" ON public.pdi_records;

-- SELECT: Admins see all, others see only their school
CREATE POLICY "pdi_records_select_all" ON public.pdi_records
FOR SELECT TO authenticated
USING (
    public.is_admin_safe() = true
    OR
    (
        public.get_my_school_id_safe() IS NOT NULL
        AND public.get_my_school_id_safe() = school_id
    )
    OR
    teacher_id = auth.uid()
);

-- INSERT: Teachers can create PDI records for their school
CREATE POLICY "pdi_records_insert" ON public.pdi_records
FOR INSERT TO authenticated
WITH CHECK (
    public.is_admin_safe() = true
    OR
    (
        public.get_my_school_id_safe() IS NOT NULL
        AND public.get_my_school_id_safe() = school_id
        AND teacher_id = auth.uid()
    )
);

-- UPDATE: Teachers can update their own PDI records, admins can update all
CREATE POLICY "pdi_records_update" ON public.pdi_records
FOR UPDATE TO authenticated
USING (
    public.is_admin_safe() = true
    OR
    teacher_id = auth.uid()
    OR
    (
        public.get_my_school_id_safe() IS NOT NULL
        AND public.get_my_school_id_safe() = school_id
    )
);

-- DELETE: Teachers can delete their own PDI records, admins can delete all
CREATE POLICY "pdi_records_delete" ON public.pdi_records
FOR DELETE TO authenticated
USING (
    public.is_admin_safe() = true
    OR
    teacher_id = auth.uid()
);

-- ==============================================================================
-- PHASE 3: SCHOOL_STUDENTS TABLE (Error 406)
-- ==============================================================================

-- Enable RLS if not already enabled
ALTER TABLE public.school_students ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "School Manager can manage students" ON public.school_students;
DROP POLICY IF EXISTS "Users can view students from their school" ON public.school_students;
DROP POLICY IF EXISTS "school_students_select" ON public.school_students;
DROP POLICY IF EXISTS "school_students_insert" ON public.school_students;
DROP POLICY IF EXISTS "school_students_update" ON public.school_students;
DROP POLICY IF EXISTS "school_students_delete" ON public.school_students;

-- SELECT: All school members can view students from their school
CREATE POLICY "school_students_select" ON public.school_students
FOR SELECT TO authenticated
USING (
    public.is_admin_safe() = true
    OR
    (
        public.get_my_school_id_safe() IS NOT NULL
        AND public.get_my_school_id_safe() = school_id
    )
);

-- INSERT: Managers and admins can add students
CREATE POLICY "school_students_insert" ON public.school_students
FOR INSERT TO authenticated
WITH CHECK (
    public.is_admin_safe() = true
    OR
    (
        public.get_my_school_id_safe() IS NOT NULL
        AND public.get_my_school_id_safe() = school_id
        AND EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() 
            AND role IN ('manager', 'school_manager', 'school_admin')
        )
    )
);

-- UPDATE: Managers can update students from their school
CREATE POLICY "school_students_update" ON public.school_students
FOR UPDATE TO authenticated
USING (
    public.is_admin_safe() = true
    OR
    (
        public.get_my_school_id_safe() IS NOT NULL
        AND public.get_my_school_id_safe() = school_id
        AND EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() 
            AND role IN ('manager', 'school_manager', 'school_admin')
        )
    )
);

-- DELETE: Managers can delete students from their school
CREATE POLICY "school_students_delete" ON public.school_students
FOR DELETE TO authenticated
USING (
    public.is_admin_safe() = true
    OR
    (
        public.get_my_school_id_safe() IS NOT NULL
        AND public.get_my_school_id_safe() = school_id
        AND EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() 
            AND role IN ('manager', 'school_manager', 'school_admin')
        )
    )
);

-- ==============================================================================
-- PHASE 4: ENEM_QUESTIONS TABLE (Enable Read Access for 17,000 questions)
-- ==============================================================================

-- Enable RLS if not already enabled
ALTER TABLE public.enem_questions ENABLE ROW LEVEL SECURITY;

-- Drop any existing restrictive policies
DROP POLICY IF EXISTS "enem_questions_select" ON public.enem_questions;
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON public.enem_questions;
DROP POLICY IF EXISTS "Allow public read" ON public.enem_questions;
DROP POLICY IF EXISTS "Permitir leitura pública" ON public.enem_questions;
DROP POLICY IF EXISTS "enem_questions_select_authenticated" ON public.enem_questions;
DROP POLICY IF EXISTS "enem_questions_select_all" ON public.enem_questions;

-- Allow ALL authenticated users to read enem_questions
CREATE POLICY "enem_questions_select_all" ON public.enem_questions
FOR SELECT TO authenticated
USING (true);

-- ==============================================================================
-- VERIFICATION QUERIES
-- ==============================================================================

-- Verify SECURITY DEFINER functions
SELECT 
    routine_name,
    routine_type,
    security_type,
    specific_name
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name IN ('is_admin_safe', 'get_my_school_id_safe')
ORDER BY routine_name;

-- Verify profiles policies (should be 3)
SELECT 
    'profiles' as table_name,
    policyname, 
    cmd
FROM pg_policies 
WHERE tablename = 'profiles'
ORDER BY cmd, policyname;

-- Verify pdi_records policies (should be 4)
SELECT 
    'pdi_records' as table_name,
    policyname, 
    cmd
FROM pg_policies 
WHERE tablename = 'pdi_records'
ORDER BY cmd, policyname;

-- Verify school_students policies (should be 4)
SELECT 
    'school_students' as table_name,
    policyname, 
    cmd
FROM pg_policies 
WHERE tablename = 'school_students'
ORDER BY cmd, policyname;

-- Verify enem_questions policies (should be 1)
SELECT 
    'enem_questions' as table_name,
    policyname, 
    cmd
FROM pg_policies 
WHERE tablename = 'enem_questions'
ORDER BY policyname;

-- Summary count
SELECT 
    tablename,
    COUNT(*) as policy_count
FROM pg_policies 
WHERE tablename IN ('profiles', 'pdi_records', 'school_students', 'enem_questions')
GROUP BY tablename
ORDER BY tablename;

-- ==============================================================================
-- DEPLOYMENT COMPLETE
-- Expected Policy Count:
--   - profiles: 3 (SELECT, UPDATE, INSERT)
--   - pdi_records: 4 (SELECT, INSERT, UPDATE, DELETE)
--   - school_students: 4 (SELECT, INSERT, UPDATE, DELETE)
--   - enem_questions: 1 (SELECT)
-- TOTAL: 12 policies
-- ==============================================================================

-- Commit all changes
COMMIT;
