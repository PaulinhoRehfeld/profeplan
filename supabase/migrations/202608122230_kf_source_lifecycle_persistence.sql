-- =============================================================================
-- ProfePlan Knowledge Factory - Sublote C.1.2
-- Governed source lifecycle persistence, RLS and least-privilege grants.
--
-- Additive only. This migration does not create lifecycle command RPCs, does
-- not reinterpret legacy source data and does not authorize production use.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Minimal governed identities
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_source_identities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kind text NOT NULL CHECK (
    kind IN (
      'work',
      'edition',
      'manifestation',
      'received_file',
      'governed_source',
      'source_version',
      'processing_run',
      'derived_artifact'
    )
  ),
  legacy_source_id uuid REFERENCES public.kf_sources(id) ON DELETE RESTRICT,
  legacy_source_version_id uuid REFERENCES public.kf_source_versions(id) ON DELETE RESTRICT,
  created_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_source_identities_legacy_shape_check CHECK (
    (legacy_source_id IS NULL OR kind = 'governed_source')
    AND (legacy_source_version_id IS NULL OR kind = 'source_version')
    AND NOT (legacy_source_id IS NOT NULL AND legacy_source_version_id IS NOT NULL)
  )
);

CREATE UNIQUE INDEX kf_source_identities_legacy_source_idx
  ON public.kf_source_identities (legacy_source_id)
  WHERE legacy_source_id IS NOT NULL;

CREATE UNIQUE INDEX kf_source_identities_legacy_version_idx
  ON public.kf_source_identities (legacy_source_version_id)
  WHERE legacy_source_version_id IS NOT NULL;

-- ---------------------------------------------------------------------------
-- 2. Minimized, immutable authorization bases
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_source_authorization_bases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kind text NOT NULL CHECK (
    kind IN (
      'wrtech_ownership',
      'publisher_contract',
      'open_license',
      'express_authorization',
      'legal_norm',
      'other_approved'
    )
  ),
  reference_digest text CHECK (
    reference_digest IS NULL OR btrim(reference_digest) <> ''
  ),
  created_at timestamptz NOT NULL DEFAULT clock_timestamp()
);

-- ---------------------------------------------------------------------------
-- 3. Rebuildable registration projection
--
-- The event history is authoritative. This table is a current projection for
-- compare-and-set and efficient reads by the future C.1.3 boundary.
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_source_registration_projections (
  subject_identity_id uuid PRIMARY KEY
    REFERENCES public.kf_source_identities(id) ON DELETE RESTRICT,
  projected_state text NOT NULL CHECK (
    projected_state IN (
      'REGISTERED',
      'PENDING_VALIDATION',
      'VALIDATED',
      'BLOCKED',
      'REPLACED',
      'ARCHIVED'
    )
  ),
  aggregate_version text NOT NULL CHECK (btrim(aggregate_version) <> ''),
  sequence bigint NOT NULL CHECK (sequence > 0),
  successor_identity_id uuid
    REFERENCES public.kf_source_identities(id) ON DELETE RESTRICT,
  created_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  updated_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_source_registration_projection_successor_check CHECK (
    (projected_state = 'REPLACED' AND successor_identity_id IS NOT NULL)
    OR (projected_state <> 'REPLACED' AND successor_identity_id IS NULL)
  ),
  CONSTRAINT kf_source_registration_projection_not_self_successor_check CHECK (
    successor_identity_id IS NULL OR successor_identity_id <> subject_identity_id
  ),
  CONSTRAINT kf_source_registration_projection_time_check CHECK (
    updated_at >= created_at
  )
);

