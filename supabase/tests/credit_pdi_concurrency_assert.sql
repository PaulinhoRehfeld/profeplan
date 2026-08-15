-- =============================================================================
-- ProfePlan — Lote 1.3C.4D concurrent PDI save assertion
-- Disposable Supabase only. Executed after parallel sessions finish.
-- =============================================================================

\set ON_ERROR_STOP on

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
  WHERE user_id = '00000000-0000-4000-8000-000000000505'
    AND entry_type = 'DEBIT';

  SELECT COUNT(*) INTO v_records
  FROM public.pdi_records
  WHERE id = '30000000-0000-4000-8000-000000000505';

  SELECT COUNT(*) INTO v_gc
  FROM public.generated_contents
  WHERE id = '30000000-0000-4000-8000-000000000505';

  SELECT COUNT(*) INTO v_block9
  FROM public.pdi_documents AS pd,
       LATERAL jsonb_array_elements(pd.block_9_content) AS item
  WHERE pd.id = '20000000-0000-4000-8000-000000000505'
    AND item ->> 'artifact_id' = '30000000-0000-4000-8000-000000000505';

  v_balance := (
    public.credit_balance_snapshot_internal(
      '00000000-0000-4000-8000-000000000505', now()
    )->>'total'
  )::integer;

  IF v_debits <> 1 OR v_records <> 1 OR v_gc <> 1 OR v_block9 <> 1 OR v_balance <> 0 THEN
    RAISE EXCEPTION
      'concurrent PDI validation diverged: debits %, records %, gc %, block9 %, balance %',
      v_debits, v_records, v_gc, v_block9, v_balance;
  END IF;
END;
$$;

SELECT 'OK:credit_pdi_concurrency_1_3C_4D' AS result;
