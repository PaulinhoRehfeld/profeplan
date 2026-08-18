export const syntheticExtractionRequest = {
  requestId: 'extraction-request-synthetic-1',
  run: { kind: 'extraction_run', id: 'extraction-run-synthetic-1' },
  sourceVersion: { kind: 'source_version', id: 'source-version-synthetic-1' },
  ingestionHandoff: {
    contractVersion: '1.0.0',
    ingestionRun: { kind: 'processing_run', id: 'processing-run-synthetic-1' },
    aggregateVersion: '7',
    sequence: 7,
    reviewedArtifactId: 'artifact-synthetic-1',
    approvalEventId: 'ingestion-approval-event-synthetic-1',
    committedAt: '2026-08-18T03:00:00.000Z',
  },
  artifact: {
    artifactId: 'artifact-synthetic-1',
    sha256: '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
    sizeBytes: 4096,
  },
  method: {
    kind: 'native_text',
    name: 'synthetic-native-text-extractor',
    version: '1.0.0',
  },
  requestedBy: { actorId: 'actor-synthetic-1', role: 'system_worker' },
  requestedAt: '2026-08-18T03:01:00.000Z',
};

export const syntheticClaimAuthorizationEvidence = {
  authorizationId: 'authorization-extraction-claim-synthetic-1',
  sourceVersion: { kind: 'source_version', id: 'source-version-synthetic-1' },
  purpose: 'extraction',
  checkpoint: 'claim',
  evaluatedAt: '2026-08-18T03:02:00.000Z',
};

export const syntheticArtifactReadAuthorizationEvidence = {
  authorizationId: 'authorization-extraction-read-synthetic-1',
  sourceVersion: { kind: 'source_version', id: 'source-version-synthetic-1' },
  purpose: 'extraction',
  checkpoint: 'artifact_read',
  evaluatedAt: '2026-08-18T03:03:00.000Z',
};

export const syntheticFinalizationAuthorizationEvidence = {
  authorizationId: 'authorization-extraction-final-synthetic-1',
  sourceVersion: { kind: 'source_version', id: 'source-version-synthetic-1' },
  purpose: 'extraction',
  checkpoint: 'finalization',
  evaluatedAt: '2026-08-18T03:04:00.000Z',
};

export const syntheticExtractionProvenance = {
  run: { kind: 'extraction_run', id: 'extraction-run-synthetic-1' },
  sourceVersion: { kind: 'source_version', id: 'source-version-synthetic-1' },
  ingestionRun: { kind: 'processing_run', id: 'processing-run-synthetic-1' },
  artifactSha256: '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
  method: {
    kind: 'native_text',
    name: 'synthetic-native-text-extractor',
    version: '1.0.0',
  },
  observedAt: '2026-08-18T03:03:30.000Z',
};

export const syntheticExtractionQualityMeasurements = [
  {
    metric: 'page_coverage',
    value: 1,
    unit: 'ratio',
    measuredAt: '2026-08-18T03:05:00.000Z',
  },
  {
    metric: 'provenance_completeness',
    value: true,
    unit: 'boolean',
    measuredAt: '2026-08-18T03:05:00.000Z',
  },
];

export const syntheticExtractionReceipt = {
  contractVersion: '1.0.0',
  commandId: 'command-extraction-synthetic-1',
  fingerprint: 'sha256:synthetic-extraction-command-1',
  correlationId: 'correlation-extraction-synthetic-1',
  operation: 'request_extraction',
  run: { kind: 'extraction_run', id: 'extraction-run-synthetic-1' },
  aggregateVersion: '1',
  sequence: 1,
  eventIds: ['extraction-event-synthetic-1'],
  state: 'REQUESTED',
  outcome: 'applied',
  committedAt: '2026-08-18T03:01:00.000Z',
};
