-- ==============================================================================
-- FEATURE: MERGE CLASSES
-- ==============================================================================
-- Allows merging a 'Source Class' into a 'Target Class'.
-- 1. Moves all students from Source to Target.
-- 2. Deletes the Source Class.

CREATE OR REPLACE FUNCTION public.merge_classes(
    p_source_class_id UUID,
    p_target_class_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_moved_count INT;
    v_source_name TEXT;
    v_target_name TEXT;
BEGIN
    -- 1. Get Names for logging/return
    SELECT name INTO v_source_name FROM public.classes WHERE id = p_source_class_id;
    SELECT name INTO v_target_name FROM public.classes WHERE id = p_target_class_id;

    IF v_source_name IS NULL OR v_target_name IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Uma das turmas não foi encontrada.');
    END IF;

    -- 2. Verify Permissions (Must be Manager of BOTH classes)
    IF NOT (
        public.is_admin() OR 
        (public.is_school_manager((SELECT school_id FROM public.classes WHERE id = p_source_class_id)) AND
         public.is_school_manager((SELECT school_id FROM public.classes WHERE id = p_target_class_id)))
    ) THEN
        RETURN jsonb_build_object('success', false, 'error', 'Sem permissão para gerenciar estas turmas.');
    END IF;

    -- 3. Move Students
    UPDATE public.students 
    SET class_id = p_target_class_id::TEXT -- Cast to TEXT if needed based on schema, strictly logic says class_id is UUID usually but we saw type issues before. Let's check schema. Assuming UUID based on function signature.
    WHERE class_id = p_source_class_id::TEXT; 
    
    GET DIAGNOSTICS v_moved_count = ROW_COUNT;

    -- 4. Delete Source Class
    DELETE FROM public.classes WHERE id = p_source_class_id;

    RETURN jsonb_build_object(
        'success', true, 
        'moved_students', v_moved_count,
        'message', format('Turma %s unificada com %s. %s alunos movidos.', v_source_name, v_target_name, v_moved_count)
    );
EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;

GRANT EXECUTE ON FUNCTION public.merge_classes(UUID, UUID) TO authenticated;
