-- Manager read/write tests (school scoped)
-- TODO: Replace placeholders with real values.
BEGIN;
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":"00000000-0000-0000-0000-000000000000","role":"authenticated"}';
SELECT COUNT(*) AS profiles_visible_to_manager
FROM public.profiles
WHERE school_id = 'SCHOOL_ID_PLACEHOLDER';
SELECT COUNT(*) AS school_students_visible_to_manager
FROM public.school_students
WHERE school_id = 'SCHOOL_ID_PLACEHOLDER';
-- INSERT/UPDATE/DELETE samples (adjust columns to match schema)
-- INSERT INTO public.school_students (school_id, student_id) VALUES ('SCHOOL_ID_PLACEHOLDER', 'REPLACE_STUDENT_ID');
-- UPDATE public.school_students SET school_id = 'SCHOOL_ID_PLACEHOLDER' WHERE student_id = 'REPLACE_STUDENT_ID';
-- DELETE FROM public.school_students WHERE student_id = 'REPLACE_STUDENT_ID';
COMMIT;
