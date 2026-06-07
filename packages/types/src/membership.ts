export enum MembershipRole {
  OWNER = 'OWNER',
  ADMIN = 'ADMIN',
  COORDINATOR = 'COORDINATOR',
  TEACHER = 'TEACHER',
  SUPPORT = 'SUPPORT',
}

export interface Membership {
  id: string;
  userId: string;
  organizationId: string;
  role: MembershipRole;
  createdAt: string;
}
