-- =============================================================================
-- Disposable proof matrix — ProfePlan Credit Accounting Lote 1.3B.3
-- Atomic term-plan save pilot
-- =============================================================================
\set ON_ERROR_STOP on

INSERT INTO public.profiles (id, tier, credits, is_unlimited) VALUES
  ('00000000-0000-0000-0000-000000000201', 'FREE', 999, false),
  ('00000000-0000-0000-0000-000000000202', 'GOLD', 0, true),
  ('00000000-0000-0000-0000-000000000203', 'FREE', 0, false),
  ('00000000-0000-0000-0000-000000000204', 'FREE', 0, false),
  ('00000000-0000-0000-0000-000000000205', 'FREE', 0, false),
  ('00000000-0000-0000-0000-000000000206', 'FREE', 0, false);

-- ---------------------------------------------------------------------------
-- 1. Permission boundary
-- ---------------------------------------------------------------------------
DO $$
DECLARE
  v_signature text := 'public.credit_save_term_plan(text,text,integer,text,text,text,text,integer,jsonb,integer,jsonb,text,text,text,jsonb)';
BEGIN
  IF NOT has_function_privilege('authenticated', v_signature, 'EXECUTE') THEN
    RAISE EXCEPTION 'authenticated cannot execute governed term-plan save';
  END IF;

  IF has_function_privilege('anon', v_signature, 'EXECUTE')
     OR has_function_privilege('service_role', v_signature, 'EXECUTE') THEN
    RAISE EXCEPTION 'governed term-plan save leaked outside authenticated';
  END IF;

  IF has_function_privilege(
       'authenticated',
       'public.credit_consume_internal(uuid,text,text,text,text,text,jsonb)',
       'EXECUTE'
     ) THEN
    RAISE EXCEPTION 'authenticated can still call private consume primitive';
  END IF;
END;
$$;

-- ---------------------------------------------------------------------------
-- 2. User 201: profiles.credits is intentionally 999, ledger has exactly 2.
--    Same payload must replay; a real edit charges once; third edit is rejected.
-- ---------------------------------------------------------------------------
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000201',
  'grant-purchased-201',
  'GRANT_PURCHASE',
  'fp-grant-purchased-201',
  'purchase:201:1',
  'PURCHASED',
  2,
  clock_timestamp(),
  NULL,
  'stripe:test:201',
  '{}'::jsonb
);

SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000201', false);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-000000000201","role":"authenticated"}',
  false
);

SELECT public.credit_save_term_plan(
  'plan-201',
  'Planejamento 1º Trimestre - História',
  1,
  'Trimestre',
  'História',
  '1º Ano EM',
  'Ensino Médio',
  2,
  '{"monthlyExam":true,"termExam":true,"recovery":true}'::jsonb,
  24,
  '{"vistos":5,"trabalhos":5,"monthlyExam":10,"termExam":10,"others":0}'::jsonb,
  'Minas Gerais',
  'Estadual',
  'VERSAO-1',
  '[{"number":1,"title":"Aula 1"}]'::jsonb
);

DO $$
DECLARE
  v_debits integer;
  v_ops integer;
BEGIN
  SELECT COUNT(*) INTO v_debits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-0000-0000-000000000201'
    AND entry_type = 'DEBIT';

  SELECT COUNT(*) INTO v_ops
  FROM public.credit_operations
  WHERE user_id = '00000000-0000-0000-0000-000000000201'
    AND artifact_id = 'plan-201';

  IF v_debits <> 1 OR v_ops <> 1 THEN
    RAISE EXCEPTION 'first atomic save did not create exactly one economic operation/debit';
  END IF;

  IF (SELECT generated_text FROM public.term_plans WHERE id = 'plan-201') <> 'VERSAO-1' THEN
    RAISE EXCEPTION 'first atomic save did not persist canonical term plan';
  END IF;
END;
$$;

-- Exact replay: server-derived fingerprint/operation id must prevent a new debit.
SELECT public.credit_save_term_plan(
  'plan-201',
  'Planejamento 1º Trimestre - História',
  1,
  'Trimestre',
  'História',
  '1º Ano EM',
  'Ensino Médio',
  2,
  '{"monthlyExam":true,"termExam":true,"recovery":true}'::jsonb,
  24,
  '{"vistos":5,"trabalhos":5,"monthlyExam":10,"termExam":10,"others":0}'::jsonb,
  'Minas Gerais',
  'Estadual',
  'VERSAO-1',
  '[{"number":1,"title":"Aula 1"}]'::jsonb
);

DO $$
BEGIN
  IF (
    SELECT COUNT(*)
    FROM public.credit_ledger_entries
    WHERE user_id = '00000000-0000-0000-0000-000000000201'
      AND entry_type = 'DEBIT'
  ) <> 1 THEN
    RAISE EXCEPTION 'exact save replay created a second debit';
  END IF;
END;
$$;

