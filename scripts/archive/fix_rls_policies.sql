-- =====================================================
-- LIMPEZA TOTAL DE POLÍTICAS RLS - PROFEPLAN v3.8
-- =====================================================
-- Este script remove TODAS as políticas antigas e cria
-- um conjunto mínimo e seguro
-- =====================================================

-- 1. REMOVER TODAS AS POLÍTICAS EXISTENTES
DROP POLICY IF EXISTS "Admins Full Access" ON profiles;
DROP POLICY IF EXISTS "Admins have full access" ON profiles;
DROP POLICY IF EXISTS "Allow school visibility" ON profiles;
DROP POLICY IF EXISTS "Managers can view school members" ON profiles;
DROP POLICY IF EXISTS "Users Own Profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
DROP POLICY IF EXISTS "Users can manage their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile." ON profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "profiles_insert_policy" ON profiles;
DROP POLICY IF EXISTS "profiles_select_policy" ON profiles;
DROP POLICY IF EXISTS "profiles_update_policy" ON profiles;

-- 2. GARANTIR QUE RLS ESTÁ ATIVADO
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 3. CRIAR APENAS 3 POLÍTICAS BÁSICAS E SEGURAS
-- =====================================================

-- SELECT: Cada usuário pode LER apenas seu próprio perfil
CREATE POLICY "profile_select_own" 
ON profiles
FOR SELECT 
USING (auth.uid() = id);

-- INSERT: Cada usuário pode CRIAR apenas seu próprio perfil
CREATE POLICY "profile_insert_own" 
ON profiles
FOR INSERT 
WITH CHECK (auth.uid() = id);

-- UPDATE: Cada usuário pode ATUALIZAR apenas seu próprio perfil
CREATE POLICY "profile_update_own" 
ON profiles
FOR UPDATE 
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- =====================================================
-- 4. VERIFICAÇÃO FINAL
-- =====================================================

SELECT 
  policyname,
  cmd,
  permissive
FROM pg_policies 
WHERE tablename = 'profiles'
ORDER BY policyname;

-- =====================================================
-- RESULTADO ESPERADO:
-- Você deve ver EXATAMENTE 3 políticas:
-- 1. profile_insert_own (INSERT)
-- 2. profile_select_own (SELECT)
-- 3. profile_update_own (UPDATE)
-- 
-- Se aparecer mais que isso, execute o script novamente.
-- =====================================================
