-- =============================================================================
-- Knowledge Factory Lote 3B.4B.2 - transactional component write validation
-- NON-PRODUCTION ONLY. All fixtures are synthetic and rolled back.
-- =============================================================================

BEGIN;

CREATE TEMP TABLE kf_component_write_test_bootstrap (id integer);

CREATE OR REPLACE FUNCTION pg_temp.kf_assert(p_condition boolean, p_message text)
RETURNS void
LANGUAGE plpgsql
AS $function$
BEGIN
  IF p_condition IS NOT TRUE THEN
    RAISE EXCEPTION 'ASSERTION FAILED: %', p_message;
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION pg_temp.kf_expect_error(
  p_sql text,
  p_allowed_states text[],
  p_message text
)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
  v_state text;
BEGIN
  BEGIN
    EXECUTE p_sql;
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_state = RETURNED_SQLSTATE;
    IF v_state = ANY(p_allowed_states) THEN
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
$function$;

CREATE OR REPLACE FUNCTION pg_temp.kf_test_uuid(p_prefix text, p_suffix integer)
RETURNS uuid
LANGUAGE sql
IMMUTABLE
AS $function$
  SELECT (p_prefix || lpad(p_suffix::text, 12, '0'))::uuid
$function$;

CREATE OR REPLACE FUNCTION pg_temp.kf_evidence(
  p_version_id uuid,
  p_evidence_id uuid
)
RETURNS jsonb
LANGUAGE sql
IMMUTABLE
AS $function$
  SELECT jsonb_build_object(
    'id', p_evidence_id::text,
    'version', '1.0.0',
    'componentVersionId', p_version_id::text,
    'sourceId', 'b1000000-0000-4000-8000-000000000001',
    'sourceVersionId', 'b1100000-0000-4000-8000-000000000001',
    'sourceSegmentId', 'b1200000-0000-4000-8000-000000000001',
    'contribution', 'conceptual',
    'recordedAt', '2026-08-08T16:00:00.000Z'
  )
$function$;

CREATE OR REPLACE FUNCTION pg_temp.kf_version(
  p_component_id uuid,
  p_version_id uuid,
  p_evidence_id uuid,
  p_status text,
  p_version text,
  p_with_material boolean,
  p_supersedes_version text DEFAULT NULL
)
RETURNS jsonb
LANGUAGE sql
IMMUTABLE
AS $function$
  SELECT jsonb_strip_nulls(jsonb_build_object(
    'id', p_version_id::text,
    'version', p_version,
    'componentId', p_component_id::text,
    'summary', 'Synthetic transactional component version.',
    'keywords', jsonb_build_array('synthetic', 'transactional'),
    'sourceEvidenceIds', CASE
      WHEN p_with_material THEN jsonb_build_array(p_evidence_id::text)
      ELSE '[]'::jsonb
    END,
    'curriculumNodeIds', CASE
      WHEN p_with_material THEN jsonb_build_array(
        'b2100000-0000-4000-8000-000000000001'
      )
      ELSE '[]'::jsonb
    END,
    'supersedesVersion', p_supersedes_version,
    'approvedAt', CASE
      WHEN p_status = 'approved' THEN '2026-08-08T16:00:00.000Z'
      ELSE NULL
    END,
    'status', p_status
  ))
$function$;

CREATE OR REPLACE FUNCTION pg_temp.kf_create_payload(
  p_suffix integer,
  p_status text,
  p_with_material boolean
)
RETURNS jsonb
LANGUAGE sql
IMMUTABLE
AS $function$
  SELECT jsonb_build_object(
    'component', jsonb_build_object(
      'id', pg_temp.kf_test_uuid('b3000000-0000-4000-8000-', p_suffix)::text,
      'version', '1.0.0',
      'canonicalKey', 'synthetic-transactional-' || p_suffix::text,
      'title', 'Synthetic transactional component ' || p_suffix::text,
      'componentType', 'concept',
      'schoolComponent', 'Filosofia',
      'grades', jsonb_build_array('2_em'),
      'status', p_status,
      'currentVersionId', pg_temp.kf_test_uuid(
        'b3100000-0000-4000-8000-', p_suffix
      )::text,
      'createdAt', '2026-08-08T15:00:00.000Z',
      'updatedAt', '2026-08-08T15:00:00.000Z'
    ),
    'initialVersion', pg_temp.kf_version(
      pg_temp.kf_test_uuid('b3000000-0000-4000-8000-', p_suffix),
      pg_temp.kf_test_uuid('b3100000-0000-4000-8000-', p_suffix),
      pg_temp.kf_test_uuid('b3200000-0000-4000-8000-', p_suffix),
      p_status,
      '1.0.0',
      p_with_material
    ),
    'evidenceOrigins', CASE
      WHEN p_with_material THEN jsonb_build_array(pg_temp.kf_evidence(
        pg_temp.kf_test_uuid('b3100000-0000-4000-8000-', p_suffix),
        pg_temp.kf_test_uuid('b3200000-0000-4000-8000-', p_suffix)
      ))
      ELSE '[]'::jsonb
    END
  )
