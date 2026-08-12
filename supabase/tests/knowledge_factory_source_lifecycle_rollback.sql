-- =============================================================================
-- Knowledge Factory C.1.2 - guarded destructive rollback rehearsal
-- DISPOSABLE / NON-PRODUCTION ENVIRONMENTS ONLY.
-- =============================================================================

BEGIN;

DO $$
DECLARE
  v_table_name text;
  v_row_count bigint;
  v_tables text[] := ARRAY[
    'kf_source_command_receipt_events',
    'kf_source_governance_events',
    'kf_source_command_receipts',
    'kf_source_authorizations',
    'kf_source_registration_projections',
    'kf_source_authorization_bases',
    'kf_source_identities'
  ];
BEGIN
  FOREACH v_table_name IN ARRAY v_tables LOOP
    IF to_regclass('public.' || v_table_name) IS NOT NULL THEN
      EXECUTE format('SELECT count(*) FROM public.%I', v_table_name) INTO v_row_count;
      IF v_row_count <> 0 THEN
        RAISE EXCEPTION
          'Refusing destructive C.1.2 rollback: public.% contains % row(s)',
          v_table_name,
          v_row_count;
      END IF;
    END IF;
  END LOOP;
END;
$$;

DROP POLICY IF EXISTS kf_source_command_receipt_events_admin_select
  ON public.kf_source_command_receipt_events;
DROP POLICY IF EXISTS kf_source_governance_events_admin_select
  ON public.kf_source_governance_events;
DROP POLICY IF EXISTS kf_source_command_receipts_admin_select
  ON public.kf_source_command_receipts;
DROP POLICY IF EXISTS kf_source_authorizations_admin_select
  ON public.kf_source_authorizations;
DROP POLICY IF EXISTS kf_source_registration_projections_admin_select
  ON public.kf_source_registration_projections;
DROP POLICY IF EXISTS kf_source_authorization_bases_admin_select
  ON public.kf_source_authorization_bases;
DROP POLICY IF EXISTS kf_source_identities_admin_select
  ON public.kf_source_identities;

DROP TRIGGER IF EXISTS kf_source_command_receipt_events_append_only
  ON public.kf_source_command_receipt_events;
DROP TRIGGER IF EXISTS kf_source_governance_events_append_only
  ON public.kf_source_governance_events;
DROP TRIGGER IF EXISTS kf_source_command_receipts_append_only
  ON public.kf_source_command_receipts;
DROP TRIGGER IF EXISTS kf_source_authorization_bases_append_only
  ON public.kf_source_authorization_bases;
DROP TRIGGER IF EXISTS kf_source_identities_append_only
  ON public.kf_source_identities;

DROP TABLE IF EXISTS public.kf_source_command_receipt_events;
DROP TABLE IF EXISTS public.kf_source_governance_events;
DROP TABLE IF EXISTS public.kf_source_command_receipts;
DROP TABLE IF EXISTS public.kf_source_authorizations;
DROP TABLE IF EXISTS public.kf_source_registration_projections;
DROP TABLE IF EXISTS public.kf_source_authorization_bases;
DROP TABLE IF EXISTS public.kf_source_identities;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = 'public'
      AND c.relname = ANY(ARRAY[
        'kf_source_command_receipt_events',
        'kf_source_governance_events',
        'kf_source_command_receipts',
        'kf_source_authorizations',
        'kf_source_registration_projections',
        'kf_source_authorization_bases',
        'kf_source_identities'
      ])
      AND c.relkind IN ('r', 'p', 'v', 'm', 'S', 'f')
  ) THEN
    RAISE EXCEPTION 'C.1.2 rollback incomplete: lifecycle relation remains';
  END IF;

  IF to_regclass('public.kf_sources') IS NULL
    OR to_regclass('public.kf_source_versions') IS NULL
    OR to_regclass('public.kf_source_permission_events') IS NULL THEN
    RAISE EXCEPTION 'C.1.2 rollback altered the legacy source foundation';
  END IF;

  IF to_regprocedure('public.kf_prevent_append_only_mutation()') IS NULL THEN
    RAISE EXCEPTION 'C.1.2 rollback removed a shared append-only helper';
  END IF;
END;
$$;

COMMIT;
