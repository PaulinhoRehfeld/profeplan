-- ===========================================================================
-- get_my_profile() — SECURITY DEFINER
-- Lê o perfil do usuário autenticado sem depender de RLS.
--
-- CONTEXTO: A política de RLS em `profiles` é USING (auth.uid() = id).
-- Para usuários com Ghost ID (auth.uid() ≠ profiles.id, criado antes da
-- migração de UUID), qualquer SELECT direto retorna 0 linhas — tanto por ID
-- quanto por email — porque o row-filter bloqueia a linha do perfil real.
-- Esta função bypassa o RLS com SECURITY DEFINER e resolve pelo auth.uid()
-- primeiro; se não encontrar, faz fallback por email (ghost-id recovery).
-- ===========================================================================

CREATE OR REPLACE FUNCTION public.get_my_profile()
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_uid   uuid := auth.uid();
  v_email text;
  v_row   public.profiles;
BEGIN
  IF v_uid IS NULL THEN
    RETURN NULL;
  END IF;

  -- 1. Lookup canônico: id = auth.uid()
  SELECT * INTO v_row FROM public.profiles WHERE id = v_uid LIMIT 1;
  IF FOUND THEN
    RETURN v_row;
  END IF;

  -- 2. Ghost ID fallback: resolve por email
  SELECT email INTO v_email FROM auth.users WHERE id = v_uid;

  IF v_email IS NOT NULL THEN
    SELECT * INTO v_row
    FROM public.profiles
    WHERE lower(email) = lower(v_email)
    ORDER BY created_at DESC
    LIMIT 1;

    IF FOUND THEN
      RETURN v_row;
    END IF;
  END IF;

  RETURN NULL;
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_my_profile() TO authenticated;
COMMENT ON FUNCTION public.get_my_profile() IS
  'Lê o perfil do usuário autenticado contornando RLS. '
  'Resolve Ghost ID por email quando auth.uid() ≠ profiles.id.';