$function$;

CREATE OR REPLACE FUNCTION pg_temp.kf_append_payload(
  p_component_id uuid,
  p_expected_current_id uuid,
  p_version_id uuid,
  p_evidence_id uuid,
  p_version text,
  p_status text
)
RETURNS jsonb
LANGUAGE sql
IMMUTABLE
AS $function$
  SELECT jsonb_build_object(
    'expectedCurrentVersionId', p_expected_current_id::text,
    'version', pg_temp.kf_version(
      p_component_id,
      p_version_id,
      p_evidence_id,
      p_status,
      p_version,
      true,
      '1.0.0'
    ),
    'evidenceOrigins', jsonb_build_array(pg_temp.kf_evidence(p_version_id, p_evidence_id))
  )
$function$;

-- ---------------------------------------------------------------------------
-- 1. Synthetic provenance and curriculum dependencies
-- ---------------------------------------------------------------------------
INSERT INTO public.kf_sources (
  id, version, title, source_type, status, license_category, allowed_uses
) VALUES (
  'b1000000-0000-4000-8000-000000000001',
  '1.0.0',
  'WRTECH-SYNTHETIC-COMPONENT-WRITE-SOURCE',
  'wrtech_owned',
  'approved',
  'owned',
  ARRAY['generation']::text[]
);

INSERT INTO public.kf_source_versions (
  id, version, source_id, checksum, effective_at
) VALUES (
  'b1100000-0000-4000-8000-000000000001',
  '1.0.0',
  'b1000000-0000-4000-8000-000000000001',
  'sha256:synthetic-component-write-source',
  '2026-08-08T15:00:00.000Z'
);

INSERT INTO public.kf_source_segments (
  id, version, source_version_id, locator, content_digest, extracted_text
) VALUES (
  'b1200000-0000-4000-8000-000000000001',
  '1.0.0',
  'b1100000-0000-4000-8000-000000000001',
  'synthetic://component-write/segment',
  'sha256:synthetic-component-write-segment',
  'Synthetic evidence only.'
);

INSERT INTO public.kf_curriculum_packages (
  id, version, state, stage, status, title, effective_from
) VALUES (
  'b2000000-0000-4000-8000-000000000001',
  '1.0.0',
  'MG',
  'ensino_medio',
  'draft',
  'Synthetic transactional curriculum package',
  '2026-08-08T15:00:00.000Z'
);

INSERT INTO public.kf_curriculum_nodes (
  id, version, curriculum_package_id, node_type, code, title, description,
  component, grades
) VALUES (
  'b2100000-0000-4000-8000-000000000001',
  '1.0.0',
  'b2000000-0000-4000-8000-000000000001',
  'skill',
  'SYN-WRITE-001',
  'Synthetic transactional skill',
  'Synthetic description.',
  'Filosofia',
  ARRAY['2_em']::text[]
);

-- ---------------------------------------------------------------------------
-- 2. Surface, ownership, RLS and least privilege
-- ---------------------------------------------------------------------------
SELECT pg_temp.kf_assert(
  to_regclass('public.kf_component_write_receipts') IS NOT NULL,
  'the idempotency receipt table must exist'
);

SELECT pg_temp.kf_assert(
  (
    SELECT relrowsecurity
    FROM pg_class
    WHERE oid = 'public.kf_component_write_receipts'::regclass
  ),
  'receipt RLS must be enabled'
);

