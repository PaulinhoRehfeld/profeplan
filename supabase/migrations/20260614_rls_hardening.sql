-- =============================================================================
-- Migration: Row Level Security Hardening & Audit
-- Projeto: PROFEPLAN V4
-- Data: 2026-06-14
-- Target Tables: profiles, students, pdi_documents
-- =============================================================================

BEGIN;

-- =============================================================================
-- 1. LIMPEZA DE POLÍTICAS LEGADAS OU LARGAS (Evitar bypass de RLS)
-- =============================================================================

DROP POLICY IF EXISTS "Enable ALL access for authenticated users" ON public.students;
DROP POLICY IF EXISTS "Enable ALL access for authenticated users" ON public.pdi_documents;
DROP POLICY IF EXISTS "Enable ALL access for authenticated users" ON public.pdi_teacher_entries;
DROP POLICY IF EXISTS "profiles_select_authenticated" ON public.profiles;

-- =============================================================================
-- 2. FUNÇÕES AUXILIARES (SECURITY DEFINER para evitar recursão infinita RLS)
-- =============================================================================

-- Helper: Get My School ID safely (bypasses RLS)
CREATE OR REPLACE FUNCTION public.get_my_school_id_safe()
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_school_id text;
BEGIN
    SELECT school_id::text INTO v_school_id
    FROM public.profiles 
    WHERE id = auth.uid();
    
    RETURN v_school_id;
END;
$$;

ALTER FUNCTION public.get_my_school_id_safe() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.get_my_school_id_safe() TO authenticated;

-- Helper: Am I Manager/Admin? (bypasses RLS)
CREATE OR REPLACE FUNCTION public.is_manager_or_admin_safe()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles 
    WHERE id = auth.uid() 
      AND role IN ('school_manager', 'school_admin', 'manager', 'admin')
  );
END;
$$;

ALTER FUNCTION public.is_manager_or_admin_safe() OWNER TO postgres;
GRANT EXECUTE ON FUNCTION public.is_manager_or_admin_safe() TO authenticated;

-- =============================================================================
-- 3. ENDURECIMENTO DE RLS: Profiles (Leitura restrita ao próprio tenant/escola)
-- =============================================================================

-- Leitura: Usuário pode ler a si mesmo ou colegas da mesma escola (sem recursão)
DROP POLICY IF EXISTS "profiles_select" ON public.profiles;
CREATE POLICY "profiles_select" ON public.profiles
  FOR SELECT
  TO authenticated
  USING (
    id = auth.uid()
    OR school_id::text = public.get_my_school_id_safe()
  );

-- =============================================================================
-- 4. AUTOMAÇÃO DE VÍNCULO EM PDI: Trigger para Auto-Popular school_id
-- =============================================================================

-- Função para preencher automaticamente school_id em pdi_documents caso venha nulo no INSERT
CREATE OR REPLACE FUNCTION public.set_pdi_document_school_id()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.school_id IS NULL THEN
    SELECT school_id INTO NEW.school_id
    FROM public.school_students
    WHERE id = NEW.student_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_set_pdi_document_school_id ON public.pdi_documents;
CREATE TRIGGER trigger_set_pdi_document_school_id
BEFORE INSERT ON public.pdi_documents
FOR EACH ROW
EXECUTE FUNCTION public.set_pdi_document_school_id();

-- =============================================================================
-- 5. ENDURECIMENTO DE RLS: PDI Documents (Apenas proprietários da escola)
-- =============================================================================

-- Leitura: Apenas professores/gestores da mesma escola podem ler o PDI (usando helper)
DROP POLICY IF EXISTS "pdi_documents_select" ON public.pdi_documents;
CREATE POLICY "pdi_documents_select" ON public.pdi_documents
  FOR SELECT
  TO authenticated
  USING (
    school_id::text = public.get_my_school_id_safe()
  );

-- Escrita (INSERT): Permite criação se o professor/gestor é da mesma escola do aluno (otimizado)
DROP POLICY IF EXISTS "pdi_documents_insert" ON public.pdi_documents;
CREATE POLICY "pdi_documents_insert" ON public.pdi_documents
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.school_students ss
      WHERE ss.id = student_id
        AND ss.school_id::text = public.get_my_school_id_safe()
    )
  );

-- Escrita (UPDATE): Apenas gestores da escola do PDI ou professores da escola do PDI (usando helper)
DROP POLICY IF EXISTS "pdi_documents_update" ON public.pdi_documents;
CREATE POLICY "pdi_documents_update" ON public.pdi_documents
  FOR UPDATE
  TO authenticated
  USING (
    school_id::text = public.get_my_school_id_safe()
  )
  WITH CHECK (
    school_id::text = public.get_my_school_id_safe()
  );

-- Escrita (DELETE): Apenas gestores/supervisores ou administradores da escola (usando helper)
DROP POLICY IF EXISTS "pdi_documents_delete" ON public.pdi_documents;
CREATE POLICY "pdi_documents_delete" ON public.pdi_documents
  FOR DELETE
  TO authenticated
  USING (
    school_id::text = public.get_my_school_id_safe()
    AND public.is_manager_or_admin_safe()
  );

-- =============================================================================
-- 5. ATIVAÇÃO E GARANTIA DE RLS
-- =============================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pdi_documents ENABLE ROW LEVEL SECURITY;

COMMIT;
