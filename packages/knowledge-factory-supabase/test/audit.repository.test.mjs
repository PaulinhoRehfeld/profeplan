import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";
import {
  AUDIT_EVENT_COLUMNS,
  KnowledgeFactoryPersistenceError,
  SupabaseAuditRepository,
  auditRowToDomainEvent,
  domainEventToAuditRow,
  toPersistenceError,
} from "../src/index.ts";

const AGGREGATE_ID = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1";
const OTHER_AGGREGATE_ID = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb2";

const EVENT = Object.freeze({
  eventType: "source_authorized",
  aggregateType: "source",
  aggregateId: AGGREGATE_ID,
  occurredAt: "2026-08-07T12:00:00.000Z",
  metadata: Object.freeze({ synthetic: true, score: 1, label: "safe" }),
});

function rowFromEvent(event = EVENT) {
  return {
    event_type: event.eventType,
    aggregate_type: event.aggregateType,
    aggregate_id: event.aggregateId,
    occurred_at: event.occurredAt,
    metadata: event.metadata,
  };
}

function createClientDouble({
  appendResponse,
  appendFailure,
  listResponse,
  listFailure,
} = {}) {
  const calls = [];
  const effectiveAppendResponse = appendResponse ?? {
    data: rowFromEvent(),
    error: null,
  };
  const effectiveListResponse = listResponse ?? {
    data: [rowFromEvent()],
    error: null,
  };

  const client = {
    secret: "service-role-must-never-be-logged",
    from(table) {
      calls.push(["from", table]);
      return {
        insert(payload) {
          calls.push(["insert", payload]);
          return {
            select(columns) {
              calls.push(["insert.select", columns]);
              return {
                single() {
                  calls.push(["single"]);
                  if (appendFailure) return Promise.reject(appendFailure);
                  return Promise.resolve(effectiveAppendResponse);
                },
              };
            },
          };
        },
        select(columns) {
          calls.push(["select", columns]);
          const builder = {
            eq(column, value) {
              calls.push(["eq", column, value]);
              return builder;
            },
            order(column, options) {
              calls.push(["order", column, options]);
              return builder;
            },
            then(onFulfilled, onRejected) {
              const result = listFailure
                ? Promise.reject(listFailure)
                : Promise.resolve(effectiveListResponse);
              return result.then(onFulfilled, onRejected);
            },
          };
          return builder;
        },
      };
    },
  };

  return { client, calls };
}

function createRepository(client, entries = []) {
  return new SupabaseAuditRepository(
    { client, correlationId: "cccccccc-cccc-4ccc-8ccc-ccccccccccc3" },
    {
      record(entry) {
        entries.push(entry);
      },
    },
  );
}

async function assertPersistenceCode(promise, code) {
  await assert.rejects(promise, (error) => {
    assert.ok(error instanceof KnowledgeFactoryPersistenceError);
    assert.equal(error.code, code);
    assert.doesNotMatch(
      error.message,
      /23505|42501|permission denied|service.role/i,
    );
    return true;
  });
}

test("mapper converts DomainEvent to the explicit SQL row", () => {
  assert.deepEqual(domainEventToAuditRow(EVENT), rowFromEvent());
});

test("mapper converts an SQL row to exactly DomainEvent", () => {
  assert.deepEqual(
    auditRowToDomainEvent({
      id: "dddddddd-dddd-4ddd-8ddd-ddddddddddd4",
      ...rowFromEvent(),
      actor_id: "eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee5",
      actor_role: "system",
      correlation_id: "ffffffff-ffff-4fff-8fff-fffffffffff6",
      outcome: "recorded",
      reason: "physical-only",
    }),
    EVENT,
  );
});

test("append uses INSERT and never UPSERT", async () => {
  const { client, calls } = createClientDouble();
  await createRepository(client).append(EVENT);

  assert.deepEqual(
    calls.map(([operation]) => operation),
    ["from", "insert", "insert.select", "single"],
  );
  assert.equal(calls[0][1], "kf_audit_events");
  assert.deepEqual(calls[1][1], rowFromEvent());
  assert.equal(calls[2][1], AUDIT_EVENT_COLUMNS);
  assert.ok(!calls.some(([operation]) => operation === "upsert"));
});

test("listByAggregate applies the mandatory filter and deterministic ordering", async () => {
  const rows = [
    rowFromEvent(EVENT),
    rowFromEvent({
      ...EVENT,
      eventType: "source_blocked",
      occurredAt: "2026-08-07T13:00:00.000Z",
    }),
  ];
  const { client, calls } = createClientDouble({
    listResponse: { data: rows, error: null },
  });

  const events = await createRepository(client).listByAggregate(AGGREGATE_ID);

  assert.equal(events.length, 2);
  assert.deepEqual(
    calls.find(([operation]) => operation === "eq"),
    ["eq", "aggregate_id", AGGREGATE_ID],
  );
  assert.deepEqual(
    calls.filter(([operation]) => operation === "order"),
    [
      ["order", "occurred_at", { ascending: true }],
      ["order", "id", { ascending: true }],
    ],
  );
});

test("listByAggregate accepts an empty provider array", async () => {
  const { client } = createClientDouble({
    listResponse: { data: [], error: null },
  });
  assert.deepEqual(
    await createRepository(client).listByAggregate(OTHER_AGGREGATE_ID),
    [],
  );
});

