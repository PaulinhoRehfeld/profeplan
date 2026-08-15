-- =============================================================================
-- ProfePlan — Lote 1.3C.3 synthetic positive-producer baseline
-- TEST ONLY. Never a production migration.
-- =============================================================================

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS full_name text,
  ADD COLUMN IF NOT EXISTS email text,
  ADD COLUMN IF NOT EXISTS role text NOT NULL DEFAULT 'teacher',
  ADD COLUMN IF NOT EXISTS is_admin boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS phone text,
  ADD COLUMN IF NOT EXISTS masp text,
  ADD COLUMN IF NOT EXISTS city text,
  ADD COLUMN IF NOT EXISTS favorite_methodology text,
  ADD COLUMN IF NOT EXISTS teaching_style text,
  ADD COLUMN IF NOT EXISTS assessment_focus text,
  ADD COLUMN IF NOT EXISTS tone_of_voice text,
  ADD COLUMN IF NOT EXISTS header_text text,
  ADD COLUMN IF NOT EXISTS footer_text text,
  ADD COLUMN IF NOT EXISTS logo_base64 text;

CREATE OR REPLACE FUNCTION public.is_hardcoded_admin(p_email text)
RETURNS boolean
LANGUAGE sql
STABLE
AS $$
  SELECT false;
$$;

CREATE TABLE IF NOT EXISTS public.referrals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  referrer_id uuid NOT NULL REFERENCES public.profiles(id),
  referee_email text NOT NULL,
  status text NOT NULL DEFAULT 'pending',
  created_at timestamptz NOT NULL DEFAULT now()
);

-- Auth identities that predate the 1.3C.3 migration. No signup trigger exists
-- yet in this disposable baseline, so their profiles are seeded explicitly.
INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at
) VALUES
(
  '00000000-0000-4000-8000-000000000401',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'admin-c3@example.invalid', '', now(),
  '{}'::jsonb, '{}'::jsonb, now(), now()
),
(
  '00000000-0000-4000-8000-000000000402',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'phone-c3@example.invalid', '', now(),
  '{}'::jsonb, '{}'::jsonb, now(), now()
),
(
  '00000000-0000-4000-8000-000000000403',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'phone-legacy-c3@example.invalid', '', now(),
  '{}'::jsonb, '{}'::jsonb, now(), now()
),
(
  '00000000-0000-4000-8000-000000000404',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'referrer-c3@example.invalid', '', now(),
  '{}'::jsonb, '{}'::jsonb, now(), now()
),
(
  '00000000-0000-4000-8000-000000000405',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'referee-c3@example.invalid', '', now(),
  '{}'::jsonb, '{}'::jsonb, now(), now()
),
(
  '00000000-0000-4000-8000-000000000409',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'emergency-c3@example.invalid', '', now(),
  '{}'::jsonb, '{}'::jsonb, now(), now()
),
(
  '00000000-0000-4000-8000-000000000410',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'teacher-c3@example.invalid', '', now(),
  '{}'::jsonb, '{}'::jsonb, now(), now()
),
(
  '00000000-0000-4000-8000-000000000412',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'ambiguous-c3@example.invalid', '', now(),
  '{}'::jsonb, '{}'::jsonb, now(), now()
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (
  id, email, role, is_admin, tier, is_unlimited, credits, phone
) VALUES
(
  '00000000-0000-4000-8000-000000000401',
  'admin-c3@example.invalid', 'admin', true, 'GOLD', true, 0, NULL
),
(
  '00000000-0000-4000-8000-000000000402',
  'phone-c3@example.invalid', 'teacher', false, 'FREE', false, 0, NULL
),
(
  '00000000-0000-4000-8000-000000000403',
  'phone-legacy-c3@example.invalid', 'teacher', false, 'FREE', false, 0, '+550000000403'
),
(
  '00000000-0000-4000-8000-000000000404',
  'referrer-c3@example.invalid', 'teacher', false, 'FREE', false, 0, NULL
),
(
  '00000000-0000-4000-8000-000000000405',
  'referee-c3@example.invalid', 'teacher', false, 'FREE', false, 0, NULL
),
(
  '00000000-0000-4000-8000-000000000406',
  'silver-c3@example.invalid', 'teacher', false, 'FREE', false, 0, NULL
),
(
  '00000000-0000-4000-8000-000000000407',
  'gold-with-balance-c3@example.invalid', 'teacher', false, 'GOLD', true, 0, NULL
),
(
  '00000000-0000-4000-8000-000000000408',
  'admin-target-c3@example.invalid', 'teacher', false, 'FREE', false, 0, NULL
),
(
  '00000000-0000-4000-8000-000000000410',
  'teacher-c3@example.invalid', 'teacher', false, 'FREE', false, 0, NULL
),
(
  '00000000-0000-4000-8000-000000000411',
  'phone-rollback-c3@example.invalid', 'teacher', false, 'FREE', false, 0, NULL
),
(
  '00000000-0000-4000-8000-000000000412',
  'ambiguous-c3@example.invalid', 'teacher', false, 'FREE', false, 0, NULL
),
(
  '00000000-0000-4000-8000-000000000413',
  'stripe-rollback-c3@example.invalid', 'teacher', false, 'FREE', false, 0, NULL
),
(
  '00000000-0000-4000-8000-000000000414',
  'gold-empty-c3@example.invalid', 'teacher', false, 'FREE', false, 0, NULL
);

INSERT INTO public.referrals (
  id, referrer_id, referee_email, status, created_at
) VALUES
(
  '00000000-0000-4000-8000-000000000451',
  '00000000-0000-4000-8000-000000000404',
  'referee-c3@example.invalid',
  'pending',
  '2026-08-14 20:00:00+00'
),
(
  '00000000-0000-4000-8000-000000000452',
  '00000000-0000-4000-8000-000000000404',
  'ambiguous-c3@example.invalid',
  'pending',
  '2026-08-14 20:01:00+00'
),
(
  '00000000-0000-4000-8000-000000000453',
  '00000000-0000-4000-8000-000000000410',
  'ambiguous-c3@example.invalid',
  'pending',
  '2026-08-14 20:02:00+00'
);
