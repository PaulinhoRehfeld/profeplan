-- =============================================================================
-- Migration: search_curriculum_rag + curriculum_rag table
-- Projeto: PROFEPLAN
-- Supabase: uatejrgmbzgoeayfascf
-- Data: 2026-06-06
-- =============================================================================
-- DESCRIÇÃO:
--   1. Habilita a extensão pgvector (caso não esteja)
--   2. Cria a tabela `curriculum_rag` para armazenar trechos de currículo SEE/MG
--   3. Cria a função RPC `search_curriculum_rag` (buscada pelo código legado)
--   4. Cria a função RPC `get_curriculo_completo` (busca determinística SEE/MG)
--   5. Configura RLS básica (leitura pública)
-- =============================================================================

-- 1. Extensão pgvector (necessária para busca semântica)
-- NOTA: No Supabase cloud, habilitar via Dashboard → Extensions também funciona
CREATE EXTENSION IF NOT EXISTS vector;

-- =============================================================================
-- 2. Tabela curriculum_rag
-- Armazena trechos de currículo oficial (SEE/MG, BNCC) com embeddings vetoriais
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.curriculum_rag (
  id            UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
  content       TEXT            NOT NULL,       -- trecho do currículo em texto
  embedding     vector(768),                    -- embedding Gemini (768 dims)
  disciplina    TEXT,                           -- ex: "Matemática"
  ano_escolar   TEXT,                           -- ex: "8º Ano", "1º Ano EM"
  periodo       TEXT,                           -- ex: "1º Trimestre"
  fonte         TEXT DEFAULT 'SEE/MG',          -- "SEE/MG", "BNCC", "CRMG"
  ano_base      INT  DEFAULT 2025,              -- ano do currículo
  metadata      JSONB DEFAULT '{}'::jsonb,
  created_at    TIMESTAMPTZ DEFAULT now()
);

-- Índice vetorial para busca semântica (IVFFlat)
CREATE INDEX IF NOT EXISTS curriculum_rag_embedding_idx
  ON public.curriculum_rag
  USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);

-- Índices de filtro
CREATE INDEX IF NOT EXISTS curriculum_rag_disciplina_idx ON public.curriculum_rag (disciplina);
CREATE INDEX IF NOT EXISTS curriculum_rag_ano_escolar_idx ON public.curriculum_rag (ano_escolar);
CREATE INDEX IF NOT EXISTS curriculum_rag_periodo_idx ON public.curriculum_rag (periodo);

-- Full-text index para fallback de busca por texto
CREATE INDEX IF NOT EXISTS curriculum_rag_content_fts_idx
  ON public.curriculum_rag
  USING gin(to_tsvector('portuguese', content));

-- =============================================================================
-- 3. RLS (Row Level Security)
-- =============================================================================

ALTER TABLE public.curriculum_rag ENABLE ROW LEVEL SECURITY;

-- Leitura pública (o currículo é conteúdo público)
DROP POLICY IF EXISTS "curriculum_rag_read_public" ON public.curriculum_rag;
CREATE POLICY "curriculum_rag_read_public"
  ON public.curriculum_rag
  FOR SELECT
  USING (true);

-- Escrita apenas para service_role (ingestão via scripts)
DROP POLICY IF EXISTS "curriculum_rag_insert_service_role" ON public.curriculum_rag;
CREATE POLICY "curriculum_rag_insert_service_role"
  ON public.curriculum_rag
  FOR INSERT
  TO service_role
  WITH CHECK (true);

-- =============================================================================
-- 4. Função RPC: search_curriculum_rag
-- =============================================================================
-- Chamada pelo código legado:
--   supabase.rpc('search_curriculum_rag', {
--     query_text, match_threshold, match_count,
--     filter_disciplina, filter_ano, filter_periodo
--   })
--
-- ESTRATÉGIA DUAL:
--   - Se existir embedding: usa similaridade cosseno (pgvector)
--   - Fallback: full-text search em português
-- =============================================================================

-- Remover todas as sobrecargas anteriores para evitar conflito de assinaturas
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN 
    SELECT oid::regprocedure AS prod
    FROM pg_proc 
    WHERE proname = 'search_curriculum_rag'
  LOOP
    EXECUTE 'DROP FUNCTION ' || r.prod || ' CASCADE';
  END LOOP;
END;
$$;

