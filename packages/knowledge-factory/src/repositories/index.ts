export * from './audit.repository.ts';
export * from './curriculum.repository.ts';
export * from './ingestion.repository.ts';
export * from './knowledge-source.repository.ts';
export * from './pedagogical-component.repository.ts';
export * from './production-order.repository.ts';
export * from './source-lifecycle.repository.ts';

export const REPOSITORY_PORT_NAMES = [
  'KnowledgeSourceRepository',
  'PedagogicalComponentRepository',
  'CurriculumRepository',
  'ProductionOrderRepository',
  'AuditRepository',
  'SourceLifecycleRepository',
  'IngestionRepository',
] as const;
