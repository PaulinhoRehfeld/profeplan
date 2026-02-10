-- ==============================================================================
-- FIX: Allow school_id to be TEXT (to match non-UUID INEP codes)
-- ==============================================================================

-- 1. Alter students table
ALTER TABLE public.students 
  DROP CONSTRAINT IF EXISTS students_current_school_id_fkey, -- Drop FK first just in case
  ALTER COLUMN current_school_id TYPE TEXT; -- Change UUID to TEXT

-- 2. Alter classes table
ALTER TABLE public.classes 
  DROP CONSTRAINT IF EXISTS classes_school_id_fkey,
  ALTER COLUMN school_id TYPE TEXT;

-- 3. Update FKs manually (optional, strictly speaking we just need the types to match)
-- We can try to re-add FK if schools.id is also text
-- ALTER TABLE public.students ADD CONSTRAINT students_current_school_id_fkey FOREIGN KEY (current_school_id) REFERENCES public.schools(id);
-- ALTER TABLE public.classes ADD CONSTRAINT classes_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id);

-- 4. Fix orphan records (Try to recover if possible, or just leave null for user to re-add)
-- Since we don't know which school "Davi Silva" belongs to without logs, we might just have to wipe or leave them.
-- BUT, if we assume the user is 'prehfeld@hotmail.com' (admin) or the active teacher...
-- We can verify in the next step.
