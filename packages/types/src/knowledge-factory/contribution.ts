import type { EntityId, ISODateTime } from './common.ts';
import type { PartReconstructionEvidenceRef } from './reconstruction.ts';

export const KNOWLEDGE_CONTRIBUTION_CANDIDATE_CONTRACT_VERSION = '1.0.0' as const;

export const KNOWLEDGE_CONTRIBUTION_KINDS = ['conceptual', 'contextual', 'methodological'] as const;
export type KnowledgeContributionKind = (typeof KNOWLEDGE_CONTRIBUTION_KINDS)[number];

export const KNOWLEDGE_CONTRIBUTION_CANDIDATE_STATES = ['candidate'] as const;
export type KnowledgeContributionCandidateState =
  (typeof KNOWLEDGE_CONTRIBUTION_CANDIDATE_STATES)[number];

export interface KnowledgeContributionCandidate {
  readonly contractVersion: typeof KNOWLEDGE_CONTRIBUTION_CANDIDATE_CONTRACT_VERSION;
  readonly contributionId: EntityId;
  readonly state: KnowledgeContributionCandidateState;
  readonly kind: KnowledgeContributionKind;
  readonly statement: string;
  readonly structuralReviewSnapshotId: EntityId;
  readonly reconstructionCandidateSnapshotId: EntityId;
  readonly sourceElementIds: readonly EntityId[];
  readonly evidence: readonly PartReconstructionEvidenceRef[];
  readonly createdAt: ISODateTime;
}

export const KNOWLEDGE_CONTRIBUTION_RELATION_CANDIDATE_CONTRACT_VERSION = '1.0.0' as const;

export const KNOWLEDGE_CONTRIBUTION_RELATION_KINDS = ['contextualizes'] as const;
export type KnowledgeContributionRelationKind =
  (typeof KNOWLEDGE_CONTRIBUTION_RELATION_KINDS)[number];

export const KNOWLEDGE_CONTRIBUTION_RELATION_CANDIDATE_STATES = ['candidate'] as const;
export type KnowledgeContributionRelationCandidateState =
  (typeof KNOWLEDGE_CONTRIBUTION_RELATION_CANDIDATE_STATES)[number];

export interface KnowledgeContributionRelationCandidate {
  readonly contractVersion: typeof KNOWLEDGE_CONTRIBUTION_RELATION_CANDIDATE_CONTRACT_VERSION;
  readonly relationId: EntityId;
  readonly state: KnowledgeContributionRelationCandidateState;
  readonly kind: KnowledgeContributionRelationKind;
  readonly sourceContributionId: EntityId;
  readonly targetContributionId: EntityId;
  readonly evidence: readonly PartReconstructionEvidenceRef[];
  readonly createdAt: ISODateTime;
}
