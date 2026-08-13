import type { PedagogicalComponentReadRepository } from '@profeplan/knowledge-factory';
import type {
  EntityId,
  EvidenceOrigin,
  PedagogicalComponent,
  PedagogicalComponentVersion,
  VersionTag,
} from '@profeplan/types';
import type { SupabaseSystemContext } from '../context/supabase-system-context.ts';
import {
  invalidPersistenceResponse,
  toPersistenceError,
  type KnowledgeFactoryPersistenceError,
} from '../errors/persistence-error.ts';
import {
  NOOP_PERSISTENCE_LOGGER,
  recordPersistenceLog,
  type PersistenceLogger,
} from '../observability/persistence-logger.ts';
import {
  COMPONENT_CURRICULUM_LINK_COLUMNS,
  COMPONENT_SOURCE_EVIDENCE_ID_COLUMNS,
  EVIDENCE_ORIGIN_COLUMNS,
  PEDAGOGICAL_COMPONENT_COLUMNS,
  PEDAGOGICAL_COMPONENT_VERSION_COLUMNS,
  componentCurriculumLinkRowsToIds,
  componentSourceEvidenceRowsToIds,
  evidenceOriginRowToEvidenceOrigin,
  pedagogicalComponentRowToPedagogicalComponent,
  pedagogicalComponentVersionRowToPedagogicalComponentVersion,
} from './pedagogical-component.mapper.ts';

const ADAPTER_NAME = 'SupabasePedagogicalComponentReadRepository';
const COMPONENT_TABLE = 'kf_pedagogical_components';
const COMPONENT_VERSION_TABLE = 'kf_component_versions';
const COMPONENT_EVIDENCE_TABLE = 'kf_component_source_evidence';
const COMPONENT_CURRICULUM_LINK_TABLE = 'kf_component_curriculum_links';

interface ProviderResponse {
  readonly data: unknown;
  readonly error: unknown;
}

function parseProviderResponse(value: unknown, operation: string): ProviderResponse {
  if (typeof value !== 'object' || value === null || !('data' in value) || !('error' in value)) {
    throw invalidPersistenceResponse(operation);
  }
  return { data: value.data, error: value.error };
}

function isMultipleRowsResponse(error: unknown): boolean {
  return (
    typeof error === 'object' && error !== null && 'code' in error && error.code === 'PGRST116'
  );
}

function throwProviderError(error: unknown, operation: string): never {
  if (isMultipleRowsResponse(error)) {
    throw invalidPersistenceResponse(operation);
  }
  throw toPersistenceError(error, operation);
}

function recordSuccess(
  logger: PersistenceLogger,
  context: SupabaseSystemContext,
  operation: string,
  startedAt: number,
  aggregateType: string,
  aggregateId: EntityId,
  rowCount: number
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'success',
    aggregateType,
    aggregateId,
    correlationId: context.correlationId,
    rowCount,
  });
}

function recordFailure(
  logger: PersistenceLogger,
  context: SupabaseSystemContext,
  operation: string,
  startedAt: number,
  aggregateType: string,
  aggregateId: EntityId,
  error: KnowledgeFactoryPersistenceError
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'failure',
    aggregateType,
    aggregateId,
    correlationId: context.correlationId,
    errorCode: error.code,
  });
}

async function hydrateComponentVersion(
  context: SupabaseSystemContext,
  row: unknown,
  operation: string
): Promise<PedagogicalComponentVersion> {
  const versionWithoutLinks = pedagogicalComponentVersionRowToPedagogicalComponentVersion(
    row,
    [],
    [],
    operation
  );

  const rawEvidenceResponse: unknown = await context.client
    .from(COMPONENT_EVIDENCE_TABLE)
    .select(COMPONENT_SOURCE_EVIDENCE_ID_COLUMNS)
    .eq('component_version_id', versionWithoutLinks.id)
    .order('id', { ascending: true });
  const evidenceResponse = parseProviderResponse(rawEvidenceResponse, operation);
  if (evidenceResponse.error !== null) {
    throwProviderError(evidenceResponse.error, operation);
  }
  const sourceEvidenceIds = componentSourceEvidenceRowsToIds(evidenceResponse.data, operation);

  const rawCurriculumResponse: unknown = await context.client
    .from(COMPONENT_CURRICULUM_LINK_TABLE)
    .select(COMPONENT_CURRICULUM_LINK_COLUMNS)
    .eq('component_version_id', versionWithoutLinks.id)
    .order('curriculum_node_id', { ascending: true });
  const curriculumResponse = parseProviderResponse(rawCurriculumResponse, operation);
  if (curriculumResponse.error !== null) {
    throwProviderError(curriculumResponse.error, operation);
  }
  const curriculumNodeIds = componentCurriculumLinkRowsToIds(curriculumResponse.data, operation);

  return pedagogicalComponentVersionRowToPedagogicalComponentVersion(
    row,
    sourceEvidenceIds,
    curriculumNodeIds,
    operation
  );
}

