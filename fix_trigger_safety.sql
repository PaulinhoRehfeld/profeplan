-- ==============================================================================
-- 🛠️ FIX TRIGGER SAFETY (TG_OP Check)
-- ==============================================================================
-- Accessing "OLD" in an INSERT trigger can cause errors.
-- This script adds explicit TG_OP checks to safely handle Admin logic.

BEGIN;

CREATE OR REPLACE FUNCTION public.enforce_institutional_role() 
RETURNS TRIGGER AS $$
BEGIN
    -- 1. Handle UPDATE (Check OLD and NEW)
    IF (TG_OP = 'UPDATE') THEN
        -- Safely check OLD record
        IF OLD.role = 'admin' OR OLD.role = 'school_admin' OR OLD.is_admin = true THEN
             -- Preserve Admin Status
             IF NEW.role IS DISTINCT FROM OLD.role THEN
                 NEW.role := OLD.role; 
             END IF;
             RETURN NEW;
        END IF;
    END IF;

    -- 2. Handle INSERT & UPDATE (Check NEW)
    IF NEW.role = 'admin' OR NEW.role = 'school_admin' OR NEW.is_admin = true THEN
        RETURN NEW;
    END IF;

    -- 3. Institutional Email Check (For non-admins)
    IF NEW.email ~* '^escola\.[0-9]+\.pedagogico@educacao\.mg\.gov\.br$' THEN
        NEW.role := 'manager';
    ELSE
        -- Downgrade invalid managers (Teacher Default)
        IF NEW.role = 'manager' OR NEW.role = 'school_manager' THEN
             NEW.role := 'teacher';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Re-apply Trigger to ensure it uses the new function
DROP TRIGGER IF EXISTS on_auth_user_role_check ON public.profiles;
CREATE TRIGGER on_auth_user_role_check
BEFORE INSERT OR UPDATE OF email, role ON public.profiles
FOR EACH ROW EXECUTE FUNCTION public.enforce_institutional_role();

-- Ensure Admin is correct (Idempotent)
UPDATE public.profiles 
SET role = 'admin', is_admin = true, tier = 'GOLD', is_unlimited = true
WHERE email = 'prehfeld@hotmail.com';

COMMIT;
