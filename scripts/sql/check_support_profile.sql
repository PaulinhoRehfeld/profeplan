
-- DIAGNOSTIC: Check Support User & Profile
SELECT 
    u.id as auth_id, 
    u.email as auth_email, 
    p.id as profile_id, 
    p.email as profile_email,
    p.role as profile_role,
    p.is_admin
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.id
WHERE u.email = 'suporte@profeplan.com.br';
