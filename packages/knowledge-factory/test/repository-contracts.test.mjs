import assert from 'node:assert/strict';
import test from 'node:test';
import { REPOSITORY_PORT_NAMES } from '../src/index.ts';

test('knowledge factory exposes exactly the approved abstract repository ports', () => {
  assert.deepEqual(REPOSITORY_PORT_NAMES, [
    'KnowledgeSourceRepository',
    'PedagogicalComponentRepository',
    'CurriculumRepository',
    'ProductionOrderRepository',
    'AuditRepository',
    'SourceLifecycleRepository',
  ]);
});
