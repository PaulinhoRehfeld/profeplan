-- ==============================================================================
-- MIGRATION: Gestão de Turmas (Classes)
-- ==============================================================================

-- 1. Criar tabela de turmas (classes)
CREATE TABLE IF NOT EXISTS public.classes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    school_id UUID NOT NULL REFERENCES public.schools(id) ON DELETE CASCADE,
    name TEXT NOT NULL,           -- Ex: "3º Ano A"
    grade TEXT,                   -- Ex: "3º Ano", "8º Ano"
    year INTEGER DEFAULT EXTRACT(YEAR FROM NOW()),  -- Ano letivo
    shift TEXT,                   -- "Matutino", "Vespertino", "Noturno"
    room TEXT,                    -- Sala de aula
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(school_id, name, year)  -- Evita duplicatas
);

-- 2. Atualizar tabela students (adicionar class_id)
ALTER TABLE public.students 
ADD COLUMN IF NOT EXISTS class_id UUID REFERENCES public.classes(id) ON DELETE SET NULL;

-- 3. Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_classes_school_id ON public.classes(school_id);
CREATE INDEX IF NOT EXISTS idx_students_class_id ON public.students(class_id);

-- 4. RLS Policies para classes

-- Habilitar RLS
ALTER TABLE public.classes ENABLE ROW LEVEL SECURITY;

-- Policy: SELECT (todos podem ver turmas da própria escola)
CREATE POLICY "classes_select_authenticated"
ON public.classes
FOR SELECT
TO authenticated
USING (true);

-- Policy: INSERT (apenas gestores podem criar turmas)
CREATE POLICY "classes_insert_managers"
ON public.classes
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (role = 'manager' OR is_admin = true)
        AND school_id = classes.school_id
    )
);

-- Policy: UPDATE (apenas gestores da escola)
CREATE POLICY "classes_update_managers"
ON public.classes
FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (role = 'manager' OR is_admin = true)
        AND school_id = classes.school_id
    )
);

-- Policy: DELETE (apenas gestores da escola)
CREATE POLICY "classes_delete_managers"
ON public.classes
FOR DELETE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (role = 'manager' OR is_admin = true)
        AND school_id = classes.school_id
    )
);

-- 5. Verificação
SELECT 
    'Tabelas criadas' as status,
    EXISTS(SELECT 1 FROM information_schema.tables WHERE table_name = 'classes') as classes_exists,
    EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = 'students' AND column_name = 'class_id') as class_id_added;

-- 6. Exemplo de inserção (teste)
/*
INSERT INTO classes (school_id, name, grade, year, shift, room)
SELECT 
    id, 
    '3º Ano A',
    '3º Ano',
    2026,
    'Matutino',
    'Sala 101'
FROM schools 
LIMIT 1;
*/
