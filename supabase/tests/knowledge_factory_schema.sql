-- =============================================================================
-- Knowledge Factory Lote 3A - schema/constraint tests
-- NON-PRODUCTION ONLY. Assumes 202608071120_knowledge_factory_schema.sql applied.
-- All records are synthetic and rolled back.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. The 15 approved tables must exist
-- ---------------------------------------------------------------------------
DO $$
DECLARE
  expected text[] := ARRAY[
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
  item text;
BEGIN
  FOREACH item IN ARRAY expected LOOP
    IF to_regclass('public.' || item) IS NULL THEN
      RAISE EXCEPTION 'Missing Knowledge Factory table: %', item;
    END IF;
  END LOOP;
END;
$$;

-- No vector columns or vector indexes in Knowledge Factory.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name LIKE 'kf\_%' ESCAPE '\'
      AND udt_name = 'vector'
  ) THEN
    RAISE EXCEPTION 'Vector column detected in Lote 3A';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE schemaname = 'public'
      AND tablename LIKE 'kf\_%' ESCAPE '\'
      AND indexdef ~* '(ivfflat|hnsw|vector_)'
  ) THEN
    RAISE EXCEPTION 'Vector index detected in Lote 3A';
  END IF;
END;
$$;

-- ---------------------------------------------------------------------------
-- 2. Synthetic valid provenance chain
-- ---------------------------------------------------------------------------
INSERT INTO public.kf_sources (
  id, version, title, source_type, status, license_category, allowed_uses, provenance_uri
) VALUES (
  '11111111-1111-4111-8111-111111111111',
  '1.0.0',
  'WRTECH-SYNTHETIC-SOURCE-001',
  'wrtech_owned',
  'approved',
  'owned',
  ARRAY['retrieval', 'generation'],
  'urn:wrtech:synthetic:source:001'
);

INSERT INTO public.kf_source_versions (
  id, version, source_id, checksum, effective_at
) VALUES (
  '11111111-1111-4111-8111-111111111112',
  '1.0.0',
  '11111111-1111-4111-8111-111111111111',
  'synthetic-checksum-001',
  now()
);

INSERT INTO public.kf_source_segments (
  id, version, source_version_id, locator, content_digest, extracted_text
) VALUES (
  '11111111-1111-4111-8111-111111111113',
  '1.0.0',
  '11111111-1111-4111-8111-111111111112',
  'synthetic:segment:001',
  'synthetic-digest-001',
  'Conteúdo sintético para teste de schema; não deriva de material real.'
);

-- Second source/version/segment used to prove evidence-chain coherence.
INSERT INTO public.kf_sources (
  id, version, title, source_type, status, license_category, allowed_uses
) VALUES (
  '11111111-1111-4111-8111-111111111121',
  '1.0.0',
  'WRTECH-SYNTHETIC-SOURCE-002',
  'wrtech_owned',
  'approved',
  'owned',
  ARRAY['retrieval']
);

INSERT INTO public.kf_source_versions (
  id, version, source_id, checksum, effective_at
) VALUES (
  '11111111-1111-4111-8111-111111111122',
  '1.0.0',
  '11111111-1111-4111-8111-111111111121',
  'synthetic-checksum-002',
  now()
);

INSERT INTO public.kf_source_segments (
  id, version, source_version_id, locator, content_digest, extracted_text
) VALUES (
  '11111111-1111-4111-8111-111111111123',
  '1.0.0',
  '11111111-1111-4111-8111-111111111122',
  'synthetic:segment:002',
  'synthetic-digest-002',
  'Segundo conteúdo sintético para teste.'
);

-- ---------------------------------------------------------------------------
-- 3. Synthetic curriculum package and nodes
-- ---------------------------------------------------------------------------
INSERT INTO public.kf_curriculum_packages (
  id, version, state, stage, status, title, effective_from
) VALUES (
  '33333333-3333-4333-8333-333333333331',
  '1.0.0',
  'MG',
  'ensino_medio',
  'active',
  'SYN-MG-EM-001',
  now()
);

INSERT INTO public.kf_curriculum_nodes (
  id, version, curriculum_package_id, node_type, code, title, description, component, grades
) VALUES
(
  '33333333-3333-4333-8333-333333333341',
  '1.0.0',
  '33333333-3333-4333-8333-333333333331',
  'knowledge_object',
  'SYN-MG-PHI-2-001',
  'Objeto sintético A',
  'Descrição sintética.',
  'Filosofia',
  ARRAY['2_em']
),
(
  '33333333-3333-4333-8333-333333333342',
  '1.0.0',
  '33333333-3333-4333-8333-333333333331',
  'skill',
  'SYN-MG-PHI-2-002',
  'Habilidade sintética B',
  'Descrição sintética.',
  'Filosofia',
  ARRAY['2_em']
);

