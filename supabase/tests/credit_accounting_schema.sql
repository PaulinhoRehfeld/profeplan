\set ON_ERROR_STOP on

-- Lote 1.3B.1 disposable schema proof.
-- Runs only against the disposable Supabase stack created by CI.

DO $$
BEGIN
  IF to_regclass('public.credit_operations') IS NULL THEN
    RAISE EXCEPTION 'credit_operations missing';
  END IF;
  IF to_regclass('public.credit_grants') IS NULL THEN
    RAISE EXCEPTION 'credit_grants missing';
  END IF;
  IF to_regclass('public.credit_ledger_entries') IS NULL THEN
    RAISE EXCEPTION 'credit_ledger_entries missing';
  END IF;
END;
$$;

-- RLS must be enabled and direct user policies must not exist yet.
DO $$
DECLARE
  v_rls_count integer;
  v_policy_count integer;
BEGIN
  SELECT count(*) INTO v_rls_count
  FROM pg_class c
  JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE n.nspname = 'public'
    AND c.relname IN ('credit_operations', 'credit_grants', 'credit_ledger_entries')
    AND c.relrowsecurity = true;

  IF v_rls_count <> 3 THEN
    RAISE EXCEPTION 'expected RLS on all credit accounting tables, got %', v_rls_count;
  END IF;

  SELECT count(*) INTO v_policy_count
  FROM pg_policies
  WHERE schemaname = 'public'
    AND tablename IN ('credit_operations', 'credit_grants', 'credit_ledger_entries');

  IF v_policy_count <> 0 THEN
    RAISE EXCEPTION '1.3B.1 must not expose direct authenticated policies, got %', v_policy_count;
  END IF;
END;
$$;

-- Least privilege: anon/authenticated get no table privileges; service_role is
-- append-only (SELECT + INSERT, no UPDATE/DELETE).
DO $$
DECLARE
  v_table text;
BEGIN
  FOREACH v_table IN ARRAY ARRAY['credit_operations', 'credit_grants', 'credit_ledger_entries']
  LOOP
    IF has_table_privilege('anon', 'public.' || v_table, 'SELECT')
       OR has_table_privilege('authenticated', 'public.' || v_table, 'SELECT')
       OR has_table_privilege('authenticated', 'public.' || v_table, 'INSERT') THEN
      RAISE EXCEPTION 'direct user privilege leaked on %', v_table;
    END IF;

    IF NOT has_table_privilege('service_role', 'public.' || v_table, 'SELECT')
       OR NOT has_table_privilege('service_role', 'public.' || v_table, 'INSERT')
       OR has_table_privilege('service_role', 'public.' || v_table, 'UPDATE')
       OR has_table_privilege('service_role', 'public.' || v_table, 'DELETE') THEN
      RAISE EXCEPTION 'service_role least-privilege mismatch on %', v_table;
    END IF;
  END LOOP;
END;
$$;

INSERT INTO public.profiles (id, tier, credits, is_unlimited) VALUES
  ('11111111-1111-1111-1111-111111111111', 'FREE', 10, false),
  ('22222222-2222-2222-2222-222222222222', 'FREE', 10, false);

-- Valid FREE trial: exactly 10 credits for exactly seven days.
INSERT INTO public.credit_operations (
  operation_id, user_id, operation_kind, action_key, request_fingerprint,
  outcome, requested_amount, applied_amount
) VALUES (
  'grant:free:11111111-1111-1111-1111-111111111111',
  '11111111-1111-1111-1111-111111111111',
  'GRANT', 'FREE_TRIAL', 'fp-free-a', 'APPLIED', 10, 10
);

INSERT INTO public.credit_grants (
  id, user_id, operation_id, grant_key, origin, granted_amount, granted_at, expires_at
) VALUES (
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  '11111111-1111-1111-1111-111111111111',
  'grant:free:11111111-1111-1111-1111-111111111111',
  'free-trial:11111111-1111-1111-1111-111111111111',
  'FREE_TRIAL', 10, '2026-08-14T12:00:00Z', '2026-08-21T12:00:00Z'
);

