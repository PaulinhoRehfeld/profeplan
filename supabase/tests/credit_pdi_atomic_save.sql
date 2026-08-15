-- =============================================================================
-- ProfePlan — Lote 1.3C.4D PDI atomic save validation
-- Disposable Supabase only.
-- =============================================================================

\set ON_ERROR_STOP on

CREATE OR REPLACE FUNCTION pg_temp.credit_set_identity(p_role text, p_user_id uuid)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  PERFORM set_config('request.jwt.claim.sub', p_user_id::text, true);
  PERFORM set_config(
    'request.jwt.claims',
    jsonb_build_object('sub', p_user_id::text, 'role', p_role)::text,
    true
  );
END;
$$;

SELECT public.credit_grant_command(
  '00000000-0000-4000-8000-000000000501',
  'grant-4d-user-501-initial',
  'GRANT_TEST_PURCHASED',
  'grant-4d-user-501-initial:3',
  'grant-4d:user-501:initial',
  'PURCHASED',
  3,
  '2026-08-15 15:30:00+00',
  NULL,
  'synthetic-4d',
  '{"test":"1.3C.4D"}'::jsonb
);

SELECT public.credit_grant_command(
  '00000000-0000-4000-8000-000000000504',
  'grant-4d-user-504-rollback',
  'GRANT_TEST_PURCHASED',
  'grant-4d-user-504-rollback:1',
  'grant-4d:user-504:rollback',
  'PURCHASED',
  1,
  '2026-08-15 15:30:00+00',
  NULL,
  'synthetic-4d',
  '{"test":"1.3C.4D"}'::jsonb
);

SELECT public.credit_grant_command(
  '00000000-0000-4000-8000-000000000505',
  'grant-4d-user-505-concurrency',
  'GRANT_TEST_PURCHASED',
  'grant-4d-user-505-concurrency:1',
  'grant-4d:user-505:concurrency',
  'PURCHASED',
  1,
  '2026-08-15 15:30:00+00',
  NULL,
  'synthetic-4d',
  '{"test":"1.3C.4D"}'::jsonb
);

-- -----------------------------------------------------------------------------
-- 1. Permission boundary.
-- -----------------------------------------------------------------------------
DO $$
BEGIN
  IF has_function_privilege(
    'anon',
    'public.credit_validate_pdi_adaptation(uuid,uuid,uuid,text,text,text,text,jsonb,timestamptz)',
    'EXECUTE'
  ) OR has_function_privilege(
    'service_role',
    'public.credit_validate_pdi_adaptation(uuid,uuid,uuid,text,text,text,text,jsonb,timestamptz)',
    'EXECUTE'
  ) THEN
    RAISE EXCEPTION 'non-user role can execute governed PDI adaptation save';
  END IF;

  IF NOT has_function_privilege(
    'authenticated',
    'public.credit_validate_pdi_adaptation(uuid,uuid,uuid,text,text,text,text,jsonb,timestamptz)',
    'EXECUTE'
  ) OR NOT has_function_privilege(
    'authenticated',
    'public.credit_save_pdi_generated_report(text,text,text,timestamptz)',
    'EXECUTE'
  ) OR NOT has_function_privilege(
    'authenticated',
    'public.credit_save_pdi_final_report(uuid,text)',
    'EXECUTE'
  ) THEN
    RAISE EXCEPTION 'authenticated role cannot execute one or more governed PDI saves';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 2. First adaptation validation = one debit; retry/edit = no extra debit.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity('authenticated', '00000000-0000-4000-8000-000000000501');
SELECT public.credit_validate_pdi_adaptation(
  '30000000-0000-4000-8000-000000000501',
  '20000000-0000-4000-8000-000000000501',
  '10000000-0000-4000-8000-000000000501',
  'lesson-501',
  'Aula 501',
  'Sociologia',
  'Conteúdo adaptado inicial',
  '{"lesson_id":"lesson-501","lesson_title":"Aula 501","subject":"Sociologia","adaptacao_metodologica":"Inicial","recursos_adaptados":[],"objetivos_adaptados":[],"estrategias_ensino":[]}'::jsonb,
  '2026-08-15 15:31:00+00'
);
SELECT public.credit_validate_pdi_adaptation(
  '30000000-0000-4000-8000-000000000501',
  '20000000-0000-4000-8000-000000000501',
  '10000000-0000-4000-8000-000000000501',
  'lesson-501',
  'Aula 501 revisada',
  'Sociologia',
  'Conteúdo adaptado editado',
  '{"lesson_id":"lesson-501","lesson_title":"Aula 501 revisada","subject":"Sociologia","adaptacao_metodologica":"Editada","recursos_adaptados":[],"objetivos_adaptados":[],"estrategias_ensino":[]}'::jsonb,
  '2026-08-15 15:31:00+00'
);
COMMIT;

DO $$
DECLARE
  v_debits integer;
  v_records integer;
  v_gc integer;
  v_block9 integer;
  v_balance integer;
