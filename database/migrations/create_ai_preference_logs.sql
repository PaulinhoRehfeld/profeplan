-- ============================================
-- AI PREFERENCES ANALYTICS - DATABASE MIGRATION
-- ============================================
-- 
-- Cria tabela para rastrear uso de preferências de IA
-- e métricas de satisfação do usuário
--
-- AUTOR: Sistema Profeplan - Guardrails Analytics
-- DATA: 16/02/2026

-- 1. Criar tabela de logs de preferências
CREATE TABLE IF NOT EXISTS ai_preference_logs (
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
    
    -- Índices para performance
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Criar índices para consultas rápidas
CREATE INDEX idx_preference_logs_user_id ON ai_preference_logs(user_id);
CREATE INDEX idx_preference_logs_tool ON ai_preference_logs(tool);
CREATE INDEX idx_preference_logs_generated_at ON ai_preference_logs(generated_at DESC);
CREATE INDEX idx_preference_logs_methodology ON ai_preference_logs(methodology);
CREATE INDEX idx_preference_logs_feedback_score ON ai_preference_logs(feedback_score);

-- 3. Trigger para atualizar updated_at automaticamente
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

-- 4. RLS (Row Level Security) Policies
ALTER TABLE ai_preference_logs ENABLE ROW LEVEL SECURITY;

-- Usuários podem ver apenas seus próprios logs
CREATE POLICY "Users can view their own preference logs"
    ON ai_preference_logs FOR SELECT
    USING (auth.uid() = user_id);

-- Usuários podem inserir seus próprios logs
CREATE POLICY "Users can insert their own preference logs"
    ON ai_preference_logs FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Usuários podem atualizar seus próprios logs
CREATE POLICY "Users can update their own preference logs"
    ON ai_preference_logs FOR UPDATE
    USING (auth.uid() = user_id);

-- 5. View agregada de analytics (opcional, para consultas rápidas)
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

-- 6. Comentários para documentação
COMMENT ON TABLE ai_preference_logs IS 'Rastreia uso de preferências de IA e métricas de satisfação do usuário';
COMMENT ON COLUMN ai_preference_logs.tool IS 'Ferramenta que gerou o conteúdo: planning, pdi, chat, assessment';
COMMENT ON COLUMN ai_preference_logs.feedback_score IS 'Nota de satisfação de 1 a 5 estrelas';
COMMENT ON COLUMN ai_preference_logs.regeneration_requested IS 'Indica se o usuário pediu regeneração (sinal de insatisfação)';

-- ============================================
-- EXEMPLO DE QUERIES ÚTEIS
-- ============================================

-- Query 1: Metodologia mais usada por usuário nos últimos 30 dias
-- SELECT methodology, COUNT(*) as total 
-- FROM ai_preference_logs 
-- WHERE user_id = 'SEU_USER_ID' AND generated_at >= NOW() - INTERVAL '30 days'
-- GROUP BY methodology 
-- ORDER BY total DESC;

-- Query 2: Taxa de satisfação média por ferramenta
-- SELECT tool, AVG(feedback_score) as avg_rating, COUNT(*) as total_uses
-- FROM ai_preference_logs 
-- WHERE user_id = 'SEU_USER_ID' AND feedback_score IS NOT NULL
-- GROUP BY tool;

-- Query 3: Identificar preferências com alta taxa de regeneração (possível problema)
-- SELECT methodology, 
--        COUNT(*) as uses, 
--        SUM(CASE WHEN regeneration_requested THEN 1 ELSE 0 END) as regenerations,
--        (SUM(CASE WHEN regeneration_requested THEN 1 ELSE 0 END)::FLOAT / COUNT(*)) * 100 as regen_rate
-- FROM ai_preference_logs 
-- WHERE user_id = 'SEU_USER_ID'
-- GROUP BY methodology
-- HAVING COUNT(*) >= 5
-- ORDER BY regen_rate DESC;
