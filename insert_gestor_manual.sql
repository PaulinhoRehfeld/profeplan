-- ==============================================================================
-- INSERIR GESTOR ESCOLAR (MANUALMENTE)
-- ==============================================================================

-- 1. Inserir na tabela de Login Simplificado (authorized_users)
-- O usuário poderá logar com este email e senha, mesmo sem ter criado conta no Supabase Auth.
INSERT INTO authorized_users (id, email, access_key, role)
VALUES 
(
    gen_random_uuid(), -- Gera um ID novo
    'gestor.antoniolago@educacao.mg.gov.br', -- EMAIL (Pode trocar)
    '123456', -- SENHA (Pode trocar)
    'school_manager' -- CÓDIGO DO GESTOR
);


-- 2. [OPCIONAL] Se o login acima der erro de 'RPC' (Função não encontrada), 
-- é porque precisamos criar a função que o LoginScreen tenta usar.
-- Vou incluir ela aqui por garantia.

CREATE OR REPLACE FUNCTION check_admin_credentials(check_email TEXT, check_key TEXT)
RETURNS TABLE (user_id UUID, role TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT id, authorized_users.role
    FROM authorized_users
    WHERE email = check_email AND access_key = check_key;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
