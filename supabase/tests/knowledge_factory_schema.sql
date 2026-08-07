-- =============================================================================
-- ProfePlan Knowledge Factory — Lote 3A validation suite
-- NON-PRODUCTION ONLY.
-- Assumes supabase/migrations/20260807_knowledge_factory_schema.sql is applied.
-- All data is synthetic; the complete suite runs inside a transaction and rolls back.
-- =============================================================================

BEGIN;

-- Initialize pg_temp and create tiny assertion helpers without external extensions.
CREATE TEMP TABLE kf_test_bootstrap (id integer);

CREATE OR REPLACE FUNCTION pg_temp.assert_true(p_condition boolean, p_message text)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  IF p_condition IS NOT TRUE THEN
    RAISE EXCEPTION 'ASSERTION FAILED: %', p_message;
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION pg_temp.expect_error(
  p_sql text,
  p_allowed_states text[],
  p_message text
)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_state text;
BEGIN
  BEGIN
    EXECUTE p_sql;
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_state = RETURNED_SQLSTATE;
    IF p_allowed_states IS NULL OR v_state = ANY(p_allowed_states) THEN
      RETURN;
    END IF;

    RAISE EXCEPTION
      'ASSERTION FAILED: %; unexpected SQLSTATE %, error: %',
      p_message,
      v_state,
      SQLERRM;
  END;

  RAISE EXCEPTION 'ASSERTION FAILED: %; statement unexpectedly succeeded', p_message;
END;
$$;

-- -----------------------------------------------------------------------------
-- 1. Schema inventory and forbidden features
-- -----------------------------------------------------------------------------
SELECT pg_temp.assert_true(
  (
    SELECT count(*) = 15
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_name LIKE 'kf\_%' ESCAPE '\'
  ),
  'exactly 15 public.kf_* tables must exist'
);

SELECT pg_temp.assert_true(
  NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name LIKE 'kf\_%' ESCAPE '\'
      AND udt_name = 'vector'
  ),
  'no Knowledge Factory vector column may exist in Lote 3A'
);

SELECT pg_temp.assert_true(
  NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE schemaname = 'public'
      AND tablename LIKE 'kf\_%' ESCAPE '\'
      AND indexdef ~* '(ivfflat|hnsw|vector_)'
  ),
  'no Knowledge Factory vector index may exist in Lote 3A'
);

