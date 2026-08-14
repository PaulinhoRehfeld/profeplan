import type { CurriculumRepository } from '@profeplan/knowledge-factory';
import type {
  CurriculumNode,
  CurriculumPackage,
  CurriculumState,
  EducationStage,
  EntityId,
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
  CURRICULUM_NODE_COLUMNS,
  CURRICULUM_PACKAGE_COLUMNS,
  CURRICULUM_PACKAGE_SOURCE_COLUMNS,
  curriculumNodeRowToCurriculumNode,
  curriculumPackageRowToCurriculumPackage,
  curriculumPackageSourceRowsToIds,
} from './curriculum.mapper.ts';

const ADAPTER_NAME = 'SupabaseCurriculumRepository';
const CURRICULUM_PACKAGE_TABLE = 'kf_curriculum_packages';
const CURRICULUM_PACKAGE_SOURCE_TABLE = 'kf_curriculum_package_sources';
const CURRICULUM_NODE_TABLE = 'kf_curriculum_nodes';

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

function recordSuccess(
  logger: PersistenceLogger,
  context: SupabaseSystemContext,
  operation: string,
  startedAt: number,
  aggregateType: string,
  aggregateId: EntityId | undefined,
  rowCount: number
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'success',
    aggregateType,
    ...(aggregateId === undefined ? {} : { aggregateId }),
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
  aggregateId: EntityId | undefined,
  error: KnowledgeFactoryPersistenceError
): void {
  recordPersistenceLog(logger, {
    operation,
    adapter: ADAPTER_NAME,
    durationMs: Math.max(0, Date.now() - startedAt),
    outcome: 'failure',
    aggregateType,
    ...(aggregateId === undefined ? {} : { aggregateId }),
    correlationId: context.correlationId,
    errorCode: error.code,
  });
}

async function hydrateCurriculumPackage(
  context: SupabaseSystemContext,
  row: unknown,
  operation: string
): Promise<CurriculumPackage> {
  const packageWithoutSources = curriculumPackageRowToCurriculumPackage(row, [], operation);
  const rawResponse: unknown = await context.client
    .from(CURRICULUM_PACKAGE_SOURCE_TABLE)
    .select(CURRICULUM_PACKAGE_SOURCE_COLUMNS)
    .eq('curriculum_package_id', packageWithoutSources.id)
    .order('source_version_id', { ascending: true });
  const response = parseProviderResponse(rawResponse, operation);

  if (response.error !== null) {
    throw toPersistenceError(response.error, operation);
  }

  return {
    ...packageWithoutSources,
    sourceVersionIds: curriculumPackageSourceRowsToIds(response.data, operation),
  };
}

export class SupabaseCurriculumRepository implements CurriculumRepository {
  private readonly context: SupabaseSystemContext;
  private readonly logger: PersistenceLogger;

  constructor(context: SupabaseSystemContext, logger: PersistenceLogger = NOOP_PERSISTENCE_LOGGER) {
    this.context = context;
    this.logger = logger;
  }

  async findPackageById(id: EntityId): Promise<CurriculumPackage | null> {
    const operation = 'curriculum.findPackageById';
    const startedAt = Date.now();

    try {
      const rawResponse: unknown = await this.context.client
        .from(CURRICULUM_PACKAGE_TABLE)
        .select(CURRICULUM_PACKAGE_COLUMNS)
        .eq('id', id)
        .maybeSingle();
      const response = parseProviderResponse(rawResponse, operation);

      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      const curriculumPackage =
        response.data === null
          ? null
          : await hydrateCurriculumPackage(this.context, response.data, operation);
      recordSuccess(
        this.logger,
        this.context,
        operation,
        startedAt,
        'curriculum_package',
        id,
        curriculumPackage === null ? 0 : 1
      );
      return curriculumPackage;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(
        this.logger,
        this.context,
        operation,
        startedAt,
        'curriculum_package',
        id,
        persistenceError
      );
      throw persistenceError;
    }
  }

  async findActivePackageByStateAndStage(
    state: CurriculumState,
    stage: EducationStage
  ): Promise<CurriculumPackage | null> {
    const operation = 'curriculum.findActivePackageByStateAndStage';
    const startedAt = Date.now();

    try {
      const rawResponse: unknown = await this.context.client
        .from(CURRICULUM_PACKAGE_TABLE)
        .select(CURRICULUM_PACKAGE_COLUMNS)
        .eq('state', state)
        .eq('stage', stage)
        .eq('status', 'active')
        .maybeSingle();
      const response = parseProviderResponse(rawResponse, operation);

      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      const curriculumPackage =
        response.data === null
          ? null
          : await hydrateCurriculumPackage(this.context, response.data, operation);
      recordSuccess(
        this.logger,
        this.context,
        operation,
        startedAt,
        'curriculum_package',
        curriculumPackage?.id,
        curriculumPackage === null ? 0 : 1
      );
      return curriculumPackage;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(
        this.logger,
        this.context,
        operation,
        startedAt,
        'curriculum_package',
        undefined,
        persistenceError
      );
      throw persistenceError;
    }
  }

  async findNodeById(id: EntityId): Promise<CurriculumNode | null> {
    const operation = 'curriculum.findNodeById';
    const startedAt = Date.now();

    try {
      const rawResponse: unknown = await this.context.client
        .from(CURRICULUM_NODE_TABLE)
        .select(CURRICULUM_NODE_COLUMNS)
        .eq('id', id)
        .maybeSingle();
      const response = parseProviderResponse(rawResponse, operation);

      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      const node =
        response.data === null ? null : curriculumNodeRowToCurriculumNode(response.data, operation);
      recordSuccess(
        this.logger,
        this.context,
        operation,
        startedAt,
        'curriculum_node',
        id,
        node === null ? 0 : 1
      );
      return node;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(
        this.logger,
        this.context,
        operation,
        startedAt,
        'curriculum_node',
        id,
        persistenceError
      );
      throw persistenceError;
    }
  }

  async listNodesByPackage(packageId: EntityId): Promise<readonly CurriculumNode[]> {
    const operation = 'curriculum.listNodesByPackage';
    const startedAt = Date.now();

    try {
      const rawResponse: unknown = await this.context.client
        .from(CURRICULUM_NODE_TABLE)
        .select(CURRICULUM_NODE_COLUMNS)
        .eq('curriculum_package_id', packageId)
        .order('code', { ascending: true })
        .order('version', { ascending: true })
        .order('id', { ascending: true });
      const response = parseProviderResponse(rawResponse, operation);

      if (response.error !== null) {
        throw toPersistenceError(response.error, operation);
      }
      if (!Array.isArray(response.data)) {
        throw invalidPersistenceResponse(operation);
      }

      const nodes = response.data.map((row) => curriculumNodeRowToCurriculumNode(row, operation));
      recordSuccess(
        this.logger,
        this.context,
        operation,
        startedAt,
        'curriculum_package',
        packageId,
        nodes.length
      );
      return nodes;
    } catch (error) {
      const persistenceError = toPersistenceError(error, operation);
      recordFailure(
        this.logger,
        this.context,
        operation,
        startedAt,
        'curriculum_package',
        packageId,
        persistenceError
      );
      throw persistenceError;
    }
  }
}
