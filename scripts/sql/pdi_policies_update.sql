-- POLICY UPDATE: Grant Full Access to Admins and Write Access to Authenticated Users
-- (For MVP/Dev speed, we are allowing authenticated users to CRUD. 
--  In production, we should restrict Teacher/Manager based on school_id)

-- 1. PDI DOCUMENTS
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON pdi_documents;
CREATE POLICY "Enable ALL access for authenticated users" ON pdi_documents
  FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);

-- 2. PDI TEACHER ENTRIES
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON pdi_teacher_entries;
CREATE POLICY "Enable ALL access for authenticated users" ON pdi_teacher_entries
  FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);

-- 3. STUDENTS
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON students;
CREATE POLICY "Enable ALL access for authenticated users" ON students
  FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);

-- 4. ENSURE RLS IS ON
ALTER TABLE pdi_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE pdi_teacher_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
