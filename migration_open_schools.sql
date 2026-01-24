-- ==============================================================================
-- MIGRATION: HABILITAR LEITURA PÚBLICA TOTAL (ANON + AUTH) DE ESCOLAS
-- ==============================================================================

-- 1. Remover a política restrita de "authenticated"
DROP POLICY IF EXISTS "Public view for authenticated users" ON schools;

-- 2. Criar política TOTALMENTE PÚBLICA
-- Permite que usuários sem sessão válida (Bypass/Anon) também busquem escolas.
CREATE POLICY "Public view for everyone (anon included)" 
ON schools FOR SELECT 
TO public 
USING ( true );

-- 3. Garantir que roles anon tenham permissão de SELECT na tabela
GRANT SELECT ON public.schools TO anon;
GRANT SELECT ON public.schools TO authenticated;
GRANT SELECT ON public.schools TO service_role;