-- Real content edit -> new canonical fingerprint -> second and final credit.
SELECT public.credit_save_term_plan(
  'plan-201',
  'Planejamento 1º Trimestre - História',
  1,
  'Trimestre',
  'História',
  '1º Ano EM',
  'Ensino Médio',
  2,
  '{"monthlyExam":true,"termExam":true,"recovery":true}'::jsonb,
  24,
  '{"vistos":5,"trabalhos":5,"monthlyExam":10,"termExam":10,"others":0}'::jsonb,
  'Minas Gerais',
  'Estadual',
  'VERSAO-2',
  '[{"number":1,"title":"Aula 1 revisada"}]'::jsonb
);

DO $$
DECLARE
  v_snapshot jsonb;
BEGIN
  SELECT public.credit_get_balance_for_user(
    '00000000-0000-0000-0000-000000000201'
  ) INTO v_snapshot;

  IF (v_snapshot ->> 'total')::integer <> 0
     OR (SELECT COUNT(*) FROM public.credit_ledger_entries
         WHERE user_id = '00000000-0000-0000-0000-000000000201'
           AND entry_type = 'DEBIT') <> 2
     OR (SELECT generated_text FROM public.term_plans WHERE id = 'plan-201') <> 'VERSAO-2' THEN
    RAISE EXCEPTION 'edited save did not consume exactly the second ledger credit';
  END IF;
END;
$$;

-- A third changed payload is rejected. The previously saved artifact survives.
SELECT public.credit_save_term_plan(
  'plan-201',
  'Planejamento 1º Trimestre - História',
  1,
  'Trimestre',
  'História',
  '1º Ano EM',
  'Ensino Médio',
  2,
  '{"monthlyExam":true,"termExam":true,"recovery":true}'::jsonb,
  24,
  '{"vistos":5,"trabalhos":5,"monthlyExam":10,"termExam":10,"others":0}'::jsonb,
  'Minas Gerais',
  'Estadual',
  'VERSAO-3-SEM-SALDO',
  '[{"number":1,"title":"Nao deve persistir"}]'::jsonb
);

DO $$
BEGIN
  IF (SELECT generated_text FROM public.term_plans WHERE id = 'plan-201') <> 'VERSAO-2' THEN
    RAISE EXCEPTION 'rejected save overwrote the last canonical artifact';
  END IF;

  IF (
    SELECT COUNT(*)
    FROM public.credit_operations
    WHERE user_id = '00000000-0000-0000-0000-000000000201'
      AND artifact_id = 'plan-201'
      AND outcome = 'REJECTED'
      AND reason_code = 'INSUFFICIENT_CREDITS'
  ) <> 1 THEN
    RAISE EXCEPTION 'insufficient save did not retain its controlled rejection receipt';
  END IF;

  IF (
    SELECT COUNT(*)
    FROM public.credit_ledger_entries
    WHERE user_id = '00000000-0000-0000-0000-000000000201'
      AND entry_type = 'DEBIT'
  ) <> 2 THEN
    RAISE EXCEPTION 'insufficient save created an extra debit';
  END IF;
END;
$$;

-- ---------------------------------------------------------------------------
-- 3. Gold: canonical save persists, economic receipt is NO_CHARGE, no debit.
-- ---------------------------------------------------------------------------
SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000202', false);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-000000000202","role":"authenticated"}',
  false
);

SELECT public.credit_save_term_plan(
  'plan-gold-202', 'Plano Gold', 1, 'Trimestre', 'Filosofia', '2º Ano EM',
  'Ensino Médio', 2, '{}'::jsonb, 24, '{}'::jsonb, 'Minas Gerais', 'Estadual',
  'CONTEUDO-GOLD', '[]'::jsonb
);

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.term_plans WHERE id = 'plan-gold-202') THEN
    RAISE EXCEPTION 'Gold term plan was not persisted';
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.credit_ledger_entries
    WHERE user_id = '00000000-0000-0000-0000-000000000202'
      AND entry_type = 'DEBIT'
  ) THEN
    RAISE EXCEPTION 'Gold term-plan save created a debit';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.credit_operations
    WHERE user_id = '00000000-0000-0000-0000-000000000202'
      AND artifact_id = 'plan-gold-202'
      AND outcome = 'NO_CHARGE'
      AND reason_code = 'GOLD_UNLIMITED'
  ) THEN
    RAISE EXCEPTION 'Gold term-plan save did not produce auditable NO_CHARGE receipt';
  END IF;
END;
$$;

-- ---------------------------------------------------------------------------
-- 4. Persistence failure after economic decision must roll back receipt/debit.
-- ---------------------------------------------------------------------------
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000203',
  'grant-purchased-203', 'GRANT_PURCHASE', 'fp-grant-purchased-203',
  'purchase:203:1', 'PURCHASED', 1, clock_timestamp(), NULL,
  'stripe:test:203', '{}'::jsonb
);

CREATE OR REPLACE FUNCTION pg_temp.fail_term_plan_203()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.id = 'plan-rollback-203' THEN
    RAISE EXCEPTION 'forced canonical persistence failure for 1.3B.3 test';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER term_plan_203_forced_failure
