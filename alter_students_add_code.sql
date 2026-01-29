-- Add student_code to students table safely
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'students' AND column_name = 'student_code') THEN
        ALTER TABLE students ADD COLUMN student_code TEXT;
    END IF;
END $$;
