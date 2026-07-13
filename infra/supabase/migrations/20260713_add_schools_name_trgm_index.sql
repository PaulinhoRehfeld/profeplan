-- ==============================================================================
-- MIGRATION: Índice trigram para busca de escolas por nome
-- Date: 2026-07-13
-- Goal: search_schools_unaccent() rodava sem índice de suporte — recalculava
-- unaccent(name) em varredura sequencial nas 4.014 linhas de public.schools
-- a cada chamada. unaccent(text) não é IMMUTABLE (depende da config de busca
-- textual corrente), então não pode ser usada direto numa expressão de índice;
-- criamos um wrapper IMMUTABLE fixando o dicionário 'unaccent' e reescrevemos
-- a RPC para usar exatamente essa mesma expressão, permitindo que o planner
-- use o índice GIN trigram criado abaixo.
-- ==============================================================================

CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS unaccent;

CREATE OR REPLACE FUNCTION public.immutable_unaccent(text)
RETURNS text
LANGUAGE sql
IMMUTABLE
PARALLEL SAFE
STRICT
SET search_path = public
AS $$
    SELECT unaccent('public.unaccent'::regdictionary, $1);
$$;

CREATE INDEX IF NOT EXISTS idx_schools_name_trgm
    ON public.schools
    USING GIN (public.immutable_unaccent(name) gin_trgm_ops);

-- Reescreve a RPC para usar a expressão indexada (name) e mantém a busca por
-- cidade sem índice — cardinalidade baixa (poucas centenas de cidades em MG),
-- ILIKE direto num seq scan de 4 mil linhas é barato o suficiente.
CREATE OR REPLACE FUNCTION public.search_schools_unaccent(q text)
RETURNS SETOF public.schools
LANGUAGE sql
STABLE
AS $$
    SELECT *
    FROM public.schools
    WHERE public.immutable_unaccent(name) ILIKE public.immutable_unaccent('%' || q || '%')
       OR public.immutable_unaccent(city) ILIKE public.immutable_unaccent('%' || q || '%')
    ORDER BY name
    LIMIT 10;
$$;

GRANT EXECUTE ON FUNCTION public.search_schools_unaccent(text) TO authenticated;
