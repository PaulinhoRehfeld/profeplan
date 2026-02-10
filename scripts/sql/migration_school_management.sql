-- ==============================================================================
-- MIGRATION: SCHOOL MANAGEMENT SCHEMA
-- ==============================================================================
-- Creates tables for students, classes, and updates profiles for school management

-- STEP 1: Update profiles table for teachers
-- ==============================================================================
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS masp TEXT UNIQUE,  -- Código MASP do professor (Minas Gerais)
ADD COLUMN IF NOT EXISTS schools JSONB DEFAULT '[]'::jsonb;  -- Array de school_ids para múltiplas escolas

-- Create index for MASP lookups
CREATE INDEX IF NOT EXISTS idx_profiles_masp ON public.profiles(masp);


-- STEP 2: Create classes table
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.classes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_id UUID REFERENCES public.schools(id) ON DELETE CASCADE NOT NULL,
    name TEXT NOT NULL,  -- Ex: "8º A", "1º EM Técnico"
    year INTEGER NOT NULL,  -- Ano letivo: 2024, 2025...
    level TEXT,  -- Ex: "EF2", "EM", "TECNICO"
    teacher_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    student_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_classes_school ON public.classes(school_id);
CREATE INDEX IF NOT EXISTS idx_classes_teacher ON public.classes(teacher_id);
CREATE INDEX IF NOT EXISTS idx_classes_year ON public.classes(year);

-- RLS Policies
ALTER TABLE public.classes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Managers can view classes of their school"
ON public.classes FOR SELECT
USING (
    school_id IN (
        SELECT school_id FROM public.profiles WHERE id = auth.uid()
    )
);

CREATE POLICY "Managers can manage classes of their school"
ON public.classes FOR ALL
USING (
    school_id IN (
        SELECT school_id FROM public.profiles WHERE id = auth.uid() AND role = 'manager'
    )
);


-- STEP 3: Create students table
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.students (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_code TEXT UNIQUE NOT NULL,  -- Código oficial do aluno (INEP ou similar)
    name TEXT NOT NULL,
    birth_date DATE,
    serie TEXT,  -- Ex: "8º Ano EF", "1º Ano EM"
    current_school_id UUID REFERENCES public.schools(id) ON DELETE SET NULL,
    current_class_id UUID REFERENCES public.classes(id) ON DELETE SET NULL,
    special_needs TEXT,  -- Necessidades especiais (PDI/DUA)
    has_pdi BOOLEAN DEFAULT false,
    transfer_history JSONB DEFAULT '[]'::jsonb,  -- Histórico de transferências
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_students_code ON public.students(student_code);
CREATE INDEX IF NOT EXISTS idx_students_school ON public.students(current_school_id);
CREATE INDEX IF NOT EXISTS idx_students_class ON public.students(current_class_id);
CREATE INDEX IF NOT EXISTS idx_students_name ON public.students(name);

-- RLS Policies
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Managers can view students of their school"
ON public.students FOR SELECT
USING (
    current_school_id IN (
        SELECT school_id FROM public.profiles WHERE id = auth.uid()
    )
);

CREATE POLICY "Managers can manage students of their school"
ON public.students FOR ALL
USING (
    current_school_id IN (
        SELECT school_id FROM public.profiles WHERE id = auth.uid() AND role = 'manager'
    )
);


-- STEP 4: Create trigger to update student count in classes
-- ==============================================================================
CREATE OR REPLACE FUNCTION update_class_student_count()
RETURNS TRIGGER AS $$
BEGIN
    -- Update old class count
    IF OLD.current_class_id IS NOT NULL THEN
        UPDATE classes 
        SET student_count = (
            SELECT COUNT(*) FROM students WHERE current_class_id = OLD.current_class_id
        )
        WHERE id = OLD.current_class_id;
    END IF;
    
    -- Update new class count
    IF NEW.current_class_id IS NOT NULL THEN
        UPDATE classes 
        SET student_count = (
            SELECT COUNT(*) FROM students WHERE current_class_id = NEW.current_class_id
        )
        WHERE id = NEW.current_class_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_student_class_change
AFTER INSERT OR UPDATE OF current_class_id ON public.students
FOR EACH ROW
EXECUTE FUNCTION update_class_student_count();


-- STEP 5: Verification
-- ==============================================================================
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name IN ('students', 'classes', 'profiles')
ORDER BY table_name, ordinal_position;
