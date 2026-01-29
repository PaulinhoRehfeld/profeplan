-- Diagnose Student "Adão"
SELECT id, name, student_code, class_id, current_school_id 
FROM public.students 
WHERE name ILIKE '%Adão%';

-- Check Policies on Students table to ensure UPDATE is allowed
SELECT * FROM pg_policies WHERE tablename = 'students';
