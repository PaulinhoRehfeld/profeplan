-- ==============================================================================
-- MIGRATION: Add School Management Columns to Classes Table
-- Date: 2026-01-24
-- Purpose: Add grade column and other school management fields to classes table
-- ==============================================================================

-- 1. Add missing columns to classes table if they don't exist
DO $$ 
BEGIN
    -- Add school_id column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'classes' AND column_name = 'school_id'
    ) THEN
        ALTER TABLE public.classes ADD COLUMN school_id TEXT REFERENCES public.schools(id) ON DELETE CASCADE;
    END IF;

    -- Add grade column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'classes' AND column_name = 'grade'
    ) THEN
        ALTER TABLE public.classes ADD COLUMN grade TEXT;
    END IF;

    -- Add year column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'classes' AND column_name = 'year'
    ) THEN
        ALTER TABLE public.classes ADD COLUMN year INTEGER DEFAULT EXTRACT(YEAR FROM NOW());
    END IF;

    -- Add shift column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'classes' AND column_name = 'shift'
    ) THEN
        ALTER TABLE public.classes ADD COLUMN shift TEXT;
    END IF;

    -- Add room column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'classes' AND column_name = 'room'
    ) THEN
        ALTER TABLE public.classes ADD COLUMN room TEXT;
    END IF;

    -- Add updated_at column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'classes' AND column_name = 'updated_at'
    ) THEN
        ALTER TABLE public.classes ADD COLUMN updated_at TIMESTAMPTZ DEFAULT NOW();
    END IF;
END $$;

-- 2. Create indices for performance
CREATE INDEX IF NOT EXISTS idx_classes_school_id ON public.classes(school_id);

-- 3. Update RLS Policies for School Management

-- Drop old policies if they exist (these were from the original migration_classes.sql)
DROP POLICY IF EXISTS "classes_select_authenticated" ON public.classes;
DROP POLICY IF EXISTS "classes_insert_managers" ON public.classes;
DROP POLICY IF EXISTS "classes_update_managers" ON public.classes;
DROP POLICY IF EXISTS "classes_delete_managers" ON public.classes;
DROP POLICY IF EXISTS "classes_select_school" ON public.classes;

-- New Policy: SELECT (authenticated users can see classes from their school)
CREATE POLICY "classes_select_school"
ON public.classes
FOR SELECT
TO authenticated
USING (
    school_id IS NOT NULL 
    AND EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND profiles.school_id = classes.school_id
    )
);

-- New Policy: INSERT (only school managers/admins can create school classes)
CREATE POLICY "classes_insert_managers"
ON public.classes
FOR INSERT
TO authenticated
WITH CHECK (
    school_id IS NOT NULL 
    AND EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (role = 'manager' OR is_admin = true)
        AND profiles.school_id = classes.school_id
    )
);

-- New Policy: UPDATE (only school managers/admins can update school classes)
CREATE POLICY "classes_update_managers"
ON public.classes
FOR UPDATE
TO authenticated
USING (
    school_id IS NOT NULL 
    AND EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (role = 'manager' OR is_admin = true)
        AND profiles.school_id = classes.school_id
    )
);

-- New Policy: DELETE (only school managers/admins can delete school classes)
CREATE POLICY "classes_delete_managers"
ON public.classes
FOR DELETE
TO authenticated
USING (
    school_id IS NOT NULL 
    AND EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND (role = 'manager' OR is_admin = true)
        AND profiles.school_id = classes.school_id
    )
);

-- 4. Verification
SELECT 
    'Migration completed' as status,
    EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = 'classes' AND column_name = 'grade') as grade_column_exists,
    EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = 'classes' AND column_name = 'school_id') as school_id_column_exists;
