-- ==============================================================================
-- FIX: GLOBAL "GOD MODE" ACCESS FOR ADMINS
-- Ensure Admins can see EVERYTHING (Schools, Classes, Students) regardless of link
-- ==============================================================================

-- 1. Helper Function (Ensure it exists and is secure)
CREATE OR REPLACE FUNCTION public.is_admin_safe()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.profiles 
        WHERE id = auth.uid() AND is_admin = true
    );
END;
$$;
GRANT EXECUTE ON FUNCTION public.is_admin_safe() TO authenticated;

-- ==============================================================================
-- 2. TABLE: SCHOOLS (Admins must see ALL schools to switch context)
-- ==============================================================================
DROP POLICY IF EXISTS "schools_select_policy" ON public.schools;
DROP POLICY IF EXISTS "schools_insert_policy" ON public.schools;
DROP POLICY IF EXISTS "schools_update_policy" ON public.schools;
DROP POLICY IF EXISTS "schools_delete_policy" ON public.schools;

CREATE POLICY "schools_select_policy" ON public.schools FOR SELECT USING (true); -- Public read (or restrict if needed, but Admins need all)
CREATE POLICY "schools_all_admin_policy" ON public.schools FOR ALL USING (public.is_admin_safe());

-- ==============================================================================
-- 3. TABLE: CLASSES
-- ==============================================================================
DROP POLICY IF EXISTS "Managers Full Access Classes" ON public.classes;
DROP POLICY IF EXISTS "Teachers View Classes" ON public.classes;

CREATE POLICY "classes_admin_policy" ON public.classes FOR ALL
USING (public.is_admin_safe());

CREATE POLICY "classes_manager_policy" ON public.classes FOR ALL
USING (public.is_school_manager(school_id));

CREATE POLICY "classes_teacher_select_policy" ON public.classes FOR SELECT
USING (
    school_id IN (
        SELECT school_id FROM public.profiles 
        WHERE id = auth.uid() AND role = 'teacher'
    )
);

-- ==============================================================================
-- 4. TABLE: STUDENTS
-- ==============================================================================
DROP POLICY IF EXISTS "Managers Full Access" ON public.students;
DROP POLICY IF EXISTS "Teachers View" ON public.students;

CREATE POLICY "students_admin_policy" ON public.students FOR ALL
USING (public.is_admin_safe());

CREATE POLICY "students_manager_policy" ON public.students FOR ALL
USING (public.is_school_manager(current_school_id));

CREATE POLICY "students_teacher_select_policy" ON public.students FOR SELECT
USING (
    current_school_id IN (
        SELECT school_id FROM public.profiles 
        WHERE id = auth.uid() AND role = 'teacher'
    )
);

-- ==============================================================================
-- 5. TABLE: PENDING TEACHERS
-- ==============================================================================
DROP POLICY IF EXISTS "pending_teachers_policy" ON public.pending_teachers;

CREATE POLICY "pending_teachers_admin_policy" ON public.pending_teachers FOR ALL
USING (public.is_admin_safe());

CREATE POLICY "pending_teachers_manager_policy" ON public.pending_teachers FOR ALL
USING (
    school_id IN (
        SELECT school_id FROM public.profiles 
        WHERE id = auth.uid() AND role = 'manager'
    )
);
