\set ON_ERROR_STOP on

-- C.2.4 atomic rollback proof. Assumes knowledge_factory_ingestion_c2_4.sql ran first.

DO $setup$
DECLARE
  v_request jsonb;
  v_command jsonb;
  v_artifact jsonb;
  v_fp text;
BEGIN
  v_request := jsonb_build_object(
    'commandType','request_ingestion',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T01:50:00.000Z',
    'correlationId','c5000000-0000-4000-8000-000000000002',
    'reason','synthetic rollback run',
    'request',jsonb_build_object(
      'requestId','c6000000-0000-4000-8000-000000000002',
      'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000002'),
      'receivedFile',jsonb_build_object('kind','received_file','id','c3000000-0000-4000-8000-000000000002'),
      'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000002'),
      'requestedBy',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
      'requestedAt','2026-08-15T01:50:00.000Z',
      'authorizationEvidence',jsonb_build_array(
        jsonb_build_object(
          'authorizationId','cf000000-0000-4000-8000-000000000003',
          'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000002'),
          'purpose','temporary_staging','evaluatedAt','2026-08-15T01:50:00.000Z'
        ),
        jsonb_build_object(
          'authorizationId','cf000000-0000-4000-8000-000000000004',
          'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000002'),
          'purpose','ingestion','evaluatedAt','2026-08-15T01:50:00.000Z'
        )
      )
    )
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('request_ingestion',v_request);
  PERFORM * FROM public.kf_ingestion_request('d2000000-0000-4000-8000-000000000001',v_fp,v_request);

  v_command := jsonb_build_object(
    'commandType','begin_staging','actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T01:51:00.000Z','correlationId','c5000000-0000-4000-8000-000000000002',
    'reason','rollback begin staging','run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000002'),
    'expectedState','REQUESTED'
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('begin_staging',v_command);
  PERFORM * FROM public.kf_ingestion_begin_staging('d2000000-0000-4000-8000-000000000002',v_fp,v_command);

  v_artifact := jsonb_build_object(
    'artifactId','c7000000-0000-4000-8000-000000000002',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000002'),
    'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000002'),
    'receivedFile',jsonb_build_object('kind','received_file','id','c3000000-0000-4000-8000-000000000002'),
    'sizeBytes',21,'mediaType','application/pdf',
    'createdAt','2026-08-15T01:51:30.000Z','expiresAt','2026-08-15T07:51:30.000Z',
    'writeIntentDigest',jsonb_build_object('algorithm','sha-256','value',repeat('1',64)),
    'correlationId','c5000000-0000-4000-8000-000000000002'
  );
  PERFORM public.kf_ingestion_prepare_staging_artifact(v_artifact);

  v_command := jsonb_build_object(
    'commandType','mark_staged','actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T01:52:00.000Z','correlationId','c5000000-0000-4000-8000-000000000002',
    'reason','rollback mark staged','run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000002'),
    'expectedState','STAGING','expectedSequence',2,
    'stagingArtifact',jsonb_build_object(
      'artifactId','c7000000-0000-4000-8000-000000000002',
      'opaqueLocator','temporary-staging:v1:c1000000-0000-4000-8000-000000000002:c7000000-0000-4000-8000-000000000002'
    )
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('mark_staged',v_command);
  PERFORM * FROM public.kf_ingestion_mark_staged(
    'd2000000-0000-4000-8000-000000000003',v_fp,v_command,
    jsonb_build_object(
      'artifact',v_command -> 'stagingArtifact','run',v_artifact -> 'run',
      'sourceVersion',v_artifact -> 'sourceVersion','receivedFile',v_artifact -> 'receivedFile',
      'sizeBytes',21,'mediaType','application/pdf',
      'createdAt','2026-08-15T01:51:30.000Z','expiresAt','2026-08-15T07:51:30.000Z'
    )
  );

  v_command := jsonb_build_object(
    'commandType','begin_verification','actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T01:53:00.000Z','correlationId','c5000000-0000-4000-8000-000000000002',
    'reason','rollback begin verify','run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000002'),
    'expectedState','STAGED','expectedSequence',3
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('begin_verification',v_command);
  PERFORM * FROM public.kf_ingestion_begin_verification('d2000000-0000-4000-8000-000000000004',v_fp,v_command);
