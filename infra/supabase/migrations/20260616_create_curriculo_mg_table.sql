-- ================================================
-- LOAD curriculo_mg JSON into Supabase
-- ================================================
-- INSTRUÇÕES:
-- 1. Primeiro execute este SQL para criar a tabela
-- 2. Depois use o script Python import_curriculo_supabase.py para inserir os dados
-- ================================================

-- 1. Criar tabela de currículo MG
CREATE TABLE IF NOT EXISTS curriculo_mg (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    level       TEXT NOT NULL,   -- 'Ensino Médio' | 'Ensino Fundamental'
    grade       TEXT NOT NULL,   -- '1º Ano', '2º Ano', etc.
    grade_num   INTEGER NOT NULL, -- 1, 2, 3, 6, 7, 8, 9
    subject     TEXT NOT NULL,   -- 'Filosofia', 'Matemática', etc.
    regime      TEXT NOT NULL,   -- 'Bimestre' | 'Trimestre'
    period      INTEGER NOT NULL, -- 1, 2, 3, 4
    
    unidade_tematica        TEXT DEFAULT '',
    competencia             TEXT DEFAULT '',
    habilidade              TEXT DEFAULT '',
    habilidade_codes        TEXT[] DEFAULT '{}',
    objeto_conhecimento     TEXT DEFAULT '',
    descritores_saeb        TEXT DEFAULT '',
    orientacoes_pedagogicas TEXT DEFAULT '',
    chunk_text              TEXT DEFAULT '',
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Índices para busca rápida
CREATE INDEX IF NOT EXISTS idx_curriculo_mg_subject
    ON curriculo_mg(subject);

CREATE INDEX IF NOT EXISTS idx_curriculo_mg_grade
    ON curriculo_mg(grade_num, level);

CREATE INDEX IF NOT EXISTS idx_curriculo_mg_period
    ON curriculo_mg(period, regime);

CREATE INDEX IF NOT EXISTS idx_curriculo_mg_subject_grade
    ON curriculo_mg(subject, grade_num, level, period);

-- 3. Full-text search (português)
CREATE INDEX IF NOT EXISTS idx_curriculo_mg_fts
    ON curriculo_mg USING gin(
        to_tsvector('portuguese', 
            coalesce(unidade_tematica,'') || ' ' ||
            coalesce(objeto_conhecimento,'') || ' ' ||
            coalesce(habilidade,'')
        )
    );

-- 4. RLS — todos podem ler (conteúdo público)
ALTER TABLE curriculo_mg ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public read curriculo_mg" ON curriculo_mg;
CREATE POLICY "Public read curriculo_mg"
    ON curriculo_mg FOR SELECT TO authenticated
    USING (true);

-- Admins podem gerenciar
DROP POLICY IF EXISTS "Admin manage curriculo_mg" ON curriculo_mg;
CREATE POLICY "Admin manage curriculo_mg"
    ON curriculo_mg FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE id = auth.uid() AND (role = 'admin' OR is_admin = true)
        )
    );

-- 5. Função RPC para busca semântica simples (sem embeddings)
CREATE OR REPLACE FUNCTION search_curriculo(
    p_subject   TEXT DEFAULT NULL,
    p_grade_num INTEGER DEFAULT NULL,
    p_level     TEXT DEFAULT NULL,
    p_period    INTEGER DEFAULT NULL,
    p_query     TEXT DEFAULT NULL,
    p_limit     INTEGER DEFAULT 20
)
RETURNS SETOF curriculo_mg
LANGUAGE sql STABLE
AS $$
    SELECT *
    FROM curriculo_mg
    WHERE
        (p_subject   IS NULL OR subject    ILIKE '%' || p_subject   || '%')
        AND (p_grade_num IS NULL OR grade_num  = p_grade_num)
        AND (p_level     IS NULL OR level      ILIKE '%' || p_level     || '%')
        AND (p_period    IS NULL OR period     = p_period)
        AND (p_query     IS NULL OR to_tsvector('portuguese',
                coalesce(unidade_tematica,'') || ' ' ||
                coalesce(objeto_conhecimento,'') || ' ' ||
                coalesce(habilidade,'')
             ) @@ plainto_tsquery('portuguese', p_query))
    ORDER BY grade_num, period
    LIMIT p_limit;
$$;

-- 6. Estatísticas de verificação (rode após importar os dados)
-- SELECT level, grade, subject, COUNT(*) as blocos
-- FROM curriculo_mg
-- GROUP BY level, grade, subject
-- ORDER BY level DESC, grade, subject;
