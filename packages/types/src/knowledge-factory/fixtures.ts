import type { AgentProfile, AgentScope } from './agent.ts';
import type { CurriculumLink, CurriculumNode, CurriculumPackage } from './curriculum.ts';
import type { DeliveryContract } from './delivery.ts';
import type { PedagogicalProductionOrder } from './opp.ts';
import type {
  EvidenceOrigin,
  PedagogicalComponent,
  PedagogicalComponentVersion,
} from './pedagogical.ts';
import type { ContextPackage, QueryPlan, SufficiencyResult } from './retrieval.ts';
import type { KnowledgeSource, SourceSegment, SourceVersion } from './source.ts';
import type { ValidationFinding } from './validation.ts';

const createdAt = '2026-08-06T12:00:00.000Z';

export const syntheticSource: KnowledgeSource = {
  id: 'src_synthetic_philosophy',
  version: '1.0.0',
  title: 'Fonte sintética sobre liberdade e responsabilidade',
  sourceType: 'wrtech_owned',
  status: 'approved',
  licenseCategory: 'owned',
  allowedUses: ['retrieval', 'generation', 'internal_review'],
  provenanceUri: 'synthetic://knowledge-factory/source/1',
  createdAt,
  updatedAt: createdAt,
};

export const syntheticSourceVersion: SourceVersion = {
  id: 'srcv_synthetic_philosophy_1',
  version: '1.0.0',
  sourceId: syntheticSource.id,
  checksum: 'sha256:synthetic-source-version-1',
  effectiveAt: createdAt,
};

export const syntheticSegment: SourceSegment = {
  id: 'seg_synthetic_philosophy_1',
  version: '1.0.0',
  sourceVersionId: syntheticSourceVersion.id,
  locator: 'synthetic-section-1',
  contentDigest: 'sha256:synthetic-segment-1',
  extractedText: 'Conteúdo inteiramente sintético para validar contratos.',
  createdAt,
};

export const syntheticCurriculumPackage: CurriculumPackage = {
  id: 'cur_mg_philosophy_em',
  version: '1.0.0',
  state: 'MG',
  stage: 'ensino_medio',
  status: 'active',
  title: 'Pacote curricular sintético MG — Filosofia',
  effectiveFrom: createdAt,
  sourceVersionIds: [syntheticSourceVersion.id],
};

export const syntheticCurriculumNode: CurriculumNode = {
  id: 'curnode_filosofia_liberdade',
  version: '1.0.0',
  curriculumPackageId: syntheticCurriculumPackage.id,
  nodeType: 'learning_expectation',
  code: 'SYN-MG-FIL-001',
  title: 'Analisar liberdade e responsabilidade',
  description: 'Expectativa sintética para testes do contrato curricular.',
  component: 'Filosofia',
  grades: ['2_em'],
};

export const syntheticCurriculumLink: CurriculumLink = {
  id: 'curlink_filosofia_liberdade',
  version: '1.0.0',
  curriculumPackageId: syntheticCurriculumPackage.id,
  fromNodeId: syntheticCurriculumNode.id,
  toNodeId: syntheticCurriculumNode.id,
  relation: 'supports',
};

export const syntheticComponent: PedagogicalComponent = {
  id: 'pc_filosofia_liberdade',
  version: '1.0.0',
  canonicalKey: 'filosofia.liberdade_responsabilidade',
  title: 'Liberdade e responsabilidade',
  componentType: 'concept',
  schoolComponent: 'Filosofia',
  grades: ['2_em'],
  status: 'approved',
  currentVersionId: 'pcv_filosofia_liberdade_1',
  createdAt,
  updatedAt: createdAt,
};

export const syntheticComponentVersion: PedagogicalComponentVersion = {
  id: 'pcv_filosofia_liberdade_1',
  version: '1.0.0',
  componentId: syntheticComponent.id,
  summary: 'Síntese autoral e sintética sobre escolhas e consequências.',
  keywords: ['liberdade', 'responsabilidade', 'escolha'],
  sourceEvidenceIds: ['ev_filosofia_liberdade_1'],
  curriculumNodeIds: [syntheticCurriculumNode.id],
  status: 'approved',
  approvedAt: createdAt,
};

export const syntheticEvidence: EvidenceOrigin = {
  id: 'ev_filosofia_liberdade_1',
  version: '1.0.0',
  componentVersionId: syntheticComponentVersion.id,
  sourceId: syntheticSource.id,
  sourceVersionId: syntheticSourceVersion.id,
  sourceSegmentId: syntheticSegment.id,
  contribution: 'conceptual',
  recordedAt: createdAt,
};

export const syntheticAgentScope: AgentScope = {
  id: 'scope_socrates_2',
  version: '1.0.0',
  schoolComponent: 'Filosofia',
  stage: 'ensino_medio',
  grades: ['2_em'],
  curriculumStates: ['MG'],
  mode: 'primary',
};