SELECT pg_temp.kf_assert(
  (
    SELECT count(*) = 4
    FROM pg_proc AS functions
    JOIN pg_namespace AS namespaces ON namespaces.oid = functions.pronamespace
    WHERE namespaces.nspname = 'public'
      AND functions.proname IN (
        'kf_create_pedagogical_component_aggregate',
        'kf_append_pedagogical_component_version',
        'kf_transition_pedagogical_component_version_status',
        'kf_promote_pedagogical_component_version'
      )
      AND functions.prosecdef
      AND functions.proowner = 'postgres'::regrole
      AND functions.proconfig @> ARRAY['search_path=pg_catalog, public']::text[]
  ),
  'all four RPCs must be postgres-owned SECURITY DEFINER functions with a fixed search_path'
);

SELECT pg_temp.kf_assert(
  has_function_privilege(
    'service_role',
    'public.kf_create_pedagogical_component_aggregate(uuid,jsonb)',
    'EXECUTE'
  )
  AND has_function_privilege(
    'service_role',
    'public.kf_append_pedagogical_component_version(uuid,jsonb)',
    'EXECUTE'
  )
  AND has_function_privilege(
    'service_role',
    'public.kf_transition_pedagogical_component_version_status(uuid,jsonb)',
    'EXECUTE'
  )
  AND has_function_privilege(
    'service_role',
    'public.kf_promote_pedagogical_component_version(uuid,jsonb)',
    'EXECUTE'
  ),
  'service_role must execute all four RPCs'
);

SELECT pg_temp.kf_assert(
  NOT has_function_privilege(
    'anon', 'public.kf_create_pedagogical_component_aggregate(uuid,jsonb)', 'EXECUTE'
  )
  AND NOT has_function_privilege(
    'authenticated',
    'public.kf_create_pedagogical_component_aggregate(uuid,jsonb)',
    'EXECUTE'
  ),
  'anon and authenticated must not execute component write RPCs'
);

SELECT pg_temp.kf_assert(
  NOT has_table_privilege('service_role', 'public.kf_pedagogical_components', 'INSERT')
  AND NOT has_table_privilege('service_role', 'public.kf_pedagogical_components', 'UPDATE')
  AND NOT has_table_privilege('service_role', 'public.kf_component_versions', 'INSERT')
  AND NOT has_table_privilege('service_role', 'public.kf_component_versions', 'UPDATE')
  AND NOT has_table_privilege('service_role', 'public.kf_component_source_evidence', 'INSERT')
  AND NOT has_table_privilege('service_role', 'public.kf_component_curriculum_links', 'INSERT')
  AND has_table_privilege('service_role', 'public.kf_pedagogical_components', 'SELECT'),
  'service_role must retain reads but lose direct aggregate DML'
);

SELECT pg_temp.kf_assert(
  NOT has_table_privilege('service_role', 'public.kf_component_write_receipts', 'SELECT')
  AND NOT has_table_privilege('service_role', 'public.kf_component_write_receipts', 'INSERT'),
  'receipt storage must have no direct service_role privileges'
);

-- Matrix parity with packages/knowledge-factory/src/policies/component-lifecycle.ts.
WITH statuses(status) AS (
  SELECT unnest(ARRAY[
    'draft', 'in_review', 'approved', 'rejected', 'superseded', 'suspended',
    'blocked', 'archived'
  ]::text[])
), expected(from_status, to_status) AS (
  VALUES
    ('draft', 'in_review'), ('draft', 'blocked'), ('draft', 'archived'),
    ('in_review', 'approved'), ('in_review', 'rejected'), ('in_review', 'blocked'),
    ('in_review', 'archived'), ('approved', 'suspended'), ('approved', 'superseded'),
    ('approved', 'blocked'), ('approved', 'archived'), ('rejected', 'archived'),
    ('superseded', 'archived'), ('suspended', 'in_review'), ('suspended', 'blocked'),
    ('suspended', 'archived'), ('blocked', 'archived')
)
SELECT pg_temp.kf_assert(
  NOT EXISTS (
    SELECT 1
    FROM statuses AS source
    CROSS JOIN statuses AS target
    WHERE public.kf_component_transition_allowed_internal(source.status, target.status)
      IS DISTINCT FROM EXISTS (
        SELECT 1 FROM expected
        WHERE expected.from_status = source.status
          AND expected.to_status = target.status
      )
  ),
  'the SQL transition matrix must equal the TypeScript lifecycle matrix'
);

