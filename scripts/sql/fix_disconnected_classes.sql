-- ==============================================================================
-- FIX: ADOPT DISCONNECTED CLASSES
-- ==============================================================================
-- Problem: Classes created by teachers might not have the correct 'school_id'.
-- Solution: If a Class has students from School X, the Class belongs to School X.

-- 1. Check count before fix
SELECT COUNT(*) as disconnected_classes_count
FROM public.classes c
JOIN public.students s ON s.class_id = c.id
WHERE s.current_school_id IS NOT NULL
AND (c.school_id IS NULL OR c.school_id != s.current_school_id);

-- 2. Perform the Update (The "Adoption")
UPDATE public.classes c
SET school_id = s.current_school_id
FROM public.students s
WHERE c.id = s.class_id
AND s.current_school_id IS NOT NULL
AND (c.school_id IS NULL OR c.school_id != s.current_school_id);

-- 3. Verify specifically for the class '65789956...' (Adão's class)
SELECT id, name, school_id FROM public.classes 
WHERE id = '65789956-ca7f-40c3-b4e8-79e03a20fdca';