export class SupabasePedagogicalComponentReadRepository implements PedagogicalComponentReadRepository {
  private readonly context: SupabaseSystemContext;
  private readonly logger: PersistenceLogger;

  constructor(context: SupabaseSystemContext, logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER) {
    this.context = context;
    this.logger = logger;
  }

  async findById(id: EntityId): Promise<PedagogicalComponent | null> {
    const operation = 'component.findById';
    const startedAt = Date.now();

    try {
      const rawResponse: unknown = await this.context.client
        .from(COMPONENT_TABLE)
        .select(PEDAGOGICAL_COMPONENT_COLUMNS)
        .eq('id', id)
        .maybeSingle();
      const response = parseProviderResponse(rawResponse, operation);
      if (response.error !== null) {
        throwProviderError(response.error, operation);
      }

      const component =
        response.data === null
          ? null
          : pedagogicalComponentRowToPedagogicalComponent(response.data, operation);
      recordSuccess(
        this.logger,
        this.context,
        operation,
        startedAt,
        'component',
        id,
        component ? 1 : 0
      );
      return component;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(
        this.logger,
        this.context,
        operation,
        startedAt,
        'component',
        id,
        persistenceError
      );
      throw persistenceError;
    }
  }

  async findVersion(
    componentId: EntityId,
    version: VersionTag
  ): Promise<PedagogicalComponentVersion | null> {
    const operation = 'component.findVersion';
    const startedAt = Date.now();

    try {
      const rawResponse: unknown = await this.context.client
        .from(COMPONENT_VERSION_TABLE)
        .select(PEDAGOGICAL_COMPONENT_VERSION_COLUMNS)
        .eq('component_id', componentId)
        .eq('version', version)
        .maybeSingle();
      const response = parseProviderResponse(rawResponse, operation);
      if (response.error !== null) {
        throwProviderError(response.error, operation);
      }

      const componentVersion =
        response.data === null
          ? null
          : await hydrateComponentVersion(this.context, response.data, operation);
      recordSuccess(
        this.logger,
        this.context,
        operation,
        startedAt,
        'component',
        componentId,
        componentVersion ? 1 : 0
      );
      return componentVersion;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(
        this.logger,
        this.context,
        operation,
        startedAt,
        'component',
        componentId,
        persistenceError
      );
      throw persistenceError;
    }
  }

  async listEvidenceOrigins(componentVersionId: EntityId): Promise<readonly EvidenceOrigin[]> {
    const operation = 'component.listEvidenceOrigins';
    const startedAt = Date.now();

    try {
      const rawResponse: unknown = await this.context.client
        .from(COMPONENT_EVIDENCE_TABLE)
        .select(EVIDENCE_ORIGIN_COLUMNS)
        .eq('component_version_id', componentVersionId)
        .order('recorded_at', { ascending: true })
        .order('id', { ascending: true });
      const response = parseProviderResponse(rawResponse, operation);
      if (response.error !== null) {
        throwProviderError(response.error, operation);
      }
      if (!Array.isArray(response.data)) {
        throw invalidPersistenceResponse(operation);
      }

      const evidenceOrigins = response.data.map((row) =>
        evidenceOriginRowToEvidenceOrigin(row, operation)
      );
      recordSuccess(
        this.logger,
        this.context,
        operation,
        startedAt,
        'component_version',
        componentVersionId,
        evidenceOrigins.length
      );
      return evidenceOrigins;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(
        this.logger,
        this.context,
        operation,
        startedAt,
        'component_version',
        componentVersionId,
        persistenceError
      );
      throw persistenceError;
    }
  }
}
