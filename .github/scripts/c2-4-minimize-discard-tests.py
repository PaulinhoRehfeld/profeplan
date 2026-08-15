from pathlib import Path
import subprocess

BASE = "ac25f9decd45b9e9757e33f3f988ab5b0dd6862c"
UNIT_PATH = "packages/knowledge-factory-supabase/test/staging.repository.test.mjs"
INTEGRATION_PATH = "packages/knowledge-factory-supabase/test/staging.c2-2.integration.test.mjs"


def original(path: str) -> str:
    return subprocess.check_output(["git", "show", f"{BASE}:{path}"], text=True)


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f"Expected exactly one {label}; found {count}")
    return text.replace(old, new, 1)


text = original(UNIT_PATH)
text = replace_once(
    text,
    "const calls = { upload: [], download: [], remove: [], list: [] };",
    "const calls = { upload: [], download: [], remove: [], list: [], exists: [] };",
    "calls declaration",
)
text = replace_once(
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
    "remove mock",
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
text = replace_once(
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
    "list mock",
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
    (error) => error.code === 'UNAVAILABLE' && !error.message.includes('network timeout after provider delete')
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
text = replace_once(text, marker, new_test + marker, "unverified deletion marker")
Path(UNIT_PATH).write_text(text)

text = original(INTEGRATION_PATH)
text = replace_once(
    text,
    """    assert.equal(repeated.state, 'DISCARDED');
    assert.equal(repeated.outcome, 'discarded');""",
    """    assert.equal(repeated.state, 'DISCARDED');
    assert.equal(repeated.outcome, 'already_discarded');""",
    "integration repeated-discard assertion",
)
Path(INTEGRATION_PATH).write_text(text)