SELECT pg_temp.assert_true(
  NOT EXISTS (
    SELECT 1
    FROM pg_trigger t
    JOIN pg_class c ON c.oid = t.tgrelid
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE NOT t.tgisinternal
      AND t.tgname LIKE 'kf\_%' ESCAPE '\'
      AND NOT (n.nspname = 'public' AND c.relname LIKE 'kf\_%' ESCAPE '\')
  ),
  'no kf_* trigger may be installed on a legacy table'
);

SELECT pg_temp.assert_true(
  NOT EXISTS (
    SELECT 1
    FROM pg_constraint c
    JOIN pg_class child ON child.oid = c.conrelid
    JOIN pg_class parent ON parent.oid = c.confrelid
    JOIN pg_namespace n ON n.oid = child.relnamespace
    WHERE n.nspname = 'public'
      AND child.relname LIKE 'kf\_%' ESCAPE '\'
      AND parent.relname = 'curriculum_rag'
  ),
  'Knowledge Factory must not depend on curriculum_rag'
);

-- -----------------------------------------------------------------------------
-- 2. Synthetic auth identities and profiles
-- -----------------------------------------------------------------------------
INSERT INTO auth.users (
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_user_meta_data,
  created_at,
  updated_at
)
VALUES
  (
    '10000000-0000-4000-8000-000000000001',
    'authenticated',
    'authenticated',
    'kf-user-a@example.invalid',
    '',
    now(),
    '{"full_name":"KF Synthetic User A"}'::jsonb,
    now(),
    now()
  ),
  (
    '10000000-0000-4000-8000-000000000002',
    'authenticated',
    'authenticated',
    'kf-user-b@example.invalid',
    '',
    now(),
    '{"full_name":"KF Synthetic User B"}'::jsonb,
    now(),
    now()
  ),
  (
    '10000000-0000-4000-8000-000000000003',
    'authenticated',
    'authenticated',
    'kf-admin@example.invalid',
    '',
    now(),
    '{"full_name":"KF Synthetic Platform Admin"}'::jsonb,
    now(),
    now()
  ),
  (
    '10000000-0000-4000-8000-000000000004',
    'authenticated',
    'authenticated',
    'kf-school-admin@example.invalid',
    '',
    now(),
    '{"full_name":"KF Synthetic School Admin"}'::jsonb,
    now(),
    now()
  )
ON CONFLICT (id) DO NOTHING;

-- Existing auth triggers may already have created profiles. Upsert only fields that
-- are used by current platform authorization and are present in the production schema.
INSERT INTO public.profiles (
  id,
  email,
  full_name,
  role,
  is_admin,
  tier,
  is_unlimited,
  credits
)
VALUES
  (
    '10000000-0000-4000-8000-000000000001',
    'kf-user-a@example.invalid',
    'KF Synthetic User A',
    'teacher',
    false,
    'FREE',
    false,
    0
  ),
  (
    '10000000-0000-4000-8000-000000000002',
    'kf-user-b@example.invalid',
    'KF Synthetic User B',
    'teacher',
    false,
    'FREE',
    false,
    0
  ),
  (
    '10000000-0000-4000-8000-000000000003',
    'kf-admin@example.invalid',
    'KF Synthetic Platform Admin',
    'admin',
    true,
    'FREE',
    false,
    0
  ),
  (
    '10000000-0000-4000-8000-000000000004',
    'kf-school-admin@example.invalid',
    'KF Synthetic School Admin',
    'school_admin',
    false,
    'FREE',
    false,
    0
  )
ON CONFLICT (id) DO UPDATE
SET
  email = EXCLUDED.email,
  full_name = EXCLUDED.full_name,
  role = EXCLUDED.role,
  is_admin = EXCLUDED.is_admin;

-- -----------------------------------------------------------------------------
-- 3. Synthetic provenance chain
-- -----------------------------------------------------------------------------
INSERT INTO public.kf_sources (
  id,
  version,
  title,
  source_type,
  status,
  license_category,
  allowed_uses,
  provenance_uri,
  created_at,
  updated_at
)
VALUES
  (
    '20000000-0000-4000-8000-000000000001',
    '1.0.0',
    'WRTECH-SYNTHETIC-SOURCE-001',
    'wrtech_owned',
    'approved',
    'owned',
    ARRAY['retrieval', 'generation']::text[],
    'urn:wrtech:synthetic:source:001',
    now(),
    now()
  ),
  (
    '20000000-0000-4000-8000-000000000002',
    '1.0.0',
    'WRTECH-SYNTHETIC-SOURCE-002',
    'wrtech_owned',
    'approved',
    'owned',
    ARRAY['retrieval']::text[],
    'urn:wrtech:synthetic:source:002',
    now(),
    now()
  );

INSERT INTO public.kf_source_versions (
  id,
  version,
  source_id,
  checksum,
  effective_at
)
VALUES
  (
    '20100000-0000-4000-8000-000000000001',
    '1.0.0',
    '20000000-0000-4000-8000-000000000001',
    'synthetic-checksum-001',
    now()
  ),
  (
    '20100000-0000-4000-8000-000000000002',
    '1.0.0',
    '20000000-0000-4000-8000-000000000002',
    'synthetic-checksum-002',
    now()
  );

INSERT INTO public.kf_source_segments (
  id,
  version,
  source_version_id,
  parent_segment_id,
  locator,
  content_digest,
  extracted_text,
  created_at
)
VALUES
  (
    '20200000-0000-4000-8000-000000000001',
    '1.0.0',
    '20100000-0000-4000-8000-000000000001',
    NULL,
    'synthetic:segment:001',
    'synthetic-digest-001',
    'Synthetic educational segment. No protected content.',
    now()
  ),
  (
    '20200000-0000-4000-8000-000000000002',
    '1.0.0',
    '20100000-0000-4000-8000-000000000002',
    NULL,
    'synthetic:segment:002',
    'synthetic-digest-002',
    'Second synthetic educational segment.',
    now()
  );

INSERT INTO public.kf_source_permission_events (
  id,
  version,
  source_id,
  action,
  use_type,
  reason,
  occurred_at
)
VALUES (
  '20300000-0000-4000-8000-000000000001',
  '1.0.0',
  '20000000-0000-4000-8000-000000000001',
  'grant',
  'generation',
  'Synthetic permission event for Lote 3A validation.',
  now()
);

-- -----------------------------------------------------------------------------
-- 4. Synthetic curriculum
-- -----------------------------------------------------------------------------
INSERT INTO public.kf_curriculum_packages (
  id,
  version,
  state,
  stage,
  status,
  title,
  effective_from
)
VALUES (
  '40000000-0000-4000-8000-000000000001',
  '1.0.0',
  'MG',
  'ensino_medio',
  'active',
  'Synthetic MG High School Package',
  now()
);

INSERT INTO public.kf_curriculum_package_sources (
  curriculum_package_id,
  source_version_id
)
VALUES (
  '40000000-0000-4000-8000-000000000001',
  '20100000-0000-4000-8000-000000000001'
);

INSERT INTO public.kf_curriculum_nodes (
  id,
  version,
  curriculum_package_id,
  node_type,
  code,
  title,
  description,
  component,
  grades
)
VALUES
  (
    '40100000-0000-4000-8000-000000000001',
    '1.0.0',
    '40000000-0000-4000-8000-000000000001',
    'skill',
    'SYN-MG-PHI-2-001',
    'Synthetic Philosophy Skill A',
    'Synthetic description for schema validation.',
    'Filosofia',
    ARRAY['2_em']::text[]
  ),
  (
    '40100000-0000-4000-8000-000000000002',
    '1.0.0',
    '40000000-0000-4000-8000-000000000001',
    'knowledge_object',
    'SYN-MG-PHI-2-002',
    'Synthetic Philosophy Knowledge Object B',
    'Second synthetic description.',
    'Filosofia',
    ARRAY['2_em']::text[]
  );

INSERT INTO public.kf_curriculum_links (
  id,
  version,
  curriculum_package_id,
  from_node_id,
  to_node_id,
  relation
)
VALUES (
  '40200000-0000-4000-8000-000000000001',
  '1.0.0',
  '40000000-0000-4000-8000-000000000001',
  '40100000-0000-4000-8000-000000000001',
  '40100000-0000-4000-8000-000000000002',
  'supports'
);

-- -----------------------------------------------------------------------------
-- 5. Synthetic pedagogical components
-- -----------------------------------------------------------------------------
SET CONSTRAINTS kf_pedagogical_components_current_version_fk DEFERRED;

INSERT INTO public.kf_pedagogical_components (
  id,
  version,
  canonical_key,
  title,
  component_type,
  school_component,
  grades,
  status,
  current_version_id,
  created_at,
  updated_at
)
VALUES
  (
    '30000000-0000-4000-8000-000000000001',
    '1.0.0',
    'synthetic-philosophy-concept-a',
    'Synthetic Philosophy Concept A',
    'concept',
    'Filosofia',
    ARRAY['2_em']::text[],
    'approved',
    '30100000-0000-4000-8000-000000000001',
    now(),
    now()
  ),
  (
    '30000000-0000-4000-8000-000000000002',
    '1.0.0',
    'synthetic-philosophy-concept-b',
    'Synthetic Philosophy Concept B',
    'concept',
    'Filosofia',
    ARRAY['2_em']::text[],
    'approved',
    '30100000-0000-4000-8000-000000000002',
    now(),
    now()
  );

INSERT INTO public.kf_component_versions (
  id,
  version,
  component_id,
  summary,
  keywords,
  approved_at,
  status
)
VALUES
  (
    '30100000-0000-4000-8000-000000000001',
    '1.0.0',
    '30000000-0000-4000-8000-000000000001',
    'Synthetic summary A.',
    ARRAY['synthetic', 'philosophy']::text[],
    now(),
    'approved'
  ),
  (
    '30100000-0000-4000-8000-000000000002',
    '1.0.0',
    '30000000-0000-4000-8000-000000000002',
    'Synthetic summary B.',
    ARRAY['synthetic', 'philosophy']::text[],
    now(),
    'approved'
  );

SET CONSTRAINTS kf_pedagogical_components_current_version_fk IMMEDIATE;

INSERT INTO public.kf_component_source_evidence (
  id,
  version,
  component_version_id,
  source_id,
  source_version_id,
  source_segment_id,
  contribution,
  recorded_at
)
VALUES (
  '30200000-0000-4000-8000-000000000001',
  '1.0.0',
  '30100000-0000-4000-8000-000000000001',
  '20000000-0000-4000-8000-000000000001',
  '20100000-0000-4000-8000-000000000001',
  '20200000-0000-4000-8000-000000000001',
  'conceptual',
  now()
);

INSERT INTO public.kf_component_curriculum_links (
  component_version_id,
  curriculum_node_id
)
VALUES (
  '30100000-0000-4000-8000-000000000001',
  '40100000-0000-4000-8000-000000000001'
);

-- -----------------------------------------------------------------------------
-- 6. Synthetic OPP and audit fixtures
-- -----------------------------------------------------------------------------
INSERT INTO public.kf_production_orders (
  id,
  version,
  requester_id,
  agent_profile_id,
  curriculum_package_id,
  product_type,
  theme,
  duration_minutes,
  status,
  created_at,
  updated_at
)
VALUES
  (
    '50000000-0000-4000-8000-000000000001',
    '1.0.0',
    '10000000-0000-4000-8000-000000000001',
    '90000000-0000-4000-8000-000000000001',
    '40000000-0000-4000-8000-000000000001',
    'lesson_plan',
    'Synthetic theme A',
    50,
    'requested',
    now(),
    now()
  ),
  (
    '50000000-0000-4000-8000-000000000002',
    '1.0.0',
    '10000000-0000-4000-8000-000000000002',
    '90000000-0000-4000-8000-000000000001',
    '40000000-0000-4000-8000-000000000001',
    'lesson_plan',
    'Synthetic theme B',
    50,
    'requested',
    now(),
    now()
  );

INSERT INTO public.kf_production_order_events (
  id,
  version,
  opp_id,
  event_type,
  from_status,
  to_status,
  reason,
  occurred_at
)
VALUES (
  '50100000-0000-4000-8000-000000000001',
  '1.0.0',
  '50000000-0000-4000-8000-000000000001',
  'created',
  NULL,
  'requested',
  'Synthetic creation event.',
  now()
);

INSERT INTO public.kf_audit_events (
  id,
  event_type,
  aggregate_type,
  aggregate_id,
  occurred_at,
  actor_id,
  actor_role,
  outcome,
  metadata
)
VALUES (
  '60000000-0000-4000-8000-000000000001',
  'synthetic_validation',
  'source',
  '20000000-0000-4000-8000-000000000001',
  now(),
  '10000000-0000-4000-8000-000000000003',
  'admin',
  'recorded',
  '{"synthetic":true}'::jsonb
);

-- -----------------------------------------------------------------------------
-- 7. Constraint negative tests
-- -----------------------------------------------------------------------------
SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_sources (
      id, version, title, source_type, status, license_category,
      allowed_uses, created_at, updated_at
    ) VALUES (
      '20000000-0000-4000-8000-000000000091',
      '',
      'Invalid empty version',
      'wrtech_owned',
      'approved',
      'owned',
      ARRAY['retrieval']::text[],
      now(),
      now()
    )
  $sql$,
  ARRAY['23514']::text[],
  'empty version must be rejected'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_sources (
      id, version, title, source_type, status, license_category,
      allowed_uses, created_at, updated_at
    ) VALUES (
      '20000000-0000-4000-8000-000000000092',
      '1.0.0',
      'Invalid source status',
      'wrtech_owned',
      'not_a_status',
      'owned',
      ARRAY['retrieval']::text[],
      now(),
      now()
    )
  $sql$,
  ARRAY['23514']::text[],
  'invalid source status must be rejected'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_source_versions (
      id, version, source_id, checksum, effective_at
    ) VALUES (
      '20100000-0000-4000-8000-000000000091',
      '1.0.0',
      '20000000-0000-4000-8000-000000000099',
      'orphan-checksum',
      now()
    )
  $sql$,
  ARRAY['23503']::text[],
  'orphan source version must be rejected'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_source_versions (
      id, version, source_id, checksum, effective_at
    ) VALUES (
      '20100000-0000-4000-8000-000000000092',
      '1.0.0',
      '20000000-0000-4000-8000-000000000001',
      'duplicate-version',
      now()
    )
  $sql$,
  ARRAY['23505']::text[],
  'duplicate source version must be rejected'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_curriculum_packages (
      id, version, state, stage, status, title, effective_from
    ) VALUES (
      '40000000-0000-4000-8000-000000000091',
      '2.0.0',
      'MG',
      'ensino_medio',
      'active',
      'Second active MG package',
      now()
    )
  $sql$,
  ARRAY['23505']::text[],
  'two active packages for the same state/stage must be rejected'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_curriculum_packages (
      id, version, state, stage, status, title, effective_from
    ) VALUES (
      '40000000-0000-4000-8000-000000000092',
      '1.0.0',
      'RS',
      'ensino_medio',
      'active',
      'Forbidden active RS package in MVP',
      now()
    )
  $sql$,
  ARRAY['23514']::text[],
  'RS active package must remain blocked in the MVP'
);

