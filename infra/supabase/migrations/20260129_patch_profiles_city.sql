-- ==============================================================================
-- PATCH: MISSING COLUMNS & RLS FIX
-- DATA: 2026-01-29
-- OBJETIVO: Adicionar a coluna 'city' e garantir permissão de update.
-- ==============================================================================

BEGIN;

-- 1. Adicionar coluna 'city' se não existir
DO $$ 
BEGIN 
    ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS city TEXT;
EXCEPTION
    WHEN OTHERS THEN NULL;
END $$;

-- 2. Garantir Política de UPDATE para o próprio usuário
-- Às vezes o RLS padrão de "Public Profiles" impede o update se não houver política específica.
DROP POLICY IF EXISTS "Users can update own profile." ON public.profiles;
CREATE POLICY "Users can update own profile." 
ON public.profiles FOR UPDATE 
TO authenticated 
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

COMMIT;
