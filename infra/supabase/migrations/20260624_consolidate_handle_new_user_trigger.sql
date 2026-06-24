-- ============================================================
-- FIX: Consolidar trigger handle_new_user (versão definitiva)
-- Date: 2026-06-24
-- Problema: Três migrations conflitantes em datas diferentes definiam
-- comportamentos diferentes para novos usuários:
--   - 20260221_default_gold_new_users.sql  → tier=GOLD, credits=9999
--   - 20260616_fix_admin_and_default_credits.sql → tier=FREE, credits=10
--   - 20260616_fix_profile_sync_trigger.sql → tier=GOLD, credits=9999 (sobrescreve)
-- Estado atual em produção: GOLD/9999 (última migration aplicada).
-- Esta migration torna explícito o comportamento definitivo e remove ambiguidade.
-- ============================================================

BEGIN;

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
    'GOLD',    -- Período promocional: novos usuários recebem GOLD
    true,
    9999,
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO UPDATE SET
    email        = EXCLUDED.email,
    full_name    = COALESCE(profiles.full_name, EXCLUDED.full_name),
    tier         = CASE WHEN profiles.tier IS NULL THEN 'GOLD' ELSE profiles.tier END,
    is_unlimited = CASE WHEN profiles.is_unlimited IS NULL THEN true ELSE profiles.is_unlimited END,
    credits      = CASE WHEN profiles.credits IS NULL OR profiles.credits = 0 THEN 9999 ELSE profiles.credits END,
    updated_at   = NOW();

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Nunca bloquear cadastro por erro de criação de profile
    RAISE WARNING 'handle_new_user failed for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$;

-- Re-apply trigger (garante que aponta para a versão acima)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE PROCEDURE public.handle_new_user();

COMMIT;
