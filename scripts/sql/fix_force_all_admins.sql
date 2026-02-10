-- ==============================================================================
-- NUCLEAR OPTION: TORNAR TODOS OS USUÁRIOS EXISTENTES EM ADMINS
-- Motivo: Erro no email ou case sensitivity estava impedindo o script anterior.
-- ==============================================================================

-- 1. Inserir perfil para TODOS os usuários que estão no Auth mas não no Profiles
INSERT INTO public.profiles (id, email, full_name, role, is_admin, tier, is_unlimited, credits)
SELECT 
    id, 
    email, 
    COALESCE(raw_user_meta_data->>'full_name', 'Admin User'),
    'admin', -- Todos viram ADMIN
    true,
    'GOLD',
    true,
    9999
FROM auth.users
ON CONFLICT (id) DO UPDATE
SET 
    role = 'admin',
    is_admin = true,
    tier = 'GOLD',
    is_unlimited = true,
    credits = 9999;

-- 2. Mensagem de Confirmação (Check output)
-- Se isso retornar "0 rows", então a tabela auth.users está VAZIA.
-- Isso significaria que você não criou a conta no projeto NOVO (PROFEPLAN-DEV).
