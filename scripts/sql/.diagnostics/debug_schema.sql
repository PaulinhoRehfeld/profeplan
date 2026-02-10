-- DIAGNOSTIC SCRIPT
-- List Triggers and Policies to identify recursion/conflicts

-- 1. List Policies on 'schools' and 'profiles'
SELECT 
    schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check 
FROM pg_policies 
WHERE tablename IN ('schools', 'profiles', 'authorized_users');

-- 2. List Triggers on auth.users (triggers are hard to see across schemas, but we try)
SELECT 
    event_object_schema as table_schema,
    event_object_table as table_name,
    trigger_schema,
    trigger_name,
    event_manipulation as event,
    action_statement as definition
FROM information_schema.triggers
WHERE event_object_table = 'users' 
AND event_object_schema = 'auth';

-- 3. List Triggers on public tables
SELECT 
    event_object_schema as table_schema,
    event_object_table as table_name,
    trigger_schema,
    trigger_name,
    event_manipulation as event
FROM information_schema.triggers
WHERE event_object_schema = 'public';
