-- ==============================================================================
-- 🔐 SECURE ROLE ASSIGNMENT: INSTITUTIONAL EMAIL PATTERN
-- ==============================================================================
-- Requirement: Only emails matching 'escola.*.pedagogico@educacao.mg.gov.br' 
-- should be 'manager'. Generic updates to 'role' should be prevented for normal users.

BEGIN;

-- 1. Create Function to Enforce Role Logic
CREATE OR REPLACE FUNCTION public.enforce_institutional_role() 
RETURNS TRIGGER AS $$
BEGIN
    -- Check Regex for Manager Pattern
    -- Pattern: escola.NUMEROS.pedagogico@educacao.mg.gov.br
    IF NEW.email ~* '^escola\.[0-9]+\.pedagogico@educacao\.mg\.gov\.br$' THEN
        NEW.role := 'manager';
    ELSE
        -- If user tries to set manager BUT email doesn't match, revert to teacher
        -- (Unless they are already something else like admin, but for now strict safety)
        IF NEW.role = 'manager' OR NEW.role = 'school_manager' THEN
             -- Allow existing Admins to manually set it? 
             -- For now, STRICT: You are only a manager if you have the email.
             NEW.role := 'teacher';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Create Trigger on Profiles (Before Insert/Update)
DROP TRIGGER IF EXISTS on_auth_user_role_check ON public.profiles;
CREATE TRIGGER on_auth_user_role_check
BEFORE INSERT OR UPDATE OF email, role ON public.profiles
FOR EACH ROW EXECUTE FUNCTION public.enforce_institutional_role();

-- 3. Run a migration on existing users to fix them retroactively
UPDATE public.profiles 
SET role = 'manager' 
WHERE email ~* '^escola\.[0-9]+\.pedagogico@educacao\.mg\.gov\.br$';

-- 4. Restore "Update Own Profile" Policy but SECURELY
-- We allow users to update their profile, but the TRIGGER will override the 'role' 
-- if they try to hack it without the proper email.
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile" ON public.profiles 
FOR UPDATE TO authenticated 
USING (auth.uid() = id); 
-- Note: Even if they send role='manager', the trigger above intercepts it 
-- and sets it back to 'teacher' if the email doesn't match.

COMMIT;
