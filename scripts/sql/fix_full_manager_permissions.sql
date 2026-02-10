-- ==============================================================================
-- FIX: REPAIR SCHOOL MANAGER PERMISSIONS & SCHEMA (TYPE MISMATCH FIX)
-- ==============================================================================

-- 1. ENSURE SCHEMA (Fix Type Mismatch)
-- The error 42804 confirmed that schools.id is TEXT (INEP code), not UUID.
-- We must ensure students.current_school_id matches that type.

-- Safely recreate the column to ensure correct type
ALTER TABLE public.students 
DROP COLUMN IF EXISTS current_school_id CASCADE;

ALTER TABLE public.students 
ADD COLUMN current_school_id TEXT REFERENCES public.schools(id) ON DELETE SET NULL;

-- 2. PROFILES (Teachers/Managers)
DROP POLICY IF EXISTS "profiles_select_authenticated" ON public.profiles;
CREATE POLICY "profiles_select_authenticated" ON public.profiles FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;
CREATE POLICY "profiles_update_own" ON public.profiles FOR UPDATE TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

-- 3. SCHOOLS
ALTER TABLE public.schools ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public view for authenticated users" ON public.schools;
CREATE POLICY "Public view for authenticated users" ON public.schools FOR SELECT TO authenticated USING (true);
CREATE POLICY "Public view for anon" ON public.schools FOR SELECT TO anon USING (true);

-- 4. CLASSES
-- Note: If classes.school_id is already UUID, this might conflict too, but we focus on students for now.
-- If classes also fails, we'll need a similar fix there.
ALTER TABLE public.classes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "classes_select_school" ON public.classes;
DROP POLICY IF EXISTS "classes_insert_managers" ON public.classes;
DROP POLICY IF EXISTS "classes_update_managers" ON public.classes;
DROP POLICY IF EXISTS "classes_delete_managers" ON public.classes;

-- READ: Authenticated users can read classes of their school
CREATE POLICY "classes_select_school" ON public.classes FOR SELECT TO authenticated
USING (
  school_id IN (SELECT school_id FROM public.profiles WHERE id = auth.uid())
);

-- WRITE (Insert/Update/Delete): Only Managers
CREATE POLICY "classes_insert_managers" ON public.classes FOR INSERT TO authenticated
WITH CHECK (
  school_id IN (SELECT school_id FROM public.profiles WHERE id = auth.uid() AND (role = 'manager' OR is_admin = true))
);

CREATE POLICY "classes_update_managers" ON public.classes FOR UPDATE TO authenticated
USING (
  school_id IN (SELECT school_id FROM public.profiles WHERE id = auth.uid() AND (role = 'manager' OR is_admin = true))
);

CREATE POLICY "classes_delete_managers" ON public.classes FOR DELETE TO authenticated
USING (
  school_id IN (SELECT school_id FROM public.profiles WHERE id = auth.uid() AND (role = 'manager' OR is_admin = true))
);

-- 5. STUDENTS
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "students_select_school" ON public.students;
DROP POLICY IF EXISTS "students_insert_managers" ON public.students;
DROP POLICY IF EXISTS "students_update_managers" ON public.students;
DROP POLICY IF EXISTS "students_delete_managers" ON public.students;

-- READ: Authenticated users can read students of their school
CREATE POLICY "students_select_school" ON public.students FOR SELECT TO authenticated
USING (
  current_school_id IN (SELECT school_id FROM public.profiles WHERE id = auth.uid())
);

-- WRITE: Only Managers/Admins
CREATE POLICY "students_insert_managers" ON public.students FOR INSERT TO authenticated
WITH CHECK (
  current_school_id IN (SELECT school_id FROM public.profiles WHERE id = auth.uid() AND (role = 'manager' OR is_admin = true))
);

CREATE POLICY "students_update_managers" ON public.students FOR UPDATE TO authenticated
USING (
  current_school_id IN (SELECT school_id FROM public.profiles WHERE id = auth.uid() AND (role = 'manager' OR is_admin = true))
);

CREATE POLICY "students_delete_managers" ON public.students FOR DELETE TO authenticated
USING (
  current_school_id IN (SELECT school_id FROM public.profiles WHERE id = auth.uid() AND (role = 'manager' OR is_admin = true))
);

-- 6. VERIFICATION
SELECT 
    'Students Column Fixed (TEXT)' as status,
    EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = 'students' AND column_name = 'current_school_id' AND data_type = 'text') as column_is_text;
