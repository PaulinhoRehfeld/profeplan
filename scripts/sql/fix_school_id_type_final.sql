-- ==============================================================================
-- FIX DEFINITIVO: Corrigir tipos de ID da Escola (UUID -> TEXT)
-- Utiliza SQL Dinâmico para remover TODAS as políticas que possam bloquear a mudança
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
        WHERE tablename IN ('students', 'classes', 'profiles', 'schools') 
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', r.policyname, r.tablename);
        RAISE NOTICE 'Política removida: % na tabela %', r.policyname, r.tablename;
    END LOOP;
END $$;

-- 2. Alterar tipos das colunas (Agora sem impedimentos)
-- ==============================================================================

-- Tabela students
ALTER TABLE public.students DROP CONSTRAINT IF EXISTS students_current_school_id_fkey;
ALTER TABLE public.students ALTER COLUMN current_school_id TYPE TEXT;

-- Tabela classes
ALTER TABLE public.classes DROP CONSTRAINT IF EXISTS classes_school_id_fkey;
ALTER TABLE public.classes ALTER COLUMN school_id TYPE TEXT;

-- Tabela profiles (garantir compatibilidade)
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_school_id_fkey;
ALTER TABLE public.profiles ALTER COLUMN school_id TYPE TEXT;

-- 3. Recriar Políticas de Segurança (Padronizadas)
-- ==============================================================================

-- 3.1 STUDENTS
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

-- 3.3 PROFILES (Básico para garantir funcionamento)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING (
    id = auth.uid()
);

-- Admins têm acesso total (Update conforme necessário)
CREATE POLICY "Admins full access" ON public.profiles FOR ALL USING (
    (SELECT is_admin FROM public.profiles WHERE id = auth.uid()) = true
);

-- Colaboradores da mesma escola podem se ver
CREATE POLICY "School Colleagues View" ON public.profiles FOR SELECT USING (
    school_id = (SELECT school_id FROM public.profiles WHERE id = auth.uid())
);

-- Correção concluída com sucesso!
