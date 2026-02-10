-- RLS FIX (V5 - CORRECT COLUMN NAME)
-- Objetivo: Corrigir o nome da coluna para 'current_school_id' e aplicar regras de segurança finais.

SET search_path = public;

-- 1) Limpeza de Policies Antigas/Quebradas
DROP POLICY IF EXISTS "pdi_supervisors_manage" ON public.pdi_documents;
DROP POLICY IF EXISTS "pdi_teachers_view_edit" ON public.pdi_documents;
DROP POLICY IF EXISTS "Enable ALL access for authenticated users" ON public.pdi_documents;
DROP POLICY IF EXISTS "pdi_student_owner_access" ON public.pdi_documents;
DROP POLICY IF EXISTS "pdi_admin_policy" ON public.pdi_documents;

-- 2) ADMIN POLICY (Acesso Total)
CREATE POLICY "pdi_admin_policy" ON public.pdi_documents
  FOR ALL
  USING (public.is_admin_safe());

-- 3) MANAGERS POLICY (Gestores da Escola)
CREATE POLICY "pdi_supervisors_manage" ON public.pdi_documents
  FOR ALL
  TO authenticated
  USING (
    -- Cenário A: O documento tem o ID da escola gravado nele
    (
      pdi_documents.school_id IS NOT NULL
      AND pdi_documents.school_id::text = (
          SELECT school_id::text 
          FROM public.profiles 
          WHERE id = auth.uid()
      )
    )
    OR
    -- Cenário B: O documento é de um aluno, e o aluno é da escola do gestor
    (
      pdi_documents.student_id IS NOT NULL
      AND EXISTS (
        SELECT 1 
        FROM public.students s
        WHERE s.id::text = pdi_documents.student_id::text
          AND s.current_school_id::text = ( -- <--- CORREÇÃO AQUI
              SELECT school_id::text 
              FROM public.profiles 
              WHERE id = auth.uid()
          )
      )
    )
  );

-- 4) TEACHERS POLICY (Professores da Escola)
CREATE POLICY "pdi_teachers_view_edit" ON public.pdi_documents
  FOR ALL
  TO authenticated
  USING (
    -- Cenário A: Documento da escola do professor
    (
      pdi_documents.school_id IS NOT NULL
      AND pdi_documents.school_id::text = (
          SELECT school_id::text 
          FROM public.profiles 
          WHERE id = auth.uid() AND role = 'teacher'
      )
    )
    OR
    -- Cenário B: Documento de aluno da escola do professor
    (
      pdi_documents.student_id IS NOT NULL
      AND EXISTS (
        SELECT 1 
        FROM public.students s
        WHERE s.id::text = pdi_documents.student_id::text
          AND s.current_school_id::text = ( -- <--- CORREÇÃO AQUI
              SELECT school_id::text 
              FROM public.profiles 
              WHERE id = auth.uid() AND role = 'teacher'
          )
      )
    )
  )
  WITH CHECK (
    -- Mesma lógica para permitir salvar/editar
    (
      pdi_documents.school_id IS NOT NULL
      AND pdi_documents.school_id::text = (
          SELECT school_id::text 
          FROM public.profiles 
          WHERE id = auth.uid() AND role = 'teacher'
      )
    )
    OR
    (
      pdi_documents.student_id IS NOT NULL
      AND EXISTS (
        SELECT 1 
        FROM public.students s
        WHERE s.id::text = pdi_documents.student_id::text
          AND s.current_school_id::text = ( -- <--- CORREÇÃO AQUI
              SELECT school_id::text 
              FROM public.profiles 
              WHERE id = auth.uid() AND role = 'teacher'
          )
      )
    )
  );

-- 5) Garantir RLS Ativo
ALTER TABLE IF EXISTS public.pdi_documents ENABLE ROW LEVEL SECURITY;

-- 6) Verificação Final
SELECT tablename, policyname, cmd FROM pg_policies WHERE tablename = 'pdi_documents';

RESULTADO: 
| tablename     | policyname             | cmd |
| ------------- | ---------------------- | --- |
| pdi_documents | pdi_admin_policy       | ALL |
| pdi_documents | pdi_supervisors_manage | ALL |
| pdi_documents | pdi_teachers_view_edit | ALL |

ATUAR COMO: GIT SPECIALIST.

MISSÃO: FINALIZAR FIX DE RLS & LIMPEZA

Status: O script SQL V5 (com current_school_id) foi executado com sucesso no Supabase. O problema de segurança crítica foi resolvido.

TAREFAS:

Salvar o Script Oficial: Crie um arquivo scripts/sql/00_RLS_SECURITY_FIX_PROD.sql com o conteúdo exato do script V5.

Arquivar Legado: Mova todos os arquivos fix_rls_*.sql (as 13 versões) para scripts/archive/.

Git Commit: Crie o commit fix(db): correct RLS using current_school_id & cleanup scripts.
