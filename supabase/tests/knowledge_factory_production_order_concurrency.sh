#!/usr/bin/env bash
# Knowledge Factory Sublote 3B.5.3 - real multi-session concurrency checks.
# NON-PRODUCTION ONLY. The target must be the disposable DB CI database.

set -euo pipefail

: "${KF_DB_URL:?KF_DB_URL must point to the disposable Knowledge Factory database}"

if [ "$KF_DB_URL" != 'postgresql://postgres:postgres@127.0.0.1:54322/postgres' ]; then
  echo "Refusing concurrency checks outside the canonical disposable Supabase database."
  exit 1
fi

work_dir="$(mktemp -d)"
cleanup_files() {
  rm -rf "$work_dir"
}
trap cleanup_files EXIT

psql_safe() {
  psql "$KF_DB_URL" -v ON_ERROR_STOP=1 --no-psqlrc "$@"
}

wait_for_marker() {
  local file="$1"
  local marker="$2"
  local attempts=0

  until grep -q "$marker" "$file" 2>/dev/null; do
    attempts=$((attempts + 1))
    if [ "$attempts" -ge 100 ]; then
      echo "Timed out while preparing the disposable concurrency barrier."
      return 1
    fi
    sleep 0.05
  done
}

create_payload() {
  local opp_id="$1"
  local event_id="$2"
  local theme="$3"
  local occurred_at="$4"
  printf '{"order":{"id":"%s","version":"1.0.0","agentProfileId":"a5100000-0000-4000-8000-000000000001","curriculumPackageId":"b5100000-0000-4000-8000-000000000001","productType":"lesson_plan","theme":"%s"},"eventId":"%s","eventVersion":"1.0.0","occurredAt":"%s"}' \
    "$opp_id" "$theme" "$event_id" "$occurred_at"
}

transition_payload() {
  local opp_id="$1"
  local expected_status="$2"
  local expected_updated_at="$3"
  local to_status="$4"
  local event_id="$5"
  local occurred_at="$6"
  printf '{"requesterId":"a5100000-0000-4000-8000-000000000001","oppId":"%s","expectedStatus":"%s","expectedUpdatedAt":"%s","toStatus":"%s","eventId":"%s","eventVersion":"1.0.0","occurredAt":"%s"}' \
    "$opp_id" "$expected_status" "$expected_updated_at" "$to_status" "$event_id" "$occurred_at"
}

create_as_requester() {
  local command_id="$1"
  local payload="$2"
  psql_safe -At <<SQL
BEGIN;
SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', 'a5100000-0000-4000-8000-000000000001', true);
SELECT set_config(
  'request.jwt.claims',
  '{"sub":"a5100000-0000-4000-8000-000000000001","role":"authenticated"}',
  true
);
SELECT replayed FROM public.kf_create_production_order('$command_id', '$payload'::jsonb);
COMMIT;
SQL
}

transition_as_system() {
  local command_id="$1"
  local payload="$2"
  psql_safe -At --set=VERBOSITY=verbose <<SQL
BEGIN;
SET LOCAL ROLE service_role;
SELECT replayed FROM public.kf_transition_production_order('$command_id', '$payload'::jsonb);
COMMIT;
SQL
}

psql_safe >/dev/null <<'SQL'
INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, created_at, updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'a5100000-0000-4000-8000-000000000001',
  'authenticated', 'authenticated', 'opp-concurrency@example.invalid', '',
  now(), now(), now()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.kf_curriculum_packages (
  id, version, state, stage, status, title, effective_from
) VALUES (
  'b5100000-0000-4000-8000-000000000001',
  '1.0.0', 'MG', 'ensino_medio', 'draft',
  'Synthetic OPP concurrency package', '2026-08-11T20:00:00.000Z'
);
SQL

