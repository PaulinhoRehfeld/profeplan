-- =============================================================================
-- ProfePlan — Lote 1.3C.5 integral cutover/enforcement rehearsal
-- DISPOSABLE SUPABASE ONLY. Never a production migration.
--
-- Preconditions supplied by the workflow:
-- - synthetic legacy snapshot already imported through the 1.3C.2 rehearsal;
-- - 1.3B accounting foundation;
-- - 1.3C.3 governed producers;
-- - TermPlan, generated_contents and PDI governed save boundaries.
-- =============================================================================
\set ON_ERROR_STOP on

-- -----------------------------------------------------------------------------
-- 1. Confirm the conservative legacy cut is still exact before enforcement.
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  v_legacy_grants integer;
  v_legacy_total integer;
  v_gold_grants integer;
BEGIN
  SELECT COUNT(*), COALESCE(SUM(granted_amount), 0)::integer
    INTO v_legacy_grants, v_legacy_total
  FROM public.credit_grants
  WHERE origin = 'LEGACY_BALANCE';

  SELECT COUNT(*) INTO v_gold_grants
  FROM public.credit_grants
  WHERE user_id = '00000000-0000-0000-0000-000000000031';

  IF v_legacy_grants <> 30 OR v_legacy_total <> 292 OR v_gold_grants <> 0 THEN
    RAISE EXCEPTION
      'integral rehearsal entered with an invalid legacy cut: grants %, total %, gold grants %',
      v_legacy_grants, v_legacy_total, v_gold_grants;
  END IF;
END;
$$;

-- Use one legacy finite user as the end-to-end cutover subject. Its old integer
-- remains frozen at 10 while the imported ledger becomes the spendable authority.
UPDATE public.profiles
SET school_id = 'cutover-school',
    role = 'school_manager'
WHERE id = '00000000-0000-0000-0000-000000000001';

INSERT INTO public.schools (id, name)
VALUES ('cutover-school', 'Synthetic Cutover School');

INSERT INTO public.school_students (id, school_id, name)
VALUES (
  '71000000-0000-4000-8000-000000000001',
  'cutover-school',
  'Synthetic Cutover Student'
);

INSERT INTO public.pdi_documents (id, student_id, year)
VALUES (
  '72000000-0000-4000-8000-000000000001',
  '71000000-0000-4000-8000-000000000001',
  2026
);

-- -----------------------------------------------------------------------------
-- 2. Baseline must contain the legacy direct-write surface we intend to close.
-- -----------------------------------------------------------------------------
DO $$
BEGIN
  IF NOT has_table_privilege('authenticated', 'public.term_plans', 'INSERT')
     OR NOT has_table_privilege('authenticated', 'public.term_plans', 'UPDATE')
     OR NOT has_table_privilege('authenticated', 'public.generated_contents', 'INSERT')
     OR NOT has_table_privilege('authenticated', 'public.generated_contents', 'UPDATE') THEN
    RAISE EXCEPTION 'synthetic legacy bypass surface is incomplete before enforcement';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 3. Pre-release rollback proof.
--    PostgreSQL DDL grants are transactional: apply the intended enforcement,
--    verify it, roll it back, and prove the legacy surface is restored exactly.
-- -----------------------------------------------------------------------------
BEGIN;
REVOKE INSERT, UPDATE ON public.term_plans FROM authenticated;
REVOKE INSERT, UPDATE ON public.generated_contents FROM authenticated;

DO $$
BEGIN
  IF has_table_privilege('authenticated', 'public.term_plans', 'INSERT')
     OR has_table_privilege('authenticated', 'public.term_plans', 'UPDATE')
     OR has_table_privilege('authenticated', 'public.generated_contents', 'INSERT')
     OR has_table_privilege('authenticated', 'public.generated_contents', 'UPDATE') THEN
    RAISE EXCEPTION 'transactional enforcement rehearsal did not remove direct writes';
  END IF;
END;
$$;
ROLLBACK;

DO $$
BEGIN
  IF NOT has_table_privilege('authenticated', 'public.term_plans', 'INSERT')
     OR NOT has_table_privilege('authenticated', 'public.term_plans', 'UPDATE')
     OR NOT has_table_privilege('authenticated', 'public.generated_contents', 'INSERT')
     OR NOT has_table_privilege('authenticated', 'public.generated_contents', 'UPDATE') THEN
    RAISE EXCEPTION 'rollback failed to restore the pre-release legacy write surface';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 4. Apply enforcement for the rest of this disposable rehearsal only.
-- -----------------------------------------------------------------------------
REVOKE INSERT, UPDATE ON public.term_plans FROM authenticated;
REVOKE INSERT, UPDATE ON public.generated_contents FROM authenticated;

