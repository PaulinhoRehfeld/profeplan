-- ==============================================================================
-- FIX RLS: FINAL RESET FOR STUDENTS
-- ==============================================================================
-- Ensure Managers have FULL CRUD (Select, Insert, Update, Delete) on their students.

ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;

-- 1. DROP ALL EXISTING POLICIES (Clean Slate)
DROP POLICY IF EXISTS "Managers Manage" ON public.students;
DROP POLICY IF EXISTS "Managers View" ON public.students;
DROP POLICY IF EXISTS "Teachers View" ON public.students;
DROP POLICY IF EXISTS "Managers can delete students" ON public.students;
DROP POLICY IF EXISTS "Managers Update Students" ON public.students;

-- 2. CREATE HELPER FUNCTION (If not exists)
CREATE OR REPLACE FUNCTION public.is_school_manager(target_school_id TEXT)
RETURNS BOOLEAN LANGUAGE sql SECURITY DEFINER AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() 
      AND role = 'manager' 
      AND school_id = target_school_id
  );
$$;

-- 3. CREATE MANAGER POLICIES
-- Policy for ALL actions (Select, Insert, Update, Delete)
CREATE POLICY "Managers Full Access" ON public.students
FOR ALL TO authenticated
USING (
    public.is_school_manager(current_school_id)
    OR
    public.is_admin() = true
)
WITH CHECK (
    public.is_school_manager(current_school_id)
    OR
    public.is_admin() = true
);

-- 4. CREATE TEACHER POLICIES (Read Only for now)
CREATE POLICY "Teachers View" ON public.students
FOR SELECT TO authenticated
USING (
    current_school_id IN (
        SELECT school_id FROM public.profiles 
        WHERE id = auth.uid() AND role = 'teacher'
    )
    OR
    public.is_admin() = true
);

-- 5. VERIFY ADÃO DATA (Debug Output)
SELECT id, name, class_id, current_school_id, pdi_needs, deficiencies, observations 
FROM public.students 
WHERE name ILIKE '%Adão%';
