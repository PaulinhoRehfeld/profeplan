-- =============================================================================
-- ProfePlan Knowledge Factory - Lote 3B.4B.2
-- Transactional writes for pedagogical component aggregates.
--
-- This migration is additive. It does not wire an application adapter and it
-- does not access hosted or production data.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Idempotency receipts
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_component_write_receipts (
  command_id uuid PRIMARY KEY,
  operation text NOT NULL CHECK (
    operation IN (
      'create_component_aggregate',
      'append_component_version',
      'transition_component_version_status',
      'promote_component_version'
    )
  ),
  payload_fingerprint text NOT NULL CHECK (
    payload_fingerprint ~ '^[0-9a-f]{64}$'
  ),
  component_id uuid NOT NULL
    REFERENCES public.kf_pedagogical_components(id) ON DELETE RESTRICT,
  component_version_id uuid
    REFERENCES public.kf_component_versions(id) ON DELETE RESTRICT,
  committed_at timestamptz NOT NULL DEFAULT clock_timestamp()
);

ALTER TABLE public.kf_component_write_receipts ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.kf_component_write_receipts
FROM PUBLIC, anon, authenticated, service_role;

-- ---------------------------------------------------------------------------
-- 2. Closed-schema validation helpers
--
-- These helpers are deliberately not executable by API roles. They exist only
-- to keep the four SECURITY DEFINER command functions small and consistent.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_component_write_assert_object_internal(
  p_value jsonb,
  p_required_keys text[],
  p_allowed_keys text[],
  p_context text
)
RETURNS void
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF p_value IS NULL OR jsonb_typeof(p_value) <> 'object' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must be a JSON object';
  END IF;

  IF NOT (p_value ?& p_required_keys) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' is missing one or more required fields';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM jsonb_object_keys(p_value) AS supplied(key)
    WHERE NOT (supplied.key = ANY(p_allowed_keys))
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' contains an unknown field';
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_component_write_text_internal(
  p_value jsonb,
  p_context text,
  p_allow_empty boolean DEFAULT false
)
RETURNS text
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_result text;
BEGIN
  IF p_value IS NULL OR jsonb_typeof(p_value) <> 'string' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must be a JSON string';
  END IF;

  v_result := p_value #>> '{}';
  IF NOT p_allow_empty AND btrim(v_result) = '' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must not be blank';
  END IF;

  RETURN v_result;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_component_write_uuid_internal(
  p_value jsonb,
  p_context text
)
RETURNS uuid
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_component_write_text_internal(p_value, p_context)::uuid;
EXCEPTION
  WHEN invalid_text_representation THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must be a UUID';
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_component_write_timestamp_internal(
  p_value jsonb,
  p_context text
)
RETURNS timestamptz
LANGUAGE plpgsql
STABLE
SET search_path = pg_catalog, public
AS $function$
BEGIN
  RETURN public.kf_component_write_text_internal(p_value, p_context)::timestamptz;