-- ---------------------------------------------------------------------------
-- 3. Complete create, replay and fingerprint conflict
-- ---------------------------------------------------------------------------
DO $test$
DECLARE
  v_receipt record;
BEGIN
  SELECT * INTO v_receipt
  FROM public.kf_create_pedagogical_component_aggregate(
    'b9000000-0000-4000-8000-000000000001',
    pg_temp.kf_create_payload(1, 'approved', true)
  );

  PERFORM pg_temp.kf_assert(NOT v_receipt.replayed, 'first create must not be a replay');
  PERFORM pg_temp.kf_assert(
    v_receipt.component_id = 'b3000000-0000-4000-8000-000000000001',
    'create receipt must identify the component'
  );

  SELECT * INTO v_receipt
  FROM public.kf_create_pedagogical_component_aggregate(
    'b9000000-0000-4000-8000-000000000001',
    pg_temp.kf_create_payload(1, 'approved', true)
  );
  PERFORM pg_temp.kf_assert(v_receipt.replayed, 'same create command must replay');
END;
$test$;

SELECT pg_temp.kf_assert(
  (SELECT count(*) = 1 FROM public.kf_pedagogical_components
   WHERE id = 'b3000000-0000-4000-8000-000000000001')
  AND (SELECT count(*) = 1 FROM public.kf_component_versions
       WHERE component_id = 'b3000000-0000-4000-8000-000000000001')
  AND (SELECT count(*) = 1 FROM public.kf_component_source_evidence
       WHERE component_version_id = 'b3100000-0000-4000-8000-000000000001')
  AND (SELECT count(*) = 1 FROM public.kf_component_curriculum_links
       WHERE component_version_id = 'b3100000-0000-4000-8000-000000000001')
  AND (SELECT count(*) = 1 FROM public.kf_component_write_receipts
       WHERE command_id = 'b9000000-0000-4000-8000-000000000001'),
  'create and replay must produce exactly one complete aggregate and one receipt'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_create_pedagogical_component_aggregate(
      'b9000000-0000-4000-8000-000000000001',
      jsonb_set(
        pg_temp.kf_create_payload(1, 'approved', true),
        '{component,title}',
        '"Different valid title"'::jsonb
      )
    )
  $sql$,
  ARRAY['40001'],
  'same commandId with a different fingerprint must conflict'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_create_pedagogical_component_aggregate(
      'b9000000-0000-4000-8000-000000000002',
      pg_temp.kf_create_payload(2, 'draft', false) || '{"unknown":true}'::jsonb
    )
  $sql$,
  ARRAY['22023'],
  'closed payload schema must reject unknown fields'
);

-- ---------------------------------------------------------------------------
-- 4. Failure injection proves rollback at every physical create stage
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pg_temp.kf_fail_selected_insert()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
  IF current_setting('kf.test.fail_table', true) = TG_TABLE_NAME THEN
    RAISE EXCEPTION USING ERRCODE = 'P0001', MESSAGE = 'synthetic stage failure';
  END IF;
  RETURN NEW;
END;
$function$;

CREATE TRIGGER kf_test_fail_component
BEFORE INSERT ON public.kf_pedagogical_components
FOR EACH ROW EXECUTE FUNCTION pg_temp.kf_fail_selected_insert();
CREATE TRIGGER kf_test_fail_version
BEFORE INSERT ON public.kf_component_versions
FOR EACH ROW EXECUTE FUNCTION pg_temp.kf_fail_selected_insert();
CREATE TRIGGER kf_test_fail_evidence
BEFORE INSERT ON public.kf_component_source_evidence
FOR EACH ROW EXECUTE FUNCTION pg_temp.kf_fail_selected_insert();
CREATE TRIGGER kf_test_fail_curriculum
BEFORE INSERT ON public.kf_component_curriculum_links
FOR EACH ROW EXECUTE FUNCTION pg_temp.kf_fail_selected_insert();
CREATE TRIGGER kf_test_fail_receipt
BEFORE INSERT ON public.kf_component_write_receipts
FOR EACH ROW EXECUTE FUNCTION pg_temp.kf_fail_selected_insert();

DO $atomicity$
DECLARE
  v_stage text;
  v_suffix integer := 10;
  v_component_id uuid;
  v_version_id uuid;
  v_command_id uuid;
