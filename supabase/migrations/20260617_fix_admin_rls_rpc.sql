-- =============================================================================
-- Migration: FIX COMPLETO — Recursão RLS + Admin + Write Policies + RPC
-- Projeto: PROFEPLAN V4
-- Data: 2026-06-17
-- IDEMPOTENTE: pode ser executado múltiplas vezes com segurança
-- COMO USAR: Cole no Supabase SQL Editor e execute como service_role
-- =============================================================================

BEGIN;

-- =============================================================================
-- 1. HELPER FUNCTIONS (SECURITY DEFINER = roda como postgres, bypassa RLS)
--    DEVE ser criado ANTES das políticas que o usam
-- =============================================================================

CREATE OR REPLACE FUNCTION public.get_my_school_id_safe()
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_school_id text;
BEGIN
    SELECT school_id::text INTO v_school_id
    FROM public.profiles
    WHERE id = auth.uid();
    RETURN v_school_id;
END;
$$;
ALTER FUNCTION public.get_my_school_id_safe() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.get_my_school_id_safe() TO authenticated;

-- -------------------------------------------------

CREATE OR REPLACE FUNCTION public.is_manager_or_admin_safe()
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
      AND role IN ('school_manager', 'school_admin', 'manager', 'admin')
  );
END;
$$;
ALTER FUNCTION public.is_manager_or_admin_safe() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.is_manager_or_admin_safe() TO authenticated;

-- -------------------------------------------------

CREATE OR REPLACE FUNCTION public.get_all_profiles_secure()
RETURNS SETOF public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
      AND (is_admin = true OR role = 'admin')
  ) THEN
    RAISE EXCEPTION 'Acesso negado: apenas administradores.';
  END IF;
  RETURN QUERY SELECT * FROM public.profiles ORDER BY email;
END;
$$;
ALTER FUNCTION public.get_all_profiles_secure() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.get_all_profiles_secure() TO authenticated;

-- -------------------------------------------------

CREATE OR REPLACE FUNCTION public.is_hardcoded_admin(p_email text)
RETURNS boolean
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT p_email = ANY(ARRAY['prehfeld@hotmail.com', 'suporte@profeplan.com.br']);
$$;
GRANT EXECUTE ON FUNCTION public.is_hardcoded_admin(text) TO authenticated;

-- =============================================================================
-- 2. LIMPAR *TODAS* AS POLÍTICAS EXISTENTES EM profiles
--    (inclui legadas que causam recursão — sem exceção)
-- =============================================================================

DO $$
DECLARE
    pol RECORD;
BEGIN
    FOR pol IN
        SELECT policyname
        FROM pg_policies
        WHERE schemaname = 'public' AND tablename = 'profiles'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.profiles', pol.policyname);
        RAISE NOTICE 'Política removida: %', pol.policyname;
    END LOOP;
END;
$$;

-- =============================================================================
-- 3. ATIVAR RLS E RECRIAR POLÍTICAS LIMPAS (sem recursão)
-- =============================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- SELECT: próprio perfil ou colegas da mesma escola
CREATE POLICY "profiles_select" ON public.profiles
  FOR SELECT TO authenticated
  USING (
    id = auth.uid()
    OR school_id::text = public.get_my_school_id_safe()
  );

-- INSERT: usuário cria apenas seu próprio perfil
CREATE POLICY "profiles_insert_own" ON public.profiles
  FOR INSERT TO authenticated
  WITH CHECK (id = auth.uid());

-- UPDATE: usuário atualiza apenas seu próprio perfil
CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE TO authenticated
  USING  (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- =============================================================================
-- 4. GARANTIR STATUS ADMIN PARA EMAILS HARDCODED
-- =============================================================================

UPDATE public.profiles
SET
  role         = 'admin',
  is_admin     = true,
  tier         = 'GOLD',
  credits      = 9999,
  is_unlimited = true
WHERE email IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br');

-- =============================================================================
-- 5. VERIFICAÇÃO FINAL
-- =============================================================================

DO $$
DECLARE
  admin_count  int;
  policy_count int;
BEGIN
  SELECT COUNT(*) INTO admin_count
  FROM public.profiles
  WHERE email IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br')
    AND is_admin = true AND role = 'admin';

  SELECT COUNT(*) INTO policy_count
  FROM pg_policies
  WHERE schemaname = 'public' AND tablename = 'profiles';

  RAISE NOTICE '✅ Admins configurados: % | Políticas ativas em profiles: %',
    admin_count, policy_count;
END;
$$;

COMMIT;
