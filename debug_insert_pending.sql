-- Script to Debug Pending Teacher Insertion
-- Run this in Supabase SQL Editor to see the REAL error message

DO $$
DECLARE
    v_school_id TEXT;
    v_manager_id UUID;
BEGIN
    -- 1. Get the school ID of the current user (You)
    SELECT school_id, id INTO v_school_id, v_manager_id
    FROM profiles 
    WHERE email = 'prehfeld@hotmail.com'; -- HARDCODED YOUR EMAIL

    RAISE NOTICE 'Manager ID: %, School ID: %', v_manager_id, v_school_id;

    -- 2. Try to insert a pending teacher manually
    INSERT INTO public.pending_teachers (
        school_id,
        email_institucional,
        masp,
        full_name,
        created_by
    ) VALUES (
        v_school_id,
        'debug.teacher@educacao.mg.gov.br',
        '99999999',
        'Debug Teacher',
        v_manager_id
    );

    RAISE NOTICE 'Insert successful!';
    
    -- Rollback to not leave garbage
    RAISE EXCEPTION 'Test finished successfully (Rolling back)';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'ERROR TRAPPED: % %', SQLERRM, SQLSTATE;
END $$;
