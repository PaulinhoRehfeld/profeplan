-- =============================================================================
-- ProfePlan — Lote 1.3C.4A generated-content atomic save validation
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

-- Seed governed balances through the public grant command; never touch the
-- ledger tables directly.
SELECT public.credit_grant_command(
  '00000000-0000-4000-8000-000000000501',
  'grant-4a-user-501-initial',
  'GRANT_TEST_PURCHASED',
  'grant-4a-user-501-initial:2',
  'grant-4a:user-501:initial',
  'PURCHASED',
  2,
  '2026-08-15 02:00:00+00',
  NULL,
  'synthetic-4a',
  '{"test":"1.3C.4A"}'::jsonb
);

SELECT public.credit_grant_command(
  '00000000-0000-4000-8000-000000000504',
  'grant-4a-user-504-rollback',
  'GRANT_TEST_PURCHASED',
  'grant-4a-user-504-rollback:1',
  'grant-4a:user-504:rollback',
  'PURCHASED',
  1,
  '2026-08-15 02:00:00+00',
  NULL,
  'synthetic-4a',
  '{"test":"1.3C.4A"}'::jsonb
);

SELECT public.credit_grant_command(
  '00000000-0000-4000-8000-000000000505',
  'grant-4a-user-505-concurrency',
  'GRANT_TEST_PURCHASED',
  'grant-4a-user-505-concurrency:1',
  'grant-4a:user-505:concurrency',
  'PURCHASED',
  1,
  '2026-08-15 02:00:00+00',
  NULL,
  'synthetic-4a',
  '{"test":"1.3C.4A"}'::jsonb
);

-- -----------------------------------------------------------------------------
-- 1. RPC permissions
-- -----------------------------------------------------------------------------
DO $$
BEGIN
  IF has_function_privilege(
    'anon',
    'public.credit_save_generated_content(text,text,text,text,text,timestamptz)',
    'EXECUTE'
  ) THEN
    RAISE EXCEPTION 'anon must not execute governed generated-content save';
  END IF;

  IF NOT has_function_privilege(
    'authenticated',
    'public.credit_save_generated_content(text,text,text,text,text,timestamptz)',
    'EXECUTE'
  ) THEN
    RAISE EXCEPTION 'authenticated must execute governed generated-content save';
  END IF;

  IF has_function_privilege(
    'service_role',
    'public.credit_save_generated_content(text,text,text,text,text,timestamptz)',
    'EXECUTE'
  ) THEN
    RAISE EXCEPTION 'service_role must not execute user-facing governed save';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 2. First save = one debit; exact retry and real edit = no extra debit.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000501'
);

SELECT public.credit_save_generated_content(
  'artifact-4a-501-a',
  'plano',
  'PLANOS DE AULA',
  'Plano 501 A',
  'Conteúdo canônico inicial',
  '2026-08-15 02:10:00+00'
);

SELECT public.credit_save_generated_content(
  'artifact-4a-501-a',
  'plano',
  'PLANOS DE AULA',
  'Plano 501 A',
  'Conteúdo canônico inicial',
  '2026-08-15 02:10:00+00'
);

SELECT public.credit_save_generated_content(
  'artifact-4a-501-a',
  'plano',
  'PLANOS DE AULA',
  'Plano 501 A revisado',
  'Conteúdo canônico editado',
  '2026-08-15 02:10:00+00'
);
COMMIT;

DO $$
DECLARE
  v_row public.generated_contents%ROWTYPE;
  v_consume_ops integer;
  v_debits integer;
  v_balance integer;
