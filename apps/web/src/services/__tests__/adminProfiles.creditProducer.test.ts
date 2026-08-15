import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const mocks = vi.hoisted(() => ({
  rpc: vi.fn(),
  from: vi.fn(),
  getUser: vi.fn(),
}));

vi.mock('../supabaseClient', () => ({
  supabase: {
    rpc: mocks.rpc,
    from: mocks.from,
    auth: { getUser: mocks.getUser },
  },
}));

import { addUserCredits, updateUserProfileAdmin } from '../admin/adminProfiles';

describe('adminProfiles - governed positive producer gate', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    vi.stubEnv('VITE_GOVERNED_CREDIT_PRODUCERS', 'false');
    mocks.rpc.mockResolvedValue({ data: { success: true }, error: null });
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('preserva a RPC legada de dois argumentos com a flag desligada', async () => {
    const result = await addUserCredits('user-1', 10, 'ignored-operation-id');

    expect(result.error).toBeNull();
    expect(mocks.rpc).toHaveBeenCalledWith('admin_add_credits', {
      p_target_id: 'user-1',
      p_amount: 10,
    });
  });

  it('exige operation id e chama o overload governado com a flag ligada', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_PRODUCERS', 'true');

    const missing = await addUserCredits('user-1', 10);
    expect(missing.error?.message).toContain('idempotente');
    expect(mocks.rpc).not.toHaveBeenCalled();

    const result = await addUserCredits('user-1', 10, 'admin-adjustment-ui-v1:abc');
    expect(result.error).toBeNull();
    expect(mocks.rpc).toHaveBeenCalledWith('admin_add_credits', {
      p_target_id: 'user-1',
      p_amount: 10,
      p_operation_id: 'admin-adjustment-ui-v1:abc',
    });
  });

  it('remove p_credits da edição genérica quando produtores governados estão ativos', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_PRODUCERS', 'true');

    await updateUserProfileAdmin('user-1', {
      tier: 'SILVER',
      credits: 999,
      is_unlimited: false,
    });

    expect(mocks.rpc).toHaveBeenCalledWith('admin_update_profile', {
      p_target_id: 'user-1',
      p_tier: 'SILVER',
      p_credits: null,
      p_is_unlimited: false,
      p_role: null,
      p_is_admin: null,
    });
  });
});
