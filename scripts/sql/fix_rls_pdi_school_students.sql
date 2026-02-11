-- ==============================================================================
-- FIX: RLS for pdi_records and school_students (403/406 errors)
-- Purpose: Add missing RLS policies for PDI records and school students tables
-- Date: 2026-02-11
-- ==============================================================================

-- ==============================================================================
-- PART 1: PDI_RECORDS
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
    -- Admin can see all
    public.is_admin_safe() = true
    OR
    -- Teachers/Managers see their school's PDI records
    (
        public.get_my_school_id_safe() IS NOT NULL
        AND public.get_my_school_id_safe() = school_id
    )
    OR
    -- Teachers see their own PDI records
    teacher_id = auth.uid()
);

-- INSERT: Teachers can create PDI records for their school
CREATE POLICY "pdi_records_insert" ON public.pdi_records
FOR INSERT TO authenticated
WITH CHECK (
    -- Admin can insert anywhere
    public.is_admin_safe() = true
    OR
    -- Teachers can insert for their school
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
-- PART 2: SCHOOL_STUDENTS
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
    -- Admin can see all
    public.is_admin_safe() = true
    OR
    -- School members see their school's students
    (
        public.get_my_school_id_safe() IS NOT NULL
        AND public.get_my_school_id_safe() = school_id
    )
);

-- INSERT: Managers and admins can add students
CREATE POLICY "school_students_insert" ON public.school_students
FOR INSERT TO authenticated
WITH CHECK (
    -- Admin can insert anywhere
    public.is_admin_safe() = true
    OR
    -- Managers can insert for their school
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
-- VERIFICATION QUERIES
-- ==============================================================================

-- Verify policies were created
SELECT 
    schemaname, 
    tablename, 
    policyname, 
    permissive,
    cmd
FROM pg_policies 
WHERE tablename IN ('pdi_records', 'school_students')
ORDER BY tablename, cmd, policyname;

-- Count policies per table
SELECT 
    tablename,
    COUNT(*) as policy_count
FROM pg_policies 
WHERE tablename IN ('pdi_records', 'school_students')
GROUP BY tablename
ORDER BY tablename;
