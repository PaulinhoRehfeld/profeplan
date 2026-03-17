-- ==============================================================================
-- MIGRATION: Allow Teachers to Create and Manage Their Own Students (Fix)
-- Date: 2026-03-11
-- Purpose: Fixes RLS violation (403) where only admins/managers could add students
-- ==============================================================================

-- Remove políticas antigas caso existam
DROP POLICY IF EXISTS "students_insert_teacher" ON public.students;
DROP POLICY IF EXISTS "students_update_teacher" ON public.students;
DROP POLICY IF EXISTS "students_delete_teacher" ON public.students;
DROP POLICY IF EXISTS "students_select_teacher" ON public.students;
DROP POLICY IF EXISTS "students_insert_teacher_v2" ON public.students;
DROP POLICY IF EXISTS "students_update_teacher_v2" ON public.students;
DROP POLICY IF EXISTS "students_delete_teacher_v2" ON public.students;
DROP POLICY IF EXISTS "students_select_teacher_v2" ON public.students;

-- 1. Permite Inserir alunos na própria turma
CREATE POLICY "students_insert_teacher_v3"
ON public.students
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.classes
        WHERE id = class_id AND user_id::text = auth.uid()::text
    )
);

-- 2. Permite Atualizar
CREATE POLICY "students_update_teacher_v3"
ON public.students
FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.classes
        WHERE id = class_id AND user_id::text = auth.uid()::text
    )
);

-- 3. Permite Deletar
CREATE POLICY "students_delete_teacher_v3"
ON public.students
FOR DELETE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.classes
        WHERE id = class_id AND user_id::text = auth.uid()::text
    )
);

-- 4. Permite Visualizar
CREATE POLICY "students_select_teacher_v3"
ON public.students
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.classes
        WHERE id = class_id AND user_id::text = auth.uid()::text
    )
);
