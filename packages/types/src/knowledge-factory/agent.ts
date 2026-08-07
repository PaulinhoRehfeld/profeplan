import type {
  CurriculumState,
  EducationStage,
  EntityId,
  SchoolGrade,
  VersionedEntity,
} from './common.ts';

export const AGENT_SCOPE_MODES = ['primary', 'support', 'comparative'] as const;
export type AgentScopeMode = (typeof AGENT_SCOPE_MODES)[number];

export const AGENT_TOOL_PERMISSIONS = [
  'curriculum_lookup',
  'knowledge_retrieval',
  'context_assembly',
  'quality_validation',
] as const;
export type AgentToolPermission = (typeof AGENT_TOOL_PERMISSIONS)[number];

export interface AgentScope extends VersionedEntity {
  schoolComponent: string;
  stage: EducationStage;
  grades: readonly SchoolGrade[];
  curriculumStates: readonly CurriculumState[];
  mode: AgentScopeMode;
}

export interface AgentProfile extends VersionedEntity {
  name: string;
  description: string;
  scopeId: EntityId;
  activeCurriculumPackageId: EntityId;
  allowedTools: readonly AgentToolPermission[];
  blockedDomains: readonly string[];
  active: boolean;
}

export function isAgentAuthorizedForState(scope: AgentScope, state: CurriculumState): boolean {
  return scope.curriculumStates.includes(state);
}