BEGIN
  SELECT COUNT(*) INTO v_debits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-4000-8000-000000000501'
    AND entry_type = 'DEBIT';

  SELECT COUNT(*) INTO v_records
  FROM public.pdi_records
  WHERE id = '30000000-0000-4000-8000-000000000501'
    AND content ->> 'adaptedContent' = 'Conteúdo adaptado editado';

  SELECT COUNT(*) INTO v_gc
  FROM public.generated_contents
  WHERE id = '30000000-0000-4000-8000-000000000501'
    AND type = 'adaptacao_pdi'
    AND content = 'Conteúdo adaptado editado';

  SELECT COUNT(*) INTO v_block9
  FROM public.pdi_documents AS pd,
       LATERAL jsonb_array_elements(pd.block_9_content) AS item
  WHERE pd.id = '20000000-0000-4000-8000-000000000501'
    AND item ->> 'artifact_id' = '30000000-0000-4000-8000-000000000501'
    AND item ->> 'adaptacao_metodologica' = 'Editada';

  v_balance := (
    public.credit_balance_snapshot_internal(
      '00000000-0000-4000-8000-000000000501', now()
    )->>'total'
  )::integer;

  IF v_debits <> 1 OR v_records <> 1 OR v_gc <> 1 OR v_block9 <> 1 OR v_balance <> 2 THEN
    RAISE EXCEPTION
      'PDI adaptation first-save/edit mismatch: debits %, records %, gc %, block9 %, balance %',
      v_debits, v_records, v_gc, v_block9, v_balance;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 3. Insufficiency leaves all canonical PDI artifacts untouched.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity('authenticated', '00000000-0000-4000-8000-000000000502');
SELECT public.credit_validate_pdi_adaptation(
  '30000000-0000-4000-8000-000000000502',
  '20000000-0000-4000-8000-000000000502',
  '10000000-0000-4000-8000-000000000502',
  'lesson-502',
  'Aula 502',
  'Filosofia',
  'Sem saldo',
  '{"lesson_id":"lesson-502","lesson_title":"Aula 502","subject":"Filosofia","adaptacao_metodologica":"Sem saldo"}'::jsonb,
  '2026-08-15 15:32:00+00'
);
COMMIT;

DO $$
DECLARE
  v_records integer;
  v_gc integer;
  v_block9 integer;
  v_rejected integer;
BEGIN
  SELECT COUNT(*) INTO v_records FROM public.pdi_records
  WHERE id = '30000000-0000-4000-8000-000000000502';
  SELECT COUNT(*) INTO v_gc FROM public.generated_contents
  WHERE id = '30000000-0000-4000-8000-000000000502';
  SELECT jsonb_array_length(block_9_content) INTO v_block9 FROM public.pdi_documents
  WHERE id = '20000000-0000-4000-8000-000000000502';
  SELECT COUNT(*) INTO v_rejected FROM public.credit_operations
  WHERE user_id = '00000000-0000-4000-8000-000000000502'
    AND artifact_id = '30000000-0000-4000-8000-000000000502'
    AND outcome = 'REJECTED';

  IF v_records <> 0 OR v_gc <> 0 OR v_block9 <> 0 OR v_rejected <> 1 THEN
    RAISE EXCEPTION 'insufficient PDI save leaked persistence or missed receipt';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 4. Gold persists with no debit.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity('authenticated', '00000000-0000-4000-8000-000000000503');
SELECT public.credit_validate_pdi_adaptation(
  '30000000-0000-4000-8000-000000000503',
  '20000000-0000-4000-8000-000000000503',
  '10000000-0000-4000-8000-000000000503',
  'lesson-503',
  'Aula Gold',
  'Geografia',
  'Conteúdo Gold',
  '{"lesson_id":"lesson-503","lesson_title":"Aula Gold","subject":"Geografia","adaptacao_metodologica":"Gold"}'::jsonb,
  '2026-08-15 15:33:00+00'
);
COMMIT;

DO $$
DECLARE
  v_debits integer;
  v_records integer;
BEGIN
  SELECT COUNT(*) INTO v_debits FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-4000-8000-000000000503' AND entry_type = 'DEBIT';
  SELECT COUNT(*) INTO v_records FROM public.pdi_records
  WHERE id = '30000000-0000-4000-8000-000000000503';
  IF v_debits <> 0 OR v_records <> 1 THEN
    RAISE EXCEPTION 'Gold PDI adaptation did not persist no-charge';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 5. Cross-user artifact collision is rejected.
