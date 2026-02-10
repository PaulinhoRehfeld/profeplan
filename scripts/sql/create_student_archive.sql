-- ==============================================================================
-- DATABASE UPDATE: STUDENT ARCHIVING & PDI
-- ==============================================================================

-- 1. Helper Functions (Required for Policies)
CREATE OR REPLACE FUNCTION public.is_school_manager(target_school_id TEXT)
RETURNS BOOLEAN LANGUAGE sql SECURITY DEFINER AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() 
      AND role = 'manager' 
      AND school_id = target_school_id
  );
$$;

-- 2. Create table for Deleted Students (Archive)
CREATE TABLE IF NOT EXISTS public.deleted_students (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    original_student_id UUID, -- Keep reference to original ID if needed
    name TEXT NOT NULL,
    student_code TEXT,
    school_id TEXT NOT NULL,
    class_id TEXT,
    deletion_reason TEXT NOT NULL, -- "Transferência", "Evasão", etc.
    deletion_details TEXT, -- Custom text for "Outro"
    deleted_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_by UUID REFERENCES auth.users(id),
    
    -- Store backup of student data
    backup_data JSONB 
);

-- 2. Enable RLS on Archive
ALTER TABLE public.deleted_students ENABLE ROW LEVEL SECURITY;

-- Managers can insert (when deleting) and view their own deleted students
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

-- 3. Add PDI columns to active Students table (if not exists)
ALTER TABLE public.students 
ADD COLUMN IF NOT EXISTS pdi_needs TEXT[], -- Array of strings ['TDAH', 'TEA']
ADD COLUMN IF NOT EXISTS observations TEXT;

-- 4. Create Safe Delete Function (RPC)
-- This function performs the "Move & Delete" transactionally
CREATE OR REPLACE FUNCTION public.archive_and_delete_student(
    p_student_id UUID,
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
    -- Get Student Data
    SELECT * INTO v_student_data FROM public.students WHERE id = p_student_id;
    
    IF v_student_data IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Student not found');
    END IF;

    -- Verify Permission (Must be Manager of that school or Admin)
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
        v_student_data.id,
        v_student_data.name,
        v_student_data.student_code,
        v_student_data.current_school_id,
        v_student_data.class_id, -- Assuming this column might be 'class_id' or 'turma_id', checking schema next
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

GRANT EXECUTE ON FUNCTION public.archive_and_delete_student TO authenticated;
