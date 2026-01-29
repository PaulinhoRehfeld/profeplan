-- ==============================================================================
-- INSERT MISSING PROFILE FOR: suporte@profeplan.com.br
-- ==============================================================================

DO $$
DECLARE
    v_user_id UUID;
    v_email TEXT := 'suporte@profeplan.com.br';
BEGIN
    -- 1. Find the user ID
    SELECT id INTO v_user_id
    FROM auth.users
    WHERE email = v_email;

    IF v_user_id IS NOT NULL THEN
        RAISE NOTICE 'Found User ID: %', v_user_id;

        -- 2. Upsert into profiles
        INSERT INTO public.profiles (
            id, 
            email, 
            role, 
            is_admin, 
            full_name, 
            plan_tier, 
            credits,
            school_id -- Admin doesn't strictly need one, but let's keep it null or set to a dummy if constraint exists
        )
        VALUES (
            v_user_id,
            v_email,
            'admin',
            true,
            'Suporte ProfePlan',
            'gold',
            9999,
            NULL
        )
        ON CONFLICT (id) DO UPDATE
        SET 
            role = 'admin',
            is_admin = true,
            plan_tier = 'gold',
            credits = 9999;
            
        RAISE NOTICE '✅ Profile successfully created/updated for %', v_email;
    ELSE
        RAISE EXCEPTION '❌ User % not found in auth.users. Please create the user in the Authentication tab first, OR check if the email is correct.', v_email;
    END IF;
END $$;
