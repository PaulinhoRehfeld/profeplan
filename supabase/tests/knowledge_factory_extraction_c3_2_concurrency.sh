#!/usr/bin/env bash
set -euo pipefail

: "${KF_DB_URL:?KF_DB_URL is required}"

RUN_ID='e1000000-0000-4000-8000-000000000005'
SOURCE_VERSION_ID="$(psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 -c \
  "select source_version_id from public.kf_extraction_runs where run_id='${RUN_ID}'::uuid")"
VERSION="$(psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 -c \
  "select aggregate_version from public.kf_extraction_runs where run_id='${RUN_ID}'::uuid")"
SEQUENCE="$(psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 -c \
  "select sequence from public.kf_extraction_runs where run_id='${RUN_ID}'::uuid")"

if [[ -z "$SOURCE_VERSION_ID" || "$VERSION" != 'concurrency-v2' || "$SEQUENCE" != '2' ]]; then
  echo 'C.3.2 concurrency fixture is not READY at the expected version/sequence.' >&2
  exit 1
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

cat >"$TMP_DIR/begin.sql" <<SQL
\\set ON_ERROR_STOP on
WITH command AS (
  SELECT jsonb_build_object(
    'commandType','begin_extraction',
    'actor',jsonb_build_object(
      'actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'
    ),
    'occurredAt','2026-08-15T02:21:00.000Z',
    'correlationId','e5000000-0000-4000-8000-000000000005',
    'reason','concurrent claim candidate',
    'run',jsonb_build_object('kind','extraction_run','id','$RUN_ID'),
    'expectedState','READY','expectedVersion','$VERSION','expectedSequence',$SEQUENCE,
    'authorizationEvidence',jsonb_build_object(
      'authorizationId','cf000000-0000-4000-8000-000000000005',
      'sourceVersion',jsonb_build_object('kind','source_version','id','$SOURCE_VERSION_ID'),
      'purpose','extraction','checkpoint','claim','evaluatedAt','2026-08-15T02:21:00.000Z'
    )
  ) AS payload
)
SELECT result.*
FROM command
CROSS JOIN LATERAL public.kf_extraction_begin(
  'e7000000-0000-4000-8000-000000000022',
  public.kf_extraction_command_fingerprint_internal('begin_extraction',command.payload),
  command.payload
) AS result;
SQL

cat >"$TMP_DIR/cancel.sql" <<SQL
\\set ON_ERROR_STOP on
WITH command AS (
  SELECT jsonb_build_object(
    'commandType','cancel_extraction',
    'actor',jsonb_build_object(
      'actorId','c4000000-0000-4000-8000-000000000001','role','system_worker'
    ),
    'occurredAt','2026-08-15T02:21:00.000Z',
    'correlationId','e5000000-0000-4000-8000-000000000005',
    'reason','concurrent cancellation candidate',
    'run',jsonb_build_object('kind','extraction_run','id','$RUN_ID'),
    'expectedState','READY','expectedVersion','$VERSION','expectedSequence',$SEQUENCE,
    'reasonCode','operator_cancelled'
  ) AS payload
)
SELECT result.*
FROM command
CROSS JOIN LATERAL public.kf_extraction_cancel(
  'e7000000-0000-4000-8000-000000000023',
  public.kf_extraction_command_fingerprint_internal('cancel_extraction',command.payload),
  command.payload
) AS result;
SQL

set +e
psql "$KF_DB_URL" -v ON_ERROR_STOP=1 -f "$TMP_DIR/begin.sql" >"$TMP_DIR/begin.log" 2>&1 &
PID_BEGIN=$!
psql "$KF_DB_URL" -v ON_ERROR_STOP=1 -f "$TMP_DIR/cancel.sql" >"$TMP_DIR/cancel.log" 2>&1 &
PID_CANCEL=$!
wait "$PID_BEGIN"
STATUS_BEGIN=$?
wait "$PID_CANCEL"
STATUS_CANCEL=$?
set -e

SUCCESS_COUNT=0
[[ "$STATUS_BEGIN" -eq 0 ]] && SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
[[ "$STATUS_CANCEL" -eq 0 ]] && SUCCESS_COUNT=$((SUCCESS_COUNT + 1))

if [[ "$SUCCESS_COUNT" -ne 1 ]]; then
  echo "Expected exactly one concurrent winner; begin=$STATUS_BEGIN cancel=$STATUS_CANCEL" >&2
  cat "$TMP_DIR/begin.log" >&2
  cat "$TMP_DIR/cancel.log" >&2
  exit 1
fi

LOSER_LOG="$TMP_DIR/begin.log"
[[ "$STATUS_BEGIN" -eq 0 ]] && LOSER_LOG="$TMP_DIR/cancel.log"
if ! grep -Eq 'PT409|stale extraction state/version/sequence|CAS lost concurrent transition' "$LOSER_LOG"; then
  echo 'Concurrent loser did not fail through the expected closed CAS path.' >&2
  cat "$LOSER_LOG" >&2
  exit 1
fi

STATE="$(psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 -c \
  "select state from public.kf_extraction_runs where run_id='${RUN_ID}'::uuid")"
FINAL_SEQUENCE="$(psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 -c \
  "select sequence from public.kf_extraction_runs where run_id='${RUN_ID}'::uuid")"
RECEIPTS="$(psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 -c \
  "select count(*) from public.kf_extraction_command_receipts where run_id='${RUN_ID}'::uuid")"
EVENTS="$(psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 -c \
  "select count(*) from public.kf_extraction_events where run_id='${RUN_ID}'::uuid")"

if [[ "$STATE" != 'EXTRACTING' && "$STATE" != 'CANCELLED' ]]; then
  echo "Unexpected concurrent winner state: $STATE" >&2
  exit 1
fi
if [[ "$FINAL_SEQUENCE" != '3' || "$RECEIPTS" != '3' || "$EVENTS" != '3' ]]; then
  echo "Concurrent C.3.2 projection/history mismatch: seq=$FINAL_SEQUENCE receipts=$RECEIPTS events=$EVENTS" >&2
  exit 1
fi

echo "C.3.2 concurrent CAS proof passed; winner state=$STATE"
