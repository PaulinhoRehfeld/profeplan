import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

test('CurriculumRepository requires state and stage and removes the ambiguous lookup', async () => {
  const source = await readFile(
    new URL('../src/repositories/curriculum.repository.ts', import.meta.url),
    'utf8'
  );

  assert.match(
    source,
    /findActivePackageByStateAndStage\(\s*state:\s*CurriculumState,\s*stage:\s*EducationStage\s*\)/
  );
  assert.doesNotMatch(source, /findActivePackageByState\s*\(/);
  assert.match(source, /EducationStage/);
});
