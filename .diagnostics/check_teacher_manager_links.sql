-- DIAGNÓSTICO: Linkamento Professor-Manager
-- Execute no SQL Editor do Supabase

-- 1. Verificar gestores cadastrados
SELECT 
    id, 
    full_name, 
    email, 
    role, 
    school_id,
    inep_code
FROM profiles 
WHERE role = 'manager';

-- 2. Verificar professores cadastrados
SELECT 
    id, 
    full_name, 
    email, 
    role, 
    school_id,
    inep_code
FROM profiles 
WHERE role = 'teacher';

-- 3. Verificar vínculos ativos em teacher_schools
SELECT 
    ts.id,
    ts.teacher_id,
    ts.school_id,
    ts.started_at,
    ts.ended_at,
    p.full_name AS professor_nome,
    p.email AS professor_email,
    s.name AS escola_nome,
    s.inep_code AS escola_inep
FROM teacher_schools ts
LEFT JOIN profiles p ON ts.teacher_id = p.id
LEFT JOIN schools s ON ts.school_id = s.id
WHERE ts.ended_at IS NULL
ORDER BY ts.started_at DESC;

-- 4. Verificar se gestor e professor estão na mesma escola
SELECT 
    'GESTOR' as tipo,
    p.full_name,
    p.school_id,
    s.name as escola_nome
FROM profiles p
LEFT JOIN schools s ON p.school_id = s.id
WHERE p.role = 'manager'

UNION ALL

SELECT 
    'PROFESSOR (via school_id)' as tipo,
    p.full_name,
    p.school_id,
    s.name as escola_nome
FROM profiles p
LEFT JOIN schools s ON p.school_id = s.id
WHERE p.role = 'teacher'

UNION ALL

SELECT 
    'PROFESSOR (via teacher_schools)' as tipo,
    p.full_name,
    ts.school_id,
    s.name as escola_nome
FROM teacher_schools ts
JOIN profiles p ON ts.teacher_id = p.id
LEFT JOIN schools s ON ts.school_id = s.id
WHERE ts.ended_at IS NULL;
