import type {
  CurriculumNode,
  CurriculumPackage,
  CurriculumState,
  EntityId,
} from '@profeplan/types';

export interface CurriculumRepository {
  findPackageById(id: EntityId): Promise<CurriculumPackage | null>;
  findActivePackageByState(state: CurriculumState): Promise<CurriculumPackage | null>;
  findNodeById(id: EntityId): Promise<CurriculumNode | null>;
  listNodesByPackage(packageId: EntityId): Promise<readonly CurriculumNode[]>;
}
