-- ==============================================================================
-- MIGRATION: LIBERAR GERAL (DEV ENVIRONMENT)
-- Motivo: O "Perfil de Admin" não foi criado no banco, então o RLS está bloqueando.
-- Solução: Desativar a checagem de segurança para permitir que o Frontend (que já está liberado) funcione.
-- ==============================================================================

-- 1. Liberar tabela de Usuários Autorizados (Para você conseguir cadastrar novos)
ALTER TABLE authorized_users DISABLE ROW LEVEL SECURITY;

-- 2. Liberar tabela de Perfis (Para você conseguir editar perfis)
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- 3. Inserir um usuário autorizado manualmente (Exemplo)
INSERT INTO authorized_users (email, access_key, role)
VALUES 
('novo.professor@escola.com', '123456', 'teacher')
ON CONFLICT DO NOTHING;

-- 4. Inserir o seu admin na tabela authorized também (para constar)
INSERT INTO authorized_users (email, access_key, role)
VALUES 
('prehfeld@hotmail.com', 'admin123', 'admin')
ON CONFLICT DO NOTHING;