BEGIN
  FOREACH v_stage IN ARRAY ARRAY[
    'kf_pedagogical_components',
    'kf_component_versions',
    'kf_component_source_evidence',
    'kf_component_curriculum_links',
    'kf_component_write_receipts'
  ] LOOP
    v_component_id := pg_temp.kf_test_uuid('b3000000-0000-4000-8000-', v_suffix);
    v_version_id := pg_temp.kf_test_uuid('b3100000-0000-4000-8000-', v_suffix);
    v_command_id := pg_temp.kf_test_uuid('b9000000-0000-4000-8000-', v_suffix);
    PERFORM set_config('kf.test.fail_table', v_stage, true);

    BEGIN
      PERFORM * FROM public.kf_create_pedagogical_component_aggregate(
        v_command_id,
        pg_temp.kf_create_payload(v_suffix, 'approved', true)
      );
      RAISE EXCEPTION USING
        ERRCODE = 'P0002',
        MESSAGE = 'create unexpectedly survived failure at ' || v_stage;
    EXCEPTION WHEN SQLSTATE 'P0001' THEN
      NULL;
    END;

    PERFORM pg_temp.kf_assert(
      NOT EXISTS (SELECT 1 FROM public.kf_pedagogical_components WHERE id = v_component_id)
      AND NOT EXISTS (SELECT 1 FROM public.kf_component_versions WHERE id = v_version_id)
      AND NOT EXISTS (
        SELECT 1 FROM public.kf_component_source_evidence
        WHERE component_version_id = v_version_id
      )
      AND NOT EXISTS (
        SELECT 1 FROM public.kf_component_curriculum_links
        WHERE component_version_id = v_version_id
      )
      AND NOT EXISTS (
        SELECT 1 FROM public.kf_component_write_receipts WHERE command_id = v_command_id
      ),
      'failure at ' || v_stage || ' left partial create state'
    );

    v_suffix := v_suffix + 1;
  END LOOP;

  PERFORM set_config('kf.test.fail_table', '', true);
END;
$atomicity$;

-- ---------------------------------------------------------------------------
-- 5. Append, transition and promotion compare-and-set behavior
-- ---------------------------------------------------------------------------
SELECT * FROM public.kf_create_pedagogical_component_aggregate(
  'b9000000-0000-4000-8000-000000000020',
  pg_temp.kf_create_payload(20, 'draft', true)
);

SELECT * FROM public.kf_append_pedagogical_component_version(
  'b9000000-0000-4000-8000-000000000021',
  pg_temp.kf_append_payload(
    'b3000000-0000-4000-8000-000000000020',
    'b3100000-0000-4000-8000-000000000020',
    'b3110000-0000-4000-8000-000000000020',
    'b3210000-0000-4000-8000-000000000020',
    '2.0.0',
    'approved'
  )
);

SELECT pg_temp.kf_assert(
  (
    SELECT current_version_id = 'b3100000-0000-4000-8000-000000000020'
    FROM public.kf_pedagogical_components
    WHERE id = 'b3000000-0000-4000-8000-000000000020'
  ),
  'append must not promote the new version'
);

SELECT pg_temp.kf_assert(
  (
    SELECT replayed FROM public.kf_append_pedagogical_component_version(
      'b9000000-0000-4000-8000-000000000021',
      pg_temp.kf_append_payload(
        'b3000000-0000-4000-8000-000000000020',
        'b3100000-0000-4000-8000-000000000020',
        'b3110000-0000-4000-8000-000000000020',
        'b3210000-0000-4000-8000-000000000020',
        '2.0.0',
        'approved'
      )
    )
  ),
  'append retry must replay without duplication'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_append_pedagogical_component_version(
      'b9000000-0000-4000-8000-000000000022',
      pg_temp.kf_append_payload(
        'b3000000-0000-4000-8000-000000000020',
        'b3100000-0000-4000-8000-000000000099',
        'b3110000-0000-4000-8000-000000000021',
        'b3210000-0000-4000-8000-000000000021',
        '3.0.0',
        'approved'
      )
    )
  $sql$,
  ARRAY['40001'],
  'append must reject a stale expected current version'
);