INSERT INTO public.kf_curriculum_links (
  id, version, curriculum_package_id, from_node_id, to_node_id, relation
) VALUES (
  '33333333-3333-4333-8333-333333333351',
  '1.0.0',
  '33333333-3333-4333-8333-333333333331',
  '33333333-3333-4333-8333-333333333341',
  '33333333-3333-4333-8333-333333333342',
  'supports'
);

-- ---------------------------------------------------------------------------
-- 4. Components: deferred current-version FK must be coherent
-- ---------------------------------------------------------------------------
SET CONSTRAINTS kf_pedagogical_components_current_version_fk DEFERRED;

INSERT INTO public.kf_pedagogical_components (
  id, version, canonical_key, title, component_type, school_component, grades, status,
  current_version_id
) VALUES (
  '22222222-2222-4222-8222-222222222221',
  '1.0.0',
  'synthetic-philosophy-concept-a',
  'Conceito sintético A',
  'concept',
  'Filosofia',
  ARRAY['2_em'],
  'approved',
  '22222222-2222-4222-8222-222222222222'
);

INSERT INTO public.kf_component_versions (
  id, version, component_id, summary, keywords, approved_at, status
) VALUES (
  '22222222-2222-4222-8222-222222222222',
  '1.0.0',
  '22222222-2222-4222-8222-222222222221',
  'Resumo sintético.',
  ARRAY['sintetico'],
  now(),
  'approved'
);

INSERT INTO public.kf_pedagogical_components (
  id, version, canonical_key, title, component_type, school_component, grades, status,
  current_version_id
) VALUES (
  '22222222-2222-4222-8222-222222222223',
  '1.0.0',
  'synthetic-philosophy-concept-b',
  'Conceito sintético B',
  'concept',
  'Filosofia',
  ARRAY['2_em'],
  'approved',
  '22222222-2222-4222-8222-222222222224'
);

INSERT INTO public.kf_component_versions (
  id, version, component_id, summary, keywords, approved_at, status
) VALUES (
  '22222222-2222-4222-8222-222222222224',
  '1.0.0',
  '22222222-2222-4222-8222-222222222223',
  'Segundo resumo sintético.',
  ARRAY['sintetico'],
  now(),
  'approved'
);

SET CONSTRAINTS kf_pedagogical_components_current_version_fk IMMEDIATE;
SET CONSTRAINTS kf_pedagogical_components_current_version_fk DEFERRED;

INSERT INTO public.kf_component_source_evidence (
  id, version, component_version_id, source_id, source_version_id, source_segment_id,
  contribution, recorded_at
) VALUES (
  '22222222-2222-4222-8222-222222222231',
  '1.0.0',
  '22222222-2222-4222-8222-222222222222',
  '11111111-1111-4111-8111-111111111111',
  '11111111-1111-4111-8111-111111111112',
  '11111111-1111-4111-8111-111111111113',
  'conceptual',
  now()
);

INSERT INTO public.kf_component_curriculum_links (
  component_version_id, curriculum_node_id
) VALUES (
  '22222222-2222-4222-8222-222222222222',
  '33333333-3333-4333-8333-333333333341'
);

