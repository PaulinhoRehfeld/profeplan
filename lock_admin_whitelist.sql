-- ==============================================================================
-- SECURITY LOCKDOWN: ADMIN WHITELIST ENFORCEMENT
-- ==============================================================================

-- 1. REVOKE ADMIN from everyone NOT in the whitelist
UPDATE public.profiles
SET 
    is_admin = false,
    role = CASE WHEN role = 'admin' THEN 'teacher' ELSE role END
WHERE email NOT IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br');

-- 2. GRANT ADMIN to the whitelist (Ensure they have access)
UPDATE public.profiles
SET 
    is_admin = true,
    role = 'admin'
WHERE email IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br');

-- ==============================================================================
-- 3. PERMANENT LOCK (Database Trigger)
-- prevents any future attempt to make someone else an admin
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.enforce_admin_whitelist()
RETURNS TRIGGER AS $$
BEGIN
    -- If trying to set is_admin = true
    IF NEW.is_admin = true THEN
        -- Check if email is in whitelist
        IF NEW.email NOT IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br') THEN
            RAISE EXCEPTION 'SECURITY VIOLATION: The user % is not authorized to be an Admin. Only specific accounts are allowed.', NEW.email;
        END IF;
    END IF;
    
    -- If trying to set role = 'admin' (text field check just in case)
    IF NEW.role = 'admin' THEN
         IF NEW.email NOT IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br') THEN
            RAISE EXCEPTION 'SECURITY VIOLATION: The user % cannot have admin role. Only specific accounts are allowed.', NEW.email;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists to ensure clean slate
DROP TRIGGER IF EXISTS trg_enforce_admin_whitelist ON public.profiles;

-- Create the trigger for INSERT and UPDATE
CREATE TRIGGER trg_enforce_admin_whitelist
BEFORE INSERT OR UPDATE ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION public.enforce_admin_whitelist();

-- 4. Verification
SELECT id, email, role, is_admin 
FROM public.profiles 
WHERE is_admin = true OR role = 'admin';
