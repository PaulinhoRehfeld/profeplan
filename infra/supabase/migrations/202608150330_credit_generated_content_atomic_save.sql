-- =============================================================================
-- ProfePlan credit accounting — Lote 1.3C.4A
-- Atomic first-save boundary for canonical generated_contents artifacts.
--
-- IMPORTANT:
-- - versioned only; NOT authorized for hosted deployment in this sublot;
-- - depends on 1.3B.1 + 1.3B.2 credit accounting foundations;
-- - first canonical save may consume at most one credit;
-- - edit/retry of an already-saved artifact id is NON_BILLABLE;
-- - direct table-write enforcement remains a later cutover gate (1.3C.5).
-- =============================================================================

BEGIN;

DO $$
BEGIN
  IF to_regclass('public.generated_contents') IS NULL THEN
    RAISE EXCEPTION '1.3C.4A requires public.generated_contents';
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
    RAISE EXCEPTION '1.3C.4A requires the governed 1.3B credit foundation';
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.credit_save_generated_content(
  p_artifact_id text,
  p_type text,
  p_folder text,
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
  v_action_key text;
  v_operation_id text;
  v_fingerprint text;
  v_economic jsonb;
  v_saved_id text;
  v_created_at timestamptz := COALESCE(p_created_at, now());
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authenticated user required for governed generated-content save'
      USING ERRCODE = '28000';
  END IF;

  IF p_artifact_id IS NULL OR btrim(p_artifact_id) = '' OR length(p_artifact_id) > 200
     OR p_type IS NULL OR btrim(p_type) = '' OR length(p_type) > 64
     OR p_folder IS NULL OR btrim(p_folder) = '' OR length(p_folder) > 128
     OR p_title IS NULL OR btrim(p_title) = '' OR length(p_title) > 1000
     OR p_content IS NULL OR btrim(p_content) = '' THEN
    RAISE EXCEPTION 'invalid governed generated-content save payload'
      USING ERRCODE = '22023';
  END IF;

  -- Dedicated domains must never accidentally fall through the generic save.
  IF p_type IN ('trimestral', 'adaptacao_pdi', 'relatorio_pdi') THEN
    RAISE EXCEPTION 'content type requires a dedicated governed save boundary'
      USING ERRCODE = '22023';
  END IF;

  v_action_key := CASE p_type
    WHEN 'avaliacao' THEN 'SAVE_ASSESSMENT'
    WHEN 'apresentacao' THEN 'SAVE_PRESENTATION'
    WHEN 'plano' THEN 'SAVE_DOCUMENT'
    WHEN 'aula' THEN 'SAVE_DOCUMENT'
    WHEN 'material' THEN 'SAVE_DOCUMENT'
    WHEN 'exercicio' THEN 'SAVE_DOCUMENT'
    WHEN 'simulado' THEN 'SAVE_DOCUMENT'
    WHEN 'documento' THEN 'SAVE_DOCUMENT'
    WHEN 'enem' THEN 'SAVE_DOCUMENT'
    WHEN 'outros' THEN 'SAVE_DOCUMENT'
    ELSE NULL
  END;

  IF v_action_key IS NULL THEN
    RAISE EXCEPTION 'unsupported governed generated-content type'
      USING ERRCODE = '22023';
  END IF;

  -- Global lock-order invariant: profile first, artifact second. This also
  -- serializes two first-save attempts by the same user. After the first
  -- transaction commits, the waiter observes the canonical artifact and takes
  -- the NON_BILLABLE edit/retry path instead of consuming again.
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
      RAISE EXCEPTION 'generated content belongs to another user'
        USING ERRCODE = '42501';
    END IF;

    UPDATE public.generated_contents
    SET type = p_type,
        folder = p_folder,
        title = p_title,
        content = p_content
    WHERE id = p_artifact_id
      AND user_id = v_user_id
    RETURNING id INTO v_saved_id;

    IF v_saved_id IS NULL THEN
      RAISE EXCEPTION 'generated content ownership conflict during governed edit'
        USING ERRCODE = '42501';
    END IF;

    RETURN jsonb_build_object(
      'saved', true,
      'outcome', 'NO_CHARGE',
      'charged', false,
      'reason', 'EXISTING_ARTIFACT_EDIT',
      'replay', true,
      'artifact_type', p_type,
      'artifact_id', v_saved_id,
      'canonical_table', 'generated_contents'
    );
  END IF;

  -- The browser does not choose the economic action key or debit amount. A
  -- fresh server operation is sufficient here because the profile+artifact
  -- serialization is the idempotency boundary for first save:
  -- - response lost after COMMIT -> artifact exists on retry -> no charge;
  -- - persistence failure -> same transaction rolls back operation + DEBIT;
  -- - explicit insufficient response -> no artifact exists, so a later retry
  --   after a new grant can make a fresh economic decision.
  v_operation_id := 'generated-content-save-v1:' || gen_random_uuid()::text;
  v_fingerprint := md5(
    jsonb_build_object(
      'version', '1.3C.4A-v1',
      'artifact_id', p_artifact_id,
      'type', p_type,
      'folder', p_folder,
      'title', p_title,
      'content', p_content,
      'created_at', v_created_at
    )::text
  );

  v_economic := public.credit_consume_internal(
    v_user_id,
    v_operation_id,
    v_action_key,
    v_fingerprint,
    p_type,
    p_artifact_id,
    jsonb_build_object(
      'command_version', '1.3C.4A',
      'canonical_table', 'generated_contents'
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
    p_type,
    p_folder,
    p_title,
    p_content,
    v_created_at
  )
  ON CONFLICT (id) DO UPDATE SET
    type = EXCLUDED.type,
    folder = EXCLUDED.folder,
    title = EXCLUDED.title,
    content = EXCLUDED.content
  WHERE public.generated_contents.user_id = v_user_id
  RETURNING id INTO v_saved_id;

  -- Cross-user collision can race after the ownership pre-check. Any failure
  -- raised here rolls the economic receipt and DEBIT back with the artifact.
  IF v_saved_id IS NULL THEN
    RAISE EXCEPTION 'generated content ownership conflict during governed save'
      USING ERRCODE = '42501';
  END IF;

  RETURN v_economic || jsonb_build_object(
    'saved', true,
    'artifact_id', v_saved_id,
    'canonical_table', 'generated_contents'
  );
END;
$$;

REVOKE ALL ON FUNCTION public.credit_save_generated_content(
  text,
  text,
  text,
  text,
  text,
  timestamptz
) FROM PUBLIC, anon, service_role;

GRANT EXECUTE ON FUNCTION public.credit_save_generated_content(
  text,
  text,
  text,
  text,
  text,
  timestamptz
) TO authenticated;

COMMENT ON FUNCTION public.credit_save_generated_content(
  text,
  text,
  text,
  text,
  text,
  timestamptz
) IS
  'Lote 1.3C.4A: authenticated atomic first-save persistence for generated_contents. First canonical save may consume one credit; existing artifact edits/retries are non-billable. Versioned only until coordinated cutover.';

COMMIT;
