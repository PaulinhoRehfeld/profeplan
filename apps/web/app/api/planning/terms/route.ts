import { prisma } from '@profeplan/db';
import { logger } from '@profeplan/logger';

import { apiCreated, apiOk, readJsonBody, withApiHandler } from '../../_lib/http';
import { requireApiTenantContext } from '../../_lib/tenant';
import { validateCreateTermPlanInput } from '../../_lib/validation';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

const termPlanSelect = {
  id: true,
  organizationId: true,
  ownerId: true,
  title: true,
  year: true,
  term: true,
  status: true,
  createdAt: true,
  updatedAt: true,
};

export const GET = withApiHandler(async (request: Request) => {
  const tenant = await requireApiTenantContext(request);

  const termPlans = await prisma.termPlan.findMany({
    where: {
      organizationId: tenant.organization.id,
    },
    orderBy: [{ year: 'desc' }, { term: 'asc' }, { createdAt: 'desc' }],
    select: termPlanSelect,
  });

  return apiOk({
    termPlans,
  });
});

export const POST = withApiHandler(async (request: Request) => {
  const tenant = await requireApiTenantContext(request);
  const body = await readJsonBody(request);
  const input = validateCreateTermPlanInput(body);

  const termPlan = await prisma.termPlan.create({
    data: {
      title: input.title,
      year: input.year,
      term: input.term,
      ownerId: tenant.user.id,
      organizationId: tenant.organization.id,
    },
    select: termPlanSelect,
  });

  logger.audit('CREATE_PLANNING', tenant.user.email, {
    termPlanId: termPlan.id,
    title: termPlan.title,
    year: termPlan.year,
    term: termPlan.term,
  });

  return apiCreated({
    termPlan,
  });
});