-- ---------------------------------------------------------------------------
-- 4. Authorization aggregate and rebuildable current projection
--
-- Scope, purpose, basis and effective window are immutable for one
-- authorization id. Scope changes create a successor authorization.
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_source_authorizations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_identity_id uuid NOT NULL
    REFERENCES public.kf_source_identities(id) ON DELETE RESTRICT,
  purpose text NOT NULL CHECK (
    purpose IN (
      'temporary_staging',
      'ingestion',
      'extraction',
      'analysis_classification',
      'distillation',
      'quotation',
      'indexing_embedding',
      'retrieval',
      'evidence',
      'generation'
    )
  ),
  restrictions text[] NOT NULL DEFAULT '{}'::text[],
  basis_id uuid NOT NULL
    REFERENCES public.kf_source_authorization_bases(id) ON DELETE RESTRICT,
  effective_from timestamptz NOT NULL,
  effective_until timestamptz,
  projected_state text NOT NULL CHECK (
    projected_state IN (
      'PENDING_REVIEW',
      'GRANTED',
      'SUSPENDED',
      'REVOKED',
      'EXPIRED',
      'BLOCKED',
      'SUPERSEDED'
    )
  ),
  aggregate_version text NOT NULL CHECK (btrim(aggregate_version) <> ''),
  sequence bigint NOT NULL CHECK (sequence > 0),
  superseded_by_authorization_id uuid,
  created_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  updated_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_source_authorizations_effective_window_check CHECK (
    effective_until IS NULL OR effective_until >= effective_from
  ),
  CONSTRAINT kf_source_authorizations_supersession_shape_check CHECK (
    (projected_state = 'SUPERSEDED' AND superseded_by_authorization_id IS NOT NULL)
    OR (projected_state <> 'SUPERSEDED' AND superseded_by_authorization_id IS NULL)
  ),
  CONSTRAINT kf_source_authorizations_not_self_superseding_check CHECK (
    superseded_by_authorization_id IS NULL OR superseded_by_authorization_id <> id
  ),
  CONSTRAINT kf_source_authorizations_time_check CHECK (updated_at >= created_at)
);

ALTER TABLE public.kf_source_authorizations
  ADD CONSTRAINT kf_source_authorizations_superseded_by_fk
  FOREIGN KEY (superseded_by_authorization_id)
  REFERENCES public.kf_source_authorizations(id)
  ON DELETE RESTRICT
  DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX kf_source_authorizations_subject_purpose_idx
  ON public.kf_source_authorizations (subject_identity_id, purpose);

-- ---------------------------------------------------------------------------
-- 5. Idempotency receipts
--
-- C.1.2 persists the invariant. Replay/conflict behavior and atomic command
-- execution remain exclusively in C.1.3.
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_source_command_receipts (
  command_id uuid PRIMARY KEY,
  fingerprint text NOT NULL CHECK (btrim(fingerprint) <> ''),
  dimension text NOT NULL CHECK (dimension IN ('registration', 'authorization', 'impact')),
  operation text NOT NULL CHECK (
    operation IN (
      'register_identity',
      'request_validation',
      'confirm_validation',
      'block_source',
      'replace_source',
      'archive_source',
      'grant_authorization',
      'suspend_authorization',
      'resume_authorization',
      'revoke_authorization',
      'block_purpose',
      'supersede_authorization',
      'open_impact_assessment'
    )
  ),
  aggregate_id uuid NOT NULL,
  subject_identity_id uuid
    REFERENCES public.kf_source_identities(id) ON DELETE RESTRICT,
  authorization_id uuid
    REFERENCES public.kf_source_authorizations(id) ON DELETE RESTRICT,
  aggregate_version text NOT NULL CHECK (btrim(aggregate_version) <> ''),
  sequence bigint NOT NULL CHECK (sequence > 0),
  registration_state text CHECK (
    registration_state IS NULL OR registration_state IN (
      'REGISTERED',
      'PENDING_VALIDATION',
      'VALIDATED',
      'BLOCKED',
      'REPLACED',
      'ARCHIVED'
    )
  ),
  authorization_state text CHECK (
    authorization_state IS NULL OR authorization_state IN (
      'PENDING_REVIEW',
      'GRANTED',
      'SUSPENDED',
      'REVOKED',
      'EXPIRED',
      'BLOCKED',
      'SUPERSEDED'
    )
  ),
  committed_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_source_command_receipts_shape_check CHECK (
    (
      dimension = 'registration'
      AND operation IN (
        'register_identity',
        'request_validation',
        'confirm_validation',
        'block_source',
        'replace_source',
        'archive_source'
      )
      AND subject_identity_id IS NOT NULL
      AND aggregate_id = subject_identity_id
      AND authorization_id IS NULL
      AND registration_state IS NOT NULL
      AND authorization_state IS NULL
    )
    OR (
      dimension = 'authorization'
      AND operation IN (
        'grant_authorization',
        'suspend_authorization',
        'resume_authorization',
        'revoke_authorization',
        'block_purpose',
        'supersede_authorization'
      )
      AND authorization_id IS NOT NULL
      AND aggregate_id = authorization_id
      AND subject_identity_id IS NULL
      AND registration_state IS NULL
      AND authorization_state IS NOT NULL
    )
    OR (
      dimension = 'impact'
      AND operation = 'open_impact_assessment'
      AND subject_identity_id IS NOT NULL
      AND aggregate_id = subject_identity_id
      AND authorization_id IS NULL
      AND registration_state IS NULL
      AND authorization_state IS NULL
    )
  )
);

