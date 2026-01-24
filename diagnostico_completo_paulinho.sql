-- ==============================================================================
-- DIAGNÓSTICO COMPLETO: Verificar estado do paulinho
-- ==============================================================================

-- 1. Verificar se existe em authorized_users
SELECT 'AUTHORIZED_USERS' as tabela, id, email, role
FROM authorized_users 
WHERE email = 'paulinho.rehfeld@gmail.com';

-- 2. Verificar se existe em profiles
SELECT 'PROFILES' as tabela, id, email, role, is_admin, school_id
FROM profiles 
WHERE email = 'paulinho.rehfeld@gmail.com';

-- 3. Verificar consistência de IDs
SELECT 
    au.email,
    au.id as auth_id,
    au.role as auth_role,
    p.id as profile_id,
    p.role as profile_role,
    CASE 
        WHEN au.id = p.id THEN 'IDs Match ✅'
        ELSE 'IDs MISMATCH ❌'
    END as id_check
FROM authorized_users au
FULL OUTER JOIN profiles p ON au.email = p.email
WHERE au.email = 'paulinho.rehfeld@gmail.com' OR p.email = 'paulinho.rehfeld@gmail.com';

-- 4. SOLUÇÃO: Criar ou atualizar o profile corretamente
-- Se o profile não existir, insere. Se existir mas estiver errado, atualiza.

-- Deletar perfil antigo se existir (para recomeçar limpo)
DELETE FROM profiles WHERE email = 'paulinho.rehfeld@gmail.com';

-- Inserir novo perfil usando o ID correto de authorized_users
INSERT INTO profiles (id, email, role, tier, credits, is_unlimited, is_admin, school_id, allowed_features)
SELECT 
    id,
    email,
    'manager'::user_role,
    'GOLD',
    9999,
    true,
    false,
    (SELECT id FROM schools WHERE name LIKE '%Antônio Lago%' LIMIT 1),
    ARRAY['all']
FROM authorized_users
WHERE email = 'paulinho.rehfeld@gmail.com';

-- 5. Verificação final
SELECT 
    au.email,
    au.role as auth_role,
    p.role as profile_role,
    p.is_admin,
    p.school_id,
    s.name as school_name,
    CASE 
        WHEN p.role = 'manager' THEN 'MANAGER ROLE OK ✅'
        ELSE 'PROFILE ROLE WRONG ❌'
    END as status
FROM authorized_users au
LEFT JOIN profiles p ON au.id = p.id
LEFT JOIN schools s ON p.school_id = s.id
WHERE au.email = 'paulinho.rehfeld@gmail.com';
