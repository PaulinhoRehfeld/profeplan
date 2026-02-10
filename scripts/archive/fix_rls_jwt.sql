-- ============================================================================== 
-- SOLUÇÃO FINAL: USAR JWT AO INVÉS DE SUBQUERY
-- ==============================================================================
-- O problema: qualquer política que faça SELECT em profiles causa recursão
-- A solução: usar auth.jwt() que vem do token, não do banco

-- PASSO 1: REMOVER A POLÍTICA RECURSIVA QUE CRIAMOS
-- ============================================================================
DROP POLICY IF EXISTS "Admins full access" ON public.profiles;

-- PASSO 2: CRIAR POLÍTICAS USANDO O EMAIL DO JWT (SEM RECURSÃO)
-- ============================================================================

-- Permitir que o admin específico (você) faça INSERT de qualquer perfil
CREATE POLICY "Admin can insert any profile"
ON public.profiles
FOR INSERT
TO authenticated
WITH CHECK (
    auth.jwt() ->> 'email' = 'prehfeld@hotmail.com'
);

-- Permitir que o admin específico (você) faça UPDATE de qualquer perfil  
CREATE POLICY "Admin can update any profile"
ON public.profiles  
FOR UPDATE
TO authenticated
USING (
    auth.jwt() ->> 'email' = 'prehfeld@hotmail.com'
);

-- Permitir que o admin específico (você) faça DELETE de qualquer perfil
CREATE POLICY "Admin can delete any profile"
ON public.profiles
FOR DELETE  
TO authenticated
USING (
    auth.jwt() ->> 'email' = 'prehfeld@hotmail.com'
);

-- Permitir que o admin faça SELECT de todos os perfis
CREATE POLICY "Admin can view all profiles"
ON public.profiles
FOR SELECT
TO authenticated  
USING (
    auth.jwt() ->> 'email' = 'prehfeld@hotmail.com'
);


-- PASSO 3: VERIFICAR POLÍTICAS ATUAIS
-- ============================================================================
SELECT 
    schemaname, 
    tablename, 
    policyname,
    cmd as command,
    qual as using_expression,
    with_check as with_check_expression
FROM pg_policies 
WHERE tablename = 'profiles'
ORDER BY policyname;
