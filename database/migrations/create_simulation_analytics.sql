-- SIMULATION ANALYTICS TABLES
-- ==============================
-- 
-- Tabelas para rastreamento de uso do módulo SimulationFactory
-- 
-- Tabelas:
-- 1. simulation_search_events: Buscas realizadas
-- 2. simulation_question_views: Questões visualizadas

-- Table: simulation_search_events
CREATE TABLE IF NOT EXISTS simulation_search_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    query TEXT NOT NULL,
    areas TEXT, -- CSV de áreas filtradas
    cache_hit BOOLEAN DEFAULT false,
    result_count INTEGER DEFAULT 0,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_simulation_search_timestamp 
    ON simulation_search_events(timestamp DESC);

CREATE INDEX IF NOT EXISTS idx_simulation_search_user 
    ON simulation_search_events(user_id, timestamp DESC);

CREATE INDEX IF NOT EXISTS idx_simulation_search_query 
    ON simulation_search_events(query);

-- Table: simulation_question_views
CREATE TABLE IF NOT EXISTS simulation_question_views (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_simulation_views_timestamp 
    ON simulation_question_views(timestamp DESC);

CREATE INDEX IF NOT EXISTS idx_simulation_views_user 
    ON simulation_question_views(user_id, timestamp DESC);

CREATE INDEX IF NOT EXISTS idx_simulation_views_question 
    ON simulation_question_views(question_id, timestamp DESC);

-- RLS (Row Level Security)
ALTER TABLE simulation_search_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE simulation_question_views ENABLE ROW LEVEL SECURITY;

-- Policies: Usuários podem inserir e ler seus próprios dados
CREATE POLICY "Users can insert their own search events"
    ON simulation_search_events
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view their own search events"
    ON simulation_search_events
    FOR SELECT
    TO authenticated
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own view events"
    ON simulation_question_views
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view their own view events"
    ON simulation_question_views
    FOR SELECT
    TO authenticated
    USING (auth.uid() = user_id);

-- Policy: Admins podem ver tudo
CREATE POLICY "Admins can view all search events"
    ON simulation_search_events
    FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.is_admin = true
        )
    );

CREATE POLICY "Admins can view all view events"
    ON simulation_question_views
    FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.is_admin = true
        )
    );

-- Comentários
COMMENT ON TABLE simulation_search_events IS 'Rastreia todas as buscas de questões realizadas no módulo SimulationFactory';
COMMENT ON TABLE simulation_question_views IS 'Rastreia visualizações individuais de questões';

-- Function auxiliar: RPC para busca semântica (se ainda não existir)
CREATE OR REPLACE FUNCTION match_questions_semantic(
    query_embedding vector(768),
    match_threshold float,
    match_count int
)
RETURNS TABLE (
    id integer,
    metadata jsonb,
    similarity float
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        enem_questions.id,
        enem_questions.metadata,
        1 - (enem_questions.embedding <=> query_embedding) as similarity
    FROM enem_questions
    WHERE 1 - (enem_questions.embedding <=> query_embedding) > match_threshold
    ORDER BY enem_questions.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

COMMENT ON FUNCTION match_questions_semantic IS 'Busca semântica de questões usando similaridade de vetores (cosine distance)';
