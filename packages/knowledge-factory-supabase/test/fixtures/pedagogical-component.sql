-- Synthetic fixtures for the read-only PedagogicalComponent adapter integration test.
-- Disposable Supabase only. The deferred FK requires one PostgreSQL transaction.

BEGIN;

INSERT INTO public.kf_sources (
  id,
  version,
  title,
  source_type,
  status,
  license_category,
  allowed_uses,
  created_at,
  updated_at
)
VALUES
  (
    'c1000000-0000-4000-8000-000000000001',
    '1.0.0',
    'Synthetic component source A',
    'wrtech_owned',
    'approved',
    'owned',
    ARRAY['retrieval', 'generation']::text[],
    '2026-08-08T12:00:00.000Z',
    '2026-08-08T12:00:00.000Z'
  ),
  (
    'c1000000-0000-4000-8000-000000000002',
    '1.0.0',
    'Synthetic component source B',
    'wrtech_owned',
    'approved',
    'owned',
    ARRAY['retrieval', 'generation']::text[],
    '2026-08-08T12:00:00.000Z',
    '2026-08-08T12:00:00.000Z'
  );

INSERT INTO public.kf_source_versions (
  id,
  version,
  source_id,
  checksum,
  effective_at
)
VALUES
  (
    'c1100000-0000-4000-8000-000000000001',
    '1.0.0',
    'c1000000-0000-4000-8000-000000000001',
    'sha256:synthetic-component-source-a',
    '2026-08-08T12:00:00.000Z'
  ),
  (
    'c1100000-0000-4000-8000-000000000002',
    '1.0.0',
    'c1000000-0000-4000-8000-000000000002',
    'sha256:synthetic-component-source-b',
    '2026-08-08T12:00:00.000Z'
  );

INSERT INTO public.kf_source_segments (
  id,
  version,
  source_version_id,
  locator,
  content_digest,
  extracted_text,
  created_at
)
VALUES
  (
    'c1200000-0000-4000-8000-000000000001',
    '1.0.0',
    'c1100000-0000-4000-8000-000000000001',
    'synthetic://component/source-a/segment-1',
    'sha256:synthetic-component-segment-a',
    'Synthetic component evidence segment A.',
    '2026-08-08T12:00:00.000Z'
  ),
  (
    'c1200000-0000-4000-8000-000000000002',
    '1.0.0',
    'c1100000-0000-4000-8000-000000000002',
    'synthetic://component/source-b/segment-1',
    'sha256:synthetic-component-segment-b',
    'Synthetic component evidence segment B.',
    '2026-08-08T12:00:00.000Z'
  );

INSERT INTO public.kf_curriculum_packages (
  id,
  version,
  state,
  stage,
  status,
  title,
  effective_from
)
VALUES (
  'c2000000-0000-4000-8000-000000000001',
  '2026.1',
  'MG',
  'ensino_medio',
  'draft',
  'Synthetic component adapter curriculum package',
  '2026-08-08T12:00:00.000Z'
);

INSERT INTO public.kf_curriculum_nodes (
  id,
  version,
  curriculum_package_id,
  node_type,
  code,
  title,
  description,
  component,
  grades
)
VALUES
  (
    'c2100000-0000-4000-8000-000000000001',
    '1.0.0',
    'c2000000-0000-4000-8000-000000000001',
    'skill',
    'SYN-COMP-001',
    'Synthetic component skill A',
    'Synthetic curriculum description A.',
    'Filosofia',
    ARRAY['2_em']::text[]
  ),
  (
    'c2100000-0000-4000-8000-000000000002',
    '1.0.0',
    'c2000000-0000-4000-8000-000000000001',
    'knowledge_object',
    'SYN-COMP-002',
    'Synthetic component knowledge object B',
    'Synthetic curriculum description B.',
    'Filosofia',
    ARRAY['2_em']::text[]
  ),
  (
    'c2100000-0000-4000-8000-000000000003',
    '1.0.0',
    'c2000000-0000-4000-8000-000000000001',
    'learning_expectation',
    'SYN-COMP-003',
    'Synthetic component learning expectation C',
    'Synthetic curriculum description C.',
    'Filosofia',
    ARRAY['2_em']::text[]
  );

SET CONSTRAINTS kf_pedagogical_components_current_version_fk DEFERRED;

