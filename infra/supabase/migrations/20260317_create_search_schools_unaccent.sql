-- ==============================================================================
-- MIGRATION: Função de busca de escolas com ignorância de acentos
-- Date: 2026-03-17
-- Goal: Permitir que "antonio" encontre "ANTÔNIO", etc.
-- ==============================================================================

-- 1. Garantir extensão UNACCENT (não é schema-specific)
CREATE EXTENSION IF NOT EXISTS unaccent;

-- 2. Criar função RPC para busca de escolas sem acento
CREATE OR REPLACE FUNCTION public.search_schools_unaccent(q text)
RETURNS SETOF public.schools
LANGUAGE sql
STABLE
AS $$
    SELECT *
    FROM public.schools
    WHERE unaccent(name) ILIKE unaccent('%' || q || '%')
    ORDER BY name
    LIMIT 10;
$$;

-- 3. Permissões: mesma regra da tabela (usuários autenticados podem SELECT)
GRANT EXECUTE ON FUNCTION public.search_schools_unaccent(text) TO authenticated;