SELECT pg_temp.expect_error(
  $sql$
    SET CONSTRAINTS kf_pedagogical_components_current_version_fk DEFERRED;
    UPDATE public.kf_pedagogical_components
    SET current_version_id = '30100000-0000-4000-8000-000000000002'
    WHERE id = '30000000-0000-4000-8000-000000000001';
    SET CONSTRAINTS kf_pedagogical_components_current_version_fk IMMEDIATE;
  $sql$,
  ARRAY['23503']::text[],
  'component current_version_id cannot point to another component version'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_component_source_evidence (
      id,
      version,
      component_version_id,
      source_id,
      source_version_id,
      source_segment_id,
      contribution,
      recorded_at
    ) VALUES (
      '30200000-0000-4000-8000-000000000091',
      '1.0.0',
      '30100000-0000-4000-8000-000000000001',
      '20000000-0000-4000-8000-000000000001',
      '20100000-0000-4000-8000-000000000001',
      '20200000-0000-4000-8000-000000000099',
      'conceptual',
      now()
    )
  $sql$,
  ARRAY['23503']::text[],
  'evidence with an orphan segment must be rejected'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_component_source_evidence (
      id,
      version,
      component_version_id,
      source_id,
      source_version_id,
      source_segment_id,
      contribution,
      recorded_at
    ) VALUES (
      '30200000-0000-4000-8000-000000000092',
      '1.0.0',
      '30100000-0000-4000-8000-000000000001',
      '20000000-0000-4000-8000-000000000001',
      '20100000-0000-4000-8000-000000000001',
      '20200000-0000-4000-8000-000000000002',
      'conceptual',
      now()
    )
  $sql$,
  ARRAY['23503']::text[],
  'mismatched source/version/segment evidence chain must be rejected'
);

