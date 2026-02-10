-- ==============================================================================
-- FIX DEFINITIVO V2: Corrigir tipos de ID da Escola (UUID -> TEXT)
-- Utiliza SQL Dinâmico para remover TODAS as políticas que possam bloquear a mudança
-- Inclui TODAS as tabelas afetadas (students, classes, school_students, etc)
-- ==============================================================================

DO $$
DECLARE
    r RECORD;
BEGIN
    RAISE NOTICE 'Iniciando limpeza de políticas de segurança...';

    -- 1. Loop para remover TODAS as políticas das tabelas afetadas
    FOR r IN 
        SELECT policyname, tablename 
        FROM pg_policies 
        WHERE tablename IN ('students', 'classes', 'profiles', 'schools', 'pending_teachers') 
           OR tablename LIKE 'pdi_%' 
           OR tablename LIKE 'school_%' 
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', r.policyname, r.tablename);
        RAISE NOTICE 'Política removida: % na tabela %', r.policyname, r.tablename;
    END LOOP;
END $$;

-- 2. Alterar tipos das colunas (Agora sem impedimentos)
-- ==============================================================================

-- Remover FKs temporariamente
ALTER TABLE public.students DROP CONSTRAINT IF EXISTS students_current_school_id_fkey;
ALTER TABLE public.classes DROP CONSTRAINT IF EXISTS classes_school_id_fkey;
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_school_id_fkey;
ALTER TABLE public.pdi_documents DROP CONSTRAINT IF EXISTS pdi_documents_school_id_fkey;
ALTER TABLE public.pending_teachers DROP CONSTRAINT IF EXISTS pending_teachers_school_id_fkey;

-- Handle conditional tables (school_students)
DO $$ BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'school_students_school_id_fkey') THEN
        ALTER TABLE public.school_students DROP CONSTRAINT school_students_school_id_fkey;
    END IF;
END $$;

-- Alterar para TEXT universalmente
ALTER TABLE public.students ALTER COLUMN current_school_id TYPE TEXT;
ALTER TABLE public.classes ALTER COLUMN school_id TYPE TEXT;
ALTER TABLE public.profiles ALTER COLUMN school_id TYPE TEXT;
ALTER TABLE public.pdi_documents ALTER COLUMN school_id TYPE TEXT;
ALTER TABLE public.pending_teachers ALTER COLUMN school_id TYPE TEXT;

DO $$ BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'school_students' AND column_name = 'school_id') THEN
        ALTER TABLE public.school_students ALTER COLUMN school_id TYPE TEXT;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pdi_records' AND column_name = 'school_id') THEN
        ALTER TABLE public.pdi_records DROP CONSTRAINT IF EXISTS pdi_records_school_id_fkey;
        ALTER TABLE public.pdi_records ALTER COLUMN school_id TYPE TEXT;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pdi_cycles' AND column_name = 'school_id') THEN
        ALTER TABLE public.pdi_cycles DROP CONSTRAINT IF EXISTS pdi_cycles_school_id_fkey;
        ALTER TABLE public.pdi_cycles ALTER COLUMN school_id TYPE TEXT;
    END IF;
END $$;

-- 3. Recriar Políticas de Segurança (Padronizadas)
-- ==============================================================================

-- 3.1 STUDENTS (Tabela correta usada pelo dashboard agora)
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Teachers View" ON public.students FOR SELECT USING (
    current_school_id IN (SELECT school_id::text FROM public.profiles WHERE id = auth.uid() AND role = 'teacher')
);

CREATE POLICY "Managers View" ON public.students FOR SELECT USING (
    current_school_id IN (SELECT school_id::text FROM public.profiles WHERE id = auth.uid())
);

CREATE POLICY "Managers Manage" ON public.students FOR ALL USING (
    current_school_id IN (SELECT school_id::text FROM public.profiles WHERE id = auth.uid() AND role = 'manager')
);

-- 3.2 CLASSES
ALTER TABLE public.classes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Managers View Classes" ON public.classes FOR SELECT USING (
    school_id IN (SELECT school_id::text FROM public.profiles WHERE id = auth.uid())
);

CREATE POLICY "Managers Manage Classes" ON public.classes FOR ALL USING (
    school_id IN (SELECT school_id::text FROM public.profiles WHERE id = auth.uid() AND role = 'manager')
);

-- 3.3 SCHOOL STUDENTS (Tabela legado/oficial, manter compatibilidade)
DO $$ BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'school_students') THEN
        ALTER TABLE public.school_students ENABLE ROW LEVEL SECURITY;
        
        CREATE POLICY "School Manager can manage students" ON public.school_students FOR ALL TO authenticated
        USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'manager' AND profiles.school_id = school_students.school_id));
        
        CREATE POLICY "Users can view students from their school" ON public.school_students FOR SELECT TO authenticated
        USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND profiles.school_id = school_students.school_id));
    END IF;
END $$;

-- 3.4 PROFILES
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING (
    id = auth.uid()
);

-- Admins têm acesso total
CREATE POLICY "Admins full access" ON public.profiles FOR ALL USING (
    (SELECT is_admin FROM public.profiles WHERE id = auth.uid()) = true
);

-- Colaboradores da mesma escola podem se ver
CREATE POLICY "School Colleagues View" ON public.profiles FOR SELECT USING (
    school_id = (SELECT school_id FROM public.profiles WHERE id = auth.uid())
);

-- Sucesso
-- Correção concluída com sucesso!
