-- =============================================================================
-- ProfePlan Knowledge Factory - Sublote C.3.4
-- Incremental extraction persistence, replay safety and reconciliation.
-- Synthetic/disposable validation only. No OCR, embeddings, chunks or production.
-- =============================================================================

BEGIN;

CREATE TABLE public.kf_extraction_batches (
  batch_id uuid PRIMARY KEY,
  run_id uuid NOT NULL REFERENCES public.kf_extraction_runs(run_id) ON DELETE RESTRICT,
  batch_sequence bigint NOT NULL CHECK (batch_sequence > 0),
  fingerprint text NOT NULL CHECK (fingerprint ~ '^[0-9a-f]{64}$'),
  first_page integer NOT NULL CHECK (first_page > 0),
  last_page integer NOT NULL CHECK (last_page >= first_page),
  page_count integer NOT NULL CHECK (page_count > 0),
  committed_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  CONSTRAINT kf_extraction_batches_run_sequence_key UNIQUE(run_id, batch_sequence)
);

CREATE INDEX kf_extraction_batches_run_idx
  ON public.kf_extraction_batches(run_id, batch_sequence);

CREATE TABLE public.kf_extraction_pages (
  run_id uuid NOT NULL REFERENCES public.kf_extraction_runs(run_id) ON DELETE RESTRICT,
  physical_page_number integer NOT NULL CHECK (physical_page_number > 0),
  batch_id uuid NOT NULL REFERENCES public.kf_extraction_batches(batch_id) ON DELETE RESTRICT,
  outcome text NOT NULL CHECK (outcome IN ('extracted','empty','rejected','pending','discarded')),
  text_content text,
  method_name text NOT NULL CHECK (btrim(method_name) <> ''),
  method_version text NOT NULL CHECK (btrim(method_version) <> ''),
  recorded_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  PRIMARY KEY(run_id, physical_page_number),
  CONSTRAINT kf_extraction_pages_empty_shape_check CHECK (
    outcome <> 'empty' OR text_content IS NULL OR btrim(text_content) = ''
  )
);

CREATE INDEX kf_extraction_pages_batch_idx
  ON public.kf_extraction_pages(batch_id, physical_page_number);

CREATE TABLE public.kf_extraction_elements (
  run_id uuid NOT NULL,
  physical_page_number integer NOT NULL,
  element_ordinal integer NOT NULL CHECK (element_ordinal > 0),
  batch_id uuid NOT NULL REFERENCES public.kf_extraction_batches(batch_id) ON DELETE RESTRICT,
  logical_locator text NOT NULL CHECK (btrim(logical_locator) <> ''),
  kind text NOT NULL CHECK (
    kind IN (
      'text_block','header','footer','note','box','column','table',
      'image_marker','chart_marker','map_marker','infographic_marker'
    )
  ),
  text_content text,
  recorded_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  PRIMARY KEY(run_id, physical_page_number, element_ordinal),
  CONSTRAINT kf_extraction_elements_page_fk FOREIGN KEY(run_id, physical_page_number)
    REFERENCES public.kf_extraction_pages(run_id, physical_page_number) ON DELETE RESTRICT,
  CONSTRAINT kf_extraction_elements_locator_key UNIQUE(run_id, logical_locator)
);

CREATE INDEX kf_extraction_elements_batch_idx
  ON public.kf_extraction_elements(batch_id, physical_page_number, element_ordinal);

CREATE TRIGGER kf_extraction_batches_append_only
BEFORE UPDATE OR DELETE ON public.kf_extraction_batches
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE TRIGGER kf_extraction_pages_append_only
BEFORE UPDATE OR DELETE ON public.kf_extraction_pages
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE TRIGGER kf_extraction_elements_append_only
BEFORE UPDATE OR DELETE ON public.kf_extraction_elements
FOR EACH ROW EXECUTE FUNCTION public.kf_prevent_append_only_mutation();

