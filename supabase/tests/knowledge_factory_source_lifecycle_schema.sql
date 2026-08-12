-- =============================================================================
-- Knowledge Factory C.1.2 - governed source lifecycle schema tests
-- NON-PRODUCTION ONLY. All fixtures are synthetic and rolled back.
-- =============================================================================

BEGIN;

CREATE TEMP TABLE kf_c12_test_bootstrap (id integer);

CREATE OR REPLACE FUNCTION pg_temp.assert_true(p_condition boolean, p_message text)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  IF p_condition IS NOT TRUE THEN
    RAISE EXCEPTION 'ASSERTION FAILED: %', p_message;
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION pg_temp.expect_error(
  p_sql text,
  p_allowed_states text[],
  p_message text
)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_state text;
BEGIN
  BEGIN
    EXECUTE p_sql;
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_state = RETURNED_SQLSTATE;
    IF p_allowed_states IS NULL OR v_state = ANY(p_allowed_states) THEN
      RETURN;
    END IF;
    RAISE EXCEPTION
      'ASSERTION FAILED: %; unexpected SQLSTATE %, error: %',
      p_message,
      v_state,
      SQLERRM;
  END;
  RAISE EXCEPTION 'ASSERTION FAILED: %; statement unexpectedly succeeded', p_message;
END;
$$;

-- ---------------------------------------------------------------------------
-- 1. Inventory and forbidden capabilities
-- ---------------------------------------------------------------------------
SELECT pg_temp.assert_true(
  (
    SELECT count(*) = 24
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_name LIKE 'kf\_%' ESCAPE '\'
  ),
  'exactly 24 public.kf_* tables must exist after C.1.2'
);

SELECT pg_temp.assert_true(
  NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name LIKE 'kf\_%' ESCAPE '\'
      AND (udt_name = 'vector' OR column_name = 'eligible')
  ),
  'C.1.2 must create neither vector nor authoritative eligible columns'
);

SELECT pg_temp.assert_true(
  NOT EXISTS (
    SELECT 1
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname LIKE 'kf\_source\_%command%' ESCAPE '\'
  ),
  'C.1.2 must not create source lifecycle command RPCs'
);

-- ---------------------------------------------------------------------------
-- 2. Synthetic legacy anchors and governed identities
-- ---------------------------------------------------------------------------
INSERT INTO public.kf_sources (
  id, version, title, source_type, status, license_category, allowed_uses
) VALUES (
  '71000000-0000-4000-8000-000000000001',
  '1.0.0',
  'WRTECH-SYNTHETIC-C12-LEGACY-SOURCE',
  'wrtech_owned',
  'approved',
  'owned',
  ARRAY['retrieval']::text[]
);

INSERT INTO public.kf_source_versions (
  id, version, source_id, checksum, effective_at
) VALUES (
  '71100000-0000-4000-8000-000000000001',
  '1.0.0',
  '71000000-0000-4000-8000-000000000001',
  'synthetic-c12-checksum',
  '2026-08-12T10:00:00Z'
);

INSERT INTO public.kf_source_identities (
  id, kind, legacy_source_id
) VALUES (
  '72000000-0000-4000-8000-000000000001',
  'governed_source',
  '71000000-0000-4000-8000-000000000001'
);

INSERT INTO public.kf_source_identities (
  id, kind, legacy_source_version_id
) VALUES (
  '72000000-0000-4000-8000-000000000002',
  'source_version',
  '71100000-0000-4000-8000-000000000001'
);

INSERT INTO public.kf_source_identities (id, kind)
VALUES
  ('72000000-0000-4000-8000-000000000003', 'source_version'),
  ('72000000-0000-4000-8000-000000000004', 'work'),
  ('72000000-0000-4000-8000-000000000005', 'edition'),
  ('72000000-0000-4000-8000-000000000006', 'manifestation'),
  ('72000000-0000-4000-8000-000000000007', 'received_file'),
  ('72000000-0000-4000-8000-000000000008', 'processing_run'),
  ('72000000-0000-4000-8000-000000000009', 'derived_artifact');

INSERT INTO public.kf_source_authorization_bases (
  id, kind, reference_digest
) VALUES (
  '72100000-0000-4000-8000-000000000001',
  'wrtech_ownership',
  'sha256:synthetic-c12-basis'
);

-- Current projections are deliberately separate from authoritative history.
INSERT INTO public.kf_source_registration_projections (
  subject_identity_id, projected_state, aggregate_version, sequence
) VALUES
  ('72000000-0000-4000-8000-000000000002', 'VALIDATED', '3.0.0', 3),
  ('72000000-0000-4000-8000-000000000003', 'REGISTERED', '1.0.0', 1);

