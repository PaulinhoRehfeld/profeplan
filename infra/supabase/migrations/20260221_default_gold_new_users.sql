-- Migration: Default GOLD for new users
-- Date: 2026-02-21
-- Description: Updates the handle_new_user trigger function to grant GOLD status (tier='GOLD', is_unlimited=true, credits=9999) to all new accounts.

-- Update the function
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  -- We include full_name and email from auth.users metadata/fields
  INSERT INTO public.profiles (
    id, 
    full_name, 
    email, 
    role, 
    tier, 
    is_unlimited, 
    credits
  )
  VALUES (
    NEW.id, 
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''), 
    NEW.email,
    'teacher', 
    'GOLD', 
    true, 
    9999
  )
  ON CONFLICT (id) DO UPDATE SET
    tier = 'GOLD',
    is_unlimited = true,
    credits = 9999;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Re-apply trigger just in case (though CREATE OR REPLACE FUNCTION handles the function side)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- Also ensure any users created today BEFORE this migration are upgraded
UPDATE public.profiles
SET 
    tier = 'GOLD',
    is_unlimited = true,
    credits = 9999
WHERE created_at >= CURRENT_DATE 
AND (tier IS DISTINCT FROM 'GOLD' OR is_unlimited = false);
