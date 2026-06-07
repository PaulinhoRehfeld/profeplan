import { enhanceTermPlan } from '@profeplan/ai';
import { prisma } from '@profeplan/db';
import { apiOk, ApiError, withApiHandler } from '../../../../_lib/http';
import { requireApiTenantContext } from '../../../../_lib/tenant';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

export const POST = withApiHandler(
  async (request: Request, context: { params: Promise<{ id: string }> }) => {
    const { id } = await context.params;
    const tenant = await requireApiTenantContext(request);

    // Verify ownership/tenant boundary
    const termPlan = await prisma.termPlan.findFirst({
      where: {
        id,
        organizationId: tenant.organization.id,
      },
    });

    if (!termPlan) {
      throw new ApiError(404, 'NOT_FOUND', 'Planejamento não encontrado ou acesso não autorizado.');
    }

    const hasApiKey = !!process.env.OPENAI_API_KEY;
    let result;

    if (hasApiKey) {
      result = await enhanceTermPlan(id);
    } else {
      console.log('⚠️ [AI Router] OPENAI_API_KEY not found. Falling back to local simulation.');

      const mockEnhancedPayload = {
        summary:
          'Resumo enriquecido pelo assistente pedagógico IA do PROFEPLAN V2 (Simulador Local).',
        objectives: [
          'Desenvolver habilidades de leitura e interpretação de textos literários.',
          'Identificar elementos narrativos estruturais e figuras de linguagem.',
        ],
        suggestedSequence: [
          'Semana 1-2: Leitura de crônicas brasileiras clássicas.',
          'Semana 3-4: Oficina prática de escrita criativa e estilística.',
        ],
        assessmentIdeas: [
          'Avaliação formativa baseada na participação nas discussões de crônicas.',
          'Avaliação somativa com a produção e revisão paritária de um texto autoral.',
        ],
        differentiationStrategies: [
          'Disponibilização de audiobooks dos textos recomendados para acessibilidade.',
          'Roteiros de apoio estruturados para alunos que necessitam de suporte extra.',
        ],
        teacherNotes:
          'Recomenda-se reservar os últimos 15 minutos de cada aula para compartilhamento espontâneo de leituras.',
      };

      const mockClient = {
        responses: {
          create: async () => ({
            output_text: JSON.stringify(mockEnhancedPayload),
          }),
        },
      };

      result = await enhanceTermPlan(id, {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        client: mockClient as any,
        model: 'mock-gpt-4o-mini',
      });
    }

    return apiOk(result);
  }
);
