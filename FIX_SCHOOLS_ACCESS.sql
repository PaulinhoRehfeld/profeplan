-- ==============================================================================
-- FIX: PERMISSÃO DE BUSCA DE ESCOLAS
-- ==============================================================================
-- Este script resolve o problema onde o professor (Teacher) não consegue buscar escolas.
-- O erro ocorre porque a tabela 'schools' tem Row Level Security (RLS) ativo,
-- mas faltava uma política explícita permitindo que usuários vejam a lista.

-- 1. Habilitar leitura para todos os usuários autenticados (Professores, Gestores, etc)
DROP POLICY IF EXISTS "Public view for authenticated users" ON public.schools;

CREATE POLICY "Public view for authenticated users" 
ON public.schools FOR SELECT 
TO authenticated 
USING ( true );

-- 2. Garantir que a tabela schools tenha RLS ativo (segurança)
ALTER TABLE public.schools ENABLE ROW LEVEL SECURITY;

-- 3. Verificação (Opcional)
-- SELECT count(*) FROM schools;
