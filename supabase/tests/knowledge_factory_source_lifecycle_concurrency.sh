#!/usr/bin/env bash
# Knowledge Factory C.1.3 - real multi-session concurrency checks.
# NON-PRODUCTION ONLY. The target must be the canonical disposable DB CI database.

set -euo pipefail

: "${KF_DB_URL:?KF_DB_URL must point to the disposable Knowledge Factory database}"
if [ "$KF_DB_URL" != 'postgresql://postgres:postgres@127.0.0.1:54322/postgres' ]; then
  echo "Refusing C.1.3 concurrency checks outside the canonical disposable Supabase database."
  exit 1
fi

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

psql_safe() {
  psql "$KF_DB_URL" -v ON_ERROR_STOP=1 --no-psqlrc "$@"
}

wait_for_marker() {
  local file="$1" marker="$2" attempts=0
  until grep -q "$marker" "$file" 2>/dev/null; do
    attempts=$((attempts + 1))
    if [ "$attempts" -ge 120 ]; then
      echo "Timed out preparing C.1.3 concurrency barrier."
      return 1
    fi
    sleep 0.05
  done
}

call_rpc() {
  local rpc="$1" operation="$2" command_id="$3" payload="$4"
  psql_safe -At --set=VERBOSITY=verbose \
    --set=command_id="$command_id" --set=operation="$operation" --set=payload="$payload" <<SQL
BEGIN;
SET LOCAL ROLE service_role;
WITH input AS (SELECT :'payload'::jsonb AS payload)
SELECT result.replayed
FROM input
CROSS JOIN LATERAL public.${rpc}(
  :'command_id'::uuid,
  encode(
    sha256(
      convert_to(
        jsonb_build_object(
          'fingerprintVersion',1,
          'operation',:'operation',
          'payload',input.payload
        )::text,
        'UTF8'
      )
    ),
    'hex'
  ),
  input.payload
) AS result;
COMMIT;
SQL
}

registration_state() {
  psql_safe -AtF '|' -c "SELECT projected_state,aggregate_version,sequence FROM public.kf_source_registration_projections WHERE subject_identity_id='$1';"
}

authorization_state() {
  psql_safe -AtF '|' -c "SELECT projected_state,aggregate_version,sequence FROM public.kf_source_authorizations WHERE id='$1';"
}

register_payload() {
  printf '{"commandType":"register_identity","actor":{"actorId":"75410000-0000-4000-8000-000000000001","role":"curator"},"subject":{"id":"%s","kind":"%s"},"occurredAt":"%s","effectiveAt":"%s","correlationId":"%s","reason":"%s"}' "$1" "$2" "$3" "$3" "$4" "$5"
}

request_payload() {
  printf '{"commandType":"request_validation","actor":{"actorId":"75410000-0000-4000-8000-000000000001","role":"curator"},"subject":{"id":"%s","kind":"%s"},"expectedState":"%s","expectedVersion":"%s","expectedSequence":%s,"occurredAt":"%s","effectiveAt":"%s","correlationId":"%s","reason":"%s"}' "$1" "$2" "$3" "$4" "$5" "$6" "$6" "$7" "$8"
}

confirm_payload() {
  printf '{"commandType":"confirm_validation","actor":{"actorId":"75410000-0000-4000-8000-000000000001","role":"curator"},"subject":{"id":"%s","kind":"%s"},"expectedState":"%s","expectedVersion":"%s","expectedSequence":%s,"occurredAt":"%s","effectiveAt":"%s","correlationId":"%s","reason":"%s"}' "$1" "$2" "$3" "$4" "$5" "$6" "$6" "$7" "$8"
}

block_payload() {
  printf '{"commandType":"block_source","actor":{"actorId":"75410000-0000-4000-8000-000000000001","role":"curator"},"subject":{"id":"%s","kind":"%s"},"expectedState":"%s","expectedVersion":"%s","expectedSequence":%s,"occurredAt":"%s","effectiveAt":"%s","correlationId":"%s","reason":"%s"}' "$1" "$2" "$3" "$4" "$5" "$6" "$6" "$7" "$8"
}