INSERT INTO public.kf_source_authorizations (
  id,
  subject_identity_id,
  purpose,
  restrictions,
  basis_id,
  effective_from,
  effective_until,
  projected_state,
  aggregate_version,
  sequence
) VALUES (
  '72200000-0000-4000-8000-000000000001',
  '72000000-0000-4000-8000-000000000002',
  'retrieval',
  ARRAY[]::text[],
  '72100000-0000-4000-8000-000000000001',
  '2026-08-12T12:00:00Z',
  '2026-08-12T14:00:00Z',
  'REVOKED',
  '2.0.0',
  2
);

-- ---------------------------------------------------------------------------
-- 3. Registration history and receipts
-- ---------------------------------------------------------------------------
INSERT INTO public.kf_source_command_receipts (
  command_id, fingerprint, dimension, operation, aggregate_id,
  subject_identity_id, aggregate_version, sequence, registration_state,
  committed_at
) VALUES
  (
    '73000000-0000-4000-8000-000000000001', 'synthetic-register-v1',
    'registration', 'register_identity',
    '72000000-0000-4000-8000-000000000002',
    '72000000-0000-4000-8000-000000000002', '1.0.0', 1, 'REGISTERED',
    '2026-08-12T10:00:00Z'
  ),
  (
    '73000000-0000-4000-8000-000000000002', 'synthetic-request-validation-v1',
    'registration', 'request_validation',
    '72000000-0000-4000-8000-000000000002',
    '72000000-0000-4000-8000-000000000002', '2.0.0', 2, 'PENDING_VALIDATION',
    '2026-08-12T10:30:00Z'
  ),
  (
    '73000000-0000-4000-8000-000000000003', 'synthetic-confirm-validation-v1',
    'registration', 'confirm_validation',
    '72000000-0000-4000-8000-000000000002',
    '72000000-0000-4000-8000-000000000002', '3.0.0', 3, 'VALIDATED',
    '2026-08-12T11:00:00Z'
  );

INSERT INTO public.kf_source_governance_events (
  event_id, dimension, aggregate_id, aggregate_version, sequence, event_type,
  subject_identity_id, actor_id, actor_role, reason, occurred_at, effective_at,
  correlation_id, command_id, registration_from_state, registration_to_state
) VALUES
  (
    '73100000-0000-4000-8000-000000000001', 'registration',
    '72000000-0000-4000-8000-000000000002', '1.0.0', 1, 'source_registered',
    '72000000-0000-4000-8000-000000000002',
    '70000000-0000-4000-8000-000000000001', 'curator', 'synthetic registration',
    '2026-08-12T10:00:00Z', '2026-08-12T10:00:00Z',
    '73900000-0000-4000-8000-000000000001',
    '73000000-0000-4000-8000-000000000001', NULL, 'REGISTERED'
  ),
  (
    '73100000-0000-4000-8000-000000000002', 'registration',
    '72000000-0000-4000-8000-000000000002', '2.0.0', 2,
    'source_validation_requested',
    '72000000-0000-4000-8000-000000000002',
    '70000000-0000-4000-8000-000000000001', 'curator',
    'synthetic validation request',
    '2026-08-12T10:30:00Z', '2026-08-12T10:30:00Z',
    '73900000-0000-4000-8000-000000000001',
    '73000000-0000-4000-8000-000000000002',
    'REGISTERED', 'PENDING_VALIDATION'
  ),
  (
    '73100000-0000-4000-8000-000000000003', 'registration',
    '72000000-0000-4000-8000-000000000002', '3.0.0', 3, 'source_validated',
    '72000000-0000-4000-8000-000000000002',
    '70000000-0000-4000-8000-000000000001', 'curator',
    'synthetic validation',
    '2026-08-12T11:00:00Z', '2026-08-12T11:00:00Z',
    '73900000-0000-4000-8000-000000000001',
    '73000000-0000-4000-8000-000000000003',
    'PENDING_VALIDATION', 'VALIDATED'
  );

INSERT INTO public.kf_source_command_receipt_events (command_id, event_id, event_order)
VALUES
  ('73000000-0000-4000-8000-000000000001', '73100000-0000-4000-8000-000000000001', 1),
  ('73000000-0000-4000-8000-000000000002', '73100000-0000-4000-8000-000000000002', 1),
  ('73000000-0000-4000-8000-000000000003', '73100000-0000-4000-8000-000000000003', 1);

