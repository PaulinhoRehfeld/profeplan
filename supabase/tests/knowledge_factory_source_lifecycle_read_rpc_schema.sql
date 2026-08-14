-- =============================================================================
-- Knowledge Factory C.1.4 - read RPC schema and least-privilege tests
-- NON-PRODUCTION ONLY.
-- =============================================================================

DO $$
DECLARE
  v_function oid;
  v_name text;
  v_service_execute_count integer := 0;
BEGIN
  FOREACH v_name IN ARRAY ARRAY[
    'kf_source_list_registration_history(uuid,timestamptz)',
    'kf_source_list_authorization_history(uuid,text,timestamptz)',
    'kf_source_list_impact_history(uuid,timestamptz)'
  ]
  LOOP
    v_function := to_regprocedure('public.' || v_name);
    IF v_function IS NULL THEN
      RAISE EXCEPTION 'C.1.4 read RPC is missing: %', v_name;
    END IF;

    IF NOT EXISTS (
      SELECT 1
      FROM pg_proc AS procedures
      WHERE procedures.oid = v_function
        AND procedures.prosecdef
        AND procedures.provolatile = 's'
        AND array_to_string(procedures.proconfig, ',') LIKE '%search_path=pg_catalog, public%'
    ) THEN
      RAISE EXCEPTION 'C.1.4 read RPC must be STABLE SECURITY DEFINER with fixed search_path: %', v_name;
    END IF;

    IF NOT has_function_privilege('service_role', v_function, 'EXECUTE') THEN
      RAISE EXCEPTION 'service_role must execute C.1.4 read RPC: %', v_name;
    END IF;
    v_service_execute_count := v_service_execute_count + 1;

    IF has_function_privilege('anon', v_function, 'EXECUTE')
      OR has_function_privilege('authenticated', v_function, 'EXECUTE') THEN
      RAISE EXCEPTION 'browser-facing roles unexpectedly execute C.1.4 read RPC: %', v_name;
    END IF;
  END LOOP;

  IF v_service_execute_count <> 3 THEN
    RAISE EXCEPTION 'expected exactly three approved C.1.4 read RPC grants';
  END IF;

  IF to_regprocedure('public.kf_source_register_identity(uuid,text,jsonb)') IS NULL
    OR to_regclass('public.kf_source_actor_assignments') IS NULL
    OR to_regclass('public.kf_source_governance_events') IS NULL THEN
    RAISE EXCEPTION 'C.1.3/C.1.2 foundation is missing under C.1.4';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM unnest(ARRAY[
      'kf_source_identities',
      'kf_source_authorization_bases',
      'kf_source_registration_projections',
      'kf_source_authorizations',
      'kf_source_command_receipts',
      'kf_source_governance_events',
      'kf_source_command_receipt_events',
      'kf_source_actor_assignments'
    ]) AS table_name(name)
    WHERE has_table_privilege('service_role', 'public.' || table_name.name, 'SELECT')
       OR has_table_privilege('service_role', 'public.' || table_name.name, 'INSERT')
       OR has_table_privilege('service_role', 'public.' || table_name.name, 'UPDATE')
       OR has_table_privilege('service_role', 'public.' || table_name.name, 'DELETE')
  ) THEN
    RAISE EXCEPTION 'C.1.4 must not reopen direct lifecycle table privileges for service_role';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_proc AS procedures
    JOIN pg_namespace AS namespaces ON namespaces.oid = procedures.pronamespace
    WHERE namespaces.nspname = 'public'
      AND (
        procedures.proname LIKE 'kf_source%ingest%'
        OR procedures.proname LIKE 'kf_source%processing_run%'
        OR procedures.proname LIKE 'kf_source%derived_artifact%'
      )
  ) THEN
    RAISE EXCEPTION 'C.1.4 unexpectedly introduced C.2/derived-processing RPC surface';
  END IF;
END;
$$;

-- Direct invocation is denied to anon/authenticated and allowed to service_role.
SET ROLE anon;
DO $$
BEGIN
  BEGIN
    PERFORM * FROM public.kf_source_list_registration_history(
      '89000000-0000-4000-8000-000000000001',
      NULL
    );
    RAISE EXCEPTION 'anon unexpectedly executed C.1.4 read RPC';
  EXCEPTION WHEN insufficient_privilege THEN NULL;
  END;
END;
$$;
RESET ROLE;

SET ROLE authenticated;
DO $$
BEGIN
  BEGIN
    PERFORM * FROM public.kf_source_list_impact_history(
      '89000000-0000-4000-8000-000000000001',
      NULL
    );
    RAISE EXCEPTION 'authenticated unexpectedly executed C.1.4 read RPC';
  EXCEPTION WHEN insufficient_privilege THEN NULL;
  END;
END;
$$;
RESET ROLE;

SET ROLE service_role;
DO $$
BEGIN
  PERFORM * FROM public.kf_source_list_registration_history(
    '89000000-0000-4000-8000-000000000001',
    NULL
  );
  PERFORM * FROM public.kf_source_list_authorization_history(
    '89000000-0000-4000-8000-000000000001',
    NULL,
    NULL
  );
  PERFORM * FROM public.kf_source_list_impact_history(
    '89000000-0000-4000-8000-000000000001',
    NULL
  );
END;
$$;
RESET ROLE;
