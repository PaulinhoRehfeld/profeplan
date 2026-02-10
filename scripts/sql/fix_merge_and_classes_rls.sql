-- ==============================================================================
-- FIX: MERGE CLASSES TYPES & CLASSES RLS
-- ==============================================================================

-- 1. DROP INCORRECT FUNCTION (UUID version)
DROP FUNCTION IF EXISTS public.merge_classes(UUID, UUID);
DROP FUNCTION IF EXISTS public.merge_classes(TEXT, TEXT);

-- 2. RECREATE FUNCTION WITH TEXT PARAMETERS (Safe for both UUID and TEXT columns)
CREATE OR REPLACE FUNCTION public.merge_classes(
    p_source_class_id TEXT,
    p_target_class_id TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_moved_count INT;
    v_source_name TEXT;
    v_target_name TEXT;
    v_source_school_id TEXT;
    v_target_school_id TEXT;
BEGIN
    -- Get Info & Verify Existence (Casting ID to TEXT for comparison if column is UUID, logic handles both)
    SELECT name, school_id INTO v_source_name, v_source_school_id FROM public.classes WHERE id::TEXT = p_source_class_id;
    SELECT name, school_id INTO v_target_name, v_target_school_id FROM public.classes WHERE id::TEXT = p_target_class_id;

    IF v_source_name IS NULL OR v_target_name IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Uma das turmas não foi encontrada.');
    END IF;

    -- Verify Permissions: Must be Manager of BOTH schools (usually same school) or ADMIN
    IF NOT (
        public.is_admin() OR 
        (public.is_school_manager(v_source_school_id) AND public.is_school_manager(v_target_school_id))
    ) THEN
        RETURN jsonb_build_object('success', false, 'error', 'Sem permissão para gerenciar estas turmas.');
    END IF;

    -- Move Students: Update reference. 
    -- We assume students.class_id is compatible with the inputs.
    UPDATE public.students 
    SET class_id = p_target_class_id
    WHERE class_id = p_source_class_id;
    
    GET DIAGNOSTICS v_moved_count = ROW_COUNT;

    -- Delete Source Class
    DELETE FROM public.classes WHERE id::TEXT = p_source_class_id;

    RETURN jsonb_build_object(
        'success', true, 
        'moved_students', v_moved_count,
        'message', format('Turma %s unificada com %s. %s alunos movidos.', v_source_name, v_target_name, v_moved_count)
    );
EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;

GRANT EXECUTE ON FUNCTION public.merge_classes(TEXT, TEXT) TO authenticated;


-- 3. FIX RLS FOR CLASSES (Ensure Editing/Saving works)
ALTER TABLE public.classes ENABLE ROW LEVEL SECURITY;

-- Reset Policies
DROP POLICY IF EXISTS "Managers Manage Classes" ON public.classes;
DROP POLICY IF EXISTS "Managers View Classes" ON public.classes;
DROP POLICY IF EXISTS "Managers Full Access Classes" ON public.classes;

-- Create Comprehensive Manager Policy
CREATE POLICY "Managers Full Access Classes" ON public.classes
FOR ALL TO authenticated
USING (
    public.is_school_manager(school_id) OR public.is_admin() = true
)
WITH CHECK (
    public.is_school_manager(school_id) OR public.is_admin() = true
);

-- Allow Teachers to View Classes (needed for their dashboard/selects)
CREATE POLICY "Teachers View Classes" ON public.classes
FOR SELECT TO authenticated
USING (
    school_id IN (
        SELECT school_id FROM public.profiles 
        WHERE id = auth.uid() AND role = 'teacher'
    )
    OR public.is_admin() = true
);
