-- =============================================================================
-- ProfePlan Knowledge Factory — Lote 3A
-- Schema, constraints, RLS e append-only foundation
-- Data: 2026-08-07
-- Scope: additive only. Does not apply itself to production.
-- =============================================================================

BEGIN;

-- -----------------------------------------------------------------------------
-- 0. Administrative helper
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_is_platform_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE id = auth.uid()
      AND role = 'admin'
  );
$$;

ALTER FUNCTION public.kf_is_platform_admin() OWNER TO postgres;
REVOKE ALL ON FUNCTION public.kf_is_platform_admin() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.kf_is_platform_admin() TO authenticated, service_role;

-- -----------------------------------------------------------------------------
-- 1. Sources and provenance
-- -----------------------------------------------------------------------------
CREATE TABLE public.kf_sources (
  id uuid PRIMARY KEY,
  version text NOT NULL,
  title text NOT NULL,
  source_type text NOT NULL,
  status text NOT NULL,
  license_category text NOT NULL,
  allowed_uses text[] NOT NULL,
  provenance_uri text NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,

  CONSTRAINT kf_sources_version_not_blank CHECK (btrim(version) <> ''),
  CONSTRAINT kf_sources_source_type_check CHECK (
    source_type IN ('curriculum', 'pnld', 'open_content', 'wrtech_owned', 'legal_reference')
  ),
  CONSTRAINT kf_sources_status_check CHECK (
    status IN ('draft', 'approved', 'blocked', 'archived')
  ),
  CONSTRAINT kf_sources_license_category_check CHECK (
    license_category IN ('owned', 'licensed', 'open', 'restricted', 'unknown')
  ),
  CONSTRAINT kf_sources_allowed_uses_check CHECK (
    allowed_uses <@ ARRAY['retrieval', 'generation', 'quotation', 'internal_review']::text[]
    AND array_position(allowed_uses, NULL) IS NULL
  )
);

CREATE TABLE public.kf_source_versions (
  id uuid PRIMARY KEY,
  version text NOT NULL,
  source_id uuid NOT NULL,
  checksum text NOT NULL,
  effective_at timestamptz NOT NULL,
  supersedes_version text NULL,

  CONSTRAINT kf_source_versions_version_not_blank CHECK (btrim(version) <> ''),
  CONSTRAINT kf_source_versions_checksum_not_blank CHECK (btrim(checksum) <> ''),
  CONSTRAINT kf_source_versions_source_fk
    FOREIGN KEY (source_id) REFERENCES public.kf_sources(id),
  CONSTRAINT kf_source_versions_source_version_unique UNIQUE (source_id, version),
  CONSTRAINT kf_source_versions_id_source_unique UNIQUE (id, source_id)
);

CREATE TABLE public.kf_source_permission_events (
  id uuid PRIMARY KEY,
  version text NOT NULL,
  source_id uuid NOT NULL,
  action text NOT NULL,
  use_type text NOT NULL,
  reason text NOT NULL,
  occurred_at timestamptz NOT NULL,

  CONSTRAINT kf_source_permission_events_version_not_blank CHECK (btrim(version) <> ''),
  CONSTRAINT kf_source_permission_events_action_check CHECK (
    action IN ('grant', 'revoke', 'block')
  ),
  CONSTRAINT kf_source_permission_events_use_type_check CHECK (
    use_type IN ('retrieval', 'generation', 'quotation', 'internal_review')
  ),
  CONSTRAINT kf_source_permission_events_source_fk
    FOREIGN KEY (source_id) REFERENCES public.kf_sources(id)
);

CREATE TABLE public.kf_source_segments (
  id uuid PRIMARY KEY,
  version text NOT NULL,
  source_version_id uuid NOT NULL,
  parent_segment_id uuid NULL,
  locator text NOT NULL,
  content_digest text NOT NULL,
  extracted_text text NOT NULL,
  created_at timestamptz NOT NULL,

  CONSTRAINT kf_source_segments_version_not_blank CHECK (btrim(version) <> ''),
  CONSTRAINT kf_source_segments_digest_not_blank CHECK (btrim(content_digest) <> ''),
  CONSTRAINT kf_source_segments_source_version_fk
    FOREIGN KEY (source_version_id) REFERENCES public.kf_source_versions(id),
  CONSTRAINT kf_source_segments_id_version_unique UNIQUE (id, source_version_id),
  CONSTRAINT kf_source_segments_parent_same_version_fk
    FOREIGN KEY (parent_segment_id, source_version_id)
    REFERENCES public.kf_source_segments(id, source_version_id)
    DEFERRABLE INITIALLY DEFERRED
);