-- ---------------------------------------------------------------------------
-- 5. Expected failures
-- ---------------------------------------------------------------------------
DO $$
BEGIN
  BEGIN
    INSERT INTO public.kf_sources (
      version, title, source_type, status, license_category, allowed_uses
    ) VALUES ('1.0.0', 'Invalid status', 'wrtech_owned', 'not-valid', 'owned', ARRAY[]::text[]);
    RAISE EXCEPTION 'Expected invalid source status to fail';
  EXCEPTION WHEN check_violation THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    INSERT INTO public.kf_sources (
      version, title, source_type, status, license_category, allowed_uses
    ) VALUES ('   ', 'Empty version', 'wrtech_owned', 'draft', 'owned', ARRAY[]::text[]);
    RAISE EXCEPTION 'Expected blank version to fail';
  EXCEPTION WHEN check_violation THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    INSERT INTO public.kf_source_versions (
      version, source_id, checksum, effective_at
    ) VALUES (
      '1.0.0',
      '99999999-9999-4999-8999-999999999999',
      'orphan',
      now()
    );
    RAISE EXCEPTION 'Expected orphan source version to fail';
  EXCEPTION WHEN foreign_key_violation THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    INSERT INTO public.kf_source_versions (
      version, source_id, checksum, effective_at
    ) VALUES (
      '1.0.0',
      '11111111-1111-4111-8111-111111111111',
      'duplicate-version',
      now()
    );
    RAISE EXCEPTION 'Expected duplicate source version to fail';
  EXCEPTION WHEN unique_violation THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    INSERT INTO public.kf_curriculum_packages (
      version, state, stage, status, title, effective_from
    ) VALUES (
      '2.0.0', 'MG', 'ensino_medio', 'active', 'Second active MG package', now()
    );
    RAISE EXCEPTION 'Expected second active package to fail';
  EXCEPTION WHEN unique_violation THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    INSERT INTO public.kf_curriculum_packages (
      version, state, stage, status, title, effective_from
    ) VALUES (
      '1.0.0', 'RS', 'ensino_medio', 'active', 'RS must remain blocked in MVP', now()
    );
    RAISE EXCEPTION 'Expected active RS package to fail';
  EXCEPTION WHEN check_violation THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  SET CONSTRAINTS kf_pedagogical_components_current_version_fk DEFERRED;
  BEGIN
    INSERT INTO public.kf_pedagogical_components (
      id, version, canonical_key, title, component_type, school_component, grades, status,
      current_version_id
    ) VALUES (
      '22222222-2222-4222-8222-222222222225',
      '1.0.0',
      'synthetic-wrong-current-version',
      'Componente inválido',
      'concept',
      'Filosofia',
      ARRAY['2_em'],
      'draft',
      '22222222-2222-4222-8222-222222222224'
    );
    SET CONSTRAINTS kf_pedagogical_components_current_version_fk IMMEDIATE;
    RAISE EXCEPTION 'Expected cross-component current_version_id to fail';
  EXCEPTION WHEN foreign_key_violation THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    INSERT INTO public.kf_component_source_evidence (
      version, component_version_id, source_id, source_version_id, source_segment_id,
      contribution, recorded_at
    ) VALUES (
      '1.0.0',
      '22222222-2222-4222-8222-222222222222',
      '11111111-1111-4111-8111-111111111111',
      '11111111-1111-4111-8111-111111111112',
      '99999999-9999-4999-8999-999999999999',
      'conceptual',
      now()
    );
    RAISE EXCEPTION 'Expected orphan evidence segment to fail';
  EXCEPTION WHEN foreign_key_violation THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    INSERT INTO public.kf_component_source_evidence (
      version, component_version_id, source_id, source_version_id, source_segment_id,
      contribution, recorded_at
    ) VALUES (
      '1.0.0',
      '22222222-2222-4222-8222-222222222222',
      '11111111-1111-4111-8111-111111111111',
      '11111111-1111-4111-8111-111111111112',
      '11111111-1111-4111-8111-111111111123',
      'conceptual',
      now()
    );
    RAISE EXCEPTION 'Expected mismatched source/version/segment evidence to fail';
  EXCEPTION WHEN foreign_key_violation THEN
    NULL;
  END;
END;
$$;

-- ---------------------------------------------------------------------------
-- 6. Append-only must hold even for privileged test executor
-- ---------------------------------------------------------------------------
INSERT INTO public.kf_source_permission_events (
  id, version, source_id, action, use_type, reason, occurred_at
) VALUES (
  '11111111-1111-4111-8111-111111111131',
  '1.0.0',
  '11111111-1111-4111-8111-111111111111',
  'grant',
  'retrieval',
  'synthetic test',
  now()
);

INSERT INTO public.kf_audit_events (
  id, event_type, aggregate_type, aggregate_id, occurred_at, outcome, metadata
) VALUES (
  '44444444-4444-4444-8444-444444444441',
  'synthetic_test',
  'source',
  '11111111-1111-4111-8111-111111111111',
  now(),
  'recorded',
  '{"synthetic": true}'::jsonb
);

DO $$
BEGIN
  BEGIN
    UPDATE public.kf_source_permission_events
    SET reason = 'mutated'
    WHERE id = '11111111-1111-4111-8111-111111111131';
    RAISE EXCEPTION 'Expected append-only UPDATE to fail';
  EXCEPTION WHEN sqlstate '55000' THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    DELETE FROM public.kf_source_permission_events
    WHERE id = '11111111-1111-4111-8111-111111111131';
    RAISE EXCEPTION 'Expected append-only DELETE to fail';
  EXCEPTION WHEN sqlstate '55000' THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    UPDATE public.kf_audit_events
    SET reason = 'mutated'
    WHERE id = '44444444-4444-4444-8444-444444444441';
    RAISE EXCEPTION 'Expected audit UPDATE to fail';
  EXCEPTION WHEN sqlstate '55000' THEN
    NULL;
  END;
END;
$$;

DO $$
BEGIN
  BEGIN
    DELETE FROM public.kf_audit_events
    WHERE id = '44444444-4444-4444-8444-444444444441';
    RAISE EXCEPTION 'Expected audit DELETE to fail';
  EXCEPTION WHEN sqlstate '55000' THEN
    NULL;
  END;
END;
$$;

-- No dependency from Knowledge Factory to curriculum_rag.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_constraint c
    JOIN pg_class child ON child.oid = c.conrelid
    JOIN pg_class parent ON parent.oid = c.confrelid
    JOIN pg_namespace n ON n.oid = child.relnamespace
    WHERE n.nspname = 'public'
      AND child.relname LIKE 'kf\_%' ESCAPE '\'
      AND parent.relname = 'curriculum_rag'
  ) THEN
    RAISE EXCEPTION 'Knowledge Factory must not depend on curriculum_rag';
  END IF;
END;
$$;

ROLLBACK;
