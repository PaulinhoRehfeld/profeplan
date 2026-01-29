-- ==============================================================================
-- RESTORE ACCESS: ADMIN & SCHOOL LINK
-- ==============================================================================

-- 1. Restore Admin Access for the Hotmail account (Master Admin)
UPDATE public.profiles
SET 
    school_id = '23299',
    role = 'admin',
    is_admin = true,
    full_name = COALESCE(full_name, 'Admin (Restaurado)')
WHERE email ILIKE '%prehfeld@hotmail.com%';

-- 2. Restore/Ensure Teacher Access for the MG Gov account
-- (In case this is the account currently logged in, so they see SOMETHING)
UPDATE public.profiles
SET 
    school_id = '23299',
    role = 'teacher' 
    -- Keep is_admin FALSE for the teacher account
WHERE email ILIKE '%paulo.rehfeld@educacao.mg.gov.br%';

-- 3. Verify the Fix
SELECT id, email, role, is_admin, school_id 
FROM public.profiles 
WHERE email ILIKE '%prehfeld@hotmail.com%' 
   OR email ILIKE '%paulo.rehfeld@educacao.mg.gov.br%';
