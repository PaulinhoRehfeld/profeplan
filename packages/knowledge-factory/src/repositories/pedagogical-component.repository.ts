import type {
  AppendPedagogicalComponentVersionCommand,
  CreatePedagogicalComponentAggregateCommand,
  EntityId,
  EvidenceOrigin,
  PedagogicalComponent,
  PedagogicalComponentVersion,
  PedagogicalComponentWriteReceipt,
  PromotePedagogicalComponentVersionCommand,
  TransitionPedagogicalComponentVersionStatusCommand,
  VersionTag,
} from '@profeplan/types';

export interface PedagogicalComponentReadRepository {
  findById(id: EntityId): Promise<PedagogicalComponent | null>;
  findVersion(
    componentId: EntityId,
    version: VersionTag
  ): Promise<PedagogicalComponentVersion | null>;
  listEvidenceOrigins(componentVersionId: EntityId): Promise<readonly EvidenceOrigin[]>;
}

export interface PedagogicalComponentCommandRepository {
  createComponentAggregate(
    command: CreatePedagogicalComponentAggregateCommand
  ): Promise<PedagogicalComponentWriteReceipt>;
  appendComponentVersion(
    command: AppendPedagogicalComponentVersionCommand
  ): Promise<PedagogicalComponentWriteReceipt>;
  transitionComponentVersionStatus(
    command: TransitionPedagogicalComponentVersionStatusCommand
  ): Promise<PedagogicalComponentWriteReceipt>;
  promoteComponentVersion(
    command: PromotePedagogicalComponentVersionCommand
  ): Promise<PedagogicalComponentWriteReceipt>;
}

export interface PedagogicalComponentRepository
  extends PedagogicalComponentReadRepository, PedagogicalComponentCommandRepository {}
