import { prisma } from '@profeplan/db';
import { apiOk, ApiError, withApiHandler } from '../../../_lib/http';
import { requireApiTenantContext } from '../../../_lib/tenant';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

export const GET = withApiHandler(
  async (request: Request, context: { params: Promise<{ id: string }> }) => {
    const { id } = await context.params;
    const tenant = await requireApiTenantContext(request);

    const termPlan = await prisma.termPlan.findFirst({
      where: {
        id,
        organizationId: tenant.organization.id,
      },
    });

    if (!termPlan) {
      throw new ApiError(404, 'NOT_FOUND', 'Planejamento não encontrado ou acesso não autorizado.');
    }

    return apiOk({
      termPlan,
    });
  }
);
