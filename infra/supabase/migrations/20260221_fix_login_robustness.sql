-- Migration: Fix Login Robustness (Case-Insensitive Auto-Confirm)
-- Date: 2026-02-21
-- Description: Updates auto-confirm for @educacao.mg.gov.br to be case-insensitive and retroactively confirms accounts created today.

-- 1. Fix Case Sensitivity in Auto-Confirm Function
CREATE OR REPLACE FUNCTION public.auto_confirm_educacao_email()
RETURNS TRIGGER AS $$
BEGIN
  -- Use ILIKE for case-insensitive matching
  IF NEW.email ILIKE '%@educacao.mg.gov.br' THEN
    NEW.email_confirmed_at := CURRENT_TIMESTAMP;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Retroactive Confirmation for skipping today
-- This ensures anyone who signed up with uppercase letters today is now confirmed
UPDATE auth.users
SET email_confirmed_at = created_at
WHERE email ILIKE '%@educacao.mg.gov.br'
AND email_confirmed_at IS NULL
AND created_at >= CURRENT_DATE;

-- 3. Ensure profiles are up to date with GOLD status
-- (Re-running this logic to catch accounts confirmed in the previous step)
UPDATE public.profiles
SET 
  tier = 'GOLD',
  is_unlimited = true,
  credits = 9999
WHERE email ILIKE '%@educacao.mg.gov.br'
AND (tier IS DISTINCT FROM 'GOLD' OR is_unlimited = false);

-- 4. Verify results (for SQL Editor output)
SELECT 
  count(*) as users_confirmed_retroactively
FROM auth.users 
WHERE email ILIKE '%@educacao.mg.gov.br' 
AND created_at >= CURRENT_DATE;
