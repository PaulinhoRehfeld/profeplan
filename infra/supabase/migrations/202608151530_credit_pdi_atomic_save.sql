-- =============================================================================
-- ProfePlan credit accounting — Lote 1.3C.4D
-- Specialized atomic save boundaries for PDI adaptation validation and reports.
--
-- IMPORTANT:
-- - versioned only; NOT authorized for hosted deployment in this sublot;
-- - depends on the governed 1.3B credit foundation and PDI schema;
-- - generation/preview remains NON_BILLABLE under the governed consumer flag;
-- - direct table-write enforcement remains a later cutover gate.
-- =============================================================================

BEGIN;

DO $$
BEGIN
  IF to_regclass('public.pdi_records') IS NULL
     OR to_regclass('public.pdi_documents') IS NULL
     OR to_regclass('public.school_students') IS NULL
     OR to_regclass('public.generated_contents') IS NULL THEN
    RAISE EXCEPTION '1.3C.4D requires PDI persistence and generated_contents';
  END IF;

  IF to_regclass('public.credit_operations') IS NULL
     OR to_regclass('public.credit_grants') IS NULL
     OR to_regclass('public.credit_ledger_entries') IS NULL
     OR NOT EXISTS (
       SELECT 1
       FROM pg_proc AS p
       JOIN pg_namespace AS n ON n.oid = p.pronamespace
       WHERE n.nspname = 'public'
         AND p.proname = 'credit_consume_internal'
     ) THEN
    RAISE EXCEPTION '1.3C.4D requires the governed 1.3B credit foundation';
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.credit_validate_pdi_adaptation(
  p_artifact_id uuid,
  p_pdi_document_id uuid,
  p_student_id uuid,
  p_lesson_id text,
  p_lesson_title text,
  p_subject text,
  p_content text,
  p_block9_payload jsonb,
  p_created_at timestamptz DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_profile_school_id text;
  v_student_school_id text;
  v_pdi_student_id uuid;
  v_existing_teacher_id uuid;
  v_existing_student_id uuid;
  v_existing_block text;
  v_existing_gc_owner uuid;
  v_operation_id text;
  v_fingerprint text;
  v_economic jsonb;
  v_created_at timestamptz := COALESCE(p_created_at, now());
  v_record_content jsonb;
  v_block9_entry jsonb;
  v_existing_block9 jsonb;
  v_next_block9 jsonb;
  v_replaced boolean := false;
  v_element jsonb;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authenticated user required for governed PDI adaptation validation'
      USING ERRCODE = '28000';
  END IF;

  IF p_artifact_id IS NULL
     OR p_pdi_document_id IS NULL
     OR p_student_id IS NULL
     OR p_lesson_id IS NULL OR btrim(p_lesson_id) = '' OR length(p_lesson_id) > 200
     OR p_lesson_title IS NULL OR btrim(p_lesson_title) = '' OR length(p_lesson_title) > 1000
     OR p_subject IS NULL OR btrim(p_subject) = '' OR length(p_subject) > 256
     OR p_content IS NULL OR btrim(p_content) = ''
     OR p_block9_payload IS NULL OR jsonb_typeof(p_block9_payload) <> 'object' THEN
    RAISE EXCEPTION 'invalid governed PDI adaptation payload'
      USING ERRCODE = '22023';
  END IF;

  IF COALESCE(p_block9_payload ->> 'lesson_id', '') <> p_lesson_id THEN
    RAISE EXCEPTION 'PDI adaptation lesson identity mismatch'
      USING ERRCODE = '22023';
  END IF;

  -- Global lock-order invariant: profile first, artifact second.
  SELECT p.school_id
    INTO v_profile_school_id
  FROM public.profiles AS p
  WHERE p.id = v_user_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'credit profile not found'
      USING ERRCODE = 'P0002';
  END IF;

  SELECT ss.school_id
    INTO v_student_school_id
  FROM public.school_students AS ss
  WHERE ss.id = p_student_id;

  IF NOT FOUND OR v_student_school_id IS NULL THEN
    RAISE EXCEPTION 'PDI student not found'
      USING ERRCODE = 'P0002';
  END IF;

  IF v_profile_school_id IS DISTINCT FROM v_student_school_id THEN
    RAISE EXCEPTION 'PDI student is outside authenticated user school'
      USING ERRCODE = '42501';
  END IF;

  SELECT pd.student_id
    INTO v_pdi_student_id
  FROM public.pdi_documents AS pd
  WHERE pd.id = p_pdi_document_id
  FOR UPDATE;

  IF NOT FOUND OR v_pdi_student_id IS DISTINCT FROM p_student_id THEN
    RAISE EXCEPTION 'PDI document/student identity mismatch'
      USING ERRCODE = '42501';
  END IF;

  SELECT pr.teacher_id, pr.student_id, pr.pdi_block
    INTO v_existing_teacher_id, v_existing_student_id, v_existing_block
  FROM public.pdi_records AS pr
  WHERE pr.id = p_artifact_id
  FOR UPDATE;

  IF FOUND THEN
    IF v_existing_teacher_id IS DISTINCT FROM v_user_id
       OR v_existing_student_id IS DISTINCT FROM p_student_id
       OR v_existing_block IS DISTINCT FROM 'block9' THEN
      RAISE EXCEPTION 'PDI adaptation artifact ownership or identity conflict'
        USING ERRCODE = '42501';
    END IF;
  END IF;

  SELECT gc.user_id
    INTO v_existing_gc_owner
  FROM public.generated_contents AS gc
  WHERE gc.id = p_artifact_id::text
  FOR UPDATE;

  IF FOUND AND v_existing_gc_owner IS DISTINCT FROM v_user_id THEN
    RAISE EXCEPTION 'PDI generated content belongs to another user'
      USING ERRCODE = '42501';
  END IF;

  v_record_content := jsonb_build_object(
    'artifactId', p_artifact_id::text,
    'lessonId', p_lesson_id,
    'adaptedContent', p_content,
    'pdiDocumentId', p_pdi_document_id::text
  );

  v_block9_entry := p_block9_payload || jsonb_build_object(
    'artifact_id', p_artifact_id::text,
    'generated_at', v_created_at,
    'generated_by_ai', true
  );

  IF v_existing_teacher_id IS NULL THEN
    v_operation_id := 'pdi-adaptation-save-v1:' || gen_random_uuid()::text;
    v_fingerprint := md5(
      jsonb_build_object(
        'version', '1.3C.4D-adaptation-v1',
        'artifact_id', p_artifact_id,
        'pdi_document_id', p_pdi_document_id,
        'student_id', p_student_id,
        'lesson_id', p_lesson_id,
        'lesson_title', p_lesson_title,
        'subject', p_subject,
        'content', p_content,
        'block9_payload', p_block9_payload,
        'created_at', v_created_at
      )::text
    );

    v_economic := public.credit_consume_internal(
      v_user_id,
      v_operation_id,
      'SAVE_PDI_ADAPTATION',
      v_fingerprint,
      'adaptacao_pdi',
      p_artifact_id::text,
      jsonb_build_object(
        'command_version', '1.3C.4D',
        'canonical_event', 'PDI_ADAPTATION_VALIDATED',
        'pdi_document_id', p_pdi_document_id
      )
    );

    IF v_economic ->> 'outcome' = 'REJECTED' THEN
      RETURN v_economic || jsonb_build_object(
        'saved', false,
        'artifact_id', p_artifact_id::text,
        'canonical_table', 'pdi_records'
      );
    END IF;

    INSERT INTO public.pdi_records (
      id,
      student_id,
      school_id,
      teacher_id,
      type,
      pdi_block,
      title,
      content,
      date,
      created_at
    ) VALUES (
      p_artifact_id,
      p_student_id,
      v_student_school_id,
      v_user_id,
      'ADAPTATION',
      'block9',
      'Adaptação: ' || p_lesson_title,
      v_record_content,
      v_created_at::date,
      v_created_at
    );
  ELSE
    UPDATE public.pdi_records
    SET title = 'Adaptação: ' || p_lesson_title,
        content = v_record_content,
        date = v_created_at::date
    WHERE id = p_artifact_id;

    v_economic := jsonb_build_object(
      'outcome', 'NO_CHARGE',
      'charged', false,
      'reason', 'EXISTING_ARTIFACT_EDIT',
      'replay', true
    );
  END IF;

  SELECT COALESCE(pd.block_9_content, '[]'::jsonb)
    INTO v_existing_block9
  FROM public.pdi_documents AS pd
  WHERE pd.id = p_pdi_document_id;

  IF jsonb_typeof(v_existing_block9) <> 'array' THEN
    v_existing_block9 := '[]'::jsonb;
  END IF;

  v_next_block9 := '[]'::jsonb;
  FOR v_element IN SELECT value FROM jsonb_array_elements(v_existing_block9)
  LOOP
    IF NOT v_replaced AND (
      v_element ->> 'artifact_id' = p_artifact_id::text
      OR v_element ->> 'lesson_id' = p_lesson_id
    ) THEN
      v_next_block9 := v_next_block9 || jsonb_build_array(v_block9_entry);
      v_replaced := true;
    ELSE
      v_next_block9 := v_next_block9 || jsonb_build_array(v_element);
    END IF;
  END LOOP;

  IF NOT v_replaced THEN
    v_next_block9 := v_next_block9 || jsonb_build_array(v_block9_entry);
  END IF;

  UPDATE public.pdi_documents
  SET block_9_content = v_next_block9,
      updated_at = now()
  WHERE id = p_pdi_document_id;

  INSERT INTO public.generated_contents (
    id,
    user_id,
    type,
    folder,
    title,
    content,
    created_at
  ) VALUES (
    p_artifact_id::text,
    v_user_id,
    'adaptacao_pdi',
    'PDI',
    'Adaptação: ' || p_lesson_title,
    p_content,
    v_created_at
  )
  ON CONFLICT (id) DO UPDATE SET
    type = EXCLUDED.type,
    folder = EXCLUDED.folder,
    title = EXCLUDED.title,
    content = EXCLUDED.content
  WHERE public.generated_contents.user_id = v_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'PDI generated-content ownership conflict during governed save'
      USING ERRCODE = '42501';
  END IF;

  RETURN v_economic || jsonb_build_object(
    'saved', true,
    'artifact_id', p_artifact_id::text,
    'pdi_record_id', p_artifact_id::text,
    'pdi_document_id', p_pdi_document_id::text,
    'canonical_table', 'pdi_records'
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.credit_save_pdi_generated_report(
  p_artifact_id text,
  p_title text,
  p_content text,
  p_created_at timestamptz DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_existing_owner uuid;
  v_operation_id text;
  v_fingerprint text;
  v_economic jsonb;
  v_created_at timestamptz := COALESCE(p_created_at, now());
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authenticated user required for governed PDI report save'
      USING ERRCODE = '28000';
  END IF;

  IF p_artifact_id IS NULL OR btrim(p_artifact_id) = '' OR length(p_artifact_id) > 200
     OR p_title IS NULL OR btrim(p_title) = '' OR length(p_title) > 1000
     OR p_content IS NULL OR btrim(p_content) = '' THEN
    RAISE EXCEPTION 'invalid governed PDI report payload'
      USING ERRCODE = '22023';
  END IF;

  PERFORM 1
  FROM public.profiles AS p
  WHERE p.id = v_user_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'credit profile not found'
      USING ERRCODE = 'P0002';
  END IF;

  SELECT gc.user_id
    INTO v_existing_owner
  FROM public.generated_contents AS gc
  WHERE gc.id = p_artifact_id
  FOR UPDATE;

  IF FOUND THEN
    IF v_existing_owner IS DISTINCT FROM v_user_id THEN
      RAISE EXCEPTION 'PDI report belongs to another user'
        USING ERRCODE = '42501';
    END IF;

    UPDATE public.generated_contents
    SET type = 'relatorio_pdi',
        folder = 'PDI',
        title = p_title,
        content = p_content
    WHERE id = p_artifact_id
      AND user_id = v_user_id;

    RETURN jsonb_build_object(
      'saved', true,
      'outcome', 'NO_CHARGE',
      'charged', false,
      'reason', 'EXISTING_ARTIFACT_EDIT',
      'replay', true,
      'artifact_id', p_artifact_id,
      'canonical_table', 'generated_contents'
    );
  END IF;

  v_operation_id := 'pdi-generated-report-save-v1:' || gen_random_uuid()::text;
  v_fingerprint := md5(
    jsonb_build_object(
      'version', '1.3C.4D-report-v1',
      'artifact_id', p_artifact_id,
      'title', p_title,
      'content', p_content,
      'created_at', v_created_at
    )::text
  );

  v_economic := public.credit_consume_internal(
    v_user_id,
    v_operation_id,
    'SAVE_PDI_REPORT',
    v_fingerprint,
    'relatorio_pdi',
    p_artifact_id,
    jsonb_build_object(
      'command_version', '1.3C.4D',
      'canonical_table', 'generated_contents',
      'report_kind', 'PEDAGOGICAL_REPORT'
    )
  );

  IF v_economic ->> 'outcome' = 'REJECTED' THEN
    RETURN v_economic || jsonb_build_object(
      'saved', false,
      'artifact_id', p_artifact_id,
      'canonical_table', 'generated_contents'
    );
  END IF;

  INSERT INTO public.generated_contents (
    id,
    user_id,
    type,
    folder,
    title,
    content,
    created_at
  ) VALUES (
    p_artifact_id,
    v_user_id,
    'relatorio_pdi',
    'PDI',
    p_title,
    p_content,
    v_created_at
  );

  RETURN v_economic || jsonb_build_object(
    'saved', true,
    'artifact_id', p_artifact_id,
    'canonical_table', 'generated_contents'
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.credit_save_pdi_final_report(
  p_pdi_document_id uuid,
  p_content text
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_profile_school_id text;
  v_role text;
  v_student_id uuid;
  v_student_school_id text;
  v_artifact_id text;
  v_existing_owner uuid;
  v_operation_id text;
  v_fingerprint text;
  v_economic jsonb;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authenticated user required for governed PDI final report save'
      USING ERRCODE = '28000';
  END IF;

  IF p_pdi_document_id IS NULL OR p_content IS NULL OR btrim(p_content) = '' THEN
    RAISE EXCEPTION 'invalid governed PDI final report payload'
      USING ERRCODE = '22023';
  END IF;

  SELECT p.school_id, p.role
    INTO v_profile_school_id, v_role
  FROM public.profiles AS p
  WHERE p.id = v_user_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'credit profile not found'
      USING ERRCODE = 'P0002';
  END IF;

  IF v_role IS NULL OR v_role NOT IN ('manager', 'school_manager', 'school_admin', 'admin') THEN
    RAISE EXCEPTION 'authenticated user cannot save PDI final report'
      USING ERRCODE = '42501';
  END IF;

  SELECT pd.student_id
    INTO v_student_id
  FROM public.pdi_documents AS pd
  WHERE pd.id = p_pdi_document_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'PDI document not found'
      USING ERRCODE = 'P0002';
  END IF;

  SELECT ss.school_id
    INTO v_student_school_id
  FROM public.school_students AS ss
  WHERE ss.id = v_student_id;

  IF v_profile_school_id IS DISTINCT FROM v_student_school_id THEN
    RAISE EXCEPTION 'PDI document is outside authenticated user school'
      USING ERRCODE = '42501';
  END IF;

  v_artifact_id := 'pdi-final-report-v1:' || p_pdi_document_id::text;

  SELECT gc.user_id
    INTO v_existing_owner
  FROM public.generated_contents AS gc
  WHERE gc.id = v_artifact_id
  FOR UPDATE;

  IF FOUND AND v_existing_owner IS DISTINCT FROM v_user_id THEN
    RAISE EXCEPTION 'PDI final report artifact belongs to another user'
      USING ERRCODE = '42501';
  END IF;

  IF v_existing_owner IS NULL THEN
    v_operation_id := 'pdi-final-report-save-v1:' || gen_random_uuid()::text;
    v_fingerprint := md5(
      jsonb_build_object(
        'version', '1.3C.4D-final-report-v1',
        'pdi_document_id', p_pdi_document_id,
        'content', p_content
      )::text
    );

    v_economic := public.credit_consume_internal(
      v_user_id,
      v_operation_id,
      'SAVE_PDI_REPORT',
      v_fingerprint,
      'relatorio_pdi',
      v_artifact_id,
      jsonb_build_object(
        'command_version', '1.3C.4D',
        'canonical_table', 'pdi_documents',
        'report_kind', 'FINAL_REPORT'
      )
    );

    IF v_economic ->> 'outcome' = 'REJECTED' THEN
      RETURN v_economic || jsonb_build_object(
        'saved', false,
        'artifact_id', v_artifact_id,
        'pdi_document_id', p_pdi_document_id::text,
        'canonical_table', 'pdi_documents'
      );
    END IF;
  ELSE
    v_economic := jsonb_build_object(
      'outcome', 'NO_CHARGE',
      'charged', false,
      'reason', 'EXISTING_ARTIFACT_EDIT',
      'replay', true
    );
  END IF;

  UPDATE public.pdi_documents
  SET final_report = p_content,
      updated_at = now()
  WHERE id = p_pdi_document_id;

  INSERT INTO public.generated_contents (
    id,
    user_id,
    type,
    folder,
    title,
    content,
    created_at
  ) VALUES (
    v_artifact_id,
    v_user_id,
    'relatorio_pdi',
    'PDI',
    'Relatório Final PDI',
    p_content,
    now()
  )
  ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    content = EXCLUDED.content
  WHERE public.generated_contents.user_id = v_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'PDI final report ownership conflict during governed save'
      USING ERRCODE = '42501';
  END IF;

  RETURN v_economic || jsonb_build_object(
    'saved', true,
    'artifact_id', v_artifact_id,
    'pdi_document_id', p_pdi_document_id::text,
    'canonical_table', 'pdi_documents'
  );
END;
$$;

REVOKE ALL ON FUNCTION public.credit_validate_pdi_adaptation(
  uuid, uuid, uuid, text, text, text, text, jsonb, timestamptz
) FROM PUBLIC, anon, service_role;
GRANT EXECUTE ON FUNCTION public.credit_validate_pdi_adaptation(
  uuid, uuid, uuid, text, text, text, text, jsonb, timestamptz
) TO authenticated;

REVOKE ALL ON FUNCTION public.credit_save_pdi_generated_report(
  text, text, text, timestamptz
) FROM PUBLIC, anon, service_role;
GRANT EXECUTE ON FUNCTION public.credit_save_pdi_generated_report(
  text, text, text, timestamptz
) TO authenticated;

REVOKE ALL ON FUNCTION public.credit_save_pdi_final_report(uuid, text)
  FROM PUBLIC, anon, service_role;
GRANT EXECUTE ON FUNCTION public.credit_save_pdi_final_report(uuid, text)
  TO authenticated;

COMMENT ON FUNCTION public.credit_validate_pdi_adaptation(
  uuid, uuid, uuid, text, text, text, text, jsonb, timestamptz
) IS
  'Lote 1.3C.4D: atomic governed PDI Block 9 validation. One semantic validation may consume one credit; retry/edit of the same artifact is non-billable.';

COMMENT ON FUNCTION public.credit_save_pdi_generated_report(text, text, text, timestamptz)
IS
  'Lote 1.3C.4D: governed generated PDI report save. First canonical save may consume one credit; edits/retries are non-billable.';

COMMENT ON FUNCTION public.credit_save_pdi_final_report(uuid, text)
IS
  'Lote 1.3C.4D: atomic PDI final-report persistence plus generated-content representation. First save per PDI document may consume one credit; edits are non-billable.';

COMMIT;
