-- ==============================================================================
-- FIX: Novas contas começam FREE/10 créditos (fim do período promocional GOLD)
-- Date: 2026-07-13
-- ==============================================================================
-- Desde 20260624_consolidate_handle_new_user_trigger.sql, todo cadastro novo
-- recebia tier=GOLD, is_unlimited=true, credits=9999 ("período promocional").
-- Decisão do dono do produto: encerrar a promoção. A partir de agora toda
-- conta nova abre como FREE com 10 créditos, e só migra pra SILVER/GOLD
-- mediante pagamento real via Stripe (infra/supabase/functions/stripe-webhook,
-- que já faz UPDATE profiles SET tier='GOLD'/'SILVER' em checkout.session.completed
-- — esse fluxo não muda).
--
-- Rebaixamento das contas GOLD/SILVER promocionais já existentes é feito à
-- parte, em scripts/sql/2026-07-13_downgrade_teachers_to_free.sql (esta
-- migration só afeta cadastros NOVOS a partir de agora).
-- ==============================================================================

BEGIN;

-- 1. Trigger de novo usuário (auth.users → profiles)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (
    id,
    full_name,
    email,
    role,
    tier,
    is_unlimited,
    credits,
    created_at,
    updated_at
  )
  VALUES (
    NEW.id,
    COALESCE(
      NEW.raw_user_meta_data->>'full_name',
      NEW.raw_user_meta_data->>'name',
      split_part(NEW.email, '@', 1)
    ),
    NEW.email,
    'teacher',
    'FREE',
    false,
    10,
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO UPDATE SET
    email        = EXCLUDED.email,
    full_name    = COALESCE(profiles.full_name, EXCLUDED.full_name),
    tier         = CASE WHEN profiles.tier IS NULL THEN 'FREE' ELSE profiles.tier END,
    is_unlimited = CASE WHEN profiles.is_unlimited IS NULL THEN false ELSE profiles.is_unlimited END,
    credits      = CASE WHEN profiles.credits IS NULL THEN 10 ELSE profiles.credits END,
    updated_at   = NOW();

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Nunca bloquear cadastro por erro de criação de profile
    RAISE WARNING 'handle_new_user failed for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE PROCEDURE public.handle_new_user();

-- 2. RPC update_my_profile — mesmo fix no branch de "criação de emergência"
-- (dispara quando o usuário salva Configurações e a trigger acima, por algum
-- motivo, ainda não tinha criado a linha em profiles).
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
      VALUES (COALESCE(v_uid, gen_random_uuid()), v_email, 'teacher', 'FREE', 10, false, NOW(), NOW())
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

COMMIT;

-- Verificação rápida
DO $$
BEGIN
  RAISE NOTICE '✅ handle_new_user() e update_my_profile() agora criam contas novas como FREE/10 créditos.';
END;
$$;
