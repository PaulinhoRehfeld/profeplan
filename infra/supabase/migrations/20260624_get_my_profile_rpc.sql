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

  -- Resolve o email do usuário autenticado (necessário para o fallback Ghost ID)
  SELECT email INTO v_email FROM auth.users WHERE id = v_uid;

  -- 1. Lookup canônico: id = auth.uid()
  SELECT * INTO v_row FROM public.profiles WHERE id = v_uid LIMIT 1;

  -- Se encontrou por id mas credits é NULL, pode ser um perfil vazio criado pelo
  -- trigger de novo usuário. Tenta encontrar um perfil mais completo pelo email.
  IF FOUND AND v_row.credits IS NOT NULL THEN
    RETURN v_row;
  END IF;

  -- 2. Ghost ID / perfil enriquecido: busca pelo email, preferindo o com mais créditos
  IF v_email IS NOT NULL THEN
    DECLARE v_rich public.profiles;
    BEGIN
      SELECT * INTO v_rich
      FROM public.profiles
      WHERE lower(email) = lower(v_email)
        AND credits IS NOT NULL
      ORDER BY credits DESC, created_at DESC
      LIMIT 1;

      IF FOUND THEN
        RETURN v_rich;
      END IF;
    END;
  END IF;

  -- 3. Último recurso: retorna o perfil por id mesmo com credits NULL
  IF FOUND THEN
    RETURN v_row;
  END IF;

  RETURN NULL;
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_my_profile() TO authenticated;
COMMENT ON FUNCTION public.get_my_profile() IS
  'Lê o perfil do usuário autenticado contornando RLS. '
  'Resolve Ghost ID por email quando auth.uid() ≠ profiles.id.';
