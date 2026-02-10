-- ==============================================================================
-- 🛡️ STABILIZE SCHOOL SCHEMA & FIX DATA (REALITY CHECKED)
-- ==============================================================================
-- This script respects the ACTUAL schema found in master_schema_dev.sql:
-- 1. `students` table DOES NOT have school_id. It links to `classes`.
-- 2. `classes` table SHOULD have school_id (we ensure it does).
-- 3. `school_students` table (Official) HAS school_id.
-- 4. All IDs are standardized to TEXT (INEP).

BEGIN;

-- ==============================================================================
-- STEP 1: DROP BLOCKING POLICIES (We will recreate them correctly)
-- ==============================================================================

-- Drop Policies on ALL tables potentially referencing school_id
DROP POLICY IF EXISTS "Supervisors manage PDI documents" ON pdi_documents;
DROP POLICY IF EXISTS "Teachers view PDI documents" ON pdi_documents;
DROP POLICY IF EXISTS "Teachers update Block 10 only" ON pdi_documents;

DROP POLICY IF EXISTS "School Admin can view all pdi records" ON pdi_records;
DROP POLICY IF EXISTS "School Members View PDI" ON pdi_records;
DROP POLICY IF EXISTS "Teachers Insert PDI" ON pdi_records;
DROP POLICY IF EXISTS "pdi_records_select_school" ON pdi_records;
DROP POLICY IF EXISTS "Teachers can view pdi records of their school" ON pdi_records;
DROP POLICY IF EXISTS "Teachers can insert pdi records" ON pdi_records;

DROP POLICY IF EXISTS "pending_teachers_select_managers" ON public.pending_teachers;
DROP POLICY IF EXISTS "pending_teachers_insert_managers" ON public.pending_teachers;
DROP POLICY IF EXISTS "pending_teachers_update_managers" ON public.pending_teachers;
DROP POLICY IF EXISTS "pending_teachers_delete_managers" ON public.pending_teachers;

DROP POLICY IF EXISTS "classes_select_school" ON public.classes;
DROP POLICY IF EXISTS "classes_insert_managers" ON public.classes;
DROP POLICY IF EXISTS "classes_update_managers" ON public.classes;
DROP POLICY IF EXISTS "classes_delete_managers" ON public.classes;
DROP POLICY IF EXISTS "classes_manage_school" ON public.classes;

-- STUDENTS: Provide a clean slate for policies
DROP POLICY IF EXISTS "students_select_school" ON public.students;
DROP POLICY IF EXISTS "students_insert_managers" ON public.students;
DROP POLICY IF EXISTS "students_update_managers" ON public.students;
DROP POLICY IF EXISTS "students_delete_managers" ON public.students;
DROP POLICY IF EXISTS "start_students_school" ON public.students;
DROP POLICY IF EXISTS "School Manager can manage students" ON public.students; 
DROP POLICY IF EXISTS "students_manage_school" ON public.students;
DROP POLICY IF EXISTS "Users manage own students" ON public.students;
DROP POLICY IF EXISTS "Users view own students" ON public.students;

DROP POLICY IF EXISTS "Users can view students from their school" ON public.school_students;
DROP POLICY IF EXISTS "School Members View Students" ON public.school_students;
DROP POLICY IF EXISTS "School Manager can manage students" ON public.school_students;
DROP POLICY IF EXISTS "Managers Manage Students" ON public.school_students;
DROP POLICY IF EXISTS "Teachers Insert Students" ON public.school_students;
DROP POLICY IF EXISTS "Teachers can insert students to their school" ON public.school_students;

DROP POLICY IF EXISTS "Managers can view school colleagues" ON public.profiles;

-- Drop Foreign Keys (to allow type change)
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_school_id_fkey;
ALTER TABLE public.pending_teachers DROP CONSTRAINT IF EXISTS pending_teachers_school_id_fkey;
ALTER TABLE public.classes DROP CONSTRAINT IF EXISTS classes_school_id_fkey;
ALTER TABLE public.pdi_documents DROP CONSTRAINT IF EXISTS pdi_documents_school_id_fkey;

-- Handle conditional tables safely
DO $$ BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'school_students_school_id_fkey') THEN
        ALTER TABLE public.school_students DROP CONSTRAINT school_students_school_id_fkey;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'pdi_records_school_id_fkey') THEN
        ALTER TABLE public.pdi_records DROP CONSTRAINT pdi_records_school_id_fkey;
    END IF;
    -- Students table does NOT have school_id FK based on master schema, but checking just in case
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'students_school_id_fkey') THEN
        ALTER TABLE public.students DROP CONSTRAINT students_school_id_fkey;
    END IF;
END $$;


-- ==============================================================================
-- STEP 2: ENSURE COLUMNS EXIST & STANDARDIZE TO TEXT
-- ==============================================================================

-- Ensure 'classes' has school_id (It might be missing in some envs)
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'classes' AND column_name = 'school_id') THEN
        ALTER TABLE public.classes ADD COLUMN school_id TEXT;
    END IF;
