-- ==============================================================================
-- FIX: PERMISSÃO DE SALVAMENTO (MEUS ARQUIVOS)
-- ==============================================================================
-- Este script garante que usuários possam SALVAR (Insert/Update) seus planejamentos.
-- Se o RLS estiver bloqueando ou mal configurado, isso resolverá.

-- 1. Habilitar RLS na tabela (garantia de segurança)
ALTER TABLE public.generated_contents ENABLE ROW LEVEL SECURITY;

-- 2. Remover políticas antigas para evitar conflitos
DROP POLICY IF EXISTS "Users manage own content" ON public.generated_contents;
DROP POLICY IF EXISTS "Users can insert own content" ON public.generated_contents;
DROP POLICY IF EXISTS "Users can update own content" ON public.generated_contents;
DROP POLICY IF EXISTS "Users can delete own content" ON public.generated_contents;
DROP POLICY IF EXISTS "Public view" ON public.generated_contents;

-- 3. Criar política UNIFICADA para todas as operações (Select, Insert, Update, Delete)
-- Permite que usuário faça tudo, desde que o user_id da linha seja igual ao seu ID de login.
CREATE POLICY "Users manage own content" 
ON public.generated_contents
FOR ALL 
TO authenticated 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- 4. Verificação de permissão para leitura pública (opcional, para debug)
-- Se quiser que anonimos não vejam nada (recomendado):
-- Nenhuma política para 'anon' ou 'public' = Acesso negado por padrão.
