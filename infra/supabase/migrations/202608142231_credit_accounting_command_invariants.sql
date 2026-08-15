-- Lote 1.3B.2 hardening: one economic GRANT operation funds exactly one lot.
BEGIN;

CREATE UNIQUE INDEX credit_grants_single_grant_per_operation_idx
  ON public.credit_grants (operation_id);

COMMIT;
