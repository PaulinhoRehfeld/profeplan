-- Corrigir o role do usuário paulinho.rehfeld@gmail.com
-- Ele deve ser manager, não admin

UPDATE public.profiles
SET 
    role = 'manager'::user_role,
    is_admin = false
WHERE email = 'paulinho.rehfeld@gmail.com';

UPDATE public.authorized_users  
SET role = 'manager'
WHERE email = 'paulinho.rehfeld@gmail.com';

-- Verificar a correção
SELECT 
    p.email,
    p.role as profile_role,
    p.is_admin,
    p.school_id,
    au.role as auth_role
FROM profiles p
LEFT JOIN authorized_users au ON p.id = au.id
WHERE p.email LIKE '%paulinho%';