-- ---------------------------------------------------------------------------
-- 4. Authorization history: grant followed by revocation
-- ---------------------------------------------------------------------------
INSERT INTO public.kf_source_command_receipts (
  command_id, fingerprint, dimension, operation, aggregate_id,
  authorization_id, aggregate_version, sequence, authorization_state,
  committed_at
) VALUES
  (
    '73200000-0000-4000-8000-000000000001', 'synthetic-grant-retrieval-v1',
    'authorization', 'grant_authorization',
    '72200000-0000-4000-8000-000000000001',
    '72200000-0000-4000-8000-000000000001', '1.0.0', 1, 'GRANTED',
    '2026-08-12T12:00:00Z'
  ),
  (
    '73200000-0000-4000-8000-000000000002', 'synthetic-revoke-retrieval-v1',
    'authorization', 'revoke_authorization',
    '72200000-0000-4000-8000-000000000001',
    '72200000-0000-4000-8000-000000000001', '2.0.0', 2, 'REVOKED',
    '2026-08-12T13:00:00Z'
  );

INSERT INTO public.kf_source_governance_events (
  event_id, dimension, aggregate_id, aggregate_version, sequence, event_type,
  subject_identity_id, authorization_id, purpose, restrictions, basis_id,
  actor_id, actor_role, reason, occurred_at, effective_at, correlation_id,
  command_id, authorization_from_state, authorization_to_state,
  effective_from, effective_until
) VALUES
  (
    '73300000-0000-4000-8000-000000000001', 'authorization',
    '72200000-0000-4000-8000-000000000001', '1.0.0', 1,
    'authorization_granted',
    '72000000-0000-4000-8000-000000000002',
    '72200000-0000-4000-8000-000000000001', 'retrieval', ARRAY[]::text[],
    '72100000-0000-4000-8000-000000000001',
    '70000000-0000-4000-8000-000000000002', 'legal_editorial_reviewer',
    'synthetic authorization grant',
    '2026-08-12T12:00:00Z', '2026-08-12T12:00:00Z',
    '73900000-0000-4000-8000-000000000002',
    '73200000-0000-4000-8000-000000000001', NULL, 'GRANTED',
    '2026-08-12T12:00:00Z', '2026-08-12T14:00:00Z'
  ),
  (
    '73300000-0000-4000-8000-000000000002', 'authorization',
    '72200000-0000-4000-8000-000000000001', '2.0.0', 2,
    'authorization_revoked',
    '72000000-0000-4000-8000-000000000002',
    '72200000-0000-4000-8000-000000000001', 'retrieval', ARRAY[]::text[],
    '72100000-0000-4000-8000-000000000001',
    '70000000-0000-4000-8000-000000000002', 'legal_editorial_reviewer',
    'synthetic authorization revocation',
    '2026-08-12T13:00:00Z', '2026-08-12T13:00:00Z',
    '73900000-0000-4000-8000-000000000002',
    '73200000-0000-4000-8000-000000000002', 'GRANTED', 'REVOKED',
    '2026-08-12T12:00:00Z', '2026-08-12T14:00:00Z'
  );

INSERT INTO public.kf_source_command_receipt_events (command_id, event_id, event_order)
VALUES
  ('73200000-0000-4000-8000-000000000001', '73300000-0000-4000-8000-000000000001', 1),
  ('73200000-0000-4000-8000-000000000002', '73300000-0000-4000-8000-000000000002', 1);

SELECT pg_temp.assert_true(
  (
    SELECT count(*) = 2
    FROM public.kf_source_governance_events
    WHERE authorization_id = '72200000-0000-4000-8000-000000000001'
  ),
  'revocation must preserve the earlier grant'
);

SELECT pg_temp.assert_true(
  (
    SELECT authorization_to_state = 'GRANTED'
    FROM public.kf_source_governance_events
    WHERE authorization_id = '72200000-0000-4000-8000-000000000001'
      AND effective_at <= '2026-08-12T12:30:00Z'
    ORDER BY effective_at DESC, sequence DESC, event_id DESC
    LIMIT 1
  ),
  'authorization history must be reconstructible as of an explicit instant'
);

SELECT pg_temp.assert_true(
  NOT EXISTS (
    SELECT 1
    FROM public.kf_source_authorizations
    WHERE subject_identity_id = '72000000-0000-4000-8000-000000000003'
  ),
  'a successor or separate source version must not inherit authorization'
);

SELECT pg_temp.assert_true(
  NOT EXISTS (
    SELECT 1
    FROM public.kf_source_authorizations
    WHERE subject_identity_id = '72000000-0000-4000-8000-000000000002'
      AND purpose = 'generation'
  ),
  'one purpose must not imply another purpose'
);

