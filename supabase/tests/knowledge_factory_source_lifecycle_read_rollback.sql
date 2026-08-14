-- =============================================================================
-- Knowledge Factory C.1.4 - guarded read-RPC rollback rehearsal
-- NON-PRODUCTION ONLY.
-- =============================================================================

BEGIN;

DO $$
BEGIN
  IF to_regprocedure('public.kf_source_list_registration_history(uuid,timestamptz)') IS NULL
    OR to_regprocedure('public.kf_source_list_authorization_history(uuid,text,timestamptz)') IS NULL
    OR to_regprocedure('public.kf_source_list_impact_history(uuid,timestamptz)') IS NULL THEN
    RAISE EXCEPTION 'C.1.4 rollback precondition failed: one or more read RPCs are missing';
  END IF;

  IF to_regprocedure('public.kf_source_register_identity(uuid,text,jsonb)') IS NULL
    OR to_regclass('public.kf_source_governance_events') IS NULL THEN
    RAISE EXCEPTION 'C.1.4 rollback precondition failed: C.1.3/C.1.2 foundation is missing';
  END IF;
END;
$$;

DROP FUNCTION public.kf_source_list_registration_history(uuid,timestamptz);
DROP FUNCTION public.kf_source_list_authorization_history(uuid,text,timestamptz);
DROP FUNCTION public.kf_source_list_impact_history(uuid,timestamptz);

DO $$
BEGIN
  IF to_regprocedure('public.kf_source_list_registration_history(uuid,timestamptz)') IS NOT NULL
    OR to_regprocedure('public.kf_source_list_authorization_history(uuid,text,timestamptz)') IS NOT NULL
    OR to_regprocedure('public.kf_source_list_impact_history(uuid,timestamptz)') IS NOT NULL THEN
    RAISE EXCEPTION 'C.1.4 read RPC remains after guarded rollback';
  END IF;

  IF to_regprocedure('public.kf_source_register_identity(uuid,text,jsonb)') IS NULL
    OR to_regprocedure('public.kf_source_grant_authorization(uuid,text,jsonb)') IS NULL
    OR to_regclass('public.kf_source_actor_assignments') IS NULL
    OR to_regclass('public.kf_source_governance_events') IS NULL THEN
    RAISE EXCEPTION 'guarded C.1.4 rollback damaged C.1.3/C.1.2 foundation';
  END IF;
END;
$$;

COMMIT;
