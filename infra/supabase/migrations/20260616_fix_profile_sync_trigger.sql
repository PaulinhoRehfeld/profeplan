-- ============================================================
-- FIX: Robust Profile Sync & New User Trigger
-- Date: 2026-06-16
-- Problem: New users authenticate but no profile row is created,
--          causing "User not found in profiles. Blocking quota-protected action."
-- Solution:
--   1. Recreate handle_new_user trigger (bulletproof version)
--   2. Backfill any auth.users without a profile
--   3. Fix RLS policies that may block self-insert
-- ============================================================

BEGIN;

-- ────────────────────────────────────────────────────────────
-- 1. TRIGGER FUNCTION: handle_new_user (bulletproof)
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
      split_part(NEW.email, '@', 1)   -- fallback: part before @
    ),
    NEW.email,
    'teacher',
    'GOLD',       -- All new users start as GOLD (promotional period)
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
    -- Never block sign-up due to profile creation error
    RAISE WARNING 'handle_new_user failed for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$;

-- ────────────────────────────────────────────────────────────
-- 2. RE-APPLY TRIGGER (drop + create to ensure it's current)
-- ────────────────────────────────────────────────────────────
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE PROCEDURE public.handle_new_user();

-- ────────────────────────────────────────────────────────────
-- 3. BACKFILL: Create profiles for existing auth users
--    who are missing a profile row
-- ────────────────────────────────────────────────────────────
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
SELECT
  au.id,
  COALESCE(
    au.raw_user_meta_data->>'full_name',
    au.raw_user_meta_data->>'name',
    split_part(au.email, '@', 1)
  ),
  au.email,
  'teacher',
  'GOLD',
  true,
  9999,
  NOW(),
  NOW()
FROM auth.users au
LEFT JOIN public.profiles p ON p.id = au.id
WHERE p.id IS NULL;  -- Only users without a profile

-- ────────────────────────────────────────────────────────────
-- 4. FIX RLS: Ensure profiles policies allow self-insert
-- ────────────────────────────────────────────────────────────

-- Drop potentially conflicting policies
DROP POLICY IF EXISTS "Users can view own profile"    ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile"  ON public.profiles;
DROP POLICY IF EXISTS "Users insert own profile"      ON public.profiles;
DROP POLICY IF EXISTS "Service role full access"      ON public.profiles;

-- SELECT: user sees own profile
CREATE POLICY "Users can view own profile"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

-- UPDATE: user updates own profile
CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- INSERT: user can create own profile (needed for fallback client-side creation)
CREATE POLICY "Users insert own profile"
  ON public.profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Service role: full unrestricted access (for trigger + admin scripts)
CREATE POLICY "Service role full access"
  ON public.profiles FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Admin users: see all profiles
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

COMMIT;

-- ────────────────────────────────────────────────────────────
-- 5. VERIFY — run after applying
-- ────────────────────────────────────────────────────────────
SELECT
  'auth.users'       AS source,
  COUNT(*)           AS total
FROM auth.users
UNION ALL
SELECT
  'profiles'         AS source,
  COUNT(*)           AS total
FROM public.profiles
UNION ALL
SELECT
  'missing profiles' AS source,
  COUNT(*)           AS total
FROM auth.users au
LEFT JOIN public.profiles p ON p.id = au.id
WHERE p.id IS NULL;
