-- =============================================================================
-- Knowledge Factory C.1.3 - command boundary schema, privileges and competence
-- NON-PRODUCTION ONLY. Synthetic fixtures are rolled back.
-- =============================================================================

BEGIN;

DO $$
DECLARE
  v_public_rpc_count integer;
  v_secure_rpc_count integer;
  v_service_execute_count integer;
  v_external_execute_count integer;
  v_internal_service_execute_count integer;
BEGIN
  IF to_regclass('public.kf_source_actor_assignments') IS NULL THEN
    RAISE EXCEPTION 'C.1.3 actor assignment table is missing';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = 'public' AND c.relname = 'kf_source_actor_assignments'
      AND c.relrowsecurity
  ) THEN
    RAISE EXCEPTION 'C.1.3 actor assignment table must have RLS enabled';
  END IF;

  SELECT count(*) INTO v_public_rpc_count
  FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
  WHERE n.nspname = 'public'
    AND p.proname = ANY(ARRAY[
      'kf_source_register_identity',
      'kf_source_request_validation',
      'kf_source_confirm_validation',
      'kf_source_block',
      'kf_source_replace',
      'kf_source_archive',
      'kf_source_grant_authorization',
      'kf_source_suspend_authorization',
      'kf_source_resume_authorization',
      'kf_source_revoke_authorization',
      'kf_source_block_purpose',
      'kf_source_supersede_authorization',
      'kf_source_open_impact_assessment'
    ])
    AND pg_get_function_identity_arguments(p.oid) = 'p_command_id uuid, p_fingerprint text, p_payload jsonb';
  IF v_public_rpc_count <> 13 THEN
    RAISE EXCEPTION 'expected 13 narrow C.1.3 RPCs, found %', v_public_rpc_count;
  END IF;

  SELECT count(*) INTO v_secure_rpc_count
  FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
  WHERE n.nspname = 'public'
    AND p.proname = ANY(ARRAY[
      'kf_source_register_identity','kf_source_request_validation',
      'kf_source_confirm_validation','kf_source_block','kf_source_replace',
      'kf_source_archive','kf_source_grant_authorization',
      'kf_source_suspend_authorization','kf_source_resume_authorization',
      'kf_source_revoke_authorization','kf_source_block_purpose',
      'kf_source_supersede_authorization','kf_source_open_impact_assessment'
    ])
    AND p.prosecdef
    AND array_to_string(p.proconfig, ',') LIKE '%search_path=pg_catalog, public%';
  IF v_secure_rpc_count <> 13 THEN
    RAISE EXCEPTION 'all 13 C.1.3 RPCs must be SECURITY DEFINER with fixed search_path';
  END IF;

  SELECT count(*) INTO v_service_execute_count
  FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
  WHERE n.nspname = 'public'
    AND p.proname = ANY(ARRAY[
      'kf_source_register_identity','kf_source_request_validation',
      'kf_source_confirm_validation','kf_source_block','kf_source_replace',
      'kf_source_archive','kf_source_grant_authorization',
      'kf_source_suspend_authorization','kf_source_resume_authorization',
      'kf_source_revoke_authorization','kf_source_block_purpose',
      'kf_source_supersede_authorization','kf_source_open_impact_assessment'
    ])
    AND has_function_privilege('service_role', p.oid, 'EXECUTE');
  IF v_service_execute_count <> 13 THEN
    RAISE EXCEPTION 'service_role must execute exactly the 13 approved C.1.3 RPCs';
  END IF;

  SELECT count(*) INTO v_external_execute_count
  FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
  WHERE n.nspname = 'public'
    AND p.proname = ANY(ARRAY[
      'kf_source_register_identity','kf_source_request_validation',
      'kf_source_confirm_validation','kf_source_block','kf_source_replace',
      'kf_source_archive','kf_source_grant_authorization',
      'kf_source_suspend_authorization','kf_source_resume_authorization',
      'kf_source_revoke_authorization','kf_source_block_purpose',
      'kf_source_supersede_authorization','kf_source_open_impact_assessment'
    ])
    AND (
      has_function_privilege('anon', p.oid, 'EXECUTE')
      OR has_function_privilege('authenticated', p.oid, 'EXECUTE')
    );
  IF v_external_execute_count <> 0 THEN
    RAISE EXCEPTION 'anon/authenticated unexpectedly execute a C.1.3 lifecycle RPC';
  END IF;

  SELECT count(*) INTO v_internal_service_execute_count
  FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
  WHERE n.nspname = 'public'
    AND p.proname LIKE 'kf_source%internal'
    AND has_function_privilege('service_role', p.oid, 'EXECUTE');
  IF v_internal_service_execute_count <> 0 THEN
    RAISE EXCEPTION 'service_role unexpectedly executes C.1.3 internal helpers';
  END IF;

  IF has_table_privilege('service_role', 'public.kf_source_actor_assignments', 'SELECT')
    OR has_table_privilege('service_role', 'public.kf_source_actor_assignments', 'INSERT')
    OR has_table_privilege('service_role', 'public.kf_source_actor_assignments', 'UPDATE')
    OR has_table_privilege('service_role', 'public.kf_source_actor_assignments', 'DELETE') THEN
    RAISE EXCEPTION 'service_role unexpectedly has direct actor-assignment table privileges';
  END IF;

  IF EXISTS (
    SELECT 1 FROM unnest(ARRAY[
      'kf_source_identities','kf_source_authorization_bases',
      'kf_source_registration_projections','kf_source_authorizations',
      'kf_source_command_receipts','kf_source_governance_events',
      'kf_source_command_receipt_events'
    ]) AS table_name(name)
    WHERE has_table_privilege('service_role', 'public.' || table_name.name, 'INSERT')
       OR has_table_privilege('service_role', 'public.' || table_name.name, 'UPDATE')
       OR has_table_privilege('service_role', 'public.' || table_name.name, 'DELETE')
  ) THEN
    RAISE EXCEPTION 'service_role unexpectedly retains direct lifecycle DML';
  END IF;
