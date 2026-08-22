import type {
  KnowledgeContributionCandidate,
  KnowledgeContributionRelationCandidate,
  KnowledgeContributionRelationKind,
} from '@profeplan/types';

const RELATION_CONTRACT_VERSION: KnowledgeContributionRelationCandidate['contractVersion'] =
  '1.0.0';

export interface KnowledgeContributionRelationProposal {
  readonly relationId: string;
  readonly kind: KnowledgeContributionRelationKind;
  readonly sourceContributionId: string;
  readonly targetContributionId: string;
  readonly evidenceIds: readonly string[];
}

export interface KnowledgeContributionRelationRequest {
  readonly contributions: readonly KnowledgeContributionCandidate[];
  readonly createdAt: string;
  readonly proposals: readonly KnowledgeContributionRelationProposal[];
}

export class KnowledgeContributionRelationService {
  relate(
    request: KnowledgeContributionRelationRequest
  ): readonly KnowledgeContributionRelationCandidate[] {
    const contributionById = new Map(
      request.contributions.map((contribution) => [contribution.contributionId, contribution])
    );
    if (contributionById.size !== request.contributions.length) {
      throw new Error('contribution IDs must be unique');
    }

    const relationIds = new Set<string>();
    return request.proposals.map((proposal) => {
      if (!proposal.relationId.trim()) {
        throw new Error('relationId is required');
      }
      if (relationIds.has(proposal.relationId)) {
        throw new Error(`duplicate relationId: ${proposal.relationId}`);
      }
      relationIds.add(proposal.relationId);

      if (proposal.sourceContributionId === proposal.targetContributionId) {
        throw new Error(
          'a contribution relation requires distinct source and target contributions'
        );
      }
      if (proposal.evidenceIds.length === 0) {
        throw new Error(`evidence is required for relation ${proposal.relationId}`);
      }

      const source = contributionById.get(proposal.sourceContributionId);
      const target = contributionById.get(proposal.targetContributionId);
      if (!source || !target) {
        throw new Error(`relation contributions must exist for relation ${proposal.relationId}`);
      }
      if (source.state !== 'candidate' || target.state !== 'candidate') {
        throw new Error(
          `relation contributions must remain candidates for relation ${proposal.relationId}`
        );
      }
      if (
        source.reconstructionCandidateSnapshotId !== target.reconstructionCandidateSnapshotId ||
        source.structuralReviewSnapshotId !== target.structuralReviewSnapshotId
      ) {
        throw new Error(
          `relation contributions must share the same structural review and reconstruction snapshot: ${proposal.relationId}`
        );
      }

      const evidenceById = new Map(
        [...source.evidence, ...target.evidence].map((evidence) => [evidence.evidenceId, evidence])
      );
      const evidenceIds = new Set<string>();
      const evidence = proposal.evidenceIds.map((evidenceId) => {
        if (evidenceIds.has(evidenceId)) {
          throw new Error(`duplicate relation evidence: ${evidenceId}`);
        }
        evidenceIds.add(evidenceId);
        const item = evidenceById.get(evidenceId);
        if (!item) {
          throw new Error(
            `relation evidence must belong to one of its contribution candidates: ${evidenceId}`
          );
        }
        return item;
      });

      return {
        contractVersion: RELATION_CONTRACT_VERSION,
        relationId: proposal.relationId,
        state: 'candidate',
        kind: proposal.kind,
        sourceContributionId: source.contributionId,
        targetContributionId: target.contributionId,
        evidence,
        createdAt: request.createdAt,
      };
    });
  }
}
