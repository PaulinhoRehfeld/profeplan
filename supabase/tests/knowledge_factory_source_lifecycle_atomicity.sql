-- =============================================================================
-- Knowledge Factory C.1.3 - idempotency, CAS, temporal monotonicity and rollback
-- NON-PRODUCTION ONLY. All fixtures are synthetic and rolled back.
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION pg_temp.c13_fingerprint(p_operation text, p_payload jsonb)
RETURNS text LANGUAGE sql IMMUTABLE AS $$
  SELECT encode(sha256(convert_to(jsonb_build_object(
    'fingerprintVersion',1,'operation',p_operation,'payload',p_payload
  )::text,'UTF8')),'hex')
$$;

INSERT INTO public.kf_source_actor_assignments(
  id, actor_id, actor_role, effective_from, effective_until
) VALUES
  ('75300000-0000-4000-8000-000000000001','75310000-0000-4000-8000-000000000001','curator','2026-08-14T00:00:00Z',NULL),
  ('75300000-0000-4000-8000-000000000002','75310000-0000-4000-8000-000000000002','legal_editorial_reviewer','2026-08-14T00:00:00Z',NULL),
  ('75300000-0000-4000-8000-000000000003','75310000-0000-4000-8000-000000000003','curator','2026-08-13T00:00:00Z','2026-08-13T23:59:59Z');

CREATE OR REPLACE FUNCTION public.kf_c13_test_fail_receipt_link()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = pg_catalog, public
AS $$
BEGIN
  IF NEW.command_id = '75340000-0000-4000-8000-000000000010'::uuid
    OR (
      NEW.command_id = '75340000-0000-4000-8000-000000000020'::uuid
      AND NEW.event_order = 2
    ) THEN
    RAISE EXCEPTION 'synthetic C.1.3 late-write failure' USING ERRCODE = 'P0001';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER kf_c13_test_fail_receipt_link
BEFORE INSERT ON public.kf_source_command_receipt_events
FOR EACH ROW EXECUTE FUNCTION public.kf_c13_test_fail_receipt_link();

DO $$
DECLARE
  v_payload jsonb;
  v_payload_changed jsonb;
  v_fp text;
  v_fp_changed text;
  v_version_initial text;
  v_version text;
  v_sequence bigint;
  v_event_ids uuid[];
  v_committed_at timestamptz;
  v_replayed boolean;
  v_state text;
  v_count integer;
  v_subject uuid := '75320000-0000-4000-8000-000000000001';
  v_atomic_subject uuid := '75320000-0000-4000-8000-000000000010';
  v_auth_subject uuid := '75320000-0000-4000-8000-000000000020';
  v_predecessor uuid := '75350000-0000-4000-8000-000000000020';
  v_successor uuid := '75350000-0000-4000-8000-000000000021';
  v_scope jsonb;
  v_basis jsonb := '{"id":"75360000-0000-4000-8000-000000000020","kind":"wrtech_ownership"}'::jsonb;
