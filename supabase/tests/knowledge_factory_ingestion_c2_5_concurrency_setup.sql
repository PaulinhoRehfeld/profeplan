\set ON_ERROR_STOP on

-- Synthetic fixtures for real multi-session C.2.5 concurrency proof.
INSERT INTO public.kf_source_identities(id,kind) VALUES
  ('c1000000-0000-4000-8000-000000000007','processing_run'),
  ('c1000000-0000-4000-8000-000000000008','processing_run');

INSERT INTO public.kf_ingestion_runs(
  run_id,request_id,source_version_id,received_file_id,
  requested_by_actor_id,requested_by_actor_role,requested_at,
  state,aggregate_version,sequence
) VALUES
  ('c1000000-0000-4000-8000-000000000007','c6000000-0000-4000-8000-000000000007',
   'c2000000-0000-4000-8000-000000000001','c3000000-0000-4000-8000-000000000001',
   'c4000000-0000-4000-8000-000000000001','system_worker','2026-08-15T02:00:00Z',
   'VERIFIED','same-review-v5',5),
  ('c1000000-0000-4000-8000-000000000008','c6000000-0000-4000-8000-000000000008',
   'c2000000-0000-4000-8000-000000000001','c3000000-0000-4000-8000-000000000001',
   'c4000000-0000-4000-8000-000000000001','system_worker','2026-08-15T02:00:00Z',
   'PENDING_REVIEW','decision-race-v6',6);

INSERT INTO public.kf_ingestion_command_receipts(
  command_id,fingerprint,correlation_id,operation,run_id,aggregate_version,sequence,previous_state,state
) VALUES
  ('d7000000-0000-4000-8000-000000000070',repeat('a',64),'c5000000-0000-4000-8000-000000000070',
   'confirm_verified','c1000000-0000-4000-8000-000000000007','same-review-v5',5,'VERIFYING','VERIFIED'),
  ('d8000000-0000-4000-8000-000000000080',repeat('b',64),'c5000000-0000-4000-8000-000000000080',
   'request_review','c1000000-0000-4000-8000-000000000008','decision-race-v6',6,'VERIFIED','PENDING_REVIEW');

INSERT INTO public.kf_ingestion_events(
  event_id,event_type,run_id,aggregate_version,sequence,actor_id,actor_role,
  reason,occurred_at,correlation_id,command_id,from_state,to_state
) VALUES
  ('e7000000-0000-4000-8000-000000000070','ingestion_verified',
   'c1000000-0000-4000-8000-000000000007','same-review-v5',5,
   'c4000000-0000-4000-8000-000000000001','system_worker','synthetic concurrency verified fixture',
   '2026-08-15T02:05:00Z','c5000000-0000-4000-8000-000000000070',
   'd7000000-0000-4000-8000-000000000070','VERIFYING','VERIFIED'),
  ('e8000000-0000-4000-8000-000000000080','ingestion_review_requested',
   'c1000000-0000-4000-8000-000000000008','decision-race-v6',6,
   'c4000000-0000-4000-8000-000000000001','system_worker','synthetic decision race fixture',
   '2026-08-15T02:06:00Z','c5000000-0000-4000-8000-000000000080',
   'd8000000-0000-4000-8000-000000000080','VERIFIED','PENDING_REVIEW');

INSERT INTO public.kf_ingestion_staging_artifacts(
  artifact_id,run_id,source_version_id,received_file_id,state,size_bytes,media_type,
  created_at,expires_at,opaque_locator,write_digest_algorithm,write_digest_value,correlation_id
) VALUES
  ('c7000000-0000-4000-8000-000000000007','c1000000-0000-4000-8000-000000000007',
   'c2000000-0000-4000-8000-000000000001','c3000000-0000-4000-8000-000000000001',
   'VERIFIED',12,'application/pdf','2026-08-15T02:00:00Z','2026-08-15T08:00:00Z',
   'temporary-staging:v1:c1000000-0000-4000-8000-000000000007:c7000000-0000-4000-8000-000000000007',
   'sha-256',repeat('c',64),'c5000000-0000-4000-8000-000000000070'),
  ('c7000000-0000-4000-8000-000000000008','c1000000-0000-4000-8000-000000000008',
   'c2000000-0000-4000-8000-000000000001','c3000000-0000-4000-8000-000000000001',
   'VERIFIED',13,'application/pdf','2026-08-15T02:00:00Z','2026-08-15T08:00:00Z',
   'temporary-staging:v1:c1000000-0000-4000-8000-000000000008:c7000000-0000-4000-8000-000000000008',
   'sha-256',repeat('d',64),'c5000000-0000-4000-8000-000000000080');

INSERT INTO public.kf_ingestion_integrity_evidence(
  artifact_id,run_id,source_version_id,received_file_id,digest_algorithm,digest_value,
  byte_length,verified_at,correlation_id,duplicate_decision
) VALUES
  ('c7000000-0000-4000-8000-000000000007','c1000000-0000-4000-8000-000000000007',
   'c2000000-0000-4000-8000-000000000001','c3000000-0000-4000-8000-000000000001',
   'sha-256',repeat('e',64),12,'2026-08-15T02:04:00Z','c5000000-0000-4000-8000-000000000070',
   jsonb_build_object('contractVersion','1.0.0','outcome','unique','matches',jsonb_build_array())),
  ('c7000000-0000-4000-8000-000000000008','c1000000-0000-4000-8000-000000000008',
   'c2000000-0000-4000-8000-000000000001','c3000000-0000-4000-8000-000000000001',
   'sha-256',repeat('f',64),13,'2026-08-15T02:05:00Z','c5000000-0000-4000-8000-000000000080',
   jsonb_build_object('contractVersion','1.0.0','outcome','unique','matches',jsonb_build_array()));