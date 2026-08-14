-- =============================================================================
-- Knowledge Factory C.1.4 disposable adapter fixture
-- TEST ONLY. Never apply to hosted or production Supabase.
-- =============================================================================

INSERT INTO public.kf_source_actor_assignments (
  id,
  actor_id,
  actor_role,
  effective_from,
  effective_until
) VALUES
  (
    '89100000-0000-4000-8000-000000000001',
    '89110000-0000-4000-8000-000000000001',
    'curator',
    '2026-08-14T00:00:00Z',
    '2026-08-15T00:00:00Z'
  ),
  (
    '89100000-0000-4000-8000-000000000002',
    '89110000-0000-4000-8000-000000000002',
    'legal_editorial_reviewer',
    '2026-08-14T00:00:00Z',
    '2026-08-15T00:00:00Z'
  );

CREATE OR REPLACE FUNCTION public.kf_test_c1_4_fingerprint(
  p_operation text,
  p_payload jsonb
)
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $function$
  SELECT public.kf_source_command_fingerprint_internal(p_operation, p_payload)
$function$;

ALTER FUNCTION public.kf_test_c1_4_fingerprint(text,jsonb) OWNER TO postgres;
REVOKE ALL ON FUNCTION public.kf_test_c1_4_fingerprint(text,jsonb)
FROM PUBLIC, anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.kf_test_c1_4_fingerprint(text,jsonb)
TO service_role;
