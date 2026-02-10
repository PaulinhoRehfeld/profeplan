-- PDI FIX MIGRATION SCRIPT
-- Run this entire script to fix the database state.

-- 1. Ensure UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Fix 'students' table
CREATE TABLE IF NOT EXISTS students (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  school_id UUID,
  state_unique_id TEXT UNIQUE,
  name TEXT NOT NULL,
  current_class_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT students_state_id_key UNIQUE (state_unique_id)
);

-- 3. Fix 'pdi_documents' table (Handle legacy existence)
CREATE TABLE IF NOT EXISTS pdi_documents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL, -- references added later if needed
  year INT NOT NULL DEFAULT date_part('year', CURRENT_DATE),
  status TEXT CHECK (status IN ('draft', 'active', 'archived')) DEFAULT 'draft',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add JSONB column safely if it didn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='pdi_documents' AND column_name='content_data') THEN
        ALTER TABLE pdi_documents ADD COLUMN content_data JSONB DEFAULT '{}'::jsonb;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='pdi_documents' AND column_name='final_report') THEN
        ALTER TABLE pdi_documents ADD COLUMN final_report TEXT;
    END IF;

    -- Ensure FK exists (optional check, but good practice)
    -- ALTER TABLE pdi_documents DROP CONSTRAINT IF EXISTS pdi_documents_student_id_fkey;
    -- ALTER TABLE pdi_documents ADD CONSTRAINT pdi_documents_student_id_fkey FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;
END $$;

-- 4. Create 'pdi_teacher_entries' (If it failed before)
CREATE TABLE IF NOT EXISTS pdi_teacher_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pdi_document_id UUID NOT NULL REFERENCES pdi_documents(id) ON DELETE CASCADE,
  teacher_id UUID NOT NULL, 
  bimester INT CHECK (bimester BETWEEN 1 AND 4),
  subject TEXT NOT NULL,
  autonomy_level TEXT,
  observations TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT unique_teacher_entry UNIQUE (pdi_document_id, teacher_id, subject, bimester)
);

-- 5. APPLY POLICIES (FULL WRITE ACCESS for Authenticated)
ALTER TABLE pdi_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE pdi_teacher_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE students ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Enable ALL access for authenticated users" ON pdi_documents;
CREATE POLICY "Enable ALL access for authenticated users" ON pdi_documents FOR ALL TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Enable ALL access for authenticated users" ON pdi_teacher_entries;
CREATE POLICY "Enable ALL access for authenticated users" ON pdi_teacher_entries FOR ALL TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Enable ALL access for authenticated users" ON students;
CREATE POLICY "Enable ALL access for authenticated users" ON students FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- 6. INDEXES
CREATE INDEX IF NOT EXISTS idx_pdi_content ON pdi_documents USING gin (content_data);