END;
$$;

INSERT INTO public.kf_source_actor_assignments(
  id, actor_id, actor_role, effective_from, effective_until
) VALUES
  ('75100000-0000-4000-8000-000000000001','75110000-0000-4000-8000-000000000001','curator','2026-08-14T00:00:00Z',NULL),
  ('75100000-0000-4000-8000-000000000002','75110000-0000-4000-8000-000000000002','legal_editorial_reviewer','2026-08-14T00:00:00Z',NULL),
  ('75100000-0000-4000-8000-000000000003','75110000-0000-4000-8000-000000000003','system_worker','2026-08-14T00:00:00Z',NULL),
  ('75100000-0000-4000-8000-000000000004','75110000-0000-4000-8000-000000000004','technical_admin','2026-08-14T00:00:00Z',NULL);

-- anon cannot reach the lifecycle RPC surface.
SET LOCAL ROLE anon;
DO $$
DECLARE
  v_payload jsonb := '{
    "commandType":"register_identity",
    "actor":{"actorId":"75110000-0000-4000-8000-000000000001","role":"curator"},
    "subject":{"id":"75120000-0000-4000-8000-000000000001","kind":"work"},
    "occurredAt":"2026-08-14T10:00:00Z",
    "effectiveAt":"2026-08-14T10:00:00Z",
    "correlationId":"75130000-0000-4000-8000-000000000001",
    "reason":"anonymous must not execute"
  }'::jsonb;
  v_fp text;
BEGIN
  v_fp := encode(sha256(convert_to(jsonb_build_object('fingerprintVersion',1,'operation','register_identity','payload',v_payload)::text,'UTF8')),'hex');
  BEGIN
    PERFORM * FROM public.kf_source_register_identity('75140000-0000-4000-8000-000000000001', v_fp, v_payload);
    RAISE EXCEPTION 'anon unexpectedly executed C.1.3 RPC';
  EXCEPTION WHEN insufficient_privilege THEN NULL;
  END;
END;
$$;
RESET ROLE;

