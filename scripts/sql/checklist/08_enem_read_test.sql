-- Authenticated read test (ENEM questions)
-- TODO: Replace placeholder UUID with a real user if needed.
BEGIN;
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":"00000000-0000-0000-0000-000000000000","role":"authenticated"}';
SELECT COUNT(*) AS enem_questions_visible_to_authenticated FROM public.enem_questions;
COMMIT;
