export enum AIRequestType {
  PLAN_ENHANCEMENT = 'PLAN_ENHANCEMENT',
  LESSON_GENERATION = 'LESSON_GENERATION',
  BNCC_ALIGNMENT = 'BNCC_ALIGNMENT',
}

export interface AIRequest {
  id: string;
  organizationId: string;
  userId: string;
  type: AIRequestType;
  input: string;
  output: string;
  createdAt: string;
}
