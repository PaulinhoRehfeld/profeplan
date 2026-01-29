-- Allow teachers to view students in their school
DROP POLICY IF EXISTS "Teachers can view students of their school" ON public.students;

CREATE POLICY "Teachers can view students of their school"
ON public.students FOR SELECT
USING (
    current_school_id IN (
        SELECT school_id FROM public.profiles WHERE id = auth.uid() AND role = 'teacher'
    )
);

-- Also ensure basic authenticated access isn't blocked if we want a simpler approach for now
-- (Optional, but safer to stick to role-based)

-- Verify existing policies
SELECT * FROM pg_policies WHERE tablename = 'students';
