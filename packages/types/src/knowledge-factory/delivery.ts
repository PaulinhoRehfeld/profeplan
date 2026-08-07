import type { EntityId, ISODateTime, VersionedEntity } from './common.ts';

export const PRODUCT_TYPES = [
  'lesson_plan',
  'didactic_text',
  'reflective_activity',
  'formative_assessment',
] as const;
export type ProductType = (typeof PRODUCT_TYPES)[number];

export interface DeliveryTraceability {
  oppId: EntityId;
  agentProfileId: EntityId;
  curriculumPackageId: EntityId;
  componentVersionIds: readonly EntityId[];
  sourceVersionIds: readonly EntityId[];
  validationReportId: EntityId;
}

export interface LessonPlanPayload {
  title: string;
  objectives: readonly string[];
  durationMinutes: number;
  developmentSteps: readonly string[];
  assessmentStrategy: string;
}

export interface DidacticTextPayload {
  title: string;
  introduction: string;
  sections: readonly { heading: string; body: string }[];
  reflectionQuestions: readonly string[];
}

export interface ReflectiveActivityPayload {
  title: string;
  instructions: readonly string[];
  prompts: readonly string[];
  expectedEvidence: string;
}

export interface FormativeAssessmentPayload {
  title: string;
  questions: readonly {
    id: EntityId;
    prompt: string;
    responseType: 'multiple_choice' | 'open_response';
    options?: readonly string[];
  }[];
  answerGuidance: readonly string[];
}

export type DeliveryPayload =
  | { productType: 'lesson_plan'; content: LessonPlanPayload }
  | { productType: 'didactic_text'; content: DidacticTextPayload }
  | { productType: 'reflective_activity'; content: ReflectiveActivityPayload }
  | { productType: 'formative_assessment'; content: FormativeAssessmentPayload };

export interface DeliveryContract extends VersionedEntity {
  createdAt: ISODateTime;
  traceability: DeliveryTraceability;
  payload: DeliveryPayload;
}

export function hasDeliveryTraceability(delivery: DeliveryContract): boolean {
  const trace = delivery.traceability;

  return Boolean(
    trace.oppId.trim() &&
      trace.agentProfileId.trim() &&
      trace.curriculumPackageId.trim() &&
      trace.componentVersionIds.length > 0 &&
      trace.sourceVersionIds.length > 0 &&
      trace.validationReportId.trim(),
  );
}
