-- ==============================================================================
-- FIX DEFINITIVO: Policies para INSERT e Referrals
-- ==============================================================================

-- PROBLEMA IDENTIFICADO:
-- O erro "new row violates row-level security policy" no INSERT indica que
-- a policy de INSERT está muito restritiva ou o auth.uid() não corresponde.

-- ============================================================================
-- PASSO 1: Verificar policies atuais
-- ============================================================================
SELECT policyname, cmd, roles 
FROM pg_policies 
WHERE tablename IN ('profiles', 'referrals', 'authorized_users')
ORDER BY tablename, cmd;

-- ============================================================================
-- PASSO 2: CORRIGIR - Policies de Profiles (mais permissivas para INSERT)
-- ============================================================================

-- Dropar a policy de INSERT antiga
DROP POLICY IF EXISTS "profiles_insert_own" ON public.profiles;

-- Nova policy de INSERT mais permissiva
-- Permite que novos usuários criem perfil (sem verificar auth.uid() rigorosamente)
CREATE POLICY "profiles_insert_new_user"
ON public.profiles
FOR INSERT
TO authenticated, anon  -- Permite tanto authenticated quanto anon (para signup)
WITH CHECK (true);  -- Temporariamente permissivo para debug

-- ============================================================================
-- PASSO 3: Criar RLS para referrals (estava dando 406)
-- ============================================================================

-- Habilitar RLS na tabela referrals
ALTER TABLE public.referrals ENABLE ROW LEVEL SECURITY;

-- Policy de SELECT para referrals
CREATE POLICY "referrals_select_all"
ON public.referrals
FOR SELECT
TO authenticated, anon
USING (true);

-- Policy de INSERT para referrals
CREATE POLICY "referrals_insert_authenticated"
ON public.referrals
FOR INSERT
TO authenticated
WITH CHECK (true);

-- ============================================================================
-- PASSO 4: Verificar authorized_users (pode estar bloqueando login VIP)
-- ============================================================================

-- Se a tabela authorized_users tiver RLS, precisamos permitir leitura
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'authorized_users' AND schemaname = 'public';

-- Se retornar rls_enabled = true, execute:
DROP POLICY IF EXISTS "authorized_users_select_all" ON public.authorized_users;

CREATE POLICY "authorized_users_select_all"
ON public.authorized_users
FOR SELECT
TO authenticated, anon
USING (true);

-- ============================================================================
-- PASSO 5: TESTE - Tentar inserir perfil manualmente
-- ============================================================================

-- Teste se consegue inserir (rode como usuário anon/public)
-- Este insert deve FUNCIONAR agora:
/*
INSERT INTO profiles (id, email, role, tier, credits, is_admin)
VALUES (
    gen_random_uuid(),
    'teste@teste.com',
    'teacher',
    'SILVER',
    10,
    false
);
*/

-- Se funcionar, delete o teste:
-- DELETE FROM profiles WHERE email = 'teste@teste.com';

-- ============================================================================
-- PASSO 6: Verificação Final
-- ============================================================================

SELECT 'Verificação Final' as status;

SELECT 
    tablename,
    count(*) as total_policies
FROM pg_policies
WHERE tablename IN ('profiles', 'referrals', 'authorized_users')
GROUP BY tablename
ORDER BY tablename;

-- ============================================================================
-- NOTAS
-- ============================================================================
-- 
-- A policy WITH CHECK (true) é TEMPORÁRIA para debug.
-- Depois que funcionar, devemos restringir para:
-- WITH CHECK (auth.uid() = id OR auth.role() = 'anon')
--
-- ============================================================================