INSERT INTO public.kf_pedagogical_components (
  id,
  version,
  canonical_key,
  title,
  component_type,
  school_component,
  grades,
  status,
  current_version_id,
  created_at,
  updated_at
)
VALUES
  (
    'c3000000-0000-4000-8000-000000000001',
    '1.0.0',
    'synthetic-component-adapter-a',
    'Synthetic component adapter A',
    'concept',
    'Filosofia',
    ARRAY['2_em']::text[],
    'approved',
    'c3100000-0000-4000-8000-000000000001',
    '2026-08-08T12:00:00.000Z',
    '2026-08-08T12:30:00.000Z'
  ),
  (
    'c3000000-0000-4000-8000-000000000002',
    '1.0.0',
    'synthetic-component-adapter-empty',
    'Synthetic component adapter without links',
    'context',
    'Filosofia',
    ARRAY['2_em']::text[],
    'draft',
    'c3100000-0000-4000-8000-000000000002',
    '2026-08-08T12:00:00.000Z',
    '2026-08-08T12:00:00.000Z'
  ),
  (
    'c3000000-0000-4000-8000-000000000003',
    '1.0.0',
    'synthetic-component-adapter-isolation',
    'Synthetic component adapter isolation row',
    'methodology',
    'Filosofia',
    ARRAY['2_em']::text[],
    'approved',
    'c3100000-0000-4000-8000-000000000003',
    '2026-08-08T12:00:00.000Z',
    '2026-08-08T12:00:00.000Z'
  );

INSERT INTO public.kf_component_versions (
  id,
  version,
  component_id,
  summary,
  keywords,
  approved_at,
  status
)
VALUES
  (
    'c3100000-0000-4000-8000-000000000001',
    '1.0.0',
    'c3000000-0000-4000-8000-000000000001',
    'Synthetic read adapter version A.',
    ARRAY['synthetic', 'component', 'read-only']::text[],
    '2026-08-08T13:00:00.000Z',
    'approved'
  ),
  (
    'c3100000-0000-4000-8000-000000000002',
    '1.0.0',
    'c3000000-0000-4000-8000-000000000002',
    'Synthetic version without evidence or curriculum links.',
    ARRAY[]::text[],
    NULL,
    'draft'
  ),
  (
    'c3100000-0000-4000-8000-000000000003',
    '1.0.0',
    'c3000000-0000-4000-8000-000000000003',
    'Synthetic isolation version.',
    ARRAY['synthetic', 'isolation']::text[],
    '2026-08-08T13:00:00.000Z',
    'approved'
  );

SET CONSTRAINTS kf_pedagogical_components_current_version_fk IMMEDIATE;

INSERT INTO public.kf_component_source_evidence (
  id,
  version,
  component_version_id,
  source_id,
  source_version_id,
  source_segment_id,
  contribution,
  recorded_at
)
VALUES
  (
    'c3200000-0000-4000-8000-000000000001',
    '1.0.0',
    'c3100000-0000-4000-8000-000000000001',
    'c1000000-0000-4000-8000-000000000001',
    'c1100000-0000-4000-8000-000000000001',
    'c1200000-0000-4000-8000-000000000001',
    'contextual',
    '2026-08-08T14:00:00.000Z'
  ),
  (
    'c3200000-0000-4000-8000-000000000002',
    '1.0.0',
    'c3100000-0000-4000-8000-000000000001',
    'c1000000-0000-4000-8000-000000000001',
    'c1100000-0000-4000-8000-000000000001',
    'c1200000-0000-4000-8000-000000000001',
    'conceptual',
    '2026-08-08T13:00:00.000Z'
  ),
  (
    'c3200000-0000-4000-8000-000000000003',
    '1.0.0',
    'c3100000-0000-4000-8000-000000000001',
    'c1000000-0000-4000-8000-000000000002',
    'c1100000-0000-4000-8000-000000000002',
    'c1200000-0000-4000-8000-000000000002',
    'methodological',
    '2026-08-08T13:00:00.000Z'
  ),
  (
    'c3200000-0000-4000-8000-000000000004',
    '1.0.0',
    'c3100000-0000-4000-8000-000000000003',
    'c1000000-0000-4000-8000-000000000002',
    'c1100000-0000-4000-8000-000000000002',
    'c1200000-0000-4000-8000-000000000002',
    'curricular',
    '2026-08-08T15:00:00.000Z'
  );

INSERT INTO public.kf_component_curriculum_links (
  component_version_id,
  curriculum_node_id
)
VALUES
  (
    'c3100000-0000-4000-8000-000000000001',
    'c2100000-0000-4000-8000-000000000002'
  ),
  (
    'c3100000-0000-4000-8000-000000000001',
    'c2100000-0000-4000-8000-000000000001'
  ),
  (
    'c3100000-0000-4000-8000-000000000003',
    'c2100000-0000-4000-8000-000000000003'
  );

COMMIT;
