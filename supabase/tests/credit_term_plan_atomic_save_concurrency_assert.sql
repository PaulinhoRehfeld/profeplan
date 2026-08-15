-- Assert exact-replay concurrency for Lote 1.3B.3.
DO $$
DECLARE
  v_ops integer;
  v_debits integer;
  v_snapshot jsonb;
BEGIN
  SELECT COUNT(*) INTO v_ops
  FROM public.credit_operations
  WHERE user_id = '00000000-0000-0000-0000-000000000206'
    AND artifact_id = 'plan-concurrent-206'
    AND action_key = 'SAVE_TERM_PLAN';

  SELECT COUNT(*) INTO v_debits
  FROM public.credit_ledger_entries
  WHERE user_id = '00000000-0000-0000-0000-000000000206'
    AND entry_type = 'DEBIT';

  SELECT public.credit_get_balance_for_user(
    '00000000-0000-0000-0000-000000000206'
  ) INTO v_snapshot;

  IF v_ops <> 1 THEN
    RAISE EXCEPTION 'parallel exact saves produced % operations; expected 1', v_ops;
  END IF;

  IF v_debits <> 1 THEN
    RAISE EXCEPTION 'parallel exact saves produced % debits; expected 1', v_debits;
  END IF;

  IF (v_snapshot ->> 'total')::integer <> 0 THEN
    RAISE EXCEPTION 'parallel exact save final balance is not zero: %', v_snapshot;
  END IF;

  IF (
    SELECT COUNT(*) FROM public.term_plans
    WHERE id = 'plan-concurrent-206'
      AND user_id = '00000000-0000-0000-0000-000000000206'
      AND generated_text = 'CONCORRENCIA-EXATA'
  ) <> 1 THEN
    RAISE EXCEPTION 'parallel exact saves did not converge on one canonical term plan';
  END IF;
END;
$$;

SELECT 'OK:credit_term_plan_atomic_save_concurrency_1_3B_3' AS result;