DO $$
BEGIN
  IF has_table_privilege('authenticated', 'public.term_plans', 'INSERT')
     OR has_table_privilege('authenticated', 'public.term_plans', 'UPDATE')
     OR has_table_privilege('authenticated', 'public.generated_contents', 'INSERT')
     OR has_table_privilege('authenticated', 'public.generated_contents', 'UPDATE') THEN
    RAISE EXCEPTION 'final disposable enforcement left a direct billable write privilege';
  END IF;
END;
$$;

-- Direct legacy writes must now fail for an authenticated user. These attempts
-- are deliberately rolled back and must not create economic or artifact state.
BEGIN;
SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000001', true);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-000000000001","role":"authenticated"}',
  true
);
DO $$
DECLARE
  v_caught boolean := false;
BEGIN
  BEGIN
    INSERT INTO public.term_plans (
      id, user_id, title, period, regime, subject, grade, level,
      workload_weekly, reserves, total_classes, grading_grid,
      state_base, education_sphere, generated_text, lessons
    ) VALUES (
      'legacy-bypass-must-fail',
      '00000000-0000-0000-0000-000000000001',
      'Legacy bypass', 1, 'Trimestre', 'Sociologia', '1º Ano EM',
      'Ensino Médio', 2, '{}'::jsonb, 24, '{}'::jsonb,
      'Minas Gerais', 'Estadual', 'MUST NOT PERSIST', '[]'::jsonb
    );
  EXCEPTION
    WHEN insufficient_privilege THEN
      v_caught := true;
  END;

  IF NOT v_caught THEN
    RAISE EXCEPTION 'direct term_plans bypass survived enforcement';
  END IF;
END;
$$;

DO $$
DECLARE
  v_caught boolean := false;
BEGIN
  BEGIN
    INSERT INTO public.generated_contents (
      id, user_id, type, folder, title, content
    ) VALUES (
      'legacy-generated-bypass-must-fail',
      '00000000-0000-0000-0000-000000000001',
      'plano', 'PLANOS DE AULA', 'Legacy bypass', 'MUST NOT PERSIST'
    );
  EXCEPTION
    WHEN insufficient_privilege THEN
      v_caught := true;
  END;

  IF NOT v_caught THEN
    RAISE EXCEPTION 'direct generated_contents bypass survived enforcement';
  END IF;
END;
$$;
ROLLBACK;

-- -----------------------------------------------------------------------------
-- 5. Governed consumer smoke matrix with the legacy direct surface closed.
--    Seven first-save events consume seven of the imported ten credits.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000001', true);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-000000000001","role":"authenticated"}',
  true
);

SELECT public.credit_save_generated_content(
  'cutover-plan-1', 'plano', 'PLANOS DE AULA',
  'Plano integral 1.3C.5', 'Conteúdo governado de planejamento',
  '2026-08-15 17:30:00+00'
);

SELECT public.credit_save_generated_content(
  'cutover-assessment-1', 'avaliacao', 'AVALIAÇÕES',
  'Avaliação integral 1.3C.5', 'Conteúdo governado de avaliação',
  '2026-08-15 17:31:00+00'
);

SELECT public.credit_save_generated_content(
  'cutover-presentation-1', 'apresentacao', 'APRESENTAÇÕES',
  'Apresentação integral 1.3C.5', 'Conteúdo governado de apresentação',
  '2026-08-15 17:32:00+00'
);

SELECT public.credit_save_term_plan(
  'cutover-term-plan-1',
  'Planejamento Trimestral integral 1.3C.5',
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
  'Conteúdo trimestral governado',
  '[]'::jsonb
);

SELECT public.credit_validate_pdi_adaptation(
  '73000000-0000-4000-8000-000000000001',
  '72000000-0000-4000-8000-000000000001',
  '71000000-0000-4000-8000-000000000001',
  'lesson-cutover-1',
  'Aula integral 1.3C.5',
  'Sociologia',
  'Adaptação validada e persistida de forma governada',
  '{"lesson_id":"lesson-cutover-1","lesson_title":"Aula integral 1.3C.5","subject":"Sociologia","adaptacao_metodologica":"Rehearsal integral"}'::jsonb,
  '2026-08-15 17:33:00+00'
);

SELECT public.credit_save_pdi_generated_report(
  'cutover-pdi-generated-report-1',
  'Relatório pedagógico integral 1.3C.5',
  'Relatório pedagógico governado',
  '2026-08-15 17:34:00+00'
);

