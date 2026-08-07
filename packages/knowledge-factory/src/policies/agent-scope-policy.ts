import type {
  AgentProfile,
  AgentScope,
  CurriculumState,
  EducationStage,
  EntityId,
  ISODateTime,
  ProductType,
  SchoolGrade,
} from '@profeplan/types';
import { domainEvent } from '../domain/events.ts';
import { allow, deny, type DomainDecision } from '../domain/result.ts';
import { reason, type DomainReason } from '../domain/reasons.ts';
import { MVP_GRADE, MVP_SCHOOL_COMPONENT, MVP_STAGE } from './curriculum-policy.ts';

function normalize(value: string): string {
  return value.trim().toLocaleLowerCase('pt-BR');
}

export interface AgentScopeRequest {
  schoolComponent: string;
  stage: EducationStage;
  grade: SchoolGrade;
  curriculumState: CurriculumState;
  curriculumPackageId: EntityId;
  productType: ProductType;
  occurredAt: ISODateTime;
}

export interface AgentScopeInput {
  profile: AgentProfile;
  scope: AgentScope;
  request: AgentScopeRequest;
}

export function evaluateSocrates2Scope(input: AgentScopeInput): DomainDecision<AgentProfile> {
  const { profile, scope, request } = input;
  const reasons: DomainReason[] = [];

  if (!profile.active) {
    reasons.push(reason('AGENT_INACTIVE', 'Agent profile is inactive.', profile.id));
  }

  if (profile.scopeId !== scope.id) {
    reasons.push(
      reason(
        'AGENT_SCOPE_ID_MISMATCH',
        'Agent profile does not reference the supplied scope.',
        profile.id
      )
    );
  }

  if (
    normalize(scope.schoolComponent) !== MVP_SCHOOL_COMPONENT ||
    normalize(request.schoolComponent) !== MVP_SCHOOL_COMPONENT
  ) {
    reasons.push(
      reason('AGENT_COMPONENT_MISMATCH', 'Sócrates 2 only accepts Filosofia.', profile.id, {
        schoolComponent: request.schoolComponent,
      })
    );
  }

  if (scope.stage !== MVP_STAGE || request.stage !== MVP_STAGE || scope.stage !== request.stage) {
    reasons.push(
      reason('AGENT_STAGE_MISMATCH', 'Sócrates 2 only accepts Ensino Médio.', profile.id, {
        stage: request.stage,
      })
    );
  }

  if (!scope.grades.includes(MVP_GRADE) || request.grade !== MVP_GRADE) {
    reasons.push(
      reason(
        'AGENT_GRADE_MISMATCH',
        'Sócrates 2 only accepts 2º ano do Ensino Médio.',
        profile.id,
        { grade: request.grade }
      )
    );
  }

  if (!scope.curriculumStates.includes('MG') || request.curriculumState !== 'MG') {
    reasons.push(
      reason('AGENT_STATE_MISMATCH', 'Sócrates 2 MVP only accepts Minas Gerais.', profile.id, {
        state: request.curriculumState,
      })
    );
  }

  if (profile.activeCurriculumPackageId !== request.curriculumPackageId) {
    reasons.push(
      reason(
        'AGENT_CURRICULUM_PACKAGE_MISMATCH',
        'Request curriculum package differs from the active agent package.',
        profile.id
      )
    );
  }

  const event = domainEvent(
    reasons.length === 0 ? 'agent_scope_accepted' : 'agent_scope_rejected',
    'agent',
    profile.id,
    request.occurredAt,
    {
      eligible: reasons.length === 0,
      productType: request.productType,
      state: request.curriculumState,
      grade: request.grade,
    }
  );

  return reasons.length === 0 ? allow(profile, [event]) : deny(reasons, [event]);
}
