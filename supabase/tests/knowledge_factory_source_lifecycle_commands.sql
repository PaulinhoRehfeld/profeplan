-- =============================================================================
-- Knowledge Factory C.1.3 - positive command matrix
-- NON-PRODUCTION ONLY. All fixtures are synthetic and rolled back.
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION pg_temp.c13_fingerprint(p_operation text, p_payload jsonb)
RETURNS text
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT encode(
    sha256(
      convert_to(
        jsonb_build_object(
          'fingerprintVersion', 1,
          'operation', p_operation,
          'payload', p_payload
        )::text,
        'UTF8'
      )
    ),
    'hex'
  )
$$;

INSERT INTO public.kf_source_actor_assignments(
  id, actor_id, actor_role, effective_from
) VALUES
  ('75200000-0000-4000-8000-000000000001','75210000-0000-4000-8000-000000000001','curator','2026-08-14T00:00:00Z'),
  ('75200000-0000-4000-8000-000000000002','75210000-0000-4000-8000-000000000002','legal_editorial_reviewer','2026-08-14T00:00:00Z');

DO $$
DECLARE
  v_payload jsonb;
  v_fp text;
  v_version text;
  v_sequence bigint;
  v_state text;
  v_subject_a uuid := '75220000-0000-4000-8000-000000000001';
  v_successor_b uuid := '75220000-0000-4000-8000-000000000002';
  v_auth_subject uuid := '75220000-0000-4000-8000-000000000010';
  v_auth1 uuid := '75250000-0000-4000-8000-000000000001';
  v_auth2 uuid := '75250000-0000-4000-8000-000000000002';
  v_auth3 uuid := '75250000-0000-4000-8000-000000000003';
  v_scope1 jsonb;
  v_basis1 jsonb := '{"id":"75260000-0000-4000-8000-000000000001","kind":"wrtech_ownership"}'::jsonb;
  v_scope3 jsonb;
  v_basis3 jsonb := '{"id":"75260000-0000-4000-8000-000000000003","kind":"publisher_contract","referenceDigest":"publisher-contract-test-v1"}'::jsonb;
  v_count integer;
  v_event_orders integer[];