EXCEPTION
  WHEN invalid_datetime_format OR datetime_field_overflow THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must be a valid timestamp with time zone';
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_component_write_text_array_internal(
  p_value jsonb,
  p_context text,
  p_allowed_values text[] DEFAULT NULL
)
RETURNS text[]
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_result text[];
BEGIN
  IF p_value IS NULL OR jsonb_typeof(p_value) <> 'array' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must be a JSON array';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM jsonb_array_elements(p_value) AS element(value)
    WHERE jsonb_typeof(element.value) <> 'string'
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must contain only strings';
  END IF;

  SELECT coalesce(array_agg(element.value #>> '{}' ORDER BY element.ordinality), '{}'::text[])
  INTO v_result
  FROM jsonb_array_elements(p_value) WITH ORDINALITY AS element(value, ordinality);

  IF EXISTS (SELECT 1 FROM unnest(v_result) AS item(value) WHERE btrim(item.value) = '') THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must not contain blank values';
  END IF;

  IF cardinality(v_result) <> (
    SELECT count(DISTINCT item.value) FROM unnest(v_result) AS item(value)
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must not contain duplicate values';
  END IF;

  IF p_allowed_values IS NOT NULL AND NOT (v_result <@ p_allowed_values) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' contains an unsupported value';
  END IF;

  RETURN v_result;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_component_write_uuid_array_internal(
  p_value jsonb,
  p_context text
)
RETURNS uuid[]
LANGUAGE plpgsql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_text_values text[];
  v_result uuid[];
BEGIN
  v_text_values := public.kf_component_write_text_array_internal(p_value, p_context);

  SELECT coalesce(array_agg(item.value::uuid ORDER BY item.ordinality), '{}'::uuid[])
  INTO v_result
  FROM unnest(v_text_values) WITH ORDINALITY AS item(value, ordinality);

  RETURN v_result;
EXCEPTION
  WHEN invalid_text_representation THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = p_context || ' must contain only UUIDs';
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_component_write_fingerprint_internal(
  p_operation text,
  p_payload jsonb
)
RETURNS text
LANGUAGE sql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT encode(
    sha256(
      convert_to(
        jsonb_build_object('operation', p_operation, 'payload', p_payload)::text,
        'UTF8'
      )
    ),
    'hex'
  )
$function$;

CREATE OR REPLACE FUNCTION public.kf_component_transition_allowed_internal(
  p_from_status text,
  p_to_status text
)
RETURNS boolean
LANGUAGE sql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT CASE p_from_status
    WHEN 'draft' THEN p_to_status = ANY(ARRAY['in_review', 'blocked', 'archived'])
    WHEN 'in_review' THEN p_to_status = ANY(ARRAY['approved', 'rejected', 'blocked', 'archived'])
    WHEN 'approved' THEN p_to_status = ANY(ARRAY['suspended', 'superseded', 'blocked', 'archived'])
    WHEN 'rejected' THEN p_to_status = 'archived'
    WHEN 'superseded' THEN p_to_status = 'archived'
    WHEN 'suspended' THEN p_to_status = ANY(ARRAY['in_review', 'blocked', 'archived'])
    WHEN 'blocked' THEN p_to_status = 'archived'
    WHEN 'archived' THEN false
    ELSE false
  END
$function$;

REVOKE ALL ON FUNCTION
  public.kf_component_write_assert_object_internal(jsonb, text[], text[], text),
  public.kf_component_write_text_internal(jsonb, text, boolean),
  public.kf_component_write_uuid_internal(jsonb, text),
  public.kf_component_write_timestamp_internal(jsonb, text),
  public.kf_component_write_text_array_internal(jsonb, text, text[]),
  public.kf_component_write_uuid_array_internal(jsonb, text),
  public.kf_component_write_fingerprint_internal(text, jsonb),
  public.kf_component_transition_allowed_internal(text, text)
FROM PUBLIC, anon, authenticated, service_role;

-- ---------------------------------------------------------------------------
-- 3. Create complete aggregate
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_create_pedagogical_component_aggregate(
  p_command_id uuid,
  p_payload jsonb
)
RETURNS TABLE (
  command_id uuid,
  operation text,
  component_id uuid,
  component_version_id uuid,
  replayed boolean,
  committed_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_operation CONSTANT text := 'create_component_aggregate';
  v_component jsonb;
  v_version jsonb;
  v_evidence jsonb;
  v_component_id uuid;
  v_version_id uuid;
  v_fingerprint text;
  v_receipt public.kf_component_write_receipts%ROWTYPE;
  v_evidence_ids uuid[];
  v_declared_evidence_ids uuid[];
  v_curriculum_ids uuid[];
  v_component_status text;
  v_version_status text;
  v_created_at timestamptz;
  v_updated_at timestamptz;
  v_approved_at timestamptz;
  v_committed_at timestamptz;
BEGIN
  IF p_command_id IS NULL THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'commandId is required';
  END IF;

  PERFORM public.kf_component_write_assert_object_internal(
    p_payload,
    ARRAY['component', 'evidenceOrigins', 'initialVersion'],
    ARRAY['component', 'evidenceOrigins', 'initialVersion'],
    'createComponentAggregate payload'
  );

  v_component := p_payload -> 'component';
  v_version := p_payload -> 'initialVersion';
  v_evidence := p_payload -> 'evidenceOrigins';

  PERFORM public.kf_component_write_assert_object_internal(
    v_component,
    ARRAY[
      'canonicalKey', 'componentType', 'createdAt', 'currentVersionId', 'grades',
      'id', 'schoolComponent', 'status', 'title', 'updatedAt', 'version'
    ],
    ARRAY[
      'canonicalKey', 'componentType', 'createdAt', 'currentVersionId', 'grades',
      'id', 'schoolComponent', 'status', 'title', 'updatedAt', 'version'
    ],
    'component'
  );

  PERFORM public.kf_component_write_assert_object_internal(
    v_version,
    ARRAY[
      'componentId', 'curriculumNodeIds', 'id', 'keywords', 'sourceEvidenceIds',
      'status', 'summary', 'version'
    ],
    ARRAY[
      'approvedAt', 'componentId', 'curriculumNodeIds', 'id', 'keywords',
      'sourceEvidenceIds', 'status', 'summary', 'supersedesVersion', 'version'
    ],
    'initialVersion'
  );

  IF v_evidence IS NULL OR jsonb_typeof(v_evidence) <> 'array' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'evidenceOrigins must be a JSON array';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM jsonb_array_elements(v_evidence) AS evidence(value)
    WHERE jsonb_typeof(evidence.value) <> 'object'
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'evidenceOrigins must contain only objects';
  END IF;

  PERFORM public.kf_component_write_assert_object_internal(
    evidence.value,
    ARRAY[
      'componentVersionId', 'contribution', 'id', 'recordedAt', 'sourceId',
      'sourceSegmentId', 'sourceVersionId', 'version'
    ],
    ARRAY[
      'componentVersionId', 'contribution', 'id', 'recordedAt', 'sourceId',
      'sourceSegmentId', 'sourceVersionId', 'version'
    ],
    'evidenceOrigin'
  )
  FROM jsonb_array_elements(v_evidence) AS evidence(value);

  v_component_id := public.kf_component_write_uuid_internal(v_component -> 'id', 'component.id');
  v_version_id := public.kf_component_write_uuid_internal(v_version -> 'id', 'initialVersion.id');

  IF public.kf_component_write_uuid_internal(
    v_component -> 'currentVersionId', 'component.currentVersionId'
  ) <> v_version_id THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'component.currentVersionId must equal initialVersion.id';
  END IF;

  IF public.kf_component_write_uuid_internal(
    v_version -> 'componentId', 'initialVersion.componentId'
  ) <> v_component_id THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'initialVersion.componentId must equal component.id';
  END IF;

  v_component_status := public.kf_component_write_text_internal(
    v_component -> 'status', 'component.status'
  );
  v_version_status := public.kf_component_write_text_internal(
    v_version -> 'status', 'initialVersion.status'
  );

  IF v_component_status <> v_version_status THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'component and initialVersion statuses must match';
  END IF;

  IF NOT (v_component_status = ANY(ARRAY[
    'draft', 'in_review', 'approved', 'rejected', 'superseded', 'suspended',
    'blocked', 'archived'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'component.status is unsupported';
  END IF;

  PERFORM public.kf_component_write_text_internal(v_component -> 'version', 'component.version');
  PERFORM public.kf_component_write_text_internal(
    v_component -> 'canonicalKey', 'component.canonicalKey'
  );
  PERFORM public.kf_component_write_text_internal(v_component -> 'title', 'component.title');
  IF NOT (
    public.kf_component_write_text_internal(
      v_component -> 'componentType', 'component.componentType'
    ) = ANY(ARRAY[
      'concept', 'explanation', 'context', 'methodology', 'activity_pattern',
      'assessment_pattern', 'inclusion_strategy'
    ])
  ) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'component.componentType is unsupported';
  END IF;
  PERFORM public.kf_component_write_text_internal(
    v_component -> 'schoolComponent', 'component.schoolComponent'
  );
  PERFORM public.kf_component_write_text_array_internal(
    v_component -> 'grades',
    'component.grades',
    ARRAY['6', '7', '8', '9', '1_em', '2_em', '3_em']
  );

  v_created_at := public.kf_component_write_timestamp_internal(
    v_component -> 'createdAt', 'component.createdAt'
  );
  v_updated_at := public.kf_component_write_timestamp_internal(
    v_component -> 'updatedAt', 'component.updatedAt'
  );

  PERFORM public.kf_component_write_text_internal(v_version -> 'version', 'initialVersion.version');
  PERFORM public.kf_component_write_text_internal(
    v_version -> 'summary', 'initialVersion.summary', true
  );
  PERFORM public.kf_component_write_text_array_internal(
    v_version -> 'keywords', 'initialVersion.keywords'
  );
  v_declared_evidence_ids := public.kf_component_write_uuid_array_internal(
    v_version -> 'sourceEvidenceIds', 'initialVersion.sourceEvidenceIds'
  );
  v_curriculum_ids := public.kf_component_write_uuid_array_internal(
    v_version -> 'curriculumNodeIds', 'initialVersion.curriculumNodeIds'
  );

  IF v_version ? 'supersedesVersion' THEN
    PERFORM public.kf_component_write_text_internal(
      v_version -> 'supersedesVersion', 'initialVersion.supersedesVersion'
    );
  END IF;

  IF v_version ? 'approvedAt' THEN
    v_approved_at := public.kf_component_write_timestamp_internal(
      v_version -> 'approvedAt', 'initialVersion.approvedAt'
    );
  END IF;

  SELECT coalesce(
    array_agg(
      public.kf_component_write_uuid_internal(evidence.value -> 'id', 'evidenceOrigin.id')
      ORDER BY public.kf_component_write_uuid_internal(evidence.value -> 'id', 'evidenceOrigin.id')
    ),
    '{}'::uuid[]
  )
  INTO v_evidence_ids
  FROM jsonb_array_elements(v_evidence) AS evidence(value);

  IF cardinality(v_evidence_ids) <> (
    SELECT count(DISTINCT item.value) FROM unnest(v_evidence_ids) AS item(value)
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'evidenceOrigins must not contain duplicate ids';
  END IF;

  IF (
    SELECT coalesce(array_agg(value ORDER BY value), '{}'::uuid[])
    FROM unnest(v_declared_evidence_ids) AS item(value)
  )
    IS DISTINCT FROM v_evidence_ids THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'initialVersion.sourceEvidenceIds must exactly match evidenceOrigins ids';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM jsonb_array_elements(v_evidence) AS evidence(value)
    WHERE public.kf_component_write_uuid_internal(
      evidence.value -> 'componentVersionId', 'evidenceOrigin.componentVersionId'
    ) <> v_version_id
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'every evidenceOrigin must reference initialVersion.id';
  END IF;

  PERFORM public.kf_component_write_text_internal(
    evidence.value -> 'version', 'evidenceOrigin.version'
  )
  FROM jsonb_array_elements(v_evidence) AS evidence(value);

  PERFORM public.kf_component_write_text_internal(
    evidence.value -> 'contribution', 'evidenceOrigin.contribution'
  )
  FROM jsonb_array_elements(v_evidence) AS evidence(value);

  IF EXISTS (
    SELECT 1
    FROM jsonb_array_elements(v_evidence) AS evidence(value)
    WHERE NOT (
      (evidence.value ->> 'contribution') = ANY(
        ARRAY['conceptual', 'curricular', 'methodological', 'contextual']
      )
    )
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'evidenceOrigin.contribution is unsupported';
  END IF;

  PERFORM public.kf_component_write_timestamp_internal(
    evidence.value -> 'recordedAt', 'evidenceOrigin.recordedAt'
  )
  FROM jsonb_array_elements(v_evidence) AS evidence(value);

  IF v_version_status = 'approved'
    AND (cardinality(v_evidence_ids) = 0 OR cardinality(v_curriculum_ids) = 0) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'an approved version requires evidence and curriculum links';
  END IF;

  IF v_version_status = 'approved' AND v_approved_at IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'an approved version requires approvedAt';
  END IF;

  IF v_version_status <> 'approved' AND v_approved_at IS NOT NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'approvedAt is valid only for an approved version';
  END IF;

  v_fingerprint := public.kf_component_write_fingerprint_internal(v_operation, p_payload);
  PERFORM pg_advisory_xact_lock(hashtextextended(p_command_id::text, 0));

  SELECT * INTO v_receipt
  FROM public.kf_component_write_receipts AS receipts
  WHERE receipts.command_id = p_command_id;

  IF FOUND THEN
    IF v_receipt.operation <> v_operation OR v_receipt.payload_fingerprint <> v_fingerprint THEN
      RAISE EXCEPTION USING
        ERRCODE = 'PT409',
        MESSAGE = 'commandId was already used with a different command payload';
    END IF;

    RETURN QUERY SELECT
      v_receipt.command_id,
      v_receipt.operation,
      v_receipt.component_id,
      v_receipt.component_version_id,
      true,
      v_receipt.committed_at;
    RETURN;
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.kf_pedagogical_components
    WHERE id = v_component_id
      OR canonical_key = (v_component ->> 'canonicalKey')
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = 'PT409',
      MESSAGE = 'component id or canonical key already exists';
  END IF;

  IF EXISTS (SELECT 1 FROM public.kf_component_versions WHERE id = v_version_id) THEN
    RAISE EXCEPTION USING
      ERRCODE = 'PT409',
      MESSAGE = 'component version id already exists';
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.kf_component_source_evidence
    WHERE id = ANY(v_evidence_ids)
  ) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'evidenceOrigin id already exists';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM jsonb_array_elements(v_evidence) AS evidence(value)
    LEFT JOIN public.kf_source_segments AS segments
      ON segments.id = public.kf_component_write_uuid_internal(
        evidence.value -> 'sourceSegmentId', 'evidenceOrigin.sourceSegmentId'
      )
     AND segments.source_version_id = public.kf_component_write_uuid_internal(
        evidence.value -> 'sourceVersionId', 'evidenceOrigin.sourceVersionId'
      )
    LEFT JOIN public.kf_source_versions AS source_versions
      ON source_versions.id = public.kf_component_write_uuid_internal(
        evidence.value -> 'sourceVersionId', 'evidenceOrigin.sourceVersionId'
      )
     AND source_versions.source_id = public.kf_component_write_uuid_internal(
        evidence.value -> 'sourceId', 'evidenceOrigin.sourceId'
      )
    WHERE segments.id IS NULL OR source_versions.id IS NULL
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'evidenceOrigins contains an incoherent source chain';
  END IF;

  IF (
    SELECT count(*) FROM public.kf_curriculum_nodes WHERE id = ANY(v_curriculum_ids)
  ) <> cardinality(v_curriculum_ids) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'initialVersion.curriculumNodeIds contains an unknown node';
  END IF;

  INSERT INTO public.kf_pedagogical_components (
    id, version, canonical_key, title, component_type, school_component, grades,
    status, current_version_id, created_at, updated_at
  ) VALUES (
    v_component_id,
    v_component ->> 'version',
    v_component ->> 'canonicalKey',
    v_component ->> 'title',
    v_component ->> 'componentType',
    v_component ->> 'schoolComponent',
    public.kf_component_write_text_array_internal(v_component -> 'grades', 'component.grades'),
    v_component_status,
    v_version_id,
    v_created_at,
    v_updated_at
  );

  INSERT INTO public.kf_component_versions (
    id, version, component_id, summary, keywords, supersedes_version, approved_at, status
  ) VALUES (
    v_version_id,
    v_version ->> 'version',
    v_component_id,
    v_version ->> 'summary',
    public.kf_component_write_text_array_internal(v_version -> 'keywords', 'initialVersion.keywords'),
    CASE WHEN v_version ? 'supersedesVersion' THEN v_version ->> 'supersedesVersion' END,
    v_approved_at,
    v_version_status
  );

  INSERT INTO public.kf_component_source_evidence (
    id, version, component_version_id, source_id, source_version_id,
    source_segment_id, contribution, recorded_at
  )
  SELECT
    public.kf_component_write_uuid_internal(evidence.value -> 'id', 'evidenceOrigin.id'),
    evidence.value ->> 'version',
    v_version_id,
    public.kf_component_write_uuid_internal(evidence.value -> 'sourceId', 'evidenceOrigin.sourceId'),
    public.kf_component_write_uuid_internal(
      evidence.value -> 'sourceVersionId', 'evidenceOrigin.sourceVersionId'
    ),
    public.kf_component_write_uuid_internal(
      evidence.value -> 'sourceSegmentId', 'evidenceOrigin.sourceSegmentId'
    ),
    evidence.value ->> 'contribution',
    public.kf_component_write_timestamp_internal(
      evidence.value -> 'recordedAt', 'evidenceOrigin.recordedAt'
    )
  FROM jsonb_array_elements(v_evidence) AS evidence(value);

  INSERT INTO public.kf_component_curriculum_links (component_version_id, curriculum_node_id)
  SELECT v_version_id, item.value
  FROM unnest(v_curriculum_ids) AS item(value);

  INSERT INTO public.kf_component_write_receipts (
    command_id, operation, payload_fingerprint, component_id, component_version_id
  ) VALUES (
    p_command_id, v_operation, v_fingerprint, v_component_id, v_version_id
  )
  RETURNING kf_component_write_receipts.committed_at INTO v_committed_at;

  RETURN QUERY SELECT
    p_command_id, v_operation, v_component_id, v_version_id, false, v_committed_at;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 4. Append immutable version snapshot
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_append_pedagogical_component_version(
  p_command_id uuid,
  p_payload jsonb
)
RETURNS TABLE (
  command_id uuid,
  operation text,
  component_id uuid,
  component_version_id uuid,
  replayed boolean,
  committed_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_operation CONSTANT text := 'append_component_version';
  v_version jsonb;
  v_evidence jsonb;
  v_component_id uuid;
  v_version_id uuid;
  v_expected_current_version_id uuid;
  v_current_version_id uuid;
  v_current_version_tag text;
  v_fingerprint text;
  v_receipt public.kf_component_write_receipts%ROWTYPE;
  v_evidence_ids uuid[];
  v_declared_evidence_ids uuid[];
  v_curriculum_ids uuid[];
  v_version_status text;
  v_approved_at timestamptz;
  v_committed_at timestamptz;
BEGIN
  IF p_command_id IS NULL THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'commandId is required';
  END IF;

  PERFORM public.kf_component_write_assert_object_internal(
    p_payload,
    ARRAY['evidenceOrigins', 'expectedCurrentVersionId', 'version'],
    ARRAY['evidenceOrigins', 'expectedCurrentVersionId', 'version'],
    'appendComponentVersion payload'
  );

  v_version := p_payload -> 'version';
  v_evidence := p_payload -> 'evidenceOrigins';

  PERFORM public.kf_component_write_assert_object_internal(
    v_version,
    ARRAY[
      'componentId', 'curriculumNodeIds', 'id', 'keywords', 'sourceEvidenceIds',
      'status', 'summary', 'version'
    ],
    ARRAY[
      'approvedAt', 'componentId', 'curriculumNodeIds', 'id', 'keywords',
      'sourceEvidenceIds', 'status', 'summary', 'supersedesVersion', 'version'
    ],
    'version'
  );

  IF v_evidence IS NULL OR jsonb_typeof(v_evidence) <> 'array' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'evidenceOrigins must be a JSON array';
  END IF;

  PERFORM public.kf_component_write_assert_object_internal(
    evidence.value,
    ARRAY[
      'componentVersionId', 'contribution', 'id', 'recordedAt', 'sourceId',
      'sourceSegmentId', 'sourceVersionId', 'version'
    ],
    ARRAY[
      'componentVersionId', 'contribution', 'id', 'recordedAt', 'sourceId',
      'sourceSegmentId', 'sourceVersionId', 'version'
    ],
    'evidenceOrigin'
  )
  FROM jsonb_array_elements(v_evidence) AS evidence(value);

  v_component_id := public.kf_component_write_uuid_internal(
    v_version -> 'componentId', 'version.componentId'
  );
  v_version_id := public.kf_component_write_uuid_internal(v_version -> 'id', 'version.id');
  v_expected_current_version_id := public.kf_component_write_uuid_internal(
    p_payload -> 'expectedCurrentVersionId', 'expectedCurrentVersionId'
  );
  v_version_status := public.kf_component_write_text_internal(v_version -> 'status', 'version.status');

  IF NOT (v_version_status = ANY(ARRAY[
    'draft', 'in_review', 'approved', 'rejected', 'superseded', 'suspended',
    'blocked', 'archived'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'version.status is unsupported';
  END IF;

  PERFORM public.kf_component_write_text_internal(v_version -> 'version', 'version.version');
  PERFORM public.kf_component_write_text_internal(v_version -> 'summary', 'version.summary', true);
  PERFORM public.kf_component_write_text_array_internal(v_version -> 'keywords', 'version.keywords');
  v_declared_evidence_ids := public.kf_component_write_uuid_array_internal(
    v_version -> 'sourceEvidenceIds', 'version.sourceEvidenceIds'
  );
  v_curriculum_ids := public.kf_component_write_uuid_array_internal(
    v_version -> 'curriculumNodeIds', 'version.curriculumNodeIds'
  );

  IF v_version ? 'supersedesVersion' THEN
    PERFORM public.kf_component_write_text_internal(
      v_version -> 'supersedesVersion', 'version.supersedesVersion'
    );
  END IF;

  IF v_version ? 'approvedAt' THEN
    v_approved_at := public.kf_component_write_timestamp_internal(
      v_version -> 'approvedAt', 'version.approvedAt'
    );
  END IF;

  SELECT coalesce(
    array_agg(
      public.kf_component_write_uuid_internal(evidence.value -> 'id', 'evidenceOrigin.id')
      ORDER BY public.kf_component_write_uuid_internal(evidence.value -> 'id', 'evidenceOrigin.id')
    ),
    '{}'::uuid[]
  )
  INTO v_evidence_ids
  FROM jsonb_array_elements(v_evidence) AS evidence(value);

  IF cardinality(v_evidence_ids) <> (
    SELECT count(DISTINCT item.value) FROM unnest(v_evidence_ids) AS item(value)
  ) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'evidenceOrigins has duplicate ids';
  END IF;

  IF (
    SELECT coalesce(array_agg(value ORDER BY value), '{}'::uuid[])
    FROM unnest(v_declared_evidence_ids) AS item(value)
  )
    IS DISTINCT FROM v_evidence_ids THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'version.sourceEvidenceIds must exactly match evidenceOrigins ids';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM jsonb_array_elements(v_evidence) AS evidence(value)
    WHERE public.kf_component_write_uuid_internal(
      evidence.value -> 'componentVersionId', 'evidenceOrigin.componentVersionId'
    ) <> v_version_id
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'every evidenceOrigin must reference version.id';
  END IF;

  PERFORM public.kf_component_write_text_internal(evidence.value -> 'version', 'evidenceOrigin.version')
  FROM jsonb_array_elements(v_evidence) AS evidence(value);
  PERFORM public.kf_component_write_text_internal(
    evidence.value -> 'contribution', 'evidenceOrigin.contribution'
  )
  FROM jsonb_array_elements(v_evidence) AS evidence(value);

  IF EXISTS (
    SELECT 1
    FROM jsonb_array_elements(v_evidence) AS evidence(value)
    WHERE NOT (
      (evidence.value ->> 'contribution') = ANY(
        ARRAY['conceptual', 'curricular', 'methodological', 'contextual']
      )
    )
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'evidenceOrigin.contribution is unsupported';
  END IF;
  PERFORM public.kf_component_write_timestamp_internal(
    evidence.value -> 'recordedAt', 'evidenceOrigin.recordedAt'
  )
  FROM jsonb_array_elements(v_evidence) AS evidence(value);

  IF v_version_status = 'approved'
    AND (cardinality(v_evidence_ids) = 0 OR cardinality(v_curriculum_ids) = 0) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'an approved version requires evidence and curriculum links';
  END IF;

  IF v_version_status = 'approved' AND v_approved_at IS NULL THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'an approved version requires approvedAt';
  END IF;

  IF v_version_status <> 'approved' AND v_approved_at IS NOT NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'approvedAt is valid only for an approved version';
  END IF;

  v_fingerprint := public.kf_component_write_fingerprint_internal(v_operation, p_payload);
  PERFORM pg_advisory_xact_lock(hashtextextended(p_command_id::text, 0));

  SELECT * INTO v_receipt
  FROM public.kf_component_write_receipts AS receipts
  WHERE receipts.command_id = p_command_id;

  IF FOUND THEN
    IF v_receipt.operation <> v_operation OR v_receipt.payload_fingerprint <> v_fingerprint THEN
      RAISE EXCEPTION USING
        ERRCODE = 'PT409',
        MESSAGE = 'commandId was already used with a different command payload';
    END IF;
    RETURN QUERY SELECT
      v_receipt.command_id, v_receipt.operation, v_receipt.component_id,
      v_receipt.component_version_id, true, v_receipt.committed_at;
    RETURN;
  END IF;

  SELECT components.current_version_id
  INTO v_current_version_id
  FROM public.kf_pedagogical_components AS components
  WHERE components.id = v_component_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'component was not found';
  END IF;

  IF v_current_version_id <> v_expected_current_version_id THEN
    RAISE EXCEPTION USING
      ERRCODE = 'PT409',
      MESSAGE = 'component current version does not match expectedCurrentVersionId';
  END IF;

  SELECT versions.version
  INTO v_current_version_tag
  FROM public.kf_component_versions AS versions
  WHERE versions.id = v_current_version_id
    AND versions.component_id = v_component_id;

  IF EXISTS (
    SELECT 1 FROM public.kf_component_versions AS versions
    WHERE versions.id = v_version_id
       OR (
         versions.component_id = v_component_id
         AND versions.version = v_version ->> 'version'
       )
  ) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'component version already exists';
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.kf_component_source_evidence
    WHERE id = ANY(v_evidence_ids)
  ) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'evidenceOrigin id already exists';
  END IF;

  IF (v_version ? 'supersedesVersion')
    AND (v_version ->> 'supersedesVersion') <> v_current_version_tag THEN
    RAISE EXCEPTION USING
      ERRCODE = 'PT409',
      MESSAGE = 'supersedesVersion does not identify the expected current version';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM jsonb_array_elements(v_evidence) AS evidence(value)
    LEFT JOIN public.kf_source_segments AS segments
      ON segments.id = public.kf_component_write_uuid_internal(
        evidence.value -> 'sourceSegmentId', 'evidenceOrigin.sourceSegmentId'
      )
     AND segments.source_version_id = public.kf_component_write_uuid_internal(
        evidence.value -> 'sourceVersionId', 'evidenceOrigin.sourceVersionId'
      )
    LEFT JOIN public.kf_source_versions AS source_versions
      ON source_versions.id = public.kf_component_write_uuid_internal(
        evidence.value -> 'sourceVersionId', 'evidenceOrigin.sourceVersionId'
      )
     AND source_versions.source_id = public.kf_component_write_uuid_internal(
        evidence.value -> 'sourceId', 'evidenceOrigin.sourceId'
      )
    WHERE segments.id IS NULL OR source_versions.id IS NULL
  ) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'evidenceOrigins has incoherent source chain';
  END IF;

  IF (
    SELECT count(*) FROM public.kf_curriculum_nodes WHERE id = ANY(v_curriculum_ids)
  ) <> cardinality(v_curriculum_ids) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'curriculumNodeIds has an unknown node';
  END IF;

  INSERT INTO public.kf_component_versions (
    id, version, component_id, summary, keywords, supersedes_version, approved_at, status
  ) VALUES (
    v_version_id,
    v_version ->> 'version',
    v_component_id,
    v_version ->> 'summary',
    public.kf_component_write_text_array_internal(v_version -> 'keywords', 'version.keywords'),
    CASE WHEN v_version ? 'supersedesVersion' THEN v_version ->> 'supersedesVersion' END,
    v_approved_at,
    v_version_status
  );

  INSERT INTO public.kf_component_source_evidence (
    id, version, component_version_id, source_id, source_version_id,
    source_segment_id, contribution, recorded_at
  )
  SELECT
    public.kf_component_write_uuid_internal(evidence.value -> 'id', 'evidenceOrigin.id'),
    evidence.value ->> 'version',
    v_version_id,
    public.kf_component_write_uuid_internal(evidence.value -> 'sourceId', 'evidenceOrigin.sourceId'),
    public.kf_component_write_uuid_internal(
      evidence.value -> 'sourceVersionId', 'evidenceOrigin.sourceVersionId'
    ),
    public.kf_component_write_uuid_internal(
      evidence.value -> 'sourceSegmentId', 'evidenceOrigin.sourceSegmentId'
    ),
    evidence.value ->> 'contribution',
    public.kf_component_write_timestamp_internal(
      evidence.value -> 'recordedAt', 'evidenceOrigin.recordedAt'
    )
  FROM jsonb_array_elements(v_evidence) AS evidence(value);

  INSERT INTO public.kf_component_curriculum_links (component_version_id, curriculum_node_id)
  SELECT v_version_id, item.value
  FROM unnest(v_curriculum_ids) AS item(value);

  INSERT INTO public.kf_component_write_receipts (
    command_id, operation, payload_fingerprint, component_id, component_version_id
  ) VALUES (
    p_command_id, v_operation, v_fingerprint, v_component_id, v_version_id
  )
  RETURNING kf_component_write_receipts.committed_at INTO v_committed_at;

  RETURN QUERY SELECT
    p_command_id, v_operation, v_component_id, v_version_id, false, v_committed_at;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 5. Transition version status
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_transition_pedagogical_component_version_status(
  p_command_id uuid,
  p_payload jsonb
)
RETURNS TABLE (
  command_id uuid,
  operation text,
  component_id uuid,
  component_version_id uuid,
  replayed boolean,
  committed_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_operation CONSTANT text := 'transition_component_version_status';
  v_component_id uuid;
  v_version_id uuid;
  v_current_version_id uuid;
  v_expected_status text;
  v_current_status text;
  v_to_status text;
  v_occurred_at timestamptz;
  v_fingerprint text;
  v_receipt public.kf_component_write_receipts%ROWTYPE;
  v_committed_at timestamptz;
BEGIN
  IF p_command_id IS NULL THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'commandId is required';
  END IF;

  PERFORM public.kf_component_write_assert_object_internal(
    p_payload,
    ARRAY['componentId', 'componentVersionId', 'expectedStatus', 'occurredAt', 'toStatus'],
    ARRAY['componentId', 'componentVersionId', 'expectedStatus', 'occurredAt', 'toStatus'],
    'transitionComponentVersionStatus payload'
  );

  v_component_id := public.kf_component_write_uuid_internal(
    p_payload -> 'componentId', 'componentId'
  );
  v_version_id := public.kf_component_write_uuid_internal(
    p_payload -> 'componentVersionId', 'componentVersionId'
  );
  v_expected_status := public.kf_component_write_text_internal(
    p_payload -> 'expectedStatus', 'expectedStatus'
  );
  v_to_status := public.kf_component_write_text_internal(p_payload -> 'toStatus', 'toStatus');
  v_occurred_at := public.kf_component_write_timestamp_internal(
    p_payload -> 'occurredAt', 'occurredAt'
  );

  IF NOT (v_expected_status = ANY(ARRAY[
    'draft', 'in_review', 'approved', 'rejected', 'superseded', 'suspended',
    'blocked', 'archived'
  ])) OR NOT (v_to_status = ANY(ARRAY[
    'draft', 'in_review', 'approved', 'rejected', 'superseded', 'suspended',
    'blocked', 'archived'
  ])) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'component status is unsupported';
  END IF;

  v_fingerprint := public.kf_component_write_fingerprint_internal(v_operation, p_payload);
  PERFORM pg_advisory_xact_lock(hashtextextended(p_command_id::text, 0));

  SELECT * INTO v_receipt
  FROM public.kf_component_write_receipts AS receipts
  WHERE receipts.command_id = p_command_id;

  IF FOUND THEN
    IF v_receipt.operation <> v_operation OR v_receipt.payload_fingerprint <> v_fingerprint THEN
      RAISE EXCEPTION USING
        ERRCODE = 'PT409',
        MESSAGE = 'commandId was already used with a different command payload';
    END IF;
    RETURN QUERY SELECT
      v_receipt.command_id, v_receipt.operation, v_receipt.component_id,
      v_receipt.component_version_id, true, v_receipt.committed_at;
    RETURN;
  END IF;

  SELECT components.current_version_id
  INTO v_current_version_id
  FROM public.kf_pedagogical_components AS components
  WHERE components.id = v_component_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'component was not found';
  END IF;

  SELECT versions.status
  INTO v_current_status
  FROM public.kf_component_versions AS versions
  WHERE versions.id = v_version_id
    AND versions.component_id = v_component_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'component version was not found';
  END IF;

  IF v_current_status <> v_expected_status THEN
    RAISE EXCEPTION USING
      ERRCODE = 'PT409',
      MESSAGE = 'component version status does not match expectedStatus';
  END IF;

  IF NOT public.kf_component_transition_allowed_internal(v_current_status, v_to_status) THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'component status transition is invalid';
  END IF;

  IF v_to_status = 'approved' AND (
    NOT EXISTS (
      SELECT 1 FROM public.kf_component_source_evidence AS evidence
      WHERE evidence.component_version_id = v_version_id
    )
    OR NOT EXISTS (
      SELECT 1 FROM public.kf_component_curriculum_links AS links
      WHERE links.component_version_id = v_version_id
    )
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'approval requires persisted evidence and curriculum links';
  END IF;

  UPDATE public.kf_component_versions
  SET
    status = v_to_status,
    approved_at = CASE
      WHEN v_to_status = 'approved' THEN coalesce(approved_at, v_occurred_at)
      ELSE approved_at
    END
  WHERE id = v_version_id;

  IF v_current_version_id = v_version_id THEN
    UPDATE public.kf_pedagogical_components
    SET status = v_to_status, updated_at = v_occurred_at
    WHERE id = v_component_id;
  END IF;

  INSERT INTO public.kf_component_write_receipts (
    command_id, operation, payload_fingerprint, component_id, component_version_id
  ) VALUES (
    p_command_id, v_operation, v_fingerprint, v_component_id, v_version_id
  )
  RETURNING kf_component_write_receipts.committed_at INTO v_committed_at;

  RETURN QUERY SELECT
    p_command_id, v_operation, v_component_id, v_version_id, false, v_committed_at;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 6. Promote approved version
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_promote_pedagogical_component_version(
  p_command_id uuid,
  p_payload jsonb
)
RETURNS TABLE (
  command_id uuid,
  operation text,
  component_id uuid,
  component_version_id uuid,
  replayed boolean,
  committed_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_operation CONSTANT text := 'promote_component_version';
  v_component_id uuid;
  v_target_version_id uuid;
  v_expected_current_version_id uuid;
  v_current_version_id uuid;
  v_expected_updated_at timestamptz;
  v_current_updated_at timestamptz;
  v_occurred_at timestamptz;
  v_target_status text;
  v_fingerprint text;
  v_receipt public.kf_component_write_receipts%ROWTYPE;
  v_committed_at timestamptz;
BEGIN
  IF p_command_id IS NULL THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'commandId is required';
  END IF;

  PERFORM public.kf_component_write_assert_object_internal(
    p_payload,
    ARRAY[
      'componentId', 'expectedComponentUpdatedAt', 'expectedCurrentVersionId',
      'occurredAt', 'targetVersionId'
    ],
    ARRAY[
      'componentId', 'expectedComponentUpdatedAt', 'expectedCurrentVersionId',
      'occurredAt', 'targetVersionId'
    ],
    'promoteComponentVersion payload'
  );

  v_component_id := public.kf_component_write_uuid_internal(
    p_payload -> 'componentId', 'componentId'
  );
  v_target_version_id := public.kf_component_write_uuid_internal(
    p_payload -> 'targetVersionId', 'targetVersionId'
  );
  v_expected_current_version_id := public.kf_component_write_uuid_internal(
    p_payload -> 'expectedCurrentVersionId', 'expectedCurrentVersionId'
  );
  v_expected_updated_at := public.kf_component_write_timestamp_internal(
    p_payload -> 'expectedComponentUpdatedAt', 'expectedComponentUpdatedAt'
  );
  v_occurred_at := public.kf_component_write_timestamp_internal(
    p_payload -> 'occurredAt', 'occurredAt'
  );

  v_fingerprint := public.kf_component_write_fingerprint_internal(v_operation, p_payload);
  PERFORM pg_advisory_xact_lock(hashtextextended(p_command_id::text, 0));

  SELECT * INTO v_receipt
  FROM public.kf_component_write_receipts AS receipts
  WHERE receipts.command_id = p_command_id;

  IF FOUND THEN
    IF v_receipt.operation <> v_operation OR v_receipt.payload_fingerprint <> v_fingerprint THEN
      RAISE EXCEPTION USING
        ERRCODE = 'PT409',
        MESSAGE = 'commandId was already used with a different command payload';
    END IF;
    RETURN QUERY SELECT
      v_receipt.command_id, v_receipt.operation, v_receipt.component_id,
      v_receipt.component_version_id, true, v_receipt.committed_at;
    RETURN;
  END IF;

  SELECT components.current_version_id, components.updated_at
  INTO v_current_version_id, v_current_updated_at
  FROM public.kf_pedagogical_components AS components
  WHERE components.id = v_component_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'component was not found';
  END IF;

  IF v_current_version_id <> v_expected_current_version_id
    OR v_current_updated_at <> v_expected_updated_at THEN
    RAISE EXCEPTION USING
      ERRCODE = 'PT409',
      MESSAGE = 'component state does not match promotion expectations';
  END IF;

  IF v_target_version_id = v_current_version_id THEN
    RAISE EXCEPTION USING
      ERRCODE = 'PT409',
      MESSAGE = 'target version is already the current version';
  END IF;

  SELECT versions.status
  INTO v_target_status
  FROM public.kf_component_versions AS versions
  WHERE versions.id = v_target_version_id
    AND versions.component_id = v_component_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'target component version was not found';
  END IF;

  IF v_target_status <> 'approved' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'target version must be approved';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.kf_component_source_evidence AS evidence
    WHERE evidence.component_version_id = v_target_version_id
  ) OR NOT EXISTS (
    SELECT 1 FROM public.kf_component_curriculum_links AS links
    WHERE links.component_version_id = v_target_version_id
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'target version requires evidence and curriculum links';
  END IF;

  UPDATE public.kf_pedagogical_components
  SET
    current_version_id = v_target_version_id,
    status = v_target_status,
    updated_at = v_occurred_at
  WHERE id = v_component_id;

  INSERT INTO public.kf_component_write_receipts (
    command_id, operation, payload_fingerprint, component_id, component_version_id
  ) VALUES (
    p_command_id, v_operation, v_fingerprint, v_component_id, v_target_version_id
  )
  RETURNING kf_component_write_receipts.committed_at INTO v_committed_at;

  RETURN QUERY SELECT
    p_command_id, v_operation, v_component_id, v_target_version_id, false, v_committed_at;
END;
$function$;

-- ---------------------------------------------------------------------------
-- 7. Ownership and least privilege
-- ---------------------------------------------------------------------------
ALTER TABLE public.kf_component_write_receipts OWNER TO postgres;

ALTER FUNCTION public.kf_component_write_assert_object_internal(jsonb, text[], text[], text)
  OWNER TO postgres;
ALTER FUNCTION public.kf_component_write_text_internal(jsonb, text, boolean)
  OWNER TO postgres;
ALTER FUNCTION public.kf_component_write_uuid_internal(jsonb, text)
  OWNER TO postgres;
ALTER FUNCTION public.kf_component_write_timestamp_internal(jsonb, text)
  OWNER TO postgres;
ALTER FUNCTION public.kf_component_write_text_array_internal(jsonb, text, text[])
  OWNER TO postgres;
ALTER FUNCTION public.kf_component_write_uuid_array_internal(jsonb, text)
  OWNER TO postgres;
ALTER FUNCTION public.kf_component_write_fingerprint_internal(text, jsonb)
  OWNER TO postgres;
ALTER FUNCTION public.kf_component_transition_allowed_internal(text, text)
  OWNER TO postgres;

ALTER FUNCTION public.kf_create_pedagogical_component_aggregate(uuid, jsonb)
  OWNER TO postgres;
ALTER FUNCTION public.kf_append_pedagogical_component_version(uuid, jsonb)
  OWNER TO postgres;
ALTER FUNCTION public.kf_transition_pedagogical_component_version_status(uuid, jsonb)
  OWNER TO postgres;
ALTER FUNCTION public.kf_promote_pedagogical_component_version(uuid, jsonb)
  OWNER TO postgres;

REVOKE ALL ON FUNCTION
  public.kf_create_pedagogical_component_aggregate(uuid, jsonb),
  public.kf_append_pedagogical_component_version(uuid, jsonb),
  public.kf_transition_pedagogical_component_version_status(uuid, jsonb),
  public.kf_promote_pedagogical_component_version(uuid, jsonb)
FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION
  public.kf_create_pedagogical_component_aggregate(uuid, jsonb),
  public.kf_append_pedagogical_component_version(uuid, jsonb),
  public.kf_transition_pedagogical_component_version_status(uuid, jsonb),
  public.kf_promote_pedagogical_component_version(uuid, jsonb)
TO service_role;

-- The service role may read the aggregate through the read adapter, but every
-- component write must now pass through one of the four transactional RPCs.
REVOKE INSERT, UPDATE ON TABLE
  public.kf_pedagogical_components,
  public.kf_component_versions,
  public.kf_component_source_evidence,
  public.kf_component_curriculum_links
FROM service_role;

COMMIT;