for (const [providerError, expectedCode] of [
  [{ code: "23505", message: "duplicate detail" }, "CONFLICT"],
  [{ code: "23503" }, "CONSTRAINT_VIOLATION"],
  [{ code: "23514" }, "CONSTRAINT_VIOLATION"],
  [{ code: "23502" }, "CONSTRAINT_VIOLATION"],
  [{ code: "42501", message: "permission denied for table" }, "FORBIDDEN"],
  [{ status: 401, message: "JWT missing" }, "UNAUTHORIZED"],
  [{ code: "PGRST116", message: "row missing" }, "NOT_FOUND"],
  [{ code: "unexpected", message: "provider detail" }, "UNKNOWN"],
]) {
  test(`translates provider errors to ${expectedCode}`, async () => {
    const { client } = createClientDouble({
      appendResponse: { data: null, error: providerError },
    });
    await assertPersistenceCode(
      createRepository(client).append(EVENT),
      expectedCode,
    );
  });
}

test("translates timeout and network failures to UNAVAILABLE", async () => {
  for (const failure of [
    Object.assign(new Error("request timed out"), { name: "AbortError" }),
    new TypeError("fetch failed for an internal URL"),
  ]) {
    const { client } = createClientDouble({ appendFailure: failure });
    await assertPersistenceCode(
      createRepository(client).append(EVENT),
      "UNAVAILABLE",
    );
  }
});

test("rejects malformed provider response and {data:null,error:null}", async () => {
  for (const appendResponse of [
    { value: "malformed" },
    { data: null, error: null },
  ]) {
    const { client } = createClientDouble({ appendResponse });
    await assertPersistenceCode(
      createRepository(client).append(EVENT),
      "INVALID_RESPONSE",
    );
  }
});

test("rejects malformed rows and an unexpected multi-row single response", async () => {
  for (const data of [
    { ...rowFromEvent(), metadata: { nested: { forbidden: true } } },
    [rowFromEvent(), rowFromEvent()],
  ]) {
    const { client } = createClientDouble({
      appendResponse: { data, error: null },
    });
    await assertPersistenceCode(
      createRepository(client).append(EVENT),
      "INVALID_RESPONSE",
    );
  }
});

test("rejects null list data without treating it as an empty result", async () => {
  const { client } = createClientDouble({
    listResponse: { data: null, error: null },
  });
  await assertPersistenceCode(
    createRepository(client).listByAggregate(AGGREGATE_ID),
    "INVALID_RESPONSE",
  );
});

test("emits allowlisted logs and redacts client, payload, metadata and provider details", async () => {
  const entries = [];
  const secretEvent = {
    ...EVENT,
    metadata: {
      authorization: "Bearer secret-jwt",
      extracted_text: "sensitive content",
    },
  };
  const { client } = createClientDouble({
    appendResponse: { data: rowFromEvent(secretEvent), error: null },
  });
  await createRepository(client, entries).append(secretEvent);

  assert.equal(entries.length, 1);
  assert.deepEqual(
    Object.keys(entries[0]).sort(),
    [
      "adapter",
      "aggregateId",
      "aggregateType",
      "correlationId",
      "durationMs",
      "operation",
      "outcome",
      "rowCount",
    ].sort(),
  );
  const serialized = JSON.stringify(entries);
  assert.doesNotMatch(
    serialized,
    /service-role|Bearer secret|sensitive content|authorization/i,
  );
});

test("failure logs contain only a sanitized error code", async () => {
  const entries = [];
  const { client } = createClientDouble({
    appendResponse: {
      data: null,
      error: {
        code: "42501",
        message: "permission denied; Authorization: secret-jwt",
      },
    },
  });

  await assertPersistenceCode(
    createRepository(client, entries).append(EVENT),
    "FORBIDDEN",
  );
  assert.equal(entries[0].errorCode, "FORBIDDEN");
  assert.doesNotMatch(
    JSON.stringify(entries),
    /42501|permission denied|secret-jwt/i,
  );
});

test("the adapter surface has no update or delete operation", () => {
  const methods = Object.getOwnPropertyNames(
    SupabaseAuditRepository.prototype,
  ).sort();
  assert.deepEqual(
    methods,
    ["append", "constructor", "listByAggregate"].sort(),
  );
});

test("source contains no generalized any, client creation, env access or forbidden mutations", async () => {
  const sourceFiles = [
    "../src/audit/audit.mapper.ts",
    "../src/audit/supabase-audit.repository.ts",
    "../src/context/supabase-system-context.ts",
    "../src/errors/persistence-error.ts",
    "../src/observability/persistence-logger.ts",
  ];
  const source = (
    await Promise.all(
      sourceFiles.map((path) =>
        readFile(new URL(path, import.meta.url), "utf8"),
      ),
    )
  ).join("\n");

  assert.doesNotMatch(source, /\bany\b/);
  assert.doesNotMatch(
    source,
    /createClient\s*\(|process\.env|api\/_lib|supabaseAdmin/,
  );
  assert.doesNotMatch(source, /\.upsert\s*\(|\.update\s*\(|\.delete\s*\(/);
});

test("direct error translation never preserves raw provider detail", () => {
  const error = toPersistenceError(
    { code: "23505", message: "query and internal URL with secret" },
    "audit.append",
  );
  assert.equal(error.code, "CONFLICT");
  assert.equal(error.operation, "audit.append");
  assert.doesNotMatch(JSON.stringify(error), /23505|internal URL|secret/i);
});
