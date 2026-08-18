\set ON_ERROR_STOP on

-- Independent synthetic READY projection used only to prove C.3.2 CAS under
-- two real PostgreSQL sessions. No content bytes or extracted text are stored.

INSERT INTO public.kf_extraction_runs(
  run_id,request_id,source_version_id,ingestion_run_id,ingestion_handoff_event_id,
  reviewed_artifact_id,artifact_sha256,artifact_size_bytes,
  method_kind,method_name,method_version,
  requested_by_actor_id,requested_by_actor_role,requested_at,
  state,aggregate_version,sequence,created_at,updated_at
)
SELECT
  'e1000000-0000-4000-8000-000000000005',
  'e6000000-0000-4000-8000-000000000005',
  source_version_id,ingestion_run_id,ingestion_handoff_event_id,
  reviewed_artifact_id,artifact_sha256,artifact_size_bytes,
  method_kind,method_name,method_version,
  requested_by_actor_id,requested_by_actor_role,'2026-08-15T02:20:00Z',
  'READY','concurrency-v2',2,'2026-08-15T02:20:00Z','2026-08-15T02:20:30Z'
FROM public.kf_extraction_runs
WHERE run_id='e1000000-0000-4000-8000-000000000001';

INSERT INTO public.kf_extraction_command_receipts(
  command_id,fingerprint,correlation_id,operation,run_id,
  aggregate_version,sequence,previous_state,state,reason_code,committed_at
) VALUES
(
  'e7000000-0000-4000-8000-000000000020',repeat('1',64),
  'e5000000-0000-4000-8000-000000000005','request_extraction',
  'e1000000-0000-4000-8000-000000000005','concurrency-v1',1,NULL,'REQUESTED',NULL,
  '2026-08-15T02:20:00Z'
),
(
  'e7000000-0000-4000-8000-000000000021',repeat('2',64),
  'e5000000-0000-4000-8000-000000000005','mark_ready',
  'e1000000-0000-4000-8000-000000000005','concurrency-v2',2,'REQUESTED','READY',NULL,
  '2026-08-15T02:20:30Z'
);

INSERT INTO public.kf_extraction_events(
  event_id,event_type,run_id,aggregate_version,sequence,
  actor_id,actor_role,reason,occurred_at,correlation_id,command_id,
  from_state,to_state,reason_code,recorded_at
) VALUES
(
  'e8000000-0000-4000-8000-000000000020','extraction_requested',
  'e1000000-0000-4000-8000-000000000005','concurrency-v1',1,
  'c4000000-0000-4000-8000-000000000001','system_worker','synthetic concurrency request',
  '2026-08-15T02:20:00Z','e5000000-0000-4000-8000-000000000005',
  'e7000000-0000-4000-8000-000000000020',NULL,'REQUESTED',NULL,'2026-08-15T02:20:00Z'
),
(
  'e8000000-0000-4000-8000-000000000021','extraction_ready',
  'e1000000-0000-4000-8000-000000000005','concurrency-v2',2,
  'c4000000-0000-4000-8000-000000000001','system_worker','synthetic concurrency ready',
  '2026-08-15T02:20:30Z','e5000000-0000-4000-8000-000000000005',
  'e7000000-0000-4000-8000-000000000021','REQUESTED','READY',NULL,'2026-08-15T02:20:30Z'
);

SELECT 'C.3.2 concurrency fixture seeded' AS result;
