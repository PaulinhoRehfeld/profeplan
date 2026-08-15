import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const mocks = vi.hoisted(() => ({
  rpc: vi.fn(),
  from: vi.fn(),
  getUser: vi.fn(),
  getSession: vi.fn(),
}));

vi.mock('../supabaseClient', () => ({
  supabase: {
    rpc: mocks.rpc,
    from: mocks.from,
    auth: {
      getUser: mocks.getUser,
      getSession: mocks.getSession,
    },
  },
}));

import { checkAndRewardReferrer, registerPhone } from '../referrals/referrals';

describe('referrals - governed positive producer gate', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    vi.stubEnv('VITE_GOVERNED_CREDIT_PRODUCERS', 'false');
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('usa exclusivamente a RPC governada para telefone quando a flag está ativa', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_PRODUCERS', 'true');
    mocks.rpc.mockResolvedValue({
      data: { success: true, result: 'registered', credited: true },
      error: null,
    });

    const result = await registerPhone('ghost-id', '31999999999');

    expect(result.success).toBe(true);
    expect(mocks.rpc).toHaveBeenCalledWith('credit_register_my_phone_bonus', {
      p_phone: '31999999999',
    });
    expect(mocks.from).not.toHaveBeenCalled();
  });

  it('falha fechado se a RPC governada de telefone falhar', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_PRODUCERS', 'true');
    mocks.rpc.mockResolvedValue({ data: null, error: { message: 'rpc missing' } });

    const result = await registerPhone('user-1', '31999999999');

    expect(result.success).toBe(false);
    expect(result.message).toBe('rpc missing');
    expect(mocks.from).not.toHaveBeenCalled();
  });

  it('claim governado ignora email fornecido pelo cliente e usa RPC sem argumentos', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_PRODUCERS', 'true');
    mocks.rpc.mockResolvedValue({
      data: { result: 'completed', credited: true },
      error: null,
    });

    await checkAndRewardReferrer('spoofed@example.invalid');

    expect(mocks.rpc).toHaveBeenCalledWith('credit_claim_my_referral_bonus');
    expect(mocks.from).not.toHaveBeenCalled();
  });
});