CREATE OR REPLACE FUNCTION public.search_curriculum_rag(
  query_text        TEXT,
  match_threshold   FLOAT    DEFAULT 0.5,
  match_count       INT      DEFAULT 5,
  filter_disciplina TEXT     DEFAULT NULL,
  filter_ano        TEXT     DEFAULT NULL,
  filter_periodo    TEXT     DEFAULT NULL
)
RETURNS TABLE (
  id          UUID,
  content     TEXT,
  disciplina  TEXT,
  ano_escolar TEXT,
  periodo     TEXT,
  fonte       TEXT,
  ano_base    INT,
  metadata    JSONB,
  similarity  FLOAT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  has_vectors BOOLEAN;
BEGIN
  -- Verifica se a tabela tem embeddings populados
  SELECT EXISTS (
    SELECT 1 FROM public.curriculum_rag
    WHERE embedding IS NOT NULL LIMIT 1
  ) INTO has_vectors;

  IF has_vectors THEN
    -- -------------------------------------------------------------------------
    -- MODO SEMÂNTICO: busca por similaridade vetorial
    -- Requer que o embedding do query_text seja gerado pelo chamador.
    -- Como este é um fallback seguro, usamos full-text mesmo quando tem vetores
    -- (o app legado envia query_text, não o vetor — geração de embedding é no client)
    -- -------------------------------------------------------------------------
    RETURN QUERY
    SELECT
      cr.id,
      cr.content,
      cr.disciplina,
      cr.ano_escolar,
      cr.periodo,
      cr.fonte,
      cr.ano_base,
      cr.metadata,
      ts_rank(to_tsvector('portuguese', cr.content), plainto_tsquery('portuguese', query_text))::FLOAT AS similarity
    FROM public.curriculum_rag cr
    WHERE
      (filter_disciplina IS NULL OR cr.disciplina ILIKE '%' || filter_disciplina || '%')
      AND (filter_ano IS NULL OR cr.ano_escolar ILIKE '%' || filter_ano || '%')
      AND (filter_periodo IS NULL OR cr.periodo ILIKE '%' || filter_periodo || '%')
      AND to_tsvector('portuguese', cr.content) @@ plainto_tsquery('portuguese', query_text)
    ORDER BY similarity DESC
    LIMIT match_count;
  ELSE
    -- -------------------------------------------------------------------------
    -- MODO FALLBACK: full-text search (quando tabela está vazia ou sem vetores)
    -- Retorna resultados parciais sem falhar
    -- -------------------------------------------------------------------------
    RETURN QUERY
    SELECT
      cr.id,
      cr.content,
      cr.disciplina,
      cr.ano_escolar,
      cr.periodo,
      cr.fonte,
      cr.ano_base,
      cr.metadata,
      0.0::FLOAT AS similarity
    FROM public.curriculum_rag cr
    WHERE
      (filter_disciplina IS NULL OR cr.disciplina ILIKE '%' || filter_disciplina || '%')
      AND (filter_ano IS NULL OR cr.ano_escolar ILIKE '%' || filter_ano || '%')
      AND (filter_periodo IS NULL OR cr.periodo ILIKE '%' || filter_periodo || '%')
      AND (
        cr.content ILIKE '%' || query_text || '%'
        OR cr.disciplina ILIKE '%' || query_text || '%'
      )
    ORDER BY cr.created_at DESC
    LIMIT match_count;
  END IF;
END;
$$;

-- Permite execução pela role anon e authenticated
GRANT EXECUTE ON FUNCTION public.search_curriculum_rag TO anon, authenticated;

-- =============================================================================
-- 5. Função RPC: get_curriculo_completo
-- =============================================================================
-- Busca determinística do currículo SEE/MG completo para uma disciplina/período.
-- Retorna o conteúdo concatenado (texto) ou vazio.
-- =============================================================================

-- Remover todas as sobrecargas anteriores para evitar conflito de assinaturas
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN 
    SELECT oid::regprocedure AS prod
    FROM pg_proc 
    WHERE proname = 'get_curriculo_completo'
  LOOP
    EXECUTE 'DROP FUNCTION ' || r.prod || ' CASCADE';
  END LOOP;
END;
$$;

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
  SELECT string_agg(content, E'\n\n---\n\n' ORDER BY created_at ASC)
  INTO result
  FROM public.curriculum_rag
  WHERE
    disciplina ILIKE '%' || p_disciplina || '%'
    AND periodo ILIKE '%' || p_periodo || '%'
    AND (p_ano_escolar IS NULL OR ano_escolar ILIKE '%' || p_ano_escolar || '%')
    AND fonte IN ('SEE/MG', 'CRMG');

  RETURN COALESCE(result, '');
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_curriculo_completo TO anon, authenticated;

-- =============================================================================
-- 6. Dados de exemplo (seed mínimo para validar funcionamento)
-- Remove antes de produção se tiver dados reais
-- =============================================================================

INSERT INTO public.curriculum_rag (content, disciplina, ano_escolar, periodo, fonte, ano_base)
VALUES
  (
    'EF09MA01: Compreender os números inteiros, racionais e irracionais. Resolver problemas com equações do 1º e 2º grau. Trabalhar com funções afins e quadráticas.',
    'Matemática', '9º Ano', '1º Trimestre', 'BNCC', 2025
  ),
  (
    'EM13MAT101: Interpretar situações econômicas, sociais e das Ciências da Natureza que envolvem a variação de grandezas, pela análise dos gráficos das funções polinomiais de 1º e 2º graus. EM13MAT103: Analisar gráficos de barras, histogramas e polígonos de frequência.',
    'Matemática', '1º Ano EM', '1º Trimestre', 'SEE/MG', 2025
  ),
  (
    'EF07HI01: Explicar o significado de "modernidade" e suas contradições, comparando diferentes interpretações sobre as transformações que se sucederam no continente europeu com o surgimento do capitalismo.',
    'História', '7º Ano', '1º Trimestre', 'BNCC', 2025
  ),
  (
    'EF08LP01: Demonstrar atitudes de respeito, acolhimento e valorização de repertórios linguísticos. Analisar gêneros textuais argumentativos. Produzir textos dissertativo-argumentativos.',
    'Língua Portuguesa', '8º Ano', '1º Trimestre', 'BNCC', 2025
  )
ON CONFLICT DO NOTHING;

-- =============================================================================
-- FIM DA MIGRATION
-- =============================================================================
-- Para aplicar:
--   Supabase Dashboard → SQL Editor → Cole e execute este arquivo
--   OU: npx supabase db push (se usando CLI local)
-- =============================================================================
