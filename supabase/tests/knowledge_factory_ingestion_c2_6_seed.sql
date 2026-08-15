\set ON_ERROR_STOP on

-- Synthetic-only C.2.6 authority fixture.
-- No hosted resource, protected content, production secret or real source is used.

INSERT INTO public.kf_source_identities(id, kind) VALUES
  ('e2000000-0000-4000-8000-000000000001', 'source_version'),
  ('e3000000-0000-4000-8000-000000000001', 'received_file'),
  ('e2000000-0000-4000-8000-000000000002', 'source_version'),
  ('e3000000-0000-4000-8000-000000000002', 'received_file');

INSERT INTO public.kf_source_authorization_bases(id, kind)
VALUES ('ee000000-0000-4000-8000-000000000001', 'wrtech_ownership');

-- temporary_staging, ingestion and extraction are deliberately independent.
INSERT INTO public.kf_source_authorizations(
  id, subject_identity_id, purpose, restrictions, basis_id,
  effective_from, effective_until, projected_state, aggregate_version, sequence
) VALUES
  ('ef000000-0000-4000-8000-000000000001','e2000000-0000-4000-8000-000000000001','temporary_staging','{}','ee000000-0000-4000-8000-000000000001','2026-08-15T00:00:00Z','2026-08-15T08:00:00Z','GRANTED','c26-temp-ok-v1',1),
  ('ef000000-0000-4000-8000-000000000002','e2000000-0000-4000-8000-000000000001','ingestion','{}','ee000000-0000-4000-8000-000000000001','2026-08-15T00:00:00Z','2026-08-15T08:00:00Z','GRANTED','c26-ingest-ok-v1',1),
  ('ef000000-0000-4000-8000-000000000003','e2000000-0000-4000-8000-000000000001','extraction','{}','ee000000-0000-4000-8000-000000000001','2026-08-15T00:00:00Z','2026-08-15T08:00:00Z','GRANTED','c26-extract-ok-v1',1),
  ('ef000000-0000-4000-8000-000000000004','e2000000-0000-4000-8000-000000000002','temporary_staging','{}','ee000000-0000-4000-8000-000000000001','2026-08-15T00:00:00Z','2026-08-15T08:00:00Z','GRANTED','c26-temp-cancel-v1',1),
  ('ef000000-0000-4000-8000-000000000005','e2000000-0000-4000-8000-000000000002','ingestion','{}','ee000000-0000-4000-8000-000000000001','2026-08-15T00:00:00Z','2026-08-15T08:00:00Z','GRANTED','c26-ingest-cancel-v1',1);

INSERT INTO public.kf_source_actor_assignments(
  id, actor_id, actor_role, effective_from, effective_until
) VALUES
  ('ea100000-0000-4000-8000-000000000001','e4000000-0000-4000-8000-000000000001','system_worker','2026-08-15T00:00:00Z','2026-08-15T08:00:00Z'),
  ('ea100000-0000-4000-8000-000000000002','e4100000-0000-4000-8000-000000000001','legal_editorial_reviewer','2026-08-15T00:00:00Z','2026-08-15T08:00:00Z');

-- C.2.5 evaluates extraction authorization historically from C.1 governance events.
INSERT INTO public.kf_source_command_receipts(
  command_id,fingerprint,dimension,operation,aggregate_id,authorization_id,
  aggregate_version,sequence,authorization_state
) VALUES (
  'eb100000-0000-4000-8000-000000000001','synthetic-c26-extraction-grant',
  'authorization','grant_authorization','ef000000-0000-4000-8000-000000000003',
  'ef000000-0000-4000-8000-000000000003','c26-extract-ok-v1',1,'GRANTED'
);

INSERT INTO public.kf_source_governance_events(
  event_id,dimension,aggregate_id,aggregate_version,sequence,event_type,
  subject_identity_id,authorization_id,purpose,restrictions,basis_id,
  actor_id,actor_role,reason,occurred_at,effective_at,correlation_id,command_id,
  authorization_to_state,effective_from,effective_until
) VALUES (
  'ec100000-0000-4000-8000-000000000001','authorization',
  'ef000000-0000-4000-8000-000000000003','c26-extract-ok-v1',1,'authorization_granted',
  'e2000000-0000-4000-8000-000000000001','ef000000-0000-4000-8000-000000000003',
  'extraction','{}','ee000000-0000-4000-8000-000000000001',
  'e4100000-0000-4000-8000-000000000001','legal_editorial_reviewer',
  'synthetic C.2.6 extraction authorization','2026-08-15T01:30:00Z','2026-08-15T01:30:00Z',
  'ed100000-0000-4000-8000-000000000001','eb100000-0000-4000-8000-000000000001',
  'GRANTED','2026-08-15T00:00:00Z','2026-08-15T08:00:00Z'
);

INSERT INTO public.kf_source_command_receipt_events(command_id,event_id,event_order)
VALUES ('eb100000-0000-4000-8000-000000000001','ec100000-0000-4000-8000-000000000001',1);
