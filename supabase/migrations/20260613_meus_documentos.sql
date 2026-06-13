-- =============================================================================
-- Migration: meus_documentos + teacher_documents + teacher_document_chunks + teacher_agents
-- Projeto: PROFEPLAN V4
-- Data: 2026-06-13
-- =============================================================================

-- Habilita a extensão pgvector caso não esteja habilitada (já deve estar pelo anterior)
CREATE EXTENSION IF NOT EXISTS vector;

-- =============================================================================
-- 1. Tabela: teacher_documents
-- Armazena os documentos enviados pelo professor e seu status de processamento
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.teacher_documents (
  id                UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID            NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  category          TEXT            NOT NULL CHECK (category IN ('course_plan', 'book', 'didactic_material')),
  title             TEXT            NOT NULL,
  filename          TEXT            NOT NULL,
  version           INT             NOT NULL DEFAULT 1,
  content_md        TEXT,                           -- Conteúdo extraído formatado em Markdown
  metadata          JSONB           DEFAULT '{}'::jsonb, -- Metadados (disciplina, ano, habilidades, etc.)
  extraction_score  FLOAT,                          -- Score de confiança da extração (%)
  curation_report   TEXT,                           -- Relatório de auditoria de curadoria por IA
  status            TEXT            NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'reprocessing')),
  created_at        TIMESTAMPTZ     DEFAULT now(),
  updated_at        TIMESTAMPTZ     DEFAULT now()
);

-- Índices básicos
CREATE INDEX IF NOT EXISTS idx_teacher_documents_user ON public.teacher_documents(user_id);
CREATE INDEX IF NOT EXISTS idx_teacher_documents_category ON public.teacher_documents(category);

-- =============================================================================
-- 2. Tabela: teacher_document_chunks
-- Armazena os pedaços (chunks) vetorizados dos documentos dos professores
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.teacher_document_chunks (
  id                UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id       UUID            NOT NULL REFERENCES public.teacher_documents(id) ON DELETE CASCADE,
  user_id           UUID            NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content           TEXT            NOT NULL,
  embedding         VECTOR(768),                    -- Embedding Gemini (768 dims)
  created_at        TIMESTAMPTZ     DEFAULT now()
);

-- Índices e Busca Vetorial
CREATE INDEX IF NOT EXISTS idx_teacher_document_chunks_user ON public.teacher_document_chunks(user_id);
CREATE INDEX IF NOT EXISTS idx_teacher_document_chunks_document ON public.teacher_document_chunks(document_id);

CREATE INDEX IF NOT EXISTS teacher_document_chunks_embedding_idx
  ON public.teacher_document_chunks
  USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);

-- =============================================================================
-- 3. Tabela: teacher_agents
-- Configuração de agentes pedagógicos customizados por professor/disciplina
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.teacher_agents (
  id                UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID            NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name              TEXT            NOT NULL,
  subject           TEXT            NOT NULL,
  grade             TEXT            NOT NULL,
  document_id       UUID            REFERENCES public.teacher_documents(id) ON DELETE SET NULL, -- Plano de Curso vinculado
  system_prompt     TEXT            NOT NULL,
  created_at        TIMESTAMPTZ     DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_teacher_agents_user ON public.teacher_agents(user_id);
CREATE INDEX IF NOT EXISTS idx_teacher_agents_subject_grade ON public.teacher_agents(user_id, subject, grade);

-- =============================================================================
-- 4. Habilitar RLS (Row Level Security) e Políticas
-- =============================================================================

ALTER TABLE public.teacher_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teacher_document_chunks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teacher_agents ENABLE ROW LEVEL SECURITY;

-- Políticas para teacher_documents
DROP POLICY IF EXISTS "Users can perform all actions on own documents" ON public.teacher_documents;
CREATE POLICY "Users can perform all actions on own documents"
  ON public.teacher_documents
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Políticas para teacher_document_chunks
DROP POLICY IF EXISTS "Users can perform all actions on own chunks" ON public.teacher_document_chunks;
CREATE POLICY "Users can perform all actions on own chunks"
  ON public.teacher_document_chunks
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Políticas para teacher_agents
DROP POLICY IF EXISTS "Users can perform all actions on own agents" ON public.teacher_agents;
CREATE POLICY "Users can perform all actions on own agents"
  ON public.teacher_agents
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- =============================================================================
-- 5. Função RPC: search_teacher_chunks
-- Realiza busca semântica nos chunks privados do professor
-- =============================================================================

CREATE OR REPLACE FUNCTION public.search_teacher_chunks(
  p_user_id           UUID,
  p_embedding         VECTOR(768),
  p_match_threshold   FLOAT,
  p_match_count       INT
)
RETURNS TABLE (
  chunk_id          UUID,
  document_id       UUID,
  category          TEXT,
  document_title    TEXT,
  content           TEXT,
  similarity        FLOAT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    tc.id AS chunk_id,
    tc.document_id,
    td.category,
    td.title AS document_title,
    tc.content,
    (1 - (tc.embedding <=> p_embedding))::FLOAT AS similarity
  FROM public.teacher_document_chunks tc
  JOIN public.teacher_documents td ON tc.document_id = td.id
  WHERE
    tc.user_id = p_user_id
    AND td.status = 'approved'
    AND (1 - (tc.embedding <=> p_embedding)) > p_match_threshold
  ORDER BY similarity DESC
  LIMIT p_match_count;
END;
$$;

GRANT EXECUTE ON FUNCTION public.search_teacher_chunks TO anon, authenticated;
