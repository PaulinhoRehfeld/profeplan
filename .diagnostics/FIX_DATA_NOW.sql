-- ============================================================
-- CORREÇÃO IMEDIATA: Fixar Dados Corrompidos
-- Execute no SQL Editor do Supabase (LINHA POR LINHA)
-- ============================================================

-- PASSO 1: Diagnosticar situação atual
-- ============================================================

-- Ver a escola 23299
SELECT * FROM schools WHERE inep_code = '23299';
-- Copie o "id" (UUID) que aparecer aqui

-- Ver o professor com active_school_id = 31205893
SELECT id, full_name, email, role, school_id, active_school_id 
FROM profiles 
WHERE active_school_id = '31205893';
-- Copie o "id" do professor

-- Ver vínculos atuais desse professor
SELECT * FROM teacher_schools 
WHERE teacher_id = '7b48dcb1-0cc2-4385-92bb-74b011a480e7';


-- PASSO 2: CORREÇÃO - Deletar vínculo corrompido
-- ============================================================
-- O vínculo existente tem teacher_id que não existe mais
DELETE FROM teacher_schools 
WHERE id = '8ec4b1ba-1a7e-4211-b790-7a0deadc20a4';


-- PASSO 3: Obter o UUID correto da escola 23299
-- ============================================================
-- Execute esta query e COPIE o resultado do campo "id"
SELECT id, name, inep_code FROM schools WHERE inep_code = '23299';
-- Resultado esperado algo como: {
--   id: "abc123-...", 
--   name: "E.E. Antônio Lago",
--   inep_code: "23299"
-- }


-- PASSO 4: Criar vínculo CORRETO
-- ============================================================
-- SUBSTITUA os valores antes de executar:
-- - <UUID_DA_ESCOLA_23299>: ID que você copiou no PASSO 3
-- - <ID_DO_PROFESSOR>: ID do professor (7b48dcb1... ou o correto que você encontrou)

INSERT INTO teacher_schools (teacher_id, school_id, role, disciplines, started_at)
VALUES (
    '7b48dcb1-0cc2-4385-92bb-74b011a480e7',  -- ID do professor
    '<UUID_DA_ESCOLA_23299>',                 -- COLE AQUI o UUID da escola 23299
    'teacher',
    ARRAY['Matemática'],  -- Ajuste as disciplinas se necessário
    NOW()
);


-- PASSO 5: Verificar se criou corretamente
-- ============================================================
SELECT 
    ts.id,
    ts.teacher_id,
    ts.school_id,
    ts.started_at,
    ts.ended_at,
    p.full_name as professor_nome,
    s.name as escola_nome,
    s.inep_code
FROM teacher_schools ts
LEFT JOIN profiles p ON ts.teacher_id = p.id
LEFT JOIN schools s ON ts.school_id = s.id
WHERE ts.ended_at IS NULL
ORDER BY ts.created_at DESC;

-- Deve aparecer o vínculo novo com JOIN correto (nomes preenchidos)


-- PASSO 6: (OPCIONAL) Criar vínculo para a segunda escola também
-- ============================================================
-- Se o professor trabalha em 2 escolas, repita o INSERT para a outra escola

-- Primeiro, pegue o UUID da escola Domingos Pimenta (31205893)
SELECT id FROM schools WHERE inep_code = '31205893';

-- Depois, insira o vínculo
INSERT INTO teacher_schools (teacher_id, school_id, role, disciplines, started_at)
VALUES (
    '7b48dcb1-0cc2-4385-92bb-74b011a480e7',
    '<UUID_DA_ESCOLA_31205893>',  -- COLE aqui o UUID
    'teacher',
    ARRAY['Português'],
    NOW()
);


-- PASSO 7: Atualizar active_school_id no profiles
-- ============================================================
-- Definir a escola 23299 como escola ativa
UPDATE profiles 
SET active_school_id = '<UUID_DA_ESCOLA_23299>'  -- COLE o UUID da escola 23299
WHERE id = '7b48dcb1-0cc2-4385-92bb-74b011a480e7';


-- VERIFICAÇÃO FINAL
-- ============================================================
-- Deve mostrar 2 vínculos ativos (escola 23299 e 31205893)
SELECT 
    p.full_name,
    COUNT(ts.id) as total_escolas,
    STRING_AGG(s.name, ', ') as escolas_vinculadas
FROM teacher_schools ts
JOIN profiles p ON ts.teacher_id = p.id
LEFT JOIN schools s ON ts.school_id = s.id
WHERE ts.ended_at IS NULL
GROUP BY p.id, p.full_name;
