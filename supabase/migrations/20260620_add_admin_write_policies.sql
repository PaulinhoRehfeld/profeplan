-- =============================================================================
-- Migration: ADMIN WRITE — RPCs + RLS Policies (UPDATE + DELETE + CREDITS)
-- Projeto: PROFEPLAN V4
-- Data: 2026-06-20
-- Problema: Admin não conseguia alterar créditos/plano de usuários
-- Causa: RLS só permitia UPDATE com id = auth.uid()
-- Solução: RPCs SECURITY DEFINER (bypass RLS) + políticas RLS de fallback
-- =============================================================================

BEGIN;

-- =============================================================================
-- 1. RPC: admin_update_profile (bypass RLS via SECURITY DEFINER)
--    Permite admin alterar tier, credits, is_unlimited, role, is_admin em
--    qualquer perfil. Este é o caminho principal usado pelo frontend.
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
  v_is_admin boolean;
BEGIN
  -- Verifica se o caller é admin
  SELECT (role = 'admin' OR is_admin = true) INTO v_is_admin
  FROM public.profiles
  WHERE id = auth.uid();

  IF v_is_admin IS NOT true THEN
    RETURN jsonb_build_object('success', false, 'error', 'Acesso negado: apenas administradores.');
  END IF;

  -- Atualiza apenas os campos fornecidos (não-nulos)
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
-- 2. RPC: admin_add_credits (bypass RLS via SECURITY DEFINER)
--    Adiciona créditos ao saldo existente do usuário.
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
  v_is_admin   boolean;
  v_current    int;
BEGIN
  -- Verifica se o caller é admin
  SELECT (role = 'admin' OR is_admin = true) INTO v_is_admin
  FROM public.profiles
  WHERE id = auth.uid();

  IF v_is_admin IS NOT true THEN
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
-- 3. RLS Policies (fallback — caso alguém use update direto na tabela)
-- =============================================================================
DROP POLICY IF EXISTS "Admins can update any profile" ON public.profiles;

CREATE POLICY "Admins can update any profile"
  ON public.profiles FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles admin_p
      WHERE admin_p.id = auth.uid()
        AND (admin_p.role = 'admin' OR admin_p.is_admin = true)
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles admin_p
      WHERE admin_p.id = auth.uid()
        AND (admin_p.role = 'admin' OR admin_p.is_admin = true)
    )
  );

DROP POLICY IF EXISTS "Admins can delete any profile" ON public.profiles;

CREATE POLICY "Admins can delete any profile"
  ON public.profiles FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles admin_p
      WHERE admin_p.id = auth.uid()
        AND (admin_p.role = 'admin' OR admin_p.is_admin = true)
    )
  );

-- =============================================================================
-- 4. VERIFICAÇÃO
-- =============================================================================
DO $$
DECLARE
  policy_count int;
  rpc_count    int;
BEGIN
  SELECT COUNT(*) INTO policy_count
  FROM pg_policies
  WHERE schemaname = 'public' AND tablename = 'profiles';

  SELECT COUNT(*) INTO rpc_count
  FROM pg_proc
  WHERE proname IN ('admin_update_profile', 'admin_add_credits');

  RAISE NOTICE '✅ Políticas profiles: % | RPCs admin: %', policy_count, rpc_count;
END;
$$;

COMMIT;
