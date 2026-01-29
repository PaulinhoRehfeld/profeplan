-- Analyze the specific class from Adão
SELECT * FROM public.classes WHERE id = '65789956-ca7f-40c3-b4e8-79e03a20fdca';

-- Check for any classes that have students LINKED to this school (23299) but the CLASS itself is NOT linked to the school
SELECT c.id, c.name, c.school_id as class_school_id, c.created_by, count(s.id) as student_count
FROM public.classes c
JOIN public.students s ON s.class_id = c.id
WHERE s.current_school_id = '23299' -- User's School
AND (c.school_id IS NULL OR c.school_id != '23299')
GROUP BY c.id, c.name, c.school_id, c.created_by;