-- -----------------------------------------------------------------------------
-- 2. Pedagogical components
-- -----------------------------------------------------------------------------
CREATE TABLE public.kf_pedagogical_components (
  id uuid PRIMARY KEY,
  version text NOT NULL,
  canonical_key text NOT NULL UNIQUE,
  title text NOT NULL,
  component_type text NOT NULL,
  school_component text NOT NULL,
  grades text[] NOT NULL,
  status text NOT NULL,
  current_version_id uuid NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,

  CONSTRAINT kf_pedagogical_components_version_not_blank CHECK (btrim(version) <> ''),
  CONSTRAINT kf_pedagogical_components_type_check CHECK (
    component_type IN (
      'concept',
      'explanation',
      'context',
      'methodology',
      'activity_pattern',
      'assessment_pattern',
      'inclusion_strategy'
    )
  ),
  CONSTRAINT kf_pedagogical_components_status_check CHECK (
    status IN (
      'draft',
      'in_review',
      'approved',
      'rejected',
      'superseded',
      'suspended',
      'blocked',
      'archived'
    )
  ),
  CONSTRAINT kf_pedagogical_components_grades_check CHECK (
    grades <@ ARRAY['6', '7', '8', '9', '1_em', '2_em', '3_em']::text[]
    AND cardinality(grades) > 0
    AND array_position(grades, NULL) IS NULL
  )
);

CREATE TABLE public.kf_component_versions (
  id uuid PRIMARY KEY,
  version text NOT NULL,
  component_id uuid NOT NULL,
  summary text NOT NULL,
  keywords text[] NOT NULL DEFAULT '{}'::text[],
  supersedes_version text NULL,
  approved_at timestamptz NULL,
  status text NOT NULL,

  CONSTRAINT kf_component_versions_version_not_blank CHECK (btrim(version) <> ''),
  CONSTRAINT kf_component_versions_component_fk
    FOREIGN KEY (component_id) REFERENCES public.kf_pedagogical_components(id),
  CONSTRAINT kf_component_versions_status_check CHECK (
    status IN (
      'draft',
      'in_review',
      'approved',
      'rejected',
      'superseded',
      'suspended',
      'blocked',
      'archived'
    )
  ),
  CONSTRAINT kf_component_versions_component_version_unique UNIQUE (component_id, version),
  CONSTRAINT kf_component_versions_id_component_unique UNIQUE (id, component_id)
);

ALTER TABLE public.kf_pedagogical_components
  ADD CONSTRAINT kf_pedagogical_components_current_version_fk
  FOREIGN KEY (current_version_id, id)
  REFERENCES public.kf_component_versions(id, component_id)
  DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE public.kf_component_source_evidence (
  id uuid PRIMARY KEY,
  version text NOT NULL,
  component_version_id uuid NOT NULL,
  source_id uuid NOT NULL,
  source_version_id uuid NOT NULL,
  source_segment_id uuid NOT NULL,
  contribution text NOT NULL,
  recorded_at timestamptz NOT NULL,

  CONSTRAINT kf_component_source_evidence_version_not_blank CHECK (btrim(version) <> ''),
  CONSTRAINT kf_component_source_evidence_contribution_check CHECK (
    contribution IN ('conceptual', 'curricular', 'methodological', 'contextual')
  ),
  CONSTRAINT kf_component_source_evidence_component_version_fk
    FOREIGN KEY (component_version_id) REFERENCES public.kf_component_versions(id),
  CONSTRAINT kf_component_source_evidence_source_fk
    FOREIGN KEY (source_id) REFERENCES public.kf_sources(id),
  CONSTRAINT kf_component_source_evidence_source_version_chain_fk
    FOREIGN KEY (source_version_id, source_id)
    REFERENCES public.kf_source_versions(id, source_id),
  CONSTRAINT kf_component_source_evidence_segment_chain_fk
    FOREIGN KEY (source_segment_id, source_version_id)
    REFERENCES public.kf_source_segments(id, source_version_id)
);

