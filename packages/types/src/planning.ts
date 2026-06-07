export enum PlanningStatus {
  DRAFT = 'DRAFT',
  REVIEW = 'REVIEW',
  PUBLISHED = 'PUBLISHED',
}

export interface TermPlan {
  id: string;
  organizationId: string;
  ownerId: string;
  title: string;
  year: number;
  term: number;
  status: PlanningStatus;
  aiEnhancedContent?: unknown;
  aiEnhancedAt?: string | null;
  aiModel?: string | null;
  createdAt: string;
  updatedAt: string;
}
