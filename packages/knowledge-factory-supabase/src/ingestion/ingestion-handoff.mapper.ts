import type { IngestionHandoffEvidence } from '@profeplan/types';
import { invalidPersistenceResponse } from '../errors/persistence-error.ts';

const ISO_DATE_TIME_PATTERN =
  /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|([+-])(\d{2}):(\d{2}))$/;

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function isDateTime(value: unknown): value is string {
  return (
    typeof value === 'string' &&
    ISO_DATE_TIME_PATTERN.test(value) &&
    Number.isFinite(Date.parse(value))
  );
}

function hasExactKeys(value: Record<string, unknown>, keys: readonly string[]): boolean {
  return Object.keys(value).length === keys.length && keys.every((key) => key in value);
}

export function ingestionHandoffEvidenceFromData(
  data: unknown,
  operation = 'ingestionHandoff.fromData'
): IngestionHandoffEvidence {
  if (
    !isRecord(data) ||
    !hasExactKeys(data, [
      'contractVersion',
      'run',
      'sourceVersion',
      'state',
      'aggregateVersion',
      'sequence',
      'review',
      'extractionAuthorization',
      'reviewedArtifactId',
      'decisionCommandId',
      'approvalEventId',
      'committedAt',
    ]) ||
    data.contractVersion !== '1.0.0' ||
    data.state !== 'APPROVED_FOR_EXTRACTION' ||
    typeof data.aggregateVersion !== 'string' ||
    data.aggregateVersion.trim().length === 0 ||
    typeof data.sequence !== 'number' ||
    !Number.isSafeInteger(data.sequence) ||
    data.sequence <= 0 ||
    typeof data.reviewedArtifactId !== 'string' ||
    typeof data.decisionCommandId !== 'string' ||
    typeof data.approvalEventId !== 'string' ||
    !isDateTime(data.committedAt) ||
    !isRecord(data.run) ||
    !hasExactKeys(data.run, ['kind', 'id']) ||
    data.run.kind !== 'processing_run' ||
    typeof data.run.id !== 'string' ||
    !isRecord(data.sourceVersion) ||
    !hasExactKeys(data.sourceVersion, ['kind', 'id']) ||
    data.sourceVersion.kind !== 'source_version' ||
    typeof data.sourceVersion.id !== 'string' ||
    !isRecord(data.review) ||
    !hasExactKeys(data.review, [
      'reviewId',
      'reviewMode',
      'reviewer',
      'decision',
      'decidedAt',
      'reason',
    ]) ||
    typeof data.review.reviewId !== 'string' ||
    data.review.reviewMode !== 'human' ||
    data.review.decision !== 'APPROVE_FOR_EXTRACTION' ||
    !isDateTime(data.review.decidedAt) ||
    typeof data.review.reason !== 'string' ||
    data.review.reason.trim().length === 0 ||
    !isRecord(data.review.reviewer) ||
    !hasExactKeys(data.review.reviewer, ['actorId', 'role']) ||
    typeof data.review.reviewer.actorId !== 'string' ||
    data.review.reviewer.role !== 'legal_editorial_reviewer' ||
    !isRecord(data.extractionAuthorization) ||
    !hasExactKeys(data.extractionAuthorization, [
      'authorizationId',
      'sourceVersion',
      'purpose',
      'evaluatedAt',
    ]) ||
    typeof data.extractionAuthorization.authorizationId !== 'string' ||
    data.extractionAuthorization.purpose !== 'extraction' ||
    !isDateTime(data.extractionAuthorization.evaluatedAt) ||
    !isRecord(data.extractionAuthorization.sourceVersion) ||
    !hasExactKeys(data.extractionAuthorization.sourceVersion, ['kind', 'id']) ||
    data.extractionAuthorization.sourceVersion.kind !== 'source_version' ||
    data.extractionAuthorization.sourceVersion.id !== data.sourceVersion.id
  ) {
    throw invalidPersistenceResponse(operation);
  }

  return Object.freeze({
    contractVersion: '1.0.0',
    run: Object.freeze({ kind: 'processing_run', id: data.run.id }),
    sourceVersion: Object.freeze({ kind: 'source_version', id: data.sourceVersion.id }),
    state: 'APPROVED_FOR_EXTRACTION',
    aggregateVersion: data.aggregateVersion,
    sequence: data.sequence,
    review: Object.freeze({
      reviewId: data.review.reviewId,
      reviewMode: 'human',
      reviewer: Object.freeze({
        actorId: data.review.reviewer.actorId,
        role: 'legal_editorial_reviewer',
      }),
      decision: 'APPROVE_FOR_EXTRACTION',
      decidedAt: data.review.decidedAt,
      reason: data.review.reason,
    }),
    extractionAuthorization: Object.freeze({
      authorizationId: data.extractionAuthorization.authorizationId,
      sourceVersion: Object.freeze({
        kind: 'source_version',
        id: data.sourceVersion.id,
      }),
      purpose: 'extraction',
      evaluatedAt: data.extractionAuthorization.evaluatedAt,
    }),
    reviewedArtifactId: data.reviewedArtifactId,
    decisionCommandId: data.decisionCommandId,
    approvalEventId: data.approvalEventId,
    committedAt: data.committedAt,
  });
}