-- -----------------------------------------------------------------------------
-- 8. Append-only physical tests as privileged migration/test runner
-- -----------------------------------------------------------------------------
SELECT pg_temp.expect_error(
  $sql$
    UPDATE public.kf_source_permission_events
    SET reason = 'should fail'
    WHERE id = '20300000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['55000']::text[],
  'permission events must reject UPDATE'
);

SELECT pg_temp.expect_error(
  $sql$
    DELETE FROM public.kf_source_permission_events
    WHERE id = '20300000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['55000']::text[],
  'permission events must reject DELETE'
);

SELECT pg_temp.expect_error(
  $sql$
    UPDATE public.kf_production_order_events
    SET reason = 'should fail'
    WHERE id = '50100000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['55000']::text[],
  'OPP events must reject UPDATE'
);

SELECT pg_temp.expect_error(
  $sql$
    DELETE FROM public.kf_production_order_events
    WHERE id = '50100000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['55000']::text[],
  'OPP events must reject DELETE'
);

SELECT pg_temp.expect_error(
  $sql$
    UPDATE public.kf_audit_events
    SET reason = 'should fail'
    WHERE id = '60000000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['55000']::text[],
  'audit events must reject UPDATE'
);

SELECT pg_temp.expect_error(
  $sql$
    DELETE FROM public.kf_audit_events
    WHERE id = '60000000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['55000']::text[],
  'audit events must reject DELETE'
);

