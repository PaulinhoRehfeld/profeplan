-- =============================================================================
-- Migration: Criar perfil para usuários sem linha em profiles
-- Projeto: PROFEPLAN V4
-- Data: 2026-06-17
-- COMO USAR: Cole no Supabase SQL Editor e execute como service_role
-- =============================================================================

-- Cria perfil para todos os usuários em auth.users que ainda não têm perfil
INSERT INTO public.profiles (id, email, full_name, role, is_admin, tier, is_unlimited, credits)
SELECT
    u.id,
    u.email,
    COALESCE(
        u.raw_user_meta_data->>'full_name',
        u.raw_user_meta_data->>'name',
        split_part(u.email, '@', 1)
    ) AS full_name,
    'teacher'   AS role,
    false       AS is_admin,
    'FREE'      AS tier,
    false       AS is_unlimited,
    10          AS credits
FROM auth.users u
WHERE NOT EXISTS (
    SELECT 1 FROM public.profiles p WHERE p.id = u.id
)
ON CONFLICT (id) DO NOTHING;

-- Garante admins hardcoded
UPDATE public.profiles
SET
    role         = 'admin',
    is_admin     = true,
    tier         = 'GOLD',
    credits      = 9999,
    is_unlimited = true
WHERE email IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br');

DO $$
DECLARE
  fixed_count int;
BEGIN
  SELECT COUNT(*) INTO fixed_count
  FROM auth.users u
  WHERE EXISTS (SELECT 1 FROM public.profiles p WHERE p.id = u.id);

  RAISE NOTICE '✅ Total de usuários com perfil após correção: %', fixed_count;
END;
$$;
