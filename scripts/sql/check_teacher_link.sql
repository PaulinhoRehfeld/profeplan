-- ==============================================================================
-- DIAGNOSTIC: TEACHER LINKAGE & STATUS (FINAL)
-- ==============================================================================

-- 1. Check Profile for the specific email
SELECT 
    id, 
    email, 
    role, 
    school_id
FROM public.profiles
WHERE email LIKE '%paulo.rehfeld@educacao.mg.gov.br%';

-- 2. Check Pending Teachers table
-- "Pendente" status usually comes from here.
SELECT * 
FROM public.pending_teachers 
WHERE email_institucional LIKE '%paulo.rehfeld@educacao.mg.gov.br%';

-- 3. Check School ID used
SELECT id, name, city FROM public.schools WHERE id = '23299';
