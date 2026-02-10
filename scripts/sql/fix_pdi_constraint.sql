-- FIX: Update PDI Status Constraint to be robust
-- Purpose: Resolve "violates check constraint" errors by explicitly setting the allowed values.

DO $$
BEGIN
    -- 1. Drop existing constraint if it exists
    ALTER TABLE pdi_documents DROP CONSTRAINT IF EXISTS pdi_documents_status_check;

    -- 2. Add the Correct Constraint with all necessary statuses
    ALTER TABLE pdi_documents 
    ADD CONSTRAINT pdi_documents_status_check 
    CHECK (status IN ('draft', 'active', 'archived', 'em_andamento', 'finalizado', 'concluido'));

END $$;
