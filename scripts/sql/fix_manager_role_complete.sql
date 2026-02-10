-- ==============================================================================
-- DIAGNÓSTICO E CORREÇÃO: Role do Gestor
-- ==============================================================================

-- 1. Verificar o ENUM user_role atual
SELECT enumlabel 
FROM pg_enum 
WHERE enumtypid = 'user_role'::regtype
ORDER BY enumsortorder;

-- 2. Verificar inconsistência entre authorized_users e profiles
SELECT 
    au.email,
    au.role as auth_role,
    p.role as profile_role,
    p.is_admin,
    p.school_id
FROM authorized_users au
LEFT JOIN profiles p ON au.id = p.id
WHERE au.email = 'paulinho.rehfeld@gmail.com';

-- 3. CORRIGIR: Atualizar paulinho em PROFILES para 'manager'
UPDATE public.profiles
SET 
    role = 'manager'::user_role,
    is_admin = false,
    school_id = (SELECT id FROM schools WHERE name LIKE '%Antônio Lago%' LIMIT 1)
WHERE email = 'paulinho.rehfeld@gmail.com';

-- 4. CORRIGIR: Garantir que authorized_users também está correto
UPDATE public.authorized_users  
SET role = 'manager'
WHERE email = 'paulinho.rehfeld@gmail.com';

-- 5. Verificação final
SELECT 
    au.email,
    au.role as auth_role,
    p.role as profile_role,
    p.is_admin,
    p.school_id,
    s.name as school_name
FROM authorized_users au
LEFT JOIN profiles p ON au.id = p.id
LEFT JOIN schools s ON p.school_id = s.id
WHERE au.email = 'paulinho.rehfeld@gmail.com';
