-- ==============================================================================
-- MIGRAÇÃO CONSOLIDADA: CORREÇÃO DO ERRO "new row violates RLS" AO SALVAR PERFIL
-- Data: 2026-07-09
-- Problema: Usuários não conseguem salvar o perfil em Configurações.
--   Erro: "new row violates row-level security policy for table profiles"
--
-- CAUSA RAIZ TRIPLA:
--   1. RPC update_my_profile NÃO implantada → frontend cai no fallback direto
--   2. Fallback UPDATE afeta 0 linhas (Ghost ID: profiles.id ≠ auth.uid())
--   3. Upsert de recuperação viola RLS (WITH CHECK id = auth.uid())
--   4. Colunas pedagógicas (favorite_methodology, teaching_style, etc.) 
--      podem não existir na tabela profiles
--
-- O QUE ESTA MIGRATION FAZ (ordem correta):
--   A) Adiciona colunas que faltam na tabela profiles
--   B) Cria/atualiza a RPC get_my_profile() — leitura segura (bypass RLS)
--   C) Cria/atualiza a RPC update_my_profile() — escrita segura (bypass RLS)
--   D) Garante políticas RLS mínimas e corretas
--   E) Cria perfis faltantes (backfill)
-- ==============================================================================

BEGIN;

-- ==============================================================================
-- PASSO A: ADICIONAR COLUNAS QUE FALTAM
-- ==============================================================================

ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS favorite_methodology TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS teaching_style TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS assessment_focus TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS tone_of_voice TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS header_text TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS footer_text TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS logo_base64 TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS credits INTEGER DEFAULT 10;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS tier TEXT DEFAULT 'FREE';
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS is_unlimited BOOLEAN DEFAULT false;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS is_admin BOOLEAN DEFAULT false;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS role TEXT DEFAULT 'teacher';
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS masp TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS city TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS email TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS school_id TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS active_school_id TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT now();
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ;

-- ==============================================================================
-- PASSO B: RPC get_my_profile() — leitura segura (SECURITY DEFINER)
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.get_my_profile()
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_uid   uuid := auth.uid();
  v_email text;
  v_row   public.profiles;
BEGIN
  IF v_uid IS NULL THEN
    RETURN NULL;
  END IF;

  -- Resolve o email do usuário autenticado (necessário para o fallback Ghost ID)
  SELECT email INTO v_email FROM auth.users WHERE id = v_uid;

  -- 1. Lookup canônico: id = auth.uid()
  SELECT * INTO v_row FROM public.profiles WHERE id = v_uid LIMIT 1;

  -- Se encontrou por id mas credits é NULL, pode ser um perfil vazio criado pelo
  -- trigger de novo usuário. Tenta encontrar um perfil mais completo pelo email.
  IF FOUND AND v_row.credits IS NOT NULL THEN
    RETURN v_row;
  END IF;

  -- 2. Ghost ID / perfil enriquecido: busca pelo email, preferindo o com mais créditos
  IF v_email IS NOT NULL THEN
    DECLARE v_rich public.profiles;
    BEGIN
      SELECT * INTO v_rich
      FROM public.profiles
      WHERE lower(email) = lower(v_email)
        AND credits IS NOT NULL
      ORDER BY credits DESC, created_at DESC
      LIMIT 1;

      IF FOUND THEN
        RETURN v_rich;
      END IF;
    END;
  END IF;

  -- 3. Último recurso: retorna o perfil por id mesmo com credits NULL
  IF FOUND THEN
    RETURN v_row;
  END IF;

  RETURN NULL;
END;
$$;

ALTER FUNCTION public.get_my_profile() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.get_my_profile() TO authenticated;
COMMENT ON FUNCTION public.get_my_profile() IS
  'Lê o perfil do usuário autenticado contornando RLS. '
  'Resolve Ghost ID por email quando auth.uid() ≠ profiles.id.';

-- ==============================================================================
-- PASSO C: RPC update_my_profile() — escrita segura (SECURITY DEFINER)
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.update_my_profile(p_updates jsonb)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_uid uuid := auth.uid();
  v_email text;
  v_target_id uuid;
  v_result public.profiles;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Não autenticado';
  END IF;

  SELECT email INTO v_email FROM auth.users WHERE id = v_uid;

  -- 1. Tenta achar a linha pelo id do auth
  SELECT id INTO v_target_id FROM public.profiles WHERE id = v_uid;

  -- 2. Ghost ID: se não houver linha para o auth.uid(), procura por email
  IF v_target_id IS NULL AND v_email IS NOT NULL THEN
    SELECT id INTO v_target_id
      FROM public.profiles
     WHERE lower(email) = lower(v_email)
     ORDER BY created_at DESC
     LIMIT 1;
  END IF;

  -- 3. Se ainda não existe, cria a linha com o id do auth
  IF v_target_id IS NULL THEN
    INSERT INTO public.profiles (id, email, role, tier, credits, is_unlimited, created_at, updated_at)
    VALUES (v_uid, v_email, 'teacher', 'GOLD', 9999, true, NOW(), NOW())
    RETURNING id INTO v_target_id;
  END IF;

  -- 4. Aplica as alterações (COALESCE mantém o valor atual quando a chave não vem)
  UPDATE public.profiles SET
    full_name            = COALESCE(p_updates->>'full_name', full_name),
    email                = COALESCE(p_updates->>'email', email),
    masp                 = COALESCE(p_updates->>'masp', masp),
    city                 = COALESCE(p_updates->>'city', city),
    favorite_methodology = COALESCE(p_updates->>'favorite_methodology', favorite_methodology),
    teaching_style       = COALESCE(p_updates->>'teaching_style', teaching_style),
    assessment_focus     = COALESCE(p_updates->>'assessment_focus', assessment_focus),
    tone_of_voice        = COALESCE(p_updates->>'tone_of_voice', tone_of_voice),
    header_text          = COALESCE(p_updates->>'header_text', header_text),
    footer_text          = COALESCE(p_updates->>'footer_text', footer_text),
    logo_base64          = COALESCE(p_updates->>'logo_base64', logo_base64),
    updated_at           = NOW()
  WHERE id = v_target_id
  RETURNING * INTO v_result;

  RETURN v_result;
