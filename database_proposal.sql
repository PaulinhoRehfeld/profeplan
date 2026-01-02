-- ==============================================================================
-- PROFEPLAN v3 - Database Migration Proposal
-- ==============================================================================

-- 1. Tabela: generated_contents
-- Atualização para suportar novos tipos de conteúdo (Planejamento Trimestral e ENEM).
-- Verifique se a constraint já existe antes de rodar. Caso contrário, apenas adicione.

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'generated_contents_type_check') THEN
        ALTER TABLE generated_contents DROP CONSTRAINT generated_contents_type_check;
    END IF;
END $$;

ALTER TABLE generated_contents 
ADD CONSTRAINT generated_contents_type_check 
CHECK (type IN ('plano', 'aula', 'avaliacao', 'documento', 'trimestral', 'enem'));

-- 2. Tabela: enem_questions (NOVA)
-- Armazena questões do ENEM para consulta e geração de simulados.

CREATE TABLE IF NOT EXISTS enem_questions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    year INTEGER NOT NULL,
    area TEXT NOT NULL CHECK (area IN ('Linguagens', 'Ciências Humanas', 'Ciências da Natureza', 'Matemática')),
    subject TEXT, -- Ex: 'História', 'Física'
    topic TEXT, -- Ex: 'Era Vargas', 'Termodinâmica'
    question_text TEXT NOT NULL,
    options JSONB NOT NULL, -- Ex: [{"label": "A", "text": "..."}, ...]
    correct_answer CHAR(1) NOT NULL CHECK (correct_answer IN ('A', 'B', 'C', 'D', 'E')),
    difficulty TEXT CHECK (difficulty IN ('Fácil', 'Médio', 'Difícil')),
    skills TEXT, -- Códigos das habilidades (ex: 'H1', 'H5')
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS (Row Level Security) para segurança
ALTER TABLE enem_questions ENABLE ROW LEVEL SECURITY;

-- Política de Leitura: Todos os usuários autenticados podem ler as questões
CREATE POLICY "Enable read access for authenticated users" 
ON enem_questions FOR SELECT 
TO authenticated 
USING (true);

-- Política de Escrita: Apenas administradores/service_role (ajuste conforme sua auth)
-- Por padrão, sem política definida, INSERT/UPDATE é negado para usuários comuns.

-- 3. Tabela: user_learning_profile (EXISTENTE/ATUALIZAÇÃO)
-- Garante que a tabela existe para armazenar preferências estendidas.

CREATE TABLE IF NOT EXISTS user_learning_profile (
    user_id UUID REFERENCES auth.users NOT NULL PRIMARY KEY,
    preferences JSONB DEFAULT '{}'::jsonb,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_mode TEXT,
    last_discipline TEXT,
    last_grade TEXT
);

-- Habilitar RLS
ALTER TABLE user_learning_profile ENABLE ROW LEVEL SECURITY;

-- Política: Usuários podem ver e editar apenas seu próprio perfil
CREATE POLICY "Users can view own profile" 
ON user_learning_profile FOR SELECT 
TO authenticated 
USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile" 
ON user_learning_profile FOR UPDATE 
TO authenticated 
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own profile" 
ON user_learning_profile FOR INSERT 
TO authenticated 
WITH CHECK (auth.uid() = user_id);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_enem_questions_area ON enem_questions(area);
CREATE INDEX IF NOT EXISTS idx_enem_questions_subject ON enem_questions(subject);
