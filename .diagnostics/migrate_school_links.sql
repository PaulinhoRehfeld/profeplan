-- ============================================================
-- SCRIPT DE MIGRAÇÃO: Correção de Vínculos Professor-Escola
-- Execute no SQL Editor do Supabase
-- ============================================================

-- 1. DIAGNÓSTICO: Ver situação atual
SELECT 'DIAGNÓSTICO: Professores e seus school_id' as info;

SELECT 
    id,
    full_name,
    email,
    role,
    school_id,
    active_school_id
FROM profiles 
WHERE role = 'teacher'
ORDER BY created_at DESC;

-- 2. DIAGNÓSTICO: Ver vínculos existentes em teacher_schools
SELECT 'DIAGNÓSTICO: Vínculos em teacher_schools' as info;

SELECT 
    ts.id,
    ts.teacher_id,
    ts.school_id,
    ts.started_at,
    ts.ended_at,
    p.full_name
FROM teacher_schools ts
LEFT JOIN profiles p ON ts.teacher_id = p.id
ORDER BY ts.created_at DESC;

-- 3. MIGRAÇÃO: Criar vínculos em teacher_schools baseado em school_id do profiles
-- (Para professores que têm school_id mas não têm vínculo na tabela teacher_schools)
SELECT 'MIGRAÇÃO: Criando vínculos faltantes' as info;

INSERT INTO teacher_schools (teacher_id, school_id, role, started_at)
SELECT 
    p.id as teacher_id,
    p.school_id as school_id,
    'teacher' as role,
    COALESCE(p.created_at, NOW()) as started_at
FROM profiles p
WHERE p.role = 'teacher'
  AND p.school_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM teacher_schools ts 
      WHERE ts.teacher_id = p.id 
        AND ts.school_id = p.school_id
        AND ts.ended_at IS NULL
  )
ON CONFLICT DO NOTHING;

-- 4. Verificar resultado
SELECT 'VERIFICAÇÃO: Novos vínculos criados' as info;

SELECT 
    ts.id,
    p.full_name,
    s.name as escola,
    s.inep_code,
    ts.started_at
FROM teacher_schools ts
JOIN profiles p ON ts.teacher_id = p.id
LEFT JOIN schools s ON ts.school_id = s.id
WHERE ts.ended_at IS NULL
ORDER BY ts.started_at DESC;

-- 5. OPCIONAL: Limpar vínculos órfãos (teacher_id que não existe em profiles)
-- SELECT 'LIMPEZA: Vínculos órfãos' as info;
-- DELETE FROM teacher_schools 
-- WHERE teacher_id NOT IN (SELECT id FROM profiles);
