-- =============================================================================
-- Migration: FIX RECURSÃO RLS — Admin policies usando SECURITY DEFINER helpers
-- Projeto: PROFEPLAN V4
-- Data: 2026-06-20
-- Problema: 500 em TODAS as queries — recursão infinita RLS
-- Causa: Admin policies usavam EXISTS(SELECT FROM profiles) inline
-- Solução: Helper SECURITY DEFINER is_admin_safe() que bypassa RLS
-- =============================================================================

BEGIN;

-- =============================================================================
-- 1. HELPER FUNCTION: is_admin_safe (SECURITY DEFINER = bypass RLS)
--    Esta função NUNCA causa recursão porque roda como postgres
-- =============================================================================
CREATE OR REPLACE FUNCTION public.is_admin_safe()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
      AND (role = 'admin' OR is_admin = true)
  );
$$;
ALTER FUNCTION public.is_admin_safe() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.is_admin_safe() TO authenticated;

-- =============================================================================
-- 2. RECRIAR política SELECT admin usando is_admin_safe() (sem recursão)
-- =============================================================================
DROP POLICY IF EXISTS "Admins can view all profiles" ON public.profiles;

CREATE POLICY "Admins can view all profiles"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (public.is_admin_safe());

-- =============================================================================
-- 3. RECRIAR política UPDATE admin usando is_admin_safe()
-- =============================================================================
DROP POLICY IF EXISTS "Admins can update any profile" ON public.profiles;

CREATE POLICY "Admins can update any profile"
  ON public.profiles FOR UPDATE
  TO authenticated
  USING  (public.is_admin_safe())
  WITH CHECK (public.is_admin_safe());

-- =============================================================================
-- 4. RECRIAR política DELETE admin usando is_admin_safe()
-- =============================================================================
DROP POLICY IF EXISTS "Admins can delete any profile" ON public.profiles;

CREATE POLICY "Admins can delete any profile"
  ON public.profiles FOR DELETE
  TO authenticated
  USING (public.is_admin_safe());

-- =============================================================================
-- 5. ATUALIZAR RPCs para usar is_admin_safe() também
-- =============================================================================
CREATE OR REPLACE FUNCTION public.get_all_profiles_secure()
RETURNS SETOF public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_email text;
BEGIN
  SELECT email INTO v_email FROM auth.users WHERE id = auth.uid();

  IF NOT public.is_admin_safe() AND NOT public.is_hardcoded_admin(v_email) THEN
    RAISE EXCEPTION 'Acesso negado: apenas administradores.';
  END IF;

  RETURN QUERY SELECT * FROM public.profiles ORDER BY email;
END;
$$;
ALTER FUNCTION public.get_all_profiles_secure() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.get_all_profiles_secure() TO authenticated;

-- -------------------------------------------------

CREATE OR REPLACE FUNCTION public.admin_update_profile(
  p_target_id   uuid,
  p_tier        text DEFAULT NULL,
  p_credits     int DEFAULT NULL,
  p_is_unlimited boolean DEFAULT NULL,
  p_role        text DEFAULT NULL,
  p_is_admin    boolean DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_email text;
BEGIN
  SELECT email INTO v_email FROM auth.users WHERE id = auth.uid();

  IF NOT public.is_admin_safe() AND NOT public.is_hardcoded_admin(v_email) THEN
    RETURN jsonb_build_object('success', false, 'error', 'Acesso negado: apenas administradores.');
  END IF;

  UPDATE public.profiles SET
    tier          = COALESCE(p_tier, tier),
    credits       = COALESCE(p_credits, credits),
    is_unlimited  = COALESCE(p_is_unlimited, is_unlimited),
    role          = COALESCE(p_role, role),
    is_admin      = COALESCE(p_is_admin, is_admin),
    updated_at    = NOW()
  WHERE id = p_target_id;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Usuário não encontrado.');
  END IF;

  RETURN jsonb_build_object('success', true);
END;
$$;
ALTER FUNCTION public.admin_update_profile(uuid, text, int, boolean, text, boolean) OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.admin_update_profile(uuid, text, int, boolean, text, boolean) TO authenticated;

-- -------------------------------------------------

CREATE OR REPLACE FUNCTION public.admin_add_credits(
  p_target_id uuid,
  p_amount    int
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_email   text;
  v_current int;
BEGIN
  SELECT email INTO v_email FROM auth.users WHERE id = auth.uid();

  IF NOT public.is_admin_safe() AND NOT public.is_hardcoded_admin(v_email) THEN
    RETURN jsonb_build_object('success', false, 'error', 'Acesso negado: apenas administradores.');
  END IF;

  IF p_amount <= 0 OR p_amount > 1000 THEN
    RETURN jsonb_build_object('success', false, 'error', 'Valor inválido. Deve ser entre 1 e 1000 créditos.');
  END IF;

  SELECT credits INTO v_current
  FROM public.profiles
  WHERE id = p_target_id;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', false, 'error', 'Usuário não encontrado.');
  END IF;

  UPDATE public.profiles SET
    credits    = COALESCE(v_current, 0) + p_amount,
    updated_at = NOW()
  WHERE id = p_target_id;

  RETURN jsonb_build_object('success', true, 'new_credits', COALESCE(v_current, 0) + p_amount);
END;
$$;
ALTER FUNCTION public.admin_add_credits(uuid, int) OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.admin_add_credits(uuid, int) TO authenticated;

-- =============================================================================
-- 6. GARANTIR flags admin
-- =============================================================================
UPDATE public.profiles
SET
  role         = 'admin',
  is_admin     = true,
  tier         = 'GOLD',
  credits      = 9999,
  is_unlimited = true,
  updated_at   = NOW()
WHERE email IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br');

-- =============================================================================
-- 7. VERIFICAÇÃO FINAL
-- =============================================================================
DO $$
DECLARE
  policy_count int;
BEGIN
  SELECT COUNT(*) INTO policy_count
  FROM pg_policies
  WHERE schemaname = 'public' AND tablename = 'profiles';

  RAISE NOTICE '✅ Políticas ativas em profiles: %', policy_count;

  -- Testa a helper function (deve retornar true para admin)
  RAISE NOTICE '🔍 is_admin_safe() está disponível e sem recursão.';
END;
$$;

COMMIT;