# ---------------------------------------------------------------------------
# Same command race: both sessions queue behind the same advisory lock. One
# commits and the other must replay the persisted receipt.
# ---------------------------------------------------------------------------
same_opp="d5100000-0000-4000-8000-000000000001"
same_create_command="c5100000-0000-4000-8000-000000000001"
same_create_event="e5100000-0000-4000-8000-000000000001"
same_transition_command="c5100000-0000-4000-8000-000000000002"
same_transition_event="e5100000-0000-4000-8000-000000000002"

create_as_requester \
  "$same_create_command" \
  "$(create_payload "$same_opp" "$same_create_event" 'Same command race' '2026-08-11T20:01:00.000Z')" \
  >/dev/null

psql_safe -At >"$work_dir/advisory-lock.log" 2>&1 <<SQL &
BEGIN;
SELECT pg_advisory_xact_lock(hashtextextended('$same_transition_command', 0));
SELECT 'ADVISORY_LOCK_READY';
SELECT pg_sleep(2);
COMMIT;
SQL
barrier_pid=$!
wait_for_marker "$work_dir/advisory-lock.log" 'ADVISORY_LOCK_READY'

same_payload="$(transition_payload \
  "$same_opp" 'requested' '2026-08-11T20:01:00.000Z' 'scoped' \
  "$same_transition_event" '2026-08-11T20:02:00.000Z')"

transition_as_system "$same_transition_command" "$same_payload" \
  >"$work_dir/same-a.out" 2>"$work_dir/same-a.err" &
same_pid_a=$!
transition_as_system "$same_transition_command" "$same_payload" \
  >"$work_dir/same-b.out" 2>"$work_dir/same-b.err" &
same_pid_b=$!

wait "$same_pid_a"
wait "$same_pid_b"
wait "$barrier_pid"

same_results="$(grep -E '^[ft]$' "$work_dir/same-a.out" "$work_dir/same-b.out" | sed 's/^.*://' | sort | tr '\n' ' ')"
if [ "$same_results" != "f t " ]; then
  echo "Same-command concurrency did not produce one commit and one replay."
  exit 1
fi

same_counts="$(psql_safe -Atc "
  SELECT
    (SELECT count(*) FROM public.kf_production_orders WHERE id = '$same_opp') || ':' ||
    (SELECT count(*) FROM public.kf_production_order_events WHERE opp_id = '$same_opp') || ':' ||
    (SELECT count(*) FROM public.kf_production_order_write_receipts
      WHERE command_id = '$same_transition_command');
")"
if [ "$same_counts" != "1:2:1" ]; then
  echo "Same-command concurrency created a duplicate logical mutation."
  exit 1
fi

# ---------------------------------------------------------------------------
# Competing state race: both sessions read the same expectation and queue on
# the target row. Exactly one transition must win; the stale competitor fails
# with PT409 after the row lock is released.
# ---------------------------------------------------------------------------
race_opp="d5100000-0000-4000-8000-000000000011"
race_create_command="c5100000-0000-4000-8000-000000000011"
race_create_event="e5100000-0000-4000-8000-000000000011"

create_as_requester \
  "$race_create_command" \
  "$(create_payload "$race_opp" "$race_create_event" 'Competing transition race' '2026-08-11T20:11:00.000Z')" \
  >/dev/null

psql_safe -At >"$work_dir/row-lock.log" 2>&1 <<SQL &
BEGIN;
SELECT id FROM public.kf_production_orders WHERE id = '$race_opp' FOR UPDATE;
SELECT 'ROW_LOCK_READY';
SELECT pg_sleep(2);
COMMIT;
SQL
row_barrier_pid=$!
wait_for_marker "$work_dir/row-lock.log" 'ROW_LOCK_READY'

race_payload_a="$(transition_payload \
  "$race_opp" 'requested' '2026-08-11T20:11:00.000Z' 'scoped' \
  'e5100000-0000-4000-8000-000000000012' '2026-08-11T20:12:00.000Z')"
race_payload_b="$(transition_payload \
  "$race_opp" 'requested' '2026-08-11T20:11:00.000Z' 'blocked' \
  'e5100000-0000-4000-8000-000000000013' '2026-08-11T20:12:00.000Z')"