CREATE INDEX kf_source_command_receipts_aggregate_idx
  ON public.kf_source_command_receipts (dimension, aggregate_id, sequence);

-- ---------------------------------------------------------------------------
-- 6. Authoritative append-only governance history
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_source_governance_events (
  event_id uuid PRIMARY KEY,
  dimension text NOT NULL CHECK (dimension IN ('registration', 'authorization', 'impact')),
  aggregate_id uuid NOT NULL,
  aggregate_version text NOT NULL CHECK (btrim(aggregate_version) <> ''),
  sequence bigint NOT NULL CHECK (sequence > 0),
  event_type text NOT NULL CHECK (
    event_type IN (
      'source_registered',
      'source_validation_requested',
      'source_validated',
      'source_blocked',
      'source_replaced',
      'source_archived',
      'authorization_granted',
      'authorization_suspended',
      'authorization_resumed',
      'authorization_revoked',
      'authorization_expired',
      'authorization_blocked',
      'authorization_superseded',
      'source_impact_assessment_opened'
    )
  ),
  subject_identity_id uuid NOT NULL
    REFERENCES public.kf_source_identities(id) ON DELETE RESTRICT,
  authorization_id uuid
    REFERENCES public.kf_source_authorizations(id) ON DELETE RESTRICT,
  purpose text CHECK (
    purpose IS NULL OR purpose IN (
      'temporary_staging',
      'ingestion',
      'extraction',
      'analysis_classification',
      'distillation',
      'quotation',
      'indexing_embedding',
      'retrieval',
      'evidence',
      'generation'
    )
  ),
  restrictions text[],
  basis_id uuid
    REFERENCES public.kf_source_authorization_bases(id) ON DELETE RESTRICT,
  actor_id uuid NOT NULL,
  actor_role text NOT NULL CHECK (
    actor_role IN (
      'curator',
      'legal_editorial_reviewer',
      'system_worker',
      'auditor',
      'technical_admin'
    )
  ),
  reason text NOT NULL CHECK (btrim(reason) <> ''),
  occurred_at timestamptz NOT NULL,
  effective_at timestamptz NOT NULL,
  correlation_id uuid NOT NULL,
  command_id uuid NOT NULL,
  registration_from_state text CHECK (
    registration_from_state IS NULL OR registration_from_state IN (
      'REGISTERED',
      'PENDING_VALIDATION',
      'VALIDATED',
      'BLOCKED',
      'REPLACED',
      'ARCHIVED'
    )
  ),
  registration_to_state text CHECK (
    registration_to_state IS NULL OR registration_to_state IN (
      'REGISTERED',
      'PENDING_VALIDATION',
      'VALIDATED',
      'BLOCKED',
      'REPLACED',
      'ARCHIVED'
    )
  ),
  authorization_from_state text CHECK (
    authorization_from_state IS NULL OR authorization_from_state IN (
      'PENDING_REVIEW',
      'GRANTED',
      'SUSPENDED',
      'REVOKED',
      'EXPIRED',
      'BLOCKED',
      'SUPERSEDED'
    )
  ),
  authorization_to_state text CHECK (
    authorization_to_state IS NULL OR authorization_to_state IN (
      'PENDING_REVIEW',
      'GRANTED',
      'SUSPENDED',
      'REVOKED',
      'EXPIRED',
      'BLOCKED',
      'SUPERSEDED'
    )
  ),
  effective_from timestamptz,
  effective_until timestamptz,
  successor_identity_id uuid
    REFERENCES public.kf_source_identities(id) ON DELETE RESTRICT,
  superseded_by_authorization_id uuid
    REFERENCES public.kf_source_authorizations(id) ON DELETE RESTRICT,
  triggering_authorization_id uuid
    REFERENCES public.kf_source_authorizations(id) ON DELETE RESTRICT,
  recorded_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_source_governance_events_sequence_key
    UNIQUE (dimension, aggregate_id, sequence),
  CONSTRAINT kf_source_governance_events_command_event_key
    UNIQUE (command_id, event_id),
  CONSTRAINT kf_source_governance_events_command_fk
    FOREIGN KEY (command_id)
    REFERENCES public.kf_source_command_receipts(command_id)
    ON DELETE RESTRICT
    DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT kf_source_governance_events_effective_window_check CHECK (
    effective_until IS NULL OR (
      effective_from IS NOT NULL AND effective_until >= effective_from
    )
  ),
  CONSTRAINT kf_source_governance_events_not_self_successor_check CHECK (
    successor_identity_id IS NULL OR successor_identity_id <> subject_identity_id
  ),
  CONSTRAINT kf_source_governance_events_shape_check CHECK (
    (
      dimension = 'registration'
      AND event_type IN (
        'source_registered',
        'source_validation_requested',
        'source_validated',
        'source_blocked',
        'source_replaced',
        'source_archived'
      )
      AND aggregate_id = subject_identity_id
      AND authorization_id IS NULL
      AND purpose IS NULL
      AND restrictions IS NULL
      AND basis_id IS NULL
      AND registration_to_state IS NOT NULL
      AND authorization_from_state IS NULL
      AND authorization_to_state IS NULL
      AND effective_from IS NULL
      AND effective_until IS NULL
      AND superseded_by_authorization_id IS NULL
      AND triggering_authorization_id IS NULL
      AND (
        (event_type = 'source_replaced' AND successor_identity_id IS NOT NULL)
        OR (event_type <> 'source_replaced' AND successor_identity_id IS NULL)
      )
    )
    OR (
      dimension = 'authorization'
      AND event_type IN (
        'authorization_granted',
        'authorization_suspended',
        'authorization_resumed',
        'authorization_revoked',
        'authorization_expired',
        'authorization_blocked',
        'authorization_superseded'
      )
      AND authorization_id IS NOT NULL
      AND aggregate_id = authorization_id
      AND purpose IS NOT NULL
      AND restrictions IS NOT NULL
      AND basis_id IS NOT NULL
      AND registration_from_state IS NULL
      AND registration_to_state IS NULL
      AND authorization_to_state IS NOT NULL
      AND effective_from IS NOT NULL
      AND successor_identity_id IS NULL
      AND triggering_authorization_id IS NULL
      AND (
        (event_type = 'authorization_superseded' AND superseded_by_authorization_id IS NOT NULL)
        OR (event_type <> 'authorization_superseded' AND superseded_by_authorization_id IS NULL)
      )
    )
    OR (
      dimension = 'impact'
      AND event_type = 'source_impact_assessment_opened'
      AND aggregate_id = subject_identity_id
      AND authorization_id IS NULL
      AND purpose IS NULL
      AND restrictions IS NULL
      AND basis_id IS NULL
      AND registration_from_state IS NULL
      AND registration_to_state IS NULL
      AND authorization_from_state IS NULL
      AND authorization_to_state IS NULL
      AND effective_from IS NULL
      AND effective_until IS NULL
      AND successor_identity_id IS NULL
      AND superseded_by_authorization_id IS NULL
    )
  )
);

