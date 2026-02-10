-- ==============================================================================
-- RPC: APPROVE TEACHER
-- Links an existing profile to the school based on the pending invitation
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.approve_teacher(
    p_pending_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_email TEXT;
    v_school_id TEXT;
    v_profile_id UUID;
BEGIN
    -- 1. Get Pending Info
    SELECT email_institucional, school_id 
    INTO v_email, v_school_id
    FROM public.pending_teachers 
    WHERE id = p_pending_id;

    IF v_email IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Convite não encontrado.');
    END IF;

    -- 2. Find Profile
    SELECT id INTO v_profile_id
    FROM public.profiles 
    WHERE email = v_email;

    IF v_profile_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Usuário ainda não criou conta no sistema (Perfil não encontrado).');
    END IF;

    -- 3. Link Profile
    UPDATE public.profiles
    SET 
        school_id = v_school_id,
        role = 'teacher',
        is_admin = false
    WHERE id = v_profile_id;

    -- 4. Delete Pending Record (Mission Accomplished)
    DELETE FROM public.pending_teachers WHERE id = p_pending_id;

    RETURN jsonb_build_object(
        'success', true, 
        'message', 'Professor aprovado e vinculado com sucesso!'
    );

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;

GRANT EXECUTE ON FUNCTION public.approve_teacher(UUID) TO authenticated;
