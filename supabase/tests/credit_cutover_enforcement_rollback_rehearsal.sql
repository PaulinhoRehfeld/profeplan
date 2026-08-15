-- =============================================================================
-- ProfePlan — Lote 1.3C.6 enforcement rollback verification
-- DISPOSABLE SUPABASE ONLY.
-- Run after scripts/sql/credit_cutover_enforcement_rollback.sql.
-- =============================================================================
\set ON_ERROR_STOP on

DO $$
BEGIN
  IF NOT has_table_privilege('authenticated', 'public.term_plans', 'INSERT')
     OR NOT has_table_privilege('authenticated', 'public.term_plans', 'UPDATE')
     OR NOT has_table_privilege('authenticated', 'public.generated_contents', 'INSERT')
     OR NOT has_table_privilege('authenticated', 'public.generated_contents', 'UPDATE') THEN
    RAISE EXCEPTION 'enforcement rollback did not restore legacy whole-table writes';
  END IF;

  IF EXISTS (
    SELECT 1 FROM pg_trigger
    WHERE tgname IN (
      'credit_guard_pdi_record_billable_write',
      'credit_guard_pdi_document_billable_write'
    ) AND NOT tgisinternal
  ) THEN
    RAISE EXCEPTION 'enforcement rollback left a PDI guard trigger installed';
  END IF;
END;
$$;

-- Prove the legacy PDI surface is actually restored rather than only checking
-- catalog metadata. All writes are rolled back immediately.
BEGIN;

UPDATE public.profiles
SET school_id = 'cutover-rollback-school'
WHERE id = '00000000-0000-0000-0000-000000000001';

INSERT INTO public.schools (id, name)
VALUES ('cutover-rollback-school', 'Synthetic Rollback School')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.school_students (id, school_id, name)
VALUES (
  '91000000-0000-4000-8000-000000000001',
  'cutover-rollback-school',
  'Synthetic Rollback Student'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.pdi_documents (id, student_id, year)
VALUES (
  '92000000-0000-4000-8000-000000000001',
  '91000000-0000-4000-8000-000000000001',
  2026
)
ON CONFLICT (id) DO NOTHING;

SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000001', true);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-000000000001","role":"authenticated"}',
  true
);

INSERT INTO public.pdi_records (
  id, student_id, school_id, teacher_id, type, pdi_block, title, content
) VALUES (
  '93000000-0000-4000-8000-000000000001',
  '91000000-0000-4000-8000-000000000001',
  'cutover-rollback-school',
  '00000000-0000-0000-0000-000000000001',
  'ADAPTATION', 'block9', 'Legacy rollback surface', '{}'::jsonb
);

UPDATE public.pdi_documents
SET block_9_content = '[{"lesson_id":"rollback-surface"}]'::jsonb,
    final_report = 'Legacy rollback surface'
WHERE id = '92000000-0000-4000-8000-000000000001';

ROLLBACK;

SELECT 'OK:credit_cutover_enforcement_rollback_1_3C_6' AS result;
