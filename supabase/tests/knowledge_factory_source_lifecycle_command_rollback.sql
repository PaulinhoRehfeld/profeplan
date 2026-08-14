-- =============================================================================
-- Knowledge Factory C.1.3 - guarded structural rollback rehearsal
-- DISPOSABLE / NON-PRODUCTION ENVIRONMENTS ONLY.
-- =============================================================================

BEGIN;

DO $$
DECLARE
  v_assignment_count bigint;
BEGIN
  IF to_regclass('public.kf_source_actor_assignments') IS NOT NULL THEN
    SELECT count(*) INTO v_assignment_count FROM public.kf_source_actor_assignments;
    IF v_assignment_count <> 0 THEN
      RAISE EXCEPTION
        'Refusing destructive C.1.3 rollback: kf_source_actor_assignments contains % row(s)',
        v_assignment_count;
    END IF;
  END IF;
END;
$$;

-- Public SECURITY DEFINER surface first.
DROP FUNCTION IF EXISTS public.kf_source_open_impact_assessment(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_supersede_authorization(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_block_purpose(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_revoke_authorization(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_resume_authorization(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_suspend_authorization(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_grant_authorization(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_archive(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_replace(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_block(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_confirm_validation(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_request_validation(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_register_identity(uuid,text,jsonb);

-- Higher-level internals before their shared dependencies.
DROP FUNCTION IF EXISTS public.kf_source_open_impact_assessment_internal(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_supersede_authorization_internal(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_authorization_transition_internal(text,text,text,text[],boolean,uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_grant_authorization_internal(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_command_resolve_basis_internal(jsonb,boolean);
DROP FUNCTION IF EXISTS public.kf_source_registration_transition_internal(text,text,text,text[],boolean,uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_register_identity_internal(uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_command_append_impact_internal(uuid,integer,uuid,uuid,uuid,text,text,timestamptz,timestamptz,uuid);
DROP FUNCTION IF EXISTS public.kf_source_command_assert_subject_internal(jsonb);
DROP FUNCTION IF EXISTS public.kf_source_command_receipt_result_internal(uuid,boolean);
DROP FUNCTION IF EXISTS public.kf_source_command_precheck_internal(text,uuid,text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_command_assert_assignment_internal(uuid,text,timestamptz);
DROP FUNCTION IF EXISTS public.kf_source_command_actor_allowed_internal(text,text);
DROP FUNCTION IF EXISTS public.kf_source_command_fingerprint_internal(text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_command_validate_payload_internal(text,jsonb);
DROP FUNCTION IF EXISTS public.kf_source_command_validate_subject_internal(jsonb,text);
DROP FUNCTION IF EXISTS public.kf_source_command_assert_c13_kind_internal(text);
DROP FUNCTION IF EXISTS public.kf_source_command_text_array_internal(jsonb,text);
DROP FUNCTION IF EXISTS public.kf_source_command_positive_bigint_internal(jsonb,text);
DROP FUNCTION IF EXISTS public.kf_source_command_timestamp_internal(jsonb,text);
DROP FUNCTION IF EXISTS public.kf_source_command_uuid_internal(jsonb,text);
DROP FUNCTION IF EXISTS public.kf_source_command_text_internal(jsonb,text);
DROP FUNCTION IF EXISTS public.kf_source_command_assert_object_internal(jsonb,text[],text[],text);

DROP TABLE IF EXISTS public.kf_source_actor_assignments;

DO $$
DECLARE
  v_rpc_count integer;
  v_internal_count integer;
BEGIN
  IF to_regclass('public.kf_source_actor_assignments') IS NOT NULL THEN
    RAISE EXCEPTION 'C.1.3 rollback left actor assignment table behind';
  END IF;

  SELECT count(*) INTO v_rpc_count
  FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace
  WHERE n.nspname='public'
    AND p.proname = ANY(ARRAY[
      'kf_source_register_identity','kf_source_request_validation',
      'kf_source_confirm_validation','kf_source_block','kf_source_replace',
      'kf_source_archive','kf_source_grant_authorization',
      'kf_source_suspend_authorization','kf_source_resume_authorization',
      'kf_source_revoke_authorization','kf_source_block_purpose',
      'kf_source_supersede_authorization','kf_source_open_impact_assessment'
    ]);
  IF v_rpc_count <> 0 THEN
    RAISE EXCEPTION 'C.1.3 rollback left one or more public lifecycle RPCs behind';
  END IF;

  SELECT count(*) INTO v_internal_count
  FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace
  WHERE n.nspname='public' AND p.proname LIKE 'kf_source%internal';
  IF v_internal_count <> 0 THEN
    RAISE EXCEPTION 'C.1.3 rollback left internal lifecycle command helpers behind';
  END IF;

  -- C.1.2 must remain completely intact.
  IF to_regclass('public.kf_source_identities') IS NULL
    OR to_regclass('public.kf_source_authorization_bases') IS NULL
    OR to_regclass('public.kf_source_registration_projections') IS NULL
    OR to_regclass('public.kf_source_authorizations') IS NULL
    OR to_regclass('public.kf_source_command_receipts') IS NULL
    OR to_regclass('public.kf_source_governance_events') IS NULL
    OR to_regclass('public.kf_source_command_receipt_events') IS NULL THEN
    RAISE EXCEPTION 'C.1.3 rollback altered the C.1.2 persistence foundation';
  END IF;

  IF to_regprocedure('public.kf_prevent_source_authorization_scope_mutation()') IS NULL
    OR to_regprocedure('public.kf_prevent_append_only_mutation()') IS NULL THEN
    RAISE EXCEPTION 'C.1.3 rollback removed a C.1.2/shared integrity helper';
  END IF;
END;
$$;

COMMIT;
