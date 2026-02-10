-- ==============================================================================
-- BOOTSTRAP: TORNAR 'prehfeld@hotmail.com' ADMIN SUPREMO
-- ==============================================================================

-- 1. Encontrar o usuário pelo email e dar permissão de ADMIN
UPDATE profiles
SET 
    role = 'admin',
    is_admin = true,
    tier = 'GOLD',
    is_unlimited = true
WHERE email = 'prehfeld@hotmail.com';

-- 2. Garantir que ele possa gerenciar a tabela authorized_users
-- (A policy já existe para 'admin', então o update acima resolve).

-- 3. [Opcional] Se o usuário ainda não existir na tabela profiles (apenas no auth), 
-- podemos criar um "Placeholder" para garantir. Mas o ideal é que ele já tenha logado.
-- Se não logou, o UPDATE acima dá 0 rows affected e não faz mal.
