-- =============================================================================
-- ProfePlan — Lote 1.3C.6 granular enforcement candidate rehearsal
-- DISPOSABLE SUPABASE ONLY.
--
-- Assumes the integrated 1.3B/1.3C schema, LEGACY_BALANCE import and the
-- 202608151900 enforcement candidate are already present.
-- =============================================================================
\set ON_ERROR_STOP on

BEGIN;

-- Synthetic cutover subject: imported legacy balance = 10.
UPDATE public.profiles
SET school_id = 'cutover-enforcement-school',
    role = 'school_manager'
WHERE id = '00000000-0000-0000-0000-000000000001';

INSERT INTO public.schools (id, name)
VALUES ('cutover-enforcement-school', 'Synthetic Enforcement School')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.school_students (id, school_id, name)
VALUES (
  '81000000-0000-4000-8000-000000000001',
  'cutover-enforcement-school',
  'Synthetic Enforcement Student'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.pdi_documents (id, student_id, year)
VALUES (
  '82000000-0000-4000-8000-000000000001',
  '81000000-0000-4000-8000-000000000001',
  2026
)
ON CONFLICT (id) DO NOTHING;

-- Final enforcement must remove direct whole-table billable writes and install
-- the two granular PDI guards.
DO $$
BEGIN
  IF has_table_privilege('authenticated', 'public.term_plans', 'INSERT')
     OR has_table_privilege('authenticated', 'public.term_plans', 'UPDATE')
     OR has_table_privilege('authenticated', 'public.generated_contents', 'INSERT')
     OR has_table_privilege('authenticated', 'public.generated_contents', 'UPDATE') THEN
    RAISE EXCEPTION 'whole-table billable direct write survived enforcement';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger
    WHERE tgname = 'credit_guard_pdi_record_billable_write'
      AND NOT tgisinternal
  ) OR NOT EXISTS (
    SELECT 1 FROM pg_trigger
    WHERE tgname = 'credit_guard_pdi_document_billable_write'
      AND NOT tgisinternal
  ) THEN
    RAISE EXCEPTION 'granular PDI enforcement trigger is missing';
  END IF;
END;
$$;

SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000001', true);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-000000000001","role":"authenticated"}',
  true
);

-- Whole-table bypasses must fail because authenticated lost INSERT/UPDATE.
DO $$
DECLARE
  v_caught boolean := false;
BEGIN
  BEGIN
    INSERT INTO public.generated_contents (
      id, user_id, type, folder, title, content
    ) VALUES (
      'enforcement-direct-generated-must-fail',
      '00000000-0000-0000-0000-000000000001',
      'plano', 'PLANOS DE AULA', 'Bypass', 'MUST NOT PERSIST'
    );
  EXCEPTION WHEN insufficient_privilege THEN
    v_caught := true;
  END;
  IF NOT v_caught THEN
    RAISE EXCEPTION 'direct generated_contents bypass survived';
  END IF;
END;
$$;

-- Direct billable PDI adaptation record must reach the guard and fail closed.
DO $$
DECLARE
  v_caught boolean := false;
BEGIN
  BEGIN
    INSERT INTO public.pdi_records (
      id, student_id, school_id, teacher_id, type, pdi_block, title, content
    ) VALUES (
      '83000000-0000-4000-8000-000000000001',
      '81000000-0000-4000-8000-000000000001',
      'cutover-enforcement-school',
      '00000000-0000-0000-0000-000000000001',
      'ADAPTATION', 'block9', 'Direct bypass', '{}'::jsonb
    );
  EXCEPTION WHEN insufficient_privilege THEN
    v_caught := true;
  END;
  IF NOT v_caught THEN
    RAISE EXCEPTION 'direct PDI adaptation record bypass survived';
  END IF;
END;
$$;

-- Direct Block 9 and final-report updates must fail, while unrelated document
-- fields remain editable under the legacy RLS surface.
DO $$
DECLARE
  v_block9_caught boolean := false;
  v_final_caught boolean := false;
BEGIN
  BEGIN
    UPDATE public.pdi_documents
    SET block_9_content = '[{"lesson_id":"direct-bypass"}]'::jsonb
    WHERE id = '82000000-0000-4000-8000-000000000001';
  EXCEPTION WHEN insufficient_privilege THEN
    v_block9_caught := true;
  END;

  BEGIN
    UPDATE public.pdi_documents
    SET final_report = 'DIRECT BYPASS'
    WHERE id = '82000000-0000-4000-8000-000000000001';
  EXCEPTION WHEN insufficient_privilege THEN
    v_final_caught := true;
  END;

  IF NOT v_block9_caught OR NOT v_final_caught THEN
    RAISE EXCEPTION 'direct billable PDI document bypass survived: block9 %, final %',
      v_block9_caught, v_final_caught;
  END IF;
