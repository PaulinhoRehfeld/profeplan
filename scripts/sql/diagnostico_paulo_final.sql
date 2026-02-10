-- ==============================================================================
-- DIAGNÓSTICO FINAL: Verificar estado completo do paulo.rehfeld
-- ==============================================================================

-- 1. Verificar se existe em authorized_users
SELECT 'STEP 1: authorized_users' as step, id, email, role
FROM authorized_users 
WHERE email = 'paulo.rehfeld@educacao.mg.gov.br';

-- 2. Verificar se existe em profiles
SELECT 'STEP 2: profiles' as step, id, email, role, is_admin, school_id
FROM profiles 
WHERE email = 'paulo.rehfeld@educacao.mg.gov.br';

-- 3. Verificar se os IDs coincidem
SELECT 
    'STEP 3: ID Comparison' as step,
    au.email,
    au.id as auth_users_id,
    p.id as profiles_id,
    CASE 
        WHEN au.id = p.id THEN 'IDs MATCH ✅'
        WHEN p.id IS NULL THEN 'PROFILE MISSING ❌'
        ELSE 'ID MISMATCH ❌'
    END as status
FROM authorized_users au
LEFT JOIN profiles p ON au.id = p.id
WHERE au.email = 'paulo.rehfeld@educacao.mg.gov.br';

-- 4. Verificar policies ativas em profiles
SELECT 
    'STEP 4: RLS Policies' as step,
    policyname,
    cmd,
    qual as using_clause
FROM pg_policies 
WHERE tablename = 'profiles';

-- 5. SOLUÇÃO: Se profile não existir OU estiver errado, recria
-- Deletar perfil antigo se existir
DELETE FROM profiles WHERE email = 'paulo.rehfeld@educacao.mg.gov.br';

-- Inserir novo perfil usando o ID de authorized_users
INSERT INTO profiles (id, email, role, tier, credits, is_unlimited, is_admin, school_id, allowed_features)
SELECT 
    au.id,
    au.email,
    'manager'::user_role,
    'GOLD',
    9999,
    true,
    false,
    (SELECT id FROM schools LIMIT 1), -- Pega primeira escola disponível
    ARRAY['all']
FROM authorized_users au
WHERE au.email = 'paulo.rehfeld@educacao.mg.gov.br';

-- 6. Verificação FINAL
SELECT 
    'STEP 6: FINAL CHECK' as step,
    au.email,
    au.role as auth_role,
    p.role as profile_role,
    p.id as profile_id,
    p.school_id,
    s.name as school_name
FROM authorized_users au
LEFT JOIN profiles p ON au.id = p.id
LEFT JOIN schools s ON p.school_id = s.id
WHERE au.email = 'paulo.rehfeld@educacao.mg.gov.br';
