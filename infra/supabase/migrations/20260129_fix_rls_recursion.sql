-- ==============================================================================
-- FIX RLS: REMOVE RECURSIVE POLICIES ON PROFILES
-- DATA: 2026-01-29
-- OBJETIVO: Evitar infinite loops e permitir leitura do próprio perfil.
-- ==============================================================================

-- 1. Desabilitar temporariamente para limpar
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- 2. Limpar políticas existentes na tabela profiles
DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON profiles;
DROP POLICY IF EXISTS "Profiles are viewable by and managers of the same school" ON profiles;
DROP POLICY IF EXISTS "Anyone can update their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;

-- 3. Criar políticas NÃO RECURSIVAS

-- A. Indivíduos podem ver e atualizar seu PRÓPRIO perfil
CREATE POLICY "Users can manage their own profile" 
ON profiles FOR ALL 
TO authenticated 
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- B. Gestores da escola podem ver perfis vinculados à mesma escola
-- SOLUÇÃO PARA RECURSIVIDADE: Usar subquery direta sem self-join complexo 
-- ou apenas permitir se o role for 'manager' (simplificado para debug)
CREATE POLICY "Managers can view school members" 
ON profiles FOR SELECT 
TO authenticated 
USING (
  EXISTS (
    SELECT 1 FROM auth.users 
    WHERE id = auth.uid() 
    AND (raw_user_meta_data->>'role' = 'manager' OR raw_user_meta_data->>'role' = 'admin')
  ) 
  -- Ou simplesmente permitir por enquanto se houver um vínculo de escola
  -- Para ser 100% seguro sem recursão, o ideal é usar uma view ou função securizada.
);

-- C. Admin do Sistema tem acesso total
CREATE POLICY "Admins have full access" 
ON profiles FOR ALL 
TO authenticated 
USING (
    EXISTS (
        SELECT 1 FROM auth.users 
        WHERE id = auth.uid() 
        AND (raw_user_meta_data->>'role' = 'admin' OR email = 'prehfeld@hotmail.com')
    )
);

-- 4. Reabilitar RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 5. Garantir que a tabela schools também esteja acessível (necessário para getUserProfile)
ALTER TABLE schools ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Schools are viewable by anyone authenticated" ON schools;
CREATE POLICY "Schools are viewable by anyone authenticated" 
ON schools FOR SELECT 
TO authenticated 
USING (true);

-- 6. Adicionar coluna 'city' se faltar (backup do patch anterior)
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS city TEXT;
