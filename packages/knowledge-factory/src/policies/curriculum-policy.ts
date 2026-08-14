import type {
  CurriculumNode,
  CurriculumPackage,
  EducationStage,
  ISODateTime,
  SchoolGrade,
} from '@profeplan/types';
import { domainEvent } from '../domain/events.ts';
import { allow, deny, type DomainDecision } from '../domain/result.ts';
import { reason, type DomainReason } from '../domain/reasons.ts';

export const MVP_SCHOOL_COMPONENT = 'filosofia' as const;
export const MVP_STAGE: EducationStage = 'ensino_medio';
export const MVP_GRADE: SchoolGrade = '2_em';

function normalize(value: string): string {
  return value.trim().toLocaleLowerCase('pt-BR');
}

export interface CurriculumScopeInput {
  curriculumPackage: CurriculumPackage;
  schoolComponent: string;
  stage: EducationStage;
  grade: SchoolGrade;
  occurredAt: ISODateTime;
}

export function evaluateMvpCurriculumScope(
  input: CurriculumScopeInput
): DomainDecision<CurriculumPackage> {
  const { curriculumPackage: pkg, schoolComponent, stage, grade, occurredAt } = input;
  const reasons: DomainReason[] = [];

  if (pkg.status !== 'active') {
    reasons.push(reason('CURRICULUM_NOT_ACTIVE', 'Curriculum package must be active.', pkg.id));
  }

  if (pkg.state !== 'MG') {
    reasons.push(
      reason('CURRICULUM_STATE_BLOCKED', 'Only Minas Gerais is enabled in the MVP.', pkg.id, {
        state: pkg.state,
      })
    );
  }

  if (pkg.stage !== MVP_STAGE || stage !== MVP_STAGE || pkg.stage !== stage) {
    reasons.push(
      reason('CURRICULUM_STAGE_MISMATCH', 'The MVP only accepts Ensino Médio.', pkg.id, {
        stage,
        packageStage: pkg.stage,
      })
    );
  }

  if (grade !== MVP_GRADE) {
    reasons.push(
      reason('CURRICULUM_GRADE_MISMATCH', 'The MVP only accepts 2º ano do Ensino Médio.', pkg.id, {
        grade,
      })
    );
  }

  if (normalize(schoolComponent) !== MVP_SCHOOL_COMPONENT) {
    reasons.push(
      reason('CURRICULUM_COMPONENT_MISMATCH', 'The MVP only accepts Filosofia.', pkg.id, {
        schoolComponent,
      })
    );
  }

  const at = Date.parse(occurredAt);
  const from = Date.parse(pkg.effectiveFrom);
  const until = pkg.effectiveUntil ? Date.parse(pkg.effectiveUntil) : undefined;
  const outsidePeriod =
    Number.isNaN(at) ||
    Number.isNaN(from) ||
    at < from ||
    (until !== undefined && !Number.isNaN(until) && at > until);

  if (outsidePeriod) {
    reasons.push(
      reason(
        'CURRICULUM_OUTSIDE_EFFECTIVE_PERIOD',
        'Curriculum package is outside its effective period.',
        pkg.id
      )
    );
  }

  const event = domainEvent(
    reasons.length === 0 ? 'curriculum_scope_accepted' : 'curriculum_scope_rejected',
    'curriculum',
    pkg.id,
    occurredAt,
    { eligible: reasons.length === 0, state: pkg.state, grade, stage }
  );

  return reasons.length === 0 ? allow(pkg, [event]) : deny(reasons, [event]);
}

export function isCurriculumNodeAligned(
  node: CurriculumNode,
  pkg: CurriculumPackage,
  schoolComponent: string,
  grade: SchoolGrade
): boolean {
  return (
    node.curriculumPackageId === pkg.id &&
    normalize(node.component) === normalize(schoolComponent) &&
    node.grades.includes(grade)
  );
}
