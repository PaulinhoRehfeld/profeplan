-- ==============================================================================
-- BYPASS RLS: INSERIR ADMIN MANUALMENTE
-- ==============================================================================
-- Este script insere o usuário diretamente nas tabelas, ignorando o bloqueio RLS do App.

-- 1. Inserir na tabela de Login Simplificado (authorized_users)
-- Usamos ON CONFLICT para não dar erro se você já tentou inserir antes.
INSERT INTO authorized_users (id, email, access_key, role)
VALUES 
(
    '00000000-0000-0000-0000-000000000001', -- ID FIXO para facilitar
    'prehfeld@hotmail.com',
    '12345678', -- Senha solicitada
    'admin'
)
ON CONFLICT (email) DO UPDATE 
SET access_key = EXCLUDED.access_key, role = EXCLUDED.role;


-- 2. Inserir (ou atualizar) na tabela Public Profiles
-- Isso garante que o usuário tenha o perfil de ADMIN com poderes totais.
INSERT INTO profiles (id, email, role, tier, credits, is_unlimited, is_admin, allowed_features)
VALUES 
(
    -- Precisamos pegar o ID que acabamos de inserir/atualizar na authorized_users
    (SELECT id FROM authorized_users WHERE email = 'prehfeld@hotmail.com'),
    'prehfeld@hotmail.com',
    'admin', -- Role do banco
    'GOLD',
    9999,
    true,
    true,
    ARRAY['all']
)
ON CONFLICT (id) DO UPDATE 
SET 
    role = 'admin',
    is_admin = true,
    tier = 'GOLD',
    is_unlimited = true,
    credits = 9999;
