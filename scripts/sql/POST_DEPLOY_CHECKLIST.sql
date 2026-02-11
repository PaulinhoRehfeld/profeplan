-- ==============================================================================
-- POST-DEPLOY VALIDATION CHECKLIST (RLS)
-- ==============================================================================
-- Purpose: Validate RLS behavior after deployment in production
-- Notes:
--   - Replace placeholders before running (see TODOs)
--   - Run each block separately in SQL Editor
-- ============================================================================== 

-- ==============================================================================
-- 1) POLICY INVENTORY (names, cmd, qual, with_check)
-- ==============================================================================
SELECT
    tablename,
    policyname,
    cmd,
    roles,
    qual,
    with_check
FROM pg_policies
WHERE schemaname = 'public'
AND tablename IN (
    'schools', 'classes', 'students', 'pending_teachers', 'pdi_documents',
    'profiles', 'pdi_records', 'school_students', 'enem_questions'
)
ORDER BY tablename, cmd, policyname;

-- ==============================================================================
-- 2) FUNCTION RETURN TYPES
-- ==============================================================================
SELECT
    p.proname AS function_name,
    pg_get_function_result(p.oid) AS return_type,
    n.nspname AS schema_name
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public'
AND p.proname IN ('is_admin_safe', 'get_my_school_id_safe')
ORDER BY p.proname;

-- ==============================================================================
-- 3) COLUMN TYPE CHECKS
-- ==============================================================================
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name IN ('profiles', 'pdi_records', 'school_students')
AND column_name IN ('school_id', 'teacher_id')
ORDER BY table_name, column_name;

-- ==============================================================================
-- 4) RLS STATUS
-- ==============================================================================
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

-- ==============================================================================
-- 5) FUNCTIONAL TESTS (AUTH CONTEXT)
-- ==============================================================================
-- TODO: Replace with real UUIDs and school_id values
--   :admin_uid   -> UUID of an admin user
--   :manager_uid -> UUID of a manager/school_admin user
--   :teacher_uid -> UUID of a teacher user
--   :school_id   -> School id for the manager/teacher
--
-- Tip: Use one block at a time. SET LOCAL applies inside a transaction.

-- 5.1) ADMIN READ TESTS
BEGIN;
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":":admin_uid","role":"authenticated"}';
SELECT COUNT(*) AS profiles_visible_to_admin FROM public.profiles;
SELECT COUNT(*) AS pdi_records_visible_to_admin FROM public.pdi_records;
SELECT COUNT(*) AS school_students_visible_to_admin FROM public.school_students;
SELECT COUNT(*) AS enem_questions_visible_to_admin FROM public.enem_questions;
COMMIT;

-- 5.2) MANAGER READ/WRITE TESTS (school scoped)
BEGIN;
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":":manager_uid","role":"authenticated"}';
SELECT COUNT(*) AS profiles_visible_to_manager
FROM public.profiles
WHERE school_id = ':school_id';
SELECT COUNT(*) AS school_students_visible_to_manager
FROM public.school_students
WHERE school_id = ':school_id';
-- INSERT/UPDATE/DELETE samples (adjust columns to match schema)
-- INSERT INTO public.school_students (school_id, student_id) VALUES (':school_id', 'REPLACE_STUDENT_ID');
-- UPDATE public.school_students SET school_id = ':school_id' WHERE student_id = 'REPLACE_STUDENT_ID';
-- DELETE FROM public.school_students WHERE student_id = 'REPLACE_STUDENT_ID';
COMMIT;

-- 5.3) TEACHER READ/WRITE TESTS (own records)
BEGIN;
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":":teacher_uid","role":"authenticated"}';
SELECT COUNT(*) AS pdi_records_visible_to_teacher
FROM public.pdi_records
WHERE teacher_id = ':teacher_uid'::uuid;
-- INSERT/UPDATE/DELETE samples (adjust columns to match schema)
-- INSERT INTO public.pdi_records (school_id, teacher_id) VALUES (':school_id', ':teacher_uid');
-- UPDATE public.pdi_records SET school_id = ':school_id' WHERE teacher_id = ':teacher_uid';
-- DELETE FROM public.pdi_records WHERE teacher_id = ':teacher_uid';
COMMIT;

-- 5.4) AUTHENTICATED READ TEST (ENEM QUESTIONS)
BEGIN;
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":":teacher_uid","role":"authenticated"}';
SELECT COUNT(*) AS enem_questions_visible_to_authenticated FROM public.enem_questions;
COMMIT;