-- -----------------------------------------------------------------------------
-- 9. RLS — anon has no table privileges
-- -----------------------------------------------------------------------------
SET LOCAL ROLE anon;

SELECT pg_temp.expect_error(
  'SELECT * FROM public.kf_sources',
  ARRAY['42501']::text[],
  'anon must not access the Knowledge Factory corpus'
);

RESET ROLE;

-- -----------------------------------------------------------------------------
-- 10. RLS — authenticated user A
-- -----------------------------------------------------------------------------
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"10000000-0000-4000-8000-000000000001","role":"authenticated"}',
  true
);
SELECT set_config(
  'request.jwt.claim.sub',
  '10000000-0000-4000-8000-000000000001',
  true
);
SET LOCAL ROLE authenticated;

SELECT pg_temp.assert_true(
  (SELECT count(*) = 0 FROM public.kf_sources),
  'teacher must not read corpus sources directly'
);

SELECT pg_temp.assert_true(
  (SELECT count(*) = 0 FROM public.kf_source_segments),
  'teacher must not read raw source segments directly'
);

SELECT pg_temp.assert_true(
  (SELECT count(*) = 0 FROM public.kf_pedagogical_components),
  'teacher must not read pedagogical components directly'
);

SELECT pg_temp.assert_true(
  (SELECT count(*) = 0 FROM public.kf_audit_events),
  'teacher must not read audit events'
);

