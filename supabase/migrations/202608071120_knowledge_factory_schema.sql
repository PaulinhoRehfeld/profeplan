-- =============================================================================
-- Migration: ProfePlan Knowledge Factory - Lote 3A
-- Date: 2026-08-07
-- Scope: schema + constraints + RLS + append-only protection
-- IMPORTANT: additive only; does not apply or authorize production deployment.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 0. Helper: platform admin check without recursive RLS
-- ---------------------------------------------------------------------------
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
GRANT EXECUTE ON FUNCTION public.kf_is_platform_admin() TO authenticated;

-- ---------------------------------------------------------------------------
-- 1. Sources and provenance
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_sources (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL CHECK (btrim(version) <> ''),
  title text NOT NULL CHECK (btrim(title) <> ''),
  source_type text NOT NULL CHECK (
    source_type IN ('curriculum', 'pnld', 'open_content', 'wrtech_owned', 'legal_reference')
  ),
  status text NOT NULL CHECK (status IN ('draft', 'approved', 'blocked', 'archived')),
  license_category text NOT NULL CHECK (
    license_category IN ('owned', 'licensed', 'open', 'restricted', 'unknown')
  ),
  allowed_uses text[] NOT NULL DEFAULT '{}'::text[] CHECK (
    allowed_uses <@ ARRAY['retrieval', 'generation', 'quotation', 'internal_review']::text[]
  ),
  provenance_uri text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.kf_source_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL CHECK (btrim(version) <> ''),
  source_id uuid NOT NULL REFERENCES public.kf_sources(id) ON DELETE RESTRICT,
  checksum text NOT NULL CHECK (btrim(checksum) <> ''),
  effective_at timestamptz NOT NULL,
  supersedes_version text CHECK (supersedes_version IS NULL OR btrim(supersedes_version) <> ''),
  CONSTRAINT kf_source_versions_source_version_key UNIQUE (source_id, version),
  CONSTRAINT kf_source_versions_source_id_id_key UNIQUE (source_id, id)
);

CREATE TABLE public.kf_source_permission_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL CHECK (btrim(version) <> ''),
  source_id uuid NOT NULL REFERENCES public.kf_sources(id) ON DELETE RESTRICT,
  action text NOT NULL CHECK (action IN ('grant', 'revoke', 'block')),
  use_type text NOT NULL CHECK (
    use_type IN ('retrieval', 'generation', 'quotation', 'internal_review')
  ),
  reason text NOT NULL CHECK (btrim(reason) <> ''),
  occurred_at timestamptz NOT NULL
);

CREATE TABLE public.kf_source_segments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL CHECK (btrim(version) <> ''),
  source_version_id uuid NOT NULL REFERENCES public.kf_source_versions(id) ON DELETE RESTRICT,
  parent_segment_id uuid,
  locator text NOT NULL CHECK (btrim(locator) <> ''),
  content_digest text NOT NULL CHECK (btrim(content_digest) <> ''),
  extracted_text text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT kf_source_segments_source_version_id_id_key UNIQUE (source_version_id, id),
  CONSTRAINT kf_source_segments_parent_fk
    FOREIGN KEY (source_version_id, parent_segment_id)
    REFERENCES public.kf_source_segments(source_version_id, id)
    ON DELETE RESTRICT,
  CONSTRAINT kf_source_segments_not_self_parent CHECK (parent_segment_id IS NULL OR parent_segment_id <> id)
);

