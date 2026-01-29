-- ==============================================================================
-- DIAGNOSTIC: PROFILE RECOVERY
-- ==============================================================================

-- 1. Check the specific ID that was reported in the screenshot/deleted
SELECT * FROM public.profiles WHERE id = '5aa2c137-e9b2-44d6-aa0e-876a670b4a33';

-- 2. Check for the hotmail address mentioned
SELECT * FROM public.profiles WHERE email ILIKE '%prehfeld@hotmail.com%';

-- 3. Check what profiles exist for the school 23299
SELECT id, email, role, full_name, is_admin 
FROM public.profiles 
WHERE school_id = '23299';

-- 4. Check a few classes to see their school_id
SELECT id, name, school_id FROM public.classes WHERE school_id = '23299' LIMIT 5;
