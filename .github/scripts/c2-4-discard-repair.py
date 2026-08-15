from pathlib import Path


def replace_exact(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f"Expected exactly one {label}; found {count}")
    return text.replace(old, new, 1)


adapter = Path("packages/knowledge-factory-supabase/src/staging/supabase-temporary-staging.adapter.ts")
text = adapter.read_text()
text = replace_exact(
    text,
    """    const path = objectPath(input.run.id, artifactId);
    const { folder, filename } = pathParts(path);
    const bucket = this.context.client.storage.from(this.bucketName);

    try {
      const { data: before, error: beforeError } = await bucket.list(folder, {
        limit: 2,
        search: filename,
      });
      if (beforeError !== null) {
        throw toPersistenceError(beforeError, operation);
      }

      const existsBefore = (before ?? []).some((item) => item.name === filename);
      if (!existsBefore) {""",
    """    const path = objectPath(input.run.id, artifactId);
    const bucket = this.context.client.storage.from(this.bucketName);

    try {
      const { data: existsBefore, error: beforeError } = await bucket.exists(path);
      if (beforeError !== null) {
        throw toPersistenceError(beforeError, operation);
      }

      if (!existsBefore) {""",
    "discard pre-check block",
)
text = replace_exact(
    text,
    """      const { data: remaining, error: listError } = await bucket.list(folder, {
        limit: 2,
        search: filename,
      });

      if (listError !== null) {
        throw toPersistenceError(listError, operation);
      }

      if ((remaining ?? []).some((item) => item.name === filename)) {
        throw toPersistenceError({ message: 'delete verification failed' }, operation);
      }""",
    """      const { data: existsAfter, error: existsError } = await bucket.exists(path);

      if (existsError !== null) {
        throw toPersistenceError(existsError, operation);
      }

      if (existsAfter) {
        throw toPersistenceError({ message: 'delete verification failed' }, operation);
      }""",
    "discard post-check block",
)
adapter.write_text(text)

unit = Path("packages/knowledge-factory-supabase/test/staging.repository.test.mjs")
text = unit.read_text()
text = replace_exact(
    text,
    "const calls = { upload: [], download: [], remove: [], list: [] };",
    "const calls = { upload: [], download: [], remove: [], list: [], exists: [] };",
    "fake calls declaration",
)
text = replace_exact(
    text,
    """    async remove(paths) {
      calls.remove.push(paths);
      if (behavior.removeError) return { data: null, error: behavior.removeError };
      for (const path of paths) objects.delete(path);
      return { data: paths.map((name) => ({ name })), error: null };
    },""",
    """    async remove(paths) {
      calls.remove.push(paths);
      if (behavior.removeError) {
        if (behavior.deleteBeforeRemoveError) {
          for (const path of paths) objects.delete(path);
        }
        return { data: null, error: behavior.removeError };
      }
      for (const path of paths) objects.delete(path);
      return { data: paths.map((name) => ({ name })), error: null };
    },""",
    "fake remove implementation",
)
needle = """    async list(folder, options) {
      calls.list.push({ folder, options });
      if (behavior.listError) return { data: null, error: behavior.listError };
      if (behavior.keepAfterRemove) {
        return { data: [{ name: options.search }], error: null };
      }
      const prefix = `${folder}/`;
      const data = [...objects.keys()]
        .filter((path) => path.startsWith(prefix))
        .map((path) => ({ name: path.slice(prefix.length) }))
        .filter((item) => !options.search || item.name.includes(options.search));
      return { data, error: null };
    },"""
text = replace_exact(
    text,
    needle,
    needle
    + """
    async exists(path) {
      calls.exists.push(path);
      if (behavior.existsError) return { data: false, error: behavior.existsError };
      if (behavior.keepAfterRemove) return { data: true, error: null };
      return { data: objects.has(path), error: null };
    },""",
    "fake list implementation",
)
marker = "test('unverified deletion fails closed with sanitized error', async () => {"
new_test = """test('lost delete response reconciles to already_discarded on retry without a second physical delete', async () => {
  const fake = fakeContext({
    deleteBeforeRemoveError: true,
    removeError: { message: 'network timeout after provider delete' },
  });
  const adapter = new SupabaseTemporaryStagingAdapter(fake.context, {
    bucketName: 'private-test-bucket',
    now: () => '2026-08-14T21:05:00.000Z',
  });
  const descriptor = await adapter.stage(write());
  const command = {
    artifact: descriptor.artifact,
    run,
    requestedAt: '2026-08-14T21:04:59.000Z',
    reasonCode: 'technical_failure',
    correlationId: 'correlation-synthetic-1',
  };

  await assert.rejects(
    adapter.discard(command),
    (error) =>
      error.code === 'UNAVAILABLE' && !error.message.includes('network timeout after provider delete')
  );
  assert.equal(fake.objects.size, 0);

  const retry = await adapter.discard({
    ...command,
    requestedAt: '2026-08-14T21:05:01.000Z',
  });
  assert.equal(retry.outcome, 'already_discarded');
  assert.equal(fake.calls.remove.length, 1);
});

"""
text = replace_exact(text, marker, new_test + marker, "unverified deletion test marker")
unit.write_text(text)

integration = Path("packages/knowledge-factory-supabase/test/staging.c2-2.integration.test.mjs")
text = integration.read_text()
text = replace_exact(
    text,
    """    assert.equal(repeated.state, 'DISCARDED');
    assert.equal(repeated.outcome, 'discarded');""",
    """    assert.equal(repeated.state, 'DISCARDED');
    assert.equal(repeated.outcome, 'already_discarded');""",
    "C.2.2 repeated discard assertion",
)
integration.write_text(text)