-- authenticated/common admin roles cannot reach the lifecycle RPC surface.
SET LOCAL ROLE authenticated;
DO $$
DECLARE
  v_payload jsonb := '{
    "commandType":"register_identity",
    "actor":{"actorId":"75110000-0000-4000-8000-000000000001","role":"curator"},
    "subject":{"id":"75120000-0000-4000-8000-000000000002","kind":"work"},
    "occurredAt":"2026-08-14T10:01:00Z",
    "effectiveAt":"2026-08-14T10:01:00Z",
    "correlationId":"75130000-0000-4000-8000-000000000002",
    "reason":"authenticated must not execute"
  }'::jsonb;
  v_fp text;
BEGIN
  v_fp := encode(sha256(convert_to(jsonb_build_object('fingerprintVersion',1,'operation','register_identity','payload',v_payload)::text,'UTF8')),'hex');
  BEGIN
    PERFORM * FROM public.kf_source_register_identity('75140000-0000-4000-8000-000000000002', v_fp, v_payload);
    RAISE EXCEPTION 'authenticated unexpectedly executed C.1.3 RPC';
  EXCEPTION WHEN insufficient_privilege THEN NULL;
  END;
END;
$$;
RESET ROLE;

-- service_role is only a technical channel; valid curator assignment is still required.
SET LOCAL ROLE service_role;
DO $$
DECLARE
  v_payload jsonb := '{
    "commandType":"register_identity",
    "actor":{"actorId":"75110000-0000-4000-8000-000000000001","role":"curator"},
    "subject":{"id":"75120000-0000-4000-8000-000000000010","kind":"work"},
    "occurredAt":"2026-08-14T10:10:00Z",
    "effectiveAt":"2026-08-14T10:10:00Z",
    "correlationId":"75130000-0000-4000-8000-000000000010",
    "reason":"valid server-side curator command"
  }'::jsonb;
  v_fp text;
  v_state text;
BEGIN
  v_fp := encode(sha256(convert_to(jsonb_build_object('fingerprintVersion',1,'operation','register_identity','payload',v_payload)::text,'UTF8')),'hex');
  SELECT state INTO v_state FROM public.kf_source_register_identity('75140000-0000-4000-8000-000000000010', v_fp, v_payload);
  IF v_state <> 'REGISTERED' THEN
    RAISE EXCEPTION 'valid service_role/curator command did not register identity';
  END IF;

  BEGIN
    INSERT INTO public.kf_source_identities(kind) VALUES ('work');
    RAISE EXCEPTION 'service_role unexpectedly wrote lifecycle table directly';
  EXCEPTION WHEN insufficient_privilege THEN NULL;
  END;
END;
$$;
RESET ROLE;

-- Unassigned actor is forbidden even through service_role.
SET LOCAL ROLE service_role;
DO $$
DECLARE
  v_payload jsonb := '{
    "commandType":"register_identity",
    "actor":{"actorId":"75110000-0000-4000-8000-000000009999","role":"curator"},
    "subject":{"id":"75120000-0000-4000-8000-000000000020","kind":"work"},
    "occurredAt":"2026-08-14T10:20:00Z",
    "effectiveAt":"2026-08-14T10:20:00Z",
    "correlationId":"75130000-0000-4000-8000-000000000020",
    "reason":"missing assignment"
  }'::jsonb;
  v_fp text;
BEGIN
  v_fp := encode(sha256(convert_to(jsonb_build_object('fingerprintVersion',1,'operation','register_identity','payload',v_payload)::text,'UTF8')),'hex');
  BEGIN
    PERFORM * FROM public.kf_source_register_identity('75140000-0000-4000-8000-000000000020', v_fp, v_payload);
    RAISE EXCEPTION 'unassigned actor unexpectedly executed command';
  EXCEPTION WHEN SQLSTATE 'PT403' THEN NULL;
  END;
END;
$$;
RESET ROLE;

-- Reviewer cannot become curator by declaring a different command channel.
SET LOCAL ROLE service_role;
DO $$
DECLARE
  v_payload jsonb := '{
    "commandType":"register_identity",
    "actor":{"actorId":"75110000-0000-4000-8000-000000000002","role":"legal_editorial_reviewer"},
    "subject":{"id":"75120000-0000-4000-8000-000000000021","kind":"work"},
    "occurredAt":"2026-08-14T10:21:00Z",
    "effectiveAt":"2026-08-14T10:21:00Z",
    "correlationId":"75130000-0000-4000-8000-000000000021",
    "reason":"reviewer cannot register"
  }'::jsonb;
  v_fp text;
