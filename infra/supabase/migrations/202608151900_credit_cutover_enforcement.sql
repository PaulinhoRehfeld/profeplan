-- =============================================================================
-- ProfePlan credit accounting — Lote 1.3C.6 preflight
-- Final hosted-enforcement candidate for the governed credit cutover.
--
-- IMPORTANT:
-- - VERSIONED ONLY. NOT AUTHORIZED FOR HOSTED DEPLOYMENT by this commit;
-- - depends on the governed 1.3B/1.3C credit foundations and 1.3C.4D PDI RPCs;
-- - preserves legitimate non-billable PDI writes while blocking direct writes
--   that would bypass billable governed boundaries;
-- - must only be applied during a coordinated freeze/cutover after the web
--   bundle is ready to use governed consumer RPCs.
-- =============================================================================

BEGIN;

DO $$
BEGIN
  IF to_regclass('public.term_plans') IS NULL
     OR to_regclass('public.generated_contents') IS NULL
     OR to_regclass('public.pdi_records') IS NULL
     OR to_regclass('public.pdi_documents') IS NULL THEN
    RAISE EXCEPTION '1.3C.6 enforcement requires billable persistence tables';
  END IF;

  IF to_regprocedure('public.credit_save_term_plan(text,text,integer,text,text,text,text,integer,jsonb,integer,jsonb,text,text,text,jsonb)') IS NULL
     OR to_regprocedure('public.credit_save_generated_content(text,text,text,text,text,timestamptz)') IS NULL
     OR to_regprocedure('public.credit_validate_pdi_adaptation(uuid,uuid,uuid,text,text,text,text,jsonb,timestamptz)') IS NULL
     OR to_regprocedure('public.credit_save_pdi_generated_report(text,text,text,timestamptz)') IS NULL
     OR to_regprocedure('public.credit_save_pdi_final_report(uuid,text)') IS NULL THEN
    RAISE EXCEPTION '1.3C.6 enforcement requires all governed consumer RPCs';
  END IF;
END;
$$;

-- TermPlan and generated_contents are governed wholesale once the consumer
-- cutover is active. The authenticated browser must no longer persist those
-- billable artifacts directly.
REVOKE INSERT, UPDATE ON public.term_plans FROM authenticated;
REVOKE INSERT, UPDATE ON public.generated_contents FROM authenticated;

-- pdi_records is shared by billable adaptations and non-billable timeline
-- events. Do not revoke the table wholesale. Block only the economic adaptation
-- surface for direct anon/authenticated writes. SECURITY DEFINER governed RPCs
-- execute with their owner as current_user and therefore remain allowed.
CREATE OR REPLACE FUNCTION public.credit_guard_pdi_record_billable_write()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = pg_catalog, public
AS $$
BEGIN
  IF current_user IN ('authenticated', 'anon') THEN
    IF TG_OP = 'INSERT' THEN
      IF upper(COALESCE(NEW.type, '')) = 'ADAPTATION'
         OR lower(COALESCE(NEW.pdi_block, '')) = 'block9' THEN
        RAISE EXCEPTION 'direct billable PDI adaptation write is disabled; use governed RPC'
          USING ERRCODE = '42501';
      END IF;
    ELSIF TG_OP = 'UPDATE' THEN
      IF upper(COALESCE(OLD.type, '')) = 'ADAPTATION'
         OR lower(COALESCE(OLD.pdi_block, '')) = 'block9'
         OR upper(COALESCE(NEW.type, '')) = 'ADAPTATION'
         OR lower(COALESCE(NEW.pdi_block, '')) = 'block9' THEN
        RAISE EXCEPTION 'direct billable PDI adaptation update is disabled; use governed RPC'
          USING ERRCODE = '42501';
      END IF;
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public.credit_guard_pdi_record_billable_write() FROM PUBLIC;

DROP TRIGGER IF EXISTS credit_guard_pdi_record_billable_write ON public.pdi_records;
CREATE TRIGGER credit_guard_pdi_record_billable_write
  BEFORE INSERT OR UPDATE ON public.pdi_records
  FOR EACH ROW
  EXECUTE FUNCTION public.credit_guard_pdi_record_billable_write();

-- pdi_documents also mixes billable and non-billable sections. Preserve direct
-- editing of content_data/status/other pedagogical fields, but prevent a client
-- from bypassing the governed Block 9 and final-report boundaries.
CREATE OR REPLACE FUNCTION public.credit_guard_pdi_document_billable_write()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = pg_catalog, public
AS $$
BEGIN
  IF current_user IN ('authenticated', 'anon') THEN
    IF TG_OP = 'INSERT' THEN
      IF (NEW.block_9_content IS NOT NULL AND NEW.block_9_content <> '[]'::jsonb)
         OR NULLIF(btrim(NEW.final_report), '') IS NOT NULL THEN
        RAISE EXCEPTION 'direct billable PDI document content is disabled; use governed RPC'
          USING ERRCODE = '42501';
      END IF;
    ELSIF TG_OP = 'UPDATE' THEN
      IF NEW.block_9_content IS DISTINCT FROM OLD.block_9_content
         OR NEW.final_report IS DISTINCT FROM OLD.final_report THEN
        RAISE EXCEPTION 'direct billable PDI document update is disabled; use governed RPC'
          USING ERRCODE = '42501';
      END IF;
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public.credit_guard_pdi_document_billable_write() FROM PUBLIC;

DROP TRIGGER IF EXISTS credit_guard_pdi_document_billable_write ON public.pdi_documents;
CREATE TRIGGER credit_guard_pdi_document_billable_write
  BEFORE INSERT OR UPDATE ON public.pdi_documents
  FOR EACH ROW
  EXECUTE FUNCTION public.credit_guard_pdi_document_billable_write();

COMMIT;