BEGIN
  SELECT * INTO v_row
  FROM public.generated_contents
  WHERE id = 'artifact-4a-501-a';

  SELECT COUNT(*) INTO v_consume_ops
  FROM public.credit_operations
  WHERE user_id = '00000000-0000-4000-8000-000000000501'
    AND operation_kind = 'CONSUME'
    AND artifact_id = 'artifact-4a-501-a';

  SELECT COUNT(*) INTO v_debits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-4000-8000-000000000501'
    AND entry_type = 'DEBIT';

  v_balance := (
    public.credit_balance_snapshot_internal(
      '00000000-0000-4000-8000-000000000501',
      now()
    )->>'total'
  )::integer;

  IF v_row.id IS NULL OR v_row.title <> 'Plano 501 A revisado'
     OR v_row.content <> 'Conteúdo canônico editado' THEN
    RAISE EXCEPTION 'canonical edit was not persisted correctly';
  END IF;

  IF v_consume_ops <> 1 OR v_debits <> 1 OR v_balance <> 1 THEN
    RAISE EXCEPTION
      'first-save/edit economics mismatch: operations %, debits %, balance %',
      v_consume_ops, v_debits, v_balance;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 3. A second artifact consumes the second credit.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000501'
);
SELECT public.credit_save_generated_content(
  'artifact-4a-501-b',
  'simulado',
  'SIMULADOS',
  'Simulado 501 B',
  'Segundo artefato canônico',
  '2026-08-15 02:11:00+00'
);
COMMIT;

DO $$
DECLARE
  v_balance integer;
  v_debits integer;
BEGIN
  v_balance := (
    public.credit_balance_snapshot_internal(
      '00000000-0000-4000-8000-000000000501', now()
    )->>'total'
  )::integer;
  SELECT COUNT(*) INTO v_debits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-4000-8000-000000000501'
    AND entry_type = 'DEBIT';

  IF v_balance <> 0 OR v_debits <> 2 THEN
    RAISE EXCEPTION 'second artifact was not charged exactly once: balance %, debits %',
      v_balance, v_debits;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 4. Insufficiency creates no artifact. After a new governed grant, a later
--    retry of the SAME artifact id can succeed (no permanent rejected replay).
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000501'
);
SELECT public.credit_save_generated_content(
  'artifact-4a-501-c',
  'material',
  'MATERIAIS ALUNOS',
  'Material 501 C',
  'Primeira tentativa sem saldo',
  '2026-08-15 02:12:00+00'
);
COMMIT;

DO $$
DECLARE
  v_rows integer;
  v_rejected integer;
BEGIN
  SELECT COUNT(*) INTO v_rows
  FROM public.generated_contents
  WHERE id = 'artifact-4a-501-c';

  SELECT COUNT(*) INTO v_rejected
  FROM public.credit_operations
  WHERE user_id = '00000000-0000-4000-8000-000000000501'
    AND artifact_id = 'artifact-4a-501-c'
    AND outcome = 'REJECTED';

  IF v_rows <> 0 OR v_rejected <> 1 THEN
    RAISE EXCEPTION 'insufficient save persisted artifact or missed receipt: rows %, rejected %',
      v_rows, v_rejected;
  END IF;
END;
$$;

RESET ROLE;
SELECT public.credit_grant_command(
  '00000000-0000-4000-8000-000000000501',
  'grant-4a-user-501-after-rejection',
  'GRANT_TEST_BONUS',
  'grant-4a-user-501-after-rejection:1',
  'grant-4a:user-501:after-rejection',
  'PROMOTIONAL_BONUS',
  1,
  '2026-08-15 02:13:00+00',
  NULL,
  'synthetic-4a',
  '{"test":"retry-after-insufficient"}'::jsonb
);

BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000501'
);
SELECT public.credit_save_generated_content(
  'artifact-4a-501-c',
  'material',
  'MATERIAIS ALUNOS',
  'Material 501 C',
  'Segunda tentativa após novo grant',
  '2026-08-15 02:12:00+00'
);
COMMIT;

DO $$
DECLARE
  v_rows integer;
  v_rejected integer;
  v_applied integer;
  v_debits integer;
