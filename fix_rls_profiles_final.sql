-- ==============================================================================
-- CORREÇÃO DEFINITIVA: RLS Policies de Profiles
-- ==============================================================================
-- O erro 406 acontece porque os usuários não conseguem ler seus próprios perfis

-- PASSO 1: Limpar TODAS as policies existentes de profiles
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile." ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile." ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
DROP POLICY IF EXISTS "Anyone can view profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admins can delete profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admin can insert any profile" ON public.profiles;
DROP POLICY IF EXISTS "Admin can update any profile" ON public.profiles;
DROP POLICY IF EXISTS "Admin can delete any profile" ON public.profiles;
DROP POLICY IF EXISTS "Admin can view all profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admins full access" ON public.profiles;
DROP POLICY IF EXISTS "Managers can view school colleagues" ON public.profiles;
DROP POLICY IF EXISTS "School Members can view colleagues" ON public.profiles;
DROP POLICY IF EXISTS "Users insert own profile" ON public.profiles;

-- PASSO 2: Criar policies corretas e funcionais

-- 2.1: Todos podem ler todos os perfis (necessário para listagens)
CREATE POLICY "Anyone can view profiles"
ON public.profiles
FOR SELECT
TO authenticated
USING (true);

-- 2.2: Usuários podem inserir apenas seu próprio perfil
CREATE POLICY "Users can insert own profile"
ON public.profiles
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- 2.3: Usuários podem atualizar apenas seu próprio perfil
CREATE POLICY "Users can update own profile"
ON public.profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = id);

-- 2.4: Apenas admins (via JWT) podem fazer DELETE
CREATE POLICY "Admins can delete profiles"
ON public.profiles
FOR DELETE
TO authenticated
USING (
    auth.jwt() ->> 'email' IN ('prehfeld@hotmail.com', 'paulinho.rehfeld@hotmail.com')
);

-- PASSO 3: Garantir que RLS está habilitado
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- PASSO 4: Verificar policies criadas
SELECT 
    schemaname, 
    tablename, 
    policyname,
    cmd as command,
    qual as using_expression
FROM pg_policies 
WHERE tablename = 'profiles'
ORDER BY policyname;
