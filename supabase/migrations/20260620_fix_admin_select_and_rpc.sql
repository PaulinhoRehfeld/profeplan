-- =============================================================================
-- Migration: ADD ADMIN SELECT POLICY (corrige "Nenhum usuário encontrado")
-- Projeto: PROFEPLAN V4
-- Data: 2026-06-20
-- Problema: Admin não conseguia ver usuários no painel
-- Causa: 20260617 removeu "Admins can view all profiles" e não recriou
-- =============================================================================

BEGIN;

-- =============================================================================
-- 1. ADMIN SELECT: permite admin ver TODOS os perfis
-- =============================================================================
DROP POLICY IF EXISTS "Admins can view all profiles" ON public.profiles;

CREATE POLICY "Admins can view all profiles"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles admin_p
      WHERE admin_p.id = auth.uid()
        AND (admin_p.role = 'admin' OR admin_p.is_admin = true)
    )
  );

-- =============================================================================
-- 2. REPARA get_all_profiles_secure: fallback por email hardcoded
--    Caso o flag is_admin/role não esteja setado, ainda permite acesso
--    pelos emails master (prehfeld@hotmail.com, suporte@profeplan.com.br)
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
  -- Obtém o email do usuário autenticado
  SELECT email INTO v_email FROM auth.users WHERE id = auth.uid();

  -- Verifica se é admin por flag OU por email hardcoded
  IF NOT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
      AND (is_admin = true OR role = 'admin')
  ) AND NOT public.is_hardcoded_admin(v_email) THEN
    RAISE EXCEPTION 'Acesso negado: apenas administradores.';
  END IF;

  RETURN QUERY SELECT * FROM public.profiles ORDER BY email;
END;
$$;
ALTER FUNCTION public.get_all_profiles_secure() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.get_all_profiles_secure() TO authenticated;

-- =============================================================================
-- 3. REPARA admin_update_profile e admin_add_credits com mesmo fallback
-- =============================================================================
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
  v_email    text;
  v_is_admin boolean;
BEGIN
  SELECT email INTO v_email FROM auth.users WHERE id = auth.uid();

  SELECT (role = 'admin' OR is_admin = true) INTO v_is_admin
  FROM public.profiles
  WHERE id = auth.uid();

  IF v_is_admin IS NOT true AND NOT public.is_hardcoded_admin(v_email) THEN
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

-- =============================================================================

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
  v_email    text;
  v_is_admin boolean;
  v_current  int;
BEGIN
  SELECT email INTO v_email FROM auth.users WHERE id = auth.uid();

  SELECT (role = 'admin' OR is_admin = true) INTO v_is_admin
  FROM public.profiles
  WHERE id = auth.uid();

  IF v_is_admin IS NOT true AND NOT public.is_hardcoded_admin(v_email) THEN
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
-- 4. GARANTIR que os admins hardcoded tenham os flags corretos
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
-- 5. VERIFICAÇÃO
-- =============================================================================
DO $$
DECLARE
  policy_count int;
  rpc_count    int;
  admin_count  int;
BEGIN
  SELECT COUNT(*) INTO policy_count
  FROM pg_policies
  WHERE schemaname = 'public' AND tablename = 'profiles';

  SELECT COUNT(*) INTO rpc_count
  FROM pg_proc
  WHERE proname IN ('admin_update_profile', 'admin_add_credits', 'get_all_profiles_secure');

  SELECT COUNT(*) INTO admin_count
  FROM public.profiles
  WHERE email IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br')
    AND is_admin = true AND role = 'admin';

  RAISE NOTICE '✅ Políticas: % | RPCs admin: % | Admins configurados: %',
    policy_count, rpc_count, admin_count;
END;
$$;

COMMIT;
