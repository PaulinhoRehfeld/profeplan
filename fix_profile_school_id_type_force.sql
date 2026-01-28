-- FORCE FIX: Migrate all school_id columns to TEXT (INEP Code)
-- This script handles the dependencies (Policies) that block simple ALTERs.

BEGIN;

-- 1. DROP BLOCKING POLICIES (We will recreate them)
-- PDI Documents
DROP POLICY IF EXISTS "Supervisors manage PDI documents" ON pdi_documents;
DROP POLICY IF EXISTS "Teachers view PDI documents" ON pdi_documents;
DROP POLICY IF EXISTS "Teachers update Block 10 only" ON pdi_documents;

-- PDI Records (Legacy/Alternative table found in error logs)
DROP POLICY IF EXISTS "School Admin can view all pdi records" ON pdi_records;
DROP POLICY IF EXISTS "School Members View PDI" ON pdi_records;
DROP POLICY IF EXISTS "Teachers Insert PDI" ON pdi_records;
DROP POLICY IF EXISTS "pdi_records_select_school" ON pdi_records;
DROP POLICY IF EXISTS "Teachers can view pdi records of their school" ON pdi_records;
DROP POLICY IF EXISTS "Teachers can insert pdi records" ON pdi_records;


-- Pending Teachers
DROP POLICY IF EXISTS "pending_teachers_select_managers" ON public.pending_teachers;
DROP POLICY IF EXISTS "pending_teachers_insert_managers" ON public.pending_teachers;
DROP POLICY IF EXISTS "pending_teachers_update_managers" ON public.pending_teachers;
DROP POLICY IF EXISTS "pending_teachers_delete_managers" ON public.pending_teachers;

-- Classes
DROP POLICY IF EXISTS "classes_select_school" ON public.classes;
DROP POLICY IF EXISTS "classes_insert_managers" ON public.classes;
DROP POLICY IF EXISTS "classes_update_managers" ON public.classes;
DROP POLICY IF EXISTS "classes_delete_managers" ON public.classes;
DROP POLICY IF EXISTS "classes_manage_school" ON public.classes;

-- Students (Drop ALL potential policies found in history)
DROP POLICY IF EXISTS "students_select_school" ON public.students;
DROP POLICY IF EXISTS "students_insert_managers" ON public.students;
DROP POLICY IF EXISTS "students_update_managers" ON public.students;
DROP POLICY IF EXISTS "students_delete_managers" ON public.students;
DROP POLICY IF EXISTS "start_students_school" ON public.students;
DROP POLICY IF EXISTS "School Manager can manage students" ON public.students; 
DROP POLICY IF EXISTS "students_manage_school" ON public.students;
DROP POLICY IF EXISTS "Users manage own students" ON public.students;

-- School Students (The one from the error + others)
DROP POLICY IF EXISTS "Users can view students from their school" ON public.school_students;
DROP POLICY IF EXISTS "School Members View Students" ON public.school_students;
DROP POLICY IF EXISTS "School Manager can manage students" ON public.school_students;
DROP POLICY IF EXISTS "Managers Manage Students" ON public.school_students;
DROP POLICY IF EXISTS "Teachers Insert Students" ON public.school_students;
DROP POLICY IF EXISTS "Teachers can insert students to their school" ON public.school_students;


-- Profiles (Manager View)
DROP POLICY IF EXISTS "Managers can view school colleagues" ON public.profiles;


-- 2. DROP FOREIGN KEYS (To allow type change)
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_school_id_fkey;
ALTER TABLE public.pending_teachers DROP CONSTRAINT IF EXISTS pending_teachers_school_id_fkey;
ALTER TABLE public.classes DROP CONSTRAINT IF EXISTS classes_school_id_fkey;
ALTER TABLE public.students DROP CONSTRAINT IF EXISTS students_current_school_id_fkey;
ALTER TABLE public.students DROP CONSTRAINT IF EXISTS students_school_id_fkey;
ALTER TABLE public.pdi_documents DROP CONSTRAINT IF EXISTS pdi_documents_school_id_fkey;

-- School Students Foreign Keys (Guessing names or using safe DO block)
DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'school_students_school_id_fkey') THEN
        ALTER TABLE public.school_students DROP CONSTRAINT school_students_school_id_fkey;
    END IF;
END $$;
-- PDI Records Foreign Keys
DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'pdi_records_school_id_fkey') THEN
        ALTER TABLE public.pdi_records DROP CONSTRAINT pdi_records_school_id_fkey;
    END IF;
END $$;


-- 3. ALTER COLUMNS TO TEXT (INEP CODE)
ALTER TABLE public.profiles ALTER COLUMN school_id TYPE TEXT USING school_id::text;
ALTER TABLE public.pending_teachers ALTER COLUMN school_id TYPE TEXT USING school_id::text;
ALTER TABLE public.classes ALTER COLUMN school_id TYPE TEXT USING school_id::text;
ALTER TABLE public.pdi_documents ALTER COLUMN school_id TYPE TEXT USING school_id::text;

