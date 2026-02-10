-- ==============================================================================
-- FIX RLS: STUDENT DELETION
-- ==============================================================================
-- Allow Managers to DELETE students from their school.

ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;

-- 1. Create Helper Function (if not exists) to avoid recursion/complexity
CREATE OR REPLACE FUNCTION public.is_school_manager(target_school_id TEXT)
RETURNS BOOLEAN LANGUAGE sql SECURITY DEFINER AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() 
      AND role = 'manager' 
      AND school_id = target_school_id
  );
$$;

-- 2. Drop existing DELETE policy
DROP POLICY IF EXISTS "Managers can delete students" ON public.students;
DROP POLICY IF EXISTS "Managers Manage" ON public.students; -- Dropping broad policy if it exists

-- 3. Create Specific DELETE Policy
CREATE POLICY "Managers Delete Students" ON public.students
FOR DELETE TO authenticated
USING (
    public.is_school_manager(current_school_id)
    OR
    public.is_admin() = true
);

-- 4. Ensure UPDATE is also allowed (for editing PDI/Transfer)
DROP POLICY IF EXISTS "Managers Update Students" ON public.students;
CREATE POLICY "Managers Update Students" ON public.students
FOR UPDATE TO authenticated
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

-- Ensure SELECT is still generic (Teachers can view too)
-- (Assuming existing SELECT policies are fine, catching specific manager actions here)
