-- ==============================================================================
-- SIX: CORREÇÃO DEFINITIVA DO LOOP INFINITO (ADMIN)
-- O problema: A regra "Admins podem fazer tudo" consultava a tabela profiles.
-- Ao consultar, ela ativava a regra de novo. Loop.
-- Solução: Usar uma função segura (SECURITY DEFINER) para verificar se é Admin.
-- ==============================================================================

-- 1. Função Segura para verificar se sou Admin (Bypassa RLS)
CREATE OR REPLACE FUNCTION am_i_admin()
RETURNS BOOLEAN AS $$
BEGIN
  -- Verifica se existe um perfil com id do usuário atual e role='admin'
  RETURN EXISTS (
    SELECT 1 FROM profiles 
    WHERE id = auth.uid() 
    AND (role = 'admin' OR is_admin = true)
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER; 

-- 2. Recriar a política de Admin usando a função segura
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Admins can manage all profiles" ON profiles; -- Caso tenha outro nome

CREATE POLICY "Admins can manage all profiles" 
ON profiles FOR ALL
TO authenticated 
USING (
    am_i_admin() = true -- Usa a função segura, sem loop!
);

-- 3. [Extra] Garantir INSERT para usuários se auto-cadastrarem
-- (Caso a regra acima falhe porque o usuário ainda não tem perfil de admin no momento do cadastro)
DROP POLICY IF EXISTS "Users insert own profile" ON profiles;

CREATE POLICY "Users insert own profile" 
ON profiles FOR INSERT 
TO authenticated 
WITH CHECK (
    auth.uid() = id
    OR
    am_i_admin() = true -- Admin também pode criar para outros
);
