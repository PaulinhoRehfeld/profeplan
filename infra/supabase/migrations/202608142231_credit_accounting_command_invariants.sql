-- Lote 1.3B.2 hardening: one economic GRANT operation funds exactly one lot,
-- and every positive lot carries a concrete producer/source reference.
BEGIN;

CREATE UNIQUE INDEX credit_grants_single_grant_per_operation_idx
  ON public.credit_grants (operation_id);

ALTER TABLE public.credit_grants
  ADD CONSTRAINT credit_grants_source_reference_required_check
    CHECK (source_reference IS NOT NULL AND btrim(source_reference) <> '');

COMMIT;
