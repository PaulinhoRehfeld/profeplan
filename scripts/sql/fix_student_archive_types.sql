-- ==============================================================================
-- FIX TYPES: STUDENT ARCHIVE (UUID -> TEXT)
-- ==============================================================================
-- The 'students.id' is TEXT, not UUID. We must update our archive table and function.

-- 1. Drop the function first (it depends on the types)
DROP FUNCTION IF EXISTS public.archive_and_delete_student(UUID, TEXT, TEXT);
DROP FUNCTION IF EXISTS public.archive_and_delete_student(TEXT, TEXT, TEXT); 

-- 2. Drop and Recreate Table (safest way to fix types if empty or just created)
DROP TABLE IF EXISTS public.deleted_students;

CREATE TABLE public.deleted_students (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    original_student_id TEXT, -- CHANGED TO TEXT
    name TEXT NOT NULL,
    student_code TEXT,
    school_id TEXT NOT NULL,
    class_id TEXT,
    deletion_reason TEXT NOT NULL,
    deletion_details TEXT,
    deleted_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_by UUID REFERENCES auth.users(id),
    backup_data JSONB 
);

-- 3. Re-enable RLS on Archive
ALTER TABLE public.deleted_students ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Managers insert deleted students" ON public.deleted_students
FOR INSERT TO authenticated
WITH CHECK (
    public.is_admin() = true OR
    public.is_school_manager(school_id)
);

CREATE POLICY "Managers view deleted students" ON public.deleted_students
FOR SELECT TO authenticated
USING (
    public.is_admin() = true OR
    public.is_school_manager(school_id)
);

-- 4. Recreate Function with TEXT types
CREATE OR REPLACE FUNCTION public.archive_and_delete_student(
    p_student_id TEXT, -- CHANGED TO TEXT
    p_reason TEXT,
    p_details TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_student_data RECORD;
    v_auth_user_id UUID := auth.uid();
BEGIN
    -- Get Student Data (Casting ID to TEXT just in case, but p_student_id is TEXT now)
    SELECT * INTO v_student_data FROM public.students WHERE id = p_student_id;
    
    IF v_student_data IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Student not found');
    END IF;

    -- Verify Permission 
    IF NOT (public.is_admin() OR public.is_school_manager(v_student_data.current_school_id)) THEN
         RETURN jsonb_build_object('success', false, 'error', 'Permission denied');
    END IF;

    -- Insert into Archive
    INSERT INTO public.deleted_students (
        original_student_id,
        name,
        student_code,
        school_id,
        class_id,
        deletion_reason,
        deletion_details,
        deleted_by,
        backup_data
    ) VALUES (
        v_student_data.id, -- matches TEXT
        v_student_data.name,
        v_student_data.student_code,
        v_student_data.current_school_id,
        v_student_data.class_id,
        p_reason,
        p_details,
        v_auth_user_id,
        row_to_json(v_student_data)::jsonb
    );

    -- Delete from Active
    DELETE FROM public.students WHERE id = p_student_id;

    RETURN jsonb_build_object('success', true);
EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;

GRANT EXECUTE ON FUNCTION public.archive_and_delete_student(TEXT, TEXT, TEXT) TO authenticated;
