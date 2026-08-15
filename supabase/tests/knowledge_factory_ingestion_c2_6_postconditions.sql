\set ON_ERROR_STOP on

-- Synthetic C.2.6 closure postconditions after the real disposable adapter E2E.
DO $closure$
DECLARE
  v_handoff jsonb;
  v_count bigint;
BEGIN
  IF (SELECT state FROM public.kf_ingestion_runs
      WHERE run_id='e1000000-0000-4000-8000-000000000001') <> 'APPROVED_FOR_EXTRACTION' THEN
    RAISE EXCEPTION 'C.2.6 successful run did not end APPROVED_FOR_EXTRACTION';
  END IF;

  IF (SELECT sequence FROM public.kf_ingestion_runs
      WHERE run_id='e1000000-0000-4000-8000-000000000001') <> 7 THEN
    RAISE EXCEPTION 'C.2.6 successful run has unexpected sequence';
  END IF;

  v_handoff := public.kf_ingestion_handoff_snapshot(
    'e1000000-0000-4000-8000-000000000001'
  );
  IF v_handoff ->> 'state' <> 'APPROVED_FOR_EXTRACTION'
    OR v_handoff #>> '{review,decision}' <> 'APPROVE_FOR_EXTRACTION'
    OR v_handoff #>> '{extractionAuthorization,purpose}' <> 'extraction'
    OR v_handoff ->> 'reviewedArtifactId' <> 'e5000000-0000-4000-8000-000000000001' THEN
    RAISE EXCEPTION 'C.2.6 persisted handoff evidence is incomplete or inconsistent';
  END IF;

  SELECT count(*) INTO v_count
  FROM public.kf_ingestion_events
  WHERE run_id='e1000000-0000-4000-8000-000000000001'
    AND event_type='ingestion_approved_for_extraction'
    AND review_decision='APPROVE_FOR_EXTRACTION'
    AND extraction_authorization_id='ef000000-0000-4000-8000-000000000003';
  IF v_count <> 1 THEN
    RAISE EXCEPTION 'C.2.6 approval event is not unique and auditable';
  END IF;

  IF (SELECT state FROM public.kf_ingestion_runs
      WHERE run_id='e1000000-0000-4000-8000-000000000002') <> 'CANCELLED' THEN
    RAISE EXCEPTION 'C.2.6 fail-safe run did not end CANCELLED';
  END IF;

  IF (SELECT state FROM public.kf_ingestion_staging_artifacts
      WHERE artifact_id='e5000000-0000-4000-8000-000000000002') <> 'DISCARDED' THEN
    RAISE EXCEPTION 'C.2.6 cancelled artifact lacks persisted discard evidence';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM public.kf_ingestion_staging_artifacts
    WHERE artifact_id='e5000000-0000-4000-8000-000000000002'
      AND discard_requested_at IS NOT NULL
      AND discard_confirmed_at IS NOT NULL
      AND discard_outcome IN ('discarded','already_discarded')
  ) THEN
    RAISE EXCEPTION 'C.2.6 discard receipt is not auditable';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema='public'
      AND table_name LIKE 'kf_ingestion_%'
      AND data_type='bytea'
  ) THEN
    RAISE EXCEPTION 'C.2 permanent ingestion tables contain bytea payload columns';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_proc p
    JOIN pg_catalog.pg_namespace n ON n.oid=p.pronamespace
    WHERE n.nspname='public'
      AND p.proname = ANY(ARRAY[
        'kf_ingestion_start_extraction',
        'kf_ingestion_execute_extraction',
        'kf_ingestion_enqueue_extraction',
        'kf_ingestion_publish_extraction_job',
        'kf_ingestion_create_extraction_job'
      ])
  ) THEN
    RAISE EXCEPTION 'C.3 execution surface leaked into C.2';
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.kf_ingestion_events
    WHERE run_id='e1000000-0000-4000-8000-000000000002'
      AND event_type='ingestion_approved_for_extraction'
  ) THEN
    RAISE EXCEPTION 'cancelled run produced forbidden extraction eligibility';
  END IF;
END;
$closure$;
