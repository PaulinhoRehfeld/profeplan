-- ==============================================================================
-- SECURE RPC: bypass RLS for Admin User List
-- ==============================================================================
-- 1. Creates a function that runs as "Database Owner" (Security Definer).
-- 2. Checks if the caller is an Admin (via authorized_users or profiles).
-- 3. Returns all profiles if allowed.
-- ==============================================================================

CREATE OR REPLACE FUNCTION get_all_profiles_secure()
RETURNS SETOF profiles
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- 1. Security Check: Who is calling this?
  -- Check authorized_users (VIP List)
  IF EXISTS (
    SELECT 1 FROM public.authorized_users
    WHERE id = auth.uid() AND (role = 'ADMIN' OR role = 'admin')
  ) THEN
    -- Access Granted: Return all profiles
    RETURN QUERY SELECT * FROM public.profiles ORDER BY email ASC;
    
  -- Check profiles (Standard List - fallback)
  ELSIF EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND (role = 'admin' OR is_admin = true)
  ) THEN
    -- Access Granted
    RETURN QUERY SELECT * FROM public.profiles ORDER BY email ASC;
    
  ELSE
    -- Access Denied: Return Empty
    RETURN;
  END IF;
END;
$$;
