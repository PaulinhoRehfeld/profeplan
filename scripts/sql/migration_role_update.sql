-- ==============================================================================
-- MIGRATION: ATUALIZAR ROLE PARA 'MANAGER' (school_manager)
-- ==============================================================================

-- 1. Remover constraint antiga se existir para permitir a modificação
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_role_check;

-- 2. Atualizar valores existentes: 'school_admin' -> 'school_manager'
-- Isso garante que usuários já criados não fiquem órfãos ou inválidos
UPDATE profiles 
SET role = 'school_manager' 
WHERE role = 'school_admin';

-- 3. Adicionar constraint atualizada
-- Roles permitidas: 'teacher', 'school_manager' (Gestor Escolar), 'admin' (Sistema)
ALTER TABLE profiles 
ADD CONSTRAINT profiles_role_check CHECK (role IN ('teacher', 'school_manager', 'admin'));

-- 4. Atualizar comentários ou defaults se necessário
ALTER TABLE profiles ALTER COLUMN role SET DEFAULT 'teacher';