CREATE INDEX kf_source_governance_registration_history_idx
  ON public.kf_source_governance_events (
    subject_identity_id,
    effective_at,
    sequence,
    event_id
  )
  WHERE dimension = 'registration';

CREATE INDEX kf_source_governance_authorization_history_idx
  ON public.kf_source_governance_events (
    authorization_id,
    effective_at,
    sequence,
    event_id
  )
  WHERE dimension = 'authorization';

CREATE INDEX kf_source_governance_authorization_lookup_idx
  ON public.kf_source_governance_events (
    subject_identity_id,
    purpose,
    effective_at,
    sequence,
    event_id
  )
  WHERE dimension = 'authorization';

CREATE INDEX kf_source_governance_command_idx
  ON public.kf_source_governance_events (command_id);

-- ---------------------------------------------------------------------------
-- 7. Ordered receipt -> event relation
-- ---------------------------------------------------------------------------
CREATE TABLE public.kf_source_command_receipt_events (
  command_id uuid NOT NULL,
  event_id uuid NOT NULL,
  event_order integer NOT NULL CHECK (event_order > 0),
  PRIMARY KEY (command_id, event_id),
  CONSTRAINT kf_source_command_receipt_events_order_key
    UNIQUE (command_id, event_order),
  CONSTRAINT kf_source_command_receipt_events_event_key UNIQUE (event_id),
  CONSTRAINT kf_source_command_receipt_events_receipt_fk
    FOREIGN KEY (command_id)
    REFERENCES public.kf_source_command_receipts(command_id)
    ON DELETE RESTRICT,
  CONSTRAINT kf_source_command_receipt_events_event_fk
    FOREIGN KEY (command_id, event_id)
    REFERENCES public.kf_source_governance_events(command_id, event_id)
    ON DELETE RESTRICT
    DEFERRABLE INITIALLY DEFERRED
);

