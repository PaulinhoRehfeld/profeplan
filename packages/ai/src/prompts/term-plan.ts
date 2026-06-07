import type { TermPlan } from '@profeplan/db';

export type TermPlanPromptInput = Pick<
  TermPlan,
  'id' | 'title' | 'year' | 'term' | 'status' | 'organizationId' | 'ownerId'
>;

export function buildTermPlanEnhancementPrompt(termPlan: TermPlanPromptInput) {
  return [
    {
      role: 'system' as const,
      content:
        'Voce e um assistente pedagogico do PROFEPLAN. Enriqueça planejamentos bimestrais de forma objetiva, util, segura e adequada ao contexto escolar brasileiro. Responda somente no JSON solicitado.',
    },
    {
      role: 'user' as const,
      content: JSON.stringify(
        {
          task: 'Enriquecer um planejamento de periodo letivo.',
          constraints: [
            'Nao inventar dados sensiveis de alunos.',
            'Nao assumir escola, turma ou disciplina nao informadas.',
            'Manter linguagem pratica para professores.',
            'Gerar sugestoes acionaveis e revisaveis.',
          ],
          termPlan: {
            id: termPlan.id,
            title: termPlan.title,
            year: termPlan.year,
            term: termPlan.term,
            status: termPlan.status,
            organizationId: termPlan.organizationId,
            ownerId: termPlan.ownerId,
          },
          outputSchema: {
            summary: 'Resumo enriquecido do planejamento.',
            objectives: ['Objetivos de aprendizagem sugeridos.'],
            suggestedSequence: ['Sequencia didatica sugerida para o periodo.'],
            assessmentIdeas: ['Ideias de avaliacao formativa/somativa.'],
            differentiationStrategies: ['Estrategias de adaptacao e inclusao.'],
            teacherNotes: 'Observacoes praticas para revisao do professor.',
          },
        },
        null,
        2
      ),
    },
  ];
}