BEGIN
  SELECT COUNT(*) INTO v_rows
  FROM public.generated_contents
  WHERE id = 'artifact-4a-501-c';

  SELECT
    COUNT(*) FILTER (WHERE outcome = 'REJECTED'),
    COUNT(*) FILTER (WHERE outcome = 'APPLIED')
  INTO v_rejected, v_applied
  FROM public.credit_operations
  WHERE user_id = '00000000-0000-4000-8000-000000000501'
    AND artifact_id = 'artifact-4a-501-c';

  SELECT COUNT(*) INTO v_debits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-4000-8000-000000000501'
    AND entry_type = 'DEBIT';

  IF v_rows <> 1 OR v_rejected <> 1 OR v_applied <> 1 OR v_debits <> 3 THEN
    RAISE EXCEPTION
      'retry after insufficient mismatch: rows %, rejected %, applied %, total debits %',
      v_rows, v_rejected, v_applied, v_debits;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 5. A user with no balance is rejected and receives no canonical row.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000502'
);
SELECT public.credit_save_generated_content(
  'artifact-4a-502-no-balance',
  'documento',
  'OUTROS',
  'Sem saldo',
  'Não deve persistir',
  '2026-08-15 02:14:00+00'
);
COMMIT;

DO $$
DECLARE
  v_rows integer;
BEGIN
  SELECT COUNT(*) INTO v_rows
  FROM public.generated_contents
  WHERE id = 'artifact-4a-502-no-balance';
  IF v_rows <> 0 THEN
    RAISE EXCEPTION 'insufficient user received a canonical artifact';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 6. Gold first save persists with NO_CHARGE and zero DEBIT.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000503'
);
SELECT public.credit_save_generated_content(
  'artifact-4a-503-gold',
  'plano',
  'PLANOS DE AULA',
  'Gold 503',
  'Artefato unlimited',
  '2026-08-15 02:15:00+00'
);
COMMIT;

DO $$
DECLARE
  v_rows integer;
  v_no_charge integer;
  v_debits integer;
BEGIN
  SELECT COUNT(*) INTO v_rows
  FROM public.generated_contents
  WHERE id = 'artifact-4a-503-gold';
  SELECT COUNT(*) INTO v_no_charge
  FROM public.credit_operations
  WHERE user_id = '00000000-0000-4000-8000-000000000503'
    AND artifact_id = 'artifact-4a-503-gold'
    AND outcome = 'NO_CHARGE';
  SELECT COUNT(*) INTO v_debits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-4000-8000-000000000503'
    AND entry_type = 'DEBIT';

  IF v_rows <> 1 OR v_no_charge <> 1 OR v_debits <> 0 THEN
    RAISE EXCEPTION 'Gold save mismatch: rows %, no_charge %, debits %',
      v_rows, v_no_charge, v_debits;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 7. Cross-user existing artifact collision fails before any economic consume.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000506'
);
DO $$
DECLARE
  v_caught boolean := false;
BEGIN
  BEGIN
    PERFORM public.credit_save_generated_content(
      'artifact-4a-501-a',
      'plano',
      'PLANOS DE AULA',
      'Colisão',
      'Não pode sobrescrever',
      '2026-08-15 02:16:00+00'
    );
  EXCEPTION
    WHEN SQLSTATE '42501' THEN
      v_caught := true;
  END;

  IF NOT v_caught THEN
    RAISE EXCEPTION 'cross-user existing artifact collision did not fail closed';
  END IF;
END;
$$;
COMMIT;

DO $$
DECLARE
  v_consume_ops integer;
BEGIN
  SELECT COUNT(*) INTO v_consume_ops
  FROM public.credit_operations
  WHERE user_id = '00000000-0000-4000-8000-000000000506'
    AND operation_kind = 'CONSUME';
  IF v_consume_ops <> 0 THEN
    RAISE EXCEPTION 'cross-user rejection created economic consume state';
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 8. Persistence failure after economic decision rolls receipt + DEBIT back.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pg_temp.fail_4a_generated_content_insert()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.id = 'artifact-4a-504-forced-failure' THEN
    RAISE EXCEPTION 'forced 4A canonical persistence failure';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER fail_4a_generated_content_insert
BEFORE INSERT ON public.generated_contents
FOR EACH ROW
EXECUTE FUNCTION pg_temp.fail_4a_generated_content_insert();

BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000504'
);
DO $$
DECLARE
  v_caught boolean := false;
BEGIN
  BEGIN
    PERFORM public.credit_save_generated_content(
      'artifact-4a-504-forced-failure',
      'plano',
      'PLANOS DE AULA',
      'Falha forçada',
      'Rollback obrigatório',
      '2026-08-15 02:17:00+00'
    );
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLERRM LIKE '%forced 4A canonical persistence failure%' THEN
        v_caught := true;
      ELSE
        RAISE;
      END IF;
  END;

  IF NOT v_caught THEN
    RAISE EXCEPTION 'forced canonical failure was not observed';
  END IF;
END;
$$;
COMMIT;

DROP TRIGGER fail_4a_generated_content_insert ON public.generated_contents;

DO $$
DECLARE
  v_rows integer;
  v_consume_ops integer;
  v_debits integer;
  v_balance integer;
BEGIN
  SELECT COUNT(*) INTO v_rows
  FROM public.generated_contents
  WHERE id = 'artifact-4a-504-forced-failure';
  SELECT COUNT(*) INTO v_consume_ops
  FROM public.credit_operations
  WHERE user_id = '00000000-0000-4000-8000-000000000504'
    AND operation_kind = 'CONSUME';
  SELECT COUNT(*) INTO v_debits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-4000-8000-000000000504'
    AND entry_type = 'DEBIT';
  v_balance := (
    public.credit_balance_snapshot_internal(
      '00000000-0000-4000-8000-000000000504', now()
    )->>'total'
  )::integer;

  IF v_rows <> 0 OR v_consume_ops <> 0 OR v_debits <> 0 OR v_balance <> 1 THEN
    RAISE EXCEPTION
      'forced persistence rollback leaked state: rows %, operations %, debits %, balance %',
      v_rows, v_consume_ops, v_debits, v_balance;
  END IF;
END;
$$;

-- -----------------------------------------------------------------------------
-- 9. Dedicated/unsupported content types fail closed.
-- -----------------------------------------------------------------------------
BEGIN;
SET LOCAL ROLE authenticated;
SELECT pg_temp.credit_set_identity(
  'authenticated',
  '00000000-0000-4000-8000-000000000504'
);
DO $$
DECLARE
  v_caught integer := 0;
BEGIN
  BEGIN
    PERFORM public.credit_save_generated_content(
      'artifact-4a-dedicated-term', 'trimestral', 'TRIMESTRAIS', 'Term', 'x', now()
    );
  EXCEPTION WHEN SQLSTATE '22023' THEN
    v_caught := v_caught + 1;
  END;

  BEGIN
    PERFORM public.credit_save_generated_content(
      'artifact-4a-dedicated-pdi', 'adaptacao_pdi', 'PDI', 'PDI', 'x', now()
    );
  EXCEPTION WHEN SQLSTATE '22023' THEN
    v_caught := v_caught + 1;
  END;

  BEGIN
    PERFORM public.credit_save_generated_content(
      'artifact-4a-unknown', 'unknown-economic-type', 'OUTROS', 'Unknown', 'x', now()
    );
  EXCEPTION WHEN SQLSTATE '22023' THEN
    v_caught := v_caught + 1;
  END;

  IF v_caught <> 3 THEN
    RAISE EXCEPTION 'dedicated/unsupported type guard mismatch: %', v_caught;
  END IF;
END;
$$;
COMMIT;

-- -----------------------------------------------------------------------------
-- 10. Legacy aggregate integer is never mutated by governed saves.
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  v_nonzero_legacy integer;
BEGIN
  SELECT COUNT(*) INTO v_nonzero_legacy
  FROM public.profiles
  WHERE credits <> 0;

  IF v_nonzero_legacy <> 0 THEN
    RAISE EXCEPTION 'governed generated-content saves mutated profiles.credits';
  END IF;
END;
$$;

SELECT 'OK:credit_generated_content_atomic_save_1_3C_4A' AS result;