-- ---------------------------------------------------------------------------
-- 8. Append-only defense in depth
-- ---------------------------------------------------------------------------
CREATE TRIGGER kf_source_identities_append_only
BEFORE UPDATE OR DELETE ON public.kf_source_identities
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE TRIGGER kf_source_authorization_bases_append_only
BEFORE UPDATE OR DELETE ON public.kf_source_authorization_bases
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE TRIGGER kf_source_governance_events_append_only
BEFORE UPDATE OR DELETE ON public.kf_source_governance_events
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE TRIGGER kf_source_command_receipts_append_only
BEFORE UPDATE OR DELETE ON public.kf_source_command_receipts
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE TRIGGER kf_source_command_receipt_events_append_only
BEFORE UPDATE OR DELETE ON public.kf_source_command_receipt_events
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE OR REPLACE FUNCTION public.kf_prevent_source_authorization_scope_mutation()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  IF NEW.id IS DISTINCT FROM OLD.id
    OR NEW.subject_identity_id IS DISTINCT FROM OLD.subject_identity_id
    OR NEW.purpose IS DISTINCT FROM OLD.purpose
    OR NEW.restrictions IS DISTINCT FROM OLD.restrictions
    OR NEW.basis_id IS DISTINCT FROM OLD.basis_id
    OR NEW.effective_from IS DISTINCT FROM OLD.effective_from
    OR NEW.effective_until IS DISTINCT FROM OLD.effective_until
    OR NEW.created_at IS DISTINCT FROM OLD.created_at THEN
    RAISE EXCEPTION
      'Knowledge Factory authorization scope and basis are immutable'
      USING ERRCODE = '55000';
  END IF;

  RETURN NEW;
END;
$$;

ALTER FUNCTION public.kf_prevent_source_authorization_scope_mutation() OWNER TO postgres;
REVOKE ALL ON FUNCTION public.kf_prevent_source_authorization_scope_mutation() FROM PUBLIC;

CREATE TRIGGER kf_source_authorizations_immutable_scope
BEFORE UPDATE ON public.kf_source_authorizations
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_source_authorization_scope_mutation();

-- ---------------------------------------------------------------------------
-- 9. RLS and grants: deny by default
--
-- Conceptual business roles are not PostgreSQL roles in C.1.2. service_role,
-- SYSTEM and technical admin are not legal/editorial authority.
-- ---------------------------------------------------------------------------
ALTER TABLE public.kf_source_identities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_source_authorization_bases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_source_registration_projections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_source_authorizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_source_command_receipts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_source_governance_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_source_command_receipt_events ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE
  public.kf_source_identities,
  public.kf_source_authorization_bases,
  public.kf_source_registration_projections,
  public.kf_source_authorizations,
  public.kf_source_command_receipts,
  public.kf_source_governance_events,
  public.kf_source_command_receipt_events
FROM PUBLIC, anon, authenticated, service_role;

-- Table SELECT is required for the RLS policy to admit platform-admin rows.
-- It does not grant any business authority or write capability.
GRANT SELECT ON TABLE
  public.kf_source_identities,
  public.kf_source_authorization_bases,
  public.kf_source_registration_projections,
  public.kf_source_authorizations,
  public.kf_source_command_receipts,
  public.kf_source_governance_events,
  public.kf_source_command_receipt_events
TO authenticated;

CREATE POLICY kf_source_identities_admin_select
  ON public.kf_source_identities FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_source_authorization_bases_admin_select
  ON public.kf_source_authorization_bases FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_source_registration_projections_admin_select
  ON public.kf_source_registration_projections FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_source_authorizations_admin_select
  ON public.kf_source_authorizations FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_source_command_receipts_admin_select
  ON public.kf_source_command_receipts FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_source_governance_events_admin_select
  ON public.kf_source_governance_events FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

CREATE POLICY kf_source_command_receipt_events_admin_select
  ON public.kf_source_command_receipt_events FOR SELECT TO authenticated
  USING (public.kf_is_platform_admin());

COMMIT;
