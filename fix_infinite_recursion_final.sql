-- ==============================================================================
-- SOLUÇÃO DEFINITIVA PARA RECURSÃO INFINITA
-- ==============================================================================
-- O erro ocorre porque as políticas de segurança estão perguntando para a própria tabela 
-- "quem é você?", criando um loop (Recursão).
-- Vamos criar funções "Bypass" (Security Definer) que leem os dados sem ativar as regras.

-- 1. Funções Auxiliares (Bypass RLS)
-- =================================================

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

GRANT EXECUTE ON FUNCTION public.get_auth_school_id() TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_auth_role() TO authenticated;

-- 2. Corrigir PROFILES (Onde o loop acontece)
-- =================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Removemos TODAS as políticas antigas para garantir
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Admins full access" ON public.profiles;
DROP POLICY IF EXISTS "School Colleagues View" ON public.profiles;

-- Recriamos SEM subqueries (usando as funções)

-- a) Admin vê tudo e edita tudo
CREATE POLICY "Admins Full Access" ON public.profiles
FOR ALL USING ( public.is_admin() = true );

-- b) Usuário vê e edita seu próprio perfil
CREATE POLICY "Users Own Profile" ON public.profiles
FOR ALL USING ( id = auth.uid() );

-- c) Colegas da mesma escola podem ver (LEITURA APENAS)
CREATE POLICY "School Colleagues Read" ON public.profiles
FOR SELECT USING (
    school_id = public.get_auth_school_id()
);

-- 3. Corrigir PENDING_TEACHERS (Usando as funções rápidas)
-- =================================================

DROP POLICY IF EXISTS "pending_teachers_select_managers" ON public.pending_teachers;
DROP POLICY IF EXISTS "pending_teachers_insert_managers" ON public.pending_teachers;
DROP POLICY IF EXISTS "pending_teachers_update_managers" ON public.pending_teachers;
DROP POLICY IF EXISTS "pending_teachers_delete_managers" ON public.pending_teachers;

-- INSERT
CREATE POLICY "pending_teachers_insert" ON public.pending_teachers
FOR INSERT TO authenticated
WITH CHECK (
    public.is_admin() = true
    OR
    (public.get_auth_role() = 'manager' AND public.get_auth_school_id() = pending_teachers.school_id::text)
);

-- SELECT
CREATE POLICY "pending_teachers_select" ON public.pending_teachers
FOR SELECT TO authenticated
USING (
    public.is_admin() = true
    OR
    (public.get_auth_role() = 'manager' AND public.get_auth_school_id() = pending_teachers.school_id::text)
);

-- UPDATE
CREATE POLICY "pending_teachers_update" ON public.pending_teachers
FOR UPDATE TO authenticated
USING (
    public.is_admin() = true
    OR
    (public.get_auth_role() = 'manager' AND public.get_auth_school_id() = pending_teachers.school_id::text)
);

-- DELETE
CREATE POLICY "pending_teachers_delete" ON public.pending_teachers
FOR DELETE TO authenticated
USING (
    public.is_admin() = true
    OR
    (public.get_auth_role() = 'manager' AND public.get_auth_school_id() = pending_teachers.school_id::text)
);

-- Final: Notificar sucesso
DO $$ BEGIN RAISE NOTICE 'Correção de recursão aplicada com sucesso!'; END $$;