INSERT INTO public.credit_ledger_entries (
  user_id, operation_id, grant_id, entry_type, amount
) VALUES (
  '11111111-1111-1111-1111-111111111111',
  'grant:free:11111111-1111-1111-1111-111111111111',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  'CREDIT', 10
);

-- Valid PURCHASED grant is non-expiring and funded by the same GRANT receipt.
INSERT INTO public.credit_operations (
  operation_id, user_id, operation_kind, action_key, request_fingerprint,
  outcome, requested_amount, applied_amount
) VALUES (
  'grant:stripe:evt_test_001',
  '11111111-1111-1111-1111-111111111111',
  'GRANT', 'SILVER_PURCHASE', 'fp-stripe-001', 'APPLIED', 40, 40
);

INSERT INTO public.credit_grants (
  id, user_id, operation_id, grant_key, origin, granted_amount, source_reference
) VALUES (
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  '11111111-1111-1111-1111-111111111111',
  'grant:stripe:evt_test_001',
  'stripe:evt_test_001',
  'PURCHASED', 40, 'evt_test_001'
);

INSERT INTO public.credit_ledger_entries (
  user_id, operation_id, grant_id, entry_type, amount
) VALUES (
  '11111111-1111-1111-1111-111111111111',
  'grant:stripe:evt_test_001',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  'CREDIT', 40
);

-- Valid paid consumption and valid Gold/unlimited no-charge receipt shape.
INSERT INTO public.credit_operations (
  operation_id, user_id, operation_kind, action_key, request_fingerprint,
  outcome, requested_amount, applied_amount, artifact_type, artifact_id
) VALUES (
  'consume:save:001',
  '11111111-1111-1111-1111-111111111111',
  'CONSUME', 'SAVE_TERM_PLAN', 'fp-save-001', 'APPLIED', 1, 1, 'term_plan', 'term-plan-001'
);

INSERT INTO public.credit_ledger_entries (
  user_id, operation_id, grant_id, entry_type, amount
) VALUES (
  '11111111-1111-1111-1111-111111111111',
  'consume:save:001',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  'DEBIT', 1
);

INSERT INTO public.credit_operations (
  operation_id, user_id, operation_kind, action_key, request_fingerprint,
  outcome, requested_amount, applied_amount, reason_code
) VALUES (
  'consume:gold:001',
  '11111111-1111-1111-1111-111111111111',
  'CONSUME', 'SAVE_ASSESSMENT', 'fp-gold-001', 'NO_CHARGE', 1, 0, 'GOLD_UNLIMITED'
);

-- FREE_TRIAL cannot omit expiry.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'grant:bad-free:no-expiry',
      '22222222-2222-2222-2222-222222222222',
      'GRANT', 'FREE_TRIAL', 'fp-bad-free', 'APPLIED', 10, 10
    );

    INSERT INTO public.credit_grants (
      user_id, operation_id, grant_key, origin, granted_amount
    ) VALUES (
      '22222222-2222-2222-2222-222222222222',
      'grant:bad-free:no-expiry',
      'free-trial:bad-no-expiry',
      'FREE_TRIAL', 10
    );

    RAISE EXCEPTION 'FREE_TRIAL without expiry was accepted';
  EXCEPTION
    WHEN check_violation THEN NULL;
  END;
END;
$$;

