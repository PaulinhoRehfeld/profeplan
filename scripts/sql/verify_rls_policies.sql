-- ==============================================================================
-- VERIFICAR POLICIES RLS EM PROFILES
-- ==============================================================================

-- 1. Listar todas as policies ativas
SELECT 
    policyname,
    cmd as operation,
    CASE 
        WHEN qual IS NOT NULL THEN 'Has USING clause'
        ELSE 'No USING clause'
    END as using_status,
    CASE 
        WHEN with_check IS NOT NULL THEN 'Has WITH CHECK'
        ELSE 'No WITH CHECK'
    END as check_status,
    roles
FROM pg_policies 
WHERE tablename = 'profiles'
ORDER BY policyname;

-- 2. Verificar se RLS está habilitado
SELECT 
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public' AND tablename = 'profiles';

-- 3. SOLUÇÃO ALTERNATIVA: Desabilitar RLS temporariamente para testar
-- ATENÇÃO: Isso é apenas para DEBUG. NÃO use em produção!

-- Descomente a linha abaixo APENAS para teste:
-- ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;

-- 4. Após testar, reabilite:
-- ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
