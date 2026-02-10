-- ==============================================================================
-- DIAGNÓSTICO: Por que paulinho.rehfeld@gmail.com não consegue logar?
-- ==============================================================================

-- PASSO 1: Verificar se existe em todas as tabelas necessárias
SELECT 'authorized_users' as tabela, id, email, role 
FROM authorized_users 
WHERE email = 'paulinho.rehfeld@gmail.com'

UNION ALL

SELECT 'profiles' as tabela, id, email, role::text 
FROM profiles 
WHERE email = 'paulinho.rehfeld@gmail.com';

-- O resultado DEVE mostrar 2 linhas (uma de cada tabela)
-- Se mostrar apenas 1 linha (authorized_users), o problema é que falta criar em profiles

-- ============================================================================
-- PASSO 2: Se faltar em profiles, criar agora
-- ============================================================================

-- Inserir em profiles usando o ID de authorized_users
INSERT INTO profiles (id, email, role, tier, credits, is_unlimited, is_admin, school_id, allowed_features)
SELECT 
    au.id,
    au.email,
    au.role::user_role,  -- Converte o texto 'manager' para o ENUM
    'GOLD',
    9999,
    true,
    false,
    (SELECT id FROM schools LIMIT 1),  -- Pega primeira escola disponível
    ARRAY['all']
FROM authorized_users au
WHERE au.email = 'paulinho.rehfeld@gmail.com'
AND NOT EXISTS (
    SELECT 1 FROM profiles p WHERE p.email = au.email
);

-- ============================================================================
-- PASSO 3: Verificar novamente
-- ============================================================================

SELECT 
    au.email,
    au.id as auth_id,
    au.role as auth_role,
    p.id as profile_id,
    p.role as profile_role,
    CASE 
        WHEN au.id = p.id THEN '✅ IDs coincidem'
        ELSE '❌ IDs DIFERENTES!'
    END as status_id
FROM authorized_users au
LEFT JOIN profiles p ON au.id = p.id
WHERE au.email = 'paulinho.rehfeld@gmail.com';

-- Deve mostrar IDs idênticos e roles 'manager'

-- ============================================================================
-- PASSO 4: Teste a policy de SELECT manualmente
-- ============================================================================

-- Este SELECT deve FUNCIONAR (sem erro 406):
SELECT id, email, role FROM profiles WHERE email = 'paulinho.rehfeld@gmail.com';

-- Se der erro 406, o problema É a policy. Execute:
SELECT policyname, cmd, qual 
FROM pg_policies 
WHERE tablename = 'profiles' AND cmd = 'SELECT';

-- A policy deve ter USING (true) ou algo permissivo