-- ---------------------------------------------------------------------------
-- 5. Constraint negatives
-- ---------------------------------------------------------------------------
SELECT pg_temp.expect_error(
  $sql$INSERT INTO public.kf_source_identities (kind) VALUES ('not_an_identity')$sql$,
  ARRAY['23514']::text[],
  'unknown identity kind must be rejected'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_source_identities (kind, legacy_source_id)
    VALUES ('work', '71000000-0000-4000-8000-000000000001')
  $sql$,
  ARRAY['23514']::text[],
  'legacy source link must only belong to governed_source identity'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_source_authorizations (
      subject_identity_id, purpose, basis_id, effective_from, effective_until,
      projected_state, aggregate_version, sequence
    ) VALUES (
      '72000000-0000-4000-8000-000000000002', 'not_a_purpose',
      '72100000-0000-4000-8000-000000000001',
      '2026-08-12T12:00:00Z', NULL, 'GRANTED', '1.0.0', 1
    )
  $sql$,
  ARRAY['23514']::text[],
  'unknown purpose must be rejected'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_source_authorizations (
      subject_identity_id, purpose, basis_id, effective_from, effective_until,
      projected_state, aggregate_version, sequence
    ) VALUES (
      '72000000-0000-4000-8000-000000000002', 'generation',
      '72100000-0000-4000-8000-000000000001',
      '2026-08-12T14:00:00Z', '2026-08-12T13:00:00Z',
      'GRANTED', '1.0.0', 1
    )
  $sql$,
  ARRAY['23514']::text[],
  'effectiveUntil before effectiveFrom must be rejected'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_source_registration_projections (
      subject_identity_id, projected_state, aggregate_version, sequence
    ) VALUES (
      '72000000-0000-4000-8000-000000000004', 'REPLACED', '1.0.0', 1
    )
  $sql$,
  ARRAY['23514']::text[],
  'REPLACED projection must identify a successor'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_source_command_receipts (
      command_id, fingerprint, dimension, operation, aggregate_id,
      subject_identity_id, aggregate_version, sequence, registration_state
    ) VALUES (
      '73000000-0000-4000-8000-000000000001', 'different-fingerprint',
      'registration', 'register_identity',
      '72000000-0000-4000-8000-000000000002',
      '72000000-0000-4000-8000-000000000002', '1.0.0', 1, 'REGISTERED'
    )
  $sql$,
  ARRAY['23505']::text[],
  'same commandId cannot persist a second fingerprint'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_source_command_receipts (
      command_id, fingerprint, dimension, operation, aggregate_id,
      authorization_id, aggregate_version, sequence, authorization_state
    ) VALUES (
      '73400000-0000-4000-8000-000000000001', 'mismatched-receipt-shape',
      'authorization', 'register_identity',
      '72200000-0000-4000-8000-000000000001',
      '72200000-0000-4000-8000-000000000001', '3.0.0', 3, 'GRANTED'
    )
  $sql$,
  ARRAY['23514']::text[],
  'receipt operation must match its lifecycle dimension'
);

SELECT pg_temp.expect_error(
  $sql$
    INSERT INTO public.kf_source_governance_events (
      event_id, dimension, aggregate_id, aggregate_version, sequence, event_type,
      subject_identity_id, actor_id, actor_role, reason, occurred_at, effective_at,
      correlation_id, command_id, registration_to_state
    ) VALUES (
      '73100000-0000-4000-8000-000000000099', 'registration',
      '72000000-0000-4000-8000-000000000002', '99.0.0', 3,
      'source_archived', '72000000-0000-4000-8000-000000000002',
      '70000000-0000-4000-8000-000000000001', 'curator', 'duplicate sequence',
      now(), now(), '73900000-0000-4000-8000-000000000001',
      '73000000-0000-4000-8000-000000000003', 'ARCHIVED'
    )
  $sql$,
  ARRAY['23505']::text[],
  'aggregate sequence must be unique'
);

-- ---------------------------------------------------------------------------
-- 6. Append-only protection, including privileged test executor
-- ---------------------------------------------------------------------------
SELECT pg_temp.expect_error(
  $sql$
    UPDATE public.kf_source_governance_events
    SET reason = 'must fail'
    WHERE event_id = '73300000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['55000']::text[],
  'governance events must reject UPDATE'
);

SELECT pg_temp.expect_error(
  $sql$
    DELETE FROM public.kf_source_governance_events
    WHERE event_id = '73300000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['55000']::text[],
  'governance events must reject DELETE'
);

SELECT pg_temp.expect_error(
  $sql$
    UPDATE public.kf_source_command_receipts
    SET fingerprint = 'must-fail'
    WHERE command_id = '73200000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['55000']::text[],
  'command receipts must reject UPDATE'
);

SELECT pg_temp.expect_error(
  $sql$
    DELETE FROM public.kf_source_authorization_bases
    WHERE id = '72100000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['55000']::text[],
  'authorization bases must reject DELETE'
);

SELECT pg_temp.expect_error(
  $sql$
    UPDATE public.kf_source_authorizations
    SET purpose = 'generation'
    WHERE id = '72200000-0000-4000-8000-000000000001'
  $sql$,
  ARRAY['55000']::text[],
  'authorization subject, purpose, scope, basis and window must be immutable'
);

ROLLBACK;
