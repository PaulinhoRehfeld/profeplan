import type { EntityId, ISODateTime, VersionedEntity } from './common.ts';

export const VALIDATION_PRIORITIES = ['must', 'should', 'could'] as const;
export type ValidationPriority = (typeof VALIDATION_PRIORITIES)[number];

export const VALIDATION_STATUSES = ['open', 'resolved', 'waived'] as const;
export type ValidationStatus = (typeof VALIDATION_STATUSES)[number];

export const VALIDATION_DOMAINS = [
  'source_permission',
  'curriculum_alignment',
  'philosophical_accuracy',
  'pedagogical_quality',
  'inclusion',
  'copyright',
  'traceability',
  'delivery_contract',
] as const;
export type ValidationDomain = (typeof VALIDATION_DOMAINS)[number];

export interface ValidationFinding extends VersionedEntity {
  oppId: EntityId;
  domain: ValidationDomain;
  priority: ValidationPriority;
  status: ValidationStatus;
  code: string;
  message: string;
  evidenceIds: readonly EntityId[];
  createdAt: ISODateTime;
}

export interface ValidationReport extends VersionedEntity {
  oppId: EntityId;
  findingIds: readonly EntityId[];
  generatedAt: ISODateTime;
}

export function isBlockingFinding(finding: ValidationFinding): boolean {
  return finding.priority === 'must' && finding.status === 'open';
}

export function canApproveFromFindings(findings: readonly ValidationFinding[]): boolean {
  return !findings.some(isBlockingFinding);
}