-- PDI Records
DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pdi_records' AND column_name = 'school_id') THEN
        ALTER TABLE public.pdi_records ALTER COLUMN school_id TYPE TEXT USING school_id::text;
    END IF;
END $$;

-- Students table typically has school_id or current_school_id. Try both safely.
DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'students' AND column_name = 'school_id') THEN
        ALTER TABLE public.students ALTER COLUMN school_id TYPE TEXT USING school_id::text;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'students' AND column_name = 'current_school_id') THEN
        ALTER TABLE public.students ALTER COLUMN current_school_id TYPE TEXT USING current_school_id::text;
    END IF;
END $$;

-- School Students table
DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'school_students' AND column_name = 'school_id') THEN
        ALTER TABLE public.school_students ALTER COLUMN school_id TYPE TEXT USING school_id::text;
    END IF;
END $$;


-- 4. RE-ADD FOREIGN KEYS (Pointing to schools.id which IS the INEP Code in TEXT)

-- Profiles
ALTER TABLE public.profiles 
ADD CONSTRAINT profiles_school_id_fkey 
FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE SET NULL;

-- Pending Teachers
ALTER TABLE public.pending_teachers 
ADD CONSTRAINT pending_teachers_school_id_fkey 
FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE CASCADE;

-- Classes
ALTER TABLE public.classes 
ADD CONSTRAINT classes_school_id_fkey 
FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE CASCADE;

-- PDI Documents
ALTER TABLE public.pdi_documents 
ADD CONSTRAINT pdi_documents_school_id_fkey 
FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE CASCADE;

-- PDI Records
DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pdi_records' AND column_name = 'school_id') THEN
         ALTER TABLE public.pdi_records ADD CONSTRAINT pdi_records_school_id_fkey 
         FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Students (Handle both columns if they exist)
DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'students' AND column_name = 'school_id') THEN
         ALTER TABLE public.students DROP CONSTRAINT IF EXISTS students_school_id_fkey;
         ALTER TABLE public.students 
         ADD CONSTRAINT students_school_id_fkey 
         FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE CASCADE;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'students' AND column_name = 'current_school_id') THEN
         ALTER TABLE public.students DROP CONSTRAINT IF EXISTS students_current_school_id_fkey;
         ALTER TABLE public.students 
         ADD CONSTRAINT students_current_school_id_fkey 
         FOREIGN KEY (current_school_id) REFERENCES public.schools(id) ON DELETE CASCADE;
    END IF;
END $$;

-- School Students
DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'school_students' AND column_name = 'school_id') THEN
         ALTER TABLE public.school_students ADD CONSTRAINT school_students_school_id_fkey 
         FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE CASCADE;
    END IF;
END $$;


-- 5. RE-CREATE POLICIES (Using TEXT comparisons + Explicit Subqueries)

-- Profiles
CREATE POLICY "Managers can view school colleagues" ON public.profiles FOR SELECT
USING (
  auth.uid() IN (
    SELECT id FROM public.profiles 
    WHERE role = 'manager' AND school_id = public.profiles.school_id
  )
);

-- PDI Documents
CREATE POLICY "Supervisors manage PDI documents" ON pdi_documents
FOR ALL TO authenticated
USING (
    school_id IN (
        SELECT school_id FROM profiles 
        WHERE id = auth.uid() 
        AND role IN ('school_manager', 'school_admin', 'admin')
    )
);

CREATE POLICY "Teachers view PDI documents" ON pdi_documents
FOR SELECT TO authenticated
USING (
    student_id IN (
        SELECT ss.id FROM school_students ss
        WHERE ss.school_id IN (
            SELECT school_id FROM profiles WHERE id = auth.uid()
        )
    )
    OR
    school_id IN (
        SELECT school_id FROM profiles WHERE id = auth.uid()
    )
);

CREATE POLICY "Teachers update Block 10 only" ON pdi_documents
FOR UPDATE TO authenticated
USING (
    school_id IN (
        SELECT school_id FROM profiles WHERE id = auth.uid()
    )
    AND
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND role = 'teacher'
    )
);

-- PDI Records (Recreating if table exists)
DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'pdi_records') THEN
        
        -- School Admin View
        CREATE POLICY "School Admin can view all pdi records" ON public.pdi_records FOR SELECT TO authenticated
        USING (
            school_id IN (
                SELECT school_id FROM profiles 
                WHERE id = auth.uid() 
                AND role IN ('school_manager', 'school_admin', 'admin')
            )
        );

        -- School Members View
         CREATE POLICY "School Members View PDI" ON public.pdi_records FOR SELECT TO authenticated
        USING (
            school_id IN (
                SELECT school_id FROM profiles 
                WHERE id = auth.uid() 
            )
        );

        -- Teachers can view pdi records of their school (Found in error log)
         CREATE POLICY "Teachers can view pdi records of their school" ON public.pdi_records FOR SELECT TO authenticated
        USING (
            school_id IN (
                SELECT school_id FROM profiles 
                WHERE id = auth.uid() 
                AND role = 'teacher'
            )
        );
        
        -- Teachers Insert
        CREATE POLICY "Teachers Insert PDI" ON public.pdi_records FOR INSERT TO authenticated
        WITH CHECK (
            school_id IN (
                SELECT school_id FROM profiles 
                WHERE id = auth.uid() 
                AND role = 'teacher'
            )
        );
        -- Recreated with both common names found attempting to block
        CREATE POLICY "Teachers can insert pdi records" ON public.pdi_records FOR INSERT TO authenticated
        WITH CHECK (
            school_id IN (
                SELECT school_id FROM profiles 
                WHERE id = auth.uid() 
                AND role = 'teacher'
            )
        );

    END IF;
