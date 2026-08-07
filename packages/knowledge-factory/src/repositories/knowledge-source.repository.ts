import type {
  EntityId,
  KnowledgeSource,
  SourcePermissionEvent,
  SourceVersion,
  VersionTag,
} from '@profeplan/types';

export interface KnowledgeSourceRepository {
  findById(id: EntityId): Promise<KnowledgeSource | null>;
  findVersion(sourceId: EntityId, version: VersionTag): Promise<SourceVersion | null>;
  listPermissionEvents(sourceId: EntityId): Promise<readonly SourcePermissionEvent[]>;
  save(source: KnowledgeSource): Promise<void>;
}
