-- ============================================
-- USER FEEDBACK PREFERENCES - DATABASE MIGRATION
-- ============================================
-- 
-- Armazena feedbacks iterativos do usuário e os transforma em
-- preferências padrão para futuros planejamentos
--
-- DATA: 16/02/2026

-- 1. Criar tabela de preferências de feedback
CREATE TABLE IF NOT EXISTS user_feedback_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    
    -- Feedback original do professor
    feedback_text TEXT NOT NULL,
    
    -- Tipo de preferência identificada
    preference_type TEXT NOT NULL CHECK (preference_type IN ('methodology', 'style', 'tone', 'focus', 'general')),
    
    -- Se já foi aplicado às configurações do usuário
    applied_to_settings BOOLEAN DEFAULT FALSE,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Criar índices
CREATE INDEX idx_feedback_prefs_user_id ON user_feedback_preferences(user_id);
CREATE INDEX idx_feedback_prefs_type ON user_feedback_preferences(preference_type);
CREATE INDEX idx_feedback_prefs_created_at ON user_feedback_preferences(created_at DESC);

-- 3. Trigger para updated_at
CREATE OR REPLACE FUNCTION update_feedback_prefs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_user_feedback_preferences_updated_at 
    BEFORE UPDATE ON user_feedback_preferences 
    FOR EACH ROW 
    EXECUTE FUNCTION update_feedback_prefs_updated_at();

-- 4. RLS Policies
ALTER TABLE user_feedback_preferences ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own feedback preferences"
    ON user_feedback_preferences FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own feedback preferences"
    ON user_feedback_preferences FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own feedback preferences"
    ON user_feedback_preferences FOR UPDATE
    USING (auth.uid() = user_id);

-- 5. Comentários
COMMENT ON TABLE user_feedback_preferences IS 'Armazena feedbacks iterativos e os transforma em preferências padrão';
COMMENT ON COLUMN user_feedback_preferences.feedback_text IS 'Feedback original do professor sobre o plano';
COMMENT ON COLUMN user_feedback_preferences.preference_type IS 'Tipo de preferência: methodology, style, tone, focus, general';
COMMENT ON COLUMN user_feedback_preferences.applied_to_settings IS 'Se o feedback já foi aplicado às configurações do usuário';

-- ============================================
-- QUERIES ÚTEIS
-- ============================================

-- Buscar feedbacks não aplicados
-- SELECT * FROM user_feedback_preferences WHERE applied_to_settings = FALSE;

-- Feedbacks por tipo de preferência
-- SELECT preference_type, COUNT(*) as total FROM user_feedback_preferences GROUP BY preference_type;