export const syntheticAgentProfile: AgentProfile = {
  id: 'agent_socrates_2',
  version: '1.0.0',
  name: 'Sócrates 2',
  description: 'Perfil sintético de Filosofia do 2º ano do Ensino Médio.',
  scopeId: syntheticAgentScope.id,
  activeCurriculumPackageId: syntheticCurriculumPackage.id,
  allowedTools: ['curriculum_lookup', 'knowledge_retrieval', 'context_assembly'],
  blockedDomains: ['rio_grande_do_sul', 'new_agents'],
  active: false,
};

export const syntheticOpp: PedagogicalProductionOrder = {
  id: 'opp_synthetic_1',
  version: '1.0.0',
  requesterId: 'teacher_synthetic_1',
  agentProfileId: syntheticAgentProfile.id,
  curriculumPackageId: syntheticCurriculumPackage.id,
  productType: 'lesson_plan',
  theme: 'Liberdade e responsabilidade',
  durationMinutes: 50,
  status: 'requested',
  createdAt,
  updatedAt: createdAt,
};

export const syntheticQueryPlan: QueryPlan = {
  id: 'query_synthetic_1',
  version: '1.0.0',
  query: 'liberdade responsabilidade escolhas consequências',
  filters: {
    schoolComponent: 'Filosofia',
    stage: 'ensino_medio',
    grade: '2_em',
    curriculumState: 'MG',
    curriculumPackageId: syntheticCurriculumPackage.id,
    sourceStatus: 'approved',
    sourceUse: 'retrieval',
    componentStatus: 'approved',
  },
  maxCandidates: 20,
  maxContextItems: 8,
};

export const syntheticSufficiencyResult: SufficiencyResult = {
  id: 'sufficiency_synthetic_1',
  version: '1.0.0',
  sufficient: true,
  reasons: [],
  evidenceCount: 1,
  componentCount: 1,
};

export const syntheticContextPackage: ContextPackage = {
  id: 'context_synthetic_1',
  version: '1.0.0',
  queryPlanId: syntheticQueryPlan.id,
  sufficiencyResultId: syntheticSufficiencyResult.id,
  items: [
    {
      componentVersionId: syntheticComponentVersion.id,
      evidenceOriginIds: [syntheticEvidence.id],
      curriculumNodeIds: [syntheticCurriculumNode.id],
      summary: syntheticComponentVersion.summary,
    },
  ],
  sourceVersionIds: [syntheticSourceVersion.id],
  curriculumPackageId: syntheticCurriculumPackage.id,
};

export const syntheticFinding: ValidationFinding = {
  id: 'finding_synthetic_1',
  version: '1.0.0',
  oppId: syntheticOpp.id,
  domain: 'traceability',
  priority: 'should',
  status: 'resolved',
  code: 'SYNTHETIC_TRACE_OK',
  message: 'Finding sintético resolvido para validação de contrato.',
  evidenceIds: [syntheticEvidence.id],
  createdAt,
};

const traceability = {
  oppId: syntheticOpp.id,
  agentProfileId: syntheticAgentProfile.id,
  curriculumPackageId: syntheticCurriculumPackage.id,
  componentVersionIds: [syntheticComponentVersion.id],
  sourceVersionIds: [syntheticSourceVersion.id],
  validationReportId: 'validation_report_synthetic_1',
};

export const syntheticDeliveries: readonly DeliveryContract[] = [
  {
    id: 'delivery_lesson_plan_1',
    version: '1.0.0',
    createdAt,
    traceability,
    payload: {
      productType: 'lesson_plan',
      content: {
        title: 'Aula sintética',
        objectives: ['Analisar uma situação filosófica fictícia.'],
        durationMinutes: 50,
        developmentSteps: ['Problematização', 'Discussão', 'Síntese'],
        assessmentStrategy: 'Registro argumentativo curto.',
      },
    },
  },
  {
    id: 'delivery_didactic_text_1',
    version: '1.0.0',
    createdAt,
    traceability,
    payload: {
      productType: 'didactic_text',
      content: {
        title: 'Texto sintético',
        introduction: 'Introdução inteiramente fictícia.',
        sections: [{ heading: 'Seção', body: 'Corpo sintético.' }],
        reflectionQuestions: ['Qual relação fictícia foi apresentada?'],
      },
    },
  },
  {
    id: 'delivery_reflective_activity_1',
    version: '1.0.0',
    createdAt,
    traceability,
    payload: {
      productType: 'reflective_activity',
      content: {
        title: 'Atividade sintética',
        instructions: ['Leia o cenário fictício.'],
        prompts: ['Justifique uma decisão possível.'],
        expectedEvidence: 'Argumento coerente com o cenário.',
      },
    },
  },
  {
    id: 'delivery_formative_assessment_1',
    version: '1.0.0',
    createdAt,
    traceability,
    payload: {
      productType: 'formative_assessment',
      content: {
        title: 'Avaliação sintética',
        questions: [
          {
            id: 'question_synthetic_1',
            prompt: 'Explique a situação fictícia.',
            responseType: 'open_response',
          },
        ],
        answerGuidance: ['Identificar escolha e consequência no cenário.'],
      },
    },
  },
];