transition_as_system 'c5100000-0000-4000-8000-000000000012' "$race_payload_a" \
  >"$work_dir/race-a.out" 2>"$work_dir/race-a.err" &
race_pid_a=$!
transition_as_system 'c5100000-0000-4000-8000-000000000013' "$race_payload_b" \
  >"$work_dir/race-b.out" 2>"$work_dir/race-b.err" &
race_pid_b=$!

set +e
wait "$race_pid_a"
race_status_a=$?
wait "$race_pid_b"
race_status_b=$?
wait "$row_barrier_pid"
row_barrier_status=$?
set -e

if [ "$row_barrier_status" -ne 0 ]; then
  echo "The disposable row-lock barrier failed."
  exit 1
fi

if ! { [ "$race_status_a" -eq 0 ] && [ "$race_status_b" -ne 0 ]; } \
  && ! { [ "$race_status_a" -ne 0 ] && [ "$race_status_b" -eq 0 ]; }; then
  echo "Competing transitions did not produce exactly one winner."
  exit 1
fi

if [ "$race_status_a" -ne 0 ]; then
  loser_log="$work_dir/race-a.err"
else
  loser_log="$work_dir/race-b.err"
fi
if ! grep -q 'PT409' "$loser_log"; then
  echo "The stale competing transition did not fail with PT409."
  exit 1
fi

race_counts="$(psql_safe -Atc "
  SELECT
    (SELECT count(*) FROM public.kf_production_order_events WHERE opp_id = '$race_opp') || ':' ||
    (SELECT count(*) FROM public.kf_production_order_write_receipts
      WHERE command_id IN (
        'c5100000-0000-4000-8000-000000000012',
        'c5100000-0000-4000-8000-000000000013'
      ));
")"
if [ "$race_counts" != "2:1" ]; then
  echo "Competing transitions persisted more than one logical winner."
  exit 1
fi

set +e
psql_safe \
  -f supabase/tests/knowledge_factory_production_order_write_rollback.sql \
  >"$work_dir/guarded-rollback.out" 2>"$work_dir/guarded-rollback.err"
guarded_rollback_status=$?
set -e
if [ "$guarded_rollback_status" -eq 0 ] \
  || ! grep -q 'Refusing Sublote 3B.5.3 rollback' "$work_dir/guarded-rollback.err"; then
  echo "Guarded rollback did not refuse to discard committed OPP receipts."
  exit 1
fi

# Restore a clean disposable database so the guarded rollback can prove that it
# never discards committed receipts. This cleanup is intentionally unavailable
# outside this explicit test script.
psql_safe >/dev/null <<'SQL'
DELETE FROM public.kf_production_order_write_receipts
WHERE command_id IN (
  'c5100000-0000-4000-8000-000000000001',
  'c5100000-0000-4000-8000-000000000002',
  'c5100000-0000-4000-8000-000000000011',
  'c5100000-0000-4000-8000-000000000012',
  'c5100000-0000-4000-8000-000000000013'
);

ALTER TABLE public.kf_production_order_events
  DISABLE TRIGGER kf_production_order_events_append_only;
DELETE FROM public.kf_production_order_events
WHERE opp_id IN (
  'd5100000-0000-4000-8000-000000000001',
  'd5100000-0000-4000-8000-000000000011'
);
ALTER TABLE public.kf_production_order_events
  ENABLE TRIGGER kf_production_order_events_append_only;

DELETE FROM public.kf_production_orders
WHERE id IN (
  'd5100000-0000-4000-8000-000000000001',
  'd5100000-0000-4000-8000-000000000011'
);
DELETE FROM public.kf_curriculum_packages
WHERE id = 'b5100000-0000-4000-8000-000000000001';
DELETE FROM auth.users
WHERE id = 'a5100000-0000-4000-8000-000000000001';
SQL

echo "Production order concurrency checks passed in the disposable database."
