-- ==============================================================================
-- FIX (FORCE): Allow school_id to be TEXT (handling RLS dependencies)
-- ==============================================================================

-- 1. Disable RLS temporarily
ALTER TABLE public.students DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.classes DISABLE ROW LEVEL SECURITY;

-- 2. Drop policies that depend on the columns
DROP POLICY IF EXISTS "Managers can view students of their school" ON public.students;
DROP POLICY IF EXISTS "Managers can manage students of their school" ON public.students;
DROP POLICY IF EXISTS "Teachers can view students of their school" ON public.students;
DROP POLICY IF EXISTS "Managers view school students via classes" ON public.students;
DROP POLICY IF EXISTS "Managers manage school students via classes" ON public.students;
DROP POLICY IF EXISTS "Public can check students" ON public.students;
DROP POLICY IF EXISTS "Users manage own students" ON public.students;
DROP POLICY IF EXISTS "Public Access" ON public.students;

DROP POLICY IF EXISTS "Managers can view classes of their school" ON public.classes;
DROP POLICY IF EXISTS "Managers can manage classes of their school" ON public.classes;

-- 3. Now safe to alter types
ALTER TABLE public.students 
  DROP CONSTRAINT IF EXISTS students_current_school_id_fkey,
  ALTER COLUMN current_school_id TYPE TEXT;

ALTER TABLE public.classes 
  DROP CONSTRAINT IF EXISTS classes_school_id_fkey,
  ALTER COLUMN school_id TYPE TEXT;

-- 4. Fix profiles just in case (though it might already be text or compatible)
-- Removing FK if exists just to be safe
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_school_id_fkey;
ALTER TABLE public.profiles ALTER COLUMN school_id TYPE TEXT;

-- 5. Re-enable RLS
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.classes ENABLE ROW LEVEL SECURITY;

-- 6. Recreate Policies (using cast ::text to ensure compatibility)
-- Teachers
CREATE POLICY "Teachers can view students of their school" ON public.students FOR SELECT USING (
    current_school_id IN (SELECT school_id::text FROM public.profiles WHERE id = auth.uid() AND role = 'teacher')
);

-- Managers
CREATE POLICY "Managers can view students of their school" ON public.students FOR SELECT USING (
    current_school_id IN (SELECT school_id::text FROM public.profiles WHERE id = auth.uid())
);

CREATE POLICY "Managers can manage students of their school" ON public.students FOR ALL USING (
    current_school_id IN (SELECT school_id::text FROM public.profiles WHERE id = auth.uid() AND role = 'manager')
);

-- Classes
CREATE POLICY "Managers can view classes of their school" ON public.classes FOR SELECT USING (
    school_id IN (SELECT school_id::text FROM public.profiles WHERE id = auth.uid())
);

CREATE POLICY "Managers can manage classes of their school" ON public.classes FOR ALL USING (
    school_id IN (SELECT school_id::text FROM public.profiles WHERE id = auth.uid() AND role = 'manager')
);

-- 7. Fix Orphaned "Davi Silva" and others?
-- If we know the school ID for the current admin/teacher, we could update them.
-- For now, let's just make sure new inserts work.
