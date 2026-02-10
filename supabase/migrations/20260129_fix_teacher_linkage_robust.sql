-- ==============================================================================
-- CORREÇÃO DEFINITIVA: VÍNCULO DE PROFESSORES E RLS
-- DATA: 2026-01-29
-- OBJETIVO: Garantir que professores não sumam após aprovação e que dados sejam consistentes.
-- ==============================================================================

BEGIN;

-- 1. Garantir Roles e Check Constraints
ALTER TABLE public.profiles 
DROP CONSTRAINT IF EXISTS profiles_role_check;

ALTER TABLE public.profiles 
ADD CONSTRAINT profiles_role_check 
CHECK (role IN ('teacher', 'manager', 'admin', 'school_manager', 'school_admin'));

-- 2. Refinar RPC de Aprovação (Cópia Robusta de Dados)
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
    -- Obter dados do pré-cadastro
    SELECT email_institucional, school_id, full_name, masp 
    INTO v_email, v_school_id, v_full_name, v_masp
    FROM public.pending_teachers 
    WHERE id = p_pending_id;

    IF v_email IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'Convite não encontrado no pré-cadastro.');
    END IF;

    -- Localizar Perfil por e-mail (Case Insensitive)
    SELECT id INTO v_profile_id
    FROM public.profiles 
    WHERE LOWER(email) = LOWER(v_email);

    IF v_profile_id IS NULL THEN
        RETURN jsonb_build_object(
            'success', false, 
            'error', 'O professor com e-mail ' || v_email || ' ainda não criou uma conta no sistema. Ele precisa se cadastrar primeiro.'
        );
    END IF;

    -- Atualizar perfil e vincular à escola
    -- Usamos COALESCE para NÃO sobrescrever dados caso o professor já tenha preenchido algo diferente,
    -- mas garantimos que o Nome e MASP do pré-cadastro sejam usados como fallback.
    UPDATE public.profiles
    SET 
        school_id = v_school_id,
        role = 'teacher',
        full_name = COALESCE(full_name, v_full_name),
        masp = COALESCE(masp, v_masp),
        is_admin = false
    WHERE id = v_profile_id;

    -- Atualizar status no pré-cadastro (dispara o "desaparecimento" da lista pendente corretamente)
    UPDATE public.pending_teachers 
    SET status = 'matched', 
        matched_profile_id = v_profile_id,
        matched_at = NOW()
    WHERE id = p_pending_id;

    RETURN jsonb_build_object(
        'success', true, 
        'message', 'Professor aprovado e vinculado com sucesso à escola ' || v_school_id
    );

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;

-- 3. Corrigir Políticas RLS para evitar Recursão Infinita
-- Estas funções SECURITY DEFINER bypassam o RLS para leitura rápida de metadados
CREATE OR REPLACE FUNCTION public.get_auth_school_id()
RETURNS TEXT LANGUAGE sql SECURITY DEFINER AS $$
  SELECT school_id::text FROM public.profiles WHERE id = auth.uid();
$$;

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN LANGUAGE sql SECURITY DEFINER AS $$
  SELECT COALESCE((SELECT is_admin FROM public.profiles WHERE id = auth.uid()), false);
$$;

CREATE OR REPLACE FUNCTION public.get_auth_role()
RETURNS TEXT LANGUAGE sql SECURITY DEFINER AS $$
  SELECT role FROM public.profiles WHERE id = auth.uid();
$$;

-- Recriar política de visualização de colegas
DROP POLICY IF EXISTS "School Colleagues Read" ON public.profiles;
CREATE POLICY "School Colleagues Read" ON public.profiles
FOR SELECT TO authenticated
USING (
    (school_id IS NOT NULL AND school_id = public.get_auth_school_id())
    OR
    (public.is_admin() = true)
);

-- Recriar políticas para pending_teachers
DROP POLICY IF EXISTS "pending_teachers_select" ON public.pending_teachers;
CREATE POLICY "pending_teachers_select" ON public.pending_teachers
FOR SELECT TO authenticated
USING (
    public.is_admin() = true
    OR
    (public.get_auth_role() = 'manager' AND public.get_auth_school_id() = pending_teachers.school_id)
);

COMMIT;
