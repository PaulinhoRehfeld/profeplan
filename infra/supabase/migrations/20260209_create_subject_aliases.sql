-- ================================================
-- PHASE 1: Subject Normalization Table
-- ================================================
-- Execute este SQL no Supabase Dashboard > SQL Editor
-- Path: https://app.supabase.com/project/uatejrgmbzgoeayfascf/sql

-- 1. Criar Tabela
CREATE TABLE IF NOT EXISTS subject_aliases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    input_variant TEXT NOT NULL UNIQUE,
    normalized_name TEXT NOT NULL,
    category TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Criar Índice para busca rápida
CREATE INDEX IF NOT EXISTS idx_subject_aliases_input 
ON subject_aliases(LOWER(input_variant));

-- 3. Popular com variantes comuns
INSERT INTO subject_aliases (input_variant, normalized_name, category) VALUES
-- Língua Portuguesa
('portugues', 'Língua Portuguesa', 'Linguagens'),
('português', 'Língua Portuguesa', 'Linguagens'),
('lingua portuguesa', 'Língua Portuguesa', 'Linguagens'),
('Língua Portuguesa', 'Língua Portuguesa', 'Linguagens'),

-- História
('historia', 'História', 'Ciências Humanas'),
('história', 'História', 'Ciências Humanas'),
('História', 'História', 'Ciências Humanas'),

-- Matemática
('matematica', 'Matemática', 'Matemática'),
('matemática', 'Matemática', 'Matemática'),
('Matemática', 'Matemática', 'Matemática'),

-- Língua Inglesa
('ingles', 'Língua Inglesa', 'Linguagens'),
('inglês', 'Língua Inglesa', 'Linguagens'),
('lingua inglesa', 'Língua Inglesa', 'Linguagens'),
('Língua Inglesa', 'Língua Inglesa', 'Linguagens'),

-- Geografia
('geografia', 'Geografia', 'Ciências Humanas'),
('Geografia', 'Geografia', 'Ciências Humanas'),

-- Biologia
('biologia', 'Biologia', 'Ciências da Natureza'),
('Biologia', 'Biologia', 'Ciências da Natureza'),

-- Física
('fisica', 'Física', 'Ciências da Natureza'),
('física', 'Física', 'Ciências da Natureza'),
('Física', 'Física', 'Ciências da Natureza'),

-- Química
('quimica', 'Química', 'Ciências da Natureza'),
('química', 'Química', 'Ciências da Natureza'),
('Química', 'Química', 'Ciências da Natureza'),

-- Filosofia
('filosofia', 'Filosofia', 'Ciências Humanas'),
('Filosofia', 'Filosofia', 'Ciências Humanas'),

-- Sociologia
('sociologia', 'Sociologia', 'Ciências Humanas'),
('Sociologia', 'Sociologia', 'Ciências Humanas'),

-- Artes
('artes', 'Artes', 'Linguagens'),
('arte', 'Artes', 'Linguagens'),
('Artes', 'Artes', 'Linguagens'),

-- Educação Física
('educacao fisica', 'Educação Física', 'Linguagens'),
('educação física', 'Educação Física', 'Linguagens'),
('Educação Física', 'Educação Física', 'Linguagens'),
('ed fisica', 'Educação Física', 'Linguagens'),

-- Redação
('redacao', 'Redação', 'Linguagens'),
('redação', 'Redação', 'Linguagens'),
('Redação', 'Redação', 'Linguagens')

ON CONFLICT (input_variant) DO NOTHING;

-- 4. Verificar inserção
SELECT 
    category,
    COUNT(*) as total_variants,
    STRING_AGG(DISTINCT normalized_name, ', ' ORDER BY normalized_name) as subjects
FROM subject_aliases
GROUP BY category
ORDER BY category;

-- Resultado esperado:
-- Ciências Humanas: 4 disciplinas (Filosofia, Geografia, História, Sociologia)
-- Ciências da Natureza: 3 disciplinas (Biologia, Física, Química)
-- Linguagens: 5 disciplinas (Artes, Educação Física, Língua Inglesa, Língua Portuguesa, Redação)
-- Matemática: 1 disciplina (Matemática)
