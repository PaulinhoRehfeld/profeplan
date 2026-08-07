import type {
  CurriculumNode,
  CurriculumPackage,
  EducationStage,
  EvidenceOrigin,
  ISODateTime,
  KnowledgeSource,
  PedagogicalComponent,
  PedagogicalComponentVersion,
  SchoolGrade,
  SourcePermissionEvent,
} from '@profeplan/types';
import { domainEvent } from '../domain/events.ts';
import { allow, deny, type DomainDecision } from '../domain/result.ts';
import { reason, type DomainReason } from '../domain/reasons.ts';
import { evaluateMvpCurriculumScope, isCurriculumNodeAligned } from './curriculum-policy.ts';
import { evaluateSourceEligibility } from './source-eligibility.ts';

export interface ComponentEligibilityScope {
  schoolComponent: string;
  stage: EducationStage;
  grade: SchoolGrade;
}

export interface ComponentEligibilityInput {
  component: PedagogicalComponent;
  version: PedagogicalComponentVersion;
  evidenceOrigins: readonly EvidenceOrigin[];
  sources: readonly KnowledgeSource[];
  sourcePermissionEvents?: readonly SourcePermissionEvent[];
  curriculumPackage: CurriculumPackage;
  curriculumNodes: readonly CurriculumNode[];
  scope: ComponentEligibilityScope;
  occurredAt: ISODateTime;
}

export function evaluateComponentEligibility(
  input: ComponentEligibilityInput
): DomainDecision<PedagogicalComponentVersion> {
  const {
    component,
    version,
    evidenceOrigins,
    sources,
    sourcePermissionEvents,
    curriculumPackage,
    curriculumNodes,
    scope,
    occurredAt,
  } = input;
  const reasons: DomainReason[] = [];

  if (component.status !== 'approved' || version.status !== 'approved') {
    reasons.push(
      reason(
        'COMPONENT_STATUS_NOT_APPROVED',
        'Component and current version must both be approved.',
        component.id
      )
    );
  }

  if (!version.version.trim()) {
    reasons.push(reason('COMPONENT_VERSION_MISSING', 'Component version is required.', component.id));
  }

  if (component.currentVersionId !== version.id || version.componentId !== component.id) {
    reasons.push(
      reason(
        'COMPONENT_CURRENT_VERSION_MISMATCH',
        'Component currentVersionId and version componentId must be consistent.',
        component.id
      )
    );
  }

  if (
    component.schoolComponent.trim().toLocaleLowerCase('pt-BR') !==
      scope.schoolComponent.trim().toLocaleLowerCase('pt-BR') ||
    !component.grades.includes(scope.grade)
  ) {
    reasons.push(
      reason('COMPONENT_SCOPE_MISMATCH', 'Component is outside the requested scope.', component.id)
    );
  }

  if (version.sourceEvidenceIds.length === 0) {
    reasons.push(
      reason('COMPONENT_EVIDENCE_MISSING', 'Approved component requires source evidence.', component.id)
    );
  }

  for (const evidenceId of version.sourceEvidenceIds) {
    const evidence = evidenceOrigins.find((item) => item.id === evidenceId);

    if (!evidence) {
      reasons.push(
        reason(
          'COMPONENT_EVIDENCE_UNRESOLVED',
          'Component evidence reference could not be resolved.',
          component.id,
          { evidenceId }
        )
      );
      continue;
    }

    const source = sources.find((item) => item.id === evidence.sourceId);

    if (!source) {
      reasons.push(
        reason(
          'COMPONENT_EVIDENCE_UNRESOLVED',
          'Evidence source could not be resolved.',
          component.id,
          { evidenceId }
        )
      );
      continue;
    }

    const sourceDecision = evaluateSourceEligibility({
      source,
      use: 'generation',
      permissionEvents: sourcePermissionEvents,
      occurredAt,
    });

    if (!sourceDecision.allowed) {
      reasons.push(
        reason(
          'COMPONENT_SOURCE_INELIGIBLE',
          'Component depends on a source that is not eligible for generation.',
          component.id,
          { sourceId: source.id }
        )
      );
    }
  }

  if (version.curriculumNodeIds.length === 0) {
    reasons.push(
      reason(
        'COMPONENT_CURRICULUM_MISSING',
        'Approved component requires curriculum alignment.',
        component.id
      )
    );
  }

  const curriculumDecision = evaluateMvpCurriculumScope({
    curriculumPackage,
    schoolComponent: scope.schoolComponent,
    stage: scope.stage,
    grade: scope.grade,
    occurredAt,
  });

  if (!curriculumDecision.allowed) {
    reasons.push(...curriculumDecision.reasons);
  }

  for (const nodeId of version.curriculumNodeIds) {
    const node = curriculumNodes.find((item) => item.id === nodeId);

    if (!node || !isCurriculumNodeAligned(node, curriculumPackage, scope.schoolComponent, scope.grade)) {
      reasons.push(
        reason(
          'CURRICULUM_NODE_MISMATCH',
          'Component curriculum node is unresolved or outside the active scope.',
          component.id,
          { nodeId }
        )
      );
    }
  }

  const event = domainEvent(
    reasons.length === 0 ? 'component_eligibility_accepted' : 'component_eligibility_rejected',
    'component',
    component.id,
    occurredAt,
    { eligible: reasons.length === 0, versionId: version.id }
  );

  return reasons.length === 0 ? allow(version, [event]) : deny(reasons, [event]);
}
