-- Migration: Fix pdi_documents RLS policy that referenced non-existent table school_students
-- A migration 20260317_align_pdi_with_students.sql já corrigiu a FK para apontar para students(id).
-- Esta migration corrige a policy de SELECT dos professores que ainda usa school_students.

DROP POLICY IF EXISTS "Teachers view PDI documents" ON pdi_documents;

CREATE POLICY "Teachers view PDI documents" ON pdi_documents
FOR SELECT TO authenticated
USING (
    -- Professor pode ver PDIs de alunos da mesma escola
    -- students não tem school_id direto: acessa via classes.school_id
    -- Todos os lados de comparação são castados para TEXT para evitar erros uuid=text
    student_id::TEXT IN (
        SELECT s.id::TEXT
        FROM public.students s
        INNER JOIN public.classes c ON c.id::TEXT = s.class_id::TEXT
        WHERE c.school_id::TEXT IN (
            SELECT school_id::TEXT FROM public.profiles WHERE id = auth.uid()
        )
    )
    OR
    -- Ou se o PDI pertence à mesma escola diretamente
    school_id::TEXT IN (
        SELECT school_id::TEXT FROM public.profiles WHERE id = auth.uid()
    )
);