SELECT set_config('kf.test.fail_table', 'kf_component_write_receipts', true);
SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_append_pedagogical_component_version(
      'b9000000-0000-4000-8000-000000000029',
      pg_temp.kf_append_payload(
        'b3000000-0000-4000-8000-000000000020',
        'b3100000-0000-4000-8000-000000000020',
        'b3110000-0000-4000-8000-000000000029',
        'b3210000-0000-4000-8000-000000000029',
        '3.0.0',
        'approved'
      )
    )
  $sql$,
  ARRAY['P0001'],
  'receipt failure must roll back the appended snapshot'
);
SELECT set_config('kf.test.fail_table', '', true);

SELECT pg_temp.kf_assert(
  NOT EXISTS (
    SELECT 1 FROM public.kf_component_versions
    WHERE id = 'b3110000-0000-4000-8000-000000000029'
  )
  AND NOT EXISTS (
    SELECT 1 FROM public.kf_component_source_evidence
    WHERE component_version_id = 'b3110000-0000-4000-8000-000000000029'
  )
  AND NOT EXISTS (
    SELECT 1 FROM public.kf_component_curriculum_links
    WHERE component_version_id = 'b3110000-0000-4000-8000-000000000029'
  )
  AND NOT EXISTS (
    SELECT 1 FROM public.kf_component_write_receipts
    WHERE command_id = 'b9000000-0000-4000-8000-000000000029'
  ),
  'failed append must not leave version, evidence, curriculum or receipt rows'
);

SELECT * FROM public.kf_transition_pedagogical_component_version_status(
  'b9000000-0000-4000-8000-000000000023',
  jsonb_build_object(
    'componentId', 'b3000000-0000-4000-8000-000000000020',
    'componentVersionId', 'b3100000-0000-4000-8000-000000000020',
    'expectedStatus', 'draft',
    'toStatus', 'in_review',
    'occurredAt', '2026-08-08T17:00:00.000Z'
  )
);

SELECT set_config('kf.test.fail_table', 'kf_component_write_receipts', true);
SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_transition_pedagogical_component_version_status(
      'b9000000-0000-4000-8000-000000000024',
      jsonb_build_object(
        'componentId', 'b3000000-0000-4000-8000-000000000020',
        'componentVersionId', 'b3100000-0000-4000-8000-000000000020',
        'expectedStatus', 'in_review',
        'toStatus', 'approved',
        'occurredAt', '2026-08-08T18:00:00.000Z'
      )
    )
  $sql$,
  ARRAY['P0001'],
  'receipt failure must roll back transition updates'
);
SELECT set_config('kf.test.fail_table', '', true);

SELECT pg_temp.kf_assert(
  (
    SELECT status = 'in_review' FROM public.kf_component_versions
    WHERE id = 'b3100000-0000-4000-8000-000000000020'
  )
  AND (
    SELECT status = 'in_review' FROM public.kf_pedagogical_components
    WHERE id = 'b3000000-0000-4000-8000-000000000020'
  ),
  'failed transition must leave version and current component unchanged'
);

SELECT * FROM public.kf_transition_pedagogical_component_version_status(
  'b9000000-0000-4000-8000-000000000025',
  jsonb_build_object(
    'componentId', 'b3000000-0000-4000-8000-000000000020',
    'componentVersionId', 'b3100000-0000-4000-8000-000000000020',
    'expectedStatus', 'in_review',
    'toStatus', 'approved',
    'occurredAt', '2026-08-08T18:00:00.000Z'
  )
);

SELECT set_config('kf.test.fail_table', 'kf_component_write_receipts', true);
SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_promote_pedagogical_component_version(
      'b9000000-0000-4000-8000-000000000026',
      jsonb_build_object(
        'componentId', 'b3000000-0000-4000-8000-000000000020',
        'targetVersionId', 'b3110000-0000-4000-8000-000000000020',
        'expectedCurrentVersionId', 'b3100000-0000-4000-8000-000000000020',
        'expectedComponentUpdatedAt', '2026-08-08T18:00:00.000Z',
        'occurredAt', '2026-08-08T19:00:00.000Z'
      )
    )
  $sql$,
  ARRAY['P0001'],
  'receipt failure must roll back promotion'
);
SELECT set_config('kf.test.fail_table', '', true);

SELECT pg_temp.kf_assert(
  (
    SELECT current_version_id = 'b3100000-0000-4000-8000-000000000020'
      AND updated_at = '2026-08-08T18:00:00.000Z'::timestamptz
    FROM public.kf_pedagogical_components
    WHERE id = 'b3000000-0000-4000-8000-000000000020'
  ),
  'failed promotion must preserve pointer and timestamp'
);

