import { beforeEach, describe, expect, it, vi } from 'vitest';

const rpcMock = vi.fn();

vi.mock('../supabaseClient', () => ({
  supabase: {
    rpc: (...args: unknown[]) => rpcMock(...args),
  },
}));

import { getMyGovernedCreditBalance } from '../credits/creditBalance';

describe('creditBalance - governed projection', () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it('lê somente a projeção server-side do ledger', async () => {
    rpcMock.mockResolvedValueOnce({
      data: {
        user_id: 'user-1',
        tier: 'SILVER',
        unlimited: false,
        total: 7,
        purchased: 7,
      },
      error: null,
    });

    await expect(getMyGovernedCreditBalance()).resolves.toMatchObject({
      total: 7,
      unlimited: false,
    });
    expect(rpcMock).toHaveBeenCalledWith('credit_get_my_balance');
  });

  it('falha fechado em erro do RPC sem fallback para profiles.credits', async () => {
    rpcMock.mockResolvedValueOnce({ data: null, error: new Error('rpc indisponível') });

    await expect(getMyGovernedCreditBalance()).rejects.toThrow('rpc indisponível');
  });

  it('rejeita shape inválido em vez de fabricar saldo local', async () => {
    rpcMock.mockResolvedValueOnce({ data: { total: 'NaN', unlimited: false }, error: null });

    await expect(getMyGovernedCreditBalance()).rejects.toThrow('Saldo governado inválido');
  });
});
