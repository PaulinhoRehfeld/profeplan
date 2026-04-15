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
-- PRE-FLIGHT CHECKS (informational)
-- ==============================================================================

-- Function return types
SELECT
    p.proname AS function_name,
    pg_get_function_result(p.oid) AS return_type,
    n.nspname AS schema_name
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public'
AND p.proname IN ('is_admin_safe', 'get_my_school_id_safe')
ORDER BY p.proname;

-- Column types for school_id/teacher_id
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name IN ('profiles', 'pdi_records', 'school_students')
AND column_name IN ('school_id', 'teacher_id')
ORDER BY table_name, column_name;

-- RLS status for all tables in this script
SELECT
    c.relname AS table_name,
    c.relrowsecurity AS rls_enabled
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
AND c.relname IN (
    'schools', 'classes', 'students', 'pending_teachers', 'pdi_documents',
    'profiles', 'pdi_records', 'school_students', 'enem_questions'
)
ORDER BY c.relname;

-- Current policy counts
SELECT
    tablename,
    COUNT(*) AS policy_count
FROM pg_policies
WHERE tablename IN (
    'schools', 'classes', 'students', 'pending_teachers', 'pdi_documents',
    'profiles', 'pdi_records', 'school_students', 'enem_questions'
)
GROUP BY tablename
ORDER BY tablename;

-- ==============================================================================
-- PHASE 1: PROFILES TABLE FIX (Error 400 - Recursion)
-- ==============================================================================

-- 1.1: Drop ALL policies for canonical tables (reset to standard set)

DO $$
DECLARE
    p RECORD;
BEGIN
    FOR p IN
        SELECT schemaname, tablename, policyname
        FROM pg_policies
        WHERE schemaname = 'public'
        AND tablename IN (
            'schools', 'classes', 'students', 'pending_teachers', 'pdi_documents',
            'profiles', 'pdi_records', 'school_students', 'enem_questions'
        )
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', p.policyname, p.schemaname, p.tablename);
    END LOOP;
END $$;

-- 1.2: Drop existing functions (after dependent policies are removed)

DROP FUNCTION IF EXISTS public.is_admin_safe();
DROP FUNCTION IF EXISTS public.get_my_school_id_safe();

-- 1.3: Create SECURITY DEFINER functions (owned by postgres)

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
RETURNS text
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT COALESCE(active_school_id, school_id) FROM public.profiles
    WHERE id = auth.uid()
    LIMIT 1;
$$;

ALTER FUNCTION public.get_my_school_id_safe() OWNER TO postgres;

-- 1.4: Recreate admin policies for core tables

-- SCHOOLS TABLE
ALTER TABLE public.schools ENABLE ROW LEVEL SECURITY;
CREATE POLICY "schools_all_admin_policy" ON public.schools
FOR ALL TO authenticated
USING (public.is_admin_safe() = true);

-- CLASSES TABLE
ALTER TABLE public.classes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "classes_admin_policy" ON public.classes
FOR ALL TO authenticated
USING (public.is_admin_safe() = true);

-- STUDENTS TABLE
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
CREATE POLICY "students_admin_policy" ON public.students
FOR ALL TO authenticated
USING (public.is_admin_safe() = true);

-- PENDING_TEACHERS TABLE
ALTER TABLE public.pending_teachers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "pending_teachers_admin_policy" ON public.pending_teachers
FOR ALL TO authenticated
USING (public.is_admin_safe() = true);

-- PDI_DOCUMENTS TABLE
ALTER TABLE public.pdi_documents ENABLE ROW LEVEL SECURITY;
CREATE POLICY "pdi_admin_policy" ON public.pdi_documents
FOR ALL TO authenticated
USING (public.is_admin_safe() = true);

-- 1.5: Policies already cleared in step 1.1

-- 1.6: Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 1.7: Create new profiles policies using SECURITY DEFINER functions

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

-- Policies already cleared in step 1.1

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

-- Policies already cleared in step 1.1

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

-- Policies already cleared in step 1.1

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

-- Verify schools policy (should be 1)
SELECT 
    'schools' as table_name,
    policyname, 
    cmd
FROM pg_policies 
WHERE tablename = 'schools'
ORDER BY policyname;

-- Verify classes policy (should be 1)
SELECT 
    'classes' as table_name,
    policyname, 
    cmd
FROM pg_policies 
WHERE tablename = 'classes'
ORDER BY policyname;

-- Verify students policy (should be 1)
SELECT 
    'students' as table_name,
    policyname, 
    cmd
FROM pg_policies 
WHERE tablename = 'students'
ORDER BY policyname;

-- Verify pending_teachers policy (should be 1)
SELECT 
    'pending_teachers' as table_name,
    policyname, 
    cmd
FROM pg_policies 
WHERE tablename = 'pending_teachers'
ORDER BY policyname;

-- Verify pdi_documents policy (should be 1)
SELECT 
    'pdi_documents' as table_name,
    policyname, 
    cmd
FROM pg_policies 
WHERE tablename = 'pdi_documents'
ORDER BY policyname;

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
WHERE tablename IN (
    'schools', 'classes', 'students', 'pending_teachers', 'pdi_documents',
    'profiles', 'pdi_records', 'school_students', 'enem_questions'
)
GROUP BY tablename
ORDER BY tablename;

-- ==============================================================================
-- DEPLOYMENT COMPLETE
-- Expected Policy Count:
--   - schools: 1 (ALL for admins)
--   - classes: 1 (ALL for admins)
--   - students: 1 (ALL for admins)
--   - pending_teachers: 1 (ALL for admins)
--   - pdi_documents: 1 (ALL for admins)
--   - profiles: 3 (SELECT, UPDATE, INSERT)
--   - pdi_records: 4 (SELECT, INSERT, UPDATE, DELETE)
--   - school_students: 4 (SELECT, INSERT, UPDATE, DELETE)
--   - enem_questions: 1 (SELECT)
-- TOTAL: 17 policies (5 from CASCADE recreated + 12 new)
-- ==============================================================================

-- Commit all changes
COMMIT;
