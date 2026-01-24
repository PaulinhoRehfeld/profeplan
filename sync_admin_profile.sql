-- ==============================================================================
-- SYNC ADMIN PROFILE
-- ==============================================================================
-- O usuário já existe na tabela authorized_users (vimos no print), 
-- mas provavelmente não existe na tabela profiles, por isso não aparece no App.

INSERT INTO public.profiles (id, email, role, tier, credits, is_unlimited, is_admin, allowed_features)
SELECT 
    id, 
    email,
    'admin', 
    'GOLD', 
    9999, 
    true, 
    true, 
    ARRAY['all']
FROM public.authorized_users
WHERE email = 'prehfeld@hotmail.com'
ON CONFLICT (id) DO UPDATE 
SET 
    role = 'admin',
    is_admin = true,
    tier = 'GOLD',
    is_unlimited = true,
    credits = 9999;

-- Confirmação
SELECT * FROM public.profiles WHERE email = 'prehfeld@hotmail.com';
