import { getCurrentUser, getUserFromAccessToken } from '@profeplan/auth/session';
import { prisma } from '@profeplan/db';
import { logger } from '@profeplan/logger';

import { ApiError } from './http';

function getBearerToken(request?: Request) {
  const authorization = request?.headers.get('authorization');

  if (!authorization?.startsWith('Bearer ')) {
    return null;
  }

  return authorization.slice('Bearer '.length).trim();
}

export async function requireApiTenantContext(request?: Request) {
  const bearerToken = getBearerToken(request);
  const authUser = bearerToken ? await getUserFromAccessToken(bearerToken) : await getCurrentUser();

  if (!authUser) {
    throw new ApiError(401, 'UNAUTHENTICATED', 'Authentication is required.');
  }

  if (!authUser.email) {
    throw new ApiError(401, 'AUTH_USER_EMAIL_REQUIRED', 'Authenticated user has no email.');
  }

  const user = await prisma.user.findUnique({
    where: { email: authUser.email },
    include: {
      memberships: {
        include: {
          organization: true,
        },
        orderBy: {
          createdAt: 'asc',
        },
      },
    },
  });

  const membership = user?.memberships[0];

  if (!user || !membership) {
    throw new ApiError(
      403,
      'TENANT_MEMBERSHIP_REQUIRED',
      'Authenticated user has no active organization membership.'
    );
  }

  logger.updateLoggerContext({
    userEmail: user.email,
    organizationId: membership.organization.id,
  });

  return {
    authUserId: authUser.id,
    user,
    membership,
    organization: membership.organization,
  };
}