END $$;

-- Alter existing columns to TEXT
ALTER TABLE public.profiles ALTER COLUMN school_id TYPE TEXT USING school_id::text;
ALTER TABLE public.pending_teachers ALTER COLUMN school_id TYPE TEXT USING school_id::text;
ALTER TABLE public.classes ALTER COLUMN school_id TYPE TEXT USING school_id::text;
ALTER TABLE public.pdi_documents ALTER COLUMN school_id TYPE TEXT USING school_id::text;

-- Conditional alters
DO $$ BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pdi_records' AND column_name = 'school_id') THEN
        ALTER TABLE public.pdi_records ALTER COLUMN school_id TYPE TEXT USING school_id::text;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'school_students' AND column_name = 'school_id') THEN
        ALTER TABLE public.school_students ALTER COLUMN school_id TYPE TEXT USING school_id::text;
    END IF;
    -- NOTE: We do NOT adding school_id to students. We respect the schema.
    -- If it happens to exist (garbage column), we assume it's unused or we ignore it for now to avoid breakage.
END $$;


-- ==============================================================================
-- STEP 3: DATA CORRECTION (DOMINGOS PIMENTA: 205893 -> 31205893)
-- ==============================================================================

DO $$ 
DECLARE
    old_id TEXT := '205893';
    new_id TEXT := '31205893';
BEGIN
    -- Only proceed if the old ID exists
    IF EXISTS (SELECT 1 FROM schools WHERE id = old_id) THEN
        
        -- Check if new ID already exists
        IF EXISTS (SELECT 1 FROM schools WHERE id = new_id) THEN
            -- Re-link dependents
            UPDATE public.profiles SET school_id = new_id WHERE school_id = old_id;
            UPDATE public.pending_teachers SET school_id = new_id WHERE school_id = old_id;
            UPDATE public.classes SET school_id = new_id WHERE school_id = old_id;
            UPDATE public.pdi_documents SET school_id = new_id WHERE school_id = old_id;
            
            IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'school_students' AND column_name = 'school_id') THEN
                UPDATE public.school_students SET school_id = new_id WHERE school_id = old_id;
            END IF;
            IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pdi_records' AND column_name = 'school_id') THEN
                UPDATE public.pdi_records SET school_id = new_id WHERE school_id = old_id;
            END IF;

            DELETE FROM schools WHERE id = old_id;
        ELSE
            -- Rename ID
            UPDATE schools SET id = new_id WHERE id = old_id;
            
            -- Manual Cascade
            UPDATE public.profiles SET school_id = new_id WHERE school_id = old_id;
            UPDATE public.pending_teachers SET school_id = new_id WHERE school_id = old_id;
            UPDATE public.classes SET school_id = new_id WHERE school_id = old_id;
            UPDATE public.pdi_documents SET school_id = new_id WHERE school_id = old_id;
             IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'school_students' AND column_name = 'school_id') THEN
                UPDATE public.school_students SET school_id = new_id WHERE school_id = old_id;
            END IF;
            IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pdi_records' AND column_name = 'school_id') THEN
                UPDATE public.pdi_records SET school_id = new_id WHERE school_id = old_id;
            END IF;
        END IF;
    END IF;
END $$;


-- ==============================================================================
-- STEP 4: REBUILD FOREIGN KEYS
-- ==============================================================================

ALTER TABLE public.profiles 
ADD CONSTRAINT profiles_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE SET NULL;

ALTER TABLE public.pending_teachers 
ADD CONSTRAINT pending_teachers_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE CASCADE;

ALTER TABLE public.classes 
ADD CONSTRAINT classes_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE CASCADE;

ALTER TABLE public.pdi_documents 
ADD CONSTRAINT pdi_documents_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE CASCADE;

DO $$ BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pdi_records' AND column_name = 'school_id') THEN
         ALTER TABLE public.pdi_records ADD CONSTRAINT pdi_records_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE CASCADE;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'school_students' AND column_name = 'school_id') THEN
         ALTER TABLE public.school_students ADD CONSTRAINT school_students_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE CASCADE;
    END IF;
END $$;


-- ==============================================================================
-- STEP 5: RESTORE ALL POLICIES (CORRECT logic for Manager)
-- ==============================================================================

-- 1. Profiles (View Colleagues)
CREATE POLICY "Managers can view school colleagues" ON public.profiles FOR SELECT
USING (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'manager' AND school_id = public.profiles.school_id));

-- 2. Pending Teachers (Manage Approval)
CREATE POLICY "pending_teachers_select_managers" ON public.pending_teachers FOR SELECT TO authenticated
USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'manager' AND school_id = pending_teachers.school_id));

CREATE POLICY "pending_teachers_insert_managers" ON public.pending_teachers FOR INSERT TO authenticated
WITH CHECK (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'manager' AND school_id = pending_teachers.school_id));

