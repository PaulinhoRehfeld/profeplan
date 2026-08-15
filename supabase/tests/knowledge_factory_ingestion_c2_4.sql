\set ON_ERROR_STOP on

-- Synthetic-only C.2.4 durable ingestion proof. No hosted or protected content.

INSERT INTO public.kf_source_identities(id, kind) VALUES
  ('c2000000-0000-4000-8000-000000000001', 'source_version'),
  ('c3000000-0000-4000-8000-000000000001', 'received_file'),
  ('c2000000-0000-4000-8000-000000000002', 'source_version'),
  ('c3000000-0000-4000-8000-000000000002', 'received_file');

INSERT INTO public.kf_source_authorization_bases(id, kind)
VALUES ('ce000000-0000-4000-8000-000000000001', 'wrtech_ownership');

INSERT INTO public.kf_source_authorizations(
  id, subject_identity_id, purpose, restrictions, basis_id,
  effective_from, projected_state, aggregate_version, sequence
) VALUES
  ('cf000000-0000-4000-8000-000000000001','c2000000-0000-4000-8000-000000000001','temporary_staging','{}','ce000000-0000-4000-8000-000000000001','2026-08-15T00:00:00Z','GRANTED','auth-v1',1),
  ('cf000000-0000-4000-8000-000000000002','c2000000-0000-4000-8000-000000000001','ingestion','{}','ce000000-0000-4000-8000-000000000001','2026-08-15T00:00:00Z','GRANTED','auth-v1',1),
  ('cf000000-0000-4000-8000-000000000003','c2000000-0000-4000-8000-000000000002','temporary_staging','{}','ce000000-0000-4000-8000-000000000001','2026-08-15T00:00:00Z','GRANTED','auth-v1',1),
  ('cf000000-0000-4000-8000-000000000004','c2000000-0000-4000-8000-000000000002','ingestion','{}','ce000000-0000-4000-8000-000000000001','2026-08-15T00:00:00Z','GRANTED','auth-v1',1);

DO $test$
DECLARE
  v_request jsonb;
  v_command jsonb;
  v_fp text;
  v_result record;
  v_artifact jsonb;
  v_verification jsonb;
  v_snapshot jsonb;
  v_count bigint;