END;
$setup$;

CREATE OR REPLACE FUNCTION public.kf_c2_4_force_receipt_failure()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.command_id = 'd2000000-0000-4000-8000-000000000005'::uuid THEN
    RAISE EXCEPTION USING ERRCODE='23514', MESSAGE='synthetic C.2.4 forced rollback';
  END IF;
  RETURN NEW;
END;
$$;
CREATE TRIGGER kf_c2_4_force_receipt_failure
BEFORE INSERT ON public.kf_ingestion_command_receipts
FOR EACH ROW EXECUTE FUNCTION public.kf_c2_4_force_receipt_failure();

DO $rollback$
DECLARE
  v_command jsonb;
  v_verification jsonb;
  v_fp text;
BEGIN
  v_command := jsonb_build_object(
    'commandType','confirm_verified','actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T01:54:00.000Z','correlationId','c5000000-0000-4000-8000-000000000002',
    'reason','forced rollback confirmation','run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000002'),
    'expectedState','VERIFYING','expectedSequence',4
  );
  v_verification := jsonb_build_object(
    'artifact',jsonb_build_object(
      'artifactId','c7000000-0000-4000-8000-000000000002',
      'opaqueLocator','temporary-staging:v1:c1000000-0000-4000-8000-000000000002:c7000000-0000-4000-8000-000000000002'
    ),
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000002'),
    'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000002'),
    'receivedFile',jsonb_build_object('kind','received_file','id','c3000000-0000-4000-8000-000000000002'),
    'sizeBytes',21,'mediaType','application/pdf',
    'createdAt','2026-08-15T01:51:30.000Z','expiresAt','2026-08-15T07:51:30.000Z',
    'integrity',jsonb_build_object(
      'contractVersion','1.0.0','artifactId','c7000000-0000-4000-8000-000000000002',
      'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000002'),
      'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000002'),
      'receivedFile',jsonb_build_object('kind','received_file','id','c3000000-0000-4000-8000-000000000002'),
      'digest',jsonb_build_object('algorithm','sha-256','value',repeat('2',64)),
      'byteLength',21,'verifiedAt','2026-08-15T01:53:30.000Z',
      'correlationId','c5000000-0000-4000-8000-000000000002'
    )
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('confirm_verified',v_command);
  BEGIN
    PERFORM * FROM public.kf_ingestion_confirm_verified(
      'd2000000-0000-4000-8000-000000000005',v_fp,v_command,v_verification
    );
    RAISE EXCEPTION 'forced rollback did not fail';
  EXCEPTION WHEN check_violation THEN NULL;
  END;

  IF (SELECT state FROM public.kf_ingestion_runs WHERE run_id='c1000000-0000-4000-8000-000000000002') <> 'VERIFYING' THEN
    RAISE EXCEPTION 'run advanced despite rolled back confirm_verified';
  END IF;
  IF (SELECT state FROM public.kf_ingestion_staging_artifacts WHERE artifact_id='c7000000-0000-4000-8000-000000000002') <> 'STAGED' THEN
    RAISE EXCEPTION 'artifact advanced despite rolled back confirm_verified';
  END IF;
  IF EXISTS (SELECT 1 FROM public.kf_ingestion_integrity_evidence WHERE artifact_id='c7000000-0000-4000-8000-000000000002') THEN
    RAISE EXCEPTION 'integrity evidence survived rolled back confirm_verified';
  END IF;
  IF EXISTS (SELECT 1 FROM public.kf_ingestion_command_receipts WHERE command_id='d2000000-0000-4000-8000-000000000005') THEN
    RAISE EXCEPTION 'receipt survived forced rollback';
  END IF;
END;
$rollback$;

DROP TRIGGER kf_c2_4_force_receipt_failure ON public.kf_ingestion_command_receipts;
DROP FUNCTION public.kf_c2_4_force_receipt_failure();

SELECT 'OK:knowledge_factory_ingestion_c2_4_atomicity' AS result;