CREATE OR REPLACE FUNCTION public.kf_extraction_batch_fingerprint_internal(
  p_run_id uuid,
  p_batch_sequence bigint,
  p_pages jsonb
)
RETURNS text
LANGUAGE sql
IMMUTABLE
SET search_path = pg_catalog, public
AS $function$
  SELECT encode(
    sha256(
      convert_to(
        public.kf_extraction_canonical_json_internal(
          jsonb_build_object(
            'fingerprintVersion', 1,
            'runId', p_run_id,
            'batchSequence', p_batch_sequence,
            'pages', p_pages
          )
        ),
        'UTF8'
      )
    ),
    'hex'
  )
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_commit_batch(
  p_batch_id uuid,
  p_fingerprint text,
  p_run_id uuid,
  p_batch_sequence bigint,
  p_pages jsonb
)
RETURNS TABLE(
  batch_id uuid,
  run_id uuid,
  batch_sequence bigint,
  page_count integer,
  replayed boolean,
  committed_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_run public.kf_extraction_runs%ROWTYPE;
  v_existing public.kf_extraction_batches%ROWTYPE;
  v_page jsonb;
  v_element jsonb;
  v_page_number integer;
  v_outcome text;
  v_text text;
  v_elements jsonb;
  v_first_page integer;
  v_last_page integer;
  v_page_count integer;
  v_expected_fingerprint text;
BEGIN
  IF p_batch_id IS NULL OR p_run_id IS NULL OR p_batch_sequence <= 0 THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'invalid extraction batch identity';
  END IF;
  IF p_fingerprint !~ '^[0-9a-f]{64}$' THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'batch fingerprint must be lowercase SHA-256 hex';
  END IF;
  IF p_pages IS NULL OR jsonb_typeof(p_pages) <> 'array' OR jsonb_array_length(p_pages) = 0 THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'batch pages must be a non-empty JSON array';
  END IF;

  v_expected_fingerprint := public.kf_extraction_batch_fingerprint_internal(
    p_run_id, p_batch_sequence, p_pages
  );
  IF v_expected_fingerprint <> p_fingerprint THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'batch fingerprint mismatch';
  END IF;

  SELECT * INTO v_existing
  FROM public.kf_extraction_batches
  WHERE kf_extraction_batches.batch_id = p_batch_id;
  IF FOUND THEN
    IF v_existing.run_id <> p_run_id
      OR v_existing.batch_sequence <> p_batch_sequence
      OR v_existing.fingerprint <> p_fingerprint THEN
      RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'batchId replay collides with different effect';
    END IF;
    RETURN QUERY SELECT
      v_existing.batch_id,
      v_existing.run_id,
      v_existing.batch_sequence,
      v_existing.page_count,
      true,
      v_existing.committed_at;
    RETURN;
  END IF;

  SELECT * INTO v_run
  FROM public.kf_extraction_runs
  WHERE kf_extraction_runs.run_id = p_run_id
  FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'extraction run was not found';
  END IF;
  IF v_run.state <> 'EXTRACTING' THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'extraction batches require EXTRACTING state';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.kf_extraction_batches
    WHERE kf_extraction_batches.run_id = p_run_id
      AND kf_extraction_batches.batch_sequence = p_batch_sequence
  ) THEN
    RAISE EXCEPTION USING ERRCODE = 'PT409', MESSAGE = 'batch sequence already committed';
  END IF;

  SELECT min((page ->> 'physicalPageNumber')::integer),
         max((page ->> 'physicalPageNumber')::integer),
         count(*)::integer
  INTO v_first_page, v_last_page, v_page_count
  FROM jsonb_array_elements(p_pages) AS item(page);

  INSERT INTO public.kf_extraction_batches(
    batch_id, run_id, batch_sequence, fingerprint, first_page, last_page, page_count
  ) VALUES (
    p_batch_id, p_run_id, p_batch_sequence, p_fingerprint,
    v_first_page, v_last_page, v_page_count
  )
  RETURNING * INTO v_existing;

  FOR v_page IN SELECT value FROM jsonb_array_elements(p_pages)
  LOOP
    PERFORM public.kf_extraction_assert_object_internal(
      v_page,
      ARRAY['physicalPageNumber','outcome','elements'],
      ARRAY['physicalPageNumber','outcome','text','elements'],
      'batch.page'
    );

    BEGIN
      v_page_number := (v_page ->> 'physicalPageNumber')::integer;
    EXCEPTION WHEN invalid_text_representation OR numeric_value_out_of_range THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'physicalPageNumber must be a positive integer';
    END;
    IF v_page_number <= 0 THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'physicalPageNumber must be a positive integer';
    END IF;

    v_outcome := v_page ->> 'outcome';
    IF NOT (v_outcome = ANY(ARRAY['extracted','empty','rejected','pending','discarded'])) THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'page outcome is invalid';
    END IF;
    v_text := CASE WHEN v_page ? 'text' THEN v_page ->> 'text' ELSE NULL END;
    v_elements := v_page -> 'elements';
    IF jsonb_typeof(v_elements) <> 'array' THEN
      RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'page elements must be an array';
    END IF;

    INSERT INTO public.kf_extraction_pages(
      run_id, physical_page_number, batch_id, outcome, text_content, method_name, method_version
    ) VALUES (
      p_run_id, v_page_number, p_batch_id, v_outcome, v_text,
      v_run.method_name, v_run.method_version
    );

    FOR v_element IN SELECT value FROM jsonb_array_elements(v_elements)
    LOOP
      PERFORM public.kf_extraction_assert_object_internal(
        v_element,
        ARRAY['logicalLocator','kind'],
        ARRAY['logicalLocator','kind','text'],
        'batch.page.element'
      );
      IF NOT ((v_element ->> 'kind') = ANY(ARRAY[
        'text_block','header','footer','note','box','column','table',
        'image_marker','chart_marker','map_marker','infographic_marker'
      ])) THEN
        RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'element kind is invalid';
      END IF;

      INSERT INTO public.kf_extraction_elements(
        run_id, physical_page_number, element_ordinal, batch_id,
        logical_locator, kind, text_content
      )
      SELECT
        p_run_id,
        v_page_number,
        coalesce(max(element_ordinal), 0) + 1,
        p_batch_id,
        public.kf_extraction_text_internal(v_element -> 'logicalLocator', 'element.logicalLocator'),
        v_element ->> 'kind',
        CASE WHEN v_element ? 'text' THEN v_element ->> 'text' ELSE NULL END
      FROM public.kf_extraction_elements
      WHERE run_id = p_run_id AND physical_page_number = v_page_number;
    END LOOP;
  END LOOP;

  RETURN QUERY SELECT
    v_existing.batch_id,
    v_existing.run_id,
    v_existing.batch_sequence,
    v_existing.page_count,
    false,
    v_existing.committed_at;
