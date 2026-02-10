-- ==============================================================================
-- DIAGNÓSTICO COMPLETO E SOLUÇÃO DEFINITIVA: RLS em Profiles
-- ==============================================================================
-- Execute este script PASSO A PASSO, verificando cada resultado

-- ============================================================================
-- PASSO 1: DIAGNÓSTICO - Ver estado atual
-- ============================================================================

-- 1.1: Verificar se RLS está habilitado
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public' AND tablename = 'profiles';

-- 1.2: Listar TODAS as policies atuais
SELECT 
    policyname,
    cmd as operation,
    roles,
    qual as using_expression,
    with_check as check_expression
FROM pg_policies 
WHERE tablename = 'profiles'
ORDER BY cmd, policyname;

-- ============================================================================
-- PASSO 2: LIMPEZA TOTAL (Remove qualquer policy que possa estar causando conflito)
-- ============================================================================

DO $$ 
DECLARE
    policy_record RECORD;
BEGIN
    FOR policy_record IN 
        SELECT policyname 
        FROM pg_policies 
        WHERE tablename = 'profiles' AND schemaname = 'public'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.profiles', policy_record.policyname);
        RAISE NOTICE 'Dropped policy: %', policy_record.policyname;
    END LOOP;
END $$;

-- Verificar que todas foram removidas
SELECT COUNT(*) as policies_remaining FROM pg_policies WHERE tablename = 'profiles';
-- Deve retornar 0

-- ============================================================================
-- PASSO 3: CRIAR POLICIES CORRETAS E MINIMALISTAS
-- ============================================================================

-- Policy 1: SELECT - Permite leitura para usuários autenticados
-- IMPORTANTE: Esta é a policy que estava faltando e causava o erro 406
CREATE POLICY "profiles_select_authenticated"
ON public.profiles
FOR SELECT
TO authenticated
USING (true);

-- Policy 2: INSERT - Usuário pode criar apenas seu próprio perfil
CREATE POLICY "profiles_insert_own"
ON public.profiles
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- Policy 3: UPDATE - Usuário pode atualizar apenas seu próprio perfil
CREATE POLICY "profiles_update_own"
ON public.profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Policy 4: DELETE - Apenas admins específicos (via JWT claim)
CREATE POLICY "profiles_delete_admin"
ON public.profiles
FOR DELETE
TO authenticated
USING (
    (auth.jwt() ->> 'email')::text IN (
        'prehfeld@hotmail.com',
        'paulinho.rehfeld@hotmail.com'
    )
);

-- ============================================================================
-- PASSO 4: GARANTIR QUE RLS ESTÁ ATIVO
-- ============================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- PASSO 5: VERIFICAÇÃO FINAL
-- ============================================================================

-- 5.1: Confirmar que RLS está ativo
SELECT 
    'RLS Status' as check_type,
    CASE 
        WHEN rowsecurity THEN '✅ RLS ATIVO'
        ELSE '❌ RLS DESATIVADO'
    END as status
FROM pg_tables
WHERE schemaname = 'public' AND tablename = 'profiles';

-- 5.2: Listar policies criadas
SELECT 
    'Policies Criadas' as check_type,
    policyname,
    cmd as operation
FROM pg_policies 
WHERE tablename = 'profiles'
ORDER BY cmd, policyname;

-- 5.3: Teste de leitura (como authenticated user)
-- Tente fazer um SELECT simples:
SELECT COUNT(*) as total_profiles FROM public.profiles;

-- ============================================================================
-- PASSO 6: SE AINDA DER ERRO 406
-- ============================================================================
-- Se mesmo após executar tudo acima o erro persistir, execute APENAS esta linha
-- para desabilitar RLS TEMPORARIAMENTE e confirmar que é o problema:

-- ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;

-- Teste o app. Se funcionar, o problema É o RLS.
-- Então reative o RLS e investigue o JWT/autenticação:

-- ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- NOTAS IMPORTANTES
-- ============================================================================
-- 
-- 1. O erro 406 geralmente significa que uma policy está bloqueando o SELECT.
-- 2. A policy "profiles_select_authenticated" é ESSENCIAL para o app funcionar.
-- 3. Se após criar esta policy o erro persistir, o problema pode ser:
--    a) O usuário não está autenticado (token JWT inválido/expirado)
--    b) O token não tem o role 'authenticated'
--    c) Há alguma policy em outra tabela relacionada (schools) bloqueando o JOIN
-- 
-- 4. Para debug avançado, verifique no Supabase:
--    - Settings > API > JWT Secret (confirme que está correto no .env)
--    - Logs > Fazer um SELECT e ver o erro exato do Postgres
--
-- ============================================================================