-- FREE_TRIAL is exactly 10 credits, not an arbitrary promotion size.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'grant:bad-free:amount',
      '22222222-2222-2222-2222-222222222222',
      'GRANT', 'FREE_TRIAL', 'fp-bad-free-amount', 'APPLIED', 9, 9
    );

    INSERT INTO public.credit_grants (
      user_id, operation_id, grant_key, origin, granted_amount, granted_at, expires_at
    ) VALUES (
      '22222222-2222-2222-2222-222222222222',
      'grant:bad-free:amount',
      'free-trial:bad-amount',
      'FREE_TRIAL', 9, '2026-08-14T12:00:00Z', '2026-08-21T12:00:00Z'
    );

    RAISE EXCEPTION 'FREE_TRIAL with amount other than 10 was accepted';
  EXCEPTION
    WHEN check_violation THEN NULL;
  END;
END;
$$;

-- FREE_TRIAL duration is exactly seven days.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'grant:bad-free:window',
      '22222222-2222-2222-2222-222222222222',
      'GRANT', 'FREE_TRIAL', 'fp-bad-free-window', 'APPLIED', 10, 10
    );

    INSERT INTO public.credit_grants (
      user_id, operation_id, grant_key, origin, granted_amount, granted_at, expires_at
    ) VALUES (
      '22222222-2222-2222-2222-222222222222',
      'grant:bad-free:window',
      'free-trial:bad-window',
      'FREE_TRIAL', 10, '2026-08-14T12:00:00Z', '2026-08-20T12:00:00Z'
    );

    RAISE EXCEPTION 'FREE_TRIAL with duration other than seven days was accepted';
  EXCEPTION
    WHEN check_violation THEN NULL;
  END;
END;
$$;

-- PURCHASED must never receive automatic expiry.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'grant:bad-purchased:expiry',
      '22222222-2222-2222-2222-222222222222',
      'GRANT', 'SILVER_PURCHASE', 'fp-bad-purchased', 'APPLIED', 40, 40
    );

    INSERT INTO public.credit_grants (
      user_id, operation_id, grant_key, origin, granted_amount, expires_at
    ) VALUES (
      '22222222-2222-2222-2222-222222222222',
      'grant:bad-purchased:expiry',
      'stripe:bad-expiry',
      'PURCHASED', 40, now() + interval '30 days'
    );

    RAISE EXCEPTION 'PURCHASED grant with expiry was accepted';
  EXCEPTION
    WHEN check_violation THEN NULL;
  END;
END;
$$;

-- LEGACY_BALANCE must remain non-expiring when provenance is ambiguous.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'grant:bad-legacy:expiry',
      '22222222-2222-2222-2222-222222222222',
      'GRANT', 'LEGACY_MIGRATION', 'fp-bad-legacy', 'APPLIED', 25, 25
    );

    INSERT INTO public.credit_grants (
      user_id, operation_id, grant_key, origin, granted_amount, expires_at
    ) VALUES (
      '22222222-2222-2222-2222-222222222222',
      'grant:bad-legacy:expiry',
      'legacy:bad-expiry',
      'LEGACY_BALANCE', 25, now() + interval '365 days'
    );

    RAISE EXCEPTION 'LEGACY_BALANCE with expiry was accepted';
  EXCEPTION
    WHEN check_violation THEN NULL;
  END;
END;
$$;

-- A user receives only one initial FREE_TRIAL lot.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'grant:duplicate-free:user-a',
      '11111111-1111-1111-1111-111111111111',
      'GRANT', 'FREE_TRIAL', 'fp-free-duplicate', 'APPLIED', 10, 10
    );

    INSERT INTO public.credit_grants (
      user_id, operation_id, grant_key, origin, granted_amount, granted_at, expires_at
    ) VALUES (
      '11111111-1111-1111-1111-111111111111',
      'grant:duplicate-free:user-a',
      'free-trial:duplicate-user-a',
      'FREE_TRIAL', 10, '2026-08-15T12:00:00Z', '2026-08-22T12:00:00Z'
    );

    RAISE EXCEPTION 'second FREE_TRIAL lot for same user was accepted';
  EXCEPTION
    WHEN unique_violation THEN NULL;
  END;
END;
$$;

