\set ON_ERROR_STOP on

-- Synthetic-only C.3.4 proof. The C.3.2 disposable proof has already left
-- run e100...0001 in EXTRACTING. No PDF bytes or real content are persisted.

DO $test$
DECLARE
  v_run_id uuid := 'e1000000-0000-4000-8000-000000000001';
  v_pages jsonb;
  v_divergent jsonb;
  v_fp text;
  v_result record;
  v_reconcile jsonb;
  v_batches_before bigint;
  v_pages_before bigint;
  v_elements_before bigint;
BEGIN
  IF (SELECT state FROM public.kf_extraction_runs WHERE run_id=v_run_id) <> 'EXTRACTING' THEN
    RAISE EXCEPTION 'C.3.2 prerequisite run is not EXTRACTING';
  END IF;

  v_pages := jsonb_build_array(
    jsonb_build_object(
      'physicalPageNumber',1,
      'outcome','extracted',
      'text','Pagina um sintetica',
      'elements',jsonb_build_array(
        jsonb_build_object('logicalLocator','page:1/text:1','kind','header','text','Titulo sintetico'),
        jsonb_build_object('logicalLocator','page:1/text:2','kind','text_block','text','Pagina um sintetica')
      )
    ),
    jsonb_build_object(
      'physicalPageNumber',2,
      'outcome','empty',
      'text','',
      'elements','[]'::jsonb
    )
  );
  v_fp := public.kf_extraction_batch_fingerprint_internal(v_run_id,1,v_pages);
  SELECT * INTO v_result FROM public.kf_extraction_commit_batch(
    'e8100000-0000-4000-8000-000000000001',v_fp,v_run_id,1,v_pages
  );
  IF v_result.replayed OR v_result.page_count <> 2 THEN
    RAISE EXCEPTION 'first C.3.4 batch did not commit expected pages';
  END IF;

  SELECT * INTO v_result FROM public.kf_extraction_commit_batch(
    'e8100000-0000-4000-8000-000000000001',v_fp,v_run_id,1,v_pages
  );
  IF NOT v_result.replayed OR v_result.page_count <> 2 THEN
    RAISE EXCEPTION 'identical C.3.4 batch replay did not reuse durable effect';
  END IF;
  IF (SELECT count(*) FROM public.kf_extraction_pages WHERE run_id=v_run_id) <> 2
    OR (SELECT count(*) FROM public.kf_extraction_elements WHERE run_id=v_run_id) <> 2 THEN
    RAISE EXCEPTION 'batch replay duplicated pages or elements';
  END IF;

  v_divergent := jsonb_set(v_pages,'{0,text}','"conteudo divergente"'::jsonb);
  BEGIN
    PERFORM * FROM public.kf_extraction_commit_batch(
      'e8100000-0000-4000-8000-000000000001',
      public.kf_extraction_batch_fingerprint_internal(v_run_id,1,v_divergent),
      v_run_id,1,v_divergent
    );
    RAISE EXCEPTION 'divergent batchId replay was accepted';
  EXCEPTION WHEN SQLSTATE 'PT409' THEN NULL;
  END;

  v_pages := jsonb_build_array(
    jsonb_build_object(
      'physicalPageNumber',3,
      'outcome','pending',
      'text','Pagina tres aguardando reconciliacao',
      'elements',jsonb_build_array(
        jsonb_build_object('logicalLocator','page:3/text:1','kind','text_block','text','Pagina tres aguardando reconciliacao')
      )
    )
  );
  v_fp := public.kf_extraction_batch_fingerprint_internal(v_run_id,2,v_pages);
  PERFORM * FROM public.kf_extraction_commit_batch(
    'e8100000-0000-4000-8000-000000000002',v_fp,v_run_id,2,v_pages
  );

  v_reconcile := public.kf_extraction_reconcile(v_run_id,4);
  IF (v_reconcile ->> 'recordedPageCount')::integer <> 3
    OR v_reconcile -> 'missingPageNumbers' <> '[4]'::jsonb
    OR (v_reconcile ->> 'complete')::boolean THEN
    RAISE EXCEPTION 'partial reconciliation did not expose the missing page';
  END IF;

  SELECT count(*) INTO v_batches_before FROM public.kf_extraction_batches WHERE run_id=v_run_id;
  SELECT count(*) INTO v_pages_before FROM public.kf_extraction_pages WHERE run_id=v_run_id;
  SELECT count(*) INTO v_elements_before FROM public.kf_extraction_elements WHERE run_id=v_run_id;

  v_pages := jsonb_build_array(
    jsonb_build_object(
      'physicalPageNumber',3,
      'outcome','extracted',
      'text','duplicate physical page',
      'elements','[]'::jsonb
    )
  );
  v_fp := public.kf_extraction_batch_fingerprint_internal(v_run_id,3,v_pages);
  BEGIN
    PERFORM * FROM public.kf_extraction_commit_batch(
      'e8100000-0000-4000-8000-000000000003',v_fp,v_run_id,3,v_pages
    );
    RAISE EXCEPTION 'duplicate physical page was accepted';
  EXCEPTION WHEN unique_violation THEN NULL;
  END;
  IF (SELECT count(*) FROM public.kf_extraction_batches WHERE run_id=v_run_id) <> v_batches_before
    OR (SELECT count(*) FROM public.kf_extraction_pages WHERE run_id=v_run_id) <> v_pages_before
    OR (SELECT count(*) FROM public.kf_extraction_elements WHERE run_id=v_run_id) <> v_elements_before THEN
    RAISE EXCEPTION 'failed duplicate page batch left partial durable effects';
  END IF;

  v_pages := jsonb_build_array(
    jsonb_build_object(
      'physicalPageNumber',4,
      'outcome','discarded',
      'elements','[]'::jsonb
    )
  );
  v_fp := public.kf_extraction_batch_fingerprint_internal(v_run_id,3,v_pages);
  PERFORM * FROM public.kf_extraction_commit_batch(
    'e8100000-0000-4000-8000-000000000004',v_fp,v_run_id,3,v_pages
  );

  v_reconcile := public.kf_extraction_reconcile(v_run_id,4);
  IF NOT (v_reconcile ->> 'complete')::boolean
    OR v_reconcile -> 'missingPageNumbers' <> '[]'::jsonb
    OR (v_reconcile ->> 'recordedPageCount')::integer <> 4
    OR (v_reconcile ->> 'extracted')::integer <> 1
    OR (v_reconcile ->> 'empty')::integer <> 1
    OR (v_reconcile ->> 'pending')::integer <> 1
    OR (v_reconcile ->> 'discarded')::integer <> 1 THEN
    RAISE EXCEPTION 'final C.3.4 reconciliation counts are inconsistent';
  END IF;

  BEGIN
    UPDATE public.kf_extraction_pages
    SET outcome='rejected'
    WHERE run_id=v_run_id AND physical_page_number=3;
    RAISE EXCEPTION 'append-only page mutation was accepted';
  EXCEPTION WHEN SQLSTATE '55000' THEN NULL;
  END;
END;
$test$;

DO $privileges$
BEGIN
  IF has_table_privilege('service_role','public.kf_extraction_batches','INSERT')
    OR has_table_privilege('service_role','public.kf_extraction_pages','INSERT')
    OR has_table_privilege('service_role','public.kf_extraction_elements','INSERT')
    OR has_table_privilege('service_role','public.kf_extraction_pages','UPDATE') THEN
    RAISE EXCEPTION 'service_role received direct C.3.4 table DML';
  END IF;
  IF NOT has_function_privilege(
    'service_role','public.kf_extraction_commit_batch(uuid,text,uuid,bigint,jsonb)','EXECUTE'
  ) OR NOT has_function_privilege(
    'service_role','public.kf_extraction_reconcile(uuid,integer)','EXECUTE'
  ) THEN
    RAISE EXCEPTION 'service_role is missing narrow C.3.4 RPC execution';
  END IF;
END;
$privileges$;

SELECT 'C.3.4 incremental persistence/reconciliation proof passed' AS result;
