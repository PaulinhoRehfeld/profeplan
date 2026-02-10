-- ==============================================================================
-- SEED: INSERIR ESCOLA "PROFESSOR ANTÔNIO LAGO"
-- ==============================================================================

-- Inserir apenas se não existir (Upsert based on ID or Name)
INSERT INTO schools (id, name, city, sre, created_at)
VALUES 
(
    '31023299', -- ID INEP fornecido anteriormente pelo usuário
    'Escola Estadual Professor Antônio Lago',
    'Capelinha', 
    'Diamantina',
    NOW()
)
ON CONFLICT (id) DO UPDATE 
SET 
    name = EXCLUDED.name,
    city = EXCLUDED.city,
    sre = EXCLUDED.sre;

-- Inserir outras escolas de teste para garantir a busca
INSERT INTO schools (id, name, city, sre)
VALUES 
('11111111', 'Escola Estadual Tancredo Neves', 'Capelinha', 'Diamantina'),
('22222222', 'Escola Municipal Rosarinha', 'Capelinha', 'Diamantina')
ON CONFLICT (id) DO NOTHING;
