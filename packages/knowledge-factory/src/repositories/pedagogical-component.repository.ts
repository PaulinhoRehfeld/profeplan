import type {
  EntityId,
  EvidenceOrigin,
  PedagogicalComponent,
  PedagogicalComponentVersion,
  VersionTag,
} from '@profeplan/types';

export interface PedagogicalComponentRepository {
  findById(id: EntityId): Promise<PedagogicalComponent | null>;
  findVersion(
    componentId: EntityId,
    version: VersionTag
  ): Promise<PedagogicalComponentVersion | null>;
  listEvidenceOrigins(componentVersionId: EntityId): Promise<readonly EvidenceOrigin[]>;
  saveComponent(component: PedagogicalComponent): Promise<void>;
  saveVersion(version: PedagogicalComponentVersion): Promise<void>;
}
