-- ============================================================
-- RPC: update_my_profile — salvar o próprio perfil com segurança
-- Date: 2026-06-24
-- Problema: quando o auth.uid() da sessão não tem linha em `profiles`
--   (Ghost ID: a linha existe sob um id antigo, recuperada por email),
--   o UPDATE afeta 0 linhas e o UPSERT viola a RLS WITH CHECK (auth.uid()=id).
--   Resultado: "new row violates row-level security policy for table profiles".
--
-- Solução: função SECURITY DEFINER que usa auth.uid() (confiável no servidor),
--   localiza a linha do usuário por id OU por email (ghost), cria se faltar,
--   e aplica as alterações. Não altera a PK de linhas existentes (evita quebrar
--   foreign keys). Escopo restrito ao próprio usuário autenticado.
-- ============================================================

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
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Não autenticado';
  END IF;

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

  -- 3. Se ainda não existe, cria a linha com o id do auth
  IF v_target_id IS NULL THEN
    INSERT INTO public.profiles (id, email)
    VALUES (v_uid, v_email)
    RETURNING id INTO v_target_id;
  END IF;

  -- 4. Aplica as alterações (COALESCE mantém o valor atual quando a chave não vem)
  UPDATE public.profiles SET
    full_name            = COALESCE(p_updates->>'full_name', full_name),
    email                = COALESCE(p_updates->>'email', email),
    masp                 = COALESCE(p_updates->>'masp', masp),
    city                 = COALESCE(p_updates->>'city', city),
    favorite_methodology = COALESCE(p_updates->>'favorite_methodology', favorite_methodology),
    teaching_style       = COALESCE(p_updates->>'teaching_style', teaching_style),
    assessment_focus     = COALESCE(p_updates->>'assessment_focus', assessment_focus),
    tone_of_voice        = COALESCE(p_updates->>'tone_of_voice', tone_of_voice),
    header_text          = COALESCE(p_updates->>'header_text', header_text),
    footer_text          = COALESCE(p_updates->>'footer_text', footer_text),
    logo_base64          = COALESCE(p_updates->>'logo_base64', logo_base64),
    updated_at           = NOW()
  WHERE id = v_target_id
  RETURNING * INTO v_result;

  RETURN v_result;
END;
$$;

GRANT EXECUTE ON FUNCTION public.update_my_profile(jsonb) TO authenticated;
