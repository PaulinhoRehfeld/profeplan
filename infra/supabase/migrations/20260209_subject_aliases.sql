-- ================================================
-- PHASE 1: Normalização de Disciplinas (SUPLEMENTO)
-- ================================================
-- NOTA: A migration 20260209_create_subject_aliases.sql cria a tabela e popula
-- com os dados principais. Este arquivo adiciona variantes extras com ON CONFLICT DO NOTHING,
-- portanto é seguro executar ambos em qualquer ordem.
-- Bugs de espaço em branco das versões originais foram corrigidos aqui.

CREATE TABLE IF NOT EXISTS subject_aliases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    input_variant TEXT NOT NULL UNIQUE,
    normalized_name TEXT NOT NULL,
    category TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_subject_aliases_input
ON subject_aliases(LOWER(input_variant));

-- Variantes adicionais (ON CONFLICT DO NOTHING garante idempotência)
INSERT INTO subject_aliases (input_variant, normalized_name, category) VALUES
-- Língua Portuguesa (variante com espaço: corrigida de ' português')
('português', 'Língua Portuguesa', 'Linguagens'),
('portugues', 'Língua Portuguesa', 'Linguagens'),
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

-- Educação Física (variante com espaço: corrigida de ' ed fisica')
('ed fisica', 'Educação Física', 'Linguagens'),
('educacao fisica', 'Educação Física', 'Linguagens'),
('educação física', 'Educação Física', 'Linguagens'),
('Educação Física', 'Educação Física', 'Linguagens'),

-- Redação
('redacao', 'Redação', 'Linguagens'),
('redação', 'Redação', 'Linguagens'),
('Redação', 'Redação', 'Linguagens')

ON CONFLICT (input_variant) DO NOTHING;