grant_payload() {
  printf '{"commandType":"grant_authorization","actor":{"actorId":"75410000-0000-4000-8000-000000000002","role":"legal_editorial_reviewer"},"authorizationId":"%s","scope":{"subject":{"id":"%s","kind":"source_version"},"purpose":"%s"},"basis":{"id":"%s","kind":"wrtech_ownership"},"effectiveFrom":"%s","occurredAt":"%s","effectiveAt":"%s","correlationId":"%s","reason":"%s"}' "$1" "$2" "$3" "$4" "$5" "$5" "$5" "$6" "$7"
}

auth_transition_payload() {
  printf '{"commandType":"%s","actor":{"actorId":"75410000-0000-4000-8000-000000000002","role":"legal_editorial_reviewer"},"authorizationId":"%s","scope":{"subject":{"id":"%s","kind":"source_version"},"purpose":"%s"},"basis":{"id":"%s","kind":"wrtech_ownership"},"expectedState":"%s","expectedVersion":"%s","expectedSequence":%s,"occurredAt":"%s","effectiveAt":"%s","correlationId":"%s","reason":"%s"}' "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$9" "${10}" "${11}"
}

supersede_payload() {
  printf '{"commandType":"supersede_authorization","actor":{"actorId":"75410000-0000-4000-8000-000000000002","role":"legal_editorial_reviewer"},"authorizationId":"%s","successorAuthorizationId":"%s","scope":{"subject":{"id":"%s","kind":"source_version"},"purpose":"generation"},"basis":{"id":"%s","kind":"open_license","referenceDigest":"%s"},"effectiveFrom":"%s","expectedState":"%s","expectedVersion":"%s","expectedSequence":%s,"occurredAt":"%s","effectiveAt":"%s","correlationId":"%s","reason":"%s"}' "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}" "${10}" "${11}" "${12}"
}

impact_payload() {
  printf '{"commandType":"open_impact_assessment","actor":{"actorId":"75410000-0000-4000-8000-000000000001","role":"curator"},"subject":{"id":"%s","kind":"%s"},"occurredAt":"%s","effectiveAt":"%s","correlationId":"%s","reason":"%s"}' "$1" "$2" "$3" "$3" "$4" "$5"
}

register_only() {
  local subject="$1" kind="$2" command="$3" time="$4" correlation="$5"
  call_rpc kf_source_register_identity register_identity "$command" \
    "$(register_payload "$subject" "$kind" "$time" "$correlation" 'concurrency fixture register')" >/dev/null
}

