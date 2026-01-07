-- Migration: Add PDI/DUA fields to students table

ALTER TABLE students 
ADD COLUMN IF NOT EXISTS needs_adaptation BOOLEAN DEFAULT false;

ALTER TABLE students 
ADD COLUMN IF NOT EXISTS deficiencies TEXT[] DEFAULT '{}';

ALTER TABLE students 
ADD COLUMN IF NOT EXISTS pedagogical_observations TEXT DEFAULT '';

-- Optional: Create an index for faster filtering of students needing adaptation
CREATE INDEX IF NOT EXISTS idx_students_needs_adaptation ON students(needs_adaptation);
