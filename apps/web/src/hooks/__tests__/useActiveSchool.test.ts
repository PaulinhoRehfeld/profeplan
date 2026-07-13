import { describe, expect, it, vi, beforeEach } from 'vitest';
import { renderHook, waitFor } from '@testing-library/react';

// Regressão do achado #13 (auditoria 2026-07-10): activeSchool é estado React
// em memória que sobrevive à navegação SPA (RootLayout não é remontado); sem
// resetar no logout/troca de usuário, um novo login herdava a escola ativa do
// usuário anterior na mesma aba.

const rpcMock = vi.fn().mockResolvedValue({ data: null, error: null });

vi.mock('../../services/supabaseClient', () => ({
  supabase: {
    from: vi.fn(() => ({
      select: vi.fn().mockReturnThis(),
      eq: vi.fn().mockReturnThis(),
      is: vi.fn().mockReturnThis(),
      order: vi.fn().mockResolvedValue({ data: [], error: null }),
    })),
    auth: {
      getUser: vi.fn().mockResolvedValue({ data: { user: { id: 'user-a' } }, error: null }),
      getSession: vi.fn().mockResolvedValue({ data: { session: null }, error: null }),
    },
    rpc: (...args: unknown[]) => rpcMock(...args),
  },
}));

import { useActiveSchool } from '../useActiveSchool';

const STORAGE_KEY = 'profeplan_active_school';

const seedStorage = (userId: string) => {
  localStorage.setItem(
    STORAGE_KEY,
    JSON.stringify({ userId, school: { id: 'school-1', name: 'Escola A', inep_code: '123' } }),
  );
};

describe('useActiveSchool (regressão #13)', () => {
  beforeEach(() => {
    localStorage.clear();
    rpcMock.mockClear();
  });

  it('carrega a escola ativa salva quando o userId bate com o armazenado', async () => {
    seedStorage('user-a');
    const { result } = renderHook(() => useActiveSchool('user-a'));

    await waitFor(() => expect(result.current.loading).toBe(false));
    expect(result.current.activeSchool?.id).toBe('school-1');
  });

  it('reseta activeSchool quando um USUÁRIO DIFERENTE loga na mesma aba (sem reload)', async () => {
    seedStorage('user-a');
    const { result, rerender } = renderHook(({ userId }) => useActiveSchool(userId), {
      initialProps: { userId: 'user-a' as string | undefined },
    });

    await waitFor(() => expect(result.current.activeSchool?.id).toBe('school-1'));

    // Troca de usuário na mesma aba, sem reload de página (ex: VerifyEmailRoute.handleLogout)
    rerender({ userId: 'user-b' });

    await waitFor(() => expect(result.current.activeSchool).toBeNull());
  });

  it('reseta activeSchool no logout (userId vira undefined)', async () => {
    seedStorage('user-a');
    const { result, rerender } = renderHook(({ userId }) => useActiveSchool(userId), {
      initialProps: { userId: 'user-a' as string | undefined },
    });

    await waitFor(() => expect(result.current.activeSchool?.id).toBe('school-1'));

    rerender({ userId: undefined });

    await waitFor(() => expect(result.current.activeSchool).toBeNull());
  });

  it('regressão — setActiveSchool persiste active_school_id no banco (não só localStorage)', async () => {
    // Antes desta correção, escolher uma escola na tela /select-school só gravava
    // em localStorage/estado React — profiles.active_school_id nunca era
    // atualizado, e ClassManager continuava vendo "school: null" para sempre.
    const { result } = renderHook(() => useActiveSchool('user-a'));
    await waitFor(() => expect(result.current.loading).toBe(false));

    const school = { id: 'school-42', name: 'Escola Nova', inep_code: '999' };
    result.current.setActiveSchool(school);

    await waitFor(() => {
      expect(rpcMock).toHaveBeenCalledWith('set_my_active_school', { p_school_id: 'school-42' });
    });
  });
});