BEGIN
  v_fp := encode(sha256(convert_to(jsonb_build_object('fingerprintVersion',1,'operation','register_identity','payload',v_payload)::text,'UTF8')),'hex');
  BEGIN
    PERFORM * FROM public.kf_source_register_identity('75140000-0000-4000-8000-000000000021', v_fp, v_payload);
    RAISE EXCEPTION 'reviewer unexpectedly acted as curator';
  EXCEPTION WHEN SQLSTATE 'PT403' THEN NULL;
  END;
END;
$$;
RESET ROLE;

-- Curator cannot grant authorization even if the channel is service_role.
SET LOCAL ROLE service_role;
DO $$
DECLARE
  v_payload jsonb := '{
    "commandType":"grant_authorization",
    "actor":{"actorId":"75110000-0000-4000-8000-000000000001","role":"curator"},
    "authorizationId":"75150000-0000-4000-8000-000000000001",
    "scope":{"subject":{"id":"75120000-0000-4000-8000-000000000010","kind":"work"},"purpose":"retrieval"},
    "basis":{"id":"75160000-0000-4000-8000-000000000001","kind":"wrtech_ownership"},
    "effectiveFrom":"2026-08-14T10:22:00Z",
    "occurredAt":"2026-08-14T10:22:00Z",
    "effectiveAt":"2026-08-14T10:22:00Z",
    "correlationId":"75130000-0000-4000-8000-000000000022",
    "reason":"curator cannot grant rights"
  }'::jsonb;
  v_fp text;
BEGIN
  v_fp := encode(sha256(convert_to(jsonb_build_object('fingerprintVersion',1,'operation','grant_authorization','payload',v_payload)::text,'UTF8')),'hex');
  BEGIN
    PERFORM * FROM public.kf_source_grant_authorization('75140000-0000-4000-8000-000000000022', v_fp, v_payload);
    RAISE EXCEPTION 'curator unexpectedly granted authorization';
  EXCEPTION WHEN SQLSTATE 'PT403' THEN NULL;
  END;
END;
$$;
RESET ROLE;

-- system_worker and technical_admin cannot originate impact decisions.
SET LOCAL ROLE service_role;
DO $$
DECLARE
  v_payload jsonb;
  v_fp text;
BEGIN
  v_payload := '{
    "commandType":"open_impact_assessment",
    "actor":{"actorId":"75110000-0000-4000-8000-000000000003","role":"system_worker"},
    "subject":{"id":"75120000-0000-4000-8000-000000000010","kind":"work"},
    "occurredAt":"2026-08-14T10:23:00Z",
    "effectiveAt":"2026-08-14T10:23:00Z",
    "correlationId":"75130000-0000-4000-8000-000000000023",
    "reason":"worker is not a decider"
  }'::jsonb;
  v_fp := encode(sha256(convert_to(jsonb_build_object('fingerprintVersion',1,'operation','open_impact_assessment','payload',v_payload)::text,'UTF8')),'hex');
  BEGIN
    PERFORM * FROM public.kf_source_open_impact_assessment('75140000-0000-4000-8000-000000000023', v_fp, v_payload);
    RAISE EXCEPTION 'system_worker unexpectedly opened impact decision';
  EXCEPTION WHEN SQLSTATE 'PT403' THEN NULL;
  END;

  v_payload := jsonb_set(v_payload, '{actor}', '{"actorId":"75110000-0000-4000-8000-000000000004","role":"technical_admin"}'::jsonb);
  v_fp := encode(sha256(convert_to(jsonb_build_object('fingerprintVersion',1,'operation','open_impact_assessment','payload',v_payload)::text,'UTF8')),'hex');
  BEGIN
    PERFORM * FROM public.kf_source_open_impact_assessment('75140000-0000-4000-8000-000000000024', v_fp, v_payload);
    RAISE EXCEPTION 'technical_admin unexpectedly opened impact decision';
  EXCEPTION WHEN SQLSTATE 'PT403' THEN NULL;
  END;
END;
$$;
RESET ROLE;

ROLLBACK;
