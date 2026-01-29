-- ==============================================================================
-- DELETE USER: paulo.rehfeld@educacao.mg.gov.br
-- ==============================================================================

BEGIN;

DO $$
DECLARE
    v_user_id UUID;
BEGIN
    -- 1. Find the user ID
    SELECT id INTO v_user_id
    FROM auth.users
    WHERE email = 'paulo.rehfeld@educacao.mg.gov.br';

    IF v_user_id IS NOT NULL THEN
        -- 2. Delete from public tables first (manually if cascade fails, though auth.users usually cascades)
        -- Delete dependencies if necessary, e.g. classes created by this user?
        -- For now, we trust Cascade or we just delete references we know of.
        -- Deleting from profiles explicitly to be sure.
        DELETE FROM public.profiles WHERE id = v_user_id;

        -- 3. Delete from auth.users (This is the Source of Truth)
        DELETE FROM auth.users WHERE id = v_user_id;
        
        RAISE NOTICE 'User % (ID: %) has been deleted.', 'paulo.rehfeld@educacao.mg.gov.br', v_user_id;
    ELSE
        RAISE NOTICE 'User % not found.', 'paulo.rehfeld@educacao.mg.gov.br';
    END IF;
END $$;

COMMIT;
