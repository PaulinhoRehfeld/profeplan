export const syntheticIngestionRequest = {
  requestId: 'ingestion-request-synthetic-1',
  sourceVersion: { kind: 'source_version', id: 'source-version-synthetic-1' },
  receivedFile: { kind: 'received_file', id: 'received-file-synthetic-1' },
  run: { kind: 'processing_run', id: 'processing-run-synthetic-1' },
  requestedBy: { actorId: 'actor-synthetic-1', role: 'curator' },
  requestedAt: '2026-08-14T20:00:00.000Z',
  authorizationEvidence: [
    {
      authorizationId: 'authorization-staging-synthetic-1',
      sourceVersion: { kind: 'source_version', id: 'source-version-synthetic-1' },
      purpose: 'temporary_staging',
      evaluatedAt: '2026-08-14T20:00:00.000Z',
    },
    {
      authorizationId: 'authorization-ingestion-synthetic-1',
      sourceVersion: { kind: 'source_version', id: 'source-version-synthetic-1' },
      purpose: 'ingestion',
      evaluatedAt: '2026-08-14T20:00:00.000Z',
    },
  ],
};

export const syntheticIngestionReceipt = {
  contractVersion: '1.0.0',
  commandId: 'command-ingestion-synthetic-1',
  fingerprint: 'sha256:synthetic-ingestion-command-1',
  correlationId: 'correlation-ingestion-synthetic-1',
  operation: 'request_ingestion',
  run: { kind: 'processing_run', id: 'processing-run-synthetic-1' },
  aggregateVersion: '1',
  sequence: 1,
  eventIds: ['ingestion-event-synthetic-1'],
  state: 'REQUESTED',
  outcome: 'applied',
  committedAt: '2026-08-14T20:00:00.000Z',
};