-- -----------------------------------------------------------------------------
-- 3. Curriculum
-- -----------------------------------------------------------------------------
CREATE TABLE public.kf_curriculum_packages (
  id uuid PRIMARY KEY,
  version text NOT NULL,
  state text NOT NULL,
  stage text NOT NULL,
  status text NOT NULL,
  title text NOT NULL,
  effective_from timestamptz NOT NULL,
  effective_until timestamptz NULL,

  CONSTRAINT kf_curriculum_packages_version_not_blank CHECK (btrim(version) <> ''),
  CONSTRAINT kf_curriculum_packages_state_check CHECK (state IN ('MG', 'RS')),
  CONSTRAINT kf_curriculum_packages_stage_check CHECK (
    stage IN ('fundamental_ii', 'ensino_medio')
  ),
  CONSTRAINT kf_curriculum_packages_status_check CHECK (
    status IN ('draft', 'active', 'retired', 'blocked')
  ),
  CONSTRAINT kf_curriculum_packages_rs_not_active CHECK (
    NOT (state = 'RS' AND status = 'active')
  ),
  CONSTRAINT kf_curriculum_packages_effective_window_check CHECK (
    effective_until IS NULL OR effective_until >= effective_from
  )
);

CREATE UNIQUE INDEX kf_curriculum_packages_one_active_per_state_stage_idx
  ON public.kf_curriculum_packages (state, stage)
  WHERE status = 'active';

CREATE TABLE public.kf_curriculum_package_sources (
  curriculum_package_id uuid NOT NULL,
  source_version_id uuid NOT NULL,

  CONSTRAINT kf_curriculum_package_sources_pk
    PRIMARY KEY (curriculum_package_id, source_version_id),
  CONSTRAINT kf_curriculum_package_sources_package_fk
    FOREIGN KEY (curriculum_package_id) REFERENCES public.kf_curriculum_packages(id),
  CONSTRAINT kf_curriculum_package_sources_source_version_fk
    FOREIGN KEY (source_version_id) REFERENCES public.kf_source_versions(id)
);

CREATE TABLE public.kf_curriculum_nodes (
  id uuid PRIMARY KEY,
  version text NOT NULL,
  curriculum_package_id uuid NOT NULL,
  node_type text NOT NULL,
  code text NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  component text NOT NULL,
  grades text[] NOT NULL,

  CONSTRAINT kf_curriculum_nodes_version_not_blank CHECK (btrim(version) <> ''),
  CONSTRAINT kf_curriculum_nodes_node_type_check CHECK (
    node_type IN ('competency', 'skill', 'knowledge_object', 'learning_expectation')
  ),
  CONSTRAINT kf_curriculum_nodes_grades_check CHECK (
    grades <@ ARRAY['6', '7', '8', '9', '1_em', '2_em', '3_em']::text[]
    AND cardinality(grades) > 0
    AND array_position(grades, NULL) IS NULL
  ),
  CONSTRAINT kf_curriculum_nodes_package_fk
    FOREIGN KEY (curriculum_package_id) REFERENCES public.kf_curriculum_packages(id),
  CONSTRAINT kf_curriculum_nodes_code_version_unique
    UNIQUE (curriculum_package_id, code, version),
  CONSTRAINT kf_curriculum_nodes_id_package_unique
    UNIQUE (id, curriculum_package_id)
);

CREATE TABLE public.kf_curriculum_links (
  id uuid PRIMARY KEY,
  version text NOT NULL,
  curriculum_package_id uuid NOT NULL,
  from_node_id uuid NOT NULL,
  to_node_id uuid NOT NULL,
  relation text NOT NULL,

  CONSTRAINT kf_curriculum_links_version_not_blank CHECK (btrim(version) <> ''),
  CONSTRAINT kf_curriculum_links_relation_check CHECK (
    relation IN ('contains', 'progresses_to', 'equivalent_to', 'supports')
  ),
  CONSTRAINT kf_curriculum_links_package_fk
    FOREIGN KEY (curriculum_package_id) REFERENCES public.kf_curriculum_packages(id),
  CONSTRAINT kf_curriculum_links_from_node_package_fk
    FOREIGN KEY (from_node_id, curriculum_package_id)
    REFERENCES public.kf_curriculum_nodes(id, curriculum_package_id),
  CONSTRAINT kf_curriculum_links_to_node_package_fk
    FOREIGN KEY (to_node_id, curriculum_package_id)
    REFERENCES public.kf_curriculum_nodes(id, curriculum_package_id)
);

