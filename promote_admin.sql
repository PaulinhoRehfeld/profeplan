-- ==============================================================================
-- BOOTSTRAP: PROMOVER USUÁRIOS PARA ADMIN
-- ==============================================================================
-- OBS: O usuário PRECISA ter feito o cadastro (Sign Up) no App primeiro.

-- 1. Promover 'prefeld@hotmail.com' (Como solicitado pelo usuário)
UPDATE public.profiles
SET 
    role = 'admin',
    is_admin = true,
    tier = 'GOLD',
    is_unlimited = true
WHERE email = 'prefeld@hotmail.com';

-- 2. Promover 'prehfeld@hotmail.com' (Caso tenha sido typo e ele usou o email correto)
UPDATE public.profiles
SET 
    role = 'admin',
    is_admin = true,
    tier = 'GOLD',
    is_unlimited = true
WHERE email = 'prehfeld@hotmail.com';

-- 3. Confirmação (Retorna quem é admin agora)
SELECT email, role, is_admin FROM public.profiles WHERE role = 'admin' OR is_admin = true;