-- grant_key is producer-idempotent.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'grant:duplicate-key:001',
      '22222222-2222-2222-2222-222222222222',
      'GRANT', 'SILVER_PURCHASE', 'fp-duplicate-key', 'APPLIED', 40, 40
    );

    INSERT INTO public.credit_grants (
      user_id, operation_id, grant_key, origin, granted_amount
    ) VALUES (
      '22222222-2222-2222-2222-222222222222',
      'grant:duplicate-key:001',
      'stripe:evt_test_001',
      'PURCHASED', 40
    );

    RAISE EXCEPTION 'duplicate grant_key was accepted';
  EXCEPTION
    WHEN unique_violation THEN NULL;
  END;
END;
$$;

-- A grant cannot disagree with the amount recorded by its GRANT operation.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'grant:mismatched-amount:001',
      '22222222-2222-2222-2222-222222222222',
      'GRANT', 'ADMIN_ADJUSTMENT', 'fp-mismatched-grant', 'APPLIED', 20, 20
    );

    INSERT INTO public.credit_grants (
      user_id, operation_id, grant_key, origin, granted_amount
    ) VALUES (
      '22222222-2222-2222-2222-222222222222',
      'grant:mismatched-amount:001',
      'admin:mismatched-amount:001',
      'ADMIN_ADJUSTMENT', 10
    );

    RAISE EXCEPTION 'grant amount different from operation amount was accepted';
  EXCEPTION
    WHEN check_violation THEN NULL;
  END;
END;
$$;

-- A CONSUME receipt cannot create a grant.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'consume:cannot-create-grant:001',
      '22222222-2222-2222-2222-222222222222',
      'CONSUME', 'SAVE_DOCUMENT', 'fp-consume-grant', 'APPLIED', 5, 5
    );

    INSERT INTO public.credit_grants (
      user_id, operation_id, grant_key, origin, granted_amount
    ) VALUES (
      '22222222-2222-2222-2222-222222222222',
      'consume:cannot-create-grant:001',
      'admin:from-consume:001',
      'ADMIN_ADJUSTMENT', 5
    );

    RAISE EXCEPTION 'CONSUME operation created a grant';
  EXCEPTION
    WHEN check_violation THEN NULL;
  END;
END;
$$;

-- Each grant can be funded by only one CREDIT ledger entry.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_ledger_entries (
      user_id, operation_id, grant_id, entry_type, amount
    ) VALUES (
      '11111111-1111-1111-1111-111111111111',
      'grant:free:11111111-1111-1111-1111-111111111111',
      'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
      'CREDIT', 10
    );

    RAISE EXCEPTION 'second CREDIT entry for same grant was accepted';
  EXCEPTION
    WHEN unique_violation THEN NULL;
  END;
END;
$$;

-- A CREDIT entry must equal its grant's funded amount.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'grant:credit-mismatch:001',
      '22222222-2222-2222-2222-222222222222',
      'GRANT', 'ADMIN_ADJUSTMENT', 'fp-credit-mismatch', 'APPLIED', 5, 5
    );

    INSERT INTO public.credit_grants (
      id, user_id, operation_id, grant_key, origin, granted_amount
    ) VALUES (
      'cccccccc-cccc-cccc-cccc-cccccccccccc',
      '22222222-2222-2222-2222-222222222222',
      'grant:credit-mismatch:001',
      'admin:credit-mismatch:001',
      'ADMIN_ADJUSTMENT', 5
    );

    INSERT INTO public.credit_ledger_entries (
      user_id, operation_id, grant_id, entry_type, amount
    ) VALUES (
      '22222222-2222-2222-2222-222222222222',
      'grant:credit-mismatch:001',
      'cccccccc-cccc-cccc-cccc-cccccccccccc',
      'CREDIT', 4
    );

    RAISE EXCEPTION 'CREDIT entry different from grant amount was accepted';
  EXCEPTION
    WHEN check_violation THEN NULL;
  END;
