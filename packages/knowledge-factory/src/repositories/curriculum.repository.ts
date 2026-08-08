import type {
  CurriculumNode,
  CurriculumPackage,
  CurriculumState,
  EducationStage,
  EntityId,
} from '@profeplan/types';

export interface CurriculumRepository {
  findPackageById(id: EntityId): Promise<CurriculumPackage | null>;
  findActivePackageByStateAndStage(
    state: CurriculumState,
    stage: EducationStage
  ): Promise<CurriculumPackage | null>;
  findNodeById(id: EntityId): Promise<CurriculumNode | null>;
  listNodesByPackage(packageId: EntityId): Promise<readonly CurriculumNode[]>;
}
