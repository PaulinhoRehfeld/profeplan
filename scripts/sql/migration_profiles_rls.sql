-- ==============================================================================
-- MIGRATION: CORRIGIR PERMISSÕES DE LEITURA DO PERFIL (FIX RLS)
-- ==============================================================================

-- 1. Habilitar RLS na tabela profiles (garantir que está ativo)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 2. Política: Usuários podem ler SEU PRÓPRIO perfil
-- Esta é a política mais importante e estava falhando ou bloqueada.
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;

CREATE POLICY "Users can view own profile" 
ON profiles FOR SELECT 
TO authenticated 
USING (
    auth.uid() = id
);

-- 3. Política: Usuários podem atualziar SEU PRÓPRIO perfil
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;

CREATE POLICY "Users can update own profile" 
ON profiles FOR UPDATE 
TO authenticated 
USING ( auth.uid() = id )
WITH CHECK ( auth.uid() = id );

-- 4. Política de Admin (para ler tudo)
-- Só o 'admin' do sistema pode ler todos os perfis
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;

CREATE POLICY "Admins can view all profiles" 
ON profiles FOR SELECT 
TO authenticated 
USING (
    role = 'admin' OR is_admin = true
);

-- 5. Garantir role atualizada para o usuário de teste
UPDATE profiles
SET role = 'school_manager'
WHERE email = 'supervisaoescola31023299@educacao.mg.gov.br';

