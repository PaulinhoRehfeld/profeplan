-- ==============================================================================
-- MIGRATION: ENABLE ADMIN ACCESS TO PDI DATA
-- ==============================================================================

BEGIN;

-- 1. Policies for 'school_students' (Update)
-- Allow Admins to UPDATE student data (specifically PDI)
CREATE POLICY "Admins can update students" ON school_students
FOR UPDATE TO authenticated
USING (
    exists (
        select 1 from profiles
        where profiles.id = auth.uid()
        and (profiles.role = 'admin' OR profiles.is_admin = true OR profiles.role = 'school_manager')
    )
);

-- 2. Ensure Admins can READ all students
-- (Assuming existing policy might be restricted to school_id, Admins usually see all?)
-- If Admins are bound to a school_id, the existing policy is likely fine if they share school_id.
-- If Admins are GLOBAL, we need a broad read policy.
CREATE POLICY "Admins can read all students" ON school_students
FOR SELECT TO authenticated
USING (
    exists (
        select 1 from profiles
        where profiles.id = auth.uid()
        and (profiles.role = 'admin' OR profiles.is_admin = true)
    )
);

-- 3. Policies for PDI Cycles (Ensure Admin Write)
DROP POLICY IF EXISTS "Managers Manage PDI Cycles" ON pdi_cycles;

CREATE POLICY "Managers and Admins Manage PDI Cycles" ON pdi_cycles
FOR ALL TO authenticated
USING (
    exists (
        select 1 from profiles
        where profiles.id = auth.uid()
        and (
             -- Match School ID for Managers
             (profiles.role = 'school_manager' AND profiles.school_id = (select school_id from school_students where id = pdi_cycles.student_id))
             OR 
             -- Global Admin
             (profiles.role = 'admin' OR profiles.is_admin = true)
        )
    )
);

-- 4. Policies for Teacher Evaluations (Admins can view/edit too if needed)
CREATE POLICY "Admins Manage Evaluations" ON pdi_teacher_evaluations
FOR ALL TO authenticated
USING (
    exists (
        select 1 from profiles
        where profiles.id = auth.uid()
        and (profiles.role = 'admin' OR profiles.is_admin = true)
    )
);

COMMIT;
