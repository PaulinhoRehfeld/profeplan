-- ==============================================================================
-- MIGRATION: REMOVER CONSTRAINT DE FOREIGN KEY
-- Motivo: Permitir perfis para usuários "Manuais" (authorized_users) que não existem no Auth real.
-- ==============================================================================

-- Remover a restrição que obriga o ID do perfil a existir na tabela auth.users
ALTER TABLE profiles 
DROP CONSTRAINT IF EXISTS profiles_id_fkey;

-- [Opcional] Remover a restrição também da tabela authorized_users (se houver, mas acho que não tem)
