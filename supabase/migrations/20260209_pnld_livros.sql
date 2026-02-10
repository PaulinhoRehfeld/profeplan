-- ================================================
-- PHASE 2: PNLD Metadata Table
-- ================================================
-- Tabela para armazenar metadados estruturados dos livros PNLD
-- Substitui busca ineficiente em pnld_livros_conteudo

CREATE TABLE IF NOT EXISTS pnld_livros (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Identificação do Livro
    titulo TEXT NOT NULL,
    isbn TEXT UNIQUE,
    
    -- Metadados Editoriais
    editora TEXT,
    colecao TEXT,
    
    -- Classificação Curricular
    disciplina TEXT NOT NULL,
    ano_serie TEXT,  -- "1º Ano EM", "6ª Série EF", etc.
    nivel_ensino TEXT, -- "Ensino Médio", "Ensino Fundamental"
    
    -- Estrutura do Livro
    volume TEXT,     -- "Único", "Volume 1", "Volume 2", etc.
    tipo TEXT DEFAULT 'Professor', -- "Professor", "Aluno"
    total_capitulos INT,
    total_paginas INT,
    
    -- Rastreabilidade
    arquivo_origem TEXT NOT NULL,  -- Nome do PDF original
    arquivo_json TEXT,  -- Caminho do JSON processado
    arquivo_md TEXT,    -- Caminho do MD de auditoria
    
    -- Qualidade
    taxa_extracao DECIMAL(5,2), -- % de fragmentos válidos
    fragmentos_totais INT,
    fragmentos_validos INT,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices para queries comuns
CREATE INDEX IF NOT EXISTS idx_pnld_livros_disciplina 
ON pnld_livros(disciplina);

CREATE INDEX IF NOT EXISTS idx_pnld_livros_editora 
ON pnld_livros(editora);

CREATE INDEX IF NOT EXISTS idx_pnld_livros_ano_serie 
ON pnld_livros(ano_serie);

CREATE INDEX IF NOT EXISTS idx_pnld_livros_nivel 
ON pnld_livros(nivel_ensino);

-- Trigger para atualizar updated_at
CREATE OR REPLACE FUNCTION update_pnld_livros_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_pnld_livros_updated_at
    BEFORE UPDATE ON pnld_livros
    FOR EACH ROW
    EXECUTE FUNCTION update_pnld_livros_updated_at();

-- Verificação
SELECT 'pnld_livros table created successfully' AS status;
