-- ==============================================================================
-- MIGRATION: ADICIONAR COLUNA ROLE NA TABELA PROFILES
-- ==============================================================================

-- Esta migração garante que a tabela de perfis (profiles) tenha a coluna 'role'.
-- Isso permite distinguir entre Professor (teacher), Gestor Escolar (school_admin) e Admin do Sistema (admin).

-- 1. Adicionar Coluna ROLE
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS role TEXT DEFAULT 'teacher';

-- 2. Adicionar Constraint para garantir integridade (Valores permitidos)
-- Se a constraint já existir, o comando abaixo pode falhar, então usamos um bloco DO seguro ou apenas tentamos adicionar.
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'profiles_role_check') THEN 
        ALTER TABLE profiles 
        ADD CONSTRAINT profiles_role_check CHECK (role IN ('teacher', 'school_admin', 'admin'));
    END IF; 
END $$;

-- 3. (Opcional) Atualizar usuários existentes para 'teacher' se estiver nulo
UPDATE profiles 
SET role = 'teacher' 
WHERE role IS NULL;

-- 4. Criar Index para performance nas buscas por role
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);
