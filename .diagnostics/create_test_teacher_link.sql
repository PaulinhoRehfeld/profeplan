-- CRIAR VÍNCULO DE TESTE: Professor → Escola do Gestor
-- Execute no SQL Editor do Supabase

-- 1. Verificar se há professores cadastrados no sistema
SELECT id, full_name, email, role 
FROM profiles 
WHERE role = 'teacher'
LIMIT 5;

-- 2. Se houver professores, pegue o ID de um deles e execute:
-- (SUBSTITUA 'COLE_AQUI_O_ID_DO_PROFESSOR' pelo ID real)

INSERT INTO teacher_schools (teacher_id, school_id, role, disciplines, started_at)
VALUES (
    'COLE_AQUI_O_ID_DO_PROFESSOR', -- ID do professor
    '23299', -- ID da escola do gestor
    'teacher', -- Role no vínculo
    ARRAY['Matemática', 'Física'], -- Disciplinas (exemplo)
    NOW() -- Data de início
);

-- 3. Se NÃO houver professores, primeiro crie um professor de teste:
-- (Execute este bloco ANTES do INSERT acima)

-- Criar usuário de teste no Supabase Auth primeiro (via Supabase Dashboard > Authentication > Add User)
-- Email: professor.teste@educacao.mg.gov.br
-- Password: (defina uma senha)

-- Depois, crie o perfil:
INSERT INTO profiles (id, email, full_name, role, school_id, inep_code)
VALUES (
    'COLE_AQUI_O_USER_ID_DO_AUTH', -- ID do usuário criado no Auth
    'professor.teste@educacao.mg.gov.br',
    'Professor Teste',
    'teacher',
    '23299', -- Mesma escola do gestor
    '23299' -- INEP
);

-- Agora crie o vínculo (use o ID do perfil criado acima):
INSERT INTO teacher_schools (teacher_id, school_id, role, disciplines)
VALUES (
    'COLE_AQUI_O_USER_ID_DO_AUTH',
    '23299',
    'teacher',
    ARRAY['Matemática']
);