CREATE TABLE public.kf_component_curriculum_links (
  component_version_id uuid NOT NULL,
  curriculum_node_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT kf_component_curriculum_links_pk
    PRIMARY KEY (component_version_id, curriculum_node_id),
  CONSTRAINT kf_component_curriculum_links_component_version_fk
    FOREIGN KEY (component_version_id) REFERENCES public.kf_component_versions(id),
  CONSTRAINT kf_component_curriculum_links_curriculum_node_fk
    FOREIGN KEY (curriculum_node_id) REFERENCES public.kf_curriculum_nodes(id)
);

-- -----------------------------------------------------------------------------
-- 4. Pedagogical Production Orders
-- -----------------------------------------------------------------------------
CREATE TABLE public.kf_production_orders (
  id uuid PRIMARY KEY,
  version text NOT NULL,
  requester_id uuid NOT NULL,
  agent_profile_id uuid NOT NULL,
  curriculum_package_id uuid NOT NULL,
  product_type text NOT NULL,
  theme text NOT NULL,
  duration_minutes integer NULL,
  status text NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL,

  CONSTRAINT kf_production_orders_version_not_blank CHECK (btrim(version) <> ''),
  CONSTRAINT kf_production_orders_requester_fk
    FOREIGN KEY (requester_id) REFERENCES auth.users(id),
  CONSTRAINT kf_production_orders_curriculum_package_fk
    FOREIGN KEY (curriculum_package_id) REFERENCES public.kf_curriculum_packages(id),
  CONSTRAINT kf_production_orders_product_type_check CHECK (
    product_type IN (
      'lesson_plan',
      'didactic_text',
      'reflective_activity',
      'formative_assessment'
    )
  ),
  CONSTRAINT kf_production_orders_status_check CHECK (
    status IN (
      'requested',
      'scoped',
      'retrieving',
      'assembling',
      'validating',
      'ready',
      'insufficient',
      'blocked',
      'failed'
    )
  ),
  CONSTRAINT kf_production_orders_duration_check CHECK (
    duration_minutes IS NULL OR duration_minutes > 0
  )
);

CREATE TABLE public.kf_production_order_events (
  id uuid PRIMARY KEY,
  version text NOT NULL,
  opp_id uuid NOT NULL,
  event_type text NOT NULL,
  from_status text NULL,
  to_status text NOT NULL,
  reason text NULL,
  occurred_at timestamptz NOT NULL,

  CONSTRAINT kf_production_order_events_version_not_blank CHECK (btrim(version) <> ''),
  CONSTRAINT kf_production_order_events_opp_fk
    FOREIGN KEY (opp_id) REFERENCES public.kf_production_orders(id),
  CONSTRAINT kf_production_order_events_event_type_check CHECK (
    event_type IN (
      'created',
      'scope_resolved',
      'retrieval_started',
      'context_assembled',
      'validation_started',
      'approved',
      'insufficiency_detected',
      'blocked',
      'failed'
    )
  ),
  CONSTRAINT kf_production_order_events_from_status_check CHECK (
    from_status IS NULL
    OR from_status IN (
      'requested',
      'scoped',
      'retrieving',
      'assembling',
      'validating',
      'ready',
      'insufficient',
      'blocked',
      'failed'
    )
  ),
  CONSTRAINT kf_production_order_events_to_status_check CHECK (
    to_status IN (
      'requested',
      'scoped',
      'retrieving',
      'assembling',
      'validating',
      'ready',
      'insufficient',
      'blocked',
      'failed'
    )
  )
);

-- -----------------------------------------------------------------------------
-- 5. Audit
-- -----------------------------------------------------------------------------
CREATE TABLE public.kf_audit_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type text NOT NULL,
  aggregate_type text NOT NULL,
  aggregate_id uuid NOT NULL,
  occurred_at timestamptz NOT NULL,
  actor_id uuid NULL,
  actor_role text NULL,
  correlation_id uuid NULL,
  outcome text NOT NULL DEFAULT 'recorded',
  reason text NULL,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT kf_audit_events_event_type_not_blank CHECK (btrim(event_type) <> ''),
  CONSTRAINT kf_audit_events_aggregate_type_not_blank CHECK (btrim(aggregate_type) <> ''),
  CONSTRAINT kf_audit_events_outcome_not_blank CHECK (btrim(outcome) <> ''),
  CONSTRAINT kf_audit_events_metadata_object_check CHECK (jsonb_typeof(metadata) = 'object')
);

