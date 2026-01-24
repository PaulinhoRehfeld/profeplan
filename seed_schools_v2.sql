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