SELECT public.credit_save_pdi_final_report(
  '72000000-0000-4000-8000-000000000001',
  'Relatório final governado do rehearsal integral'
);

-- User-facing projection must remain callable after direct table enforcement.
SELECT public.credit_get_my_balance();
COMMIT;

-- -----------------------------------------------------------------------------
-- 6. End-state invariants: one authority, exact debits, legacy integer frozen.
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  v_legacy integer;
  v_balance jsonb;
  v_total integer;
  v_debits integer;
  v_term_plans integer;
  v_generated integer;
  v_pdi_records integer;
  v_final_report text;
BEGIN
  SELECT credits INTO v_legacy
  FROM public.profiles
  WHERE id = '00000000-0000-0000-0000-000000000001';

  SELECT public.credit_get_balance_for_user(
    '00000000-0000-0000-0000-000000000001'
  ) INTO v_balance;
  v_total := (v_balance ->> 'total')::integer;

  SELECT COUNT(*) INTO v_debits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-0000-0000-000000000001'
    AND entry_type = 'DEBIT';

  SELECT COUNT(*) INTO v_term_plans
  FROM public.term_plans
  WHERE id = 'cutover-term-plan-1'
    AND user_id = '00000000-0000-0000-0000-000000000001';

  SELECT COUNT(*) INTO v_generated
  FROM public.generated_contents
  WHERE user_id = '00000000-0000-0000-0000-000000000001'
    AND id IN (
      'cutover-plan-1',
      'cutover-assessment-1',
      'cutover-presentation-1',
      '73000000-0000-4000-8000-000000000001',
      'cutover-pdi-generated-report-1',
      'pdi-final-report-v1:72000000-0000-4000-8000-000000000001'
    );

  SELECT COUNT(*) INTO v_pdi_records
  FROM public.pdi_records
  WHERE id = '73000000-0000-4000-8000-000000000001'
    AND teacher_id = '00000000-0000-0000-0000-000000000001';

  SELECT final_report INTO v_final_report
  FROM public.pdi_documents
  WHERE id = '72000000-0000-4000-8000-000000000001';

  IF v_legacy <> 10 THEN
    RAISE EXCEPTION 'governed cutover mutated frozen profiles.credits: %', v_legacy;
  END IF;
  IF v_total <> 3 OR v_debits <> 7 THEN
    RAISE EXCEPTION 'governed end-state mismatch: balance %, debits %', v_total, v_debits;
  END IF;
  IF v_term_plans <> 1 OR v_generated <> 6 OR v_pdi_records <> 1 THEN
    RAISE EXCEPTION
      'governed persistence mismatch: term plans %, generated %, pdi records %',
      v_term_plans, v_generated, v_pdi_records;
  END IF;
  IF v_final_report <> 'Relatório final governado do rehearsal integral' THEN
    RAISE EXCEPTION 'governed final PDI report did not persist';
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.term_plans WHERE id = 'legacy-bypass-must-fail'
  ) OR EXISTS (
    SELECT 1 FROM public.generated_contents WHERE id = 'legacy-generated-bypass-must-fail'
  ) THEN
    RAISE EXCEPTION 'failed legacy bypass attempt left artifact residue';
  END IF;
END;
$$;

-- A replay/edit of first-save artifact identities must not spend the same
-- imported unit again for the generic and PDI first-save boundaries.
BEGIN;
SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000001', true);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-000000000001","role":"authenticated"}',
  true
);
SELECT public.credit_save_generated_content(
  'cutover-plan-1', 'plano', 'PLANOS DE AULA',
  'Plano integral 1.3C.5 — edição', 'Conteúdo editado sem nova cobrança',
  '2026-08-15 17:35:00+00'
);
SELECT public.credit_save_pdi_generated_report(
  'cutover-pdi-generated-report-1',
  'Relatório pedagógico integral 1.3C.5 — edição',
  'Relatório editado sem nova cobrança',
  '2026-08-15 17:36:00+00'
);
COMMIT;

DO $$
DECLARE
  v_balance jsonb;
BEGIN
  SELECT public.credit_get_balance_for_user(
    '00000000-0000-0000-0000-000000000001'
  ) INTO v_balance;

  IF (v_balance ->> 'total')::integer <> 3
     OR (
       SELECT COUNT(*)
       FROM public.credit_ledger_entries
       WHERE user_id = '00000000-0000-0000-0000-000000000001'
         AND entry_type = 'DEBIT'
     ) <> 7 THEN
    RAISE EXCEPTION 'first-save replay/edit created an extra economic debit';
  END IF;
END;
$$;

SELECT 'OK:credit_cutover_integral_rehearsal_1_3C_5' AS result;
