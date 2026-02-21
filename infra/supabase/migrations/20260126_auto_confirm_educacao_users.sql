-- Migration: Auto-confirm users with @educacao.mg.gov.br email
-- Date: 2026-01-26

-- Function to check and confirm email
CREATE OR REPLACE FUNCTION public.auto_confirm_educacao_email()
RETURNS TRIGGER AS $$
BEGIN
  -- Check if the email ends with @educacao.mg.gov.br
  IF NEW.email LIKE '%@educacao.mg.gov.br' THEN
    -- Auto-confirm the email
    NEW.email_confirmed_at := CURRENT_TIMESTAMP;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger on auth.users
-- We drop it first to ensure idempotency during development
DROP TRIGGER IF EXISTS on_auth_user_created_auto_confirm ON auth.users;

CREATE TRIGGER on_auth_user_created_auto_confirm
  BEFORE INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.auto_confirm_educacao_email();