-- -----------------------------------------------------------------------------
-- 6. Operational indexes
-- -----------------------------------------------------------------------------
CREATE INDEX kf_sources_status_idx
  ON public.kf_sources (status);

CREATE INDEX kf_source_versions_source_idx
  ON public.kf_source_versions (source_id);

CREATE INDEX kf_source_permission_events_source_idx
  ON public.kf_source_permission_events (source_id, occurred_at);

CREATE INDEX kf_source_segments_source_version_idx
  ON public.kf_source_segments (source_version_id);

CREATE INDEX kf_pedagogical_components_status_idx
  ON public.kf_pedagogical_components (status);

CREATE INDEX kf_component_versions_component_idx
  ON public.kf_component_versions (component_id);

CREATE INDEX kf_component_versions_status_idx
  ON public.kf_component_versions (status);

CREATE INDEX kf_component_source_evidence_component_version_idx
  ON public.kf_component_source_evidence (component_version_id);

CREATE INDEX kf_component_source_evidence_source_version_idx
  ON public.kf_component_source_evidence (source_version_id);

CREATE INDEX kf_curriculum_packages_state_stage_status_idx
  ON public.kf_curriculum_packages (state, stage, status);

CREATE INDEX kf_curriculum_nodes_package_idx
  ON public.kf_curriculum_nodes (curriculum_package_id);

CREATE INDEX kf_curriculum_links_package_idx
  ON public.kf_curriculum_links (curriculum_package_id);

CREATE INDEX kf_production_orders_requester_idx
  ON public.kf_production_orders (requester_id, created_at);

CREATE INDEX kf_production_orders_status_idx
  ON public.kf_production_orders (status);

CREATE INDEX kf_production_order_events_opp_idx
  ON public.kf_production_order_events (opp_id, occurred_at);

CREATE INDEX kf_audit_events_aggregate_idx
  ON public.kf_audit_events (aggregate_type, aggregate_id, occurred_at);

-- -----------------------------------------------------------------------------
-- 7. Append-only protection
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_reject_append_only_mutation()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  RAISE EXCEPTION
    'Knowledge Factory append-only table % does not allow %',
    TG_TABLE_NAME,
    TG_OP
    USING ERRCODE = '55000';
END;
$$;

REVOKE ALL ON FUNCTION public.kf_reject_append_only_mutation() FROM PUBLIC;

CREATE TRIGGER kf_source_permission_events_append_only
BEFORE UPDATE OR DELETE ON public.kf_source_permission_events
FOR EACH ROW
EXECUTE FUNCTION public.kf_reject_append_only_mutation();

CREATE TRIGGER kf_production_order_events_append_only
BEFORE UPDATE OR DELETE ON public.kf_production_order_events
FOR EACH ROW
EXECUTE FUNCTION public.kf_reject_append_only_mutation();

CREATE TRIGGER kf_audit_events_append_only
BEFORE UPDATE OR DELETE ON public.kf_audit_events
FOR EACH ROW
EXECUTE FUNCTION public.kf_reject_append_only_mutation();

-- -----------------------------------------------------------------------------
-- 8. RLS
-- -----------------------------------------------------------------------------
ALTER TABLE public.kf_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_source_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_source_permission_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_source_segments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_pedagogical_components ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_component_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_component_source_evidence ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_curriculum_packages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_curriculum_package_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_curriculum_nodes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_curriculum_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_component_curriculum_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_production_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_production_order_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_audit_events ENABLE ROW LEVEL SECURITY;

-- Revoke any broad defaults first.
REVOKE ALL ON TABLE public.kf_sources FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_source_versions FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_source_permission_events FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_source_segments FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_pedagogical_components FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_component_versions FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_component_source_evidence FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_curriculum_packages FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_curriculum_package_sources FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_curriculum_nodes FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_curriculum_links FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_component_curriculum_links FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_production_orders FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_production_order_events FROM anon, authenticated;
REVOKE ALL ON TABLE public.kf_audit_events FROM anon, authenticated;

