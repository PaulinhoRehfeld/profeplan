-- Teacher read/write tests (own records)
-- TODO: Replace placeholders with real values.
BEGIN;
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":"00000000-0000-0000-0000-000000000000","role":"authenticated"}';
SELECT COUNT(*) AS pdi_records_visible_to_teacher
FROM public.pdi_records
WHERE teacher_id = '00000000-0000-0000-0000-000000000000'::uuid;
-- INSERT/UPDATE/DELETE samples (adjust columns to match schema)
-- INSERT INTO public.pdi_records (school_id, teacher_id) VALUES ('SCHOOL_ID_PLACEHOLDER', '00000000-0000-0000-0000-000000000000');
-- UPDATE public.pdi_records SET school_id = 'SCHOOL_ID_PLACEHOLDER' WHERE teacher_id = '00000000-0000-0000-0000-000000000000';
-- DELETE FROM public.pdi_records WHERE teacher_id = '00000000-0000-0000-0000-000000000000';
COMMIT;