END;
$$;

-- Composite user attribution prevents cross-account ledger allocation.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'consume:cross-user:001',
      '22222222-2222-2222-2222-222222222222',
      'CONSUME', 'SAVE_DOCUMENT', 'fp-cross-user', 'APPLIED', 1, 1
    );

    INSERT INTO public.credit_ledger_entries (
      user_id, operation_id, grant_id, entry_type, amount
    ) VALUES (
      '22222222-2222-2222-2222-222222222222',
      'consume:cross-user:001',
      'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
      'DEBIT', 1
    );

    RAISE EXCEPTION 'cross-user grant allocation was accepted';
  EXCEPTION
    WHEN foreign_key_violation THEN NULL;
  END;
END;
$$;

-- GRANT operations cannot generate DEBIT entries.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'grant:no-debit:001',
      '22222222-2222-2222-2222-222222222222',
      'GRANT', 'PROMOTIONAL_BONUS', 'fp-no-debit', 'APPLIED', 3, 3
    );

    INSERT INTO public.credit_grants (
      id, user_id, operation_id, grant_key, origin, granted_amount
    ) VALUES (
      'dddddddd-dddd-dddd-dddd-dddddddddddd',
      '22222222-2222-2222-2222-222222222222',
      'grant:no-debit:001',
      'promo:no-debit:001',
      'PROMOTIONAL_BONUS', 3
    );

    INSERT INTO public.credit_ledger_entries (
      user_id, operation_id, grant_id, entry_type, amount
    ) VALUES (
      '22222222-2222-2222-2222-222222222222',
      'grant:no-debit:001',
      'dddddddd-dddd-dddd-dddd-dddddddddddd',
      'DEBIT', 1
    );

    RAISE EXCEPTION 'GRANT operation generated a DEBIT entry';
  EXCEPTION
    WHEN check_violation THEN NULL;
  END;
END;
$$;

-- Rejected/no-charge consumption cannot produce ledger debits.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount, reason_code
    ) VALUES (
      'consume:rejected-with-debit:001',
      '11111111-1111-1111-1111-111111111111',
      'CONSUME', 'SAVE_DOCUMENT', 'fp-rejected-debit', 'REJECTED', 1, 0, 'INSUFFICIENT_CREDITS'
    );

    INSERT INTO public.credit_ledger_entries (
      user_id, operation_id, grant_id, entry_type, amount
    ) VALUES (
      '11111111-1111-1111-1111-111111111111',
      'consume:rejected-with-debit:001',
      'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
      'DEBIT', 1
    );

    RAISE EXCEPTION 'REJECTED consumption generated a ledger DEBIT';
  EXCEPTION
    WHEN check_violation THEN NULL;
  END;
END;
$$;

-- Outcome/amount shapes are deterministic.
DO $$
BEGIN
  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'consume:bad-no-charge:001',
      '11111111-1111-1111-1111-111111111111',
      'CONSUME', 'SAVE_DOCUMENT', 'fp-bad-no-charge', 'NO_CHARGE', 1, 1
    );
    RAISE EXCEPTION 'NO_CHARGE operation with applied amount was accepted';
  EXCEPTION
    WHEN check_violation THEN NULL;
  END;

  BEGIN
    INSERT INTO public.credit_operations (
      operation_id, user_id, operation_kind, action_key, request_fingerprint,
      outcome, requested_amount, applied_amount
    ) VALUES (
      'consume:bad-partial:001',
      '11111111-1111-1111-1111-111111111111',
      'CONSUME', 'SAVE_DOCUMENT', 'fp-bad-partial', 'APPLIED', 2, 1
    );
    RAISE EXCEPTION 'partial APPLIED amount was accepted';
  EXCEPTION
    WHEN check_violation THEN NULL;
  END;
END;
$$;

SELECT 'OK:credit_accounting_schema_1_3B_1' AS result;