-- -----------------------------------------------------------------------------
DO $$
BEGIN
  PERFORM set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000000506', true);
  PERFORM set_config('request.jwt.claims', '{"sub":"00000000-0000-4000-8000-000000000506","role":"authenticated"}', true);
  BEGIN
    PERFORM public.credit_validate_pdi_adaptation(
      '30000000-0000-4000-8000-000000000501',
      '20000000-0000-4000-8000-000000000506',
      '10000000-0000-4000-8000-000000000506',
      'lesson-506',
      'Colisão',
      'Sociologia',
      'Não deve persistir',
      '{"lesson_id":"lesson-506"}'::jsonb,
      now()
    );
    RAISE EXCEPTION 'cross-user PDI artifact collision was accepted';
  EXCEPTION
    WHEN SQLSTATE '42501' THEN NULL;
  END;
END;
$$;

-- -----------------------------------------------------------------------------
-- 6. Persistence failure rolls economic receipt and debit back too.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pg_temp.fail_pdi_generated_content()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.id = '30000000-0000-4000-8000-000000000504' THEN
    RAISE EXCEPTION 'synthetic PDI persistence failure';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER synthetic_pdi_generated_content_failure
BEFORE INSERT ON public.generated_contents
FOR EACH ROW EXECUTE FUNCTION pg_temp.fail_pdi_generated_content();

DO $$
BEGIN
  PERFORM set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000000504', true);
  PERFORM set_config('request.jwt.claims', '{"sub":"00000000-0000-4000-8000-000000000504","role":"authenticated"}', true);
  BEGIN
    PERFORM public.credit_validate_pdi_adaptation(
      '30000000-0000-4000-8000-000000000504',
      '20000000-0000-4000-8000-000000000504',
      '10000000-0000-4000-8000-000000000504',
      'lesson-504',
      'Rollback',
      'Sociologia',
      'Falha sintética',
      '{"lesson_id":"lesson-504","adaptacao_metodologica":"rollback"}'::jsonb,
      now()
    );
    RAISE EXCEPTION 'synthetic persistence failure did not abort';
  EXCEPTION
    WHEN raise_exception THEN
      IF SQLERRM <> 'synthetic PDI persistence failure' THEN
        RAISE;
      END IF;
  END;
END;
$$;

DROP TRIGGER synthetic_pdi_generated_content_failure ON public.generated_contents;

DO $$
DECLARE
  v_records integer;
  v_debits integer;
  v_balance integer;
BEGIN
  SELECT COUNT(*) INTO v_records FROM public.pdi_records
  WHERE id = '30000000-0000-4000-8000-000000000504';
  SELECT COUNT(*) INTO v_debits FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-4000-8000-000000000504' AND entry_type = 'DEBIT';
  v_balance := (
    public.credit_balance_snapshot_internal(
      '00000000-0000-4000-8000-000000000504', now()
    )->>'total'
  )::integer;
  IF v_records <> 0 OR v_debits <> 0 OR v_balance <> 1 THEN
    RAISE EXCEPTION 'PDI rollback left partial persistence or debit';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 7. Generated pedagogical report: first save charged, edit/retry free.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity('authenticated', '00000000-0000-4000-8000-000000000501');
SELECT public.credit_save_pdi_generated_report(
  'report-4d-501',
  'Relatório PDI 501',
  'Relatório inicial',
  '2026-08-15 15:34:00+00'
);
SELECT public.credit_save_pdi_generated_report(
  'report-4d-501',
  'Relatório PDI 501',
  'Relatório editado',
  '2026-08-15 15:34:00+00'
);
COMMIT;

-- -----------------------------------------------------------------------------
-- 8. Final Block 11 report uses PDI document identity; edit is non-billable.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity('authenticated', '00000000-0000-4000-8000-000000000501');
SELECT public.credit_save_pdi_final_report(
  '20000000-0000-4000-8000-000000000501',
  'Parecer final inicial'
);
SELECT public.credit_save_pdi_final_report(
  '20000000-0000-4000-8000-000000000501',
  'Parecer final revisado'
);
COMMIT;

DO $$
DECLARE
  v_debits integer;
  v_balance integer;
  v_report text;
  v_generated_report text;
  v_final_gc text;
BEGIN
  SELECT COUNT(*) INTO v_debits FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-4000-8000-000000000501' AND entry_type = 'DEBIT';
  v_balance := (
    public.credit_balance_snapshot_internal(
      '00000000-0000-4000-8000-000000000501', now()
    )->>'total'
  )::integer;
  SELECT content INTO v_generated_report FROM public.generated_contents WHERE id = 'report-4d-501';
  SELECT final_report INTO v_report FROM public.pdi_documents
  WHERE id = '20000000-0000-4000-8000-000000000501';
  SELECT content INTO v_final_gc FROM public.generated_contents
  WHERE id = 'pdi-final-report-v1:20000000-0000-4000-8000-000000000501';

  IF v_debits <> 3 OR v_balance <> 0
     OR v_generated_report <> 'Relatório editado'
     OR v_report <> 'Parecer final revisado'
     OR v_final_gc <> 'Parecer final revisado' THEN
    RAISE EXCEPTION 'PDI report economics/persistence mismatch';
  END IF;
END;
$$;

SELECT 'OK:credit_pdi_atomic_save_1_3C_4D' AS result;