BEFORE INSERT OR UPDATE ON public.term_plans
FOR EACH ROW EXECUTE FUNCTION pg_temp.fail_term_plan_203();

SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000203', false);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-000000000203","role":"authenticated"}',
  false
);

DO $$
BEGIN
  BEGIN
    PERFORM public.credit_save_term_plan(
      'plan-rollback-203', 'Plano rollback', 1, 'Trimestre', 'Sociologia', '1º Ano EM',
      'Ensino Médio', 2, '{}'::jsonb, 24, '{}'::jsonb, 'Minas Gerais', 'Estadual',
      'NAO-DEVE-SOBREVIVER', '[]'::jsonb
    );
    RAISE EXCEPTION 'forced persistence failure was not raised';
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLERRM NOT LIKE '%forced canonical persistence failure%' THEN
        RAISE;
      END IF;
  END;
END;
$$;

DROP TRIGGER term_plan_203_forced_failure ON public.term_plans;

DO $$
DECLARE
  v_snapshot jsonb;
BEGIN
  IF EXISTS (SELECT 1 FROM public.term_plans WHERE id = 'plan-rollback-203')
     OR EXISTS (
       SELECT 1 FROM public.credit_operations
       WHERE user_id = '00000000-0000-0000-0000-000000000203'
         AND artifact_id = 'plan-rollback-203'
     )
     OR EXISTS (
       SELECT 1 FROM public.credit_ledger_entries
       WHERE user_id = '00000000-0000-0000-0000-000000000203'
         AND entry_type = 'DEBIT'
     ) THEN
    RAISE EXCEPTION 'failed canonical persistence left economic or artifact residue';
  END IF;

  SELECT public.credit_get_balance_for_user(
    '00000000-0000-0000-0000-000000000203'
  ) INTO v_snapshot;

  IF (v_snapshot ->> 'total')::integer <> 1 THEN
    RAISE EXCEPTION 'rollback did not restore available credit';
  END IF;
END;
$$;

-- ---------------------------------------------------------------------------
-- 5. Cross-user artifact collision must fail before charging the second user.
-- ---------------------------------------------------------------------------
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000204',
  'grant-purchased-204', 'GRANT_PURCHASE', 'fp-grant-purchased-204',
  'purchase:204:1', 'PURCHASED', 1, clock_timestamp(), NULL,
  'stripe:test:204', '{}'::jsonb
);
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000205',
  'grant-purchased-205', 'GRANT_PURCHASE', 'fp-grant-purchased-205',
  'purchase:205:1', 'PURCHASED', 1, clock_timestamp(), NULL,
  'stripe:test:205', '{}'::jsonb
);

SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000204', false);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-000000000204","role":"authenticated"}',
  false
);
SELECT public.credit_save_term_plan(
  'shared-plan-204-205', 'Shared id owner', 1, 'Trimestre', 'Geografia', '1º Ano EM',
  'Ensino Médio', 2, '{}'::jsonb, 24, '{}'::jsonb, 'Minas Gerais', 'Estadual',
  'OWNER-204', '[]'::jsonb
);

SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000205', false);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"00000000-0000-0000-0000-000000000205","role":"authenticated"}',
  false
);
DO $$
BEGIN
  BEGIN
    PERFORM public.credit_save_term_plan(
      'shared-plan-204-205', 'Collision', 1, 'Trimestre', 'Geografia', '2º Ano EM',
      'Ensino Médio', 2, '{}'::jsonb, 24, '{}'::jsonb, 'Minas Gerais', 'Estadual',
      'ATTACK-205', '[]'::jsonb
    );
    RAISE EXCEPTION 'cross-user plan collision was accepted';
  EXCEPTION
    WHEN SQLSTATE '42501' THEN NULL;
  END;
END;
$$;

DO $$
DECLARE
  v_snapshot jsonb;
BEGIN
  IF (SELECT user_id FROM public.term_plans WHERE id = 'shared-plan-204-205') IS DISTINCT FROM
     '00000000-0000-0000-0000-000000000204'::uuid THEN
    RAISE EXCEPTION 'cross-user collision changed canonical owner';
  END IF;

  SELECT public.credit_get_balance_for_user(
    '00000000-0000-0000-0000-000000000205'
  ) INTO v_snapshot;
  IF (v_snapshot ->> 'total')::integer <> 1 THEN
    RAISE EXCEPTION 'cross-user collision charged the rejected user';
  END IF;
END;
$$;

-- ---------------------------------------------------------------------------
-- 6. Prepare one-credit user for parallel exact-replay proof in the workflow.
-- ---------------------------------------------------------------------------
SELECT public.credit_grant_command(
  '00000000-0000-0000-0000-000000000206',
  'grant-concurrency-206', 'GRANT_PURCHASE', 'fp-grant-concurrency-206',
  'purchase:206:1', 'PURCHASED', 1, clock_timestamp(), NULL,
  'stripe:test:206', '{}'::jsonb
);

SELECT 'OK:credit_term_plan_atomic_save_1_3B_3' AS result;
