-- ==============================================================================
-- FIX ENUM & SYNC ADMIN
-- ==============================================================================

-- 1. Adicionar 'admin' ao ENUM user_role
-- O Postgres não permite "CREATE OR REPLACE TYPE", então alteramos.
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'admin';

-- 2. Agora sim, inserir o Admin na tabela profiles
INSERT INTO public.profiles (id, email, role, tier, credits, is_unlimited, is_admin, allowed_features)
SELECT 
    id, 
    email,
    'admin'::user_role, -- Cast explícito para o tipo user_role
    'GOLD', 
    9999, 
    true, 
    true, 
    ARRAY['all']
FROM public.authorized_users
WHERE email = 'prehfeld@hotmail.com'
ON CONFLICT (id) DO UPDATE 
SET 
    role = 'admin'::user_role,
    is_admin = true,
    tier = 'GOLD',
    is_unlimited = true,
    credits = 9999;
