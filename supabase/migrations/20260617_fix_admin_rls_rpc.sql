-- =============================================================================
-- Migration: Fix Admin Status + RLS Write Policies + Admin RPC
-- Projeto: PROFEPLAN V4
-- Data: 2026-06-17
-- =============================================================================

BEGIN;

-- =============================================================================
-- 1. GARANTIR STATUS ADMIN PARA EMAILS HARDCODED
-- =============================================================================

UPDATE public.profiles
SET
  role        = 'admin',
  is_admin    = true,
  tier        = 'GOLD',
  credits     = 9999,
  is_unlimited = true
WHERE email IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br');

-- =============================================================================
-- 2. POLÍTICAS RLS DE ESCRITA PARA PROFILES (faltavam na migration anterior)
-- =============================================================================

-- UPDATE: usuário pode atualizar seu próprio perfil
DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;
CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE
  TO authenticated
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- INSERT: qualquer autenticado pode criar seu próprio perfil (para upsert de emergência)
DROP POLICY IF EXISTS "profiles_insert_own" ON public.profiles;
CREATE POLICY "profiles_insert_own" ON public.profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (id = auth.uid());

-- =============================================================================
-- 3. FUNÇÃO: get_all_profiles_secure (Admin RPC — bypassa RLS)
--    Permite ao AdminPanel listar todos os usuários sem ser bloqueado por RLS
-- =============================================================================

CREATE OR REPLACE FUNCTION public.get_all_profiles_secure()
RETURNS SETOF public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Apenas admins podem chamar esta função
  IF NOT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
      AND (is_admin = true OR role = 'admin')
  ) THEN
    RAISE EXCEPTION 'Acesso negado: apenas administradores podem listar todos os perfis.';
  END IF;

  RETURN QUERY SELECT * FROM public.profiles ORDER BY email;
END;
$$;

ALTER FUNCTION public.get_all_profiles_secure() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.get_all_profiles_secure() TO authenticated;

-- =============================================================================
-- 4. FUNÇÃO: is_hardcoded_admin (Helper server-side para RLS futuras)
-- =============================================================================

CREATE OR REPLACE FUNCTION public.is_hardcoded_admin(p_email text)
RETURNS boolean
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT p_email = ANY(ARRAY['prehfeld@hotmail.com', 'suporte@profeplan.com.br']);
$$;

GRANT EXECUTE ON FUNCTION public.is_hardcoded_admin(text) TO authenticated;

-- =============================================================================
-- 5. GARANTIR QUE RLS ESTÁ ATIVO NAS TABELAS CRÍTICAS
-- =============================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- =============================================================================
-- 6. VERIFICAÇÃO FINAL
-- =============================================================================

DO $$
DECLARE
  admin_count int;
BEGIN
  SELECT COUNT(*) INTO admin_count
  FROM public.profiles
  WHERE email IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br')
    AND is_admin = true
    AND role = 'admin';

  RAISE NOTICE 'Admins configurados corretamente: %', admin_count;
END;
$$;

COMMIT;