CREATE POLICY "pending_teachers_update_managers" ON public.pending_teachers FOR UPDATE TO authenticated
USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'manager' AND school_id = pending_teachers.school_id));

CREATE POLICY "pending_teachers_delete_managers" ON public.pending_teachers FOR DELETE TO authenticated
USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'manager' AND school_id = pending_teachers.school_id));

-- 3. Classes (Link to School)
CREATE POLICY "classes_select_school" ON public.classes FOR SELECT TO authenticated
USING (school_id IS NOT NULL AND EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND profiles.school_id = classes.school_id));

CREATE POLICY "classes_manage_school" ON public.classes FOR ALL TO authenticated
USING (school_id IS NOT NULL AND EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND (role = 'manager' OR is_admin = true) AND profiles.school_id = classes.school_id));

-- 4. School Students (Official List - Direct Link)
DO $$ BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'school_students') THEN
        -- Managers view
        CREATE POLICY "School Manager can manage students" ON public.school_students FOR ALL TO authenticated
        USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'manager' AND profiles.school_id = school_students.school_id));
        
        -- Colleagues view
        CREATE POLICY "Users can view students from their school" ON public.school_students FOR SELECT TO authenticated
        USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND profiles.school_id = school_students.school_id));

        -- Teachers add
        CREATE POLICY "Teachers can insert students to their school" ON public.school_students FOR INSERT TO authenticated
        WITH CHECK (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'teacher' AND profiles.school_id = school_students.school_id));
    END IF;
END $$;

-- 5. STUDENTS (Teacher's List - Indirect Link via Classes)
-- Critical Fix: Do NOT use students.school_id. Use students.class_id -> classes.school_id
DO $$ BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'students') THEN
        
        -- Clean slate for Students
        DROP POLICY IF EXISTS "Users manage own students" ON public.students;

        -- Teacher owns their students
        CREATE POLICY "Users manage own students" ON public.students FOR ALL TO authenticated
        USING (EXISTS (SELECT 1 FROM classes WHERE id = students.class_id AND user_id = auth.uid()));

        -- Manager can VIEW students in classes belonging to their school
        CREATE POLICY "Managers view school students via classes" ON public.students FOR SELECT TO authenticated
        USING (
            EXISTS (
                SELECT 1 FROM classes 
                JOIN profiles ON profiles.school_id = classes.school_id
                WHERE classes.id = students.class_id 
                AND profiles.id = auth.uid() 
                AND profiles.role = 'manager'
            )
        );
        
        -- Manager can MANAGE students in classes belonging to their school (Optional, but safe)
        CREATE POLICY "Managers manage school students via classes" ON public.students FOR ALL TO authenticated
        USING (
            EXISTS (
                SELECT 1 FROM classes 
                JOIN profiles ON profiles.school_id = classes.school_id
                WHERE classes.id = students.class_id 
                AND profiles.id = auth.uid() 
                AND profiles.role = 'manager'
            )
        );

    END IF;
END $$;

-- 6. PDI Documents
CREATE POLICY "Supervisors manage PDI documents" ON pdi_documents FOR ALL TO authenticated
USING (school_id IN (SELECT school_id FROM profiles WHERE id = auth.uid() AND role IN ('school_manager', 'school_admin', 'admin')));

CREATE POLICY "Teachers view PDI documents" ON pdi_documents FOR SELECT TO authenticated
USING (student_id IN (SELECT ss.id FROM school_students ss WHERE ss.school_id IN (SELECT school_id FROM profiles WHERE id = auth.uid())) OR school_id IN (SELECT school_id FROM profiles WHERE id = auth.uid()));

CREATE POLICY "Teachers update Block 10 only" ON pdi_documents FOR UPDATE TO authenticated
USING (school_id IN (SELECT school_id FROM profiles WHERE id = auth.uid()) AND EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'teacher'));

-- 7. PDI Records
DO $$ BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'pdi_records') THEN
        CREATE POLICY "School Admin can view all pdi records" ON public.pdi_records FOR SELECT TO authenticated
        USING (school_id IN (SELECT school_id FROM profiles WHERE id = auth.uid() AND role IN ('school_manager', 'school_admin', 'admin')));

        CREATE POLICY "School Members View PDI" ON public.pdi_records FOR SELECT TO authenticated
        USING (school_id IN (SELECT school_id FROM profiles WHERE id = auth.uid()));

        CREATE POLICY "Teachers can view pdi records of their school" ON public.pdi_records FOR SELECT TO authenticated
        USING (school_id IN (SELECT school_id FROM profiles WHERE id = auth.uid() AND role = 'teacher'));
        
        CREATE POLICY "Teachers Insert PDI" ON public.pdi_records FOR INSERT TO authenticated
        WITH CHECK (school_id IN (SELECT school_id FROM profiles WHERE id = auth.uid() AND role = 'teacher'));
    END IF;
END $$;


COMMIT;
