-- =============================================================================
-- Migration: Fix RLS policies for classes + students tables
-- Projeto: PROFEPLAN V4
-- Data: 2026-06-19
-- Problema: "new row violates row-level security policy for table 'classes'"
-- Causa: 20260614_rls_hardening.sql dropou "Enable ALL access" de students
--        sem recriar. E classes nunca teve políticas nos migrations de prod.
-- =============================================================================

BEGIN;

-- =========================================
-- CLASSES
-- =========================================

-- 1. INSERT: Professor pode criar suas próprias turmas
DROP POLICY IF EXISTS "classes_insert_teacher" ON public.classes;
CREATE POLICY "classes_insert_teacher"
ON public.classes
FOR INSERT
TO authenticated
WITH CHECK (
    user_id = auth.uid()
);

-- 2. UPDATE: Professor pode editar apenas suas turmas
DROP POLICY IF EXISTS "classes_update_teacher" ON public.classes;
CREATE POLICY "classes_update_teacher"
ON public.classes
FOR UPDATE
TO authenticated
USING (
    user_id = auth.uid()
)
WITH CHECK (
    user_id = auth.uid()
);

-- 3. DELETE: Professor pode excluir apenas suas turmas
DROP POLICY IF EXISTS "classes_delete_teacher" ON public.classes;
CREATE POLICY "classes_delete_teacher"
ON public.classes
FOR DELETE
TO authenticated
USING (
    user_id = auth.uid()
);

-- 4. SELECT: Professor vê suas turmas; Admin/Manager vê todas da escola
DROP POLICY IF EXISTS "classes_select" ON public.classes;
CREATE POLICY "classes_select"
ON public.classes
FOR SELECT
TO authenticated
USING (
    user_id = auth.uid()
    OR (public.is_manager_or_admin_safe() AND school_id::text = public.get_my_school_id_safe())
);

-- =========================================
-- STUDENTS (foi dropado pelo RLS hardening)
-- =========================================

-- INSERT: Professor pode adicionar alunos em turmas que ele criou
DROP POLICY IF EXISTS "students_insert_teacher" ON public.students;
CREATE POLICY "students_insert_teacher"
ON public.students
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.classes c
        WHERE c.id = class_id
          AND c.user_id = auth.uid()
    )
);

-- UPDATE: Professor pode editar alunos de suas turmas
DROP POLICY IF EXISTS "students_update_teacher" ON public.students;
CREATE POLICY "students_update_teacher"
ON public.students
FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.classes c
        WHERE c.id = class_id
          AND c.user_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.classes c
        WHERE c.id = class_id
          AND c.user_id = auth.uid()
    )
);

-- DELETE: Professor pode remover alunos de suas turmas
DROP POLICY IF EXISTS "students_delete_teacher" ON public.students;
CREATE POLICY "students_delete_teacher"
ON public.students
FOR DELETE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.classes c
        WHERE c.id = class_id
          AND c.user_id = auth.uid()
    )
);

-- SELECT: Professor vê alunos de suas turmas; Admin/Manager vê da escola
DROP POLICY IF EXISTS "students_select" ON public.students;
CREATE POLICY "students_select"
ON public.students
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.classes c
        WHERE c.id = students.class_id
          AND c.user_id = auth.uid()
    )
    OR EXISTS (
        SELECT 1 FROM public.classes c
        WHERE c.id = students.class_id
          AND public.is_manager_or_admin_safe()
          AND c.school_id::text = public.get_my_school_id_safe()
    )
);

COMMIT;
