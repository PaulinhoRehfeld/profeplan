-- =============================================================================
-- Migration: search_curriculum_rag + get_curriculo_completo (busca textual)
-- Projeto: PROFEPLAN V4
-- Data: 2026-06-23
-- Nota: Funções de busca textual (sem embeddings). Funciona com os 1576
--       registros importados via import_curriculo_from_json.py.
--       Substitui a dependência de pgvector para o fluxo principal.
-- =============================================================================

BEGIN;

-- Drop existentes para permitir mudança de tipo de retorno
DROP FUNCTION IF EXISTS public.search_curriculum_rag(text, float, integer, text, text, text);
DROP FUNCTION IF EXISTS public.get_curriculo_completo(text, text, text);

-- ---------------------------------------------------------------------------
-- 1. search_curriculum_rag
--    Chamada por: api/searchProxy.ts e searchService.ts (fallback)
--    Busca por texto livre + filtros de disciplina / ano / período.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.search_curriculum_rag(
  query_text        TEXT,
  match_threshold   FLOAT  DEFAULT 0.3,   -- aceito por compatibilidade, ignorado na busca textual
  match_count       INT    DEFAULT 10,
  filter_disciplina TEXT   DEFAULT NULL,
  filter_ano        TEXT   DEFAULT NULL,
  filter_periodo    TEXT   DEFAULT NULL
)
RETURNS TABLE (
  id          UUID,
  content     TEXT,
  disciplina  TEXT,
  ano_escolar TEXT,
  periodo     TEXT,
  fonte       TEXT,
  ano_base    INT,
  metadata    JSONB
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    c.id,
    c.content,
    c.disciplina,
    c.ano_escolar,
    c.periodo,
    c.fonte,
    c.ano_base,
    c.metadata
  FROM public.curriculos_mg c
  WHERE
    -- Filtros estruturados (AND)
    (filter_disciplina IS NULL OR c.disciplina ILIKE '%' || filter_disciplina || '%')
    AND (filter_ano      IS NULL OR c.ano_escolar ILIKE '%' || filter_ano      || '%')
    AND (filter_periodo  IS NULL OR c.periodo     ILIKE '%' || filter_periodo  || '%')
    -- Busca textual no conteúdo (OR entre content e disciplina)
    AND (
      query_text IS NULL
      OR query_text = ''
      OR c.content    ILIKE '%' || query_text || '%'
      OR c.disciplina ILIKE '%' || query_text || '%'
    )
  ORDER BY
    -- Prioriza match exato na disciplina
    CASE WHEN filter_disciplina IS NOT NULL
              AND c.disciplina ILIKE '%' || filter_disciplina || '%'
         THEN 0 ELSE 1 END,
    c.ano_escolar,
    c.periodo
  LIMIT match_count;
END;
$$;

GRANT EXECUTE ON FUNCTION public.search_curriculum_rag TO anon, authenticated;


-- ---------------------------------------------------------------------------
-- 2. get_curriculo_completo
--    Chamada por: searchService.getDeterministicCurriculum()
--    Retorna o conteúdo concatenado de um currículo específico.
--    Path primário para MG — mais preciso que a busca RAG.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_curriculo_completo(
  p_disciplina  TEXT,
  p_periodo     TEXT,
  p_ano_escolar TEXT DEFAULT NULL
)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  result TEXT;
BEGIN
  SELECT string_agg(
    c.content,
    E'\n\n---\n\n'
    ORDER BY c.periodo, c.ano_escolar
  )
  INTO result
  FROM public.curriculos_mg c
  WHERE
    (p_disciplina  IS NULL OR c.disciplina  ILIKE '%' || p_disciplina  || '%')
    AND (p_periodo     IS NULL OR c.periodo     ILIKE '%' || p_periodo     || '%')
    AND (p_ano_escolar IS NULL OR c.ano_escolar ILIKE '%' || p_ano_escolar || '%');

  RETURN COALESCE(result, '');
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_curriculo_completo TO anon, authenticated;

COMMIT;
