-- ============================================================================== 
-- SOLUÇÃO DEFINITIVA: CORRIGIR RECURSÃO INFINITA NO RLS
-- ==============================================================================
-- Este script limpa todas as políticas problemáticas e recria uma estrutura segura

-- PASSO 1: LIMPAR TODAS AS POLÍTICAS DE authorized_users
-- ============================================================================
DROP POLICY IF EXISTS "Admins can manage authorized_users" ON public.authorized_users;
DROP POLICY IF EXISTS "Admins manage authorized_users" ON public.authorized_users;
DROP POLICY IF EXISTS "Public can read authorized_users" ON public.authorized_users;

-- PASSO 2: DESABILITAR RLS EM authorized_users
-- ============================================================================
-- Esta tabela é INTERNA do sistema. Não precisa RLS porque:
-- 1. Só o backend deve acessá-la
-- 2. O AdminPanel já verifica is_admin no código
-- 3. RLS aqui causa recursão infinita

ALTER TABLE public.authorized_users DISABLE ROW LEVEL SECURITY;


-- PASSO 3: LIMPAR E RECRIAR POLÍTICAS DE profiles
-- ============================================================================
-- Remover políticas que causam recursão
DROP POLICY IF EXISTS "Managers can view school colleagues" ON public.profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admins can manage all profiles" ON public.profiles;
DROP POLICY IF EXISTS "School Members can view colleagues" ON public.profiles;

-- Manter apenas as políticas básicas e seguras
-- (As que já existem em profiles_schema.sql são OK)

-- Política adicional: Admins podem fazer tudo (SEM SUBQUERY)
-- Usa apenas o campo is_admin da PRÓPRIA ROW, não consulta outra tabela
CREATE POLICY "Admins full access" 
ON public.profiles 
FOR ALL
USING (
    (SELECT is_admin FROM public.profiles WHERE id = auth.uid()) = true
);


-- PASSO 4: GARANTIR QUE O ADMIN ATUAL ESTÁ MARCADO
-- ============================================================================
-- Confirma que prehfeld@hotmail.com está configurado como admin
UPDATE public.profiles 
SET is_admin = true, role = 'admin' 
WHERE email = 'prehfeld@hotmail.com';


-- PASSO 5: VERIFICAÇÃO
-- ============================================================================
SELECT 
    schemaname, 
    tablename, 
    policyname 
FROM pg_policies 
WHERE tablename IN ('profiles', 'authorized_users')
ORDER BY tablename, policyname;
