#!/usr/bin/env bash
set -euo pipefail

: "${KF_DB_URL:?KF_DB_URL is required}"

psql "$KF_DB_URL" -v ON_ERROR_STOP=1 \
  -f supabase/tests/knowledge_factory_ingestion_c2_4_concurrency_setup.sql

payload_same='{"commandType":"begin_staging","actor":{"actorId":"c4000000-0000-4000-8000-000000000001","role":"system_worker"},"occurredAt":"2026-08-15T02:01:00.000Z","correlationId":"c5000000-0000-4000-8000-000000000003","reason":"same command concurrency","run":{"kind":"processing_run","id":"c1000000-0000-4000-8000-000000000003"},"expectedState":"REQUESTED","expectedSequence":1}'
fp_same="$(psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 -c "SELECT public.kf_ingestion_command_fingerprint_internal('begin_staging', '$payload_same'::jsonb);")"

pids=()
for i in 1 2; do
  psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 \
    -c "SELECT replayed FROM public.kf_ingestion_begin_staging('d3000000-0000-4000-8000-000000000002', '$fp_same', '$payload_same'::jsonb);" \
    >"/tmp/kf-c2-4-same-${i}.log" 2>&1 &
  pids+=("$!")
done
for pid in "${pids[@]}"; do wait "$pid"; done

same_results="$(cat /tmp/kf-c2-4-same-1.log /tmp/kf-c2-4-same-2.log | grep -E '^[tf]$' | sort | tr '\n' ' ')"
if [ "$same_results" != "f t " ]; then
  echo "Expected one applied and one replayed concurrent result; got: $same_results"
  exit 1
fi

psql "$KF_DB_URL" -v ON_ERROR_STOP=1 -c "DO \$\$
DECLARE v_receipts bigint; v_events bigint; v_state text; v_sequence bigint;
BEGIN
  SELECT count(*) INTO v_receipts FROM public.kf_ingestion_command_receipts
   WHERE command_id='d3000000-0000-4000-8000-000000000002';
  SELECT count(*) INTO v_events FROM public.kf_ingestion_events
   WHERE command_id='d3000000-0000-4000-8000-000000000002';
  SELECT state,sequence INTO v_state,v_sequence FROM public.kf_ingestion_runs
   WHERE run_id='c1000000-0000-4000-8000-000000000003';
  IF v_receipts<>1 OR v_events<>1 OR v_state<>'STAGING' OR v_sequence<>2 THEN
    RAISE EXCEPTION 'same-command concurrency invariant failed';
  END IF;
END \$\$;"

payload_diff='{"commandType":"begin_staging","actor":{"actorId":"c4000000-0000-4000-8000-000000000001","role":"system_worker"},"occurredAt":"2026-08-15T02:02:00.000Z","correlationId":"c5000000-0000-4000-8000-000000000004","reason":"different command concurrency","run":{"kind":"processing_run","id":"c1000000-0000-4000-8000-000000000004"},"expectedState":"REQUESTED","expectedSequence":1}'
fp_diff="$(psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 -c "SELECT public.kf_ingestion_command_fingerprint_internal('begin_staging', '$payload_diff'::jsonb);")"

pids=()
for command_id in d4000000-0000-4000-8000-000000000002 d4000000-0000-4000-8000-000000000003; do
  psql "$KF_DB_URL" -At -v ON_ERROR_STOP=1 \
    -c "SELECT replayed FROM public.kf_ingestion_begin_staging('$command_id', '$fp_diff', '$payload_diff'::jsonb);" \
    >"/tmp/kf-c2-4-diff-${command_id##*0}.log" 2>&1 &
  pids+=("$!")
done

failures=0
for pid in "${pids[@]}"; do
  if ! wait "$pid"; then failures=$((failures + 1)); fi
done
if [ "$failures" -ne 1 ]; then
  echo "Expected exactly one CAS loser for different commandIds; failures=$failures"
  exit 1
fi

psql "$KF_DB_URL" -v ON_ERROR_STOP=1 -c "DO \$\$
DECLARE v_receipts bigint; v_events bigint; v_state text; v_sequence bigint;
BEGIN
  SELECT count(*) INTO v_receipts FROM public.kf_ingestion_command_receipts
   WHERE command_id IN ('d4000000-0000-4000-8000-000000000002','d4000000-0000-4000-8000-000000000003');
  SELECT count(*) INTO v_events FROM public.kf_ingestion_events
   WHERE command_id IN ('d4000000-0000-4000-8000-000000000002','d4000000-0000-4000-8000-000000000003');
  SELECT state,sequence INTO v_state,v_sequence FROM public.kf_ingestion_runs
   WHERE run_id='c1000000-0000-4000-8000-000000000004';
  IF v_receipts<>1 OR v_events<>1 OR v_state<>'STAGING' OR v_sequence<>2 THEN
    RAISE EXCEPTION 'different-command concurrency invariant failed';
  END IF;
END \$\$;"

echo 'OK:knowledge_factory_ingestion_c2_4_concurrency'
