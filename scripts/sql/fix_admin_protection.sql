-- ==============================================================================
-- 🚑 EMERGENCY FIX: PROTECT ADMINS & RESTORE ACCESS
-- ==============================================================================
-- The previous trigger unintentionally demoted Admins if they didn't have the 
-- specific school email pattern. This script fixes the trigger logic and calls.

BEGIN;

-- 1. Refine the Trigger Function to RESPECT ADMINS
CREATE OR REPLACE FUNCTION public.enforce_institutional_role() 
RETURNS TRIGGER AS $$
BEGIN
    -- 🛡️ SAFETY CHECK: If user is Admin, BYPASS all checks
    IF OLD.role = 'admin' OR NEW.role = 'admin' OR OLD.role = 'school_admin' OR NEW.role = 'school_admin' OR OLD.is_admin = true OR NEW.is_admin = true THEN
        -- Ensure pure admins keep their role
        IF NEW.role IS NULL THEN NEW.role := OLD.role; END IF;
        RETURN NEW;
    END IF;

    -- Standard Logic for Normal Users
    IF NEW.email ~* '^escola\.[0-9]+\.pedagogico@educacao\.mg\.gov\.br$' THEN
        NEW.role := 'manager';
    ELSE
        -- Downgrade invalid managers, BUT IGNORE if they were just set to teacher
        IF NEW.role = 'manager' OR NEW.role = 'school_manager' THEN
             NEW.role := 'teacher';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- 2. Restore User 'prehfeld@hotmail.com' to FULL ADMIN
UPDATE public.profiles 
SET role = 'admin', 
    is_admin = true,
    tier = 'GOLD',
    is_unlimited = true
WHERE email = 'prehfeld@hotmail.com';

COMMIT;
