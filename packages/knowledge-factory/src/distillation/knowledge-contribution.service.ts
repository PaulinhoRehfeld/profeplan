import type {
  KnowledgeContributionCandidate,
  KnowledgeContributionKind,
  PartReconstructionCandidateSnapshot,
  PartStructuralReviewSnapshot,
} from "@profeplan/types";

const CONTRIBUTION_CONTRACT_VERSION: KnowledgeContributionCandidate["contractVersion"] =
  "1.0.0";

export interface KnowledgeContributionProposal {
  readonly contributionId: string;
  readonly kind: KnowledgeContributionKind;
  readonly statement: string;
  readonly sourceElementIds: readonly string[];
}

export interface KnowledgeContributionRequest {
  readonly reconstruction: PartReconstructionCandidateSnapshot;
  readonly structuralReview: PartStructuralReviewSnapshot;
  readonly createdAt: string;
  readonly proposals: readonly KnowledgeContributionProposal[];
}

function normalize(value: string): string {
  return value
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLocaleLowerCase("pt-BR")
    .replace(/\s+/g, " ")
    .trim();
}

export class KnowledgeContributionService {
  distill(
    request: KnowledgeContributionRequest,
  ): readonly KnowledgeContributionCandidate[] {
    if (
      request.structuralReview.candidateSnapshotId !==
      request.reconstruction.snapshotId
    ) {
      throw new Error(
        "structural review does not belong to the supplied reconstruction candidate",
      );
    }

    const elementById = new Map(
      request.reconstruction.elements.map((element) => [
        element.elementId,
        element,
      ]),
    );
    const confirmedElementIds = new Set(
      request.structuralReview.decisions
        .filter(
          (decision) =>
            decision.targetKind === "element" &&
            decision.disposition === "confirmed",
        )
        .map((decision) => decision.targetId),
    );
    const contributionIds = new Set<string>();

    return request.proposals.map((proposal) => {
      if (!proposal.contributionId.trim()) {
        throw new Error("contributionId is required");
      }
      if (contributionIds.has(proposal.contributionId)) {
        throw new Error(`duplicate contributionId: ${proposal.contributionId}`);
      }
      contributionIds.add(proposal.contributionId);

      if (!proposal.statement.trim()) {
        throw new Error(
          `statement is required for contribution ${proposal.contributionId}`,
        );
      }
      if (proposal.sourceElementIds.length === 0) {
        throw new Error(
          `source elements are required for contribution ${proposal.contributionId}`,
        );
      }

      const sourceElements = proposal.sourceElementIds.map((elementId) => {
        const element = elementById.get(elementId);
        if (!element) {
          throw new Error(
            `source element not found in reconstruction candidate: ${elementId}`,
          );
        }
        if (!confirmedElementIds.has(elementId)) {
          throw new Error(
            `source element is not structurally confirmed: ${elementId}`,
          );
        }
        return element;
      });

      const normalizedStatement = normalize(proposal.statement);
      const sourceTexts = sourceElements
        .map((element) => element.text)
        .filter((text): text is string => Boolean(text?.trim()));
      if (sourceTexts.some((text) => normalize(text) === normalizedStatement)) {
        throw new Error(
          `contribution ${proposal.contributionId} must not be an exact copy of source text`,
        );
      }

      const evidenceById = new Map(
        sourceElements
          .flatMap((element) => element.evidence)
          .map((evidence) => [evidence.evidenceId, evidence]),
      );

      return {
        contractVersion: CONTRIBUTION_CONTRACT_VERSION,
        contributionId: proposal.contributionId,
        state: "candidate",
        kind: proposal.kind,
        statement: proposal.statement.trim(),
        structuralReviewSnapshotId: request.structuralReview.reviewSnapshotId,
        reconstructionCandidateSnapshotId: request.reconstruction.snapshotId,
        sourceElementIds: [...proposal.sourceElementIds],
        evidence: [...evidenceById.values()],
        createdAt: request.createdAt,
      };
    });
  }
}
