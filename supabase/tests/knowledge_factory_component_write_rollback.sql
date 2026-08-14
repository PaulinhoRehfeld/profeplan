-- =============================================================================
-- Knowledge Factory Lote 3B.4B.2 - guarded rollback rehearsal
-- NON-PRODUCTION / DISPOSABLE ENVIRONMENTS ONLY.
--
-- The rollback refuses to discard idempotency receipts. Component data created
-- by already-committed RPCs is intentionally never deleted by this script.
-- =============================================================================

BEGIN;

DO $guard$
DECLARE
  v_receipt_count bigint;
BEGIN
  IF to_regclass('public.kf_component_write_receipts') IS NOT NULL THEN
    SELECT count(*) INTO v_receipt_count
    FROM public.kf_component_write_receipts;

    IF v_receipt_count <> 0 THEN
      RAISE EXCEPTION
        'Refusing Lote 3B.4B.2 rollback: kf_component_write_receipts contains % row(s)',
        v_receipt_count;
    END IF;
  END IF;
END;
$guard$;

REVOKE ALL ON FUNCTION
  public.kf_create_pedagogical_component_aggregate(uuid, jsonb),
  public.kf_append_pedagogical_component_version(uuid, jsonb),
  public.kf_transition_pedagogical_component_version_status(uuid, jsonb),
  public.kf_promote_pedagogical_component_version(uuid, jsonb)
FROM PUBLIC, anon, authenticated, service_role;

DROP FUNCTION public.kf_create_pedagogical_component_aggregate(uuid, jsonb);
DROP FUNCTION public.kf_append_pedagogical_component_version(uuid, jsonb);
DROP FUNCTION public.kf_transition_pedagogical_component_version_status(uuid, jsonb);
DROP FUNCTION public.kf_promote_pedagogical_component_version(uuid, jsonb);

DROP FUNCTION public.kf_component_transition_allowed_internal(text, text);
DROP FUNCTION public.kf_component_write_fingerprint_internal(text, jsonb);
DROP FUNCTION public.kf_component_write_uuid_array_internal(jsonb, text);
DROP FUNCTION public.kf_component_write_text_array_internal(jsonb, text, text[]);
DROP FUNCTION public.kf_component_write_timestamp_internal(jsonb, text);
DROP FUNCTION public.kf_component_write_uuid_internal(jsonb, text);
DROP FUNCTION public.kf_component_write_text_internal(jsonb, text, boolean);
DROP FUNCTION public.kf_component_write_assert_object_internal(jsonb, text[], text[], text);

DROP TABLE public.kf_component_write_receipts;

GRANT INSERT, UPDATE ON TABLE
  public.kf_pedagogical_components,
  public.kf_component_versions,
  public.kf_component_source_evidence,
  public.kf_component_curriculum_links
TO service_role;

DO $postconditions$
BEGIN
  IF to_regclass('public.kf_pedagogical_components') IS NULL
    OR to_regclass('public.kf_component_versions') IS NULL
    OR to_regclass('public.kf_component_source_evidence') IS NULL
    OR to_regclass('public.kf_component_curriculum_links') IS NULL THEN
    RAISE EXCEPTION 'Lote 3B.4B.2 rollback damaged the Lote 3A aggregate schema';
  END IF;

  IF to_regclass('public.kf_component_write_receipts') IS NOT NULL
    OR to_regprocedure('public.kf_create_pedagogical_component_aggregate(uuid,jsonb)') IS NOT NULL
    OR to_regprocedure('public.kf_append_pedagogical_component_version(uuid,jsonb)') IS NOT NULL
    OR to_regprocedure(
      'public.kf_transition_pedagogical_component_version_status(uuid,jsonb)'
    ) IS NOT NULL
    OR to_regprocedure('public.kf_promote_pedagogical_component_version(uuid,jsonb)') IS NOT NULL THEN
    RAISE EXCEPTION 'Lote 3B.4B.2 rollback left a write object behind';
  END IF;
END;
$postconditions$;

COMMIT;
