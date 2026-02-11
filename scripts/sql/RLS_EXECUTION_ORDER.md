# RLS Execution Order (Draft)

Purpose: provide a safe, repeatable order for running admin/RLS scripts and avoid accidental regressions.
Scope: scripts in scripts/sql/*.sql
Status: RECOMMENDED - based on script content review (2026-02-10).

## Preconditions

1) Confirm environment and backup
- Run on a staging database first.
- Take a backup or snapshot before any change.

2) Baseline diagnostics (read-only)
- check_db_integrity.sql
- check_security_flags.sql
- verify_rls_policies.sql
- audit_admin_rls.sql
- audit_functions.sql

## Recommended Order (High-Level)

Step 1: Admin access recovery (if blocked)
- ensure_global_admin_access.sql
- restore_admin_access.sql (only if previous scripts broke access)

Step 2: Resolve recursion and visibility issues (winner: fix_profiles_recursion_400.sql)
- fix_infinite_recursion_final.sql (legacy recursion fix)
- fix_profiles_recursion_400.sql (preferred: creates SECURITY DEFINER helpers + non-recursive policies)
	- Includes: is_admin_safe(), get_my_school_id_safe(), and select/update/insert policies
- Skip fix_profiles_visibility.sql if fix_profiles_recursion_400.sql ran (overlaps and is weaker)

Step 3: Core RLS policy set (choose ONE target set)
- Profiles: fix_profiles_recursion_400.sql (winner)
- School Students: migration_fix_policies.sql (if role = school_manager is in use)
- Avoid rls_fix_definitivo.sql unless you explicitly want public SELECT on profiles

Step 4: Table-specific RLS fixes
- fix_students_rls_final.sql (creates is_school_manager helper used by other scripts)
- ensure_global_admin_access.sql (sets RLS for schools/classes/students/pending_teachers)
- fix_pending_teachers_rls_v2.sql (only if you are not using ensure_global_admin_access.sql policies)
- fix_student_delete_rls.sql (if used by your workflows)

Step 5: Admin role and permissions
- fix_admin_duplicates.sql
- delete_duplicate_admin.sql
- fix_admin_protection.sql
- fix_force_all_admins.sql
- update_admin_permissions.sql
- promote_admin.sql (if a new admin is needed)

Step 6: Post-change verification (read-only)
- check_security_flags.sql
- verify_rls_policies.sql
- audit_admin_rls.sql
- check_profiles_schema.sql
- check_teacher_link.sql

## Scripts to Avoid or Use Only as Last Resort

- disable_rls_debug.sql
- disable_schools_fix_profiles.sql
- nuke_and_fix_profiles_rls.sql
- fix_all_open_read.sql

These disable or weaken security. Only use in emergency recovery and revert immediately.

## Restore/Revert Scripts

- restore_admin_access.sql
- restore_profiles_security.sql
- restore_profile_access.sql
- restore_schools_security.sql
- revert_school_management.sql

Use these ONLY to roll back a known bad change. Always re-run diagnostics after a restore.

## Notes

- Multiple versions exist (v2, final, definitivo). Prefer the newest script only after reviewing its content.
- Do NOT mix multiple RLS policy sets in one run.
- Always re-check RLS enabled flags in the diagnostics before and after changes.

## Decision Log (Fill Before Execution)

- Target environment:
- Chosen RLS policy set:
- Reason for choice:
- Backup snapshot:
- Date/time:

## Rationale for "Winner" Choice

- fix_profiles_recursion_400.sql uses SECURITY DEFINER helpers and forces function owner to postgres, reducing recursion risk.
- fix_profiles_visibility.sql does not set function owner, so it is less robust for RLS bypass.
- rls_fix_definitivo.sql grants SELECT to all authenticated users (broad). Use only if that is desired.
