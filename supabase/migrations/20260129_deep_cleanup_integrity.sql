-- ==============================================================================
-- CLEANUP & HARDENING: SCHOOL_ID & EMAIL INTEGRITY
-- DATA: 2026-01-29
-- OBJETIVO: Remover quebras de linha/espaços e garantir tipos em school_id.
-- ==============================================================================

BEGIN;

-- 1. LIMPEZA DE DADOS EXISTENTES (Remover \n, \r, \t e espaços)
-- Usamos regex_replace para limpar qualquer whitespace não-espaço no início/fim e espaços duplos
UPDATE public.profiles 
SET school_id = TRIM(BOTH FROM regexp_replace(school_id::text, '[\n\r\t]+', '', 'g'))
WHERE school_id IS NOT NULL;

UPDATE public.schools 
SET id = TRIM(BOTH FROM regexp_replace(id::text, '[\n\r\t]+', '', 'g'))
WHERE id IS NOT NULL;

UPDATE public.classes 
SET school_id = TRIM(BOTH FROM regexp_replace(school_id::text, '[\n\r\t]+', '', 'g'))
WHERE school_id IS NOT NULL;

UPDATE public.students 
SET current_school_id = TRIM(BOTH FROM regexp_replace(current_school_id::text, '[\n\r\t]+', '', 'g'))
WHERE current_school_id IS NOT NULL;

UPDATE public.pending_teachers 
SET school_id = TRIM(BOTH FROM regexp_replace(school_id::text, '[\n\r\t]+', '', 'g')),
    email_institucional = TRIM(BOTH FROM LOWER(regexp_replace(email_institucional, '[\n\r\t]+', '', 'g')))
WHERE school_id IS NOT NULL;

-- 2. HARDENING DAS FUNÇÕES DE SEGURANÇA (Adicionar TRIM defensivo)
CREATE OR REPLACE FUNCTION public.get_auth_school_id()
RETURNS TEXT LANGUAGE sql SECURITY DEFINER AS $$
  SELECT TRIM(BOTH FROM school_id::text) FROM public.profiles WHERE id = auth.uid();
$$;

-- 3. HARDENING DO RPC DE APROVAÇÃO
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
    v_full_name TEXT;
    v_masp TEXT;
    v_profile_id UUID;
BEGIN
    -- Obter e limpar dados do pré-cadastro
    SELECT 
        TRIM(BOTH FROM LOWER(email_institucional)), 
        TRIM(BOTH FROM school_id::text), 
        TRIM(BOTH FROM full_name), 
        TRIM(BOTH FROM masp) 
    INTO v_email, v_school_id, v_full_name, v_masp
    FROM public.pending_teachers 
    WHERE id = p_pending_id;

    IF v_email IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Convite não encontrado.');
    END IF;

    -- Localizar Perfil (Garante limpeza na comparação)
    SELECT id INTO v_profile_id
    FROM public.profiles 
    WHERE LOWER(TRIM(email)) = v_email;

    IF v_profile_id IS NULL THEN
        RETURN jsonb_build_object(
            'success', false, 
            'error', 'Perfil não encontrado para o e-mail ' || v_email
        );
    END IF;

    -- Vincular e Sincronizar
    UPDATE public.profiles
    SET 
        school_id = v_school_id,
        role = 'teacher',
        full_name = COALESCE(full_name, v_full_name),
        masp = COALESCE(masp, v_masp),
        is_admin = false
    WHERE id = v_profile_id;

    -- Marcar match
    UPDATE public.pending_teachers 
    SET status = 'matched', 
        matched_profile_id = v_profile_id,
        matched_at = NOW()
    WHERE id = p_pending_id;

    RETURN jsonb_build_object('success', true, 'message', 'Vínculo realizado com sucesso!');

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;

COMMIT;
