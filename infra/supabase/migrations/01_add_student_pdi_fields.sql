-- Migration: Add PDI/DUA fields to students table
-- Guard: só executa se a tabela students existir (seguro para rodar do zero)

DO $$ BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'students'
  ) THEN
    ALTER TABLE students
    ADD COLUMN IF NOT EXISTS needs_adaptation BOOLEAN DEFAULT false;

    ALTER TABLE students
    ADD COLUMN IF NOT EXISTS deficiencies TEXT[] DEFAULT '{}';

    ALTER TABLE students
    ADD COLUMN IF NOT EXISTS pedagogical_observations TEXT DEFAULT '';

    CREATE INDEX IF NOT EXISTS idx_students_needs_adaptation ON students(needs_adaptation);
  END IF;
END $$;