SELECT pg_temp.assert_true(
  (
    SELECT count(*) = 1
    FROM public.kf_production_orders
    WHERE id = '50000000-0000-4000-8000-000000000001'
  ),
  'user A must read own OPP'
);

SELECT pg_temp.assert_true(
  (
    SELECT count(*) = 0
    FROM public.kf_production_orders
    WHERE id = '50000000-0000-4000-8000-000000000002'
  ),
  'user A must not read user B OPP'
);

INSERT INTO public.kf_production_orders (
  id,
  version,
  requester_id,
  agent_profile_id,
  curriculum_package_id,
  product_type,
  theme,
  duration_minutes,
  status,
  created_at,
  updated_at
)
VALUES (
  '50000000-0000-4000-8000-000000000003',
  '1.0.0',
  '10000000-0000-4000-8000-000000000001',
  '90000000-0000-4000-8000-000000000001',
  '40000000-0000-4000-8000-000000000001',
  'didactic_text',
  'Synthetic own OPP insert',
  NULL,
  'requested',
  now(),
  now()
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_production_orders (
      id,
      version,
      requester_id,
      agent_profile_id,
      curriculum_package_id,
      product_type,
      theme,
      status,
      created_at,
      updated_at
    ) VALUES (
      '50000000-0000-4000-8000-000000000004',
      '1.0.0',
      '10000000-0000-4000-8000-000000000002',
      '90000000-0000-4000-8000-000000000001',
      '40000000-0000-4000-8000-000000000001',
      'didactic_text',
      'Tampered requester',
      'requested',
      now(),
      now()
    )
  $sql$,
  ARRAY['42501']::text[],
  'requester_id tampering must be rejected'
);

SELECT pg_temp.expect_error(
  $sql$
    UPDATE public.kf_production_orders
    SET status = 'ready'
    WHERE id = '50000000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['42501']::text[],
  'teacher must not update OPP status directly'
);

