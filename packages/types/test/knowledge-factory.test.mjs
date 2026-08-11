import assert from 'node:assert/strict';
import test from 'node:test';

import {
  EPIC_018_ENABLED,
  KNOWLEDGE_FACTORY_CONTRACT_VERSION,
  PEDAGOGICAL_COMPONENT_WRITE_OPERATIONS,
  PRODUCTION_ORDER_WRITE_OPERATIONS,
  assertOppTransition,
  canApproveFromFindings,
  hasDeliveryTraceability,
  hasIdentityAndVersion,
  hasMandatoryQueryFilters,
  hasSingleActiveCurriculum,
  isComponentProductionReady,
  isCurriculumPackageAllowedForMvp,
  isSourceRecoverable,
  isSufficient,
  syntheticComponentVersion,
  syntheticCurriculumPackage,
  syntheticDeliveries,
  syntheticCreateProductionOrderCommand,
  syntheticFinding,
  syntheticProductionOrderWriteReceipt,
  syntheticQueryPlan,
  syntheticSource,
  syntheticSufficiencyResult,
  syntheticTransitionProductionOrderCommand,
} from '../src/knowledge-factory/index.ts';

test('knowledge factory exports the approved 3.0.0 write contract', () => {
  assert.equal(KNOWLEDGE_FACTORY_CONTRACT_VERSION, '3.0.0');
  assert.deepEqual(PEDAGOGICAL_COMPONENT_WRITE_OPERATIONS, [
    'create_component_aggregate',
    'append_component_version',
    'transition_component_version_status',
    'promote_component_version',
  ]);
  assert.equal(Object.isFrozen(PEDAGOGICAL_COMPONENT_WRITE_OPERATIONS), true);
  assert.deepEqual(PRODUCTION_ORDER_WRITE_OPERATIONS, [
    'create_production_order',
    'transition_production_order',
  ]);
  assert.equal(Object.isFrozen(PRODUCTION_ORDER_WRITE_OPERATIONS), true);
});

test('production order fixtures keep requester and lifecycle fields outside create payloads', () => {
  assert.deepEqual(Object.keys(syntheticCreateProductionOrderCommand.order).sort(), [
    'agentProfileId',
    'curriculumPackageId',
    'durationMinutes',
    'id',
    'productType',
    'theme',
    'version',
  ]);
  assert.equal(syntheticProductionOrderWriteReceipt.operation, 'create_production_order');
  assert.equal(
    syntheticProductionOrderWriteReceipt.commandId,
    syntheticCreateProductionOrderCommand.commandId
  );
  assert.equal(syntheticTransitionProductionOrderCommand.requesterId, 'teacher_synthetic_1');
  assert.equal('eventType' in syntheticTransitionProductionOrderCommand, false);
  assert.equal('fromStatus' in syntheticTransitionProductionOrderCommand, false);
});

test('versioned contracts preserve identity and version', () => {
  assert.equal(hasIdentityAndVersion(syntheticSource), true);
  const serialized = JSON.parse(JSON.stringify(syntheticSource));
  assert.equal(serialized.id, syntheticSource.id);
  assert.equal(serialized.version, syntheticSource.version);
});

test('blocked sources cannot be recovered', () => {
  assert.equal(isSourceRecoverable({ ...syntheticSource, status: 'blocked' }, 'retrieval'), false);
});

test('incompatible licenses block generation use', () => {
  assert.equal(
    isSourceRecoverable(
      {
        ...syntheticSource,
        licenseCategory: 'restricted',
        allowedUses: ['generation', 'internal_review'],
      },
      'generation'
    ),
    false
  );
});

test('unapproved components cannot enter production', () => {
  assert.equal(
    isComponentProductionReady({ ...syntheticComponentVersion, status: 'in_review' }),
    false
  );
  assert.equal(isComponentProductionReady(syntheticComponentVersion), true);
});

test('query plans require deterministic mandatory filters', () => {
  assert.equal(hasMandatoryQueryFilters(syntheticQueryPlan), true);
  assert.equal(
    hasMandatoryQueryFilters({
      ...syntheticQueryPlan,
      filters: { ...syntheticQueryPlan.filters, sourceStatus: 'blocked' },
    }),
    false
  );
});

test('only one active curriculum is accepted', () => {
  assert.equal(hasSingleActiveCurriculum([syntheticCurriculumPackage]), true);
  assert.equal(
    hasSingleActiveCurriculum([
      syntheticCurriculumPackage,
      { ...syntheticCurriculumPackage, id: 'cur_mg_second', version: '1.0.0' },
    ]),
    false
  );
});

test('Rio Grande do Sul and EPIC-018 remain blocked in the MVP', () => {
  assert.equal(EPIC_018_ENABLED, false);
  assert.equal(isCurriculumPackageAllowedForMvp(syntheticCurriculumPackage), true);
  assert.equal(
    isCurriculumPackageAllowedForMvp({
      ...syntheticCurriculumPackage,
      id: 'cur_rs_synthetic',
      state: 'RS',
    }),
    false
  );
});

test('invalid OPP transitions are rejected', () => {
  assert.doesNotThrow(() => assertOppTransition('requested', 'scoped'));
  assert.throws(() => assertOppTransition('requested', 'ready'), /Invalid OPP transition/);
});

test('open Must findings block approval', () => {
  assert.equal(canApproveFromFindings([syntheticFinding]), true);
  assert.equal(
    canApproveFromFindings([
      {
        ...syntheticFinding,
        id: 'finding_must_open',
        priority: 'must',
        status: 'open',
      },
    ]),
    false
  );
});

test('insufficiency cannot be treated as success', () => {
  assert.equal(isSufficient(syntheticSufficiencyResult), true);
  assert.equal(
    isSufficient({
      ...syntheticSufficiencyResult,
      sufficient: false,
      reasons: ['insufficient_evidence'],
    }),
    false
  );
});

test('all four delivery contracts preserve traceability', () => {
  assert.equal(syntheticDeliveries.length, 4);
  for (const delivery of syntheticDeliveries) {
    assert.equal(hasDeliveryTraceability(delivery), true);
    const serialized = JSON.parse(JSON.stringify(delivery));
    assert.equal(serialized.id, delivery.id);
    assert.equal(serialized.version, delivery.version);
    assert.equal(serialized.traceability.oppId, delivery.traceability.oppId);
  }
});
