-- ==============================================================================
-- MIGRATION: UPDATE PDI TO TRIMESTER SYSTEM (MG)
-- ==============================================================================

BEGIN;

-- 1. Rename 'bimester' to 'period' to be more generic, or just change the constraint.
-- Let's stick to 'period' (1, 2, 3) to match "Trimestre".

ALTER TABLE pdi_teacher_evaluations 
DROP CONSTRAINT IF EXISTS pdi_teacher_evaluations_bimester_check;

ALTER TABLE pdi_teacher_evaluations
RENAME COLUMN bimester TO period;

ALTER TABLE pdi_teacher_evaluations
ADD CONSTRAINT pdi_teacher_evaluations_period_check CHECK (period IN (1, 2, 3));

-- Update the Unique Constraint
ALTER TABLE pdi_teacher_evaluations
DROP CONSTRAINT IF EXISTS pdi_teacher_evaluations_pdi_cycle_id_teacher_id_subject_bimester_key;

ALTER TABLE pdi_teacher_evaluations
ADD CONSTRAINT pdi_teacher_evaluations_unique_entry 
UNIQUE (pdi_cycle_id, teacher_id, subject, period);

COMMIT;
