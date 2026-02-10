-- ==============================================================================
-- SECURE RPC V2: Email-Based Authorization
-- ==============================================================================
-- Problem: ID Mismatch between Auth, Profiles, and Authorized_Users tables
--          causes ID-based checks (auth.uid() = id) to fail.
-- Solution: Trust the verified Email in the JWT token (auth.jwt() ->> 'email').
-- ==============================================================================

CREATE OR REPLACE FUNCTION get_all_profiles_secure()
RETURNS SETOF profiles
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  calling_email text;
BEGIN
  -- 1. Get the email directly from the authenticated user's token
  calling_email := lower(auth.jwt() ->> 'email');
  
  -- 2. Security Check: Is this email is an Admin?
  -- Check Profiles OR Authorized Users
  IF EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE lower(email) = calling_email 
    AND (role = 'admin' OR is_admin = true)
  ) 
  OR EXISTS (
    SELECT 1 FROM public.authorized_users 
    WHERE lower(email) = calling_email 
    AND (role = 'ADMIN' OR role = 'admin')
  ) 
  -- Hardcoded Emergency Backdoor for Owner
  OR calling_email = 'prehfeld@hotmail.com'
  THEN
    -- Access Granted: Return all profiles
    RETURN QUERY SELECT * FROM public.profiles ORDER BY role DESC, email ASC;
  ELSE
    -- Access Denied
    RAISE EXCEPTION 'Access Denied for %', calling_email;
  END IF;
END;
$$;
