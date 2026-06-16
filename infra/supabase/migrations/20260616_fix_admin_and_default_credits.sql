-- ============================================================
-- FIX: Restore admin account + Set default 10 credits for new users
-- Date: 2026-06-16
-- ============================================================

BEGIN;

-- ────────────────────────────────────────────────────────────
-- 1. RESTORE ADMIN: prehfeld@hotmail.com
--    Master admin with unlimited GOLD + is_admin flag
-- ────────────────────────────────────────────────────────────
UPDATE public.profiles
SET
    role         = 'admin',
    is_admin     = true,
    tier         = 'GOLD',
    is_unlimited = true,
    credits      = 9999,
    updated_at   = NOW()
WHERE email = 'prehfeld@hotmail.com';

-- Also restore suporte@profeplan.com.br if it exists
UPDATE public.profiles
SET
    role         = 'admin',
    is_admin     = true,
    tier         = 'GOLD',
    is_unlimited = true,
    credits      = 9999,
    updated_at   = NOW()
WHERE email = 'suporte@profeplan.com.br';

-- ────────────────────────────────────────────────────────────
-- 2. UPDATE TRIGGER: New users get 10 credits (not 9999)
--    Admins are handled separately (hardcoded list in app)
-- ────────────────────────────────────────────────────────────
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
    'FREE',        -- New users start as FREE tier
    false,         -- Not unlimited
    10,            -- 10 bonus credits for new users
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO UPDATE SET
    email        = EXCLUDED.email,
    full_name    = COALESCE(profiles.full_name, EXCLUDED.full_name),
    tier         = CASE WHEN profiles.tier IS NULL THEN 'FREE' ELSE profiles.tier END,
    is_unlimited = CASE WHEN profiles.is_unlimited IS NULL THEN false ELSE profiles.is_unlimited END,
    credits      = CASE WHEN profiles.credits IS NULL OR profiles.credits = 0 THEN 10 ELSE profiles.credits END,
    updated_at   = NOW();

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'handle_new_user failed for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$;

-- Re-apply trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE PROCEDURE public.handle_new_user();

COMMIT;

-- ────────────────────────────────────────────────────────────
-- VERIFY
-- ────────────────────────────────────────────────────────────
SELECT email, role, is_admin, tier, is_unlimited, credits
FROM public.profiles
WHERE email IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br');