-- ---------------------------------------------------------------------------
-- 2. Pedagogical components and evidence
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_pedagogical_components (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL CHECK (btrim(version) <> ''),
  canonical_key text NOT NULL UNIQUE CHECK (btrim(canonical_key) <> ''),
  title text NOT NULL CHECK (btrim(title) <> ''),
  component_type text NOT NULL CHECK (
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
  school_component text NOT NULL CHECK (btrim(school_component) <> ''),
  grades text[] NOT NULL CHECK (
    grades <@ ARRAY['6', '7', '8', '9', '1_em', '2_em', '3_em']::text[]
  ),
  status text NOT NULL CHECK (
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
  current_version_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.kf_component_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL CHECK (btrim(version) <> ''),
  component_id uuid NOT NULL REFERENCES public.kf_pedagogical_components(id) ON DELETE RESTRICT,
  summary text NOT NULL,
  keywords text[] NOT NULL DEFAULT '{}'::text[],
  supersedes_version text CHECK (supersedes_version IS NULL OR btrim(supersedes_version) <> ''),
  approved_at timestamptz,
  status text NOT NULL CHECK (
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
  CONSTRAINT kf_component_versions_component_version_key UNIQUE (component_id, version),
  CONSTRAINT kf_component_versions_component_id_id_key UNIQUE (component_id, id)
);

ALTER TABLE public.kf_pedagogical_components
  ADD CONSTRAINT kf_pedagogical_components_current_version_fk
  FOREIGN KEY (id, current_version_id)
  REFERENCES public.kf_component_versions(component_id, id)
  ON DELETE RESTRICT
  DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE public.kf_component_source_evidence (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL CHECK (btrim(version) <> ''),
  component_version_id uuid NOT NULL
    REFERENCES public.kf_component_versions(id) ON DELETE RESTRICT,
  source_id uuid NOT NULL REFERENCES public.kf_sources(id) ON DELETE RESTRICT,
  source_version_id uuid NOT NULL,
  source_segment_id uuid NOT NULL,
  contribution text NOT NULL CHECK (
    contribution IN ('conceptual', 'curricular', 'methodological', 'contextual')
  ),
  recorded_at timestamptz NOT NULL,
  CONSTRAINT kf_component_source_evidence_source_version_fk
    FOREIGN KEY (source_id, source_version_id)
    REFERENCES public.kf_source_versions(source_id, id)
    ON DELETE RESTRICT,
  CONSTRAINT kf_component_source_evidence_segment_fk
    FOREIGN KEY (source_version_id, source_segment_id)
    REFERENCES public.kf_source_segments(source_version_id, id)
    ON DELETE RESTRICT
);

-- ---------------------------------------------------------------------------
-- 3. Curriculum packages and graph
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_curriculum_packages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL CHECK (btrim(version) <> ''),
  state text NOT NULL CHECK (state IN ('MG', 'RS')),
  stage text NOT NULL CHECK (stage IN ('fundamental_ii', 'ensino_medio')),
  status text NOT NULL CHECK (status IN ('draft', 'active', 'retired', 'blocked')),
  title text NOT NULL CHECK (btrim(title) <> ''),
  effective_from timestamptz NOT NULL,
  effective_until timestamptz,
  CONSTRAINT kf_curriculum_packages_effective_window_check CHECK (
    effective_until IS NULL OR effective_until >= effective_from
  ),
  CONSTRAINT kf_curriculum_packages_rs_mvp_block_check CHECK (
    state <> 'RS' OR status IN ('draft', 'blocked')
  )
);

CREATE UNIQUE INDEX kf_curriculum_packages_single_active_idx
  ON public.kf_curriculum_packages (state, stage)
  WHERE status = 'active';

CREATE TABLE public.kf_curriculum_package_sources (
  curriculum_package_id uuid NOT NULL
    REFERENCES public.kf_curriculum_packages(id) ON DELETE RESTRICT,
  source_version_id uuid NOT NULL
    REFERENCES public.kf_source_versions(id) ON DELETE RESTRICT,
  PRIMARY KEY (curriculum_package_id, source_version_id)
);

CREATE TABLE public.kf_curriculum_nodes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL CHECK (btrim(version) <> ''),
  curriculum_package_id uuid NOT NULL
    REFERENCES public.kf_curriculum_packages(id) ON DELETE RESTRICT,
  node_type text NOT NULL CHECK (
    node_type IN ('competency', 'skill', 'knowledge_object', 'learning_expectation')
  ),
  code text NOT NULL CHECK (btrim(code) <> ''),
  title text NOT NULL CHECK (btrim(title) <> ''),
  description text NOT NULL,
  component text NOT NULL CHECK (btrim(component) <> ''),
  grades text[] NOT NULL CHECK (
    grades <@ ARRAY['6', '7', '8', '9', '1_em', '2_em', '3_em']::text[]
  ),
  CONSTRAINT kf_curriculum_nodes_package_code_version_key
    UNIQUE (curriculum_package_id, code, version),
  CONSTRAINT kf_curriculum_nodes_package_id_id_key
    UNIQUE (curriculum_package_id, id)
);

CREATE TABLE public.kf_curriculum_links (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL CHECK (btrim(version) <> ''),
  curriculum_package_id uuid NOT NULL
    REFERENCES public.kf_curriculum_packages(id) ON DELETE RESTRICT,
  from_node_id uuid NOT NULL,
  to_node_id uuid NOT NULL,
  relation text NOT NULL CHECK (
    relation IN ('contains', 'progresses_to', 'equivalent_to', 'supports')
  ),
  CONSTRAINT kf_curriculum_links_distinct_nodes CHECK (from_node_id <> to_node_id),
  CONSTRAINT kf_curriculum_links_from_node_fk
    FOREIGN KEY (curriculum_package_id, from_node_id)
    REFERENCES public.kf_curriculum_nodes(curriculum_package_id, id)
    ON DELETE RESTRICT,
  CONSTRAINT kf_curriculum_links_to_node_fk
    FOREIGN KEY (curriculum_package_id, to_node_id)
    REFERENCES public.kf_curriculum_nodes(curriculum_package_id, id)
    ON DELETE RESTRICT
);

CREATE TABLE public.kf_component_curriculum_links (
  component_version_id uuid NOT NULL
    REFERENCES public.kf_component_versions(id) ON DELETE RESTRICT,
  curriculum_node_id uuid NOT NULL
    REFERENCES public.kf_curriculum_nodes(id) ON DELETE RESTRICT,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (component_version_id, curriculum_node_id)
);

-- ---------------------------------------------------------------------------
-- 4. Production orders and audit
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_production_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL CHECK (btrim(version) <> ''),
  requester_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE RESTRICT,
  agent_profile_id uuid NOT NULL,
  curriculum_package_id uuid NOT NULL
    REFERENCES public.kf_curriculum_packages(id) ON DELETE RESTRICT,
  product_type text NOT NULL CHECK (
    product_type IN (
      'lesson_plan',
      'didactic_text',
      'reflective_activity',
      'formative_assessment'
    )
  ),
  theme text NOT NULL CHECK (btrim(theme) <> ''),
  duration_minutes integer CHECK (duration_minutes IS NULL OR duration_minutes > 0),
  status text NOT NULL CHECK (
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
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.kf_production_order_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL CHECK (btrim(version) <> ''),
  opp_id uuid NOT NULL REFERENCES public.kf_production_orders(id) ON DELETE RESTRICT,
  event_type text NOT NULL CHECK (
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
  from_status text CHECK (
    from_status IS NULL OR from_status IN (
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
  to_status text NOT NULL CHECK (
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
  ),
  reason text,
  occurred_at timestamptz NOT NULL
);

CREATE TABLE public.kf_audit_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type text NOT NULL CHECK (btrim(event_type) <> ''),
  aggregate_type text NOT NULL CHECK (btrim(aggregate_type) <> ''),
  aggregate_id uuid NOT NULL,
  occurred_at timestamptz NOT NULL,
  actor_id uuid,
  actor_role text,
  correlation_id uuid,
  outcome text NOT NULL DEFAULT 'recorded' CHECK (btrim(outcome) <> ''),
  reason text,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------------
-- 5. Deterministic operational indexes only
-- ---------------------------------------------------------------------------
CREATE INDEX kf_source_versions_source_id_idx
  ON public.kf_source_versions (source_id);

CREATE INDEX kf_source_permission_events_source_id_idx
  ON public.kf_source_permission_events (source_id);

CREATE INDEX kf_source_segments_source_version_id_idx
  ON public.kf_source_segments (source_version_id);

CREATE INDEX kf_sources_status_idx
  ON public.kf_sources (status);

CREATE INDEX kf_components_status_idx
  ON public.kf_pedagogical_components (status);

CREATE INDEX kf_component_versions_component_id_idx
  ON public.kf_component_versions (component_id);

CREATE INDEX kf_component_evidence_component_version_idx
  ON public.kf_component_source_evidence (component_version_id);

CREATE INDEX kf_curriculum_packages_state_stage_status_idx
  ON public.kf_curriculum_packages (state, stage, status);

CREATE INDEX kf_curriculum_nodes_package_id_idx
  ON public.kf_curriculum_nodes (curriculum_package_id);

CREATE INDEX kf_production_orders_requester_id_idx
  ON public.kf_production_orders (requester_id);

CREATE INDEX kf_production_orders_status_idx
  ON public.kf_production_orders (status);

CREATE INDEX kf_production_order_events_opp_id_idx
  ON public.kf_production_order_events (opp_id);

CREATE INDEX kf_audit_events_aggregate_idx
  ON public.kf_audit_events (aggregate_type, aggregate_id, occurred_at);

-- ---------------------------------------------------------------------------
-- 6. Append-only protection
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.kf_prevent_append_only_mutation()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  RAISE EXCEPTION 'Knowledge Factory append-only table % does not allow %',
    TG_TABLE_NAME,
    TG_OP
    USING ERRCODE = '55000';
END;
$$;

ALTER FUNCTION public.kf_prevent_append_only_mutation() OWNER TO postgres;
REVOKE ALL ON FUNCTION public.kf_prevent_append_only_mutation() FROM PUBLIC;

CREATE TRIGGER kf_source_permission_events_append_only
BEFORE UPDATE OR DELETE ON public.kf_source_permission_events
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE TRIGGER kf_production_order_events_append_only
BEFORE UPDATE OR DELETE ON public.kf_production_order_events
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE TRIGGER kf_audit_events_append_only
BEFORE UPDATE OR DELETE ON public.kf_audit_events
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

-- ---------------------------------------------------------------------------
-- 7. RLS: deny by default, minimal direct access
-- ---------------------------------------------------------------------------
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

REVOKE ALL ON TABLE
  public.kf_sources,
  public.kf_source_versions,
  public.kf_source_permission_events,
  public.kf_source_segments,
  public.kf_pedagogical_components,
  public.kf_component_versions,
  public.kf_component_source_evidence,
  public.kf_curriculum_packages,
  public.kf_curriculum_package_sources,
  public.kf_curriculum_nodes,
  public.kf_curriculum_links,
  public.kf_component_curriculum_links,
  public.kf_production_orders,
  public.kf_production_order_events,
  public.kf_audit_events
FROM PUBLIC, anon, authenticated;

-- Authenticated gets only the SQL privileges needed for RLS-controlled reads
-- and direct OPP creation. Corpus rows remain invisible to non-admin users.
GRANT SELECT ON TABLE
  public.kf_sources,
  public.kf_source_versions,
  public.kf_source_permission_events,
  public.kf_source_segments,
  public.kf_pedagogical_components,
  public.kf_component_versions,
  public.kf_component_source_evidence,
  public.kf_curriculum_packages,
  public.kf_curriculum_package_sources,
  public.kf_curriculum_nodes,
  public.kf_curriculum_links,
  public.kf_component_curriculum_links,
  public.kf_audit_events
TO authenticated;

GRANT SELECT, INSERT ON TABLE public.kf_production_orders TO authenticated;
GRANT SELECT ON TABLE public.kf_production_order_events TO authenticated;

-- Minimal backend privileges for future adapters; no DELETE is granted.
GRANT SELECT, INSERT, UPDATE ON TABLE
  public.kf_sources,
  public.kf_source_versions,
  public.kf_source_segments,
  public.kf_pedagogical_components,
  public.kf_component_versions,
  public.kf_component_source_evidence,
  public.kf_curriculum_packages,
  public.kf_curriculum_package_sources,
  public.kf_curriculum_nodes,
  public.kf_curriculum_links,
  public.kf_component_curriculum_links,
  public.kf_production_orders
TO service_role;

GRANT SELECT, INSERT ON TABLE
  public.kf_source_permission_events,
  public.kf_production_order_events,
  public.kf_audit_events
TO service_role;

-- ---------------------------------------------------------------------------
-- 8. Admin read policies for global corpus and audit
-- ---------------------------------------------------------------------------
CREATE POLICY kf_sources_admin_select
  ON public.kf_sources FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_source_versions_admin_select
  ON public.kf_source_versions FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_source_permission_events_admin_select
  ON public.kf_source_permission_events FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_source_segments_admin_select
  ON public.kf_source_segments FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_pedagogical_components_admin_select
  ON public.kf_pedagogical_components FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_component_versions_admin_select
  ON public.kf_component_versions FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_component_source_evidence_admin_select
  ON public.kf_component_source_evidence FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_curriculum_packages_admin_select
  ON public.kf_curriculum_packages FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_curriculum_package_sources_admin_select
  ON public.kf_curriculum_package_sources FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_curriculum_nodes_admin_select
  ON public.kf_curriculum_nodes FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_curriculum_links_admin_select
  ON public.kf_curriculum_links FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_component_curriculum_links_admin_select
  ON public.kf_component_curriculum_links FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_audit_events_admin_select
  ON public.kf_audit_events FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

-- ---------------------------------------------------------------------------
-- 9. User-owned OPP policies
-- ---------------------------------------------------------------------------
CREATE POLICY kf_production_orders_select_own
  ON public.kf_production_orders FOR SELECT TO authenticated
  USING (requester_id = auth.uid());

CREATE POLICY kf_production_orders_insert_own
  ON public.kf_production_orders FOR INSERT TO authenticated
  WITH CHECK (
    requester_id = auth.uid()
    AND status = 'requested'
  );

CREATE POLICY kf_production_order_events_select_own
  ON public.kf_production_order_events FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.kf_production_orders opp
      WHERE opp.id = kf_production_order_events.opp_id
        AND opp.requester_id = auth.uid()
    )
  );

COMMIT;
