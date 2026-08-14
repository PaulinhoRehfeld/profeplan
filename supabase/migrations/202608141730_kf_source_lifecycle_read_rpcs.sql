-- =============================================================================
-- ProfePlan Knowledge Factory - Sublote C.1.4
-- Read-only server-side query boundary for governed source lifecycle history.
--
-- SECURITY: service_role receives EXECUTE only. Direct SELECT/DML on lifecycle
-- tables remains governed by the C.1.2 deny-by-default grants and RLS model.
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION public.kf_source_list_registration_history(
  p_subject_identity_id uuid,
  p_as_of timestamptz DEFAULT NULL
)
RETURNS TABLE(
  event_id uuid,
  aggregate_id uuid,
  aggregate_version text,
  sequence bigint,
  event_type text,
  subject_id uuid,
  subject_kind text,
  actor_id uuid,
  actor_role text,
  reason text,
  occurred_at timestamptz,
  effective_at timestamptz,
  correlation_id uuid,
  command_id uuid,
  from_state text,
  to_state text,
  successor_id uuid,
  successor_kind text
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
  SELECT
    events.event_id,
    events.aggregate_id,
    events.aggregate_version,
    events.sequence,
    events.event_type,
    events.subject_identity_id AS subject_id,
    subject.kind AS subject_kind,
    events.actor_id,
    events.actor_role,
    events.reason,
    events.occurred_at,
    events.effective_at,
    events.correlation_id,
    events.command_id,
    events.registration_from_state AS from_state,
    events.registration_to_state AS to_state,
    events.successor_identity_id AS successor_id,
    successor.kind AS successor_kind
  FROM public.kf_source_governance_events AS events
  INNER JOIN public.kf_source_identities AS subject
    ON subject.id = events.subject_identity_id
  LEFT JOIN public.kf_source_identities AS successor
    ON successor.id = events.successor_identity_id
  WHERE events.dimension = 'registration'
    AND events.subject_identity_id = p_subject_identity_id
    AND (p_as_of IS NULL OR events.effective_at <= p_as_of)
  ORDER BY events.effective_at ASC, events.sequence ASC, events.event_id ASC
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_list_authorization_history(
  p_subject_identity_id uuid,
  p_purpose text DEFAULT NULL,
  p_as_of timestamptz DEFAULT NULL
)
RETURNS TABLE(
  event_id uuid,
  aggregate_id uuid,
  aggregate_version text,
  sequence bigint,
  event_type text,
  subject_id uuid,
  subject_kind text,
  actor_id uuid,
  actor_role text,
  reason text,
  occurred_at timestamptz,
  effective_at timestamptz,
  correlation_id uuid,
  command_id uuid,
  authorization_id uuid,
  purpose text,
  restrictions text[],
  basis_id uuid,
  basis_kind text,
  basis_reference_digest text,
  from_state text,
  to_state text,
  effective_from timestamptz,
  effective_until timestamptz,
  superseded_by_authorization_id uuid
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
  SELECT
    events.event_id,
    events.aggregate_id,
    events.aggregate_version,
    events.sequence,
    events.event_type,
    events.subject_identity_id AS subject_id,
    subject.kind AS subject_kind,
    events.actor_id,
    events.actor_role,
    events.reason,
    events.occurred_at,
    events.effective_at,
    events.correlation_id,
    events.command_id,
    events.authorization_id,
    events.purpose,
    events.restrictions,
    events.basis_id,
    basis.kind AS basis_kind,
    basis.reference_digest AS basis_reference_digest,
    events.authorization_from_state AS from_state,
    events.authorization_to_state AS to_state,
    events.effective_from,
    events.effective_until,
    events.superseded_by_authorization_id
  FROM public.kf_source_governance_events AS events
  INNER JOIN public.kf_source_identities AS subject
    ON subject.id = events.subject_identity_id
  INNER JOIN public.kf_source_authorization_bases AS basis
    ON basis.id = events.basis_id
  WHERE events.dimension = 'authorization'
    AND events.subject_identity_id = p_subject_identity_id
    AND (p_purpose IS NULL OR events.purpose = p_purpose)
    AND (p_as_of IS NULL OR events.effective_at <= p_as_of)
  ORDER BY events.effective_at ASC, events.sequence ASC, events.event_id ASC
$function$;

CREATE OR REPLACE FUNCTION public.kf_source_list_impact_history(
  p_subject_identity_id uuid,
  p_as_of timestamptz DEFAULT NULL
)
RETURNS TABLE(
  event_id uuid,
  aggregate_id uuid,
  aggregate_version text,
  sequence bigint,
  event_type text,
  subject_id uuid,
  subject_kind text,
  actor_id uuid,
  actor_role text,
  reason text,
  occurred_at timestamptz,
  effective_at timestamptz,
  correlation_id uuid,
  command_id uuid,
  triggering_authorization_id uuid
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
  SELECT
    events.event_id,
    events.aggregate_id,
    events.aggregate_version,
    events.sequence,
    events.event_type,
    events.subject_identity_id AS subject_id,
    subject.kind AS subject_kind,
    events.actor_id,
    events.actor_role,
    events.reason,
    events.occurred_at,
    events.effective_at,
    events.correlation_id,
    events.command_id,
    events.triggering_authorization_id
  FROM public.kf_source_governance_events AS events
  INNER JOIN public.kf_source_identities AS subject
    ON subject.id = events.subject_identity_id
  WHERE events.dimension = 'impact'
    AND events.subject_identity_id = p_subject_identity_id
    AND (p_as_of IS NULL OR events.effective_at <= p_as_of)
  ORDER BY events.effective_at ASC, events.sequence ASC, events.event_id ASC
$function$;

ALTER FUNCTION public.kf_source_list_registration_history(uuid,timestamptz) OWNER TO postgres;
ALTER FUNCTION public.kf_source_list_authorization_history(uuid,text,timestamptz) OWNER TO postgres;
ALTER FUNCTION public.kf_source_list_impact_history(uuid,timestamptz) OWNER TO postgres;

REVOKE ALL ON FUNCTION
  public.kf_source_list_registration_history(uuid,timestamptz),
  public.kf_source_list_authorization_history(uuid,text,timestamptz),
  public.kf_source_list_impact_history(uuid,timestamptz)
FROM PUBLIC, anon, authenticated, service_role;

GRANT EXECUTE ON FUNCTION
  public.kf_source_list_registration_history(uuid,timestamptz),
  public.kf_source_list_authorization_history(uuid,text,timestamptz),
  public.kf_source_list_impact_history(uuid,timestamptz)
TO service_role;

COMMIT;
