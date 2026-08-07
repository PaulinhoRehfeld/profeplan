import assert from "node:assert/strict";
import test from "node:test";
import { SupabaseClient } from "@supabase/supabase-js";
import { SupabaseAuditRepository } from "../src/index.ts";

const SUPABASE_URL = process.env.KF_SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.KF_SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  throw new Error(
    "Disposable Supabase credentials were not provided to the integration test",
  );
}

const client = new SupabaseClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
  auth: {
    persistSession: false,
    autoRefreshToken: false,
    detectSessionInUrl: false,
  },
});
const repository = new SupabaseAuditRepository({
  client,
  correlationId: "70000000-0000-4000-8000-000000000001",
});

const AGGREGATE_A = "71000000-0000-4000-8000-000000000001";
const AGGREGATE_B = "72000000-0000-4000-8000-000000000002";

const EVENT_A1 = {
  eventType: "source_authorized",
  aggregateType: "source",
  aggregateId: AGGREGATE_A,
  occurredAt: "2026-08-07T12:00:00.000Z",
  metadata: { synthetic: true, sequence: 1 },
};
const EVENT_A2 = {
  eventType: "source_blocked",
  aggregateType: "source",
  aggregateId: AGGREGATE_A,
  occurredAt: "2026-08-07T13:00:00.000Z",
  metadata: { synthetic: true, sequence: 2 },
};
const EVENT_B1 = {
  eventType: "component_eligibility_accepted",
  aggregateType: "component",
  aggregateId: AGGREGATE_B,
  occurredAt: "2026-08-07T12:30:00.000Z",
  metadata: { synthetic: true },
};

test("AuditRepository persists, reads and isolates aggregates on disposable Supabase", async () => {
  await repository.append(EVENT_A2);
  await repository.append(EVENT_B1);
  await repository.append(EVENT_A1);

  const aggregateAEvents = await repository.listByAggregate(AGGREGATE_A);
  const aggregateBEvents = await repository.listByAggregate(AGGREGATE_B);

  assert.deepEqual(aggregateAEvents, [EVENT_A1, EVENT_A2]);
  assert.deepEqual(aggregateBEvents, [EVENT_B1]);

  const { data, error } = await client
    .from("kf_audit_events")
    .select("event_type,aggregate_type,aggregate_id,occurred_at,metadata")
    .eq("aggregate_id", AGGREGATE_A)
    .order("occurred_at", { ascending: true });

  assert.equal(error, null);
  assert.equal(data?.length, 2);
  assert.deepEqual(
    data?.map((row) => row.aggregate_id),
    [AGGREGATE_A, AGGREGATE_A],
  );
});

test("physical append-only protection rejects UPDATE and DELETE", async () => {
  const updateResult = await client
    .from("kf_audit_events")
    .update({ reason: "forbidden synthetic mutation" })
    .eq("aggregate_id", AGGREGATE_A);
  assert.ok(updateResult.error, "UPDATE unexpectedly succeeded");

  const deleteResult = await client
    .from("kf_audit_events")
    .delete()
    .eq("aggregate_id", AGGREGATE_A);
  assert.ok(deleteResult.error, "DELETE unexpectedly succeeded");

  const aggregateAEvents = await repository.listByAggregate(AGGREGATE_A);
  assert.equal(aggregateAEvents.length, 2);
  assert.deepEqual(
    aggregateAEvents.map((event) => event.metadata.sequence),
    [1, 2],
  );
});
