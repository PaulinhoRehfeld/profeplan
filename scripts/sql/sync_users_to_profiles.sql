-- ============================================================================== 
-- SINCRONIZAR USUÁRIOS: authorized_users -> profiles
-- ==============================================================================
-- Usuários foram criados em authorized_users mas não em profiles devido ao RLS.
-- Este script copia os dados faltantes.

-- IMPORTANTE: Execute DEPOIS de fix_rls_jwt.sql

INSERT INTO public.profiles (id, email, role, tier, credits, is_unlimited, is_admin, allowed_features)
SELECT 
    au.id,
    au.email,
    CASE 
        WHEN au.role = 'admin' THEN 'admin'::user_role
        WHEN au.role = 'manager' THEN 'manager'::user_role
        ELSE 'teacher'::user_role
    END as role,
    'GOLD' as tier,
    9999 as credits,
    true as is_unlimited,
    CASE WHEN au.role = 'admin' THEN true ELSE false END as is_admin,
    ARRAY['all'] as allowed_features
FROM public.authorized_users au
WHERE NOT EXISTS (
    SELECT 1 FROM public.profiles p WHERE p.id = au.id
);

-- Verificar quantos foram criados
SELECT 
    'authorized_users' as tabela,
    COUNT(*) as total
FROM authorized_users

UNION ALL

SELECT 
    'profiles' as tabela,
    COUNT(*) as total  
FROM profiles;
