-- =============================================================================
-- ProfePlan — Lote 1.3C.4A parallel first-save assertion
-- Run after concurrent sessions target the same user + artifact id.
-- =============================================================================

\set ON_ERROR_STOP on

DO $$
DECLARE
  v_rows integer;
  v_applied integer;
  v_no_charge integer;
  v_debits integer;
  v_balance integer;
BEGIN
  SELECT COUNT(*) INTO v_rows
  FROM public.generated_contents
  WHERE id = 'artifact-4a-505-concurrent'
    AND user_id = '00000000-0000-4000-8000-000000000505';

  SELECT
    COUNT(*) FILTER (WHERE outcome = 'APPLIED'),
    COUNT(*) FILTER (WHERE outcome = 'NO_CHARGE')
  INTO v_applied, v_no_charge
  FROM public.credit_operations
  WHERE user_id = '00000000-0000-4000-8000-000000000505'
    AND operation_kind = 'CONSUME'
    AND artifact_id = 'artifact-4a-505-concurrent';

  SELECT COUNT(*) INTO v_debits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-4000-8000-000000000505'
    AND entry_type = 'DEBIT';

  v_balance := (
    public.credit_balance_snapshot_internal(
      '00000000-0000-4000-8000-000000000505', now()
    )->>'total'
  )::integer;

  IF v_rows <> 1 OR v_applied <> 1 OR v_no_charge <> 0
     OR v_debits <> 1 OR v_balance <> 0 THEN
    RAISE EXCEPTION
      'parallel first-save mismatch: rows %, applied %, no_charge_ops %, debits %, balance %',
      v_rows, v_applied, v_no_charge, v_debits, v_balance;
  END IF;
END;
$$;

SELECT 'OK:credit_generated_content_concurrency_1_3C_4A' AS result;
