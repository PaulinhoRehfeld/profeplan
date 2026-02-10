-- =====================================================
-- MIGRATION: Multi-School Support (TIPOS MISTOS)
-- Professor em Múltiplas Escolas
-- =====================================================
-- IMPORTANTE: 
-- - profiles.id = UUID
-- - schools.id = TEXT
-- =====================================================

-- 1. CRIAR TABELA DE RELACIONAMENTO (TIPOS MISTOS)
CREATE TABLE IF NOT EXISTS teacher_schools (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    teacher_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    school_id TEXT NOT NULL REFERENCES schools(id) ON DELETE CASCADE,
    
    -- Metadados do Vínculo
    role TEXT CHECK (role IN ('teacher', 'coordinator', 'principal')) DEFAULT 'teacher',
    disciplines TEXT[],
    
    -- Controle Temporal
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ended_at TIMESTAMP WITH TIME ZONE,
    
    -- Metadados
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Constraint: Previne duplicatas
    UNIQUE(teacher_id, school_id, ended_at)
);

-- 2. ÍNDICES
CREATE INDEX IF NOT EXISTS idx_teacher_schools_teacher ON teacher_schools(teacher_id);
CREATE INDEX IF NOT EXISTS idx_teacher_schools_school ON teacher_schools(school_id);
CREATE INDEX IF NOT EXISTS idx_teacher_schools_active ON teacher_schools(teacher_id, school_id) WHERE ended_at IS NULL;

-- 3. HABILITAR RLS
ALTER TABLE teacher_schools ENABLE ROW LEVEL SECURITY;

-- 4. POLÍTICAS RLS

-- 4.1. Professores veem seus vínculos
CREATE POLICY "Teachers can view own school links" 
ON teacher_schools
FOR SELECT 
USING (auth.uid() = teacher_id);

-- 4.2. Professores criam seus vínculos
CREATE POLICY "Teachers can create own school links" 
ON teacher_schools
FOR INSERT 
WITH CHECK (auth.uid() = teacher_id);

-- 4.3. Professores atualizam seus vínculos
CREATE POLICY "Teachers can update own school links" 
ON teacher_schools
FOR UPDATE 
USING (auth.uid() = teacher_id)
WITH CHECK (auth.uid() = teacher_id);

-- 4.4. Função helper para gestores
CREATE OR REPLACE FUNCTION get_user_managed_school_id()
RETURNS TEXT AS $$
    SELECT school_id 
    FROM profiles 
    WHERE id = auth.uid()
    AND role = 'manager'
    LIMIT 1;
$$ LANGUAGE SQL SECURITY DEFINER;

-- 4.5. Gestores veem professores da escola
CREATE POLICY "Managers can view their school teachers" 
ON teacher_schools
FOR SELECT 
USING (school_id = get_user_managed_school_id());

-- 4.6. Gestores adicionam professores
CREATE POLICY "Managers can add teachers to their school" 
ON teacher_schools
FOR INSERT 
WITH CHECK (school_id = get_user_managed_school_id());

-- =====================================================
-- 5. MIGRAÇÃO DE DADOS EXISTENTES
-- =====================================================

INSERT INTO teacher_schools (teacher_id, school_id, role, started_at)
SELECT 
    id AS teacher_id,
    school_id,
    'teacher' AS role,
    created_at AS started_at
FROM profiles
WHERE school_id IS NOT NULL
  AND school_id != ''
  AND role = 'teacher'
  AND NOT EXISTS (
    SELECT 1 FROM teacher_schools 
    WHERE teacher_id = profiles.id 
    AND school_id = profiles.school_id
  );

-- =====================================================
-- 6. ADICIONAR COLUNA ESCOLA ATIVA
-- =====================================================

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'profiles' 
        AND column_name = 'active_school_id'
    ) THEN
        ALTER TABLE profiles ADD COLUMN active_school_id TEXT REFERENCES schools(id);
        COMMENT ON COLUMN profiles.active_school_id IS 'Escola selecionada pelo professor (múltiplas escolas).';
    END IF;
END $$;

-- =====================================================
-- 7. FUNÇÃO: Obter Escolas de um Professor
-- =====================================================

CREATE OR REPLACE FUNCTION get_teacher_schools(teacher_uuid UUID)
RETURNS TABLE (
    school_id TEXT,
    school_name TEXT,
    school_inep TEXT,
    role TEXT,
    disciplines TEXT[],
    started_at TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.id AS school_id,
        s.name AS school_name,
        s.inep_code AS school_inep,
        ts.role,
        ts.disciplines,
        ts.started_at
    FROM teacher_schools ts
    JOIN schools s ON ts.school_id = s.id
    WHERE ts.teacher_id = teacher_uuid
      AND ts.ended_at IS NULL
    ORDER BY ts.started_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 8. VERIFICAÇÃO FINAL
-- =====================================================

-- Estrutura
SELECT 
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'teacher_schools'
ORDER BY ordinal_position;

-- Políticas
SELECT policyname, cmd
FROM pg_policies 
WHERE tablename = 'teacher_schools'
ORDER BY policyname;

-- Vínculos migrados
SELECT 
    COUNT(*) AS total_links,
    COUNT(DISTINCT teacher_id) AS unique_teachers
FROM teacher_schools;

-- =====================================================
-- ✅ SUCESSO: 
-- - teacher_id = UUID
-- - school_id = TEXT
-- - 5 políticas RLS ativas
-- =====================================================