BEGIN
  -- -------------------------------------------------------------------------
  -- Registration lifecycle: every one of the six C.1.3 registration commands.
  -- -------------------------------------------------------------------------
  v_payload := jsonb_build_object(
    'commandType','register_identity',
    'actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_subject_a::text,'kind','work'),
    'occurredAt','2026-08-14T12:00:00Z','effectiveAt','2026-08-14T12:00:00Z',
    'correlationId','75230000-0000-4000-8000-000000000001','reason','register work A'
  );
  v_fp := pg_temp.c13_fingerprint('register_identity', v_payload);
  SELECT aggregate_version, sequence, state INTO v_version, v_sequence, v_state
  FROM public.kf_source_register_identity('75240000-0000-4000-8000-000000000001',v_fp,v_payload);
  IF v_state <> 'REGISTERED' OR v_sequence <> 1 THEN RAISE EXCEPTION 'register_identity failed'; END IF;

  v_payload := jsonb_build_object(
    'commandType','request_validation','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_subject_a::text,'kind','work'),
    'expectedState','REGISTERED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T12:01:00Z','effectiveAt','2026-08-14T12:01:00Z',
    'correlationId','75230000-0000-4000-8000-000000000002','reason','request validation A'
  );
  v_fp := pg_temp.c13_fingerprint('request_validation',v_payload);
  SELECT aggregate_version,sequence,state INTO v_version,v_sequence,v_state
  FROM public.kf_source_request_validation('75240000-0000-4000-8000-000000000002',v_fp,v_payload);
  IF v_state <> 'PENDING_VALIDATION' OR v_sequence <> 2 THEN RAISE EXCEPTION 'request_validation failed'; END IF;

  v_payload := jsonb_build_object(
    'commandType','confirm_validation','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_subject_a::text,'kind','work'),
    'expectedState','PENDING_VALIDATION','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T12:02:00Z','effectiveAt','2026-08-14T12:02:00Z',
    'correlationId','75230000-0000-4000-8000-000000000003','reason','confirm validation A'
  );
  v_fp := pg_temp.c13_fingerprint('confirm_validation',v_payload);
  SELECT aggregate_version,sequence,state INTO v_version,v_sequence,v_state
  FROM public.kf_source_confirm_validation('75240000-0000-4000-8000-000000000003',v_fp,v_payload);
  IF v_state <> 'VALIDATED' OR v_sequence <> 3 THEN RAISE EXCEPTION 'confirm_validation failed'; END IF;

  v_payload := jsonb_build_object(
    'commandType','block_source','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_subject_a::text,'kind','work'),
    'expectedState','VALIDATED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T12:03:00Z','effectiveAt','2026-08-14T12:03:00Z',
    'correlationId','75230000-0000-4000-8000-000000000004','reason','block source A'
  );
  v_fp := pg_temp.c13_fingerprint('block_source',v_payload);
  SELECT aggregate_version,sequence,state INTO v_version,v_sequence,v_state
  FROM public.kf_source_block('75240000-0000-4000-8000-000000000004',v_fp,v_payload);
  IF v_state <> 'BLOCKED' OR v_sequence <> 4 THEN RAISE EXCEPTION 'block_source failed'; END IF;

  SELECT array_agg(event_order ORDER BY event_order) INTO v_event_orders
  FROM public.kf_source_command_receipt_events
  WHERE command_id='75240000-0000-4000-8000-000000000004';
  IF v_event_orders <> ARRAY[1,2] THEN RAISE EXCEPTION 'block_source did not atomically append impact'; END IF;

  v_payload := jsonb_build_object(
    'commandType','request_validation','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_subject_a::text,'kind','work'),
    'expectedState','BLOCKED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T12:04:00Z','effectiveAt','2026-08-14T12:04:00Z',
    'correlationId','75230000-0000-4000-8000-000000000005','reason','revalidate blocked source A'
  );
  v_fp := pg_temp.c13_fingerprint('request_validation',v_payload);
  SELECT aggregate_version,sequence,state INTO v_version,v_sequence,v_state
  FROM public.kf_source_request_validation('75240000-0000-4000-8000-000000000005',v_fp,v_payload);

  v_payload := jsonb_build_object(
    'commandType','confirm_validation','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_subject_a::text,'kind','work'),
    'expectedState','PENDING_VALIDATION','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T12:05:00Z','effectiveAt','2026-08-14T12:05:00Z',
    'correlationId','75230000-0000-4000-8000-000000000006','reason','confirm revalidation A'
  );
  v_fp := pg_temp.c13_fingerprint('confirm_validation',v_payload);
  SELECT aggregate_version,sequence,state INTO v_version,v_sequence,v_state
  FROM public.kf_source_confirm_validation('75240000-0000-4000-8000-000000000006',v_fp,v_payload);

  -- Compatible successor exists before replacement.
  v_payload := jsonb_build_object(
    'commandType','register_identity','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_successor_b::text,'kind','work'),
    'occurredAt','2026-08-14T12:05:30Z','effectiveAt','2026-08-14T12:05:30Z',
    'correlationId','75230000-0000-4000-8000-000000000007','reason','register successor B'
  );
  v_fp := pg_temp.c13_fingerprint('register_identity',v_payload);
  PERFORM * FROM public.kf_source_register_identity('75240000-0000-4000-8000-000000000007',v_fp,v_payload);

  v_payload := jsonb_build_object(
    'commandType','replace_source','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_subject_a::text,'kind','work'),
    'successor',jsonb_build_object('id',v_successor_b::text,'kind','work'),
    'expectedState','VALIDATED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T12:06:00Z','effectiveAt','2026-08-14T12:06:00Z',
    'correlationId','75230000-0000-4000-8000-000000000008','reason','replace source A with B'
  );
  v_fp := pg_temp.c13_fingerprint('replace_source',v_payload);
  SELECT aggregate_version,sequence,state INTO v_version,v_sequence,v_state
  FROM public.kf_source_replace('75240000-0000-4000-8000-000000000008',v_fp,v_payload);
  IF v_state <> 'REPLACED' OR v_sequence <> 7 THEN RAISE EXCEPTION 'replace_source failed'; END IF;

  v_payload := jsonb_build_object(
    'commandType','archive_source','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_subject_a::text,'kind','work'),
    'expectedState','REPLACED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T12:07:00Z','effectiveAt','2026-08-14T12:07:00Z',
    'correlationId','75230000-0000-4000-8000-000000000009','reason','archive replaced source A'
  );
  v_fp := pg_temp.c13_fingerprint('archive_source',v_payload);
  SELECT aggregate_version,sequence,state INTO v_version,v_sequence,v_state
  FROM public.kf_source_archive('75240000-0000-4000-8000-000000000009',v_fp,v_payload);
  IF v_state <> 'ARCHIVED' OR v_sequence <> 8 THEN RAISE EXCEPTION 'archive_source failed'; END IF;

  SELECT count(*) INTO v_count FROM public.kf_source_governance_events
  WHERE dimension='impact' AND aggregate_id=v_subject_a;
  IF v_count <> 3 THEN RAISE EXCEPTION 'registration restrictions should have produced exactly three impact events'; END IF;

  -- -------------------------------------------------------------------------
  -- Prepare a validated subject for the authorization command matrix.
  -- -------------------------------------------------------------------------
  v_payload := jsonb_build_object(
    'commandType','register_identity','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_auth_subject::text,'kind','source_version'),
    'occurredAt','2026-08-14T13:00:00Z','effectiveAt','2026-08-14T13:00:00Z',
    'correlationId','75230000-0000-4000-8000-000000000010','reason','register authorization subject'
  );
  v_fp := pg_temp.c13_fingerprint('register_identity',v_payload);
  SELECT aggregate_version,sequence INTO v_version,v_sequence FROM public.kf_source_register_identity('75240000-0000-4000-8000-000000000010',v_fp,v_payload);

  v_payload := jsonb_build_object(
    'commandType','request_validation','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_auth_subject::text,'kind','source_version'),
    'expectedState','REGISTERED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T13:01:00Z','effectiveAt','2026-08-14T13:01:00Z',
    'correlationId','75230000-0000-4000-8000-000000000011','reason','request authorization-subject validation'
  );
  v_fp := pg_temp.c13_fingerprint('request_validation',v_payload);
  SELECT aggregate_version,sequence INTO v_version,v_sequence FROM public.kf_source_request_validation('75240000-0000-4000-8000-000000000011',v_fp,v_payload);

  v_payload := jsonb_build_object(
    'commandType','confirm_validation','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_auth_subject::text,'kind','source_version'),
    'expectedState','PENDING_VALIDATION','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T13:02:00Z','effectiveAt','2026-08-14T13:02:00Z',
    'correlationId','75230000-0000-4000-8000-000000000012','reason','confirm authorization-subject validation'
  );
  v_fp := pg_temp.c13_fingerprint('confirm_validation',v_payload);
  PERFORM * FROM public.kf_source_confirm_validation('75240000-0000-4000-8000-000000000012',v_fp,v_payload);

  v_scope1 := jsonb_build_object(
    'subject',jsonb_build_object('id',v_auth_subject::text,'kind','source_version'),
    'purpose','retrieval','restrictions',jsonb_build_array('internal_only')
  );

  -- grant_authorization
  v_payload := jsonb_build_object(
    'commandType','grant_authorization','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000002','role','legal_editorial_reviewer'),
    'authorizationId',v_auth1::text,'scope',v_scope1,'basis',v_basis1,
    'effectiveFrom','2026-08-14T13:03:00Z','occurredAt','2026-08-14T13:03:00Z','effectiveAt','2026-08-14T13:03:00Z',
    'correlationId','75230000-0000-4000-8000-000000000013','reason','grant retrieval authorization'
  );
  v_fp := pg_temp.c13_fingerprint('grant_authorization',v_payload);
  SELECT aggregate_version,sequence,state INTO v_version,v_sequence,v_state FROM public.kf_source_grant_authorization('75240000-0000-4000-8000-000000000013',v_fp,v_payload);
  IF v_state <> 'GRANTED' OR v_sequence <> 1 THEN RAISE EXCEPTION 'grant_authorization failed'; END IF;

  -- suspend_authorization
  v_payload := jsonb_build_object(
    'commandType','suspend_authorization','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000002','role','legal_editorial_reviewer'),
    'authorizationId',v_auth1::text,'scope',v_scope1,'basis',v_basis1,
    'expectedState','GRANTED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T13:04:00Z','effectiveAt','2026-08-14T13:04:00Z',
    'correlationId','75230000-0000-4000-8000-000000000014','reason','suspend retrieval authorization'
  );
  v_fp := pg_temp.c13_fingerprint('suspend_authorization',v_payload);
  SELECT aggregate_version,sequence,state INTO v_version,v_sequence,v_state FROM public.kf_source_suspend_authorization('75240000-0000-4000-8000-000000000014',v_fp,v_payload);
  IF v_state <> 'SUSPENDED' OR v_sequence <> 2 THEN RAISE EXCEPTION 'suspend_authorization failed'; END IF;

  -- resume_authorization
  v_payload := jsonb_build_object(
    'commandType','resume_authorization','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000002','role','legal_editorial_reviewer'),
    'authorizationId',v_auth1::text,'scope',v_scope1,'basis',v_basis1,
    'expectedState','SUSPENDED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T13:05:00Z','effectiveAt','2026-08-14T13:05:00Z',
    'correlationId','75230000-0000-4000-8000-000000000015','reason','resume retrieval authorization'
  );
  v_fp := pg_temp.c13_fingerprint('resume_authorization',v_payload);
  SELECT aggregate_version,sequence,state INTO v_version,v_sequence,v_state FROM public.kf_source_resume_authorization('75240000-0000-4000-8000-000000000015',v_fp,v_payload);
  IF v_state <> 'GRANTED' OR v_sequence <> 3 THEN RAISE EXCEPTION 'resume_authorization failed'; END IF;

  -- suspend again, then block_purpose from SUSPENDED.
  v_payload := jsonb_build_object(
    'commandType','suspend_authorization','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000002','role','legal_editorial_reviewer'),
    'authorizationId',v_auth1::text,'scope',v_scope1,'basis',v_basis1,
    'expectedState','GRANTED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T13:06:00Z','effectiveAt','2026-08-14T13:06:00Z',
    'correlationId','75230000-0000-4000-8000-000000000016','reason','suspend again before purpose block'
  );
  v_fp := pg_temp.c13_fingerprint('suspend_authorization',v_payload);
  SELECT aggregate_version,sequence INTO v_version,v_sequence FROM public.kf_source_suspend_authorization('75240000-0000-4000-8000-000000000016',v_fp,v_payload);

  v_payload := jsonb_build_object(
    'commandType','block_purpose','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000002','role','legal_editorial_reviewer'),
    'authorizationId',v_auth1::text,'scope',v_scope1,'basis',v_basis1,
    'expectedState','SUSPENDED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T13:07:00Z','effectiveAt','2026-08-14T13:07:00Z',
    'correlationId','75230000-0000-4000-8000-000000000017','reason','block retrieval purpose'
  );
  v_fp := pg_temp.c13_fingerprint('block_purpose',v_payload);
  SELECT aggregate_version,sequence,state INTO v_version,v_sequence,v_state FROM public.kf_source_block_purpose('75240000-0000-4000-8000-000000000017',v_fp,v_payload);
  IF v_state <> 'BLOCKED' OR v_sequence <> 5 THEN RAISE EXCEPTION 'block_purpose failed'; END IF;

  -- supersede_authorization: successor gets a new immutable scope/basis/window.
  v_payload := jsonb_build_object(
    'commandType','supersede_authorization','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000002','role','legal_editorial_reviewer'),
    'authorizationId',v_auth1::text,'successorAuthorizationId',v_auth2::text,
    'scope',jsonb_build_object('subject',jsonb_build_object('id',v_auth_subject::text,'kind','source_version'),'purpose','generation','restrictions',jsonb_build_array('teacher_output_only')),
    'basis',jsonb_build_object('id','75260000-0000-4000-8000-000000000002','kind','open_license','referenceDigest','open-license-test-v2'),
    'effectiveFrom','2026-08-14T13:08:00Z','expectedState','BLOCKED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T13:08:00Z','effectiveAt','2026-08-14T13:08:00Z',
    'correlationId','75230000-0000-4000-8000-000000000018','reason','supersede blocked retrieval grant with generation grant'
  );
  v_fp := pg_temp.c13_fingerprint('supersede_authorization',v_payload);
  SELECT aggregate_version,sequence,state INTO v_version,v_sequence,v_state FROM public.kf_source_supersede_authorization('75240000-0000-4000-8000-000000000018',v_fp,v_payload);
  IF v_state <> 'SUPERSEDED' OR v_sequence <> 6 THEN RAISE EXCEPTION 'supersede_authorization failed'; END IF;

  SELECT array_agg(event_order ORDER BY event_order) INTO v_event_orders FROM public.kf_source_command_receipt_events
  WHERE command_id='75240000-0000-4000-8000-000000000018';
  IF v_event_orders <> ARRAY[1,2,3] THEN RAISE EXCEPTION 'supersede_authorization event order is not predecessor/successor/impact'; END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.kf_source_authorizations
    WHERE id=v_auth1 AND projected_state='SUPERSEDED' AND superseded_by_authorization_id=v_auth2
  ) OR NOT EXISTS (
    SELECT 1 FROM public.kf_source_authorizations
    WHERE id=v_auth2 AND projected_state='GRANTED' AND sequence=1 AND purpose='generation'
  ) THEN
    RAISE EXCEPTION 'supersession did not atomically preserve predecessor and create successor';
  END IF;

  -- A separate authorization exercises revoke_authorization.
  v_scope3 := jsonb_build_object(
    'subject',jsonb_build_object('id',v_auth_subject::text,'kind','source_version'),
    'purpose','quotation'
  );
  v_payload := jsonb_build_object(
    'commandType','grant_authorization','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000002','role','legal_editorial_reviewer'),
    'authorizationId',v_auth3::text,'scope',v_scope3,'basis',v_basis3,
    'effectiveFrom','2026-08-14T13:09:00Z','occurredAt','2026-08-14T13:09:00Z','effectiveAt','2026-08-14T13:09:00Z',
    'correlationId','75230000-0000-4000-8000-000000000019','reason','grant quotation authorization'
  );
  v_fp := pg_temp.c13_fingerprint('grant_authorization',v_payload);
  SELECT aggregate_version,sequence INTO v_version,v_sequence FROM public.kf_source_grant_authorization('75240000-0000-4000-8000-000000000019',v_fp,v_payload);

  v_payload := jsonb_build_object(
    'commandType','revoke_authorization','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000002','role','legal_editorial_reviewer'),
    'authorizationId',v_auth3::text,'scope',v_scope3,'basis',v_basis3,
    'expectedState','GRANTED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T13:10:00Z','effectiveAt','2026-08-14T13:10:00Z',
    'correlationId','75230000-0000-4000-8000-000000000020','reason','revoke quotation authorization'
  );
  v_fp := pg_temp.c13_fingerprint('revoke_authorization',v_payload);
  SELECT state INTO v_state FROM public.kf_source_revoke_authorization('75240000-0000-4000-8000-000000000020',v_fp,v_payload);
  IF v_state <> 'REVOKED' THEN RAISE EXCEPTION 'revoke_authorization failed'; END IF;

  -- Explicit impact assessment by a competent reviewer.
  v_payload := jsonb_build_object(
    'commandType','open_impact_assessment','actor',jsonb_build_object('actorId','75210000-0000-4000-8000-000000000002','role','legal_editorial_reviewer'),
    'subject',jsonb_build_object('id',v_auth_subject::text,'kind','source_version'),
    'triggeringAuthorizationId',v_auth3::text,
    'occurredAt','2026-08-14T13:11:00Z','effectiveAt','2026-08-14T13:11:00Z',
    'correlationId','75230000-0000-4000-8000-000000000021','reason','manual impact review'
  );
  v_fp := pg_temp.c13_fingerprint('open_impact_assessment',v_payload);
  SELECT sequence,state INTO v_sequence,v_state FROM public.kf_source_open_impact_assessment('75240000-0000-4000-8000-000000000021',v_fp,v_payload);
  IF v_sequence <> 6 OR v_state IS NOT NULL THEN RAISE EXCEPTION 'open_impact_assessment failed or returned a state'; END IF;

  SELECT count(*) INTO v_count FROM public.kf_source_governance_events
  WHERE dimension='impact' AND aggregate_id=v_auth_subject;
  IF v_count <> 6 THEN RAISE EXCEPTION 'authorization lifecycle should have six impact events, found %',v_count; END IF;

  -- Every command receipt must have at least one deterministically ordered event.
  IF EXISTS (
    SELECT 1 FROM public.kf_source_command_receipts r
    WHERE r.command_id::text LIKE '75240000-0000-4000-8000-%'
      AND NOT EXISTS (
        SELECT 1 FROM public.kf_source_command_receipt_events re WHERE re.command_id=r.command_id
      )
  ) THEN
    RAISE EXCEPTION 'a C.1.3 command receipt was persisted without event linkage';
  END IF;
END;
$$;

ROLLBACK;
