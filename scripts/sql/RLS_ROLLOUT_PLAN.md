# RLS Rollout Plan

Goal: re-enable and validate RLS without breaking app access.
Scope: profiles, teacher_schools, schools, classes, students, pending_teachers.

## Phase 0 - Preparation

- Confirm backup/snapshot exists.
- Capture current policy state:
  - check_security_flags.sql
  - verify_rls_policies.sql
  - audit_admin_rls.sql
  - audit_functions.sql

## Phase 1 - DEV Environment

1) Apply fixes in order (see RLS_EXECUTION_ORDER.md).
2) Run verification scripts:
   - check_security_flags.sql
   - verify_rls_policies.sql
   - check_profiles_schema.sql
   - check_teacher_link.sql
3) Manual smoke tests:
   - Admin can list all profiles.
   - Manager can see only their school users.
   - Teacher can see only self profile.
   - SchoolSwitcher still loads.
4) Log results in a short note.

## Phase 2 - STAGING Environment

1) Repeat Phase 1 steps.
2) Run app-level smoke tests:
   - Login (teacher, manager, admin).
   - List classes, students, PDI, planning.
   - Pending teachers approval flow.
3) Verify no 403/406 errors in client logs.

## Phase 3 - PROD Environment

1) Announce maintenance window.
2) Apply scripts in order.
3) Re-run verification scripts.
4) Confirm key flows:
   - Login
   - School switching
   - Class list
   - Student list
   - PDI list

## Rollback Plan

If any critical failure occurs:
- restore_admin_access.sql
- restore_profiles_security.sql
- restore_profile_access.sql
- restore_schools_security.sql

Then re-run diagnostics to confirm baseline state.

## Acceptance Criteria

- RLS enabled on target tables.
- No recursion errors in profiles.
- Correct role-based visibility.
- No widespread 403/406 errors in app.
