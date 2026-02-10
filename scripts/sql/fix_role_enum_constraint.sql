-- ==============================================================================
-- 🔓 FIX ROLE ENUM CONSTRAINT & STANDARDIZE TO 'manager'
-- ==============================================================================
-- The `profiles` table likely has a CHECK constraint allowing only 'school_manager'.
-- The Frontend sends 'manager'.
-- The Policies check for 'manager'.
-- THIS SCRIPT ALIGNS EVERYTHING TO 'manager'.

BEGIN;

-- 1. Drop the restrictive constraint (name might vary, so we try common ones or just text check)
DO $$ 
DECLARE 
    r RECORD;
BEGIN 
    FOR r IN (
        SELECT constraint_name 
        FROM information_schema.constraint_column_usage 
        WHERE table_name = 'profiles' AND column_name = 'role'
    ) LOOP 
        EXECUTE 'ALTER TABLE public.profiles DROP CONSTRAINT ' || quote_ident(r.constraint_name);
    END LOOP;
END $$;

-- 2. Standardize Data: Convert 'school_manager' -> 'manager'
UPDATE public.profiles SET role = 'manager' WHERE role = 'school_manager';

-- 3. Add New Flexible Constraint (Optional, but good for validation)
ALTER TABLE public.profiles ADD CONSTRAINT profiles_role_check 
CHECK (role IN ('teacher', 'manager', 'school_admin', 'admin', 'school_manager')); 
-- We include 'school_manager' just in case legacy code sends it, but we prefer 'manager'.

COMMIT;
