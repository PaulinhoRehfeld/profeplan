-- ==============================================================================
-- PATCH: update_my_profile RPC — versão robusta com tratamento de erros
-- Data: 2026-07-09
-- Execute APENAS esta função se a RPC já existir.
-- Isso substitui a versão anterior por uma mais resiliente.
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.update_my_profile(p_updates jsonb)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_uid uuid := auth.uid();
  v_email text;
  v_target_id uuid;
  v_result public.profiles;
BEGIN
  -- Tenta auth.uid() primeiro
  IF v_uid IS NULL THEN
    -- Fallback: tenta extrair o email do próprio p_updates
    v_email := p_updates->>'email';
    IF v_email IS NULL OR v_email = '' THEN
      RAISE EXCEPTION 'Não autenticado e sem email nos updates';
    END IF;
    -- Busca o perfil pelo email informado
    SELECT id INTO v_target_id
      FROM public.profiles
     WHERE lower(email) = lower(v_email)
     ORDER BY created_at DESC
     LIMIT 1;
  ELSE
    SELECT email INTO v_email FROM auth.users WHERE id = v_uid;

    -- 1. Tenta achar a linha pelo id do auth
    SELECT id INTO v_target_id FROM public.profiles WHERE id = v_uid;

    -- 2. Ghost ID: se não houver linha para o auth.uid(), procura por email
    IF v_target_id IS NULL AND v_email IS NOT NULL THEN
      SELECT id INTO v_target_id
        FROM public.profiles
       WHERE lower(email) = lower(v_email)
       ORDER BY created_at DESC
       LIMIT 1;
    END IF;
  END IF;

  -- 3. Se ainda não existe, cria a linha
  IF v_target_id IS NULL THEN
    BEGIN
      INSERT INTO public.profiles (id, email, role, tier, credits, is_unlimited, created_at, updated_at)
      VALUES (COALESCE(v_uid, gen_random_uuid()), v_email, 'teacher', 'GOLD', 9999, true, NOW(), NOW())
      RETURNING id INTO v_target_id;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE EXCEPTION 'Falha ao criar perfil: % (id=%, email=%)', SQLERRM, v_uid, v_email;
    END;
  END IF;

  -- 4. Aplica as alterações (COALESCE + NULLIF para tratar strings vazias como NULL)
  BEGIN
    UPDATE public.profiles SET
      full_name            = COALESCE(NULLIF(p_updates->>'full_name', ''), full_name),
      email                = COALESCE(NULLIF(p_updates->>'email', ''), email),
      masp                 = COALESCE(NULLIF(p_updates->>'masp', ''), masp),
      city                 = COALESCE(NULLIF(p_updates->>'city', ''), city),
      favorite_methodology = COALESCE(NULLIF(p_updates->>'favorite_methodology', ''), favorite_methodology),
      teaching_style       = COALESCE(NULLIF(p_updates->>'teaching_style', ''), teaching_style),
      assessment_focus     = COALESCE(NULLIF(p_updates->>'assessment_focus', ''), assessment_focus),
      tone_of_voice        = COALESCE(NULLIF(p_updates->>'tone_of_voice', ''), tone_of_voice),
      header_text          = COALESCE(NULLIF(p_updates->>'header_text', ''), header_text),
      footer_text          = COALESCE(NULLIF(p_updates->>'footer_text', ''), footer_text),
      logo_base64          = COALESCE(NULLIF(p_updates->>'logo_base64', ''), logo_base64),
      updated_at           = NOW()
    WHERE id = v_target_id
    RETURNING * INTO v_result;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE EXCEPTION 'Falha ao atualizar perfil (id=%): %', v_target_id, SQLERRM;
  END;

  RETURN v_result;
END;
$$;

ALTER FUNCTION public.update_my_profile(jsonb) OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.update_my_profile(jsonb) TO authenticated;

-- Verificação rápida
DO $$
DECLARE
  rpc_exists boolean;
BEGIN
  SELECT EXISTS (
    SELECT 1 FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'public' AND p.proname = 'update_my_profile'
  ) INTO rpc_exists;
  
  IF rpc_exists THEN
    RAISE NOTICE '✅ RPC update_my_profile ATUALIZADA com sucesso.';
  ELSE
    RAISE EXCEPTION '❌ RPC update_my_profile NÃO foi criada!';
  END IF;
END;
$$;
