-- ==============================================================================
-- FIX: INSERIR PERFIL DE ADMIN NA MARRA (MANUALMENTE)
-- Motivo: O gatilho automático (Trigger) possivelmente não rodou.
-- ==============================================================================

INSERT INTO public.profiles (id, email, full_name, role, is_admin, tier, is_unlimited, credits)
SELECT 
    id, 
    email, 
    COALESCE(raw_user_meta_data->>'full_name', 'Admin User'),
    'admin', -- Força papel de ADMIN
    true,    -- Flag de Admin
    'GOLD',  -- Plano Gold
    true,    -- Ilimitado
    9999     -- Créditos
FROM auth.users
WHERE email = 'prehfeld@hotmail.com'
ON CONFLICT (id) DO UPDATE
SET 
    role = 'admin',
    is_admin = true,
    tier = 'GOLD',
    is_unlimited = true,
    credits = 9999;

-- Verificação: Se rodar com sucesso, deve retornar "Inserted 1 row" ou "Updated 1 row".
