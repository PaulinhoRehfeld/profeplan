-- =============================================================================
-- ProfePlan credit accounting — Lote 1.3B.3
-- Atomic TermPlan save pilot (versioned only; no hosted deployment here)
-- =============================================================================

BEGIN;

CREATE OR REPLACE FUNCTION public.credit_save_term_plan(
  p_plan_id text,
  p_title text,
  p_period integer,
  p_regime text,
  p_subject text,
  p_grade text,
  p_level text,
  p_workload_weekly integer,
  p_reserves jsonb,
  p_total_classes integer,
  p_grading_grid jsonb,
  p_state_base text,
  p_education_sphere text,
  p_generated_text text,
  p_lessons jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_existing_owner uuid;
  v_fingerprint text;
  v_operation_id text;
  v_economic jsonb;
  v_saved_id text;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authenticated user required for governed term-plan save'
      USING ERRCODE = '28000';
  END IF;

  IF p_plan_id IS NULL OR btrim(p_plan_id) = ''
     OR p_title IS NULL OR btrim(p_title) = ''
     OR p_period IS NULL OR p_period NOT BETWEEN 1 AND 3
     OR p_regime IS DISTINCT FROM 'Trimestre'
     OR p_subject IS NULL OR btrim(p_subject) = ''
     OR p_grade IS NULL OR btrim(p_grade) = ''
     OR p_level IS NULL OR btrim(p_level) = ''
     OR p_workload_weekly IS NULL OR p_workload_weekly <= 0
     OR p_reserves IS NULL OR jsonb_typeof(p_reserves) <> 'object'
     OR p_total_classes IS NULL OR p_total_classes < 0
     OR p_grading_grid IS NULL OR jsonb_typeof(p_grading_grid) <> 'object'
     OR p_state_base IS NULL OR btrim(p_state_base) = ''
     OR p_education_sphere IS NULL OR btrim(p_education_sphere) = ''
     OR p_generated_text IS NULL OR btrim(p_generated_text) = ''
     OR p_lessons IS NULL OR jsonb_typeof(p_lessons) <> 'array' THEN
    RAISE EXCEPTION 'invalid governed term-plan save payload'
      USING ERRCODE = '22023';
  END IF;

  -- Lock-order invariant for every governed credit command that also touches an
  -- artifact row: profile first, artifact second. credit_consume_internal()
  -- takes the same profile lock. Acquiring it here before any term_plans row
  -- prevents a concurrent replay from holding the profile while another save
  -- holds the artifact row and waits back on the same profile (deadlock cycle).
  PERFORM 1
  FROM public.profiles AS p
  WHERE p.id = v_user_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'credit profile not found'
      USING ERRCODE = 'P0002';
  END IF;

  -- The browser does not decide economic idempotency. A canonical JSON payload
  -- is hashed on the server; the same user + plan + payload always resolves to
  -- the same semantic operation, while a real edit produces a new operation.
  v_fingerprint := md5(
    jsonb_build_object(
      'version', '1.3B.3-v1',
      'plan_id', p_plan_id,
      'title', p_title,
      'period', p_period,
      'regime', p_regime,
      'subject', p_subject,
      'grade', p_grade,
      'level', p_level,
      'workload_weekly', p_workload_weekly,
      'reserves', p_reserves,
      'total_classes', p_total_classes,
      'grading_grid', p_grading_grid,
      'state_base', p_state_base,
      'education_sphere', p_education_sphere,
      'generated_text', p_generated_text,
      'lessons', p_lessons
    )::text
  );

  v_operation_id :=
    'term-plan-save:' || v_user_id::text || ':' || p_plan_id || ':' || v_fingerprint;

  -- Reject cross-user artifact collisions before making an economic decision.
  -- The profile lock above is intentionally acquired before this artifact lock.
  SELECT tp.user_id
    INTO v_existing_owner
  FROM public.term_plans AS tp
  WHERE tp.id = p_plan_id
  FOR UPDATE;

  IF FOUND AND v_existing_owner IS DISTINCT FROM v_user_id THEN
    RAISE EXCEPTION 'term plan belongs to another user'
      USING ERRCODE = '42501';
  END IF;

  v_economic := public.credit_consume_internal(
    v_user_id,
    v_operation_id,
    'SAVE_TERM_PLAN',
    v_fingerprint,
    'term_plan',
    p_plan_id,
    jsonb_build_object(
      'command_version', '1.3B.3',
      'fingerprint_version', '1.3B.3-v1'
    )
  );

  IF v_economic ->> 'outcome' = 'REJECTED' THEN
    RETURN v_economic || jsonb_build_object(
      'saved', false,
      'plan_id', p_plan_id,
      'fingerprint', v_fingerprint,
      'canonical_table', 'term_plans'
    );
  END IF;

  INSERT INTO public.term_plans (
    id,
    user_id,
    title,
    period,
    regime,
    subject,
    grade,
    level,
    workload_weekly,
    reserves,
    total_classes,
    grading_grid,
    state_base,
    education_sphere,
    generated_text,
    lessons,
    updated_at
  ) VALUES (
    p_plan_id,
    v_user_id,
    p_title,
    p_period,
    p_regime,
    p_subject,
    p_grade,
    p_level,
    p_workload_weekly,
    p_reserves,
    p_total_classes,
    p_grading_grid,
    p_state_base,
    p_education_sphere,
    p_generated_text,
    p_lessons,
    now()
  )
  ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    period = EXCLUDED.period,
    regime = EXCLUDED.regime,
    subject = EXCLUDED.subject,
    grade = EXCLUDED.grade,
    level = EXCLUDED.level,
    workload_weekly = EXCLUDED.workload_weekly,
    reserves = EXCLUDED.reserves,
    total_classes = EXCLUDED.total_classes,
    grading_grid = EXCLUDED.grading_grid,
    state_base = EXCLUDED.state_base,
    education_sphere = EXCLUDED.education_sphere,
    generated_text = EXCLUDED.generated_text,
    lessons = EXCLUDED.lessons,
    updated_at = now()
  WHERE public.term_plans.user_id = v_user_id
  RETURNING id INTO v_saved_id;

  -- Covers the race where another user claims the same text id after the
  -- ownership pre-check but before our INSERT. Raising rolls back the economic
  -- receipt and DEBIT together with the failed artifact save.
  IF v_saved_id IS NULL THEN
    RAISE EXCEPTION 'term plan ownership conflict during governed save'
      USING ERRCODE = '42501';
  END IF;

  RETURN v_economic || jsonb_build_object(
    'saved', true,
    'plan_id', v_saved_id,
    'fingerprint', v_fingerprint,
    'canonical_table', 'term_plans'
  );
END;
$$;

REVOKE ALL ON FUNCTION public.credit_save_term_plan(
  text,
  text,
  integer,
  text,
  text,
  text,
  text,
  integer,
  jsonb,
  integer,
  jsonb,
  text,
  text,
  text,
  jsonb
) FROM PUBLIC, anon, service_role;

GRANT EXECUTE ON FUNCTION public.credit_save_term_plan(
  text,
  text,
  integer,
  text,
  text,
  text,
  text,
  integer,
  jsonb,
  integer,
  jsonb,
  text,
  text,
  text,
  jsonb
) TO authenticated;

COMMENT ON FUNCTION public.credit_save_term_plan(
  text,
  text,
  integer,
  text,
  text,
  text,
  text,
  integer,
  jsonb,
  integer,
  jsonb,
  text,
  text,
  text,
  jsonb
) IS
  'Lote 1.3B.3 pilot: authenticated atomic term_plans persistence plus governed credit decision. Disabled in the web app unless its explicit feature flag is enabled after a separate hosted cutover.';

COMMIT;