END;
$$;

-- Non-billable PDI timeline and document edits must continue to work.
INSERT INTO public.pdi_records (
  id, student_id, school_id, teacher_id, type, pdi_block, title, content
) VALUES (
  '83000000-0000-4000-8000-000000000002',
  '81000000-0000-4000-8000-000000000001',
  'cutover-enforcement-school',
  '00000000-0000-0000-0000-000000000001',
  'OBSERVATION', NULL, 'Non-billable observation', '{"ok":true}'::jsonb
);

UPDATE public.pdi_documents
SET content_data = '{"non_billable_edit":true}'::jsonb,
    status = 'em_andamento'
WHERE id = '82000000-0000-4000-8000-000000000001';

-- Governed SECURITY DEFINER boundaries must continue through enforcement.
SELECT public.credit_save_generated_content(
  'enforcement-governed-plan-1',
  'plano',
  'PLANOS DE AULA',
  'Governed plan under enforcement',
  'Persisted through governed RPC',
  '2026-08-15 18:00:00+00'
);

SELECT public.credit_save_term_plan(
  'enforcement-governed-term-1',
  'Governed TermPlan under enforcement',
  1,
  'Trimestre',
  'Sociologia',
  '1º Ano EM',
  'Ensino Médio',
  2,
  '{}'::jsonb,
  24,
  '{}'::jsonb,
  'Minas Gerais',
  'Estadual',
  'Governed quarterly content',
  '[]'::jsonb
);

SELECT public.credit_validate_pdi_adaptation(
  '83000000-0000-4000-8000-000000000003',
  '82000000-0000-4000-8000-000000000001',
  '81000000-0000-4000-8000-000000000001',
  'lesson-enforcement-1',
  'Governed adaptation under enforcement',
  'Sociologia',
  'Governed adaptation content',
  '{"lesson_id":"lesson-enforcement-1","lesson_title":"Governed adaptation under enforcement","subject":"Sociologia","adaptacao_metodologica":"Governed"}'::jsonb,
  '2026-08-15 18:01:00+00'
);

SELECT public.credit_save_pdi_final_report(
  '82000000-0000-4000-8000-000000000001',
  'Governed final report under enforcement'
);

RESET ROLE;

DO $$
DECLARE
  v_balance integer;
  v_debits integer;
  v_non_billable integer;
  v_adaptation integer;
  v_block9 jsonb;
  v_final text;
BEGIN
  SELECT (public.credit_get_balance_for_user(
    '00000000-0000-0000-0000-000000000001'
  )->>'total')::integer INTO v_balance;

  SELECT COUNT(*) INTO v_debits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-0000-0000-000000000001'
    AND entry_type = 'DEBIT';

  SELECT COUNT(*) INTO v_non_billable
  FROM public.pdi_records
  WHERE id = '83000000-0000-4000-8000-000000000002'
    AND type = 'OBSERVATION';

  SELECT COUNT(*) INTO v_adaptation
  FROM public.pdi_records
  WHERE id = '83000000-0000-4000-8000-000000000003'
    AND type = 'ADAPTATION'
    AND pdi_block = 'block9';

  SELECT block_9_content, final_report
    INTO v_block9, v_final
  FROM public.pdi_documents
  WHERE id = '82000000-0000-4000-8000-000000000001';

  IF v_balance <> 6 OR v_debits <> 4 THEN
    RAISE EXCEPTION 'governed enforcement economics mismatch: balance %, debits %',
      v_balance, v_debits;
  END IF;
  IF v_non_billable <> 1 OR v_adaptation <> 1 THEN
    RAISE EXCEPTION 'PDI enforcement persistence mismatch: nonbillable %, adaptation %',
      v_non_billable, v_adaptation;
  END IF;
  IF jsonb_array_length(v_block9) <> 1
     OR v_final <> 'Governed final report under enforcement' THEN
    RAISE EXCEPTION 'governed PDI document writes did not survive enforcement';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.pdi_records
    WHERE id = '83000000-0000-4000-8000-000000000001'
  ) THEN
    RAISE EXCEPTION 'failed direct PDI bypass left residue';
  END IF;
END;
$$;

ROLLBACK;

SELECT 'OK:credit_cutover_enforcement_candidate_1_3C_6' AS result;
