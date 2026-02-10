-- ==============================================================================
-- SMART LINKAGE: AUTO-SYNC PROFILE & PENDING TEACHERS
-- DATA: 2026-01-29
-- OBJETIVO: Ao salvar o perfil, vincular automaticamente a escola e convites.
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.update_teacher_profile(
    p_profile_id UUID,
    p_updates JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_school_id TEXT;
    v_email TEXT;
    v_role TEXT;
    v_pending_id UUID;
BEGIN
    -- 1. Extrair dados das atualizações
    v_school_id := TRIM(BOTH FROM (p_updates->>'school_id')::text);
    v_email := TRIM(BOTH FROM LOWER((p_updates->>'email')::text));
    
    -- Se o role não for passado ou for nulo, garantimos 'teacher' (se não for admin/manager)
    v_role := p_updates->>'role';
    IF v_role IS NULL THEN
        -- Verificar role atual para evitar sobrescrever gestores
        SELECT role INTO v_role FROM public.profiles WHERE id = p_profile_id;
        IF v_role IS NULL OR v_role = '' THEN
            v_role := 'teacher';
        END IF;
    END IF;

    -- 2. Atualizar o Perfil
    -- NOTA: Usamos jsonb_to_recordset ou similar se fossem muitos campos, 
    -- mas aqui atualizaremos os campos conhecidos do Profeplan.
    UPDATE public.profiles
    SET 
        full_name = COALESCE(p_updates->>'full_name', full_name),
        email = COALESCE(v_email, email),
        masp = COALESCE(p_updates->>'masp', masp),
        city = COALESCE(p_updates->>'city', city),
        school_id = COALESCE(v_school_id, school_id),
        role = v_role,
        updated_at = NOW()
    WHERE id = p_profile_id;

    -- 3. GATILHO DE VÍNCULO (O que o usuário pediu)
    -- Procurar se existe um convite pendente para este e-mail nesta escola
    IF v_email IS NOT NULL AND v_school_id IS NOT NULL THEN
        SELECT id INTO v_pending_id 
        FROM public.pending_teachers 
        WHERE LOWER(TRIM(email_institucional)) = v_email 
        AND TRIM(school_id) = v_school_id
        AND status = 'pending'
        LIMIT 1;

        IF v_pending_id IS NOT NULL THEN
            -- Vincula automaticamente
            UPDATE public.pending_teachers 
            SET status = 'matched', 
                matched_profile_id = p_profile_id,
                matched_at = NOW()
            WHERE id = v_pending_id;
        END IF;
    END IF;

    RETURN jsonb_build_object(
        'success', true, 
        'message', 'Perfil atualizado e vinculado com sucesso!',
        'matched_invite', (v_pending_id IS NOT NULL)
    );

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;
