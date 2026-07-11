import { beforeEach, describe, expect, it, vi } from 'vitest';

vi.mock('../../supabaseClient', () => ({
  supabase: {
    from: vi.fn(),
    auth: {
      getUser: vi.fn(),
      getSession: vi.fn(),
    },
  },
}));

import { supabase } from '../../supabaseClient';
import { registerPhone } from '../referrals';

const mocked = supabase as unknown as {
  from: ReturnType<typeof vi.fn>;
  auth: { getUser: ReturnType<typeof vi.fn>; getSession: ReturnType<typeof vi.fn> };
};

const createQuery = (result: { data: unknown; error: unknown }) => {
  const q: any = {};
  for (const m of ['select', 'update', 'is']) {
    q[m] = vi.fn(() => q);
  }
  q.eq = vi.fn(() => q);
  q.maybeSingle = vi.fn(() => Promise.resolve(result));
  return q;
};

describe('registerPhone (Ghost ID regressão)', () => {
  beforeEach(() => {
    mocked.from.mockReset();
    mocked.auth.getUser.mockReset();
    mocked.auth.getSession.mockReset();
  });

  it('usa o auth.uid() real (não o userId bruto) no SELECT e no UPDATE', async () => {
    mocked.auth.getUser.mockResolvedValue({ data: { user: { id: 'real-auth-id' } } });

    const selectQuery = createQuery({ data: { phone: null, credits: 5 }, error: null });
    const updateQuery = createQuery({ data: null, error: null });
    mocked.from.mockReturnValueOnce(selectQuery).mockReturnValueOnce(updateQuery);

    const result = await registerPhone('ghost-user-id', '31999999999');

    expect(result.success).toBe(true);
    expect(selectQuery.eq).toHaveBeenCalledWith('id', 'real-auth-id');
    expect(selectQuery.eq).not.toHaveBeenCalledWith('id', 'ghost-user-id');
    expect(updateQuery.eq).toHaveBeenCalledWith('id', 'real-auth-id');
  });

  it('sem sessão resolvível, cai de volta pro userId recebido (não quebra)', async () => {
    mocked.auth.getUser.mockRejectedValue(new Error('no session'));
    mocked.auth.getSession.mockRejectedValue(new Error('no session'));

    const selectQuery = createQuery({ data: { phone: null, credits: 0 }, error: null });
    const updateQuery = createQuery({ data: null, error: null });
    mocked.from.mockReturnValueOnce(selectQuery).mockReturnValueOnce(updateQuery);

    const result = await registerPhone('fallback-id', '31999999999');

    expect(result.success).toBe(true);
    expect(selectQuery.eq).toHaveBeenCalledWith('id', 'fallback-id');
  });
});
