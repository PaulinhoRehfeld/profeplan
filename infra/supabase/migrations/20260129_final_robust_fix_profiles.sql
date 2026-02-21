-- ==============================================================================
-- FIX ESTRUTURAL DEFINITIVO: TABELA PROFILES & VISIBILIDADE
-- DATA: 2026-01-29
-- OBJETIVO: Garantir colunas, limpar dados e fixar RLS.
-- ==============================================================================

BEGIN;

-- 1. Assegurar Colunas Necessárias na tabela Profiles
-- Muitas queries as solicitam, então elas DEVEM existir.
DO $$ 
BEGIN 
    ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS email TEXT;
    ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS role TEXT DEFAULT 'teacher';
    ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS masp TEXT;
    ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS is_admin BOOLEAN DEFAULT false;
    ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT now();
EXCEPTION
    WHEN OTHERS THEN NULL;
END $$;

-- 2. Normalização de Roles e Constraints
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_role_check;
ALTER TABLE public.profiles ADD CONSTRAINT profiles_role_check 
CHECK (role IN ('teacher', 'manager', 'school_manager', 'admin', 'school_admin'));

-- 3. Limpeza Profunda de Dados (Defensiva)
UPDATE public.profiles 
SET 
    school_id = TRIM(BOTH FROM regexp_replace(school_id::text, '[\n\r\t]+', '', 'g')),
    email = TRIM(BOTH FROM LOWER(regexp_replace(email, '[\n\r\t]+', '', 'g'))),
    role = TRIM(BOTH FROM role)
WHERE school_id IS NOT NULL OR email IS NOT NULL;

-- 4. Funções de Apoio RLS com TRIM
CREATE OR REPLACE FUNCTION public.get_auth_school_id()
RETURNS TEXT LANGUAGE sql SECURITY DEFINER AS $$
  SELECT TRIM(BOTH FROM school_id::text) FROM public.profiles WHERE id = auth.uid();
$$;

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN LANGUAGE sql SECURITY DEFINER AS $$
  SELECT COALESCE((SELECT is_admin FROM public.profiles WHERE id = auth.uid()), false);
$$;

-- 5. Atualizar Políticas de RLS para Profiles (VISIBILIDADE TOTAL NA ESCOLA)
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;
DROP POLICY IF EXISTS "School Colleagues Read" ON public.profiles;
DROP POLICY IF EXISTS "allow_select_within_school" ON public.profiles;

CREATE POLICY "Allow school visibility" 
ON public.profiles FOR SELECT 
TO authenticated 
USING (
    public.is_admin() = true
    OR (school_id IS NOT NULL AND TRIM(school_id) = public.get_auth_school_id())
    OR (id = auth.uid())
);

-- 6. Garantir que o RPC de aprovação use os novos padrões
CREATE OR REPLACE FUNCTION public.approve_teacher(p_pending_id UUID)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    v_email TEXT;
    v_school_id TEXT;
    v_full_name TEXT;
    v_masp TEXT;
    v_profile_id UUID;
BEGIN
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

    -- Localizar por e-mail no profiles ou auth.users (fallback)
    SELECT id INTO v_profile_id FROM public.profiles WHERE LOWER(TRIM(email)) = v_email;

    IF v_profile_id IS NULL THEN
        -- Tentar buscar na auth.users se não estiver no profile
        RETURN jsonb_build_object('success', false, 'error', 'O perfil para o e-mail ' || v_email || ' ainda não foi criado. O professor precisa logar uma vez.');
    END IF;

    UPDATE public.profiles
    SET 
        school_id = v_school_id,
        role = 'teacher',
        full_name = COALESCE(full_name, v_full_name),
        masp = COALESCE(masp, v_masp),
        email = COALESCE(email, v_email)
    WHERE id = v_profile_id;

    UPDATE public.pending_teachers 
    SET status = 'matched', matched_profile_id = v_profile_id, matched_at = NOW()
    WHERE id = p_pending_id;

    RETURN jsonb_build_object('success', true, 'message', 'Professor vinculado com sucesso!');
END;
$$;

COMMIT;
