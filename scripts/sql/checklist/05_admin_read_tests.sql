-- Admin read tests
-- TODO: Replace :admin_uid with a real UUID if you want accurate results.
BEGIN;
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":"00000000-0000-0000-0000-000000000000","role":"authenticated"}';
SELECT COUNT(*) AS profiles_visible_to_admin FROM public.profiles;
SELECT COUNT(*) AS pdi_records_visible_to_admin FROM public.pdi_records;
SELECT COUNT(*) AS school_students_visible_to_admin FROM public.school_students;
SELECT COUNT(*) AS enem_questions_visible_to_admin FROM public.enem_questions;
COMMIT;