BEGIN
  -- -------------------------------------------------------------------------
  -- Safe replay: same command/payload produces the persisted receipt only.
  -- -------------------------------------------------------------------------
  v_payload := jsonb_build_object(
    'commandType','register_identity',
    'actor',jsonb_build_object('actorId','75310000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_subject::text,'kind','edition'),
    'occurredAt','2026-08-14T15:00:00Z','effectiveAt','2026-08-14T15:00:00Z',
    'correlationId','75330000-0000-4000-8000-000000000001','reason','idempotent register'
  );
  v_fp := pg_temp.c13_fingerprint('register_identity',v_payload);
  SELECT aggregate_version,sequence,event_ids,committed_at,replayed
    INTO v_version_initial,v_sequence,v_event_ids,v_committed_at,v_replayed
  FROM public.kf_source_register_identity('75340000-0000-4000-8000-000000000001',v_fp,v_payload);
  IF v_replayed OR v_sequence <> 1 THEN RAISE EXCEPTION 'first command unexpectedly replayed'; END IF;

  SELECT aggregate_version,sequence,event_ids,committed_at,replayed
    INTO v_version,v_sequence,v_event_ids,v_committed_at,v_replayed
  FROM public.kf_source_register_identity('75340000-0000-4000-8000-000000000001',v_fp,v_payload);
  IF NOT v_replayed OR v_version <> v_version_initial OR v_sequence <> 1 THEN
    RAISE EXCEPTION 'identical replay did not return persisted logical result';
  END IF;
  SELECT count(*) INTO v_count FROM public.kf_source_governance_events
  WHERE command_id='75340000-0000-4000-8000-000000000001';
  IF v_count <> 1 THEN RAISE EXCEPTION 'replay duplicated governance history'; END IF;

  -- Same commandId with a different canonical command is a conflict.
  v_payload_changed := jsonb_set(v_payload,'{reason}','"different semantic payload"'::jsonb);
  v_fp_changed := pg_temp.c13_fingerprint('register_identity',v_payload_changed);
  BEGIN
    PERFORM * FROM public.kf_source_register_identity(
      '75340000-0000-4000-8000-000000000001',v_fp_changed,v_payload_changed
    );
    RAISE EXCEPTION 'divergent commandId reuse unexpectedly succeeded';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;

  -- Caller cannot lie about the fingerprint even for a structurally valid payload.
  BEGIN
    PERFORM * FROM public.kf_source_register_identity(
      '75340000-0000-4000-8000-000000000002',repeat('0',64),
      jsonb_set(v_payload,'{subject,id}','"75320000-0000-4000-8000-000000000002"'::jsonb)
    );
    RAISE EXCEPTION 'tampered fingerprint unexpectedly succeeded';
  EXCEPTION WHEN invalid_parameter_value THEN NULL;
  END;
  IF EXISTS (SELECT 1 FROM public.kf_source_identities WHERE id='75320000-0000-4000-8000-000000000002') THEN
    RAISE EXCEPTION 'fingerprint failure left an identity behind';
  END IF;

  -- Assignment outside occurredAt is forbidden.
  v_payload_changed := jsonb_set(v_payload,'{actor}','{"actorId":"75310000-0000-4000-8000-000000000003","role":"curator"}'::jsonb);
  v_payload_changed := jsonb_set(v_payload_changed,'{subject,id}','"75320000-0000-4000-8000-000000000003"'::jsonb);
  v_fp_changed := pg_temp.c13_fingerprint('register_identity',v_payload_changed);
  BEGIN
    PERFORM * FROM public.kf_source_register_identity('75340000-0000-4000-8000-000000000003',v_fp_changed,v_payload_changed);
    RAISE EXCEPTION 'expired actor assignment unexpectedly authorized command';
  EXCEPTION WHEN SQLSTATE 'PT403' THEN NULL;
  END;

  -- C.1.3 cannot materialize future processing/derived identity kinds.
  v_payload_changed := jsonb_set(v_payload,'{subject}','{"id":"75320000-0000-4000-8000-000000000004","kind":"processing_run"}'::jsonb);
  v_fp_changed := pg_temp.c13_fingerprint('register_identity',v_payload_changed);
  BEGIN
    PERFORM * FROM public.kf_source_register_identity('75340000-0000-4000-8000-000000000004',v_fp_changed,v_payload_changed);
    RAISE EXCEPTION 'processing_run unexpectedly entered C.1.3';
  EXCEPTION WHEN invalid_parameter_value THEN NULL;
  END;

  -- -------------------------------------------------------------------------
  -- CAS and temporal monotonicity.
  -- -------------------------------------------------------------------------
  v_payload := jsonb_build_object(
    'commandType','request_validation','actor',jsonb_build_object('actorId','75310000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_subject::text,'kind','edition'),
    'expectedState','REGISTERED','expectedVersion',v_version_initial,'expectedSequence',1,
    'occurredAt','2026-08-14T15:01:00Z','effectiveAt','2026-08-14T15:01:00Z',
    'correlationId','75330000-0000-4000-8000-000000000005','reason','request validation for CAS test'
  );
  v_fp := pg_temp.c13_fingerprint('request_validation',v_payload);
  SELECT aggregate_version,sequence INTO v_version,v_sequence
  FROM public.kf_source_request_validation('75340000-0000-4000-8000-000000000005',v_fp,v_payload);

  v_payload_changed := jsonb_build_object(
    'commandType','confirm_validation','actor',jsonb_build_object('actorId','75310000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_subject::text,'kind','edition'),
    'expectedState','REGISTERED','expectedVersion',v_version_initial,'expectedSequence',1,
    'occurredAt','2026-08-14T15:02:00Z','effectiveAt','2026-08-14T15:02:00Z',
    'correlationId','75330000-0000-4000-8000-000000000006','reason','stale CAS must fail'
  );
  v_fp_changed := pg_temp.c13_fingerprint('confirm_validation',v_payload_changed);
  BEGIN
    PERFORM * FROM public.kf_source_confirm_validation('75340000-0000-4000-8000-000000000006',v_fp_changed,v_payload_changed);
    RAISE EXCEPTION 'stale CAS unexpectedly succeeded';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;
  IF EXISTS (SELECT 1 FROM public.kf_source_command_receipts WHERE command_id='75340000-0000-4000-8000-000000000006') THEN
    RAISE EXCEPTION 'stale CAS persisted a receipt';
  END IF;

  v_payload := jsonb_build_object(
    'commandType','confirm_validation','actor',jsonb_build_object('actorId','75310000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_subject::text,'kind','edition'),
    'expectedState','PENDING_VALIDATION','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T15:03:00Z','effectiveAt','2026-08-14T15:03:00Z',
    'correlationId','75330000-0000-4000-8000-000000000007','reason','valid confirmation after stale attempt'
  );
  v_fp := pg_temp.c13_fingerprint('confirm_validation',v_payload);
  SELECT aggregate_version,sequence,state INTO v_version,v_sequence,v_state
  FROM public.kf_source_confirm_validation('75340000-0000-4000-8000-000000000007',v_fp,v_payload);

  v_payload_changed := jsonb_build_object(
    'commandType','block_source','actor',jsonb_build_object('actorId','75310000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_subject::text,'kind','edition'),
    'expectedState','VALIDATED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T15:02:30Z','effectiveAt','2026-08-14T15:02:30Z',
    'correlationId','75330000-0000-4000-8000-000000000008','reason','retroactive transition must fail'
  );
  v_fp_changed := pg_temp.c13_fingerprint('block_source',v_payload_changed);
  BEGIN
    PERFORM * FROM public.kf_source_block('75340000-0000-4000-8000-000000000008',v_fp_changed,v_payload_changed);
    RAISE EXCEPTION 'temporal regression unexpectedly succeeded';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;
  SELECT projected_state INTO v_state FROM public.kf_source_registration_projections WHERE subject_identity_id=v_subject;
  IF v_state <> 'VALIDATED' THEN RAISE EXCEPTION 'temporal conflict partially mutated projection'; END IF;

  -- -------------------------------------------------------------------------
  -- Late-write fault injection: registration must rollback every prior write.
  -- -------------------------------------------------------------------------
  v_payload := jsonb_build_object(
    'commandType','register_identity','actor',jsonb_build_object('actorId','75310000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_atomic_subject::text,'kind','manifestation'),
    'occurredAt','2026-08-14T15:10:00Z','effectiveAt','2026-08-14T15:10:00Z',
    'correlationId','75330000-0000-4000-8000-000000000010','reason','force rollback after receipt and event'
  );
  v_fp := pg_temp.c13_fingerprint('register_identity',v_payload);
  BEGIN
    PERFORM * FROM public.kf_source_register_identity('75340000-0000-4000-8000-000000000010',v_fp,v_payload);
    RAISE EXCEPTION 'fault-injected register unexpectedly committed';
  EXCEPTION WHEN raise_exception THEN NULL;
  END;
  IF EXISTS (SELECT 1 FROM public.kf_source_identities WHERE id=v_atomic_subject)
    OR EXISTS (SELECT 1 FROM public.kf_source_registration_projections WHERE subject_identity_id=v_atomic_subject)
    OR EXISTS (SELECT 1 FROM public.kf_source_command_receipts WHERE command_id='75340000-0000-4000-8000-000000000010')
    OR EXISTS (SELECT 1 FROM public.kf_source_governance_events WHERE command_id='75340000-0000-4000-8000-000000000010') THEN
    RAISE EXCEPTION 'late registration failure left partial C.1.3 state';
  END IF;

  -- -------------------------------------------------------------------------
  -- Prepare validated subject and predecessor for supersession rollback proof.
  -- -------------------------------------------------------------------------
  v_payload := jsonb_build_object(
    'commandType','register_identity','actor',jsonb_build_object('actorId','75310000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_auth_subject::text,'kind','source_version'),
    'occurredAt','2026-08-14T16:00:00Z','effectiveAt','2026-08-14T16:00:00Z',
    'correlationId','75330000-0000-4000-8000-000000000020','reason','register supersession rollback subject'
  );
  v_fp := pg_temp.c13_fingerprint('register_identity',v_payload);
  SELECT aggregate_version,sequence INTO v_version,v_sequence FROM public.kf_source_register_identity('75340000-0000-4000-8000-000000000021',v_fp,v_payload);

  v_payload := jsonb_build_object(
    'commandType','request_validation','actor',jsonb_build_object('actorId','75310000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_auth_subject::text,'kind','source_version'),
    'expectedState','REGISTERED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T16:01:00Z','effectiveAt','2026-08-14T16:01:00Z',
    'correlationId','75330000-0000-4000-8000-000000000021','reason','request validation'
  );
  v_fp := pg_temp.c13_fingerprint('request_validation',v_payload);
  SELECT aggregate_version,sequence INTO v_version,v_sequence FROM public.kf_source_request_validation('75340000-0000-4000-8000-000000000022',v_fp,v_payload);

  v_payload := jsonb_build_object(
    'commandType','confirm_validation','actor',jsonb_build_object('actorId','75310000-0000-4000-8000-000000000001','role','curator'),
    'subject',jsonb_build_object('id',v_auth_subject::text,'kind','source_version'),
    'expectedState','PENDING_VALIDATION','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T16:02:00Z','effectiveAt','2026-08-14T16:02:00Z',
    'correlationId','75330000-0000-4000-8000-000000000022','reason','confirm validation'
  );
  v_fp := pg_temp.c13_fingerprint('confirm_validation',v_payload);
  PERFORM * FROM public.kf_source_confirm_validation('75340000-0000-4000-8000-000000000023',v_fp,v_payload);

  v_scope := jsonb_build_object('subject',jsonb_build_object('id',v_auth_subject::text,'kind','source_version'),'purpose','retrieval');
  v_payload := jsonb_build_object(
    'commandType','grant_authorization','actor',jsonb_build_object('actorId','75310000-0000-4000-8000-000000000002','role','legal_editorial_reviewer'),
    'authorizationId',v_predecessor::text,'scope',v_scope,'basis',v_basis,
    'effectiveFrom','2026-08-14T16:03:00Z','occurredAt','2026-08-14T16:03:00Z','effectiveAt','2026-08-14T16:03:00Z',
    'correlationId','75330000-0000-4000-8000-000000000023','reason','grant predecessor'
  );
  v_fp := pg_temp.c13_fingerprint('grant_authorization',v_payload);
  SELECT aggregate_version,sequence INTO v_version,v_sequence FROM public.kf_source_grant_authorization('75340000-0000-4000-8000-000000000024',v_fp,v_payload);

  -- Failure on receipt-event order 2 occurs after predecessor update, successor
  -- insert, receipt and both governance events have already been attempted.
  v_payload := jsonb_build_object(
    'commandType','supersede_authorization','actor',jsonb_build_object('actorId','75310000-0000-4000-8000-000000000002','role','legal_editorial_reviewer'),
    'authorizationId',v_predecessor::text,'successorAuthorizationId',v_successor::text,
    'scope',jsonb_build_object('subject',jsonb_build_object('id',v_auth_subject::text,'kind','source_version'),'purpose','generation'),
    'basis',jsonb_build_object('id','75360000-0000-4000-8000-000000000021','kind','open_license','referenceDigest','rollback-successor-basis'),
    'effectiveFrom','2026-08-14T16:04:00Z','expectedState','GRANTED','expectedVersion',v_version,'expectedSequence',v_sequence,
    'occurredAt','2026-08-14T16:04:00Z','effectiveAt','2026-08-14T16:04:00Z',
    'correlationId','75330000-0000-4000-8000-000000000024','reason','force supersession rollback after successor event'
  );
  v_fp := pg_temp.c13_fingerprint('supersede_authorization',v_payload);
  BEGIN
    PERFORM * FROM public.kf_source_supersede_authorization('75340000-0000-4000-8000-000000000020',v_fp,v_payload);
    RAISE EXCEPTION 'fault-injected supersession unexpectedly committed';
  EXCEPTION WHEN raise_exception THEN NULL;
  END;

  IF NOT EXISTS (
    SELECT 1 FROM public.kf_source_authorizations
    WHERE id=v_predecessor AND projected_state='GRANTED' AND sequence=1
      AND superseded_by_authorization_id IS NULL
  ) THEN
    RAISE EXCEPTION 'failed supersession did not restore predecessor projection';
  END IF;
  IF EXISTS (SELECT 1 FROM public.kf_source_authorizations WHERE id=v_successor)
    OR EXISTS (SELECT 1 FROM public.kf_source_command_receipts WHERE command_id='75340000-0000-4000-8000-000000000020')
    OR EXISTS (SELECT 1 FROM public.kf_source_governance_events WHERE command_id='75340000-0000-4000-8000-000000000020')
    OR EXISTS (SELECT 1 FROM public.kf_source_authorization_bases WHERE id='75360000-0000-4000-8000-000000000021') THEN
    RAISE EXCEPTION 'failed supersession left successor, receipt, event or new basis behind';
  END IF;
END;
$$;

DROP TRIGGER kf_c13_test_fail_receipt_link ON public.kf_source_command_receipt_events;
DROP FUNCTION public.kf_c13_test_fail_receipt_link();

ROLLBACK;