END;
$function$;

CREATE OR REPLACE FUNCTION public.kf_extraction_reconcile(
  p_run_id uuid,
  p_expected_page_count integer
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
SET search_path = pg_catalog, public
AS $function$
DECLARE
  v_recorded integer;
  v_extracted integer;
  v_empty integer;
  v_rejected integer;
  v_pending integer;
  v_discarded integer;
  v_missing jsonb;
BEGIN
  IF p_expected_page_count <= 0 THEN
    RAISE EXCEPTION USING ERRCODE = '22023', MESSAGE = 'expected page count must be positive';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.kf_extraction_runs WHERE run_id = p_run_id) THEN
    RAISE EXCEPTION USING ERRCODE = 'P0002', MESSAGE = 'extraction run was not found';
  END IF;

  SELECT
    count(*)::integer,
    count(*) FILTER (WHERE outcome='extracted')::integer,
    count(*) FILTER (WHERE outcome='empty')::integer,
    count(*) FILTER (WHERE outcome='rejected')::integer,
    count(*) FILTER (WHERE outcome='pending')::integer,
    count(*) FILTER (WHERE outcome='discarded')::integer
  INTO v_recorded,v_extracted,v_empty,v_rejected,v_pending,v_discarded
  FROM public.kf_extraction_pages
  WHERE run_id = p_run_id;

  SELECT coalesce(jsonb_agg(page_number ORDER BY page_number), '[]'::jsonb)
  INTO v_missing
  FROM generate_series(1, p_expected_page_count) AS page_number
  WHERE NOT EXISTS (
    SELECT 1 FROM public.kf_extraction_pages
    WHERE run_id = p_run_id AND physical_page_number = page_number
  );

  RETURN jsonb_build_object(
    'runId', p_run_id,
    'expectedPageCount', p_expected_page_count,
    'recordedPageCount', v_recorded,
    'extracted', v_extracted,
    'empty', v_empty,
    'rejected', v_rejected,
    'pending', v_pending,
    'discarded', v_discarded,
    'missingPageNumbers', v_missing,
    'complete', v_recorded = p_expected_page_count AND jsonb_array_length(v_missing) = 0
  );
END;
$function$;

ALTER TABLE public.kf_extraction_batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_extraction_pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kf_extraction_elements ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.kf_extraction_batches FROM PUBLIC, anon, authenticated, service_role;
REVOKE ALL ON TABLE public.kf_extraction_pages FROM PUBLIC, anon, authenticated, service_role;
REVOKE ALL ON TABLE public.kf_extraction_elements FROM PUBLIC, anon, authenticated, service_role;

REVOKE ALL ON FUNCTION public.kf_extraction_batch_fingerprint_internal(uuid,bigint,jsonb)
  FROM PUBLIC, anon, authenticated, service_role;
REVOKE ALL ON FUNCTION public.kf_extraction_commit_batch(uuid,text,uuid,bigint,jsonb)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.kf_extraction_reconcile(uuid,integer)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.kf_extraction_commit_batch(uuid,text,uuid,bigint,jsonb)
  TO service_role;
GRANT EXECUTE ON FUNCTION public.kf_extraction_reconcile(uuid,integer)
  TO service_role;

COMMIT;
