-- ============================================================================
-- MIGRATION: Garantir estrutura da tabela schools
-- Date: 2024-01-24
-- Purpose: Criar ou atualizar tabela schools com colunas corretas
-- ============================================================================

-- Criar tabela se não existir
CREATE TABLE IF NOT EXISTS schools (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    city TEXT,
    sre TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Adicionar colunas se não existirem (para migração incremental)
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'schools' AND column_name = 'city'
    ) THEN
        ALTER TABLE schools ADD COLUMN city TEXT;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'schools' AND column_name = 'sre'
    ) THEN
        ALTER TABLE schools ADD COLUMN sre TEXT;
    END IF;
END $$;

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_schools_city ON schools(city);
CREATE INDEX IF NOT EXISTS idx_schools_sre ON schools(sre);
CREATE INDEX IF NOT EXISTS idx_schools_name ON schools USING GIN(to_tsvector('portuguese', name));

-- Verificação
SELECT 
    column_name, 
    data_type 
FROM information_schema.columns 
WHERE table_name = 'schools'
ORDER BY ordinal_position;
