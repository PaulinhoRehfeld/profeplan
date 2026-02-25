-- ============================================
-- AI PREFERENCES ANALYTICS - DATABASE MIGRATION (SAFE VERSION)
-- ============================================
-- 
-- Versão segura que pode ser executada múltiplas vezes sem erros
-- Remove tudo antes de recriar (útil para desenvolvimento)
--
-- AUTOR: Sistema Profeplan - Guardrails Analytics
-- DATA: 16/02/2026

-- 1. Remover tudo que possa existir (ordem reversa de dependências)
DROP VIEW IF EXISTS ai_preference_analytics_summary;
DROP TRIGGER IF EXISTS update_ai_preference_logs_updated_at ON ai_preference_logs;
DROP FUNCTION IF EXISTS update_updated_at_column();
DROP TABLE IF EXISTS ai_preference_logs CASCADE;

-- 2. Criar tabela de logs de preferências
CREATE TABLE ai_preference_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    tool TEXT NOT NULL CHECK (tool IN ('planning', 'pdi', 'chat', 'assessment')),
    
    -- Preferências aplicadas
    methodology TEXT NOT NULL,
    pedagogical_style TEXT NOT NULL,
    assessment_focus TEXT NOT NULL,
    writing_tone TEXT NOT NULL,
    
    -- Métricas de satisfação
    feedback_score INTEGER CHECK (feedback_score >= 1 AND feedback_score <= 5),
    feedback_text TEXT,
    regeneration_requested BOOLEAN DEFAULT FALSE,
    
    -- Timestamps
    generated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Criar índices para consultas rápidas
CREATE INDEX idx_preference_logs_user_id ON ai_preference_logs(user_id);
CREATE INDEX idx_preference_logs_tool ON ai_preference_logs(tool);
CREATE INDEX idx_preference_logs_generated_at ON ai_preference_logs(generated_at DESC);
CREATE INDEX idx_preference_logs_methodology ON ai_preference_logs(methodology);
CREATE INDEX idx_preference_logs_feedback_score ON ai_preference_logs(feedback_score);

-- 4. Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_ai_preference_logs_updated_at 
    BEFORE UPDATE ON ai_preference_logs 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 5. RLS (Row Level Security) Policies
ALTER TABLE ai_preference_logs ENABLE ROW LEVEL SECURITY;

-- Remover políticas antigas se existirem
DROP POLICY IF EXISTS "Users can view their own preference logs" ON ai_preference_logs;
DROP POLICY IF EXISTS "Users can insert their own preference logs" ON ai_preference_logs;
DROP POLICY IF EXISTS "Users can update their own preference logs" ON ai_preference_logs;

-- Criar políticas
CREATE POLICY "Users can view their own preference logs"
    ON ai_preference_logs FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own preference logs"
    ON ai_preference_logs FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own preference logs"
    ON ai_preference_logs FOR UPDATE
    USING (auth.uid() = user_id);

-- 6. View agregada de analytics
CREATE OR REPLACE VIEW ai_preference_analytics_summary AS
SELECT 
    user_id,
    tool,
    methodology,
    COUNT(*) as usage_count,
    AVG(feedback_score) as avg_satisfaction,
    SUM(CASE WHEN regeneration_requested THEN 1 ELSE 0 END)::FLOAT / COUNT(*) * 100 as regeneration_rate,
    MAX(generated_at) as last_used_at
FROM ai_preference_logs
WHERE generated_at >= NOW() - INTERVAL '30 days'
GROUP BY user_id, tool, methodology;

-- 7. Comentários para documentação
COMMENT ON TABLE ai_preference_logs IS 'Rastreia uso de preferências de IA e métricas de satisfação do usuário';
COMMENT ON COLUMN ai_preference_logs.tool IS 'Ferramenta que gerou o conteúdo: planning, pdi, chat, assessment';
COMMENT ON COLUMN ai_preference_logs.feedback_score IS 'Nota de satisfação de 1 a 5 estrelas';
COMMENT ON COLUMN ai_preference_logs.regeneration_requested IS 'Indica se o usuário pediu regeneração (sinal de insatisfação)';

-- ============================================
-- SUCESSO!
-- ============================================
-- Tabela ai_preference_logs criada/recriada com sucesso
-- Sistema de analytics pronto para uso
