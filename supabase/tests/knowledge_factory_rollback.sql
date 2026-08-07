-- =============================================================================
-- Knowledge Factory Lote 3A - destructive rollback rehearsal
-- NON-PRODUCTION / DISPOSABLE ENVIRONMENTS ONLY.
--
-- Safety rule: this script refuses to run if ANY kf_* table contains rows.
-- It is intended only after synthetic tests have rolled back their fixtures.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 0. Safety guard: never destroy populated Knowledge Factory tables
-- ---------------------------------------------------------------------------
DO $$
DECLARE
  table_name text;
  row_count bigint;
  tables text[] := ARRAY[
    'kf_sources',
    'kf_source_versions',
    'kf_source_permission_events',
    'kf_source_segments',
    'kf_pedagogical_components',
    'kf_component_versions',
    'kf_component_source_evidence',
    'kf_curriculum_packages',
    'kf_curriculum_package_sources',
    'kf_curriculum_nodes',
    'kf_curriculum_links',
    'kf_component_curriculum_links',
    'kf_production_orders',
    'kf_production_order_events',
    'kf_audit_events'
  ];
BEGIN
  FOREACH table_name IN ARRAY tables LOOP
    IF to_regclass('public.' || table_name) IS NOT NULL THEN
      EXECUTE format('SELECT count(*) FROM public.%I', table_name) INTO row_count;
      IF row_count <> 0 THEN
        RAISE EXCEPTION
          'Refusing destructive Knowledge Factory rollback: public.% contains % row(s)',
          table_name,
          row_count;
      END IF;
    END IF;
  END LOOP;
END;
$$;

-- ---------------------------------------------------------------------------
-- 1. Drop explicit policies first
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS kf_sources_admin_select ON public.kf_sources;
DROP POLICY IF EXISTS kf_source_versions_admin_select ON public.kf_source_versions;
DROP POLICY IF EXISTS kf_source_permission_events_admin_select ON public.kf_source_permission_events;
DROP POLICY IF EXISTS kf_source_segments_admin_select ON public.kf_source_segments;
DROP POLICY IF EXISTS kf_pedagogical_components_admin_select ON public.kf_pedagogical_components;
DROP POLICY IF EXISTS kf_component_versions_admin_select ON public.kf_component_versions;
DROP POLICY IF EXISTS kf_component_source_evidence_admin_select ON public.kf_component_source_evidence;
DROP POLICY IF EXISTS kf_curriculum_packages_admin_select ON public.kf_curriculum_packages;
DROP POLICY IF EXISTS kf_curriculum_package_sources_admin_select ON public.kf_curriculum_package_sources;
DROP POLICY IF EXISTS kf_curriculum_nodes_admin_select ON public.kf_curriculum_nodes;
DROP POLICY IF EXISTS kf_curriculum_links_admin_select ON public.kf_curriculum_links;
DROP POLICY IF EXISTS kf_component_curriculum_links_admin_select ON public.kf_component_curriculum_links;
DROP POLICY IF EXISTS kf_audit_events_admin_select ON public.kf_audit_events;
DROP POLICY IF EXISTS kf_production_orders_select_own ON public.kf_production_orders;
DROP POLICY IF EXISTS kf_production_orders_insert_own ON public.kf_production_orders;
DROP POLICY IF EXISTS kf_production_order_events_select_own ON public.kf_production_order_events;

-- ---------------------------------------------------------------------------
-- 2. Drop append-only triggers
-- ---------------------------------------------------------------------------
DROP TRIGGER IF EXISTS kf_source_permission_events_append_only
  ON public.kf_source_permission_events;
DROP TRIGGER IF EXISTS kf_production_order_events_append_only
  ON public.kf_production_order_events;
DROP TRIGGER IF EXISTS kf_audit_events_append_only
  ON public.kf_audit_events;

-- ---------------------------------------------------------------------------
-- 3. Remove tables in reverse dependency order
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS public.kf_component_curriculum_links;
DROP TABLE IF EXISTS public.kf_curriculum_links;
DROP TABLE IF EXISTS public.kf_curriculum_package_sources;
DROP TABLE IF EXISTS public.kf_component_source_evidence;
DROP TABLE IF EXISTS public.kf_production_order_events;
DROP TABLE IF EXISTS public.kf_audit_events;
DROP TABLE IF EXISTS public.kf_production_orders;
DROP TABLE IF EXISTS public.kf_curriculum_nodes;
DROP TABLE IF EXISTS public.kf_curriculum_packages;

ALTER TABLE IF EXISTS public.kf_pedagogical_components
  DROP CONSTRAINT IF EXISTS kf_pedagogical_components_current_version_fk;

DROP TABLE IF EXISTS public.kf_component_versions;
DROP TABLE IF EXISTS public.kf_pedagogical_components;
DROP TABLE IF EXISTS public.kf_source_segments;
DROP TABLE IF EXISTS public.kf_source_permission_events;
DROP TABLE IF EXISTS public.kf_source_versions;
DROP TABLE IF EXISTS public.kf_sources;

-- ---------------------------------------------------------------------------
-- 4. Drop Knowledge Factory-only helper functions
-- ---------------------------------------------------------------------------
DROP FUNCTION IF EXISTS public.kf_prevent_append_only_mutation();
DROP FUNCTION IF EXISTS public.kf_is_platform_admin();

-- ---------------------------------------------------------------------------
-- 5. Postconditions: all kf_* relations/functions must be gone
-- ---------------------------------------------------------------------------
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = 'public'
      AND c.relname LIKE 'kf\_%' ESCAPE '\'
      AND c.relkind IN ('r', 'p', 'v', 'm', 'S', 'f')
  ) THEN
    RAISE EXCEPTION 'Knowledge Factory rollback incomplete: kf_* relation remains';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname LIKE 'kf\_%' ESCAPE '\'
  ) THEN
    RAISE EXCEPTION 'Knowledge Factory rollback incomplete: kf_* function remains';
  END IF;

  -- The rollback must never remove or rename legacy curriculum objects.
  IF to_regclass('public.curriculum_rag') IS NOT NULL THEN
    RAISE NOTICE 'Legacy curriculum_rag remains present (expected).';
  END IF;
END;
$$;

COMMIT;
