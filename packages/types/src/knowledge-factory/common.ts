export type EntityId = string;
export type ISODateTime = string;
export type VersionTag = string;

export interface VersionedEntity {
  id: EntityId;
  version: VersionTag;
}

export const EDUCATION_STAGES = ['fundamental_ii', 'ensino_medio'] as const;
export type EducationStage = (typeof EDUCATION_STAGES)[number];

export const SCHOOL_GRADES = ['6', '7', '8', '9', '1_em', '2_em', '3_em'] as const;
export type SchoolGrade = (typeof SCHOOL_GRADES)[number];

export const CURRICULUM_STATES = ['MG', 'RS'] as const;
export type CurriculumState = (typeof CURRICULUM_STATES)[number];

export const KNOWLEDGE_FACTORY_CONTRACT_VERSION = '2.0.0' as const;
export const MVP_CURRICULUM_STATE: CurriculumState = 'MG';
export const EPIC_018_ENABLED = false as const;

export function hasIdentityAndVersion(value: Partial<VersionedEntity>): value is VersionedEntity {
  return Boolean(value.id?.trim() && value.version?.trim());
}

export function isMvpCurriculumState(state: CurriculumState): boolean {
  return state === MVP_CURRICULUM_STATE;
}
