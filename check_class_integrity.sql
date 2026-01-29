-- Check if the class assigned to Adão exists and belongs to the correct school
SELECT * 
FROM public.classes 
WHERE id = '65789956-ca7f-40c3-b4e8-79e03a20fdca';

-- Check RLS on classes
SELECT * FROM pg_policies WHERE tablename = 'classes';
