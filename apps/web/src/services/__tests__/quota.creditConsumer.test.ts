import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const mocks = vi.hoisted(() => ({
  getUserProfile: vi.fn(),
  from: vi.fn(),
  getSession: vi.fn(),
  getUser: vi.fn(),
}));

vi.mock('../profile/profileRepository', () => ({
  getUserProfile: mocks.getUserProfile,
}));

vi.mock('../supabaseClient', () => ({
  supabase: {
    from: mocks.from,
    auth: {
      getSession: mocks.getSession,
      getUser: mocks.getUser,
    },
  },
}));

import { checkUsageQuota, incrementUserUsage } from '../credits/quota';

describe('credits/quota - governed consumer compatibility', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'false');
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('mantém o bloqueio legado por saldo zero com a flag OFF', async () => {
    mocks.getUserProfile.mockResolvedValue({
      id: 'user-zero',
      tier: 'SILVER',
      credits: 0,
      is_unlimited: false,
    });

    const result = await checkUsageQuota('user-zero');

    expect(result.allowed).toBe(false);
    expect(result.message).toContain('Créditos insuficientes');
  });

  it('não usa profiles.credits como gate de geração com a flag ON', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');

    const result = await checkUsageQuota('user-zero');

    expect(result).toEqual({ allowed: true });
    expect(mocks.getUserProfile).not.toHaveBeenCalled();
    expect(mocks.from).not.toHaveBeenCalled();
  });

  it('não executa read-modify-write legado quando a flag ON', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');

    await incrementUserUsage('user-any', 'chat');
    await incrementUserUsage('user-any', 'document');
    await incrementUserUsage('user-any', 'term_plan');

    expect(mocks.getUserProfile).not.toHaveBeenCalled();
    expect(mocks.from).not.toHaveBeenCalled();
  });
});
