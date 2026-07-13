-- ==============================================================================
-- ⚠️ OBSOLETO — NÃO RODAR CONTRA PRODUÇÃO ⚠️
-- Arquivado em 2026-07-13. Seed para o schema abandonado de
-- step1_school_manager_model.sql (id UUID, colunas inep_code/municipality).
-- Incompatível com o schema real de produção (id TEXT = INEP 6 dígitos,
-- coluna "city"). Ver scripts/sql/README_SCHOOLS_SCHEMA.md.
-- ==============================================================================

INSERT INTO schools (id, inep_code, name, municipality)
VALUES 
(
    gen_random_uuid(), 
    '31023299', 
    'Escola Estadual Professor Antônio Lago',
    'Capelinha'
),
(
    gen_random_uuid(), 
    '11111111', 
    'Escola Estadual Tancredo Neves', 
    'Capelinha'
),
(
    gen_random_uuid(), 
    '22222222', 
    'Escola Municipal Rosarinha', 
    'Capelinha'
),
(
    gen_random_uuid(), 
    '33333333', 
    'Escola Estadual Domingos Pimenta', 
    'Capelinha'
)
ON CONFLICT (inep_code) DO NOTHING;

SELECT * FROM schools;