END;
$$;

ALTER FUNCTION public.update_my_profile(jsonb) OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.update_my_profile(jsonb) TO authenticated;
COMMENT ON FUNCTION public.update_my_profile(jsonb) IS
  'Salva o perfil do usuário autenticado contornando RLS. '
  'Resolve Ghost ID, cria perfil se não existir, e aplica as alterações. '
  'NÃO altera a PK de linhas existentes (evita quebrar foreign keys).';

-- ==============================================================================
-- PASSO D: GARANTIR POLÍTICAS RLS CORRETAS
-- ==============================================================================

-- Habilita RLS (se ainda não estiver)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Remove políticas que possam conflitar e recria as essenciais
DROP POLICY IF EXISTS "profiles_select_authenticated" ON public.profiles;
DROP POLICY IF EXISTS "profiles_select" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_own" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;
DROP POLICY IF EXISTS "v2_users_view_own_profile" ON public.profiles;
DROP POLICY IF EXISTS "v2_users_update_own_profile" ON public.profiles;
DROP POLICY IF EXISTS "v2_users_insert_own_profile" ON public.profiles;
DROP POLICY IF EXISTS "v2_admins_view_all_profiles" ON public.profiles;
DROP POLICY IF EXISTS "v2_admins_update_all_profiles" ON public.profiles;

-- SELECT: usuário vê seu próprio perfil OU todos (leitura ampla para permitir
-- que o app funcione sem bloqueios durante transições de sessão)
CREATE POLICY "profiles_select_own_or_all"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (true);  -- Leitura ampla: o app precisa ver perfis para lookup por email

-- INSERT: apenas o próprio perfil
CREATE POLICY "profiles_insert_own"
  ON public.profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- UPDATE: apenas o próprio perfil
CREATE POLICY "profiles_update_own"
  ON public.profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- DELETE: apenas admins (por segurança)
CREATE POLICY "profiles_delete_admin"
  ON public.profiles FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid()
        AND (role = 'admin' OR is_admin = true)
    )
  );

-- ==============================================================================
-- PASSO E: BACKFILL — Criar perfis para usuários sem perfil
-- ==============================================================================

INSERT INTO public.profiles (id, email, full_name, role, is_admin, tier, is_unlimited, credits, created_at, updated_at)
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
    'GOLD'      AS tier,
    true        AS is_unlimited,
    9999        AS credits,
    NOW()       AS created_at,
    NOW()       AS updated_at
FROM auth.users u
WHERE NOT EXISTS (
    SELECT 1 FROM public.profiles p WHERE p.id = u.id
)
ON CONFLICT (id) DO UPDATE SET
    email        = EXCLUDED.email,
    updated_at   = NOW();

-- Garante admins hardcoded
UPDATE public.profiles
SET
    role         = 'admin',
    is_admin     = true,
    tier         = 'GOLD',
    credits      = 9999,
    is_unlimited = true,
    updated_at   = NOW()
WHERE lower(email) IN ('prehfeld@hotmail.com', 'suporte@profeplan.com.br', 'paulinho.rehfeld@hotmail.com');

-- ==============================================================================
-- VERIFICAÇÃO FINAL
-- ==============================================================================

DO $$
DECLARE
  col_count int;
  pol_count int;
  profile_count int;
  rpc_get boolean;
  rpc_update boolean;
BEGIN
  SELECT COUNT(*) INTO col_count
  FROM information_schema.columns
  WHERE table_name = 'profiles' AND table_schema = 'public';

  SELECT COUNT(*) INTO pol_count
  FROM pg_policies
  WHERE schemaname = 'public' AND tablename = 'profiles';

  SELECT COUNT(*) INTO profile_count
  FROM public.profiles;

  SELECT EXISTS (
    SELECT 1 FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'public' AND p.proname = 'get_my_profile'
  ) INTO rpc_get;

  SELECT EXISTS (
    SELECT 1 FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'public' AND p.proname = 'update_my_profile'
  ) INTO rpc_update;

  RAISE NOTICE '============================================';
  RAISE NOTICE '✅ VERIFICAÇÃO DA MIGRAÇÃO:';
  RAISE NOTICE '   Colunas em profiles: %', col_count;
  RAISE NOTICE '   Políticas RLS ativas: %', pol_count;
  RAISE NOTICE '   Total de perfis: %', profile_count;
  RAISE NOTICE '   RPC get_my_profile: %', CASE WHEN rpc_get THEN '✅ Presente' ELSE '❌ Ausente' END;
  RAISE NOTICE '   RPC update_my_profile: %', CASE WHEN rpc_update THEN '✅ Presente' ELSE '❌ Ausente' END;
  RAISE NOTICE '============================================';
END;
$$;

COMMIT;