register_and_validate() {
  local subject="$1" c1="$2" c2="$3" c3="$4" base_minute="$5"
  register_only "$subject" source_version "$c1" "2026-08-14T17:${base_minute}:00Z" "75430000-0000-4000-8000-${c1##*-}"
  IFS='|' read -r state version sequence <<<"$(registration_state "$subject")"
  call_rpc kf_source_request_validation request_validation "$c2" \
    "$(request_payload "$subject" source_version "$state" "$version" "$sequence" "2026-08-14T17:${base_minute}:10Z" "75430000-0000-4000-8000-${c2##*-}" 'concurrency fixture request')" >/dev/null
  IFS='|' read -r state version sequence <<<"$(registration_state "$subject")"
  call_rpc kf_source_confirm_validation confirm_validation "$c3" \
    "$(confirm_payload "$subject" source_version "$state" "$version" "$sequence" "2026-08-14T17:${base_minute}:20Z" "75430000-0000-4000-8000-${c3##*-}" 'concurrency fixture confirm')" >/dev/null
}

expect_one_success_one_pt409() {
  local pid_a="$1" pid_b="$2" err_a="$3" err_b="$4" label="$5"
  local status_a status_b loser
  set +e
  wait "$pid_a"; status_a=$?
  wait "$pid_b"; status_b=$?
  set -e
  if ! { [ "$status_a" -eq 0 ] && [ "$status_b" -ne 0 ]; } \
    && ! { [ "$status_a" -ne 0 ] && [ "$status_b" -eq 0 ]; }; then
    echo "$label did not produce exactly one winner."
    exit 1
  fi
  if [ "$status_a" -ne 0 ]; then loser="$err_a"; else loser="$err_b"; fi
  if ! grep -q 'PT409' "$loser"; then
    echo "$label loser did not fail with PT409."
    exit 1
  fi
}

# Runtime competence fixtures.
psql_safe >/dev/null <<'SQL'
INSERT INTO public.kf_source_actor_assignments(id,actor_id,actor_role,effective_from)
VALUES
 ('75400000-0000-4000-8000-000000000001','75410000-0000-4000-8000-000000000001','curator','2026-08-14T00:00:00Z'),
 ('75400000-0000-4000-8000-000000000002','75410000-0000-4000-8000-000000000002','legal_editorial_reviewer','2026-08-14T00:00:00Z');
SQL

# ---------------------------------------------------------------------------
# 1. Two different command IDs using the same expectedVersion/expectedSequence.
# ---------------------------------------------------------------------------
s1='75420000-0000-4000-8000-000000000001'
register_only "$s1" work '75440000-0000-4000-8000-000000000001' '2026-08-14T17:01:00Z' '75430000-0000-4000-8000-000000000001'
IFS='|' read -r state version sequence <<<"$(registration_state "$s1")"
payload_a="$(request_payload "$s1" work "$state" "$version" "$sequence" '2026-08-14T17:01:10Z' '75430000-0000-4000-8000-000000000002' 'same expectation writer A')"
payload_b="$(request_payload "$s1" work "$state" "$version" "$sequence" '2026-08-14T17:01:10Z' '75430000-0000-4000-8000-000000000003' 'same expectation writer B')"
call_rpc kf_source_request_validation request_validation '75440000-0000-4000-8000-000000000002' "$payload_a" >"$work_dir/s1a.out" 2>"$work_dir/s1a.err" & p1=$!
call_rpc kf_source_request_validation request_validation '75440000-0000-4000-8000-000000000003' "$payload_b" >"$work_dir/s1b.out" 2>"$work_dir/s1b.err" & p2=$!
expect_one_success_one_pt409 "$p1" "$p2" "$work_dir/s1a.err" "$work_dir/s1b.err" 'same-expectation race'

# ---------------------------------------------------------------------------
# 2. Simultaneous replay of the same commandId/fingerprint.
# ---------------------------------------------------------------------------
s2='75420000-0000-4000-8000-000000000002'
register_only "$s2" work '75440000-0000-4000-8000-000000000010' '2026-08-14T17:02:00Z' '75430000-0000-4000-8000-000000000010'
IFS='|' read -r state version sequence <<<"$(registration_state "$s2")"
same_cmd='75440000-0000-4000-8000-000000000011'
same_payload="$(request_payload "$s2" work "$state" "$version" "$sequence" '2026-08-14T17:02:10Z' '75430000-0000-4000-8000-000000000011' 'same command replay race')"
psql_safe -At >"$work_dir/cmd-barrier.out" 2>&1 <<SQL &
BEGIN;
SELECT pg_advisory_xact_lock(hashtextextended('command:$same_cmd',0));
SELECT 'C13_COMMAND_LOCK_READY';
SELECT pg_sleep(2);
COMMIT;
SQL
barrier=$!
wait_for_marker "$work_dir/cmd-barrier.out" 'C13_COMMAND_LOCK_READY'
call_rpc kf_source_request_validation request_validation "$same_cmd" "$same_payload" >"$work_dir/s2a.out" 2>"$work_dir/s2a.err" & p1=$!
call_rpc kf_source_request_validation request_validation "$same_cmd" "$same_payload" >"$work_dir/s2b.out" 2>"$work_dir/s2b.err" & p2=$!
wait "$p1"; wait "$p2"; wait "$barrier"
results="$(grep -E '^[ft]$' "$work_dir/s2a.out" "$work_dir/s2b.out" | sed 's/^.*://' | sort | tr '\n' ' ')"
if [ "$results" != 'f t ' ]; then echo 'same-command race did not produce one commit and one replay'; exit 1; fi

# ---------------------------------------------------------------------------
# 3. Same commandId with different fingerprints: one commit, one conflict.
# ---------------------------------------------------------------------------
s3='75420000-0000-4000-8000-000000000003'
register_only "$s3" work '75440000-0000-4000-8000-000000000020' '2026-08-14T17:03:00Z' '75430000-0000-4000-8000-000000000020'
IFS='|' read -r state version sequence <<<"$(registration_state "$s3")"
diff_cmd='75440000-0000-4000-8000-000000000021'
payload_a="$(request_payload "$s3" work "$state" "$version" "$sequence" '2026-08-14T17:03:10Z' '75430000-0000-4000-8000-000000000021' 'fingerprint A')"
payload_b="$(request_payload "$s3" work "$state" "$version" "$sequence" '2026-08-14T17:03:10Z' '75430000-0000-4000-8000-000000000022' 'fingerprint B')"
call_rpc kf_source_request_validation request_validation "$diff_cmd" "$payload_a" >"$work_dir/s3a.out" 2>"$work_dir/s3a.err" & p1=$!
call_rpc kf_source_request_validation request_validation "$diff_cmd" "$payload_b" >"$work_dir/s3b.out" 2>"$work_dir/s3b.err" & p2=$!
expect_one_success_one_pt409 "$p1" "$p2" "$work_dir/s3a.err" "$work_dir/s3b.err" 'same-command divergent-fingerprint race'

# ---------------------------------------------------------------------------
# 4. Two different operations share the same state expectation.
# ---------------------------------------------------------------------------
s4='75420000-0000-4000-8000-000000000004'
register_only "$s4" work '75440000-0000-4000-8000-000000000030' '2026-08-14T17:04:00Z' '75430000-0000-4000-8000-000000000030'
IFS='|' read -r state version sequence <<<"$(registration_state "$s4")"
payload_a="$(request_payload "$s4" work "$state" "$version" "$sequence" '2026-08-14T17:04:10Z' '75430000-0000-4000-8000-000000000031' 'request wins or loses')"
payload_b="$(block_payload "$s4" work "$state" "$version" "$sequence" '2026-08-14T17:04:10Z' '75430000-0000-4000-8000-000000000032' 'block wins or loses')"
call_rpc kf_source_request_validation request_validation '75440000-0000-4000-8000-000000000031' "$payload_a" >"$work_dir/s4a.out" 2>"$work_dir/s4a.err" & p1=$!
call_rpc kf_source_block block_source '75440000-0000-4000-8000-000000000032' "$payload_b" >"$work_dir/s4b.out" 2>"$work_dir/s4b.err" & p2=$!
expect_one_success_one_pt409 "$p1" "$p2" "$work_dir/s4a.err" "$work_dir/s4b.err" 'different-operation same-state race'

# ---------------------------------------------------------------------------
# 5. Two supersessions race on the same predecessor.
# ---------------------------------------------------------------------------
s5='75420000-0000-4000-8000-000000000005'
register_and_validate "$s5" '75440000-0000-4000-8000-000000000040' '75440000-0000-4000-8000-000000000041' '75440000-0000-4000-8000-000000000042' '05'
pred='75450000-0000-4000-8000-000000000001'
call_rpc kf_source_grant_authorization grant_authorization '75440000-0000-4000-8000-000000000043' "$(grant_payload "$pred" "$s5" retrieval '75460000-0000-4000-8000-000000000001' '2026-08-14T17:05:30Z' '75430000-0000-4000-8000-000000000043' 'grant predecessor for supersession race')" >/dev/null
IFS='|' read -r state version sequence <<<"$(authorization_state "$pred")"
payload_a="$(supersede_payload "$pred" '75450000-0000-4000-8000-000000000002' "$s5" '75460000-0000-4000-8000-000000000002' 'supersession-A' '2026-08-14T17:05:40Z' "$state" "$version" "$sequence" '2026-08-14T17:05:40Z' '75430000-0000-4000-8000-000000000044' 'supersession A')"
payload_b="$(supersede_payload "$pred" '75450000-0000-4000-8000-000000000003' "$s5" '75460000-0000-4000-8000-000000000003' 'supersession-B' '2026-08-14T17:05:40Z' "$state" "$version" "$sequence" '2026-08-14T17:05:40Z' '75430000-0000-4000-8000-000000000045' 'supersession B')"
call_rpc kf_source_supersede_authorization supersede_authorization '75440000-0000-4000-8000-000000000044' "$payload_a" >"$work_dir/s5a.out" 2>"$work_dir/s5a.err" & p1=$!
call_rpc kf_source_supersede_authorization supersede_authorization '75440000-0000-4000-8000-000000000045' "$payload_b" >"$work_dir/s5b.out" 2>"$work_dir/s5b.err" & p2=$!
expect_one_success_one_pt409 "$p1" "$p2" "$work_dir/s5a.err" "$work_dir/s5b.err" 'supersession race'
succ_count="$(psql_safe -Atc "SELECT count(*) FROM public.kf_source_authorizations WHERE id IN ('75450000-0000-4000-8000-000000000002','75450000-0000-4000-8000-000000000003');")"
if [ "$succ_count" != '1' ]; then echo 'supersession race created an invalid number of successors'; exit 1; fi

# ---------------------------------------------------------------------------
# 6. Grant races with a registral block of its subject.
# ---------------------------------------------------------------------------
s6='75420000-0000-4000-8000-000000000006'
register_and_validate "$s6" '75440000-0000-4000-8000-000000000050' '75440000-0000-4000-8000-000000000051' '75440000-0000-4000-8000-000000000052' '06'
IFS='|' read -r state version sequence <<<"$(registration_state "$s6")"
grant_payload_s6="$(grant_payload '75450000-0000-4000-8000-000000000010' "$s6" retrieval '75460000-0000-4000-8000-000000000010' '2026-08-14T17:06:40Z' '75430000-0000-4000-8000-000000000053' 'grant racing registral block')"
block_payload_s6="$(block_payload "$s6" source_version "$state" "$version" "$sequence" '2026-08-14T17:06:40Z' '75430000-0000-4000-8000-000000000054' 'registral block racing grant')"
call_rpc kf_source_grant_authorization grant_authorization '75440000-0000-4000-8000-000000000053' "$grant_payload_s6" >"$work_dir/s6grant.out" 2>"$work_dir/s6grant.err" & p1=$!
call_rpc kf_source_block block_source '75440000-0000-4000-8000-000000000054' "$block_payload_s6" >"$work_dir/s6block.out" 2>"$work_dir/s6block.err" & p2=$!
set +e
wait "$p1"; grant_status=$?
wait "$p2"; block_status=$?
set -e
if [ "$block_status" -ne 0 ]; then echo 'registral block unexpectedly lost grant/block serialization'; cat "$work_dir/s6block.err"; exit 1; fi
if [ "$grant_status" -ne 0 ] && ! grep -q 'PT409' "$work_dir/s6grant.err"; then echo 'grant/block loser did not fail with PT409'; exit 1; fi
final_s6="$(psql_safe -Atc "SELECT projected_state FROM public.kf_source_registration_projections WHERE subject_identity_id='$s6';")"
if [ "$final_s6" != 'BLOCKED' ]; then echo 'grant/block race did not finish with registrally blocked subject'; exit 1; fi

# ---------------------------------------------------------------------------
# 7. Two authorization decisions race on the same aggregate.
# ---------------------------------------------------------------------------
s7='75420000-0000-4000-8000-000000000007'
register_and_validate "$s7" '75440000-0000-4000-8000-000000000060' '75440000-0000-4000-8000-000000000061' '75440000-0000-4000-8000-000000000062' '07'
auth7='75450000-0000-4000-8000-000000000020'
basis7='75460000-0000-4000-8000-000000000020'
call_rpc kf_source_grant_authorization grant_authorization '75440000-0000-4000-8000-000000000063' "$(grant_payload "$auth7" "$s7" retrieval "$basis7" '2026-08-14T17:07:30Z' '75430000-0000-4000-8000-000000000063' 'grant for authorization race')" >/dev/null
IFS='|' read -r state version sequence <<<"$(authorization_state "$auth7")"
payload_a="$(auth_transition_payload suspend_authorization "$auth7" "$s7" retrieval "$basis7" "$state" "$version" "$sequence" '2026-08-14T17:07:40Z' '75430000-0000-4000-8000-000000000064' 'suspend race')"
payload_b="$(auth_transition_payload revoke_authorization "$auth7" "$s7" retrieval "$basis7" "$state" "$version" "$sequence" '2026-08-14T17:07:40Z' '75430000-0000-4000-8000-000000000065' 'revoke race')"
call_rpc kf_source_suspend_authorization suspend_authorization '75440000-0000-4000-8000-000000000064' "$payload_a" >"$work_dir/s7a.out" 2>"$work_dir/s7a.err" & p1=$!
call_rpc kf_source_revoke_authorization revoke_authorization '75440000-0000-4000-8000-000000000065' "$payload_b" >"$work_dir/s7b.out" 2>"$work_dir/s7b.err" & p2=$!
expect_one_success_one_pt409 "$p1" "$p2" "$work_dir/s7a.err" "$work_dir/s7b.err" 'authorization decision race'

# ---------------------------------------------------------------------------
# 8. Two explicit impact events on the same subject serialize by impact lock.
# ---------------------------------------------------------------------------
s8='75420000-0000-4000-8000-000000000008'
register_only "$s8" manifestation '75440000-0000-4000-8000-000000000070' '2026-08-14T17:08:00Z' '75430000-0000-4000-8000-000000000070'
payload_a="$(impact_payload "$s8" manifestation '2026-08-14T17:08:10Z' '75430000-0000-4000-8000-000000000071' 'impact race A')"
payload_b="$(impact_payload "$s8" manifestation '2026-08-14T17:08:10Z' '75430000-0000-4000-8000-000000000072' 'impact race B')"
call_rpc kf_source_open_impact_assessment open_impact_assessment '75440000-0000-4000-8000-000000000071' "$payload_a" >"$work_dir/s8a.out" 2>"$work_dir/s8a.err" & p1=$!
call_rpc kf_source_open_impact_assessment open_impact_assessment '75440000-0000-4000-8000-000000000072' "$payload_b" >"$work_dir/s8b.out" 2>"$work_dir/s8b.err" & p2=$!
wait "$p1"; wait "$p2"
impact_sequences="$(psql_safe -Atc "SELECT string_agg(sequence::text,',' ORDER BY sequence) FROM public.kf_source_governance_events WHERE dimension='impact' AND aggregate_id='$s8';")"
if [ "$impact_sequences" != '1,2' ]; then echo "impact race produced invalid sequence set: $impact_sequences"; exit 1; fi

# Guarded C.1.3 rollback must refuse to discard active actor assignments.
set +e
psql_safe -f supabase/tests/knowledge_factory_source_lifecycle_command_rollback.sql >"$work_dir/guard.out" 2>"$work_dir/guard.err"
guard_status=$?
set -e
if [ "$guard_status" -eq 0 ] || ! grep -q 'Refusing destructive C.1.3 rollback' "$work_dir/guard.err"; then
  echo 'C.1.3 guarded rollback did not refuse active assignment data.'
  exit 1
fi

# Explicit disposable cleanup. These deletes are intentionally unavailable to
# runtime roles and exist only to restore the shared CI database after real
# multi-session commits.
psql_safe >/dev/null <<'SQL'
ALTER TABLE public.kf_source_command_receipt_events DISABLE TRIGGER kf_source_command_receipt_events_append_only;
DELETE FROM public.kf_source_command_receipt_events WHERE command_id::text LIKE '7544%';
ALTER TABLE public.kf_source_command_receipt_events ENABLE TRIGGER kf_source_command_receipt_events_append_only;

ALTER TABLE public.kf_source_governance_events DISABLE TRIGGER kf_source_governance_events_append_only;
DELETE FROM public.kf_source_governance_events WHERE command_id::text LIKE '7544%';
ALTER TABLE public.kf_source_governance_events ENABLE TRIGGER kf_source_governance_events_append_only;

ALTER TABLE public.kf_source_command_receipts DISABLE TRIGGER kf_source_command_receipts_append_only;
DELETE FROM public.kf_source_command_receipts WHERE command_id::text LIKE '7544%';
ALTER TABLE public.kf_source_command_receipts ENABLE TRIGGER kf_source_command_receipts_append_only;

DELETE FROM public.kf_source_authorizations WHERE id::text LIKE '7545%';
DELETE FROM public.kf_source_registration_projections WHERE subject_identity_id::text LIKE '7542%';

ALTER TABLE public.kf_source_authorization_bases DISABLE TRIGGER kf_source_authorization_bases_append_only;
DELETE FROM public.kf_source_authorization_bases WHERE id::text LIKE '7546%';
ALTER TABLE public.kf_source_authorization_bases ENABLE TRIGGER kf_source_authorization_bases_append_only;

ALTER TABLE public.kf_source_identities DISABLE TRIGGER kf_source_identities_append_only;
DELETE FROM public.kf_source_identities WHERE id::text LIKE '7542%';
ALTER TABLE public.kf_source_identities ENABLE TRIGGER kf_source_identities_append_only;

DELETE FROM public.kf_source_actor_assignments WHERE id::text LIKE '7540%';
SQL

echo 'C.1.3 source lifecycle concurrency checks passed in the disposable database.'
