-- ==============================================================================
-- MIGRATION: CORRIGIR POLÍTICAS RLS PARA SCHOOL_MANAGER
-- ==============================================================================

-- 1. Remover políticas antigas que usavam 'school_admin'
DROP POLICY IF EXISTS "School Admin can manage students" ON school_students;

-- 2. Recriar política para 'school_manager'
CREATE POLICY "School Manager can manage students" 
ON school_students FOR ALL 
TO authenticated 
USING (
    exists (
        select 1 from profiles
        where profiles.id = auth.uid()
        and profiles.role = 'school_manager' -- ATUALIZADO
        and profiles.school_id = school_students.school_id
    )
);

-- 3. Garantir que perfis estejam atualizados (Redundância necessária se a migração anterior falhou por algum motivo de bloqueio)
UPDATE profiles 
SET role = 'school_manager' 
WHERE role = 'school_admin';

-- 4. Verificar se a coluna role tem a constraint certa, senão, atualizar.
DO $$ 
BEGIN 
    ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_role_check;
    ALTER TABLE profiles ADD CONSTRAINT profiles_role_check CHECK (role IN ('teacher', 'school_manager', 'admin'));
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignora se já estiver certo
END $$;