SELECT pg_temp.assert_true(
  (
    SELECT count(*) = 1
    FROM public.kf_production_order_events
    WHERE id = '50100000-0000-4000-8000-000000000001'
  ),
  'user A must read events from own OPP'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_production_order_events (
      id, version, opp_id, event_type, to_status, occurred_at
    ) VALUES (
      '50100000-0000-4000-8000-000000000091',
      '1.0.0',
      '50000000-0000-4000-8000-000000000001',
      'created',
      'requested',
      now()
    )
  $sql$,
  ARRAY['42501']::text[],
  'teacher must not insert OPP events directly'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_source_permission_events (
      id, version, source_id, action, use_type, reason, occurred_at
    ) VALUES (
      '20300000-0000-4000-8000-000000000091',
      '1.0.0',
      '20000000-0000-4000-8000-000000000001',
      'block',
      'generation',
      'Unauthorized teacher mutation',
      now()
    )
  $sql$,
  ARRAY['42501']::text[],
  'teacher must not insert permission events'
);

SELECT pg_temp.expect_error(
  $sql$
    UPDATE public.kf_curriculum_packages
    SET status = 'retired'
    WHERE id = '40000000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['42501']::text[],
  'teacher must not mutate curriculum packages directly'
);

RESET ROLE;

-- -----------------------------------------------------------------------------
-- 11. RLS — authenticated user B
-- -----------------------------------------------------------------------------
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"10000000-0000-4000-8000-000000000002","role":"authenticated"}',
  true
);
SELECT set_config(
  'request.jwt.claim.sub',
  '10000000-0000-4000-8000-000000000002',
  true
);
SET LOCAL ROLE authenticated;

SELECT pg_temp.assert_true(
  (
    SELECT count(*) = 1
    FROM public.kf_production_orders
    WHERE id = '50000000-0000-4000-8000-000000000002'
  ),
  'user B must read own OPP'
);

SELECT pg_temp.assert_true(
  (
    SELECT count(*) = 0
    FROM public.kf_production_orders
    WHERE id IN (
      '50000000-0000-4000-8000-000000000001',
      '50000000-0000-4000-8000-000000000003'
    )
  ),
  'user B must not read user A OPPs'
);

SELECT pg_temp.assert_true(
  (
    SELECT count(*) = 0
    FROM public.kf_production_order_events
    WHERE id = '50100000-0000-4000-8000-000000000001'
  ),
  'user B must not read user A OPP events'
);

RESET ROLE;

-- -----------------------------------------------------------------------------
-- 12. RLS — school_admin is not platform admin
-- -----------------------------------------------------------------------------
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"10000000-0000-4000-8000-000000000004","role":"authenticated"}',
  true
);
SELECT set_config(
  'request.jwt.claim.sub',
  '10000000-0000-4000-8000-000000000004',
  true
);
SET LOCAL ROLE authenticated;

SELECT pg_temp.assert_true(
  (SELECT count(*) = 0 FROM public.kf_sources),
  'school_admin must not receive global corpus access'
);

RESET ROLE;

-- -----------------------------------------------------------------------------
-- 13. RLS — platform admin read-only governance
-- -----------------------------------------------------------------------------
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"10000000-0000-4000-8000-000000000003","role":"authenticated"}',
  true
);
SELECT set_config(
  'request.jwt.claim.sub',
  '10000000-0000-4000-8000-000000000003',
  true
);
SET LOCAL ROLE authenticated;

SELECT pg_temp.assert_true(
  (SELECT count(*) = 2 FROM public.kf_sources),
  'platform admin must read corpus for governance'
);

SELECT pg_temp.assert_true(
  (SELECT count(*) = 1 FROM public.kf_audit_events),
  'platform admin must read audit events'
);

SELECT pg_temp.expect_error(
  $sql$
    UPDATE public.kf_sources
    SET status = 'blocked'
    WHERE id = '20000000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['42501']::text[],
  'platform admin must not write corpus directly in Lote 3A'
);

RESET ROLE;

-- -----------------------------------------------------------------------------
-- 14. RLS is enabled on every kf_* table
-- -----------------------------------------------------------------------------
SELECT pg_temp.assert_true(
  (
    SELECT count(*) = 15
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = 'public'
      AND c.relname LIKE 'kf\_%' ESCAPE '\'
      AND c.relkind = 'r'
      AND c.relrowsecurity
  ),
  'RLS must be enabled on all 15 Knowledge Factory tables'
);

-- All synthetic rows and synthetic auth identities are removed here.
ROLLBACK;
