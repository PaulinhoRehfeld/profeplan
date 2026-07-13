import { describe, expect, it, vi, beforeEach } from 'vitest';

// Regressão: reconcileTeacherByInep usava o teacherId bruto (prop vinda da sessão
// local) em vez do auth.uid() real para o UPDATE de active_school_id — com Ghost
// ID, o UPDATE afetava 0 linhas em silêncio (RLS bloqueia sem erro) e a função
// retornava { success: true } mesmo sem a escola ter sido vinculada de fato.

const getUserMock = vi.fn();
const getSessionMock = vi.fn();
const rpcMock = vi.fn();

vi.mock('../supabaseClient', () => ({
  supabase: {
    auth: {
      getUser: (...args: unknown[]) => getUserMock(...args),
      getSession: (...args: unknown[]) => getSessionMock(...args),
    },
    rpc: (...args: unknown[]) => rpcMock(...args),
    from: (table: string) => {
      const q: any = {};
      const chain = () => q;
      q.select = vi.fn(chain);
      q.eq = vi.fn(chain);
      q.is = vi.fn(chain);
      q.insert = vi.fn(chain);
      q.limit = vi.fn(chain);

      if (table === 'schools') {
        q.maybeSingle = vi.fn().mockResolvedValue({
          data: { id: 'school-real', name: 'Escola Real', inep_code: '31000001' },
          error: null,
        });
      } else if (table === 'teacher_schools') {
        // "Já existe vínculo ativo?" -> não existe
        q.maybeSingle = vi.fn().mockResolvedValue({ data: null, error: null });
        q.single = vi.fn().mockResolvedValue({ data: { id: 'link-1' }, error: null });
      } else if (table === 'profiles') {
        q.single = vi.fn().mockResolvedValue({ data: { active_school_id: null }, error: null });
      }
      return q;
    },
  },
}));

describe('reconcileTeacherByInep (regressão Ghost ID)', () => {
  beforeEach(() => {
    vi.resetModules();
    getUserMock.mockReset();
    getSessionMock.mockReset();
    rpcMock.mockReset();
    rpcMock.mockResolvedValue({ data: {}, error: null });
  });

  it('usa o auth.uid() real (não o teacherId bruto) para resolver o perfil e persistir a escola ativa', async () => {
    getUserMock.mockResolvedValue({ data: { user: { id: 'real-auth-id' } }, error: null });

    const { reconcileTeacherByInep } = await import('../teacherSchoolService');

    const result = await reconcileTeacherByInep('ghost-teacher-id', '31000001');

    expect(result.success).toBe(true);
    expect(rpcMock).toHaveBeenCalledWith('set_my_active_school', { p_school_id: 'school-real' });
  });

  it('propaga o erro (não engole em silêncio) quando set_my_active_school falha', async () => {
    getUserMock.mockResolvedValue({ data: { user: { id: 'real-auth-id' } }, error: null });
    rpcMock.mockResolvedValue({ data: null, error: { message: 'RLS violation' } });

    const { reconcileTeacherByInep } = await import('../teacherSchoolService');

    const result = await reconcileTeacherByInep('ghost-teacher-id', '31000001');

    expect(result.success).toBe(false);
    expect(result.error).toContain('RLS violation');
  });
});