SELECT * FROM public.kf_promote_pedagogical_component_version(
  'b9000000-0000-4000-8000-000000000027',
  jsonb_build_object(
    'componentId', 'b3000000-0000-4000-8000-000000000020',
    'targetVersionId', 'b3110000-0000-4000-8000-000000000020',
    'expectedCurrentVersionId', 'b3100000-0000-4000-8000-000000000020',
    'expectedComponentUpdatedAt', '2026-08-08T18:00:00.000Z',
    'occurredAt', '2026-08-08T19:00:00.000Z'
  )
);

SELECT pg_temp.kf_assert(
  (
    SELECT current_version_id = 'b3110000-0000-4000-8000-000000000020'
      AND status = 'approved'
      AND updated_at = '2026-08-08T19:00:00.000Z'::timestamptz
    FROM public.kf_pedagogical_components
    WHERE id = 'b3000000-0000-4000-8000-000000000020'
  ),
  'promotion must atomically move the pointer and component state'
);

SELECT pg_temp.kf_assert(
  (
    SELECT replayed FROM public.kf_promote_pedagogical_component_version(
      'b9000000-0000-4000-8000-000000000027',
      jsonb_build_object(
        'componentId', 'b3000000-0000-4000-8000-000000000020',
        'targetVersionId', 'b3110000-0000-4000-8000-000000000020',
        'expectedCurrentVersionId', 'b3100000-0000-4000-8000-000000000020',
        'expectedComponentUpdatedAt', '2026-08-08T18:00:00.000Z',
        'occurredAt', '2026-08-08T19:00:00.000Z'
      )
    )
  ),
  'promotion retry must replay even after aggregate state changed'
);

SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_promote_pedagogical_component_version(
      'b9000000-0000-4000-8000-000000000028',
      jsonb_build_object(
        'componentId', 'b3000000-0000-4000-8000-000000000020',
        'targetVersionId', 'b3110000-0000-4000-8000-000000000020',
        'expectedCurrentVersionId', 'b3110000-0000-4000-8000-000000000020',
        'expectedComponentUpdatedAt', '2026-08-08T19:00:00.000Z',
        'occurredAt', '2026-08-08T20:00:00.000Z'
      )
    )
  $sql$,
  ARRAY['40001'],
  'a new command must reject promoting the already-current target'
);

-- Approval without evidence/curriculum remains structurally forbidden.
SELECT * FROM public.kf_create_pedagogical_component_aggregate(
  'b9000000-0000-4000-8000-000000000030',
  pg_temp.kf_create_payload(30, 'in_review', false)
);
SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_transition_pedagogical_component_version_status(
      'b9000000-0000-4000-8000-000000000031',
      jsonb_build_object(
        'componentId', 'b3000000-0000-4000-8000-000000000030',
        'componentVersionId', 'b3100000-0000-4000-8000-000000000030',
        'expectedStatus', 'in_review',
        'toStatus', 'approved',
        'occurredAt', '2026-08-08T20:00:00.000Z'
      )
    )
  $sql$,
  ARRAY['22023'],
  'approval without evidence or curriculum must fail'
);

-- Direct service_role DML and unprivileged RPC execution must fail.
SET LOCAL ROLE service_role;
SELECT pg_temp.kf_expect_error(
  $sql$
    INSERT INTO public.kf_pedagogical_components (
      id, version, canonical_key, title, component_type, school_component,
      grades, status, current_version_id
    ) VALUES (
      'bf000000-0000-4000-8000-000000000001', '1.0.0', 'forbidden-direct-write',
      'Forbidden', 'concept', 'Filosofia', ARRAY['2_em']::text[], 'draft',
      'bf100000-0000-4000-8000-000000000001'
    )
  $sql$,
  ARRAY['42501'],
  'service_role direct aggregate DML must be denied'
);
RESET ROLE;

SET LOCAL ROLE anon;
SELECT pg_temp.kf_expect_error(
  $sql$
    SELECT * FROM public.kf_create_pedagogical_component_aggregate(
      'bf900000-0000-4000-8000-000000000001',
      '{}'::jsonb
    )
  $sql$,
  ARRAY['42501'],
  'anon RPC execution must be denied'
);
RESET ROLE;

ROLLBACK;
