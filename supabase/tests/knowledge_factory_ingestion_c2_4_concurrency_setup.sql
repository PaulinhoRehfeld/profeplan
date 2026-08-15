\set ON_ERROR_STOP on

-- Seed two internally consistent REQUESTED aggregates for real multi-session C.2.4 races.
INSERT INTO public.kf_source_identities(id, kind) VALUES
  ('c1000000-0000-4000-8000-000000000003','processing_run'),
  ('c1000000-0000-4000-8000-000000000004','processing_run');

INSERT INTO public.kf_ingestion_runs(
  run_id,request_id,source_version_id,received_file_id,
  requested_by_actor_id,requested_by_actor_role,requested_at,
  state,aggregate_version,sequence
) VALUES
  ('c1000000-0000-4000-8000-000000000003','c6000000-0000-4000-8000-000000000003',
   'c2000000-0000-4000-8000-000000000001','c3000000-0000-4000-8000-000000000001',
   'c4000000-0000-4000-8000-000000000001','system_worker','2026-08-15T02:00:00Z',
   'REQUESTED','seed-v1-run3',1),
  ('c1000000-0000-4000-8000-000000000004','c6000000-0000-4000-8000-000000000004',
   'c2000000-0000-4000-8000-000000000001','c3000000-0000-4000-8000-000000000001',
   'c4000000-0000-4000-8000-000000000001','system_worker','2026-08-15T02:00:00Z',
   'REQUESTED','seed-v1-run4',1);

INSERT INTO public.kf_ingestion_command_receipts(
  command_id,fingerprint,correlation_id,operation,run_id,aggregate_version,
  sequence,previous_state,state
) VALUES
  ('d3000000-0000-4000-8000-000000000001',repeat('3',64),'c5000000-0000-4000-8000-000000000003',
   'request_ingestion','c1000000-0000-4000-8000-000000000003','seed-v1-run3',1,NULL,'REQUESTED'),
  ('d4000000-0000-4000-8000-000000000001',repeat('4',64),'c5000000-0000-4000-8000-000000000004',
   'request_ingestion','c1000000-0000-4000-8000-000000000004','seed-v1-run4',1,NULL,'REQUESTED');

INSERT INTO public.kf_ingestion_events(
  event_id,event_type,run_id,aggregate_version,sequence,actor_id,actor_role,
  reason,occurred_at,correlation_id,command_id,from_state,to_state
) VALUES
  ('e3000000-0000-4000-8000-000000000001','ingestion_requested','c1000000-0000-4000-8000-000000000003',
   'seed-v1-run3',1,'c4000000-0000-4000-8000-000000000001','system_worker','synthetic concurrency seed',
   '2026-08-15T02:00:00Z','c5000000-0000-4000-8000-000000000003','d3000000-0000-4000-8000-000000000001',NULL,'REQUESTED'),
  ('e4000000-0000-4000-8000-000000000001','ingestion_requested','c1000000-0000-4000-8000-000000000004',
   'seed-v1-run4',1,'c4000000-0000-4000-8000-000000000001','system_worker','synthetic concurrency seed',
   '2026-08-15T02:00:00Z','c5000000-0000-4000-8000-000000000004','d4000000-0000-4000-8000-000000000001',NULL,'REQUESTED');

SELECT 'OK:knowledge_factory_ingestion_c2_4_concurrency_setup' AS result;
