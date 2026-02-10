-- ============================================================
-- CORREÇÃO IMEDIATA: Vincular professor existente à escola 23299
-- Execute no SQL Editor do Supabase
-- ============================================================

-- 1. Ver TODOS os professores que existem
SELECT 
    id,
    full_name,
    email,
    role,
    masp,
    school_id,
    active_school_id,
    city
FROM profiles 
WHERE role = 'teacher';

-- 2. Ver TODOS os usuários (para encontrar o professor)
SELECT 
    id,
    full_name,
    email,
    role,
    school_id
FROM profiles;

-- 3. Ver vínculos atuais
SELECT * FROM teacher_schools;

-- 4. CORREÇÃO: Se o professor existir com ID diferente, atualizar o vínculo
-- Primeiro, encontre o ID correto do professor com MASP 1109372-1

-- Se você encontrar o professor com ID correto, execute:
-- UPDATE teacher_schools 
-- SET teacher_id = 'COLE_O_ID_CORRETO_AQUI'
-- WHERE id = '8ec4b1ba-1a7e-4211-b790-7a0deadc20a4';

-- 5. OU, se o professor não tiver vínculo, criar um novo:
-- INSERT INTO teacher_schools (teacher_id, school_id, role, started_at)
-- VALUES ('COLE_O_ID_DO_PROFESSOR', '23299', 'teacher', NOW());

-- 6. Verificar se o school_id é texto ou UUID
-- O problema pode ser que school_id deveria ser o INEP (23299) ou um UUID
SELECT id, inep_code, name FROM schools WHERE inep_code = '23299';
