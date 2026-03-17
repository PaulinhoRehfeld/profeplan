-- ==============================================================================
-- MIGRATION: Align PDI documents with students table (PROFEPLAN Option A)
-- Date: 2026-03-17
-- Goal:
--   1) Garantir que pdi_documents.student_id referencie public.students(id)
--   2) Adicionar coluna year para alinhar com o código TypeScript existente
--   3) Manter compatibilidade com a coluna period já existente
-- ==============================================================================

-- 1. Ajustar FK de student_id para apontar para public.students(id)
ALTER TABLE public.pdi_documents
DROP CONSTRAINT IF EXISTS pdi_documents_student_id_fkey;

ALTER TABLE public.pdi_documents
ADD CONSTRAINT pdi_documents_student_id_fkey
FOREIGN KEY (student_id) REFERENCES public.students(id)
ON DELETE CASCADE;

-- 2. Adicionar coluna year (quando ainda não existir)
ALTER TABLE public.pdi_documents
ADD COLUMN IF NOT EXISTS year INT;

-- 3. (Opcional, best-effort) Preencher year a partir de period quando possível
-- Tenta extrair o último número de period como ano (ex.: "1º Bimestre 2026")
UPDATE public.pdi_documents
SET year = NULLIF(regexp_replace(period, '.*(20[0-9]{2}).*', '\1'), '')::INT
WHERE year IS NULL
  AND period IS NOT NULL
  AND period ~ '20[0-9]{2}';

-- Para linhas sem period ou sem ano detectável, manter year NULL;
-- o código do backend deve tratar fallback para o ano corrente ao criar novos registros.