END $$;


-- Pending Teachers
CREATE POLICY "pending_teachers_select_managers" ON public.pending_teachers FOR SELECT TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() AND role = 'manager' 
        AND school_id = pending_teachers.school_id
    )
);

CREATE POLICY "pending_teachers_insert_managers" ON public.pending_teachers FOR INSERT TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() AND role = 'manager' 
        AND school_id = pending_teachers.school_id
    )
);

CREATE POLICY "pending_teachers_update_managers" ON public.pending_teachers FOR UPDATE TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() AND role = 'manager' 
        AND school_id = pending_teachers.school_id
    )
);

CREATE POLICY "pending_teachers_delete_managers" ON public.pending_teachers FOR DELETE TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() AND role = 'manager' 
        AND school_id = pending_teachers.school_id
    )
);

-- Classes
CREATE POLICY "classes_select_school" ON public.classes FOR SELECT TO authenticated
USING (
    school_id IS NOT NULL AND EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND profiles.school_id = classes.school_id
    )
);

CREATE POLICY "classes_manage_school" ON public.classes FOR ALL TO authenticated
USING (
    school_id IS NOT NULL AND EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() AND (role = 'manager' OR is_admin = true)
        AND profiles.school_id = classes.school_id
    )
);

-- Students (Recreating all specific policies correctly)
DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'students') THEN
        
        -- SELECT
        DROP POLICY IF EXISTS "students_select_school" ON public.students;
        CREATE POLICY "students_select_school" ON public.students FOR SELECT TO authenticated
        USING (
            EXISTS (
                SELECT 1 FROM profiles 
                WHERE id = auth.uid() 
                AND profiles.school_id = students.school_id 
            )
            OR
            EXISTS ( 
               SELECT 1 FROM profiles 
               WHERE id = auth.uid() 
               AND profiles.school_id = students.current_school_id 
            )
        );
        
        -- INSERT
        DROP POLICY IF EXISTS "students_insert_managers" ON public.students;
        CREATE POLICY "students_insert_managers" ON public.students FOR INSERT TO authenticated
        WITH CHECK (
            EXISTS (
                SELECT 1 FROM profiles 
                WHERE id = auth.uid() AND role = 'manager'
                AND (profiles.school_id = students.school_id OR profiles.school_id = students.current_school_id)
            )
        );

        -- UPDATE
        DROP POLICY IF EXISTS "students_update_managers" ON public.students;
        CREATE POLICY "students_update_managers" ON public.students FOR UPDATE TO authenticated
        USING (
            EXISTS (
                SELECT 1 FROM profiles 
                WHERE id = auth.uid() AND role = 'manager'
                AND (profiles.school_id = students.school_id OR profiles.school_id = students.current_school_id)
            )
        );

        -- DELETE
        DROP POLICY IF EXISTS "students_delete_managers" ON public.students;
        CREATE POLICY "students_delete_managers" ON public.students FOR DELETE TO authenticated
        USING (
             EXISTS (
                SELECT 1 FROM profiles 
                WHERE id = auth.uid() AND role = 'manager'
                AND (profiles.school_id = students.school_id OR profiles.school_id = students.current_school_id)
            )
        );

    END IF;
END $$;


-- School Students (Recreating policies)
DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'school_students') THEN
        
        -- SELECT (Users can view students from their school)
        CREATE POLICY "Users can view students from their school" ON public.school_students FOR SELECT TO authenticated
        USING (
            EXISTS (
                SELECT 1 FROM profiles 
                WHERE id = auth.uid() 
                AND profiles.school_id = school_students.school_id
            )
        );
        
        -- Manager Access (Manage)
        CREATE POLICY "School Manager can manage students" ON public.school_students FOR ALL TO authenticated
        USING (
            EXISTS (
                SELECT 1 FROM profiles 
                WHERE id = auth.uid() AND role = 'manager'
                AND profiles.school_id = school_students.school_id
            )
        );

         -- Teachers Insert Access (Recreating the one that blocked)
        CREATE POLICY "Teachers can insert students to their school" ON public.school_students FOR INSERT TO authenticated
        WITH CHECK (
            EXISTS (
                SELECT 1 FROM profiles 
                WHERE id = auth.uid() AND role = 'teacher'
                AND profiles.school_id = school_students.school_id
            )
        );

    END IF;
END $$;


COMMIT;