-- service_role is the future backend adapter role. Domain authorization remains mandatory.
GRANT ALL ON TABLE public.kf_sources TO service_role;
GRANT ALL ON TABLE public.kf_source_versions TO service_role;
GRANT ALL ON TABLE public.kf_source_permission_events TO service_role;
GRANT ALL ON TABLE public.kf_source_segments TO service_role;
GRANT ALL ON TABLE public.kf_pedagogical_components TO service_role;
GRANT ALL ON TABLE public.kf_component_versions TO service_role;
GRANT ALL ON TABLE public.kf_component_source_evidence TO service_role;
GRANT ALL ON TABLE public.kf_curriculum_packages TO service_role;
GRANT ALL ON TABLE public.kf_curriculum_package_sources TO service_role;
GRANT ALL ON TABLE public.kf_curriculum_nodes TO service_role;
GRANT ALL ON TABLE public.kf_curriculum_links TO service_role;
GRANT ALL ON TABLE public.kf_component_curriculum_links TO service_role;
GRANT ALL ON TABLE public.kf_production_orders TO service_role;
GRANT ALL ON TABLE public.kf_production_order_events TO service_role;
GRANT ALL ON TABLE public.kf_audit_events TO service_role;

-- authenticated receives SELECT on corpus/audit only so admin-only RLS can evaluate.
-- Non-admin authenticated users see zero rows.
GRANT SELECT ON TABLE public.kf_sources TO authenticated;
GRANT SELECT ON TABLE public.kf_source_versions TO authenticated;
GRANT SELECT ON TABLE public.kf_source_permission_events TO authenticated;
GRANT SELECT ON TABLE public.kf_source_segments TO authenticated;
GRANT SELECT ON TABLE public.kf_pedagogical_components TO authenticated;
GRANT SELECT ON TABLE public.kf_component_versions TO authenticated;
GRANT SELECT ON TABLE public.kf_component_source_evidence TO authenticated;
GRANT SELECT ON TABLE public.kf_curriculum_packages TO authenticated;
GRANT SELECT ON TABLE public.kf_curriculum_package_sources TO authenticated;
GRANT SELECT ON TABLE public.kf_curriculum_nodes TO authenticated;
GRANT SELECT ON TABLE public.kf_curriculum_links TO authenticated;
GRANT SELECT ON TABLE public.kf_component_curriculum_links TO authenticated;
GRANT SELECT ON TABLE public.kf_audit_events TO authenticated;

-- OPP privileges for the MVP. No direct UPDATE/DELETE to end users.
GRANT SELECT, INSERT ON TABLE public.kf_production_orders TO authenticated;
GRANT SELECT ON TABLE public.kf_production_order_events TO authenticated;

-- Administrative read policies. No direct administrative write policies.
CREATE POLICY kf_sources_admin_select
  ON public.kf_sources
  FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_source_versions_admin_select
  ON public.kf_source_versions
  FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_source_permission_events_admin_select
  ON public.kf_source_permission_events
  FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_source_segments_admin_select
  ON public.kf_source_segments
  FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_pedagogical_components_admin_select
  ON public.kf_pedagogical_components
  FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_component_versions_admin_select
  ON public.kf_component_versions
  FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_component_source_evidence_admin_select
  ON public.kf_component_source_evidence
  FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_curriculum_packages_admin_select
  ON public.kf_curriculum_packages
  FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_curriculum_package_sources_admin_select
  ON public.kf_curriculum_package_sources
  FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_curriculum_nodes_admin_select
  ON public.kf_curriculum_nodes
  FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_curriculum_links_admin_select
  ON public.kf_curriculum_links
  FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_component_curriculum_links_admin_select
  ON public.kf_component_curriculum_links
  FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_audit_events_admin_select
  ON public.kf_audit_events
  FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

-- User-private production orders.
CREATE POLICY kf_production_orders_select_own
  ON public.kf_production_orders
  FOR SELECT TO authenticated
  USING (requester_id = auth.uid());

CREATE POLICY kf_production_orders_insert_own
  ON public.kf_production_orders
  FOR INSERT TO authenticated
  WITH CHECK (requester_id = auth.uid());

CREATE POLICY kf_production_order_events_select_own
  ON public.kf_production_order_events
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.kf_production_orders opp
      WHERE opp.id = kf_production_order_events.opp_id
        AND opp.requester_id = auth.uid()
    )
  );

COMMIT;
