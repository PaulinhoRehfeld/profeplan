-- Parallel-session assertion for Lote 1.3B.2.
\set ON_ERROR_STOP on

DO $$
DECLARE
  v_applied integer;
  v_rejected integer;
  v_debits integer;
  v_snapshot jsonb;
BEGIN
  SELECT COUNT(*) FILTER (WHERE outcome = 'APPLIED'),
         COUNT(*) FILTER (WHERE outcome = 'REJECTED')
    INTO v_applied, v_rejected
  FROM public.credit_operations
  WHERE user_id = '00000000-0000-0000-0000-000000000104'
    AND operation_id LIKE 'concurrent-104-%';

  SELECT COUNT(*) INTO v_debits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-0000-0000-000000000104'
    AND entry_type = 'DEBIT';

  SELECT public.credit_get_balance_for_user(
    '00000000-0000-0000-0000-000000000104'
  ) INTO v_snapshot;

  IF v_applied <> 1 OR v_rejected <> 7 OR v_debits <> 1 THEN
    RAISE EXCEPTION 'concurrency invariant failed applied=% rejected=% debits=%',
      v_applied, v_rejected, v_debits;
  END IF;

  IF (v_snapshot ->> 'total')::integer <> 0 THEN
    RAISE EXCEPTION 'concurrency left incorrect balance: %', v_snapshot;
  END IF;

  IF EXISTS (
    SELECT operation_id
    FROM public.credit_ledger_entries
    WHERE user_id = '00000000-0000-0000-0000-000000000104'
      AND entry_type = 'DEBIT'
    GROUP BY operation_id
    HAVING COUNT(*) > 1
  ) THEN
    RAISE EXCEPTION 'a semantic operation produced multiple debits';
  END IF;
END;
$$;

SELECT 'OK:credit_accounting_commands_concurrency_1_3B_2' AS result;
