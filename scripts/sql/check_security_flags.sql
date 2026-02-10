-- ==============================================================================
-- SECURITY AUDIT: USER PRIVILEGES
-- Checking role and is_admin flag for the reported user
-- ==============================================================================

SELECT 
    id, 
    email, 
    role, 
    is_admin, 
    school_id
FROM public.profiles
WHERE email LIKE '%paulo.rehfeld@educacao.mg.gov.br%';
