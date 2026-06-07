import { requireAuth } from './session';

export type TenantContext = {
  authUserId: string;
  user: Awaited<ReturnType<typeof findUserWithMembership>>;
  membership: NonNullable<
    Awaited<ReturnType<typeof findUserWithMembership>>
  >['memberships'][number];
  organization: NonNullable<
    Awaited<ReturnType<typeof findUserWithMembership>>
  >['memberships'][number]['organization'];
};

async function findUserWithMembership(email: string) {
  const { prisma } = await import('@profeplan/db');

  return prisma.user.findUnique({
    where: { email },
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
}

export async function getTenantContext() {
  const authUser = await requireAuth();

  if (!authUser.email) {
    return null;
  }

  const user = await findUserWithMembership(authUser.email);
  const membership = user?.memberships[0];

  if (!user || !membership) {
    return null;
  }

  return {
    authUserId: authUser.id,
    user,
    membership,
    organization: membership.organization,
  };
}

export async function requireTenantContext() {
  const tenant = await getTenantContext();

  if (!tenant) {
    throw new Error('Authenticated user has no membership tenant context.');
  }

  return tenant;
}
