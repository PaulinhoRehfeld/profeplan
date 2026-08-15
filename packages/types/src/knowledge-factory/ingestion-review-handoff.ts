import type { EntityId, ISODateTime, VersionTag } from './common.ts';
import type {
  IngestionAuthorizationEvidence,
  IngestionHumanReview,
  IngestionRunRef,
  IngestionSourceVersionRef,
} from './ingestion.ts';

export const INGESTION_REVIEW_HANDOFF_CONTRACT_VERSION = '1.0.0' as const;

export interface IngestionApprovedHumanReview extends IngestionHumanReview {
  readonly decision: 'APPROVE_FOR_EXTRACTION';
}

export interface IngestionExtractionAuthorizationEvidence extends IngestionAuthorizationEvidence {
  readonly purpose: 'extraction';
}

/**
 * Persisted C.2.5 evidence that the C.2 run satisfied the governed handoff
 * preconditions at the human decision instant. This is eligibility evidence;
 * it is not a command to C.3 and does not prove that extraction remains
 * authorized at any later execution instant.
 */
export interface IngestionHandoffEvidence {
  readonly contractVersion: typeof INGESTION_REVIEW_HANDOFF_CONTRACT_VERSION;
  readonly run: IngestionRunRef;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly state: 'APPROVED_FOR_EXTRACTION';
  readonly aggregateVersion: VersionTag;
  readonly sequence: number;
  readonly review: IngestionApprovedHumanReview;
  readonly extractionAuthorization: IngestionExtractionAuthorizationEvidence;
  readonly reviewedArtifactId: EntityId;
  readonly decisionCommandId: EntityId;
  readonly approvalEventId: EntityId;
  readonly committedAt: ISODateTime;
}