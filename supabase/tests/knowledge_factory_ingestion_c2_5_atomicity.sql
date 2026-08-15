\set ON_ERROR_STOP on

-- Synthetic C.2.5 rollback proof. It deliberately faults after the run update
-- and receipt insert path has begun, then verifies that PostgreSQL rolled back
-- the whole human decision transaction.

INSERT INTO public.kf_source_identities(id,kind)
VALUES ('c1000000-0000-4000-8000-000000000006','processing_run');
INSERT INTO public.kf_ingestion_runs(
  run_id,request_id,source_version_id,received_file_id,
  requested_by_actor_id,requested_by_actor_role,requested_at,
  state,aggregate_version,sequence
) VALUES (
  'c1000000-0000-4000-8000-000000000006','c6000000-0000-4000-8000-000000000006',
  'c2000000-0000-4000-8000-000000000001','c3000000-0000-4000-8000-000000000001',
  'c4000000-0000-4000-8000-000000000001','system_worker','2026-08-15T01:40:00Z',
  'PENDING_REVIEW','atomic-fixture-v6',6
);
INSERT INTO public.kf_ingestion_command_receipts(
  command_id,fingerprint,correlation_id,operation,run_id,aggregate_version,sequence,previous_state,state
) VALUES (
  'd6000000-0000-4000-8000-000000000060',repeat('a',64),
  'c5000000-0000-4000-8000-000000000060','request_review',
  'c1000000-0000-4000-8000-000000000006','atomic-fixture-v6',6,'VERIFIED','PENDING_REVIEW'
);
INSERT INTO public.kf_ingestion_events(
  event_id,event_type,run_id,aggregate_version,sequence,actor_id,actor_role,
  reason,occurred_at,correlation_id,command_id,from_state,to_state
) VALUES (
  'e6000000-0000-4000-8000-000000000060','ingestion_review_requested',
  'c1000000-0000-4000-8000-000000000006','atomic-fixture-v6',6,
  'c4000000-0000-4000-8000-000000000001','system_worker','synthetic pending review fixture',
  '2026-08-15T01:54:00Z','c5000000-0000-4000-8000-000000000060',
  'd6000000-0000-4000-8000-000000000060','VERIFIED','PENDING_REVIEW'
);
INSERT INTO public.kf_ingestion_staging_artifacts(
  artifact_id,run_id,source_version_id,received_file_id,state,size_bytes,media_type,
  created_at,expires_at,opaque_locator,write_digest_algorithm,write_digest_value,correlation_id
) VALUES (
  'c7000000-0000-4000-8000-000000000006','c1000000-0000-4000-8000-000000000006',
  'c2000000-0000-4000-8000-000000000001','c3000000-0000-4000-8000-000000000001',
  'VERIFIED',11,'application/pdf','2026-08-15T01:40:00Z','2026-08-15T07:40:00Z',
  'temporary-staging:v1:c1000000-0000-4000-8000-000000000006:c7000000-0000-4000-8000-000000000006',
  'sha-256',repeat('a',64),'c5000000-0000-4000-8000-000000000060'
);
INSERT INTO public.kf_ingestion_integrity_evidence(
  artifact_id,run_id,source_version_id,received_file_id,digest_algorithm,digest_value,
  byte_length,verified_at,correlation_id,duplicate_decision
) VALUES (
  'c7000000-0000-4000-8000-000000000006','c1000000-0000-4000-8000-000000000006',
  'c2000000-0000-4000-8000-000000000001','c3000000-0000-4000-8000-000000000001',
  'sha-256',repeat('b',64),11,'2026-08-15T01:53:00Z','c5000000-0000-4000-8000-000000000060',
  jsonb_build_object('contractVersion','1.0.0','outcome','unique','matches',jsonb_build_array())
);

CREATE OR REPLACE FUNCTION public.kf_c25_test_fail_approval_event()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $function$
BEGIN
  IF NEW.event_type = 'ingestion_approved_for_extraction' THEN
    RAISE EXCEPTION USING ERRCODE = 'P0001', MESSAGE = 'synthetic C.2.5 event write failure';
  END IF;
  RETURN NEW;
END;
$function$;

CREATE TRIGGER kf_c25_test_fail_approval_event
BEFORE INSERT ON public.kf_ingestion_events
FOR EACH ROW EXECUTE FUNCTION public.kf_c25_test_fail_approval_event();

DO $atomicity$
DECLARE
  v_command jsonb;
  v_fp text;
BEGIN
  v_command := jsonb_build_object(
    'commandType','approve_for_extraction',
    'actor',jsonb_build_object('actorId','c4100000-0000-4000-8000-000000000001','role','legal_editorial_reviewer'),
    'occurredAt','2026-08-15T01:55:00Z','correlationId','c5000000-0000-4000-8000-000000000061',
    'reason','synthetic atomicity approval',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000006'),
    'expectedState','PENDING_REVIEW','expectedVersion','atomic-fixture-v6','expectedSequence',6,
    'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000001'),
    'review',jsonb_build_object(
      'reviewId','c8000000-0000-4000-8000-000000000060','reviewMode','human',
      'reviewer',jsonb_build_object('actorId','c4100000-0000-4000-8000-000000000001','role','legal_editorial_reviewer'),
      'decision','APPROVE_FOR_EXTRACTION','decidedAt','2026-08-15T01:55:00Z','reason','synthetic rollback proof'
    ),
    'authorizationEvidence',jsonb_build_array(jsonb_build_object(
      'authorizationId','cf000000-0000-4000-8000-000000000005',
      'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000001'),
      'purpose','extraction','evaluatedAt','2026-08-15T01:55:00Z'
    ))
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('approve_for_extraction',v_command);

  BEGIN
    PERFORM * FROM public.kf_ingestion_approve_for_extraction(
      'd6000000-0000-4000-8000-000000000061',v_fp,v_command
    );
    RAISE EXCEPTION 'synthetic partial failure did not fire';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN NULL;
  END;

  IF NOT EXISTS (
    SELECT 1 FROM public.kf_ingestion_runs
    WHERE run_id='c1000000-0000-4000-8000-000000000006'
      AND state='PENDING_REVIEW' AND aggregate_version='atomic-fixture-v6' AND sequence=6
  ) THEN
    RAISE EXCEPTION 'run update survived a failed approval transaction';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.kf_ingestion_command_receipts
    WHERE command_id='d6000000-0000-4000-8000-000000000061'
  ) THEN
    RAISE EXCEPTION 'approval receipt survived a failed approval transaction';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.kf_ingestion_events
    WHERE review_id='c8000000-0000-4000-8000-000000000060'
  ) THEN
    RAISE EXCEPTION 'human review evidence survived a failed approval transaction';
  END IF;
END;
$atomicity$;

DROP TRIGGER kf_c25_test_fail_approval_event ON public.kf_ingestion_events;
DROP FUNCTION public.kf_c25_test_fail_approval_event();

SELECT 'OK:knowledge_factory_ingestion_c2_5_atomicity' AS result;