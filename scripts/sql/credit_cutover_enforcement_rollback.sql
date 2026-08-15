-- =============================================================================
-- ProfePlan — Lote 1.3C.6 enforcement rollback candidate
--
-- VERSIONED ONLY. Do not run against hosted production without explicit
-- material authorization and a matching preflight snapshot.
--
-- Restores only the direct-write surface changed by
-- 202608151900_credit_cutover_enforcement.sql. It deliberately does NOT remove
-- ledger tables, grants, operations, or governed RPCs.
-- =============================================================================

BEGIN;

GRANT INSERT, UPDATE ON public.term_plans TO anon, authenticated;
GRANT INSERT, UPDATE ON public.generated_contents TO anon, authenticated;

DROP TRIGGER IF EXISTS credit_guard_pdi_record_billable_write ON public.pdi_records;
DROP TRIGGER IF EXISTS credit_guard_pdi_document_billable_write ON public.pdi_documents;

DROP FUNCTION IF EXISTS public.credit_guard_pdi_record_billable_write();
DROP FUNCTION IF EXISTS public.credit_guard_pdi_document_billable_write();

COMMIT;
