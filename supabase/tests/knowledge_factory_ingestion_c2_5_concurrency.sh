#!/usr/bin/env bash
set -euo pipefail

: "${KF_DB_URL:?KF_DB_URL is required}"

psql "$KF_DB_URL" -v ON_ERROR_STOP=1 \
  -f supabase/tests/knowledge_factory_ingestion_c2_5_concurrency_setup.sql

# Same commandId + same fingerprint under simultaneous request_review: one
# transaction applies and the other returns the same committed receipt as replay.
payload_same='{"commandType":"request_review","actor":{"actorId":"c4000000-0000-4000-8000-000000000001","role":"system_worker"},"occurredAt":"2026-08-15T02:07:00.000Z","correlationId":"c5000000-0000-4000-8000-000000000071","reason":"same request_review concurrency","run":{"kind":"processing_run","id":"c1000000-0000-4000-8000-000000000007"},"expectedState":"VERIFIED","expectedVersion":"same-review-v5","expectedSequence":5}'
fp_same="$(psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 -c "SELECT public.kf_ingestion_command_fingerprint_internal('request_review', '$payload_same'::jsonb);")"

pids=()
for i in 1 2; do
  psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 \
    -c "SELECT replayed FROM public.kf_ingestion_request_review('d7000000-0000-4000-8000-000000000071', '$fp_same', '$payload_same'::jsonb);" \
    >"/tmp/kf-c2-5-same-${i}.log" 2>&1 &
  pids+=("$!")
done
for pid in "${pids[@]}"; do wait "$pid"; done

same_results="$(cat /tmp/kf-c2-5-same-1.log /tmp/kf-c2-5-same-2.log | grep -E '^[tf]$' | sort | tr '\n' ' ')"
if [ "$same_results" != "f t " ]; then
  echo "Expected one applied and one replayed C.2.5 result; got: $same_results"
  exit 1
fi

psql "$KF_DB_URL" -v ON_ERROR_STOP=1 -c "DO \$\$
DECLARE v_receipts bigint; v_events bigint; v_state text; v_sequence bigint;
BEGIN
  SELECT count(*) INTO v_receipts FROM public.kf_ingestion_command_receipts
   WHERE command_id='d7000000-0000-4000-8000-000000000071';
  SELECT count(*) INTO v_events FROM public.kf_ingestion_events
   WHERE command_id='d7000000-0000-4000-8000-000000000071';
  SELECT state,sequence INTO v_state,v_sequence FROM public.kf_ingestion_runs
   WHERE run_id='c1000000-0000-4000-8000-000000000007';
  IF v_receipts<>1 OR v_events<>1 OR v_state<>'PENDING_REVIEW' OR v_sequence<>6 THEN
    RAISE EXCEPTION 'same-command C.2.5 concurrency invariant failed';
  END IF;
END \$\$;"

# Two different commandIds race on the same PENDING_REVIEW snapshot: approve
# and reject cannot both win because the durable row lock + CAS serializes them.
payload_approve='{"commandType":"approve_for_extraction","actor":{"actorId":"c4100000-0000-4000-8000-000000000001","role":"legal_editorial_reviewer"},"occurredAt":"2026-08-15T02:10:00.000Z","correlationId":"c5000000-0000-4000-8000-000000000081","reason":"concurrent approve","run":{"kind":"processing_run","id":"c1000000-0000-4000-8000-000000000008"},"expectedState":"PENDING_REVIEW","expectedVersion":"decision-race-v6","expectedSequence":6,"sourceVersion":{"kind":"source_version","id":"c2000000-0000-4000-8000-000000000001"},"review":{"reviewId":"c8000000-0000-4000-8000-000000000081","reviewMode":"human","reviewer":{"actorId":"c4100000-0000-4000-8000-000000000001","role":"legal_editorial_reviewer"},"decision":"APPROVE_FOR_EXTRACTION","decidedAt":"2026-08-15T02:10:00.000Z","reason":"concurrent human approve"},"authorizationEvidence":[{"authorizationId":"cf000000-0000-4000-8000-000000000005","sourceVersion":{"kind":"source_version","id":"c2000000-0000-4000-8000-000000000001"},"purpose":"extraction","evaluatedAt":"2026-08-15T02:10:00.000Z"}]}'
payload_reject='{"commandType":"reject_ingestion","actor":{"actorId":"c4100000-0000-4000-8000-000000000001","role":"legal_editorial_reviewer"},"occurredAt":"2026-08-15T02:10:00.000Z","correlationId":"c5000000-0000-4000-8000-000000000082","reason":"concurrent reject","run":{"kind":"processing_run","id":"c1000000-0000-4000-8000-000000000008"},"expectedState":"PENDING_REVIEW","expectedVersion":"decision-race-v6","expectedSequence":6,"reasonCode":"human_review_rejected","review":{"reviewId":"c8000000-0000-4000-8000-000000000082","reviewMode":"human","reviewer":{"actorId":"c4100000-0000-4000-8000-000000000001","role":"legal_editorial_reviewer"},"decision":"REJECT","decidedAt":"2026-08-15T02:10:00.000Z","reason":"concurrent human reject"}}'
fp_approve="$(psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 -c "SELECT public.kf_ingestion_command_fingerprint_internal('approve_for_extraction', '$payload_approve'::jsonb);")"
fp_reject="$(psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 -c "SELECT public.kf_ingestion_command_fingerprint_internal('reject_ingestion', '$payload_reject'::jsonb);")"

psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 \
  -c "SELECT state FROM public.kf_ingestion_approve_for_extraction('d8000000-0000-4000-8000-000000000081', '$fp_approve', '$payload_approve'::jsonb);" \
  >"/tmp/kf-c2-5-approve-race.log" 2>&1 &
pid_approve="$!"
psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 \
  -c "SELECT state FROM public.kf_ingestion_reject('d8000000-0000-4000-8000-000000000082', '$fp_reject', '$payload_reject'::jsonb);" \
  >"/tmp/kf-c2-5-reject-race.log" 2>&1 &
pid_reject="$!"

failures=0
if ! wait "$pid_approve"; then failures=$((failures + 1)); fi
if ! wait "$pid_reject"; then failures=$((failures + 1)); fi
if [ "$failures" -ne 1 ]; then
  echo "Expected exactly one approve/reject CAS loser; failures=$failures"
  cat /tmp/kf-c2-5-approve-race.log /tmp/kf-c2-5-reject-race.log
  exit 1
fi

psql "$KF_DB_URL" -v ON_ERROR_STOP=1 -c "DO \$\$
DECLARE v_receipts bigint; v_events bigint; v_state text; v_sequence bigint;
BEGIN
  SELECT count(*) INTO v_receipts FROM public.kf_ingestion_command_receipts
   WHERE command_id IN ('d8000000-0000-4000-8000-000000000081','d8000000-0000-4000-8000-000000000082');
  SELECT count(*) INTO v_events FROM public.kf_ingestion_events
   WHERE command_id IN ('d8000000-0000-4000-8000-000000000081','d8000000-0000-4000-8000-000000000082');
  SELECT state,sequence INTO v_state,v_sequence FROM public.kf_ingestion_runs
   WHERE run_id='c1000000-0000-4000-8000-000000000008';
  IF v_receipts<>1 OR v_events<>1 OR v_sequence<>7
    OR v_state NOT IN ('APPROVED_FOR_EXTRACTION','REJECTED') THEN
    RAISE EXCEPTION 'approve/reject race produced an invalid terminal projection';
  END IF;
  IF v_state='APPROVED_FOR_EXTRACTION' AND NOT EXISTS (
    SELECT 1 FROM public.kf_ingestion_events
    WHERE run_id='c1000000-0000-4000-8000-000000000008'
      AND sequence=7 AND extraction_authorization_id='cf000000-0000-4000-8000-000000000005'
  ) THEN
    RAISE EXCEPTION 'approval race winner lacks independent extraction authorization evidence';
  END IF;
END \$\$;"

rm -f /tmp/kf-c2-5-same-1.log /tmp/kf-c2-5-same-2.log \
  /tmp/kf-c2-5-approve-race.log /tmp/kf-c2-5-reject-race.log

echo 'OK:knowledge_factory_ingestion_c2_5_concurrency'