BEGIN
  -- Canonical fingerprint v1 must be deterministic and match the shared JS algorithm.
  v_command := jsonb_build_object(
    'commandType','begin_staging',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T01:40:00.000Z',
    'correlationId','c5000000-0000-4000-8000-000000000001',
    'reason','synthetic C.2.4 SQL test',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000001'),
    'expectedState','REQUESTED'
  );
  IF public.kf_ingestion_command_fingerprint_internal('begin_staging', v_command)
    <> 'fe3a75265f6a30399d14886680419670636f4d17b2600e48e7e17c20e5b54127' THEN
    RAISE EXCEPTION 'canonical fingerprint does not match the C.2.4 v1 vector';
  END IF;

  v_request := jsonb_build_object(
    'commandType','request_ingestion',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T01:39:00.000Z',
    'correlationId','c5000000-0000-4000-8000-000000000001',
    'reason','synthetic request',
    'request',jsonb_build_object(
      'requestId','c6000000-0000-4000-8000-000000000001',
      'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000001'),
      'receivedFile',jsonb_build_object('kind','received_file','id','c3000000-0000-4000-8000-000000000001'),
      'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000001'),
      'requestedBy',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
      'requestedAt','2026-08-15T01:39:00.000Z',
      'authorizationEvidence',jsonb_build_array(
        jsonb_build_object(
          'authorizationId','cf000000-0000-4000-8000-000000000001',
          'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000001'),
          'purpose','temporary_staging','evaluatedAt','2026-08-15T01:39:00.000Z'
        ),
        jsonb_build_object(
          'authorizationId','cf000000-0000-4000-8000-000000000002',
          'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000001'),
          'purpose','ingestion','evaluatedAt','2026-08-15T01:39:00.000Z'
        )
      )
    )
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('request_ingestion',v_request);
  SELECT * INTO v_result FROM public.kf_ingestion_request(
    'd1000000-0000-4000-8000-000000000001',v_fp,v_request
  );
  IF v_result.state <> 'REQUESTED' OR v_result.sequence <> 1 OR v_result.replayed THEN
    RAISE EXCEPTION 'request_ingestion did not create the expected durable run';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.kf_source_identities
    WHERE id='c1000000-0000-4000-8000-000000000001' AND kind='processing_run'
  ) THEN
    RAISE EXCEPTION 'processing_run identity was not created atomically';
  END IF;

  -- Lost response/replay must return the committed receipt without a second event.
  SELECT * INTO v_result FROM public.kf_ingestion_request(
    'd1000000-0000-4000-8000-000000000001',v_fp,v_request
  );
  IF NOT v_result.replayed OR v_result.sequence <> 1 THEN
    RAISE EXCEPTION 'identical request replay did not return the original receipt';
  END IF;
  SELECT count(*) INTO v_count FROM public.kf_ingestion_events
  WHERE command_id='d1000000-0000-4000-8000-000000000001';
  IF v_count <> 1 THEN RAISE EXCEPTION 'replay appended a duplicate event'; END IF;

  -- Same commandId with a divergent canonical command must fail closed.
  BEGIN
    PERFORM * FROM public.kf_ingestion_request(
      'd1000000-0000-4000-8000-000000000001',
      public.kf_ingestion_command_fingerprint_internal(
        'request_ingestion', jsonb_set(v_request,'{reason}','"divergent"'::jsonb)
      ),
      jsonb_set(v_request,'{reason}','"divergent"'::jsonb)
    );
    RAISE EXCEPTION 'expected divergent replay conflict was not raised';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;

  -- REQUESTED -> STAGING.
  v_command := jsonb_build_object(
    'commandType','begin_staging',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T01:40:00.000Z',
    'correlationId','c5000000-0000-4000-8000-000000000001',
    'reason','synthetic C.2.4 SQL test',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000001'),
    'expectedState','REQUESTED'
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('begin_staging',v_command);
  SELECT * INTO v_result FROM public.kf_ingestion_begin_staging(
    'd1000000-0000-4000-8000-000000000002',v_fp,v_command
  );
  IF v_result.state <> 'STAGING' OR v_result.sequence <> 2 THEN
    RAISE EXCEPTION 'begin_staging did not advance atomically';
  END IF;

  -- Durable write intent. No bytes are persisted in PostgreSQL.
  v_artifact := jsonb_build_object(
    'artifactId','c7000000-0000-4000-8000-000000000001',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000001'),
    'sourceVersion',jsonb_build_object('kind','source_version','id','c2000000-0000-4000-8000-000000000001'),
    'receivedFile',jsonb_build_object('kind','received_file','id','c3000000-0000-4000-8000-000000000001'),
    'sizeBytes',21,
    'mediaType','application/pdf',
    'createdAt','2026-08-15T01:40:30.000Z',
    'expiresAt','2026-08-15T07:40:30.000Z',
    'writeIntentDigest',jsonb_build_object('algorithm','sha-256','value',repeat('a',64)),
    'correlationId','c5000000-0000-4000-8000-000000000001'
  );
  v_snapshot := public.kf_ingestion_prepare_staging_artifact(v_artifact);
  IF v_snapshot ->> 'state' <> 'RECEIVING' THEN
    RAISE EXCEPTION 'staging write intent was not durably reserved';
  END IF;
  IF public.kf_ingestion_prepare_staging_artifact(v_artifact) <> v_snapshot THEN
    RAISE EXCEPTION 'identical staging preparation was not idempotent';
  END IF;
  BEGIN
    PERFORM public.kf_ingestion_prepare_staging_artifact(
      jsonb_set(v_artifact,'{writeIntentDigest,value}',to_jsonb(repeat('b',64)))
    );
    RAISE EXCEPTION 'expected divergent staging preparation conflict was not raised';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;

  -- Confirm physical staging and atomically advance the run.
  v_command := jsonb_build_object(
    'commandType','mark_staged',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T01:41:00.000Z',
    'correlationId','c5000000-0000-4000-8000-000000000001',
    'reason','physical staging confirmed',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000001'),
    'expectedState','STAGING',
    'expectedSequence',2,
    'stagingArtifact',jsonb_build_object(
      'artifactId','c7000000-0000-4000-8000-000000000001',
      'opaqueLocator','temporary-staging:v1:c1000000-0000-4000-8000-000000000001:c7000000-0000-4000-8000-000000000001'
    ),
    'technicalMetadata',jsonb_build_object('declaredMediaType','application/pdf','sizeBytes',21)
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('mark_staged',v_command);
  SELECT * INTO v_result FROM public.kf_ingestion_mark_staged(
    'd1000000-0000-4000-8000-000000000003',v_fp,v_command,
    jsonb_build_object(
      'artifact',v_command -> 'stagingArtifact',
      'run',v_artifact -> 'run',
      'sourceVersion',v_artifact -> 'sourceVersion',
      'receivedFile',v_artifact -> 'receivedFile',
      'sizeBytes',21,'mediaType','application/pdf',
      'createdAt','2026-08-15T01:40:30.000Z','expiresAt','2026-08-15T07:40:30.000Z'
    )
  );
  IF v_result.state <> 'STAGED' OR v_result.sequence <> 3 THEN
    RAISE EXCEPTION 'mark_staged did not atomically confirm DB control-plane state';
  END IF;

  -- STAGED -> VERIFYING.
  v_command := jsonb_build_object(
    'commandType','begin_verification',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T01:42:00.000Z',
    'correlationId','c5000000-0000-4000-8000-000000000001',
    'reason','begin integrity readback',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000001'),
    'expectedState','STAGED','expectedSequence',3
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('begin_verification',v_command);
  SELECT * INTO v_result FROM public.kf_ingestion_begin_verification(
    'd1000000-0000-4000-8000-000000000004',v_fp,v_command
  );
  IF v_result.state <> 'VERIFYING' OR v_result.sequence <> 4 THEN
    RAISE EXCEPTION 'begin_verification did not advance';
  END IF;

  -- Evidence + artifact VERIFIED + run VERIFIED + event + receipt are one DB transaction.
  v_command := jsonb_build_object(
    'commandType','confirm_verified',
    'actor',jsonb_build_object('actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'),
    'occurredAt','2026-08-15T01:43:00.000Z',
    'correlationId','c5000000-0000-4000-8000-000000000001',
    'reason','readback SHA-256 confirmed',
    'run',jsonb_build_object('kind','processing_run','id','c1000000-0000-4000-8000-000000000001'),
    'expectedState','VERIFYING','expectedSequence',4,
    'technicalMetadata',jsonb_build_object('declaredMediaType','application/pdf','sizeBytes',21)
  );
  v_verification := jsonb_build_object(
    'artifact',jsonb_build_object(
      'artifactId','c7000000-0000-4000-8000-000000000001',
      'opaqueLocator','temporary-staging:v1:c1000000-0000-4000-8000-000000000001:c7000000-0000-4000-8000-000000000001'
    ),
    'run',v_artifact -> 'run',
    'sourceVersion',v_artifact -> 'sourceVersion',
    'receivedFile',v_artifact -> 'receivedFile',
    'sizeBytes',21,'mediaType','application/pdf',
    'createdAt','2026-08-15T01:40:30.000Z','expiresAt','2026-08-15T07:40:30.000Z',
    'integrity',jsonb_build_object(
      'contractVersion','1.0.0',
      'artifactId','c7000000-0000-4000-8000-000000000001',
      'run',v_artifact -> 'run',
      'sourceVersion',v_artifact -> 'sourceVersion',
      'receivedFile',v_artifact -> 'receivedFile',
      'digest',jsonb_build_object('algorithm','sha-256','value',repeat('f',64)),
      'byteLength',21,
      'verifiedAt','2026-08-15T01:42:30.000Z',
      'correlationId','c5000000-0000-4000-8000-000000000001'
    )
  );
  v_fp := public.kf_ingestion_command_fingerprint_internal('confirm_verified',v_command);
  SELECT * INTO v_result FROM public.kf_ingestion_confirm_verified(
    'd1000000-0000-4000-8000-000000000005',v_fp,v_command,v_verification
  );
  IF v_result.state <> 'VERIFIED' OR v_result.sequence <> 5 THEN
    RAISE EXCEPTION 'confirm_verified did not advance atomically';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.kf_ingestion_integrity_evidence e
    JOIN public.kf_ingestion_staging_artifacts a USING (artifact_id)
    JOIN public.kf_ingestion_runs r ON r.run_id=e.run_id
    WHERE e.artifact_id='c7000000-0000-4000-8000-000000000001'
      AND a.state='VERIFIED' AND r.state='VERIFIED'
      AND e.duplicate_decision ->> 'outcome'='unique'
  ) THEN
    RAISE EXCEPTION 'VERIFIED boundary is partially persisted';
  END IF;
  SELECT * INTO v_result FROM public.kf_ingestion_confirm_verified(
    'd1000000-0000-4000-8000-000000000005',v_fp,v_command,v_verification
  );
  IF NOT v_result.replayed OR v_result.sequence <> 5 THEN
    RAISE EXCEPTION 'confirm_verified lost-response replay failed';
  END IF;

  -- A failed integrity confirmation must roll back every C.2 persistent side effect.
  -- Prepare a second run only through STAGING for a later dedicated rollback assertion.
END;
$test$;

-- RLS / grants: service_role is a narrow RPC executor, not a table writer.
SET ROLE service_role;
DO $security$
BEGIN
  BEGIN
    INSERT INTO public.kf_ingestion_runs(
      run_id,request_id,source_version_id,received_file_id,
      requested_by_actor_id,requested_by_actor_role,requested_at,state,aggregate_version,sequence
    ) VALUES (
      gen_random_uuid(),gen_random_uuid(),
      'c2000000-0000-4000-8000-000000000001','c3000000-0000-4000-8000-000000000001',
      gen_random_uuid(),'system_worker',clock_timestamp(),'REQUESTED','forbidden',1
    );
    RAISE EXCEPTION 'service_role direct ingestion DML unexpectedly succeeded';
  EXCEPTION WHEN insufficient_privilege THEN NULL;
  END;
END;
$security$;
RESET ROLE;

-- No C.2.5 RPC should have been created accidentally.
DO $scope$
BEGIN
  IF to_regprocedure('public.kf_ingestion_request_review(uuid,text,jsonb)') IS NOT NULL
    OR to_regprocedure('public.kf_ingestion_approve_for_extraction(uuid,text,jsonb)') IS NOT NULL THEN
    RAISE EXCEPTION 'C.2.5 command surface leaked into C.2.4';
  END IF;
END;
$scope$;

SELECT 'OK:knowledge_factory_ingestion_c2_4' AS result;
