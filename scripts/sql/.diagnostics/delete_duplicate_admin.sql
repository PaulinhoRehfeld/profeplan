-- ==============================================================================
-- SECURITY CLEANUP: DELETE DUPLICATE ADMIN PROFILE
-- ==============================================================================

-- Deleting the specific profile that has is_admin = true but should be a teacher.
-- ID identified from user report: 5aa2c137-e9b2-44d6-aa0e-876a670b4a33

DELETE FROM public.profiles 
WHERE id = '5aa2c137-e9b2-44d6-aa0e-876a670b4a33';

-- Verify that only the correct profile remains
SELECT 
    id, 
    email, 
    role, 
    is_admin, 
    school_id
FROM public.profiles
WHERE email LIKE '%paulo.rehfeld@educacao.mg.gov.br%';
